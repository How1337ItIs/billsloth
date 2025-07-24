#!/usr/bin/env python3
"""
Bill Sloth VRBO Automation Service
Professional VRBO/Expedia Partner API integration for vacation rental management
"""

import asyncio
import os
from datetime import datetime, timedelta
from typing import List, Optional

import uvicorn
from fastapi import FastAPI, HTTPException, BackgroundTasks
from pydantic import BaseModel
import aiohttp
from loguru import logger
import redis.asyncio as redis
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker

# Configure logging
logger.add(
    "/app/logs/vrbo_automation.log",
    rotation="1 day",
    retention="30 days",
    level="INFO"
)

app = FastAPI(title="Bill Sloth VRBO Automation", version="1.0.0")

# Database connection
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://bill:sloth_secure_2025@localhost:5432/bill_business")
engine = create_async_engine(DATABASE_URL)
AsyncSessionLocal = sessionmaker(engine, class_=AsyncSession, expire_on_commit=False)

# Redis connection
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")
redis_client = redis.from_url(REDIS_URL)

# VRBO API Configuration
VRBO_CLIENT_ID = os.getenv("VRBO_CLIENT_ID")
VRBO_CLIENT_SECRET = os.getenv("VRBO_CLIENT_SECRET")
VRBO_BASE_URL = "https://api.expediapartnercentral.com"

class BookingData(BaseModel):
    booking_id: str
    property_id: str
    guest_name: str
    guest_email: str
    check_in: datetime
    check_out: datetime
    total_amount: float
    guest_count: int

class PropertyData(BaseModel):
    property_id: str
    name: str
    address: str
    nightly_rate: float
    max_guests: int

@app.on_startup
async def startup_event():
    """Initialize services on startup"""
    logger.info("🚀 Starting Bill Sloth VRBO Automation Service")
    
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
    
    # Start background tasks
    asyncio.create_task(sync_bookings_scheduler())
    asyncio.create_task(guest_communication_scheduler())

@app.get("/")
async def root():
    return {"message": "Bill Sloth VRBO Automation Service - Ready for business!"}

@app.get("/health")
async def health_check():
    """Health check endpoint for Docker"""
    return {
        "status": "healthy",
        "timestamp": datetime.now().isoformat(),
        "service": "vrbo-automation",
        "version": "1.0.0"
    }

@app.post("/sync-bookings")
async def sync_bookings(background_tasks: BackgroundTasks):
    """Manually trigger booking synchronization"""
    background_tasks.add_task(sync_bookings_from_vrbo)
    return {"message": "Booking sync initiated"}

@app.get("/bookings")
async def get_bookings():
    """Get all bookings from database"""
    try:
        # This would fetch from database in real implementation
        bookings = await get_bookings_from_db()
        return {"bookings": bookings}
    except Exception as e:
        logger.error(f"Error fetching bookings: {e}")
        raise HTTPException(status_code=500, detail="Failed to fetch bookings")

@app.post("/send-welcome-email/{booking_id}")
async def send_welcome_email(booking_id: str, background_tasks: BackgroundTasks):
    """Send welcome email to guest"""
    background_tasks.add_task(send_guest_welcome_email, booking_id)
    return {"message": f"Welcome email queued for booking {booking_id}"}

async def sync_bookings_from_vrbo():
    """Synchronize bookings from VRBO API"""
    logger.info("🔄 Starting VRBO booking synchronization")
    
    if not VRBO_CLIENT_ID or not VRBO_CLIENT_SECRET:
        logger.warning("⚠️ VRBO API credentials not configured")
        return
    
    try:
        # Get auth token
        token = await get_vrbo_auth_token()
        if not token:
            logger.error("❌ Failed to get VRBO auth token")
            return
        
        # Fetch bookings
        bookings = await fetch_vrbo_bookings(token)
        
        # Process and store bookings
        for booking in bookings:
            await process_booking(booking)
            
        logger.info(f"✅ Synchronized {len(bookings)} bookings")
        
    except Exception as e:
        logger.error(f"❌ Booking sync failed: {e}")

async def get_vrbo_auth_token():
    """Get authentication token from VRBO API"""
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
                return result.get("access_token")
            else:
                logger.error(f"Auth failed: {response.status}")
                return None

async def fetch_vrbo_bookings(token: str):
    """Fetch bookings from VRBO API"""
    bookings_url = f"{VRBO_BASE_URL}/bookings/v1/bookings"
    headers = {"Authorization": f"Bearer {token}"}
    
    async with aiohttp.ClientSession() as session:
        async with session.get(bookings_url, headers=headers) as response:
            if response.status == 200:
                result = await response.json()
                return result.get("bookings", [])
            else:
                logger.error(f"Failed to fetch bookings: {response.status}")
                return []

async def process_booking(booking_data: dict):
    """Process and store individual booking"""
    try:
        # Store in database
        await store_booking_in_db(booking_data)
        
        # Cache in Redis for quick access
        await redis_client.setex(
            f"booking:{booking_data['id']}", 
            86400, 
            str(booking_data)
        )
        
        # Trigger guest communication if new booking
        if booking_data.get("status") == "confirmed":
            await schedule_guest_communications(booking_data)
        
        logger.info(f"✅ Processed booking {booking_data['id']}")
        
    except Exception as e:
        logger.error(f"❌ Failed to process booking {booking_data['id']}: {e}")

async def sync_bookings_scheduler():
    """Background scheduler for booking synchronization"""
    while True:
        await asyncio.sleep(3600)  # Run every hour
        await sync_bookings_from_vrbo()

async def guest_communication_scheduler():
    """Background scheduler for guest communications"""
    while True:
        await asyncio.sleep(1800)  # Run every 30 minutes
        await process_scheduled_communications()

async def send_guest_welcome_email(booking_id: str):
    """Send welcome email to guest"""
    logger.info(f"📧 Sending welcome email for booking {booking_id}")
    # Implementation would integrate with email service
    pass

async def schedule_guest_communications(booking_data: dict):
    """Schedule automated guest communications"""
    checkin_date = datetime.fromisoformat(booking_data['check_in'])
    
    # Schedule welcome email (immediate)
    await schedule_email("welcome", booking_data, datetime.now())
    
    # Schedule check-in instructions (24 hours before)
    checkin_reminder = checkin_date - timedelta(hours=24)
    await schedule_email("checkin_instructions", booking_data, checkin_reminder)
    
    # Schedule checkout instructions (day of checkin)
    await schedule_email("checkout_instructions", booking_data, checkin_date)

async def schedule_email(email_type: str, booking_data: dict, send_time: datetime):
    """Schedule email to be sent at specific time"""
    await redis_client.zadd(
        "scheduled_emails",
        {f"{email_type}:{booking_data['id']}": send_time.timestamp()}
    )

async def process_scheduled_communications():
    """Process scheduled communications that are due"""
    now = datetime.now().timestamp()
    
    # Get due communications
    due_communications = await redis_client.zrangebyscore(
        "scheduled_emails", 0, now, withscores=True
    )
    
    for comm_data, score in due_communications:
        email_type, booking_id = comm_data.decode().split(":", 1)
        await send_scheduled_email(email_type, booking_id)
        await redis_client.zrem("scheduled_emails", comm_data)

async def send_scheduled_email(email_type: str, booking_id: str):
    """Send scheduled email"""
    logger.info(f"📧 Sending {email_type} email for booking {booking_id}")
    # Implementation would load template and send email

# Database helper functions (would be implemented with SQLAlchemy)
async def get_bookings_from_db():
    """Get bookings from database"""
    return []

async def store_booking_in_db(booking_data: dict):
    """Store booking in database"""
    pass

if __name__ == "__main__":
    uvicorn.run(
        "main:app", 
        host="0.0.0.0", 
        port=8000, 
        reload=True,
        log_level="info"
    )