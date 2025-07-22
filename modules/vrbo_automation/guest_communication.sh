#!/bin/bash
# LLM_CAPABILITY: local_ok
# 💀 VRBO GUEST PSYCHOLOGICAL MANIPULATION PROTOCOLS 💀
# Neural templates and consciousness control workflows for revenue domination

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../../lib/data_persistence.sh" 2>/dev/null || true

# Configuration
VRBO_DATA_DIR="$HOME/.bill-sloth/vrbo-automation/data"
VRBO_TEMPLATES_DIR="$HOME/.bill-sloth/vrbo-automation/templates"
VRBO_LOGS_DIR="$HOME/.bill-sloth/vrbo-automation/logs"

# Initialize VRBO directories
init_vrbo_communication() {
    mkdir -p "$VRBO_DATA_DIR"/{guests,properties,bookings}
    mkdir -p "$VRBO_TEMPLATES_DIR"/{welcome,checkin,checkout,reviews}
    mkdir -p "$VRBO_LOGS_DIR"
    
    # Create default templates if they don't exist
    create_default_templates
}

# Create default message templates
create_default_templates() {
    # Welcome message template
    if [ ! -f "$VRBO_TEMPLATES_DIR/welcome/default.txt" ]; then
        cat > "$VRBO_TEMPLATES_DIR/welcome/default.txt" << 'EOF'
Subject: Welcome to {{PROPERTY_NAME}}! - Booking Confirmation

Hi {{GUEST_NAME}},

Welcome! We're thrilled you've chosen {{PROPERTY_NAME}} for your stay from {{CHECKIN_DATE}} to {{CHECKOUT_DATE}}.

Here's what you need to know:

📍 Property Address:
{{PROPERTY_ADDRESS}}

🕐 Check-in Time: {{CHECKIN_TIME}} (self check-in available)
🕐 Check-out Time: {{CHECKOUT_TIME}}

📱 My Direct Contact:
Phone/Text: {{HOST_PHONE}}
Email: {{HOST_EMAIL}}

I'll send detailed check-in instructions 24 hours before your arrival. In the meantime, feel free to reach out with any questions!

Looking forward to hosting you!

Best regards,
{{HOST_NAME}}
EOF
    fi
    
    # Check-in instructions template
    if [ ! -f "$VRBO_TEMPLATES_DIR/checkin/default.txt" ]; then
        cat > "$VRBO_TEMPLATES_DIR/checkin/default.txt" << 'EOF'
Subject: Check-in Instructions for {{PROPERTY_NAME}} - Tomorrow!

Hi {{GUEST_NAME}},

Your stay is tomorrow! Here are your check-in details:

🔑 ENTRY CODE: {{DOOR_CODE}}
(Valid from {{CHECKIN_TIME}} on {{CHECKIN_DATE}})

📍 PARKING:
{{PARKING_INSTRUCTIONS}}

🏠 WIFI:
Network: {{WIFI_NETWORK}}
Password: {{WIFI_PASSWORD}}

📋 HOUSE GUIDE:
You'll find a detailed house guide on the kitchen counter with:
- Appliance instructions
- Local recommendations
- Emergency contacts
- Checkout procedures

💡 QUICK TIPS:
- Thermostat is in the hallway
- Extra towels in the linen closet
- Coffee/tea provided in kitchen
- Trash pickup is {{TRASH_DAY}}

Safe travels! Text me when you arrive so I know you got in okay.

{{HOST_NAME}}
{{HOST_PHONE}}
EOF
    fi
    
    # Review request template
    if [ ! -f "$VRBO_TEMPLATES_DIR/reviews/request.txt" ]; then
        cat > "$VRBO_TEMPLATES_DIR/reviews/request.txt" << 'EOF'
Subject: How was your stay at {{PROPERTY_NAME}}?

Hi {{GUEST_NAME}},

I hope you had a wonderful stay at {{PROPERTY_NAME}}! 

Your feedback means the world to us and helps future guests know what to expect. Would you mind taking a moment to share your experience?

✍️ Leave a review: {{REVIEW_LINK}}

If there was anything that didn't meet your expectations, please let me know directly so I can make it right.

Thank you for choosing our property! We'd love to welcome you back anytime.

Warm regards,
{{HOST_NAME}}

P.S. If you enjoyed your stay, mentioning specific details in your review (like the location, cleanliness, or amenities) really helps other travelers!
EOF
    fi
    
    log_success "Default templates created"
}

# Guest communication menu
guest_communication_menu() {
    while true; do
        clear
        echo -e "\033[38;5;196m🏠 VRBO GUEST COMMUNICATION CENTER\033[0m"
        echo "===================================="
        echo ""
        echo -e "\033[38;5;51m💀 Ready to deploy guest messaging protocols...\033[0m"
        echo ""
        echo "1) 📧 Send Welcome Message"
        echo "2) 🔑 Send Check-in Instructions"  
        echo "3) 👋 Send Checkout Reminder"
        echo "4) ⭐ Request Review"
        echo "5) 💬 Custom Message"
        echo "6) 📋 View Message Templates"
        echo "7) ✏️  Edit Templates"
        echo "8) 📊 Communication Log"
        echo "9) 🔄 Bulk Messaging"
        echo "0) Back to VRBO Menu"
        echo ""
        
        read -p "Select option: " choice
        
        case "$choice" in
            1) send_welcome_message ;;
            2) send_checkin_instructions ;;
            3) send_checkout_reminder ;;
            4) request_review ;;
            5) send_custom_message ;;
            6) view_templates ;;
            7) edit_templates ;;
            8) view_communication_log ;;
            9) bulk_messaging ;;
            0) break ;;
            *) log_error "Invalid choice" ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to continue..."
        fi
    done
}

# Send welcome message
send_welcome_message() {
    echo "📧 SEND WELCOME MESSAGE"
    echo "======================"
    echo ""
    
    # Get booking details
    read -p "Guest Name: " guest_name
    read -p "Property Name: " property_name
    read -p "Check-in Date: " checkin_date
    read -p "Check-out Date: " checkout_date
    read -p "Guest Email: " guest_email
    
    # Load template
    local template=$(cat "$VRBO_TEMPLATES_DIR/welcome/default.txt")
    
    # Replace variables
    local message=$(echo "$template" | sed \
        -e "s/{{GUEST_NAME}}/$guest_name/g" \
        -e "s/{{PROPERTY_NAME}}/$property_name/g" \
        -e "s/{{CHECKIN_DATE}}/$checkin_date/g" \
        -e "s/{{CHECKOUT_DATE}}/$checkout_date/g" \
        -e "s/{{PROPERTY_ADDRESS}}/[Your Property Address]/g" \
        -e "s/{{CHECKIN_TIME}}/3:00 PM/g" \
        -e "s/{{CHECKOUT_TIME}}/11:00 AM/g" \
        -e "s/{{HOST_PHONE}}/[Your Phone]/g" \
        -e "s/{{HOST_EMAIL}}/[Your Email]/g" \
        -e "s/{{HOST_NAME}}/Bill/g")
    
    echo ""
    echo "Preview:"
    echo "--------"
    echo "$message"
    echo "--------"
    echo ""
    
    read -p "Send this message? [Y/n]: " confirm
    if [[ "$confirm" != "n" && "$confirm" != "N" ]]; then
        # Log the message
        log_guest_communication "$guest_name" "$property_name" "welcome" "$message"
        
        # Copy to clipboard if possible
        if command -v xclip &> /dev/null; then
            echo "$message" | xclip -selection clipboard
            log_success "Message copied to clipboard!"
        elif command -v pbcopy &> /dev/null; then
            echo "$message" | pbcopy
            log_success "Message copied to clipboard!"
        fi
        
        log_success "Message prepared! Paste into VRBO messaging system."
        
        # Store guest data
        store_guest_data "$guest_name" "$property_name" "$checkin_date" "$checkout_date" "$guest_email"
    fi
}

