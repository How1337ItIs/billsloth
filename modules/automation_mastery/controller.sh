#!/bin/bash
# Automation Mastery Controller - Main Navigation and Coordination
# Replaces the monolithic automation_mastery_interactive.sh with modular approach


set -euo pipefail
source "$SCRIPT_DIR/../../lib/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Source interactive library
source "$SCRIPT_DIR/../../lib/interactive.sh" 2>/dev/null || {
    echo "🤖 AUTOMATION MASTERY"
    echo "===================="
}

# Component source directory
COMPONENTS_DIR="$SCRIPT_DIR"

# Load all automation components
load_automation_components() {
    local components=(
        "assessment.sh"
        "recommendations.sh"
        "cloud_platforms.sh"
        "ai_automation.sh"
        "neurodivergent_strategies.sh"
        "business_automation.sh"
        "advanced_concepts.sh"
    )
    
    for component in "${components[@]}"; do
        local component_path="$COMPONENTS_DIR/$component"
        if [ -f "$component_path" ]; then
            source "$component_path"
            log_debug "Loaded component: $component"
        else
            log_warning "Component not found: $component"
        fi
    done
}

# Main automation mastery interface
show_automation_banner() {
    print_header "🤖 AUTOMATION MASTERY"
    
    echo "Transform your entire digital workflow with cloud automation,"
    echo "AI-powered tools, and neurodivergent-friendly systems."
    echo ""
    echo "🧠 Perfect for ADHD, dyslexia, executive dysfunction, and anyone who wants their"
    echo "technology to work FOR them instead of against them."
    echo ""
}

# Main menu system
automation_main_menu() {
    while true; do
        show_automation_banner
        
        print_separator "-" 60
        echo "📋 AUTOMATION MASTERY MENU"
        print_separator "-" 60
        
        echo ""
        echo "🔍 ASSESSMENT & PLANNING:"
        echo "  1) Personal Workflow Assessment    - Analyze your current digital habits"
        echo "  2) Custom Recommendations         - Get personalized automation suggestions"
        echo ""
        
        echo "☁️ CLOUD AUTOMATION PLATFORMS:"
        echo "  3) Zapier Setup & Workflows        - Connect 5000+ apps and services"
        echo "  4) IFTTT (If This Then That)       - Simple trigger-based automation"
        echo "  5) Power Automate (Microsoft)      - Enterprise-grade workflow automation"
        echo "  6) Make (formerly Integromat)      - Visual automation builder"
        echo "  7) Node-RED                        - Low-code programming for IoT"
        echo "  8) Home Assistant                  - Smart home automation hub"
        echo ""
        
        echo "🤖 AI-POWERED AUTOMATION:"
        echo "  9) AI Automation Tools             - ChatGPT, Claude, and workflow AI"
        echo " 10) Smart Email & Calendar         - AI assistants for communication"
        echo " 11) Content Creation Automation    - AI writing, social media, and more"
        echo ""
        
        echo "🧠 NEURODIVERGENT-SPECIFIC:"
        echo " 12) ADHD Automation Strategies     - Focus, reminders, and habit building"
        echo " 13) Executive Function Support     - Breaking down complex tasks"
        echo " 14) Sensory & Accessibility        - Automation for sensory processing"
        echo ""
        
        echo "💼 BUSINESS & ADVANCED:"
        echo " 15) Business Process Automation    - CRM, invoicing, project management"
        echo " 16) Advanced Concepts              - APIs, webhooks, custom integrations"
        echo " 17) Automation Security             - Privacy and security best practices"
        echo ""
        
        echo "📚 LEARNING & SUPPORT:"
        echo " 18) Automation Bootcamp           - Comprehensive learning path"
        echo " 19) Community Resources           - Forums, templates, and examples"
        echo " 20) Troubleshooting Guide         - Fix common automation issues"
        echo ""
        
        echo "📊 PROGRESS & OPTIMIZATION:"
        echo " 21) Track Your Automations        - Monitor and optimize workflows"
        echo " 22) ROI Calculator                - Measure time and cost savings"
        echo " 23) Automation Health Check       - Audit your current automations"
        echo ""
        
        echo " 0) Exit to Main Menu"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select an option (0-23)" 30 "0")
        
        case "$choice" in
            1) assess_personal_workflows ;;
            2) generate_recommendations ;;
            3) setup_zapier ;;
            4) setup_ifttt ;;
            5) setup_power_automate ;;
            6) setup_make ;;
            7) setup_node_red ;;
            8) setup_home_assistant ;;
            9) explore_ai_automation ;;
            10) setup_ai_email_calendar ;;
            11) setup_content_automation ;;
            12) neurodivergent_automation_strategies ;;
            13) executive_function_automation ;;
            14) accessibility_automation ;;
            15) business_automation ;;
            16) advanced_automation_concepts ;;
            17) automation_security ;;
            18) automation_bootcamp ;;
            19) community_resources ;;
            20) troubleshooting_guide ;;
            21) track_automations ;;
            22) roi_calculator ;;
            23) automation_health_check ;;
            0) 
                log_info "Exiting Automation Mastery"
                break
                ;;
            *)
                log_warning "Invalid option: $choice"
                echo "Please select a number between 0 and 23."
                sleep 2
                ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to return to menu..."
            echo ""
        fi
    done
}

# Placeholder functions for features not yet implemented
setup_ai_email_calendar() {
    log_info "AI Email & Calendar automation coming in future update"
    echo "This feature will help you set up AI assistants for email management and calendar scheduling."
}

setup_content_automation() {
    log_info "Content Creation automation coming in future update"
    echo "This feature will help you automate content creation for social media, blogs, and marketing."
}

executive_function_automation() {
    log_info "Executive Function support coming in future update"
    echo "This feature will provide automation strategies for executive dysfunction support."
}

accessibility_automation() {
    log_info "Accessibility automation coming in future update"
    echo "This feature will help you set up automation for sensory processing and accessibility needs."
}

automation_security() {
    log_info "Automation Security guide coming in future update"
    echo "This feature will cover privacy and security best practices for automation."
}

community_resources() {
    log_info "Community Resources coming in future update"
    echo "This feature will connect you with automation communities and resources."
}

troubleshooting_guide() {
    log_info "Troubleshooting Guide coming in future update"
    echo "This feature will help you fix common automation issues."
}

track_automations() {
    log_info "Automation Tracking coming in future update"
    echo "This feature will help you monitor and optimize your automations."
}

roi_calculator() {
    log_info "ROI Calculator coming in future update"
    echo "This feature will help you calculate time and cost savings from automation."
}

automation_health_check() {
    log_info "Automation Health Check coming in future update"
    echo "This feature will audit your current automations for optimization opportunities."
}

# Main execution
main() {
    # Load all components
    load_automation_components
    
    # Show the main menu
    automation_main_menu
}

# Export main functions
export -f automation_main_menu show_automation_banner load_automation_components

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi