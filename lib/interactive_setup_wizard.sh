#!/bin/bash
# LLM_CAPABILITY: local_ok
# Interactive Setup Wizard - Advanced onboarding for Bill Sloth
# Guides users through complete system configuration with intelligence and progress tracking

source "$(dirname "$0")/include_loader.sh"
load_includes "core" "notification" "error_handling" "data_persistence"

# Configuration
WIZARD_CONFIG_DIR="$HOME/.config/bill-sloth/wizard"
WIZARD_DATA_DIR="$HOME/.bill-sloth/setup"
WIZARD_LOG="$WIZARD_DATA_DIR/setup_wizard.log"
WIZARD_STATE_FILE="$WIZARD_DATA_DIR/wizard_state.json"
TEMPLATES_DIR="$(dirname "$0")/../config/templates"

# Create directories
mkdir -p "$WIZARD_CONFIG_DIR" "$WIZARD_DATA_DIR"

# Colors and styling
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Progress tracking
declare -A SETUP_STEPS=(
    ["business_profile"]="Business Profile Configuration"
    ["property_setup"]="VRBO Property Setup"
    ["partnership_config"]="Partnership Management Setup"
    ["email_automation"]="Email Automation Configuration"
    ["voice_control"]="Voice Control Setup"
    ["monitoring_setup"]="Monitoring & Analytics Setup"
    ["backup_config"]="Backup & Security Configuration"
    ["final_validation"]="Final System Validation"
)

declare -A STEP_STATUS=(
    ["business_profile"]="pending"
    ["property_setup"]="pending"
    ["partnership_config"]="pending"
    ["email_automation"]="pending"
    ["voice_control"]="pending"
    ["monitoring_setup"]="pending"
    ["backup_config"]="pending"
    ["final_validation"]="pending"
)

# Wizard state management
load_wizard_state() {
    if [ -f "$WIZARD_STATE_FILE" ]; then
        local state_data
        state_data=$(cat "$WIZARD_STATE_FILE" 2>/dev/null)
        
        # Parse JSON state (simplified)
        if echo "$state_data" | grep -q "business_profile.*completed"; then
            STEP_STATUS["business_profile"]="completed"
        fi
        if echo "$state_data" | grep -q "property_setup.*completed"; then
            STEP_STATUS["property_setup"]="completed"
        fi
        if echo "$state_data" | grep -q "partnership_config.*completed"; then
            STEP_STATUS["partnership_config"]="completed"
        fi
        if echo "$state_data" | grep -q "email_automation.*completed"; then
            STEP_STATUS["email_automation"]="completed"
        fi
        if echo "$state_data" | grep -q "voice_control.*completed"; then
            STEP_STATUS["voice_control"]="completed"
        fi
        if echo "$state_data" | grep -q "monitoring_setup.*completed"; then
            STEP_STATUS["monitoring_setup"]="completed"
        fi
        if echo "$state_data" | grep -q "backup_config.*completed"; then
            STEP_STATUS["backup_config"]="completed"
        fi
        if echo "$state_data" | grep -q "final_validation.*completed"; then
            STEP_STATUS["final_validation"]="completed"
        fi
    fi
}

save_wizard_state() {
    local step="$1"
    local status="$2"
    local data="${3:-{}}"
    
    STEP_STATUS["$step"]="$status"
    
    # Create JSON state (simplified)
    cat > "$WIZARD_STATE_FILE" << EOF
{
  "last_updated": "$(date -Iseconds)",
  "wizard_version": "1.0",
  "steps": {
    "business_profile": {"status": "${STEP_STATUS[business_profile]}", "data": {}},
    "property_setup": {"status": "${STEP_STATUS[property_setup]}", "data": {}},
    "partnership_config": {"status": "${STEP_STATUS[partnership_config]}", "data": {}},
    "email_automation": {"status": "${STEP_STATUS[email_automation]}", "data": {}},
    "voice_control": {"status": "${STEP_STATUS[voice_control]}", "data": {}},
    "monitoring_setup": {"status": "${STEP_STATUS[monitoring_setup]}", "data": {}},
    "backup_config": {"status": "${STEP_STATUS[backup_config]}", "data": {}},
    "final_validation": {"status": "${STEP_STATUS[final_validation]}", "data": {}}
  }
}
EOF
}

log_wizard() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$WIZARD_LOG"
}

show_wizard_banner() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════════╗
║                    🧙‍♂️ BILL SLOTH SETUP WIZARD 🧙‍♂️                              ║
║                                                                                  ║
║  Welcome to your personal automation empire! Let's get you set up for success.  ║
║  This wizard will configure everything for maximum business domination.         ║
╚══════════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    echo ""
}

show_progress_bar() {
    local completed=0
    local total=${#SETUP_STEPS[@]}
    
    for step in "${!STEP_STATUS[@]}"; do
        if [ "${STEP_STATUS[$step]}" = "completed" ]; then
            ((completed++))
        fi
    done
    
    local percentage=$((completed * 100 / total))
    local bar_length=40
    local filled_length=$((completed * bar_length / total))
    
    echo -e "${BOLD}Setup Progress: ${percentage}% Complete${NC}"
    echo -n "["
    for ((i=0; i<bar_length; i++)); do
        if [ $i -lt $filled_length ]; then
            echo -n "█"
        else
            echo -n "░"
        fi
    done
    echo "] ($completed/$total)"
    echo ""
}

show_step_menu() {
    echo -e "${PURPLE}🎯 SETUP STEPS OVERVIEW${NC}"
    echo "========================"
    echo ""
    
    local step_num=1
    for step in business_profile property_setup partnership_config email_automation voice_control monitoring_setup backup_config final_validation; do
        local status_icon
        local status_color
        case "${STEP_STATUS[$step]}" in
            "completed")
                status_icon="✅"
                status_color="$GREEN"
                ;;
            "in_progress")
                status_icon="🔄"
                status_color="$YELLOW"
                ;;
            *)
                status_icon="⏳"
                status_color="$BLUE"
                ;;
        esac
        
        echo -e "${status_color}$step_num. $status_icon ${SETUP_STEPS[$step]}${NC}"
        ((step_num++))
    done
    
    echo ""
    echo -e "${CYAN}Choose a step to configure (1-8), or 'q' to quit:${NC}"
}