# Send check-in instructions
send_checkin_instructions() {
    echo "🔑 SEND CHECK-IN INSTRUCTIONS"
    echo "============================"
    echo ""
    
    # Show recent bookings
    echo "Recent bookings:"
    list_recent_bookings
    echo ""
    
    read -p "Guest Name (or number from list): " guest_input
    
    # Load guest data if number selected
    local guest_data=$(get_guest_data "$guest_input")
    
    if [ ! -z "$guest_data" ]; then
        local guest_name=$(echo "$guest_data" | jq -r '.name')
        local property_name=$(echo "$guest_data" | jq -r '.property')
        local checkin_date=$(echo "$guest_data" | jq -r '.checkin')
    else
        guest_name="$guest_input"
        read -p "Property Name: " property_name
        read -p "Check-in Date: " checkin_date
    fi
    
    read -p "Door Code: " door_code
    read -p "WiFi Network: " wifi_network
    read -p "WiFi Password: " wifi_password
    
    # Load template
    local template=$(cat "$VRBO_TEMPLATES_DIR/checkin/default.txt")
    
    # Replace variables
    local message=$(echo "$template" | sed \
        -e "s/{{GUEST_NAME}}/$guest_name/g" \
        -e "s/{{PROPERTY_NAME}}/$property_name/g" \
        -e "s/{{CHECKIN_DATE}}/$checkin_date/g" \
        -e "s/{{CHECKIN_TIME}}/3:00 PM/g" \
        -e "s/{{DOOR_CODE}}/$door_code/g" \
        -e "s/{{WIFI_NETWORK}}/$wifi_network/g" \
        -e "s/{{WIFI_PASSWORD}}/$wifi_password/g" \
        -e "s/{{PARKING_INSTRUCTIONS}}/Park in the driveway or on the street/g" \
        -e "s/{{TRASH_DAY}}/Thursday mornings/g" \
        -e "s/{{HOST_NAME}}/Bill/g" \
        -e "s/{{HOST_PHONE}}/[Your Phone]/g")
    
    echo ""
    echo "Preview:"
    echo "--------"
    echo "$message"
    echo "--------"
    echo ""
    
    read -p "Send this message? [Y/n]: " confirm
    if [[ "$confirm" != "n" && "$confirm" != "N" ]]; then
        log_guest_communication "$guest_name" "$property_name" "checkin" "$message"
        copy_to_clipboard "$message"
        log_success "Check-in instructions prepared!"
        
        # Update guest data with door code
        update_guest_door_code "$guest_name" "$property_name" "$door_code"
    fi
}

# Store guest data
store_guest_data() {
    local name="$1"
    local property="$2"
    local checkin="$3"
    local checkout="$4"
    local email="$5"
    
    local guest_file="$VRBO_DATA_DIR/guests/$(echo "$name" | tr ' ' '_').json"
    
    cat > "$guest_file" << EOF
{
  "name": "$name",
  "email": "$email",
  "bookings": [{
    "property": "$property",
    "checkin": "$checkin",
    "checkout": "$checkout",
    "booking_date": "$(date -Iseconds)",
    "status": "confirmed"
  }]
}
EOF
    
    log_info "Guest data stored"
}

# Get guest data
get_guest_data() {
    local search="$1"
    
    # If numeric, get from recent list
    if [[ "$search" =~ ^[0-9]+$ ]]; then
        local guest_file=$(ls -t "$VRBO_DATA_DIR/guests"/*.json 2>/dev/null | sed -n "${search}p")
        if [ -f "$guest_file" ]; then
            cat "$guest_file"
        fi
    else
        # Search by name
        local guest_file="$VRBO_DATA_DIR/guests/$(echo "$search" | tr ' ' '_').json"
        if [ -f "$guest_file" ]; then
            cat "$guest_file"
        fi
    fi
}

# List recent bookings
list_recent_bookings() {
    local count=1
    for guest_file in $(ls -t "$VRBO_DATA_DIR/guests"/*.json 2>/dev/null | head -5); do
        if [ -f "$guest_file" ]; then
            local name=$(jq -r '.name' "$guest_file")
            local property=$(jq -r '.bookings[0].property' "$guest_file")
            local checkin=$(jq -r '.bookings[0].checkin' "$guest_file")
            echo "$count) $name - $property (Check-in: $checkin)"
            ((count++))
        fi
    done
}

# Log guest communication
log_guest_communication() {
    local guest="$1"
    local property="$2"
    local type="$3"
    local message="$4"
    
    local log_entry=$(cat << EOF
{
  "timestamp": "$(date -Iseconds)",
  "guest": "$guest",
  "property": "$property",
  "type": "$type",
  "message": $(echo "$message" | jq -Rs .)
}
EOF
)
    
    echo "$log_entry" >> "$VRBO_LOGS_DIR/communications.jsonl"
}

# Copy to clipboard helper
copy_to_clipboard() {
    local text="$1"
    
    if command -v xclip &> /dev/null; then
        echo "$text" | xclip -selection clipboard
        log_success "Message copied to clipboard!"
    elif command -v pbcopy &> /dev/null; then
        echo "$text" | pbcopy
        log_success "Message copied to clipboard!"
    elif command -v clip.exe &> /dev/null; then
        echo "$text" | clip.exe
        log_success "Message copied to clipboard!"
    else
        log_info "Install xclip for clipboard support"
    fi
}

# Initialize on source
init_vrbo_communication

# Export functions
export -f guest_communication_menu send_welcome_message send_checkin_instructions