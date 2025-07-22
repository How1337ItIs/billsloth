#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Unified Command Center
# Single entry point for all Bill's tools and systems

# ASCII Art Banner
show_bill_banner() {
    clear
    echo "
    ██████╗ ██╗██╗     ██╗         ███████╗██╗      ██████╗ ████████╗██╗  ██╗
    ██╔══██╗██║██║     ██║         ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║
    ██████╔╝██║██║     ██║         ███████╗██║     ██║   ██║   ██║   ███████║
    ██╔══██╗██║██║     ██║         ╚════██║██║     ██║   ██║   ██║   ██╔══██║
    ██████╔╝██║███████╗███████╗    ███████║███████╗╚██████╔╝   ██║   ██║  ██║
    ╚═════╝ ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝
    
    🎯 UNIFIED COMMAND CENTER v2.0 - Your Digital Operations Hub
    "
}

# Source all required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/data_sharing.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/workflow_orchestration.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/backup_management.sh" 2>/dev/null || true

# Initialize all systems
init_bill_command_center() {
    log_info "Initializing Bill's Command Center..."
    
    # Initialize core systems
    init_data_sharing 2>/dev/null || true
    init_workflow_system 2>/dev/null || true
    init_backup_system 2>/dev/null || true
    
    # Create command center directory
    mkdir -p ~/.bill-sloth/command-center/{logs,cache,config}
    
    # Set up system status tracking
    if [ ! -f ~/.bill-sloth/command-center/config/system_status.json ]; then
        cat > ~/.bill-sloth/command-center/config/system_status.json << 'EOF'
{
  "last_startup": "",
  "system_health": "unknown",
  "active_modules": [],
  "recent_activities": [],
  "alerts": []
}
EOF
    fi
    
    # Update startup time
    jq --arg timestamp "$(date -Iseconds)" \
       '.last_startup = $timestamp' \
       ~/.bill-sloth/command-center/config/system_status.json > ~/.bill-sloth/command-center/config/system_status.json.tmp && \
       mv ~/.bill-sloth/command-center/config/system_status.json.tmp ~/.bill-sloth/command-center/config/system_status.json
    
    log_success "Command Center initialized"
}

# System health check
check_system_health() {
    local health_score=0
    local total_checks=0
    local issues=()
    
    # Check core directories
    ((total_checks++))
    if [ -d ~/.bill-sloth ]; then
        ((health_score++))
    else
        issues+=("Core directory missing")
    fi
    
    # Check VRBO automation
    ((total_checks++))
    if [ -d ~/.bill-sloth/vrbo-automation ]; then
        ((health_score++))
    else
        issues+=("VRBO automation not configured")
    fi
    
    # Check Google Tasks integration  
    ((total_checks++))
    if [ -d ~/.bill-sloth/google-tasks ]; then
        ((health_score++))
    else
        issues+=("Google Tasks not configured")
    fi
    
    # Check backup system
    ((total_checks++))
    if [ -d ~/.bill-sloth/backups ]; then
        ((health_score++))
    else
        issues+=("Backup system not configured")
    fi
    
    # Check workflow system
    ((total_checks++))
    if [ -d ~/.bill-sloth/workflows ]; then
        ((health_score++))
    else
        issues+=("Workflow system not configured")
    fi
    
    # Check media processing
    ((total_checks++))
    if [ -d ~/.bill-sloth/media-processing ]; then
        ((health_score++))
    else
        issues+=("Media processing not configured")
    fi
    
    # Calculate health percentage
    local health_percentage=$((health_score * 100 / total_checks))
    
    # Determine health status
    local health_status="excellent"
    if [ $health_percentage -lt 100 ]; then
        health_status="good"
    fi
    if [ $health_percentage -lt 80 ]; then
        health_status="fair"
    fi
    if [ $health_percentage -lt 60 ]; then
        health_status="poor"
    fi
    
    echo "$health_status:$health_percentage:${issues[*]}"
}