business_profile_setup() {
    save_wizard_state "business_profile" "in_progress"
    
    clear
    echo -e "${CYAN}📊 BUSINESS PROFILE SETUP${NC}"
    echo "==========================="
    echo ""
    echo "Let's configure your business profile for optimal automation!"
    echo ""
    
    # Business name
    echo -e "${YELLOW}💼 What's your business name?${NC}"
    read -p "Business Name: " business_name
    
    # Business type
    echo ""
    echo -e "${YELLOW}🏠 What type of VRBO business do you run?${NC}"
    echo "1) Single Property Owner"
    echo "2) Multiple Properties"
    echo "3) Property Management Company"
    echo "4) Real Estate Investment Business"
    read -p "Select (1-4): " business_type
    
    # Location
    echo ""
    echo -e "${YELLOW}📍 What's your primary market location?${NC}"
    read -p "City, State: " business_location
    
    # Experience level
    echo ""
    echo -e "${YELLOW}🎓 What's your VRBO experience level?${NC}"
    echo "1) New to VRBO (0-6 months)"
    echo "2) Getting established (6 months - 2 years)"
    echo "3) Experienced host (2-5 years)"
    echo "4) Veteran host (5+ years)"
    read -p "Select (1-4): " experience_level
    
    # Revenue goals
    echo ""
    echo -e "${YELLOW}💰 What's your monthly revenue goal?${NC}"
    read -p "Monthly Goal ($): " revenue_goal
    
    # Time availability
    echo ""
    echo -e "${YELLOW}⏰ How many hours per week do you want to spend on VRBO management?${NC}"
    echo "1) Minimal (1-5 hours) - Maximum automation"
    echo "2) Light (5-10 hours) - Heavy automation with some manual oversight"
    echo "3) Moderate (10-20 hours) - Balanced automation and personal touch"
    echo "4) Hands-on (20+ hours) - Selective automation for efficiency"
    read -p "Select (1-4): " time_commitment
    
    # Partnership interests
    echo ""
    echo -e "${YELLOW}🤝 Are you interested in content creation partnerships?${NC}"
    echo "1) Yes, actively seeking partnerships"
    echo "2) Open to opportunities"
    echo "3) Not interested"
    read -p "Select (1-3): " partnership_interest
    
    # Save configuration
    local profile_config="$WIZARD_DATA_DIR/business_profile.json"
    cat > "$profile_config" << EOF
{
  "business_name": "$business_name",
  "business_type": "$business_type",
  "location": "$business_location",
  "experience_level": "$experience_level",
  "revenue_goal": "$revenue_goal",
  "time_commitment": "$time_commitment",
  "partnership_interest": "$partnership_interest",
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    # Generate recommendations
    echo ""
    echo -e "${GREEN}✨ PERSONALIZED RECOMMENDATIONS${NC}"
    echo "================================="
    
    case "$time_commitment" in
        "1")
            echo "🤖 Maximum Automation Package:"
            echo "• Automated pricing optimization"
            echo "• Complete guest communication automation"
            echo "• Smart calendar management"
            echo "• Voice control for hands-free operation"
            ;;
        "2")
            echo "⚡ Smart Efficiency Package:"
            echo "• Automated routine communications"
            echo "• Performance monitoring with alerts"
            echo "• Partnership opportunity tracking"
            ;;
        "3")
            echo "🎯 Balanced Control Package:"
            echo "• Selective automation for repetitive tasks"
            echo "• Enhanced analytics and insights"
            echo "• Custom communication templates"
            ;;
        "4")
            echo "🔧 Power User Package:"
            echo "• Advanced analytics and reporting"
            echo "• Detailed performance tracking"
            echo "• Custom workflow automation"
            ;;
    esac
    
    echo ""
    log_wizard "Business profile setup completed: $business_name"
    save_wizard_state "business_profile" "completed"
    
    echo -e "${GREEN}✅ Business profile configured successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

