#!/usr/bin/env python3
"""
Bill Sloth Guest Communication Service
Automated guest messaging through VRBO's built-in messaging system
"""

import asyncio
import os
import json
from datetime import datetime, timedelta
from typing import List, Optional, Dict, Any
from enum import Enum

import uvicorn
from fastapi import FastAPI, HTTPException, BackgroundTasks, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
import aiohttp
from loguru import logger
import redis.asyncio as redis
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
from jinja2 import Environment, FileSystemLoader, select_autoescape

# Configure logging
logger.add(
    "/app/logs/guest_communication.log",
    rotation="1 day",
    retention="30 days",
    level="INFO"
)

app = FastAPI(
    title="Bill Sloth Guest Communication Service",
    version="2.0.0",
    description="Automated guest messaging through VRBO platform"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Database connection
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://bill:sloth_secure_2025@localhost:5432/bill_business")
engine = create_async_engine(DATABASE_URL)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# Redis connection for caching and queuing
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")
redis_client = redis.from_url(REDIS_URL)

# VRBO API Configuration
VRBO_CLIENT_ID = os.getenv("VRBO_CLIENT_ID")
VRBO_CLIENT_SECRET = os.getenv("VRBO_CLIENT_SECRET")
VRBO_BASE_URL = "https://api.expediapartnercentral.com"

# Template configuration
template_env = Environment(
    loader=FileSystemLoader('/app/templates'),
    autoescape=select_autoescape(['html', 'xml'])
)

class MessageType(str, Enum):
    WELCOME = "welcome"
    CHECKIN_INSTRUCTIONS = "checkin_instructions"
    CHECKOUT_REMINDER = "checkout_reminder"
    REVIEW_REQUEST = "review_request"
    CUSTOM = "custom"
    HOUSE_RULES = "house_rules"
    LOCAL_RECOMMENDATIONS = "local_recommendations"
    MAINTENANCE_UPDATE = "maintenance_update"

class MessagePriority(str, Enum):
    HIGH = "high"
    NORMAL = "normal"
    LOW = "low"

class GuestMessage(BaseModel):
    booking_id: str
    message_type: MessageType
    subject: str
    body: str
    priority: MessagePriority = MessagePriority.NORMAL
    schedule_time: Optional[datetime] = None
    template_variables: Optional[Dict[str, Any]] = Field(default_factory=dict)

class MessageTemplate(BaseModel):
    name: str
    type: MessageType
    subject: str
    body: str
    variables: List[str] = Field(default_factory=list)
    active: bool = True

class MessageStatus(BaseModel):
    message_id: str
    booking_id: str
    status: str
    sent_at: Optional[datetime]
    error: Optional[str]

@app.on_startup
async def startup_event():
    """Initialize services on startup"""
    logger.info("🚀 Starting Bill Sloth Guest Communication Service")
    
    # Test database connection
    try:
        async with AsyncSessionLocal() as session:
            await session.execute("SELECT 1")
        logger.info("✅ Database connection successful")
    except Exception as e:
        logger.error(f"❌ Database connection failed: {e}")
    
    # Test Redis connection
    try:
        await redis_client.ping()
        logger.info("✅ Redis connection successful")
    except Exception as e:
        logger.error(f"❌ Redis connection failed: {e}")
    
    # Initialize default templates
    await initialize_default_templates()
    
    # Start background tasks
    asyncio.create_task(message_queue_processor())
    asyncio.create_task(scheduled_message_sender())

@app.get("/")
async def root():
    return {
        "message": "Bill Sloth Guest Communication Service",
        "status": "Ready to communicate with guests!",
        "messaging_platform": "VRBO Built-in Messaging"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "service": "guest-communication",
        "version": "2.0.0"
    }

@app.post("/send-message")
async def send_message(message: GuestMessage, background_tasks: BackgroundTasks):
    """Send a message to guest through VRBO messaging"""
    try:
        # Validate booking exists
        booking = await get_booking_details(message.booking_id)
        if not booking:
            raise HTTPException(status_code=404, detail="Booking not found")
        
        # If scheduled, add to queue
        if message.schedule_time and message.schedule_time > datetime.now():
            await schedule_message(message)
            return {"status": "scheduled", "scheduled_time": message.schedule_time}
        
        # Send immediately
        message_id = await queue_message_for_sending(message)
        return {"status": "queued", "message_id": message_id}
        
    except Exception as e:
        logger.error(f"Error sending message: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/templates")
async def get_templates(message_type: Optional[MessageType] = None):
    """Get available message templates"""
    templates = await load_templates(message_type)
    return {"templates": templates}

@app.post("/templates")
async def create_template(template: MessageTemplate):
    """Create a new message template"""
    try:
        template_id = await save_template(template)
        return {"template_id": template_id, "status": "created"}
    except Exception as e:
        logger.error(f"Error creating template: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/message-history/{booking_id}")
async def get_message_history(booking_id: str):
    """Get message history for a booking"""
    try:
        messages = await fetch_message_history(booking_id)
        return {"booking_id": booking_id, "messages": messages}
    except Exception as e:
        logger.error(f"Error fetching message history: {e}")
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/bulk-message")
async def send_bulk_message(
    message_type: MessageType,
    property_ids: List[str],
    date_range: Optional[Dict[str, str]] = None
):
    """Send bulk messages to multiple guests"""
    try:
        # Get relevant bookings
        bookings = await get_bookings_for_bulk_message(property_ids, date_range)
        
        # Queue messages for each booking
        queued_count = 0
        for booking in bookings:
            message = GuestMessage(
                booking_id=booking['booking_id'],
                message_type=message_type,
                subject="",  # Will be filled by template
                body="",     # Will be filled by template
                priority=MessagePriority.NORMAL
            )
            await queue_message_for_sending(message)
            queued_count += 1
        
        return {
            "status": "queued",
            "total_bookings": len(bookings),
            "messages_queued": queued_count
        }
        
    except Exception as e:
        logger.error(f"Error sending bulk messages: {e}")
        raise HTTPException(status_code=500, detail=str(e))

async def initialize_default_templates():
    """Initialize default message templates"""
    default_templates = [
        {
            "name": "welcome_message",
            "type": MessageType.WELCOME,
            "subject": "Welcome to {{property_name}}!",
            "body": """Hi {{guest_name}},

Thank you for booking {{property_name}}! We're excited to host you from {{check_in_date}} to {{check_out_date}}.

Here are a few important details for your stay:
- Check-in time: After 4:00 PM
- Check-out time: Before 11:00 AM
- WiFi password will be provided upon arrival
- Property address: {{property_address}}

If you have any questions before your arrival, please don't hesitate to reach out through this messaging system.

Looking forward to hosting you!

Best regards,
Bill""",
            "variables": ["guest_name", "property_name", "check_in_date", "check_out_date", "property_address"]
        },
        {
            "name": "checkin_instructions",
            "type": MessageType.CHECKIN_INSTRUCTIONS,
            "subject": "Check-in Instructions for {{property_name}}",
            "body": """Hi {{guest_name}},

Your check-in is tomorrow! Here are the details you'll need:

📍 Property Address: {{property_address}}

🚗 Parking: {{parking_instructions}}

🔑 Entry Instructions:
{{entry_instructions}}

📱 WiFi Network: {{wifi_network}}
🔐 WiFi Password: {{wifi_password}}

🏠 House Manual: You'll find a detailed house manual on the kitchen counter with information about appliances, local recommendations, and emergency contacts.

⏰ Check-in time: After 4:00 PM

If you need anything during your stay, please message me through this platform. I typically respond within an hour during business hours.

Safe travels!

Bill""",
            "variables": ["guest_name", "property_name", "property_address", "parking_instructions", 
                         "entry_instructions", "wifi_network", "wifi_password"]
        },
        {
            "name": "checkout_reminder",
            "type": MessageType.CHECKOUT_REMINDER,
            "subject": "Checkout Reminder - {{property_name}}",
            "body": """Good morning {{guest_name}},

Just a friendly reminder that checkout is today by 11:00 AM.

Before you leave, please:
✓ Load and start the dishwasher
✓ Take out any trash to the bins outside
✓ Turn off all lights and appliances
✓ Lock all doors and windows
✓ Leave the key {{key_return_instructions}}

We hope you enjoyed your stay at {{property_name}}! If you have a moment, we'd really appreciate a review on VRBO.

Safe travels home!

Bill""",
            "variables": ["guest_name", "property_name", "key_return_instructions"]
        },
        {
            "name": "review_request",
            "type": MessageType.REVIEW_REQUEST,
            "subject": "How was your stay at {{property_name}}?",
            "body": """Hi {{guest_name}},

I hope you made it home safely and that you enjoyed your recent stay at {{property_name}}.

Your feedback is incredibly valuable to us and helps future guests make informed decisions. If you have a few minutes, we would greatly appreciate if you could share your experience by leaving a review on VRBO.

If there was anything about your stay that didn't meet your expectations, please let me know directly so I can address it for future guests.

Thank you again for choosing {{property_name}}. We hope to welcome you back again soon!

Best regards,
Bill""",
            "variables": ["guest_name", "property_name"]
        },
        {
            "name": "house_rules_reminder",
            "type": MessageType.HOUSE_RULES,
            "subject": "House Rules - {{property_name}}",
            "body": """Hi {{guest_name}},

Welcome! Here are our house rules to ensure everyone has a great stay:

🚭 No smoking inside the property
🎉 No parties or events
🔇 Quiet hours: 10 PM - 8 AM
🐕 {{pet_policy}}
👥 Maximum occupancy: {{max_guests}} guests
🚗 {{parking_rules}}

Pool/Hot Tub (if applicable):
{{pool_rules}}

We appreciate your cooperation in maintaining our property for all guests to enjoy!

Bill""",
            "variables": ["guest_name", "property_name", "pet_policy", "max_guests", 
                         "parking_rules", "pool_rules"]
        },
        {
            "name": "local_recommendations",
            "type": MessageType.LOCAL_RECOMMENDATIONS,
            "subject": "Local Recommendations - {{property_name}}",
            "body": """Hi {{guest_name}},

Here are some of our favorite local spots:

🍽️ RESTAURANTS:
{{restaurant_recommendations}}

☕ COFFEE & BREAKFAST:
{{coffee_spots}}

🛒 GROCERIES:
{{grocery_stores}}

🏖️ ACTIVITIES:
{{local_activities}}

🚑 EMERGENCY:
- Nearest Hospital: {{hospital_info}}
- Urgent Care: {{urgent_care_info}}
- Emergency: 911

Feel free to ask if you need any other recommendations!

Enjoy your stay!
Bill""",
            "variables": ["guest_name", "property_name", "restaurant_recommendations", 
                         "coffee_spots", "grocery_stores", "local_activities", 
                         "hospital_info", "urgent_care_info"]
        }
    ]
    
    # Save templates to database
    for template_data in default_templates:
        await save_template(MessageTemplate(**template_data))
    
    logger.info(f"✅ Initialized {len(default_templates)} default templates")

async def get_booking_details(booking_id: str) -> Optional[Dict]:
    """Get booking details from database"""
    async with AsyncSessionLocal() as session:
        query = """
        SELECT b.*, p.name as property_name, p.address as property_address
        FROM bookings b
        JOIN properties p ON b.property_id = p.id
        WHERE b.vrbo_booking_id = :booking_id
        """
        result = await session.execute(query, {"booking_id": booking_id})
        row = result.first()
        return dict(row) if row else None

async def queue_message_for_sending(message: GuestMessage) -> str:
    """Queue message for sending through VRBO API"""
    message_id = f"msg_{datetime.now().timestamp()}_{message.booking_id}"
    
    # If template-based, render the message
    if message.message_type != MessageType.CUSTOM:
        template = await get_template_for_type(message.message_type)
        if template:
            # Get booking details for template variables
            booking = await get_booking_details(message.booking_id)
            template_vars = {**booking, **message.template_variables}
            
            # Render template
            message.subject = render_template_string(template['subject'], template_vars)
            message.body = render_template_string(template['body'], template_vars)
    
    # Add to Redis queue
    message_data = {
        "message_id": message_id,
        "booking_id": message.booking_id,
        "subject": message.subject,
        "body": message.body,
        "priority": message.priority,
        "created_at": datetime.now().isoformat(),
        "attempts": 0
    }
    
    # Use priority queue
    score = get_priority_score(message.priority)
    await redis_client.zadd("message_queue", {json.dumps(message_data): score})
    
    logger.info(f"📧 Queued message {message_id} for booking {message.booking_id}")
    return message_id

async def schedule_message(message: GuestMessage):
    """Schedule a message for future sending"""
    schedule_data = {
        "message": message.dict(),
        "scheduled_time": message.schedule_time.isoformat()
    }
    
    # Add to scheduled messages sorted set
    score = message.schedule_time.timestamp()
    await redis_client.zadd("scheduled_messages", {json.dumps(schedule_data): score})
    
    logger.info(f"📅 Scheduled message for {message.schedule_time}")

async def message_queue_processor():
    """Process queued messages"""
    while True:
        try:
            # Get highest priority message
            messages = await redis_client.zrange("message_queue", 0, 0)
            
            if messages:
                message_data = json.loads(messages[0])
                
                # Send through VRBO API
                success = await send_vrbo_message(message_data)
                
                if success:
                    # Remove from queue
                    await redis_client.zrem("message_queue", messages[0])
                    
                    # Log success
                    await log_message_status(
                        message_data['message_id'],
                        message_data['booking_id'],
                        "sent",
                        datetime.now()
                    )
                else:
                    # Increment retry count
                    message_data['attempts'] += 1
                    
                    if message_data['attempts'] >= 3:
                        # Max retries reached, move to failed queue
                        await redis_client.zrem("message_queue", messages[0])
                        await redis_client.rpush("failed_messages", json.dumps(message_data))
                        
                        await log_message_status(
                            message_data['message_id'],
                            message_data['booking_id'],
                            "failed",
                            datetime.now(),
                            "Max retries reached"
                        )
                    else:
                        # Re-queue with lower priority
                        await redis_client.zrem("message_queue", messages[0])
                        score = get_priority_score(MessagePriority.LOW) + message_data['attempts'] * 100
                        await redis_client.zadd("message_queue", {json.dumps(message_data): score})
            
            # Process every 5 seconds
            await asyncio.sleep(5)
            
        except Exception as e:
            logger.error(f"Error in message queue processor: {e}")
            await asyncio.sleep(10)

async def scheduled_message_sender():
    """Send scheduled messages"""
    while True:
        try:
            now = datetime.now().timestamp()
            
            # Get due messages
            due_messages = await redis_client.zrangebyscore(
                "scheduled_messages", 0, now
            )
            
            for message_json in due_messages:
                schedule_data = json.loads(message_json)
                message = GuestMessage(**schedule_data['message'])
                
                # Queue for immediate sending
                await queue_message_for_sending(message)
                
                # Remove from scheduled
                await redis_client.zrem("scheduled_messages", message_json)
                
                logger.info(f"📤 Moved scheduled message to send queue")
            
            # Check every minute
            await asyncio.sleep(60)
            
        except Exception as e:
            logger.error(f"Error in scheduled message sender: {e}")
            await asyncio.sleep(60)

async def send_vrbo_message(message_data: Dict) -> bool:
    """Send message through VRBO messaging API"""
    try:
        # Get access token
        token = await get_vrbo_access_token()
        if not token:
            logger.error("Failed to get VRBO access token")
            return False
        
        # Prepare VRBO message payload
        vrbo_payload = {
            "bookingId": message_data['booking_id'],
            "subject": message_data['subject'],
            "message": message_data['body'],
            "messageType": "HOST_TO_GUEST"
        }
        
        # Send through VRBO API
        async with aiohttp.ClientSession() as session:
            headers = {
                "Authorization": f"Bearer {token}",
                "Content-Type": "application/json"
            }
            
            url = f"{VRBO_BASE_URL}/messaging/v1/messages"
            
            async with session.post(url, json=vrbo_payload, headers=headers) as response:
                if response.status == 200:
                    logger.info(f"✅ Message sent successfully to booking {message_data['booking_id']}")
                    return True
                else:
                    error_text = await response.text()
                    logger.error(f"Failed to send message: {response.status} - {error_text}")
                    return False
                    
    except Exception as e:
        logger.error(f"Error sending VRBO message: {e}")
        return False

async def get_vrbo_access_token() -> Optional[str]:
    """Get VRBO API access token"""
    # Check cache first
    cached_token = await redis_client.get("vrbo_access_token")
    if cached_token:
        return cached_token.decode()
    
    # Request new token
    auth_url = f"{VRBO_BASE_URL}/authentication/v1/token"
    
    async with aiohttp.ClientSession() as session:
        data = {
            "grant_type": "client_credentials",
            "client_id": VRBO_CLIENT_ID,
            "client_secret": VRBO_CLIENT_SECRET
        }
        
        async with session.post(auth_url, data=data) as response:
            if response.status == 200:
                result = await response.json()
                token = result.get("access_token")
                expires_in = result.get("expires_in", 3600)
                
                # Cache token
                await redis_client.setex(
                    "vrbo_access_token",
                    expires_in - 300,  # 5 min buffer
                    token
                )
                
                return token
            else:
                logger.error(f"Auth failed: {response.status}")
                return None

def get_priority_score(priority: MessagePriority) -> float:
    """Get numeric score for message priority"""
    scores = {
        MessagePriority.HIGH: 0,
        MessagePriority.NORMAL: 100,
        MessagePriority.LOW: 200
    }
    return scores.get(priority, 100)

async def load_templates(message_type: Optional[MessageType] = None) -> List[Dict]:
    """Load message templates from database"""
    async with AsyncSessionLocal() as session:
        query = "SELECT * FROM communication_templates WHERE active = true"
        params = {}
        
        if message_type:
            query += " AND template_type = :message_type"
            params["message_type"] = message_type.value
            
        result = await session.execute(query, params)
        return [dict(row) for row in result]

async def get_template_for_type(message_type: MessageType) -> Optional[Dict]:
    """Get template for specific message type"""
    templates = await load_templates(message_type)
    return templates[0] if templates else None

async def save_template(template: MessageTemplate) -> int:
    """Save message template to database"""
    async with AsyncSessionLocal() as session:
        query = """
        INSERT INTO communication_templates 
        (template_name, template_type, subject, body_text, variables, active)
        VALUES (:name, :type, :subject, :body, :variables, :active)
        RETURNING id
        """
        
        params = {
            "name": template.name,
            "type": template.type.value,
            "subject": template.subject,
            "body": template.body,
            "variables": json.dumps(template.variables),
            "active": template.active
        }
        
        result = await session.execute(query, params)
        await session.commit()
        
        return result.scalar()

def render_template_string(template: str, variables: Dict[str, Any]) -> str:
    """Render template string with variables"""
    from jinja2 import Template
    tmpl = Template(template)
    return tmpl.render(**variables)

async def fetch_message_history(booking_id: str) -> List[Dict]:
    """Fetch message history for a booking"""
    async with AsyncSessionLocal() as session:
        query = """
        SELECT * FROM messages 
        WHERE booking_id = (
            SELECT id FROM bookings WHERE vrbo_booking_id = :booking_id
        )
        ORDER BY created_date DESC
        """
        
        result = await session.execute(query, {"booking_id": booking_id})
        return [dict(row) for row in result]

async def get_bookings_for_bulk_message(
    property_ids: List[str],
    date_range: Optional[Dict[str, str]] = None
) -> List[Dict]:
    """Get bookings for bulk messaging"""
    async with AsyncSessionLocal() as session:
        query = """
        SELECT b.vrbo_booking_id as booking_id, b.* 
        FROM bookings b
        JOIN properties p ON b.property_id = p.id
        WHERE p.vrbo_property_id IN :property_ids
        AND b.booking_status = 'confirmed'
        """
        
        params = {"property_ids": tuple(property_ids)}
        
        if date_range:
            if "start_date" in date_range:
                query += " AND b.check_in >= :start_date"
                params["start_date"] = date_range["start_date"]
            
            if "end_date" in date_range:
                query += " AND b.check_in <= :end_date"
                params["end_date"] = date_range["end_date"]
        
        result = await session.execute(query, params)
        return [dict(row) for row in result]

async def log_message_status(
    message_id: str,
    booking_id: str,
    status: str,
    sent_at: Optional[datetime],
    error: Optional[str] = None
):
    """Log message status to database"""
    async with AsyncSessionLocal() as session:
        query = """
        INSERT INTO message_logs 
        (message_id, booking_id, status, sent_at, error_message, created_at)
        VALUES (:message_id, :booking_id, :status, :sent_at, :error, NOW())
        """
        
        await session.execute(query, {
            "message_id": message_id,
            "booking_id": booking_id,
            "status": status,
            "sent_at": sent_at,
            "error": error
        })
        await session.commit()

@app.get("/stats")
async def get_messaging_stats():
    """Get messaging statistics"""
    stats = {
        "queue_size": await redis_client.zcard("message_queue"),
        "scheduled_messages": await redis_client.zcard("scheduled_messages"),
        "failed_messages": await redis_client.llen("failed_messages"),
        "templates_available": len(await load_templates()),
        "last_24h_sent": 0,  # Would query from database
        "avg_response_time": "< 1 minute"
    }
    
    return stats

if __name__ == "__main__":
    uvicorn.run(
        "main:app",
        host="0.0.0.0",
        port=8001,
        reload=True,
        log_level="info"
    )