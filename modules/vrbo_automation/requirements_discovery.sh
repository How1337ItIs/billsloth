#!/bin/bash
# LLM_CAPABILITY: local_ok
# VRBO Requirements Discovery Flow
# Interactive questionnaire to understand Bill's specific VRBO needs

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../../lib/notification_system.sh" 2>/dev/null || true

# Configuration
VRBO_CONFIG_DIR="$HOME/.bill-sloth/vrbo-automation/config"
REQUIREMENTS_FILE="$VRBO_CONFIG_DIR/requirements.json"

# Initialize requirements discovery
init_requirements_discovery() {
    mkdir -p "$VRBO_CONFIG_DIR"
    
    if [ ! -f "$REQUIREMENTS_FILE" ]; then
        cat > "$REQUIREMENTS_FILE" << 'EOF'
{
  "discovery_date": "",
  "properties": [],
  "pain_points": [],
  "workflows": {},
  "integrations": {},
  "priorities": []
}
EOF
    fi
}

# Main discovery flow
vrbo_requirements_discovery() {
    clear
    print_header "🏠 VRBO AUTOMATION REQUIREMENTS DISCOVERY"
    
    echo "Hi Bill! Let's figure out exactly what you need for your VRBO properties."
    echo "This will help me create the perfect automation system for you."
    echo ""
    echo "Press Enter to continue..."
    read
    
    # Property Information
    discover_properties
    
    # Current Pain Points
    discover_pain_points
    
    # Workflow Preferences
    discover_workflows
    
    # Integration Needs
    discover_integrations
    
    # Priority Ranking
    discover_priorities
    
    # Generate Summary
    generate_requirements_summary
}

# Discover property details
discover_properties() {
    clear
    echo "🏠 PROPERTY INFORMATION"
    echo "====================="
    echo ""
    echo "Let's start with your properties..."
    echo ""
    
    local properties=()
    local add_more="y"
    
    while [[ "$add_more" == "y" || "$add_more" == "Y" ]]; do
        echo "Property #$((${#properties[@]} + 1)):"
        
        read -p "Property name/nickname: " prop_name
        read -p "Location (city, state): " prop_location
        read -p "Property type (house/condo/cabin/etc): " prop_type
        read -p "Number of bedrooms: " prop_bedrooms
        read -p "Max guests: " prop_max_guests
        read -p "Average bookings per month: " prop_bookings
        read -p "Cleaning service? (y/n): " prop_cleaning
        
        local property_json=$(cat << EOF
{
  "name": "$prop_name",
  "location": "$prop_location",
  "type": "$prop_type",
  "bedrooms": "$prop_bedrooms",
  "max_guests": "$prop_max_guests",
  "avg_bookings_month": "$prop_bookings",
  "has_cleaning_service": "$prop_cleaning"
}
EOF
)
        properties+=("$property_json")
        
        echo ""
        read -p "Add another property? (y/n): " add_more
        echo ""
    done
    
    # Save properties
    local props_array=$(printf '%s\n' "${properties[@]}" | jq -s '.')
    jq --argjson props "$props_array" '.properties = $props' "$REQUIREMENTS_FILE" > "${REQUIREMENTS_FILE}.tmp" && \
        mv "${REQUIREMENTS_FILE}.tmp" "$REQUIREMENTS_FILE"
}

# Discover pain points
discover_pain_points() {
    clear
    echo "😤 CURRENT PAIN POINTS"
    echo "===================="
    echo ""
    echo "What takes up the most time or causes the most stress?"
    echo "(Check all that apply)"
    echo ""
    
    local pain_points=()
    
    echo "1) [ ] Responding to guest inquiries quickly"
    echo "2) [ ] Remembering to send check-in instructions"
    echo "3) [ ] Coordinating with cleaning service"
    echo "4) [ ] Tracking door codes and WiFi passwords"
    echo "5) [ ] Following up for reviews"
    echo "6) [ ] Managing multiple booking platforms"
    echo "7) [ ] Tracking expenses and income"
    echo "8) [ ] Dealing with problem guests"
    echo "9) [ ] Property maintenance scheduling"
    echo "10) [ ] Keeping calendars synchronized"
    echo ""
    
    read -p "Enter numbers separated by spaces (e.g., 1 3 5): " selections
    
    for num in $selections; do
        case $num in
            1) pain_points+=("guest_response_time") ;;
            2) pain_points+=("checkin_reminders") ;;
            3) pain_points+=("cleaning_coordination") ;;
            4) pain_points+=("access_info_management") ;;
            5) pain_points+=("review_followup") ;;
            6) pain_points+=("platform_management") ;;
            7) pain_points+=("financial_tracking") ;;
            8) pain_points+=("problem_guest_handling") ;;
            9) pain_points+=("maintenance_scheduling") ;;
            10) pain_points+=("calendar_sync") ;;
        esac
    done
    
    echo ""
    read -p "Any other pain points? (describe briefly): " other_pain
    if [ ! -z "$other_pain" ]; then
        pain_points+=("$other_pain")
    fi
    
    # Save pain points
    local pain_array=$(printf '%s\n' "${pain_points[@]}" | jq -R . | jq -s '.')
    jq --argjson pain "$pain_array" '.pain_points = $pain' "$REQUIREMENTS_FILE" > "${REQUIREMENTS_FILE}.tmp" && \
        mv "${REQUIREMENTS_FILE}.tmp" "$REQUIREMENTS_FILE"
}

# Discover workflow preferences
discover_workflows() {
    clear
    echo "⚙️  WORKFLOW PREFERENCES"
    echo "======================"
    echo ""
    echo "How do you prefer to work?"
    echo ""
    
    # Guest communication
    echo "📧 GUEST COMMUNICATION:"
    echo "When do you typically send check-in instructions?"
    echo "1) Morning of check-in"
    echo "2) Night before check-in"
    echo "3) 2-3 days before"
    echo "4) 1 week before"
    echo "5) Varies/inconsistent"
    read -p "Select (1-5): " checkin_timing
    
    echo ""
    echo "How do you prefer to communicate with guests?"
    echo "1) VRBO messaging only"
    echo "2) Email after booking"
    echo "3) Text/SMS"
    echo "4) Mix of all"
    read -p "Select (1-4): " comm_preference
    
    # Cleaning coordination
    echo ""
    echo "🧹 CLEANING COORDINATION:"
    echo "How do you notify your cleaner?"
    echo "1) They check the calendar themselves"
    echo "2) I text them after each checkout"
    echo "3) I email them weekly schedule"
    echo "4) No cleaner / I do it myself"
    read -p "Select (1-4): " cleaning_method
    
    # Door codes
    echo ""
    echo "🔐 DOOR CODE MANAGEMENT:"
    echo "How do you handle door codes?"
    echo "1) Same code for everyone"
    echo "2) Change monthly"
    echo "3) Unique code per guest"
    echo "4) Last 4 digits of phone number"
    echo "5) Smart lock with auto-codes"
    read -p "Select (1-5): " door_code_method
    
    # Reviews
    echo ""
    echo "⭐ REVIEW REQUESTS:"
    echo "When do you ask for reviews?"
    echo "1) Day after checkout"
    echo "2) 2-3 days after"
    echo "3) 1 week after"
    echo "4) I often forget"
    read -p "Select (1-4): " review_timing
    
    # Save workflow preferences
    local workflows=$(cat << EOF
{
  "checkin_instruction_timing": "$checkin_timing",
  "communication_preference": "$comm_preference",
  "cleaning_notification": "$cleaning_method",
  "door_code_method": "$door_code_method",
  "review_request_timing": "$review_timing"
}
EOF
)
    
    jq --argjson work "$workflows" '.workflows = $work' "$REQUIREMENTS_FILE" > "${REQUIREMENTS_FILE}.tmp" && \
        mv "${REQUIREMENTS_FILE}.tmp" "$REQUIREMENTS_FILE"
}

# Discover integration needs
discover_integrations() {
    clear
    echo "🔌 INTEGRATION NEEDS"
    echo "==================="
    echo ""
    echo "What tools/services do you currently use?"
    echo ""
    
    local integrations={}
    
    read -p "Do you use Google Calendar? (y/n): " use_gcal
    read -p "Do you use pricing tools like PriceLabs or Wheelhouse? (y/n): " use_pricing
    read -p "Do you use a channel manager like OwnerRez? (y/n): " use_channel
    read -p "Do you track finances in QuickBooks/spreadsheet? (y/n): " use_finance
    read -p "Do you have smart home devices (locks/thermostats)? (y/n): " use_smart
    read -p "Do you use any other VRBO-related tools? (describe): " other_tools
    
    # Save integration needs
    local integrations=$(cat << EOF
{
  "google_calendar": "$use_gcal",
  "pricing_tools": "$use_pricing",
  "channel_manager": "$use_channel",
  "finance_tracking": "$use_finance",
  "smart_home": "$use_smart",
  "other_tools": "$other_tools"
}
EOF
)
    
    jq --argjson int "$integrations" '.integrations = $int' "$REQUIREMENTS_FILE" > "${REQUIREMENTS_FILE}.tmp" && \
        mv "${REQUIREMENTS_FILE}.tmp" "$REQUIREMENTS_FILE"
}