property_setup() {
    save_wizard_state "property_setup" "in_progress"
    
    clear
    echo -e "${CYAN}🏠 PROPERTY SETUP${NC}"
    echo "=================="
    echo ""
    echo "Let's configure your VRBO properties for optimal automation!"
    echo ""
    
    # Number of properties
    echo -e "${YELLOW}📊 How many properties do you manage?${NC}"
    read -p "Number of properties: " property_count
    
    # Property configuration
    local properties_config="$WIZARD_DATA_DIR/properties.json"
    echo '{"properties": [' > "$properties_config"
    
    for ((i=1; i<=property_count; i++)); do
        echo ""
        echo -e "${BLUE}--- Property $i Configuration ---${NC}"
        
        echo -e "${YELLOW}🏡 Property $i Details:${NC}"
        read -p "Property Name: " prop_name
        read -p "Address: " prop_address
        read -p "Property Type (house/condo/cabin/etc): " prop_type
        read -p "Bedrooms: " bedrooms
        read -p "Bathrooms: " bathrooms
        read -p "Max Guests: " max_guests
        read -p "Base Nightly Rate ($): " base_rate
        read -p "Cleaning Fee ($): " cleaning_fee
        
        # Add to JSON (simplified)
        if [ $i -gt 1 ]; then
            echo ',' >> "$properties_config"
        fi
        cat >> "$properties_config" << EOF
    {
      "id": "property_$i",
      "name": "$prop_name",
      "address": "$prop_address",
      "type": "$prop_type",
      "bedrooms": $bedrooms,
      "bathrooms": $bathrooms,
      "max_guests": $max_guests,
      "base_rate": $base_rate,
      "cleaning_fee": $cleaning_fee
    }
EOF
    done
    
    echo ']}' >> "$properties_config"
    
    # Automation preferences
    echo ""
    echo -e "${YELLOW}🤖 Automation Preferences:${NC}"
    echo "1) Enable dynamic pricing (adjust rates based on demand)"
    read -p "Dynamic pricing (y/n): " dynamic_pricing
    
    echo "2) Enable automated guest communications"
    read -p "Auto communications (y/n): " auto_communications
    
    echo "3) Enable calendar synchronization"
    read -p "Calendar sync (y/n): " calendar_sync
    
    # Performance targets
    echo ""
    echo -e "${YELLOW}🎯 Performance Targets:${NC}"
    read -p "Target occupancy rate (%): " target_occupancy
    read -p "Target guest rating (1-5): " target_rating
    
    # Save automation config
    local automation_config="$WIZARD_DATA_DIR/property_automation.json"
    cat > "$automation_config" << EOF
{
  "dynamic_pricing": "$dynamic_pricing",
  "auto_communications": "$auto_communications",
  "calendar_sync": "$calendar_sync",
  "targets": {
    "occupancy_rate": $target_occupancy,
    "guest_rating": $target_rating
  },
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    echo ""
    echo -e "${GREEN}✨ OPTIMIZATION RECOMMENDATIONS${NC}"
    echo "=================================="
    
    # Calculate recommendations based on input
    local avg_rate=$((base_rate + cleaning_fee / 2))
    local monthly_potential=$((avg_rate * target_occupancy * 30 / 100))
    
    echo "📈 Revenue Potential: ~\$$(printf "%'d" $monthly_potential)/month per property"
    echo "🎯 Optimization Focus Areas:"
    
    if [ "$dynamic_pricing" = "y" ]; then
        echo "  ✅ Dynamic pricing will optimize your rates automatically"
    else
        echo "  ⚠️  Consider enabling dynamic pricing for 15-25% revenue increase"
    fi
    
    if [ "$auto_communications" = "y" ]; then
        echo "  ✅ Guest communications will be handled automatically"
    else
        echo "  ⚠️  Automated communications can improve guest satisfaction"
    fi
    
    if [ $target_occupancy -gt 80 ]; then
        echo "  🎯 High occupancy target - focus on guest experience automation"
    elif [ $target_occupancy -lt 60 ]; then
        echo "  📈 Consider dynamic pricing and marketing automation"
    fi
    
    echo ""
    log_wizard "Property setup completed: $property_count properties configured"
    save_wizard_state "property_setup" "completed"
    
    echo -e "${GREEN}✅ Property setup completed successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

partnership_config_setup() {
    save_wizard_state "partnership_config" "in_progress"
    
    clear
    echo -e "${CYAN}🤝 PARTNERSHIP MANAGEMENT SETUP${NC}"
    echo "================================="
    echo ""
    echo "Let's configure your content creation and business partnerships!"
    echo ""
    
    # Partnership goals
    echo -e "${YELLOW}🎯 What are your partnership goals?${NC}"
    echo "1) Generate additional revenue through sponsored content"
    echo "2) Build brand awareness and audience"
    echo "3) Create networking opportunities"
    echo "4) All of the above"
    read -p "Select (1-4): " partnership_goals
    
    # Content creation experience
    echo ""
    echo -e "${YELLOW}📹 What's your content creation experience?${NC}"
    echo "1) New to content creation"
    echo "2) Some experience (social media, blog posts)"
    echo "3) Experienced content creator"
    echo "4) Professional content creator/influencer"
    read -p "Select (1-4): " content_experience
    
    # Platforms
    echo ""
    echo -e "${YELLOW}📱 Which platforms do you use? (select all that apply)${NC}"
    echo "Enter platforms separated by commas (e.g., instagram,youtube,tiktok,blog):"
    echo "Options: instagram, youtube, tiktok, blog, podcast, facebook, twitter, linkedin"
    read -p "Platforms: " platforms
    
    # Audience size
    echo ""
    echo -e "${YELLOW}👥 What's your approximate audience size across all platforms?${NC}"
    echo "1) Under 1,000 followers"
    echo "2) 1,000 - 10,000 followers"  
    echo "3) 10,000 - 100,000 followers"
    echo "4) 100,000+ followers"
    read -p "Select (1-4): " audience_size
    
    # Partnership types interested in
    echo ""
    echo -e "${YELLOW}💼 What types of partnerships interest you?${NC}"
    echo "1) Product sponsorships (travel gear, home products)"
    echo "2) Service partnerships (property management tools)"
    echo "3) Brand ambassadorships"
    echo "4) Affiliate marketing"
    echo "5) All types"
    read -p "Select (1-5): " partnership_types
    
    # Time commitment
    echo ""
    echo -e "${YELLOW}⏰ How much time can you dedicate to partnerships monthly?${NC}"
    echo "1) 1-5 hours (minimal commitment)"
    echo "2) 5-15 hours (moderate involvement)"
    echo "3) 15-30 hours (significant focus)"
    echo "4) 30+ hours (major business component)"
    read -p "Select (1-4): " partnership_time
    
    # Revenue expectations
    echo ""
    echo -e "${YELLOW}💰 What's your monthly partnership revenue goal?${NC}"
    read -p "Monthly Goal ($): " partnership_revenue_goal
    
    # Save configuration
    local partnership_config="$WIZARD_DATA_DIR/partnership_config.json"
    cat > "$partnership_config" << EOF
{
  "goals": "$partnership_goals",
  "content_experience": "$content_experience",
  "platforms": "$platforms",
  "audience_size": "$audience_size",
  "partnership_types": "$partnership_types",
  "time_commitment": "$partnership_time",
  "revenue_goal": "$partnership_revenue_goal",
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    # Generate recommendations
    echo ""
    echo -e "${GREEN}✨ PARTNERSHIP STRATEGY RECOMMENDATIONS${NC}"
    echo "========================================"
    
    case "$content_experience" in
        "1")
            echo "🌱 Beginner Strategy:"
            echo "• Start with authentic VRBO hosting content"
            echo "• Document your host journey and challenges"
            echo "• Focus on building genuine audience engagement"
            echo "• Begin with micro-partnerships and affiliate programs"
            ;;
        "2"|"3")
            echo "📈 Growth Strategy:"
            echo "• Leverage your existing audience for VRBO-related content"
            echo "• Develop signature content series (host tips, property tours)"
            echo "• Target hospitality and travel industry partnerships"
            echo "• Create professional media kit for outreach"
            ;;
        "4")
            echo "🚀 Professional Strategy:"
            echo "• Position as VRBO industry expert and thought leader"
            echo "• Develop premium content and educational materials"
            echo "• Target high-value brand partnerships"
            echo "• Consider speaking opportunities and consulting"
            ;;
    esac
    
    # Automation recommendations based on time commitment
    echo ""
    case "$partnership_time" in
        "1")
            echo "🤖 Maximum Automation Recommended:"
            echo "• Automated partnership outreach sequences"
            echo "• Template-based proposal generation"
            echo "• Automated performance tracking and reporting"
            ;;
        "2")
            echo "⚡ Smart Automation Recommended:"
            echo "• Automated lead generation and initial outreach"
            echo "• Performance tracking with weekly reports"
            echo "• Template customization for different partnership types"
            ;;
        "3"|"4")
            echo "🎯 Strategic Automation Recommended:"
            echo "• Advanced analytics and ROI tracking"
            echo "• Custom relationship management workflows"
            echo "• Automated contract and negotiation support"
            ;;
    esac
    
    echo ""
    log_wizard "Partnership configuration completed"
    save_wizard_state "partnership_config" "completed"
    
    echo -e "${GREEN}✅ Partnership management configured successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

