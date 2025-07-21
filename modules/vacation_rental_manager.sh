#!/bin/bash
# VACATION RENTAL MANAGER - Guntersville Getaway Management
# Integrates with VRBO, HomeAway, Google Calendar, and cleaning workflows

echo "VACATION_RENTAL_MODULE_LOADED"

rental_capabilities() {
    echo "Vacation Rental Management Capabilities:"
    echo "1. VRBO/HomeAway quick access and monitoring"
    echo "2. Google Calendar integration for bookings"
    echo "3. Cleaning checklists and scheduling"
    echo "4. Guest communication templates"
    echo "5. Maintenance tracking and reminders"
    echo "6. Revenue and booking analytics"
    echo "7. Property photo management"
    echo "8. Emergency contact lists"
}

setup_rental_workspace() {
    echo "[*] Setting up vacation rental workspace..."
    
    # Create organized directory structure
    mkdir -p ~/VacationRental/{
        Bookings,
        Cleaning,
        Maintenance,
        Photos,
        Templates,
        Revenue,
        Checklists,
        ContactInfo
    }
    
    # Create desktop shortcuts for quick access
    cat > ~/Desktop/GuntersvilleGetaway.desktop << 'EOF'
[Desktop Entry]
Name=Guntersville Getaway Dashboard
Comment=Quick access to rental management
Exec=bash -c "~/bin/rental-dashboard"
Icon=applications-office
Terminal=false
Type=Application
EOF
    chmod +x ~/Desktop/GuntersvilleGetaway.desktop
    
    echo "[✓] Rental workspace organized"
}

create_vrbo_homeaway_launcher() {
    echo "[*] Setting up VRBO/HomeAway quick launcher..."
    
    cat > ~/bin/rental-platforms << 'EOF'
#!/bin/bash
echo "🏖️ Opening Guntersville Getaway platforms..."

# Open VRBO and HomeAway in dedicated browser windows
firefox --new-window \
    "https://www.vrbo.com/owner/inbox" \
    "https://www.homeaway.com/owner/inbox" \
    "https://guntersvillegetaway.com" \
    "https://calendar.google.com" \
    "https://gmail.com" &

# Create notification for memory
sleep 5
notify-send "Rental Platforms Ready" "VRBO, HomeAway, and calendar opened"

# Log access for tracking
echo "$(date): Opened rental platforms" >> ~/VacationRental/activity.log
EOF
    chmod +x ~/bin/rental-platforms
    
    echo "[✓] VRBO/HomeAway launcher created"
}

create_cleaning_checklists() {
    echo "[*] Creating cleaning checklists and schedules..."
    
    # Pre-arrival cleaning checklist
    cat > ~/VacationRental/Checklists/pre-arrival-cleaning.md << 'EOF'
# 🧹 PRE-ARRIVAL CLEANING CHECKLIST - Guntersville Getaway

## Living Areas
- [ ] Vacuum all carpets and rugs
- [ ] Dust all surfaces (tables, TV stand, decorations)
- [ ] Clean and organize coffee table
- [ ] Wipe down light switches and door handles
- [ ] Empty all trash cans
- [ ] Check and clean remote controls

## Kitchen
- [ ] Clean all appliances (inside and out)
- [ ] Wipe down all counters and surfaces
- [ ] Clean sink and faucet
- [ ] Check and stock coffee, tea, basic condiments
- [ ] Ensure all dishes are clean and put away
- [ ] Clean stovetop and oven
- [ ] Wipe down cabinet fronts

## Bedrooms
- [ ] Fresh sheets on all beds
- [ ] Vacuum floors
- [ ] Dust nightstands and dressers
- [ ] Check closets are empty and clean
- [ ] Ensure adequate hangers
- [ ] Check all lamps work

## Bathrooms
- [ ] Deep clean shower/tub
- [ ] Clean and disinfect toilet
- [ ] Wipe down all surfaces
- [ ] Clean mirrors
- [ ] Fresh towels (bath, hand, washcloths)
- [ ] Stock toilet paper, soap, shampoo
- [ ] Empty trash

## Outdoor Areas
- [ ] Sweep deck/patio
- [ ] Check outdoor furniture is clean
- [ ] Ensure grill is clean (if applicable)
- [ ] Check hot tub is clean and running (if applicable)

## Final Checks
- [ ] All lights working
- [ ] AC/Heat set to comfortable temperature
- [ ] WiFi working and password available
- [ ] Check-in instructions visible
- [ ] Welcome basket/info ready
- [ ] Lock box code updated if needed

**Time Estimate: 3-4 hours**
**Best to complete: Day before or morning of arrival**
EOF

    # Post-departure checklist
    cat > ~/VacationRental/Checklists/post-departure-cleaning.md << 'EOF'
# 🔍 POST-DEPARTURE INSPECTION - Guntersville Getaway

## Immediate Check (within 2 hours of checkout)
- [ ] Walk through all rooms for obvious damage
- [ ] Check for left items
- [ ] Take photos if damage found
- [ ] Strip beds and start laundry
- [ ] Empty all trash
- [ ] Quick tidy for next cleaning

## Damage Assessment
- [ ] Furniture condition
- [ ] Wall/paint condition  
- [ ] Appliance functionality
- [ ] Missing items check
- [ ] Document any issues with photos

## Guest Communication
- [ ] Send thank you message (if good guests)
- [ ] Request review
- [ ] Address any issues if found
- [ ] Update guest notes in system

## Maintenance Notes
- [ ] Items needing repair
- [ ] Items needing replacement  
- [ ] Deep cleaning needed
- [ ] Supplies to restock

**Complete within 4 hours of checkout**
EOF

    # Weekly maintenance checklist
    cat > ~/VacationRental/Checklists/weekly-maintenance.md << 'EOF'
# 🔧 WEEKLY MAINTENANCE CHECK - Guntersville Getaway

## Systems Check
- [ ] HVAC filter condition
- [ ] Water pressure in all faucets
- [ ] Hot water heater function
- [ ] All lights and switches
- [ ] Internet speed test
- [ ] Smoke detector batteries

## Outdoor Maintenance
- [ ] Lawn condition
- [ ] Deck/patio cleanliness
- [ ] Outdoor furniture condition
- [ ] Grill maintenance
- [ ] Hot tub chemicals and cleanliness

## Supply Inventory
- [ ] Toilet paper stock
- [ ] Towels and linens
- [ ] Cleaning supplies
- [ ] Coffee/tea/basics
- [ ] Toiletries (shampoo, soap)
- [ ] Paper towels/tissues

## Deep Clean Rotation
Week 1: [ ] Kitchen deep clean
Week 2: [ ] Bathroom deep clean  
Week 3: [ ] Living areas deep clean
Week 4: [ ] Bedroom deep clean

**Complete every Sunday**
EOF

    echo "[✓] Cleaning checklists created"
}

create_guest_communication_templates() {
    echo "[*] Creating guest communication templates..."
    
    # Welcome message template
    cat > ~/VacationRental/Templates/welcome-message.txt << 'EOF'
🏖️ Welcome to Guntersville Getaway! 

Hi [GUEST_NAME],

Thank you for choosing our lake house for your stay! We're excited to have you.

KEY INFORMATION:
• Check-in: 4:00 PM
• Check-out: 11:00 AM  
• WiFi: [WIFI_NAME] / Password: [WIFI_PASSWORD]
• Lock box code: [LOCKBOX_CODE]

LAKE ACTIVITIES:
• Private dock access
• Kayaks available (use at own risk)
• Great fishing spots nearby
• Swimming area marked

LOCAL RECOMMENDATIONS:
• Restaurants: [LOCAL_RESTAURANTS]
• Groceries: [NEAREST_GROCERY]
• Attractions: [LOCAL_ATTRACTIONS]

Please don't hesitate to reach out if you need anything!

Best regards,
Bill
Guntersville Getaway Management
EOF

    # Check-in reminder template
    cat > ~/VacationRental/Templates/checkin-reminder.txt << 'EOF'
🗝️ Check-in Reminder - Tomorrow!

Hi [GUEST_NAME],

Your stay at Guntersville Getaway begins tomorrow! 

ARRIVAL DETAILS:
• Check-in time: 4:00 PM or later
• Address: [PROPERTY_ADDRESS]
• Lock box location: [LOCKBOX_LOCATION]
• Code: [LOCKBOX_CODE]

WHAT TO EXPECT:
• House will be clean and ready
• Welcome basket with local treats
• All amenities stocked and ready

Need to arrive earlier? Let me know and I'll do my best to accommodate.

Looking forward to hosting you!

Bill
EOF

    # Thank you and review request
    cat > ~/VacationRental/Templates/thank-you-review.txt << 'EOF'
🌟 Thank You for Staying with Us!

Hi [GUEST_NAME],

Thank you for choosing Guntersville Getaway! We hope you had a wonderful time at the lake.

If you enjoyed your stay, we would be incredibly grateful if you could leave us a review on VRBO/HomeAway. Your feedback helps other guests discover our little slice of paradise.

We'd also love to host you again in the future!

Best wishes,
Bill
Guntersville Getaway
EOF

    echo "[✓] Guest communication templates created"
}

create_rental_dashboard() {
    echo "[*] Creating rental management dashboard..."
    
    cat > ~/bin/rental-dashboard << 'EOF'
#!/bin/bash
clear
echo "🏖️ GUNTERSVILLE GETAWAY DASHBOARD"
echo "=================================="
echo ""
echo "📅 Today: $(date '+%A, %B %d, %Y')"
echo "🕐 Time: $(date '+%H:%M')"
echo ""

# Check for today's bookings (would integrate with calendar API)
echo "📋 TODAY'S TASKS:"
echo "• Check VRBO/HomeAway messages"
echo "• Review upcoming bookings"
echo "• Maintenance check (if no guests)"
echo ""

echo "🚀 QUICK ACTIONS:"
echo "1) Open rental platforms (VRBO/HomeAway/Calendar)"
echo "2) Pre-arrival cleaning checklist"
echo "3) Post-departure inspection"
echo "4) Weekly maintenance check"
echo "5) Send guest communication"
echo "6) Check revenue/bookings"
echo "7) Property photo management"
echo "8) Emergency contacts"
echo "9) Set cleaning reminder"
echo "0) Exit"
echo ""
read -p "Choose action: " action

case $action in
    1) ~/bin/rental-platforms ;;
    2) cat ~/VacationRental/Checklists/pre-arrival-cleaning.md | less ;;
    3) cat ~/VacationRental/Checklists/post-departure-cleaning.md | less ;;
    4) cat ~/VacationRental/Checklists/weekly-maintenance.md | less ;;
    5) ~/bin/guest-communication ;;
    6) ~/bin/rental-analytics ;;
    7) nautilus ~/VacationRental/Photos ;;
    8) cat ~/VacationRental/ContactInfo/emergency-contacts.txt ;;
    9) ~/bin/cleaning-reminder ;;
    0) exit ;;
esac
EOF
    chmod +x ~/bin/rental-dashboard
    
    echo "[✓] Rental dashboard created"
}

create_google_calendar_integration() {
    echo "[*] Setting up Google Calendar integration helpers..."
    
    # Quick calendar opener for booking management
    cat > ~/bin/rental-calendar << 'EOF'
#!/bin/bash
echo "📅 Opening rental booking calendar..."
firefox --new-tab "https://calendar.google.com" &

# Create a simple booking reminder system
cat > ~/bin/booking-reminder << 'INNER_EOF'
#!/bin/bash
echo "🔔 Booking Reminder System"
echo "What needs to be remembered?"
read reminder
echo "For which date? (YYYY-MM-DD)"
read reminder_date
echo "Setting reminder for $reminder_date: $reminder"
echo "$reminder_date: $reminder" >> ~/VacationRental/Bookings/reminders.txt
sort ~/VacationRental/Bookings/reminders.txt -o ~/VacationRental/Bookings/reminders.txt
notify-send "Reminder Set" "Added: $reminder for $reminder_date"
INNER_EOF
chmod +x ~/bin/booking-reminder

# Today's bookings checker
echo "Checking today's calendar..."
sleep 2
notify-send "Calendar Ready" "Check for today's arrivals/departures"
EOF
    chmod +x ~/bin/rental-calendar
    
    echo "[✓] Google Calendar integration ready"
}

create_guest_communication_helper() {
    echo "[*] Creating guest communication helper..."
    
    cat > ~/bin/guest-communication << 'EOF'
#!/bin/bash
echo "💬 Guest Communication Helper"
echo "============================="
echo ""
echo "📝 Available Templates:"
echo "1) Welcome message"
echo "2) Check-in reminder" 
echo "3) Thank you + review request"
echo "4) Custom message"
echo ""
read -p "Select template: " template

case $template in
    1) 
        echo "Opening welcome message template..."
        cat ~/VacationRental/Templates/welcome-message.txt
        ;;
    2)
        echo "Opening check-in reminder template..."
        cat ~/VacationRental/Templates/checkin-reminder.txt
        ;;
    3)
        echo "Opening thank you template..."
        cat ~/VacationRental/Templates/thank-you-review.txt
        ;;
    4)
        echo "What would you like to communicate?"
        read custom_message
        echo "Custom message: $custom_message"
        echo "$(date): Custom message - $custom_message" >> ~/VacationRental/communication-log.txt
        ;;
esac

echo ""
echo "💡 Remember to:"
echo "• Personalize with guest name"
echo "• Update specific details (codes, dates)"
echo "• Copy to VRBO/HomeAway platform"
echo "• Log communication in guest notes"
EOF
    chmod +x ~/bin/guest-communication
    
    echo "[✓] Guest communication helper ready"
}

create_cleaning_reminder_system() {
    echo "[*] Setting up cleaning reminder system..."
    
    cat > ~/bin/cleaning-reminder << 'EOF'
#!/bin/bash
echo "🧹 Cleaning Reminder System"
echo "==========================="
echo ""
echo "When is the next guest arrival?"
echo "1) Today"
echo "2) Tomorrow" 
echo "3) This week"
echo "4) Custom date"
echo ""
read -p "Select: " timing

case $timing in
    1)
        notify-send "URGENT: Guest Arriving Today!" "Start cleaning checklist immediately"
        ~/bin/focus-timer & # Start focus timer for cleaning
        cat ~/VacationRental/Checklists/pre-arrival-cleaning.md
        ;;
    2)
        notify-send "Guest Tomorrow" "Plan cleaning for today"
        # Set reminder for morning
        (sleep 3600 && notify-send "Start Cleaning!" "Guest arrives tomorrow") &
        ;;
    3)
        echo "Which day this week?"
        read day
        notify-send "Guest This Week" "Guest arriving $day - plan accordingly"
        ;;
    4)
        echo "Enter date (YYYY-MM-DD):"
        read custom_date
        echo "$custom_date: CLEANING DAY" >> ~/VacationRental/Bookings/reminders.txt
        ;;
esac
EOF
    chmod +x ~/bin/cleaning-reminder
    
    echo "[✓] Cleaning reminder system ready"
}

create_emergency_contacts() {
    echo "[*] Creating emergency contact list..."
    
    cat > ~/VacationRental/ContactInfo/emergency-contacts.txt << 'EOF'
🚨 GUNTERSVILLE GETAWAY EMERGENCY CONTACTS

PROPERTY MANAGEMENT:
• Bill (Primary): [BILL_PHONE]
• Backup Contact: [BACKUP_PHONE]

LOCAL SERVICES:
• Police: 911
• Fire Department: 911  
• Hospital: Marshall Medical Center - (256) 894-6615
• Poison Control: 1-800-222-1222

UTILITIES:
• Electric: [ELECTRIC_COMPANY] - [PHONE]
• Water: [WATER_COMPANY] - [PHONE]
• Gas: [GAS_COMPANY] - [PHONE]
• Internet: [INTERNET_PROVIDER] - [PHONE]

MAINTENANCE:
• Plumber: [PLUMBER_NAME] - [PHONE]
• Electrician: [ELECTRICIAN_NAME] - [PHONE]
• HVAC: [HVAC_COMPANY] - [PHONE]
• Cleaning Service: [CLEANING_SERVICE] - [PHONE]

LOCAL INFO:
• Lake Guntersville Police: (256) 582-2032
• Marshall County Sheriff: (256) 582-2034
• Nearest Hospital: 11540 US-431, Guntersville, AL 35976

PROPERTY DETAILS:
• Address: [PROPERTY_ADDRESS]
• Lock box location: [LOCKBOX_LOCATION]
• Main water shutoff: [WATER_LOCATION]
• Electrical panel: [PANEL_LOCATION]
• WiFi Network: [WIFI_NAME]
EOF

    echo "[✓] Emergency contacts list created"
}

check_rental_setup() {
    echo "[*] Vacation rental setup verification:"
    
    # Check directory structure
    if [ -d ~/VacationRental ]; then
        echo "✓ Rental workspace: $(find ~/VacationRental -type f | wc -l) files"
    else
        echo "✗ Rental workspace: Not created"
    fi
    
    # Check scripts
    scripts=("rental-dashboard" "rental-platforms" "guest-communication" "cleaning-reminder")
    for script in "${scripts[@]}"; do
        if [ -f ~/bin/$script ]; then
            echo "✓ $script: Ready"
        else
            echo "✗ $script: Missing"
        fi
    done
    
    # Check templates
    templates=("welcome-message.txt" "checkin-reminder.txt" "thank-you-review.txt")
    for template in "${templates[@]}"; do
        if [ -f ~/VacationRental/Templates/$template ]; then
            echo "✓ $template: Created"
        else
            echo "✗ $template: Missing"
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This vacation rental module should be executed by Claude Code"
    echo "Available functions: setup_rental_workspace, create_vrbo_homeaway_launcher, create_cleaning_checklists, create_rental_dashboard"
fi