# Discover priorities
discover_priorities() {
    clear
    echo "🎯 AUTOMATION PRIORITIES"
    echo "======================="
    echo ""
    echo "What should we automate FIRST?"
    echo "Rank your top 3 priorities..."
    echo ""
    
    echo "Options:"
    echo "A) Guest communication templates & scheduling"
    echo "B) Check-in instruction automation"
    echo "C) Review request automation"
    echo "D) Cleaning service coordination"
    echo "E) Financial tracking & reports"
    echo "F) Calendar synchronization"
    echo "G) Door code management"
    echo "H) Problem guest response templates"
    echo ""
    
    local priorities=()
    
    read -p "1st priority (letter): " prio1
    read -p "2nd priority (letter): " prio2
    read -p "3rd priority (letter): " prio3
    
    priorities=("$prio1" "$prio2" "$prio3")
    
    # Save priorities
    local prio_array=$(printf '%s\n' "${priorities[@]}" | jq -R . | jq -s '.')
    jq --argjson prio "$prio_array" '.priorities = $prio' "$REQUIREMENTS_FILE" > "${REQUIREMENTS_FILE}.tmp" && \
        mv "${REQUIREMENTS_FILE}.tmp" "$REQUIREMENTS_FILE"
}

# Generate requirements summary
generate_requirements_summary() {
    clear
    echo "📋 REQUIREMENTS SUMMARY"
    echo "======================"
    echo ""
    
    # Update discovery date
    jq --arg date "$(date -Iseconds)" '.discovery_date = $date' "$REQUIREMENTS_FILE" > "${REQUIREMENTS_FILE}.tmp" && \
        mv "${REQUIREMENTS_FILE}.tmp" "$REQUIREMENTS_FILE"
    
    echo "Based on your responses, here's what I'll build for you:"
    echo ""
    
    # Read priorities and create action plan
    local priorities=$(jq -r '.priorities[]' "$REQUIREMENTS_FILE")
    local priority_num=1
    
    for prio in $priorities; do
        echo "$priority_num. "
        case $prio in
            A|a) echo "   📧 Smart guest communication system with templates and scheduling" ;;
            B|b) echo "   🔑 Automated check-in instructions based on your timing preferences" ;;
            C|c) echo "   ⭐ Review request automation to boost your ratings" ;;
            D|d) echo "   🧹 Cleaning coordination system" ;;
            E|e) echo "   💰 Financial tracking and reporting dashboard" ;;
            F|f) echo "   📅 Calendar synchronization across platforms" ;;
            G|g) echo "   🔐 Automated door code generation and management" ;;
            H|h) echo "   🚨 Problem guest response system" ;;
        esac
        ((priority_num++))
    done
    
    echo ""
    echo "📁 Your requirements have been saved to:"
    echo "   $REQUIREMENTS_FILE"
    echo ""
    echo "🚀 Next Steps:"
    echo "1. I'll create custom automation scripts based on your needs"
    echo "2. We'll test each automation with your actual property data"
    echo "3. You'll have a fully automated VRBO management system!"
    echo ""
    
    # Create implementation plan
    create_implementation_plan
    
    read -p "Ready to start building your custom VRBO automation? (y/n): " start_build
    
    if [[ "$start_build" == "y" || "$start_build" == "Y" ]]; then
        log_success "Great! Check back tomorrow for your custom automation scripts."
        notify_success "VRBO Discovery Complete" "Your custom automation system is being prepared!"
    fi
}

# Create implementation plan based on requirements
create_implementation_plan() {
    local plan_file="$VRBO_CONFIG_DIR/implementation_plan.md"
    
    cat > "$plan_file" << 'EOF'
# VRBO Automation Implementation Plan

## Based on Requirements Discovery

### Phase 1: Priority Automations
Based on your top priorities, we'll implement:

1. **Guest Communication System**
   - Welcome message templates
   - Check-in instruction scheduler
   - Thank you messages
   - Problem resolution templates

2. **Review Management**
   - Automated review requests
   - Timing based on your preferences
   - Follow-up sequences

3. **Access Management**
   - Door code generation
   - WiFi password management
   - Secure delivery system

### Phase 2: Integration & Enhancement
- Calendar synchronization
- Financial reporting
- Cleaning coordination

### Custom Scripts to Create:
- `guest_message_automation.sh`
- `checkin_scheduler.sh`
- `review_requester.sh`  
- `door_code_manager.sh`
- `property_dashboard.sh`

### Timeline:
- Week 1: Core automation scripts
- Week 2: Testing with your properties
- Week 3: Refinements and training
EOF
    
    log_info "Implementation plan created: $plan_file"
}

# Initialize on source
init_requirements_discovery

# Export main function
export -f vrbo_requirements_discovery