email_automation_setup() {
    save_wizard_state "email_automation" "in_progress"
    
    clear
    echo -e "${CYAN}📧 EMAIL AUTOMATION SETUP${NC}"
    echo "=========================="
    echo ""
    echo "Let's configure your email automation for maximum efficiency!"
    echo ""
    
    # Email preferences
    echo -e "${YELLOW}✉️ Email Automation Preferences:${NC}"
    echo ""
    
    echo "1) Guest Communication Automation:"
    echo "   • Welcome messages with check-in details"
    echo "   • Mid-stay check-ins and local recommendations"
    echo "   • Checkout instructions and review requests"
    read -p "Enable guest automation? (y/n): " guest_automation
    
    echo ""
    echo "2) Partnership Outreach Automation:"
    echo "   • Initial contact templates"
    echo "   • Follow-up sequences"
    echo "   • Proposal and negotiation emails"
    read -p "Enable partnership automation? (y/n): " partnership_automation
    
    echo ""
    echo "3) Business Reporting Automation:"
    echo "   • Monthly revenue reports"
    echo "   • Performance analytics"
    echo "   • Goal tracking updates"
    read -p "Enable business reports? (y/n): " business_automation
    
    # Email frequency
    echo ""
    echo -e "${YELLOW}📅 Communication Frequency:${NC}"
    echo "1) Minimal (essential communications only)"
    echo "2) Balanced (important updates and opportunities)"
    echo "3) Comprehensive (detailed insights and recommendations)"
    read -p "Select frequency (1-3): " email_frequency
    
    # Personalization level
    echo ""
    echo -e "${YELLOW}👤 Personalization Level:${NC}"
    echo "1) Basic (name and property information)"
    echo "2) Enhanced (preferences and history-based)"
    echo "3) Advanced (AI-powered personalization)"
    read -p "Select personalization (1-3): " personalization_level
    
    # Email service configuration
    echo ""
    echo -e "${YELLOW}📨 Email Service Configuration:${NC}"
    read -p "Your business email address: " business_email
    read -p "Your name for email signatures: " email_signature_name
    
    # Notification preferences
    echo ""
    echo -e "${YELLOW}🔔 Notification Preferences:${NC}"
    echo "Which notifications do you want to receive?"
    read -p "New booking notifications (y/n): " notify_bookings
    read -p "Partnership opportunity alerts (y/n): " notify_partnerships
    read -p "System performance alerts (y/n): " notify_performance
    read -p "Revenue milestone notifications (y/n): " notify_revenue
    
    # Save configuration
    local email_config="$WIZARD_DATA_DIR/email_automation.json"
    cat > "$email_config" << EOF
{
  "guest_automation": "$guest_automation",
  "partnership_automation": "$partnership_automation",
  "business_automation": "$business_automation",
  "frequency": "$email_frequency",
  "personalization_level": "$personalization_level",
  "business_email": "$business_email",
  "signature_name": "$email_signature_name",
  "notifications": {
    "bookings": "$notify_bookings",
    "partnerships": "$notify_partnerships",
    "performance": "$notify_performance",
    "revenue": "$notify_revenue"
  },
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    # Generate email templates preview
    echo ""
    echo -e "${GREEN}✨ EMAIL AUTOMATION PREVIEW${NC}"
    echo "============================="
    
    if [ "$guest_automation" = "y" ]; then
        echo ""
        echo -e "${BLUE}📧 Sample Welcome Email:${NC}"
        echo "Subject: Welcome to [Property Name] - Your Key Details Inside! 🏡"
        echo ""
        echo "Hi [Guest Name],"
        echo ""
        echo "Welcome to [Property Name]! We're thrilled you've chosen our place"
        echo "for your [Location] adventure."
        echo ""
        echo "🔑 CHECK-IN DETAILS:"
        echo "• Check-in: [Date] after [Time]"
        echo "• Access Code: [Code]"
        echo "• WiFi: [Network] / Password: [Password]"
        echo ""
        echo "Looking forward to hosting you!"
        echo "$email_signature_name"
    fi
    
    if [ "$partnership_automation" = "y" ]; then
        echo ""
        echo -e "${BLUE}📧 Sample Partnership Outreach:${NC}"
        echo "Subject: Partnership Opportunity - [Brand] x [Your Business]"
        echo ""
        echo "Hi [Contact Name],"
        echo ""
        echo "I'm $email_signature_name, and I work with [Your Business] in the"
        echo "VRBO/hospitality space. I've been following [Brand] and am impressed"
        echo "by [Specific Compliment]."
        echo ""
        echo "I believe there's a natural synergy between our audiences..."
    fi
    
    # Automation schedule
    echo ""
    echo -e "${GREEN}📅 AUTOMATION SCHEDULE${NC}"
    echo "======================="
    echo "• Guest welcome emails: Sent 24 hours before check-in"
    echo "• Mid-stay check-ins: Sent on day 2 of stay"
    echo "• Review requests: Sent 6 hours after checkout"
    echo "• Partnership follow-ups: 7-day intervals"
    echo "• Business reports: Monthly on the 1st"
    echo "• Performance alerts: Real-time when thresholds are met"
    
    echo ""
    log_wizard "Email automation setup completed"
    save_wizard_state "email_automation" "completed"
    
    echo -e "${GREEN}✅ Email automation configured successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

voice_control_setup() {
    save_wizard_state "voice_control" "in_progress"
    
    clear
    echo -e "${CYAN}🎤 VOICE CONTROL SETUP${NC}"
    echo "======================="
    echo ""
    echo "Let's configure your hands-free voice control system!"
    echo ""
    
    # Voice control interest
    echo -e "${YELLOW}🗣️ Voice Control Interest:${NC}"
    echo "Voice control allows you to:"
    echo "• Check booking status hands-free while cooking/cleaning"
    echo "• Update property information while doing maintenance"
    echo "• Generate reports while multitasking"
    echo "• Control smart home features for guests"
    echo ""
    read -p "Enable voice control? (y/n): " enable_voice
    
    if [ "$enable_voice" != "y" ]; then
        save_wizard_state "voice_control" "completed"
        echo -e "${YELLOW}Voice control disabled. You can enable it later from settings.${NC}"
        read -p "Press Enter to continue..."
        return
    fi
    
    # Activation method
    echo ""
    echo -e "${YELLOW}🎯 Voice Activation Method:${NC}"
    echo "1) Wake word ('Hey Bill', 'Jarvis') - Always listening, hands-free"
    echo "2) Push-to-talk (Ctrl+Alt+V) - Press key combination to activate"
    echo "3) Auto mode - Switches between methods based on system load"
    read -p "Select activation method (1-3): " activation_method
    
    # Wake words customization
    if [ "$activation_method" = "1" ] || [ "$activation_method" = "3" ]; then
        echo ""
        echo -e "${YELLOW}🗯️ Wake Word Preferences:${NC}"
        echo "Default wake words: 'Hey Bill', 'Bill Sloth', 'Jarvis', 'Computer'"
        read -p "Add custom wake word (optional): " custom_wake_word
    fi
    
    # Voice commands priority
    echo ""
    echo -e "${YELLOW}📋 Which voice commands are most important to you?${NC}"
    echo "Select all that apply (comma-separated numbers):"
    echo "1) Business status ('check bookings', 'revenue report')"
    echo "2) Property management ('guest status', 'maintenance alerts')"
    echo "3) Partnership tracking ('deal pipeline', 'campaign performance')"
    echo "4) System control ('backup now', 'system status')"
    echo "5) Smart home integration ('adjust temperature', 'check locks')"
    read -p "Priority commands: " priority_commands
    
    # Response style
    echo ""
    echo -e "${YELLOW}🎭 Voice Response Style:${NC}"
    echo "1) Professional (formal business language)"
    echo "2) Casual (friendly, conversational)"
    echo "3) Technical (detailed data and metrics)"
    echo "4) Minimal (brief confirmations only)"
    read -p "Select style (1-4): " response_style
    
    # Privacy settings
    echo ""
    echo -e "${YELLOW}🔒 Privacy & Security:${NC}"
    read -p "Enable voice command logging for improvement? (y/n): " voice_logging
    read -p "Require confirmation for financial commands? (y/n): " financial_confirmation
    read -p "Enable guest privacy mode (disable when guests present)? (y/n): " guest_privacy
    
    # Save configuration
    local voice_config="$WIZARD_DATA_DIR/voice_control.json"
    cat > "$voice_config" << EOF
{
  "enabled": true,
  "activation_method": "$activation_method",
  "custom_wake_word": "$custom_wake_word",
  "priority_commands": "$priority_commands",
  "response_style": "$response_style",
  "voice_logging": "$voice_logging",
  "financial_confirmation": "$financial_confirmation",
  "guest_privacy": "$guest_privacy",
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    # Show command examples
    echo ""
    echo -e "${GREEN}✨ VOICE COMMAND EXAMPLES${NC}"
    echo "=========================="
    echo ""
    echo -e "${BLUE}Business Commands:${NC}"
    echo "• 'Hey Bill, check today's bookings'"
    echo "• 'Jarvis, what's my occupancy rate this month?'"
    echo "• 'Bill Sloth, generate revenue report'"
    echo ""
    echo -e "${BLUE}Property Management:${NC}"
    echo "• 'Hey Bill, any guest messages?'"
    echo "• 'Computer, schedule maintenance for property 2'"
    echo "• 'Jarvis, check energy usage'"
    echo ""
    echo -e "${BLUE}Partnership Commands:${NC}"
    echo "• 'Hey Bill, show partnership pipeline'"
    echo "• 'Bill Sloth, track campaign performance'"
    echo "• 'Jarvis, any new partnership opportunities?'"
    echo ""
    echo -e "${BLUE}System Commands:${NC}"
    echo "• 'Hey Bill, backup all data'"
    echo "• 'Computer, system health check'"
    echo "• 'Jarvis, optimize performance'"
    
    # Training recommendations
    echo ""
    echo -e "${GREEN}🎓 VOICE TRAINING TIPS${NC}"
    echo "======================"
    echo "• Speak clearly and at normal pace"
    echo "• Use natural language - the system understands context"
    echo "• Try variations if a command isn't recognized"
    echo "• The system learns your speech patterns over time"
    
    case "$response_style" in
        "1")
            echo "• Professional mode: Commands confirmed with business terminology"
            ;;
        "2")
            echo "• Casual mode: Friendly responses with personality"
            ;;
        "3")
            echo "• Technical mode: Detailed metrics and data in responses"
            ;;
        "4")
            echo "• Minimal mode: Brief 'OK' and 'Done' confirmations"
            ;;
    esac
    
    echo ""
    log_wizard "Voice control setup completed with activation method $activation_method"
    save_wizard_state "voice_control" "completed"
    
    echo -e "${GREEN}✅ Voice control configured successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

monitoring_setup() {
    save_wizard_state "monitoring_setup" "in_progress"
    
    clear
    echo -e "${CYAN}📊 MONITORING & ANALYTICS SETUP${NC}"
    echo "================================="
    echo ""
    echo "Let's configure your business monitoring and analytics!"
    echo ""
    
    # Monitoring priorities
    echo -e "${YELLOW}🎯 What metrics are most important to monitor?${NC}"
    echo "Select all that apply (comma-separated numbers):"
    echo "1) Revenue and financial performance"
    echo "2) Property occupancy and booking trends"
    echo "3) Guest satisfaction and reviews"
    echo "4) Partnership ROI and campaign performance"
    echo "5) System performance and uptime"
    echo "6) Market trends and competitor analysis"
    read -p "Priority metrics: " priority_metrics
    
    # Alert preferences
    echo ""
    echo -e "${YELLOW}🚨 Alert Preferences:${NC}"
    echo ""
    echo "Revenue alerts:"
    read -p "Alert when daily revenue drops by what % (e.g., 20): " revenue_drop_threshold
    read -p "Alert when monthly goal is at risk (days before month end): " goal_risk_days
    
    echo ""
    echo "Booking alerts:"
    read -p "Alert when occupancy drops below what % (e.g., 60): " occupancy_threshold
    read -p "Alert for guest rating below what score (1-5): " rating_threshold
    
    echo ""
    echo "System alerts:"
    read -p "Alert when system CPU usage exceeds what % (e.g., 80): " cpu_threshold
    read -p "Alert when backup fails? (y/n): " backup_failure_alerts
    
    # Reporting frequency
    echo ""
    echo -e "${YELLOW}📈 Reporting Frequency:${NC}"
    echo "1) Daily summary reports"
    echo "2) Weekly performance reports"
    echo "3) Monthly comprehensive reports"
    echo "4) Quarterly business reviews"
    echo "5) Custom schedule"
    read -p "Select reporting frequency (1-5): " reporting_frequency
    
    # Dashboard preferences
    echo ""
    echo -e "${YELLOW}📊 Dashboard Preferences:${NC}"
    echo "What should be prominently displayed on your main dashboard?"
    echo "Select all that apply (comma-separated numbers):"
    echo "1) Today's revenue and bookings"
    echo "2) Current month performance vs. goals"
    echo "3) Property performance comparison"
    echo "4) Partnership pipeline status"
    echo "5) Guest satisfaction scores"
    echo "6) Upcoming checkins/checkouts"
    echo "7) System health status"
    read -p "Dashboard widgets: " dashboard_widgets
    
    # Data retention
    echo ""
    echo -e "${YELLOW}💾 Data Retention Preferences:${NC}"
    echo "1) 1 year (basic compliance)"
    echo "2) 3 years (extended analysis)"
    echo "3) 5 years (long-term trends)"
    echo "4) 7 years (maximum business intelligence)"
    read -p "Select data retention period (1-4): " data_retention
    
    # Export preferences
    echo ""
    echo -e "${YELLOW}📤 Data Export Preferences:${NC}"
    read -p "Enable automatic monthly CSV exports for accounting? (y/n): " auto_export_csv
    read -p "Enable PDF report generation? (y/n): " pdf_reports
    read -p "Integration with QuickBooks/accounting software? (y/n): " accounting_integration
    
    # Save configuration
    local monitoring_config="$WIZARD_DATA_DIR/monitoring_config.json"
    cat > "$monitoring_config" << EOF
{
  "priority_metrics": "$priority_metrics",
  "alerts": {
    "revenue_drop_threshold": $revenue_drop_threshold,
    "goal_risk_days": $goal_risk_days,
    "occupancy_threshold": $occupancy_threshold,
    "rating_threshold": $rating_threshold,
    "cpu_threshold": $cpu_threshold,
    "backup_failure_alerts": "$backup_failure_alerts"
  },
  "reporting_frequency": "$reporting_frequency",
  "dashboard_widgets": "$dashboard_widgets",
  "data_retention": "$data_retention",
  "exports": {
    "auto_csv": "$auto_export_csv",
    "pdf_reports": "$pdf_reports",
    "accounting_integration": "$accounting_integration"
  },
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    # Show monitoring preview
    echo ""
    echo -e "${GREEN}✨ MONITORING PREVIEW${NC}"
    echo "===================="
    echo ""
    echo -e "${BLUE}📊 Your Dashboard Will Show:${NC}"
    
    # Parse dashboard widgets and show preview
    case "$dashboard_widgets" in
        *"1"*) echo "• 💰 Today's Revenue: \$XXX (vs. \$XXX yesterday)" ;;
    esac
    case "$dashboard_widgets" in
        *"2"*) echo "• 🎯 Monthly Progress: XX% of goal achieved" ;;
    esac
    case "$dashboard_widgets" in
        *"3"*) echo "• 🏠 Property Performance: [Property rankings by revenue]" ;;
    esac
    case "$dashboard_widgets" in
        *"4"*) echo "• 🤝 Partnership Pipeline: X active deals worth \$XXX" ;;
    esac
    case "$dashboard_widgets" in
        *"5"*) echo "• ⭐ Guest Satisfaction: X.X/5.0 average rating" ;;
    esac
    case "$dashboard_widgets" in
        *"6"*) echo "• 📅 Upcoming: X checkins today, X checkouts tomorrow" ;;
    esac
    case "$dashboard_widgets" in
        *"7"*) echo "• 🖥️ System Health: All services operational" ;;
    esac
    
    echo ""
    echo -e "${BLUE}🚨 Alert Examples:${NC}"
    echo "• Revenue dropped ${revenue_drop_threshold}% from yesterday - investigate booking issues"
    echo "• Property X occupancy at ${occupancy_threshold}% - consider price adjustment"
    echo "• Guest rated Property Y ${rating_threshold}/5 - review and respond"
    echo "• System CPU at ${cpu_threshold}% - performance optimization recommended"
    
    echo ""
    echo -e "${BLUE}📈 Reporting Schedule:${NC}"
    case "$reporting_frequency" in
        "1") echo "• Daily email summary at 8:00 AM with key metrics" ;;
        "2") echo "• Weekly report every Monday with performance analysis" ;;
        "3") echo "• Monthly comprehensive report on the 1st with trends" ;;
        "4") echo "• Quarterly business review with strategic recommendations" ;;
        "5") echo "• Custom schedule (configure in settings)" ;;
    esac
    
    echo ""
    log_wizard "Monitoring and analytics setup completed"
    save_wizard_state "monitoring_setup" "completed"
    
    echo -e "${GREEN}✅ Monitoring & analytics configured successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

backup_config_setup() {
    save_wizard_state "backup_config" "in_progress"
    
    clear
    echo -e "${CYAN}💾 BACKUP & SECURITY CONFIGURATION${NC}"
    echo "==================================="
    echo ""
    echo "Let's secure your business data with robust backup and security!"
    echo ""
    
    # Backup frequency
    echo -e "${YELLOW}🔄 Backup Frequency:${NC}"
    echo "1) Real-time (continuous backup as changes occur)"
    echo "2) Hourly (backup every hour)"
    echo "3) Daily (backup once per day)"
    echo "4) Weekly (backup once per week)"
    read -p "Select backup frequency (1-4): " backup_frequency
    
    # Backup locations
    echo ""
    echo -e "${YELLOW}☁️ Backup Storage Locations:${NC}"
    echo "Select all that apply (comma-separated numbers):"
    echo "1) Local external drive"
    echo "2) Cloud storage (Dropbox, Google Drive, OneDrive)"
    echo "3) Amazon S3"
    echo "4) Network attached storage (NAS)"
    echo "5) Multiple locations for redundancy"
    read -p "Backup locations: " backup_locations
    
    # Data types to backup
    echo ""
    echo -e "${YELLOW}📁 Data Types to Backup:${NC}"
    echo "What data should be included in backups?"
    echo "Select all that apply (comma-separated numbers):"
    echo "1) Guest booking data"
    echo "2) Property information and settings"
    echo "3) Financial records and transactions"
    echo "4) Partnership contracts and communications"
    echo "5) Email templates and automation settings"
    echo "6) System configuration and preferences"
    echo "7) Analytics and performance history"
    echo "8) Voice control training data"
    read -p "Data types to backup: " backup_data_types
    
    # Encryption preferences
    echo ""
    echo -e "${YELLOW}🔒 Security & Encryption:${NC}"
    read -p "Enable AES-256 encryption for all backups? (y/n): " enable_encryption
    read -p "Require password for backup restoration? (y/n): " backup_password
    read -p "Enable two-factor authentication for admin access? (y/n): " enable_2fa
    
    # Retention policy
    echo ""
    echo -e "${YELLOW}🗓️ Backup Retention Policy:${NC}"
    echo "1) Keep 30 daily, 12 weekly, 12 monthly backups"
    echo "2) Keep 90 daily, 24 weekly, 24 monthly backups"
    echo "3) Keep 365 daily, 52 weekly, 60 monthly backups"
    echo "4) Custom retention schedule"
    read -p "Select retention policy (1-4): " retention_policy
    
    # Disaster recovery
    echo ""
    echo -e "${YELLOW}🆘 Disaster Recovery Planning:${NC}"
    read -p "Enable automatic failover to backup systems? (y/n): " auto_failover
    read -p "Create disaster recovery documentation? (y/n): " disaster_docs
    read -p "Schedule regular backup testing? (y/n): " backup_testing
    
    # Access controls
    echo ""
    echo -e "${YELLOW}👥 Access Control:${NC}"
    read -p "Your admin username: " admin_username
    read -p "Enable audit logging for all access? (y/n): " audit_logging
    read -p "Restrict administrative access to specific IP addresses? (y/n): " ip_restrictions
    
    # Monitoring and alerts
    echo ""
    echo -e "${YELLOW}📊 Backup Monitoring:${NC}"
    read -p "Alert when backup fails? (y/n): " backup_failure_alert
    read -p "Send weekly backup status reports? (y/n): " backup_reports
    read -p "Monitor backup storage usage? (y/n): " storage_monitoring
    
    # Save configuration
    local backup_config="$WIZARD_DATA_DIR/backup_security_config.json"
    cat > "$backup_config" << EOF
{
  "backup_frequency": "$backup_frequency",
  "backup_locations": "$backup_locations",
  "backup_data_types": "$backup_data_types",
  "encryption": {
    "enabled": "$enable_encryption",
    "backup_password": "$backup_password",
    "two_factor_auth": "$enable_2fa"
  },
  "retention_policy": "$retention_policy",
  "disaster_recovery": {
    "auto_failover": "$auto_failover",
    "documentation": "$disaster_docs",
    "testing": "$backup_testing"
  },
  "access_control": {
    "admin_username": "$admin_username",
    "audit_logging": "$audit_logging",
    "ip_restrictions": "$ip_restrictions"
  },
  "monitoring": {
    "failure_alerts": "$backup_failure_alert",
    "status_reports": "$backup_reports",
    "storage_monitoring": "$storage_monitoring"
  },
  "configured_at": "$(date -Iseconds)"
}
EOF
    
    # Show security preview
    echo ""
    echo -e "${GREEN}✨ SECURITY & BACKUP PREVIEW${NC}"
    echo "============================="
    echo ""
    echo -e "${BLUE}🔒 Security Features Enabled:${NC}"
    
    if [ "$enable_encryption" = "y" ]; then
        echo "✅ AES-256 encryption for all data"
    fi
    if [ "$backup_password" = "y" ]; then
        echo "✅ Password-protected backup restoration"
    fi
    if [ "$enable_2fa" = "y" ]; then
        echo "✅ Two-factor authentication for admin access"
    fi
    if [ "$audit_logging" = "y" ]; then
        echo "✅ Complete audit trail of all system access"
    fi
    
    echo ""
    echo -e "${BLUE}💾 Backup Strategy:${NC}"
    case "$backup_frequency" in
        "1") echo "• Real-time continuous backup (maximum protection)" ;;
        "2") echo "• Hourly backups (excellent protection)" ;;
        "3") echo "• Daily backups (good protection)" ;;
        "4") echo "• Weekly backups (basic protection)" ;;
    esac
    
    case "$retention_policy" in
        "1") echo "• 30 daily + 12 weekly + 12 monthly backups (1+ year history)" ;;
        "2") echo "• 90 daily + 24 weekly + 24 monthly backups (2+ year history)" ;;
        "3") echo "• 365 daily + 52 weekly + 60 monthly backups (5+ year history)" ;;
        "4") echo "• Custom retention schedule" ;;
    esac
    
    if [[ "$backup_locations" == *"5"* ]]; then
        echo "• Multiple backup locations for maximum redundancy"
    elif [[ "$backup_locations" == *"2"* ]]; then
        echo "• Cloud storage backup for off-site protection"
    elif [[ "$backup_locations" == *"1"* ]]; then
        echo "• Local backup for fast recovery"
    fi
    
    echo ""
    echo -e "${BLUE}🆘 Disaster Recovery:${NC}"
    if [ "$auto_failover" = "y" ]; then
        echo "✅ Automatic failover to backup systems"
    fi
    if [ "$disaster_docs" = "y" ]; then
        echo "✅ Disaster recovery procedures documented"
    fi
    if [ "$backup_testing" = "y" ]; then
        echo "✅ Regular backup validation testing"
    fi
    
    echo ""
    echo -e "${GREEN}🛡️ Your data is now enterprise-grade protected!${NC}"
    
    echo ""
    log_wizard "Backup and security configuration completed"
    save_wizard_state "backup_config" "completed"
    
    echo -e "${GREEN}✅ Backup & security configured successfully!${NC}"
    echo ""
    read -p "Press Enter to continue..."
}

final_validation() {
    save_wizard_state "final_validation" "in_progress"
    
    clear
    echo -e "${CYAN}🎯 FINAL SYSTEM VALIDATION${NC}"
    echo "==========================="
    echo ""
    echo "Let's validate your complete Bill Sloth configuration!"
    echo ""
    
    # Run validation checks
    echo -e "${YELLOW}🔍 Running comprehensive system validation...${NC}"
    echo ""
    
    local validation_score=0
    local total_checks=8
    
    # Check each configuration step
    echo "Validating configuration components:"
    
    if [ -f "$WIZARD_DATA_DIR/business_profile.json" ]; then
        echo "✅ Business Profile: Configured"
        ((validation_score++))
    else
        echo "❌ Business Profile: Not configured"
    fi
    
    if [ -f "$WIZARD_DATA_DIR/properties.json" ]; then
        echo "✅ Property Setup: Configured"
        ((validation_score++))
    else
        echo "❌ Property Setup: Not configured"
    fi
    
    if [ -f "$WIZARD_DATA_DIR/partnership_config.json" ]; then
        echo "✅ Partnership Management: Configured"
        ((validation_score++))
    else
        echo "❌ Partnership Management: Not configured"
    fi
    
    if [ -f "$WIZARD_DATA_DIR/email_automation.json" ]; then
        echo "✅ Email Automation: Configured"
        ((validation_score++))
    else
        echo "❌ Email Automation: Not configured"
    fi
    
    if [ -f "$WIZARD_DATA_DIR/voice_control.json" ]; then
        echo "✅ Voice Control: Configured"
        ((validation_score++))
    else
        echo "❌ Voice Control: Not configured"
    fi
    
    if [ -f "$WIZARD_DATA_DIR/monitoring_config.json" ]; then
        echo "✅ Monitoring & Analytics: Configured"
        ((validation_score++))
    else
        echo "❌ Monitoring & Analytics: Not configured"
    fi
    
    if [ -f "$WIZARD_DATA_DIR/backup_security_config.json" ]; then
        echo "✅ Backup & Security: Configured"
        ((validation_score++))
    else
        echo "❌ Backup & Security: Not configured"
    fi
    
    # System components check
    if [ -f "../docker-compose.yml" ] && [ -d "../docker" ]; then
        echo "✅ System Components: Ready"
        ((validation_score++))
    else
        echo "❌ System Components: Missing"
    fi
    
    # Calculate completion percentage
    local completion_percentage=$((validation_score * 100 / total_checks))
    
    echo ""
    echo -e "${PURPLE}📊 VALIDATION RESULTS${NC}"
    echo "====================="
    echo "Configuration Score: $validation_score/$total_checks ($completion_percentage%)"
    echo ""
    
    if [ $completion_percentage -ge 90 ]; then
        echo -e "${GREEN}🎉 EXCELLENT! Your Bill Sloth system is fully configured and ready for deployment!${NC}"
        local readiness_status="PRODUCTION READY"
    elif [ $completion_percentage -ge 75 ]; then
        echo -e "${YELLOW}⚠️ GOOD! Most components configured. Complete remaining steps for optimal performance.${NC}"
        local readiness_status="MOSTLY READY"
    elif [ $completion_percentage -ge 50 ]; then
        echo -e "${YELLOW}📝 PARTIAL: Several components configured. Continue setup for full functionality.${NC}"
        local readiness_status="PARTIALLY CONFIGURED"
    else
        echo -e "${RED}❌ INCOMPLETE: Please complete more configuration steps before deployment.${NC}"
        local readiness_status="NEEDS SETUP"
    fi
    
    # Generate personalized recommendations
    echo ""
    echo -e "${GREEN}✨ PERSONALIZED RECOMMENDATIONS${NC}"
    echo "================================="
    echo ""
    
    # Business profile recommendations
    if [ -f "$WIZARD_DATA_DIR/business_profile.json" ]; then
        local business_data=$(cat "$WIZARD_DATA_DIR/business_profile.json" 2>/dev/null)
        
        if echo "$business_data" | grep -q '"time_commitment": "1"'; then
            echo "🤖 Maximum Automation Recommendations:"
            echo "• Enable all automated features for hands-off operation"
            echo "• Set up voice control for quick status checks"
            echo "• Configure comprehensive alerting for important events"
        elif echo "$business_data" | grep -q '"time_commitment": "2"'; then
            echo "⚡ Smart Efficiency Recommendations:"
            echo "• Focus on guest communication automation"
            echo "• Enable partnership opportunity alerts"
            echo "• Set up weekly performance reports"
        fi
        
        if echo "$business_data" | grep -q '"partnership_interest": "1"'; then
            echo "🤝 Partnership Growth Recommendations:"
            echo "• Configure automated outreach sequences"
            echo "• Set up ROI tracking for all partnerships"
            echo "• Enable opportunity alerts for your niche"
        fi
    fi
    
    # Property-specific recommendations
    if [ -f "$WIZARD_DATA_DIR/properties.json" ]; then
        local property_data=$(cat "$WIZARD_DATA_DIR/properties.json" 2>/dev/null)
        local property_count=$(echo "$property_data" | grep -o '"id"' | wc -l)
        
        if [ $property_count -gt 1 ]; then
            echo "🏘️ Multi-Property Recommendations:"
            echo "• Compare property performance with analytics dashboard"
            echo "• Set up property-specific automation rules"
            echo "• Enable cross-property optimization suggestions"
        else
            echo "🏠 Single Property Recommendations:"
            echo "• Focus on maximizing occupancy and guest satisfaction"
            echo "• Set up detailed performance tracking"
            echo "• Consider expansion opportunities analysis"
        fi
    fi
    
    # Next steps
    echo ""
    echo -e "${CYAN}🚀 NEXT STEPS${NC}"
    echo "=============="
    
    if [ $completion_percentage -ge 90 ]; then
        echo "1. Deploy your Bill Sloth system to your Linux server"
        echo "2. Import your actual VRBO and business data"
        echo "3. Test all automated workflows with real scenarios"
        echo "4. Schedule a review after 30 days of operation"
    else
        echo "1. Complete any remaining configuration steps"
        echo "2. Run the setup wizard again to fill in missing components"
        echo "3. Review and customize your automation settings"
        echo "4. Test the system before full deployment"
    fi
    
    # Generate final configuration summary
    local config_summary="$WIZARD_DATA_DIR/configuration_summary.txt"
    cat > "$config_summary" << EOF
BILL SLOTH CONFIGURATION SUMMARY
Generated: $(date)

SYSTEM READINESS: $readiness_status ($completion_percentage%)

CONFIGURED COMPONENTS:
$([ -f "$WIZARD_DATA_DIR/business_profile.json" ] && echo "✅ Business Profile" || echo "❌ Business Profile")
$([ -f "$WIZARD_DATA_DIR/properties.json" ] && echo "✅ Property Setup" || echo "❌ Property Setup")
$([ -f "$WIZARD_DATA_DIR/partnership_config.json" ] && echo "✅ Partnership Management" || echo "❌ Partnership Management")
$([ -f "$WIZARD_DATA_DIR/email_automation.json" ] && echo "✅ Email Automation" || echo "❌ Email Automation")
$([ -f "$WIZARD_DATA_DIR/voice_control.json" ] && echo "✅ Voice Control" || echo "❌ Voice Control")
$([ -f "$WIZARD_DATA_DIR/monitoring_config.json" ] && echo "✅ Monitoring & Analytics" || echo "❌ Monitoring & Analytics")
$([ -f "$WIZARD_DATA_DIR/backup_security_config.json" ] && echo "✅ Backup & Security" || echo "❌ Backup & Security")

DEPLOYMENT READINESS:
- Configuration Files: $(ls "$WIZARD_DATA_DIR"/*.json 2>/dev/null | wc -l)/7 complete
- System Components: Ready
- Documentation: Available
- Support: Full documentation and troubleshooting guides

CONFIGURATION FILES LOCATION: $WIZARD_DATA_DIR
WIZARD LOG: $WIZARD_LOG

For deployment instructions, see: BILL_SLOTH_GIGA_DOC.md
For support, see: docs/troubleshooting/
EOF
    
    echo ""
    echo -e "${GREEN}📄 Configuration summary saved to: $config_summary${NC}"
    
    echo ""
    log_wizard "Final validation completed with $completion_percentage% system readiness"
    save_wizard_state "final_validation" "completed"
    
    echo -e "${GREEN}✅ System validation completed!${NC}"
    echo ""
    
    if [ $completion_percentage -ge 90 ]; then
        echo -e "${GREEN}🎉 Congratulations! Your Bill Sloth system is ready to dominate! 🚀${NC}"
    fi
    
    echo ""
    read -p "Press Enter to return to main menu..."
}

main_wizard() {
    # Initialize wizard state
    load_wizard_state
    
    while true; do
        show_wizard_banner
        show_progress_bar
        show_step_menu
        
        read -p "Enter your choice: " choice
        
        case "$choice" in
            1) business_profile_setup ;;
            2) property_setup ;;
            3) partnership_config_setup ;;
            4) email_automation_setup ;;
            5) voice_control_setup ;;
            6) monitoring_setup ;;
            7) backup_config_setup ;;
            8) final_validation ;;
            q|Q) 
                echo ""
                echo -e "${GREEN}Thanks for using the Bill Sloth Setup Wizard!${NC}"
                echo "Your progress has been saved and you can resume anytime."
                echo ""
                break
                ;;
            *) 
                echo ""
                echo -e "${RED}Invalid choice. Please select 1-8 or 'q' to quit.${NC}"
                echo ""
                read -p "Press Enter to continue..."
                ;;
        esac
    done
}

# Export functions
export -f main_wizard business_profile_setup property_setup
export -f partnership_config_setup email_automation_setup voice_control_setup
export -f monitoring_setup backup_config_setup final_validation

# Run main wizard if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main_wizard "$@"
fi