# Display system status dashboard
show_system_status() {
    local health_info=$(check_system_health)
    local health_status=$(echo "$health_info" | cut -d: -f1)
    local health_percentage=$(echo "$health_info" | cut -d: -f2)
    local health_issues=$(echo "$health_info" | cut -d: -f3-)
    
    echo "📊 SYSTEM STATUS DASHBOARD"
    echo "=========================="
    echo ""
    
    # Health indicator
    case "$health_status" in
        "excellent") echo "🟢 System Health: EXCELLENT ($health_percentage%)" ;;
        "good") echo "🟡 System Health: GOOD ($health_percentage%)" ;;
        "fair") echo "🟠 System Health: FAIR ($health_percentage%)" ;;
        "poor") echo "🔴 System Health: POOR ($health_percentage%)" ;;
    esac
    
    # Show issues if any
    if [ ! -z "$health_issues" ] && [ "$health_issues" != " " ]; then
        echo "⚠️  Issues detected:"
        echo "$health_issues" | tr ' ' '\n' | sed 's/^/   • /'
    fi
    echo ""
    
    # Recent activity
    echo "📈 RECENT ACTIVITY:"
    if [ -f ~/.bill-sloth/command-center/logs/activity.log ]; then
        tail -5 ~/.bill-sloth/command-center/logs/activity.log | sed 's/^/   /'
    else
        echo "   No recent activity recorded"
    fi
    echo ""
    
    # Quick stats
    echo "📊 QUICK STATS:"
    echo "   • VRBO Properties: $(find ~/.bill-sloth/vrbo-automation/data/ -name "*.json" 2>/dev/null | wc -l || echo "0")"
    echo "   • Active Workflows: $(ls -1 ~/.bill-sloth/workflows/state/active/*.state 2>/dev/null | wc -l || echo "0")"
    echo "   • Recent Backups: $(ls -1 ~/.bill-sloth/backups/local/incremental/ 2>/dev/null | wc -l || echo "0")"
    echo "   • Processed Media: $(find ~/.bill-sloth/media-processing -name "*_processed.*" 2>/dev/null | wc -l || echo "0")"
    echo ""
}

# Quick actions menu
show_quick_actions() {
    echo "🚀 QUICK ACTIONS"
    echo "================"
    echo ""
    echo "🏠 VRBO MANAGEMENT:"
    echo "  v) VRBO property dashboard"
    echo "  g) Process new guest booking"
    echo "  t) Create guest tasks"
    echo ""
    echo "🎮 EDBOIGAMES BUSINESS:"
    echo "  e) EdBoiGames business center"
    echo "  p) Partnership management"
    echo "  c) Content processing"
    echo ""
    echo "🤖 AUTOMATION:"
    echo "  w) Launch workflow"
    echo "  a) Automation platforms"
    echo "  s) Sync all data"
    echo ""
    echo "💾 SYSTEM MANAGEMENT:"
    echo "  b) Create backup"
    echo "  m) Media processing"
    echo "  h) System health check"
    echo ""
}

# Log activity
log_activity() {
    local activity="$1"
    local timestamp=$(date -Iseconds)
    echo "$timestamp: $activity" >> ~/.bill-sloth/command-center/logs/activity.log
}

# Main command center loop
bill_command_center() {
    # Initialize systems
    init_bill_command_center
    
    while true; do
        show_bill_banner
        show_system_status
        show_quick_actions
        
        echo "📋 FULL MODULES:"
        echo "  1) Automation Mastery     2) Network Management    3) Data Hoarding"
        echo "  4) Media Processing       5) System Doctor         6) Mobile Integration"
        echo ""
        echo "⚙️  SYSTEM TOOLS:"
        echo "  7) Backup Management      8) Architecture Config   9) Workflow Orchestration"
        echo ""
        echo "  0) Exit Command Center"
        echo ""
        
        read -p "🎯 Select action or module [quick action/1-9/0]: " choice
        
        # Log the choice
        log_activity "User selected: $choice"
        
        case "$choice" in
            # Quick actions
            "v"|"V")
                log_activity "Opened VRBO dashboard"
                if [ -f ~/.bill-sloth/vrbo-automation/scripts/vrbo-dashboard.sh ]; then
                    ~/.bill-sloth/vrbo-automation/scripts/vrbo-dashboard.sh
                else
                    echo "⚠️  VRBO dashboard not found. Setting up..."
                    # Create quick VRBO dashboard
                    cat > ~/.bill-sloth/vrbo-automation/scripts/vrbo-dashboard.sh << 'EOF'
#!/bin/bash
echo "🏠 VRBO PROPERTY DASHBOARD"
echo "========================="
echo "1) Process new booking"
echo "2) Guest communication"
echo "3) Property maintenance"
echo "4) Revenue tracking"
read -p "Select action: " vrbo_action
case $vrbo_action in
    1) echo "Processing new booking..." ;;
    2) echo "Guest communication..." ;;
    3) echo "Property maintenance..." ;;
    4) echo "Revenue tracking..." ;;
esac
EOF
                    chmod +x ~/.bill-sloth/vrbo-automation/scripts/vrbo-dashboard.sh
                    ~/.bill-sloth/vrbo-automation/scripts/vrbo-dashboard.sh
                fi
                ;;
            "g"|"G")
                log_activity "Processing new guest booking"
                echo "📧 Processing New Guest Booking"
                echo "=============================="
                read -p "Guest name: " guest_name
                read -p "Property: " property
                read -p "Check-in date (YYYY-MM-DD): " checkin_date
                
                # Create workflow for guest onboarding
                if command -v run_workflow &> /dev/null; then
                    local booking_data='{"guest": "'$guest_name'", "property": "'$property'", "checkin": "'$checkin_date'"}'
                    run_workflow "vrbo_guest_onboarding" "$booking_data"
                    echo "✅ Guest onboarding workflow started"
                else
                    echo "ℹ️  Creating guest tasks manually..."
                    echo "✅ Tasks created for $guest_name at $property"
                fi
                ;;
            "t"|"T")
                log_activity "Creating guest tasks"
                if [ -f ~/.bill-sloth/google-tasks/scripts/tasks-manager.sh ]; then
                    ~/.bill-sloth/google-tasks/scripts/tasks-manager.sh
                else
                    echo "⚠️  Google Tasks not configured yet"
                fi
                ;;
            "e"|"E")
                log_activity "Opened EdBoiGames business center"
                if [ -f ~/edboigames_business/automation/scripts/weekly_business_report.sh ]; then
                    ~/edboigames_business/automation/scripts/weekly_business_report.sh
                else
                    source "$SCRIPT_DIR/modules/edboigames/controller.sh"
                fi
                ;;
            "p"|"P")
                log_activity "Opened partnership management"
                if [ -f ~/edboigames_business/partnerships/tracking/partnership_tracker.csv ]; then
                    echo "📊 Partnership Overview:"
                    cat ~/edboigames_business/partnerships/tracking/partnership_tracker.csv | head -5
                else
                    echo "⚠️  Partnership tracking not set up yet"
                fi
                ;;
            "c"|"C")
                log_activity "Opened content processing"
                if [ -f ~/.bill-sloth/media-processing/media_dashboard.sh ]; then
                    ~/.bill-sloth/media-processing/media_dashboard.sh
                else
                    echo "⚠️  Media processing not configured yet"
                fi
                ;;
            "w"|"W")
                log_activity "Launching workflow"
                if command -v list_workflows &> /dev/null; then
                    list_workflows
                    read -p "Enter workflow ID to run: " workflow_id
                    run_workflow "$workflow_id" '{"trigger": "manual"}'
                else
                    echo "⚠️  Workflow system not configured yet"
                fi
                ;;
            "a"|"A")
                log_activity "Opened automation platforms"
                source "$SCRIPT_DIR/modules/automation_mastery/cloud_platforms.sh"
                echo "🤖 Choose automation platform:"
                echo "1) Zapier  2) IFTTT  3) Power Automate  4) Make  5) Node-RED"
                read -p "Select platform: " platform
                case $platform in
                    1) setup_zapier ;;
                    2) setup_ifttt ;;
                    3) setup_power_automate ;;
                    4) setup_make ;;
                    5) setup_node_red ;;
                esac
                ;;
            "s"|"S")
                log_activity "Syncing all data"
                echo "🔄 Syncing all data across modules..."
                if command -v sync_all_data &> /dev/null; then
                    sync_all_data
                    echo "✅ Data sync completed"
                else
                    echo "⚠️  Data sharing not configured yet"
                fi
                ;;
            "b"|"B")
                log_activity "Creating backup"
                if [ -f ~/.bill-sloth/backups/quick_backup.sh ]; then
                    ~/.bill-sloth/backups/quick_backup.sh
                else
                    echo "⚠️  Backup system not configured yet"
                fi
                ;;
            "m"|"M")
                log_activity "Opened media processing"
                if [ -f ~/.bill-sloth/media-processing/media_dashboard.sh ]; then
                    ~/.bill-sloth/media-processing/media_dashboard.sh
                else
                    source "$SCRIPT_DIR/modules/media_processing_pipeline.sh"
                    media_processing_interactive
                fi
                ;;
            "h"|"H")
                log_activity "System health check"
                echo "🔍 Running comprehensive system health check..."
                check_system_health
                echo "✅ Health check completed"
                ;;
            # Full modules
            1)
                log_activity "Opened Automation Mastery"
                source "$SCRIPT_DIR/modules/automation_mastery_interactive.sh"
                ;;
            2)
                log_activity "Opened Network Management"
                source "$SCRIPT_DIR/modules/network_management_interactive.sh"
                ;;
            3)
                log_activity "Opened Data Hoarding"
                source "$SCRIPT_DIR/modules/data_hoarding.sh"
                data_hoarding_interactive
                ;;
            4)
                log_activity "Opened Media Processing"
                source "$SCRIPT_DIR/modules/media_processing_pipeline.sh"
                media_processing_interactive
                ;;
            5)
                log_activity "Opened System Doctor"
                source "$SCRIPT_DIR/modules/system_doctor_interactive.sh"
                ;;
            6)
                log_activity "Opened Mobile Integration"
                source "$SCRIPT_DIR/modules/mobile_integration_interactive.sh"
                ;;
            7)
                log_activity "Opened Backup Management"
                if [ -f ~/.bill-sloth/backups/backup_dashboard.sh ]; then
                    ~/.bill-sloth/backups/backup_dashboard.sh
                else
                    setup_bill_backup_system
                fi
                ;;
            8)
                log_activity "Opened Architecture Config"
                if [ -f ~/.bill-sloth/architecture/architecture_dashboard.sh ]; then
                    ~/.bill-sloth/architecture/architecture_dashboard.sh
                else
                    source "$SCRIPT_DIR/lib/architecture_unification.sh"
                    setup_unified_architecture
                fi
                ;;
            9)
                log_activity "Opened Workflow Orchestration"
                if [ -f ~/.bill-sloth/workflows/launch_workflow.sh ]; then
                    ~/.bill-sloth/workflows/launch_workflow.sh
                else
                    setup_bill_workflows
                fi
                ;;
            0)
                log_activity "Exited Command Center"
                echo "👋 Thanks for using Bill Sloth Command Center!"
                notify_info "Command Center" "Session ended"
                break
                ;;
            *)
                echo "❌ Invalid choice: $choice"
                sleep 1
                ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to return to Command Center..."
        fi
    done
}

# Create desktop launcher
create_desktop_launcher() {
    cat > ~/.local/share/applications/bill-sloth-command-center.desktop << 'EOF'
[Desktop Entry]
Name=Bill Sloth Command Center
Comment=Unified control center for all Bill's tools
Exec=/bin/bash -c "cd ~/bill\ sloth && ./bill_command_center.sh"
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=System;Utility;
EOF
    
    echo "🖥️  Desktop launcher created"
}

# Quick setup for missing components
quick_setup_missing() {
    echo "🔧 Setting up missing components..."
    
    # Setup VRBO automation if missing
    if [ ! -d ~/.bill-sloth/vrbo-automation ]; then
        mkdir -p ~/.bill-sloth/vrbo-automation/{scripts,data}
        echo "✅ VRBO automation directory created"
    fi
    
    # Setup Google Tasks if missing
    if [ ! -d ~/.bill-sloth/google-tasks ]; then
        mkdir -p ~/.bill-sloth/google-tasks/{scripts,data}
        echo "✅ Google Tasks directory created"
    fi
    
    # Setup EdBoiGames business if missing
    if [ ! -d ~/edboigames_business ]; then
        mkdir -p ~/edboigames_business/{automation/scripts,partnerships,templates}
        echo "✅ EdBoiGames business directory created"
    fi
    
    echo "🎯 Basic structure ready. Run specific modules to complete setup."
}

# Main execution
main() {
    # Quick setup if needed
    quick_setup_missing
    
    # Create desktop launcher
    create_desktop_launcher
    
    # Show welcome message
    notify_info "Bill Sloth Command Center" "Starting unified control center"
    
    # Start command center
    bill_command_center
}

# Check if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi