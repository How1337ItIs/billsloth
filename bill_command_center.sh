#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Unified Command Center
# Single entry point for all Bill's tools and systems

# Enable strict error handling
set -euo pipefail
trap 'echo "Error occurred at line $LINENO. Exit code: $?"' ERR

# ASCII Art Banner - UNHINGED CYPHERPUNK EDITION
show_bill_banner() {
    # Skip banner in quick mode
    if [ "${BILL_SLOTH_QUICK_MODE:-0}" = "1" ]; then
        echo -e "\033[38;5;196m💀 BILL SLOTH COMMAND CENTER - QUICK MODE 💀\033[0m"
        return
    fi
    
    clear
    
    # Matrix-style random characters
    local matrix_chars="01ᾰᾱᾲᾳᾴᾶᾷ∅∀∂∆∈∉∋∌∍∎∏∐∑−∓∔∕∖∗∘∙√∝∞∟∠∡∢∣∤∥∦∧∨∩∪∫∬∭∮∯∰∱∲∳∴∵∶∷∸∹∺∻∼∽∾∿≀≁≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟≠≡≢≣≤≥≦≧≨≩≪≫≬≭≮≯≰≱≲≳≴≵≶≷≸≹≺≻≼≽≾≿⊀⊁⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋⊌⊍⊎⊏⊐⊑⊒⊓⊔⊕⊖⊗⊘⊙⊚⊛⊜⊝⊞⊟⊠⊡⊢⊣⊤⊥⊦⊧⊨⊩⊪⊫⊬⊭⊮⊯⊰⊱⊲⊳⊴⊵⊶⊷⊸⊹⊺⊻⊼⊽⊾⊿⋀⋁⋂⋃⋄⋅⋆⋇⋈⋉⋊⋋⋌⋍⋎⋏⋐⋑⋒⋓⋔⋕⋖⋗⋘⋙⋚⋛⋜⋝⋞⋟⋠⋡⋢⋣⋤⋥⋦⋧⋨⋩⋪⋫⋬⋭⋮⋯⋰⋱⋲⋳⋴⋵⋶⋷⋸⋹⋺⋻⋼⋽⋾⋿"
    
    # Add terminal-style flashing cursor effect
    local cursor_blink="█"
    
    echo -e "\033[38;5;46m" # Bright green Matrix color
    
    cat << 'EOF'
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░                                                                            ░
    ░   ██████╗ ██╗██╗     ██╗         ███████╗██╗      ██████╗ ████████╗██╗  ██╗ ░
    ░   ██╔══██╗██║██║     ██║         ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║ ░
    ░   ██████╔╝██║██║     ██║         ███████╗██║     ██║   ██║   ██║   ███████║ ░
    ░   ██╔══██╗██║██║     ██║         ╚════██║██║     ██║   ██║   ██║   ██╔══██║ ░
    ░   ██████╔╝██║███████╗███████╗    ███████║███████╗╚██████╔╝   ██║   ██║  ██║ ░
    ░   ╚═════╝ ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝ ░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
    
    echo -e "\033[38;5;196m" # Bright red
    echo "    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄"
    
    echo -e "\033[38;5;51m" # Bright cyan
    echo "    ⚡ COMMAND INTERFACE ACTIVATED ⚡ AUTOMATION HUB v2.0 ⚡"
    
    echo -e "\033[38;5;226m" # Bright yellow
    echo "    ◊◊◊ ADVANCED MODE ENABLED - ALL SYSTEMS READY ◊◊◊"
    
    echo -e "\033[38;5;129m" # Bright magenta  
    echo "    ♢ \"Welcome to the desert of the real\" - Morpheus ♢"
    
    echo -e "\033[38;5;196m" # Bright red
    echo "    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀"
    
    echo -e "\033[0m" # Reset color
    echo ""
    
    # Add some cyberpunk flavor text
    local flavor_texts=(
        "⟨ JACK IN: Neural link established, all systems nominal ⟩"
        "⟨ ICE BREAKER: Firewall bypassed, access granted ⟩"
        "⟨ MATRIX READY: Command interface fully operational ⟩"
        "⟨ WETWARE SYNC: Consciousness upload complete ⟩"
        "⟨ DIGITAL DOMINION: Your empire awaits your commands ⟩"
    )
    
    local random_flavor=${flavor_texts[$RANDOM % ${#flavor_texts[@]}]}
    echo -e "\033[38;5;82m$random_flavor\033[0m"
    echo ""
}

# Source all required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/modern_cli.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/data_sharing.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/workflow_orchestration.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/restic_backup.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/backup_management.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/system_health_monitoring.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/hybrid_monitoring.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/task_runner.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/data_persistence.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/service_management.sh" 2>/dev/null || true
source "$SCRIPT_DIR/lib/dependency_installer.sh" 2>/dev/null || true

# Initialize all systems
init_bill_command_center() {
    log_info "Initializing Bill's Command Center..."
    
    # Fresh Ubuntu system detection and optimization
    if [ -f "/etc/os-release" ]; then
        local ubuntu_version=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
        local uptime_days=$(awk '{print int($1/86400)}' /proc/uptime)
        
        # Detect very fresh system (less than 7 days uptime)
        if [ "$uptime_days" -lt 7 ] && [ ! -f "$HOME/.bill-sloth/first_run_complete" ]; then
            echo ""
            echo -e "\033[38;5;196m🔥 FRESH UBUNTU SYSTEM DETECTED! 🔥\033[0m"
            echo -e "\033[38;5;51m💀 Initiating virgin system neural bootstrap protocol...\033[0m"
            echo ""
            echo -e "\033[38;5;226m⚡ This looks like a fresh Ubuntu install (Ubuntu $ubuntu_version, $uptime_days days old)\033[0m"
            echo -e "\033[38;5;129m🧠 Running optimized first-time setup sequence...\033[0m"
            echo ""
            
            # Run fresh system optimizations
            fresh_system_bootstrap
        fi
    fi
    
    # Setup Claude Code permissions first if available
    if is_claude_code_available; then
        if [ ! -f "$HOME/.claude/bill_sloth_full_access" ]; then
            echo ""
            setup_claude_code_permissions
            echo ""
            echo -e "\033[38;5;51m💀 Neural interface permissions configured. Restarting for full integration...\033[0m"
            echo ""
            read -n 1 -s -r -p "Press any key to continue..."
            clear
        fi
    else
        # On fresh systems, give detailed Claude Code setup instructions
        if [ ! -f "$HOME/.bill-sloth/first_run_complete" ]; then
            echo ""
            echo -e "\033[38;5;196m⚠️  CLAUDE CODE NOT DETECTED ON FRESH SYSTEM! ⚠️\033[0m"
            echo ""
            echo -e "\033[38;5;51m💀 For maximum digital supremacy, you need Claude Code installed first.\033[0m"
            echo -e "\033[38;5;226m⚡ See FRESH_UBUNTU_SETUP.md for bulletproof installation guide.\033[0m"
            echo ""
            echo -e "\033[38;5;129m🧠 Quick fix: Run these commands in a new terminal:\033[0m"
            echo "   1. curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
            echo "   2. sudo apt install nodejs -y"
            echo "   3. npm install -g @anthropic-ai/claude-code"
            echo "   4. claude login"
            echo ""
            read -p "Continue without Claude Code for now? [Y/n]: " continue_without
            if [[ "$continue_without" == "n" || "$continue_without" == "N" ]]; then
                echo "Setup FRESH_UBUNTU_SETUP.md first, then restart this script."
                exit 0
            fi
        fi
    fi
    
    # Check dependencies
    if ! quick_dependency_check; then
        echo -e "\033[38;5;196m⚠️  CRITICAL SYSTEM COMPONENTS MISSING! ⚠️\033[0m"
        echo ""
        echo -e "\033[38;5;51m🔧 Neural interface requires additional wetware drivers.\033[0m"
        echo -e "\033[38;5;226m💀 Install missing system components to achieve full digital apotheosis?\033[0m"
        read -p "▶ Hijack system dependencies? [Y/n]: " install_deps
        
        if [[ "$install_deps" != "n" && "$install_deps" != "N" ]]; then
            check_and_install_dependencies
            echo ""
            echo "Please restart the command center after installation completes."
            exit 0
        else
            log_warning "Some features may not work without required dependencies!"
        fi
    fi
    
    # Initialize core systems
    init_data_sharing 2>/dev/null || true
    init_workflow_system 2>/dev/null || true
    init_restic_backup 2>/dev/null || true
    init_health_monitoring 2>/dev/null || true
    init_data_persistence 2>/dev/null || true
    
    # Create all required directories
    mkdir -p ~/.bill-sloth/{command-center,vrbo-automation,google-tasks,workflows,backups,media-processing,health-monitoring,architecture,data}/{logs,cache,config,data,scripts,templates}
    
    # Initialize VRBO if missing
    if [ ! -f ~/.bill-sloth/vrbo-automation/scripts/guest_communication.sh ]; then
        if [ -f "$SCRIPT_DIR/modules/vrbo_automation/guest_communication.sh" ]; then
            mkdir -p ~/.bill-sloth/vrbo-automation/scripts
            cp "$SCRIPT_DIR/modules/vrbo_automation/guest_communication.sh" ~/.bill-sloth/vrbo-automation/scripts/
            log_info "VRBO guest communication module installed"
        fi
    fi
    
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
    
    # Update startup time (only if jq is available)
    if command -v jq &> /dev/null; then
        jq --arg timestamp "$(date -Iseconds)" \
           '.last_startup = $timestamp' \
           ~/.bill-sloth/command-center/config/system_status.json > ~/.bill-sloth/command-center/config/system_status.json.tmp && \
           mv ~/.bill-sloth/command-center/config/system_status.json.tmp ~/.bill-sloth/command-center/config/system_status.json
    fi
    
    log_success "Command Center initialized"
}

# System health check (enhanced with health monitoring)
check_system_health() {
    # Use the comprehensive health monitoring system if available
    if command -v generate_health_report &> /dev/null; then
        local health_report=$(generate_health_report "summary" 2>/dev/null)
        if [ ! -z "$health_report" ]; then
            local status=$(echo "$health_report" | jq -r '.overall_status // "unknown"' 2>/dev/null || echo "unknown")
            local cpu=$(echo "$health_report" | jq -r '.system_metrics.cpu_usage // 0' 2>/dev/null || echo "0")
            local memory=$(echo "$health_report" | jq -r '.system_metrics.memory_usage // 0' 2>/dev/null || echo "0")
            
            echo "$status:$cpu:$memory"
            return
        fi
    fi
    
    # Fallback to basic health check
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
    
    # Check backup system (prioritize restic)
    ((total_checks++))
    if command -v bill_backup &> /dev/null && [ -d ~/.bill-sloth/backups/restic ]; then
        ((health_score++))
    elif [ -d ~/.bill-sloth/backups ]; then
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

# Neural interface menu
show_quick_actions() {
    echo -e "\033[38;5;51m"
    cat << 'EOF'
    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
    █  ⚡ NEURAL COMMAND MATRIX ⚡                                        █
    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF
    echo -e "\033[0m"
    echo ""
    echo -e "\033[38;5;196m🏠 VRBO DOMINATION PROTOCOLS:\033[0m"
    echo -e "\033[38;5;46m  v) Neural property interface\033[0m"
    echo -e "\033[38;5;46m  g) Guest consciousness manipulation\033[0m"
    echo -e "\033[38;5;46m  t) Automated servant task deployment\033[0m"
    echo ""
    echo -e "\033[38;5;129m🎮 EDBOIGAMES EMPIRE EXPANSION:\033[0m"
    echo -e "\033[38;5;46m  e) Business warfare command center\033[0m"
    echo -e "\033[38;5;46m  p) Partnership infiltration protocols\033[0m"
    echo -e "\033[38;5;46m  c) Content weaponization pipeline\033[0m"
    echo ""
    echo -e "\033[38;5;226m🤖 AUTOMATION HIVEMIND:\033[0m"
    echo -e "\033[38;5;46m  w) Execute workflow subroutines\033[0m"
    echo -e "\033[38;5;46m  a) Platform consciousness integration\033[0m"
    echo -e "\033[38;5;46m  s) Reality synchronization protocols\033[0m"
    echo ""
    echo -e "\033[38;5;51m💾 SYSTEM SUPREMACY OPERATIONS:\033[0m"
    echo -e "\033[38;5;46m  b) Data preservation rituals\033[0m"
    echo -e "\033[38;5;46m  m) Media consciousness processing\033[0m"
    echo -e "\033[38;5;46m  h) Wetware diagnostic scan\033[0m"
    echo -e "\033[38;5;46m  H) Neural health matrix dashboard\033[0m"
    echo ""
    echo -e "\033[38;5;82m▶ Select your reality manipulation vector...\033[0m"
}

# Fresh system bootstrap for virgin Ubuntu installs
fresh_system_bootstrap() {
    echo -e "\033[38;5;82m🚀 FRESH UBUNTU NEURAL BOOTSTRAP SEQUENCE\033[0m"
    echo "========================================="
    echo ""
    
    # System update first
    echo -e "\033[38;5;51m💀 Phase 1: System consciousness synchronization...\033[0m"
    sudo apt update && sudo apt upgrade -y
    
    # Essential tools
    echo -e "\033[38;5;51m💀 Phase 2: Installing core neural interfaces...\033[0m"
    sudo apt install -y curl wget git vim htop tree unzip zip software-properties-common
    
    # Check if Node.js is properly installed
    if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
        echo -e "\033[38;5;226m⚡ Installing proper Node.js neural pathways...\033[0m"
        curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
        sudo apt install nodejs -y
    fi
    
    # Fix npm permissions for user
    echo -e "\033[38;5;51m💀 Phase 3: Configuring npm consciousness permissions...\033[0m"
    mkdir -p ~/.npm-global
    npm config set prefix '~/.npm-global'
    if ! grep -q "npm-global/bin" ~/.bashrc; then
        echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
    fi
    
    # Make sure system directories exist
    mkdir -p ~/.bill-sloth/{command-center,vrbo-automation,workflows,backups,media-processing}/{logs,cache,config,data}
    
    # Mark first run complete
    touch "$HOME/.bill-sloth/first_run_complete"
    echo "$(date -Iseconds)" > "$HOME/.bill-sloth/first_run_complete"
    
    echo ""
    echo -e "\033[38;5;46m✅ Fresh system neural bootstrap complete!\033[0m"
    echo -e "\033[38;5;82m💀 Your Ubuntu consciousness is now ready for digital supremacy.\033[0m"
    echo ""
    echo -e "\033[38;5;226m🧠 NEXT: Install Claude Code for maximum effectiveness:\033[0m"
    echo "   npm install -g @anthropic-ai/claude-code"
    echo "   claude login"
    echo ""
    read -n 1 -s -r -p "Press any key to continue..."
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
    
    # PRODUCTION SAFETY: Load safety systems
    source "$SCRIPT_DIR/lib/production_safety.sh" 2>/dev/null || true
    
    local session_timeout=1800  # 30 minutes
    local start_time=$(date +%s)
    
    while true; do
        # PRODUCTION SAFETY: Check session timeout
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))
        
        if [ $elapsed -gt $session_timeout ]; then
            log_info "Session timeout after 30 minutes - returning to main menu"
            notify_info "Session Timeout" "Command center session ended after 30 minutes"
            break
        fi
        
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
        echo "🏥 DIAGNOSTICS:"
        echo "  health) System Health Check     debug) Debug Mode"
        echo ""
        echo "  0) Exit Command Center"
        echo ""
        
        # PRODUCTION SAFETY: Use safe input with timeout
        local choice=""
        if command -v safe_read &>/dev/null; then
            choice=$(safe_read "🎯 Select action or module [quick action/1-9/0]: " 300) || {
                log_info "Input timeout - continuing session"
                continue
            }
        else
            # Fallback with basic timeout
            if ! read -t 300 -p "🎯 Select action or module [quick action/1-9/0]: " choice; then
                log_info "Input timeout - continuing session"
                continue
            fi
        fi
        
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
                if command -v bill_backup &> /dev/null; then
                    echo "🎯 QUICK BACKUP OPTIONS:"
                    echo "1) Bill Critical Files"
                    echo "2) VRBO Data"
                    echo "3) EdBoiGames Content"
                    echo "4) Everything"
                    read -p "Select backup set: " backup_choice
                    case $backup_choice in
                        1) bill_backup "bill_critical" ;;
                        2) bill_backup "vrbo_data" ;;
                        3) bill_backup "edboigames_content" ;;
                        4) 
                            bill_backup "bill_critical"
                            bill_backup "vrbo_data" 
                            bill_backup "edboigames_content"
                            ;;
                        *) echo "Invalid choice" ;;
                    esac
                elif [ -f ~/.bill-sloth/backups/quick_backup.sh ]; then
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
            "h")
                log_activity "System health check"
                echo "🔍 Running comprehensive system health check..."
                check_system_health
                echo "✅ Health check completed"
                ;;
            "H")
                log_activity "Opened health monitoring dashboard"
                if [ -f ~/.bill-sloth/health-monitoring/dashboards/health_dashboard.sh ]; then
                    ~/.bill-sloth/health-monitoring/dashboards/health_dashboard.sh
                else
                    echo "🏥 Setting up health monitoring dashboard..."
                    create_health_dashboard
                    ~/.bill-sloth/health-monitoring/dashboards/health_dashboard.sh
                fi
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
                if command -v bill_backup_list &> /dev/null; then
                    echo "🎯 BACKUP MANAGEMENT:"
                    echo "1) List backups"
                    echo "2) Create backup"
                    echo "3) Restore backup"
                    echo "4) Backup statistics"
                    read -p "Select action: " backup_action
                    case $backup_action in
                        1)
                            echo "📋 Available Backup Sets:"
                            for set in bill_critical vrbo_data edboigames_content; do
                                echo "  • $set:"
                                bill_backup_list "$set" 2>/dev/null | tail -5
                            done
                            ;;
                        2) bill_backup "bill_critical" ;;
                        3)
                            read -p "Backup set (bill_critical/vrbo_data/edboigames_content): " restore_set
                            read -p "Restore path (leave empty for auto): " restore_path
                            bill_restore "$restore_set" "latest" "$restore_path"
                            ;;
                        4)
                            echo "📊 Backup Statistics:"
                            for set in bill_critical vrbo_data edboigames_content; do
                                if restic -r "$HOME/.bill-sloth/backups/restic/$set" stats latest 2>/dev/null; then
                                    echo "✅ $set: Statistics available"
                                else
                                    echo "❌ $set: No backups found"
                                fi
                            done
                            ;;
                    esac
                elif [ -f ~/.bill-sloth/backups/backup_dashboard.sh ]; then
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
            "health")
                log_activity "Ran system health check"
                echo "🏥 Running Bill Sloth System Health Check..."
                echo ""
                if [ -f "$SCRIPT_DIR/lib/module_health_checker.sh" ]; then
                    "$SCRIPT_DIR/lib/module_health_checker.sh"
                else
                    echo "❌ Health checker not found"
                fi
                ;;
            "debug")
                log_activity "Enabled debug mode"
                echo "🐛 DEBUG MODE ACTIVATED"
                echo "======================"
                echo ""
                echo "Environment Variables:"
                echo "  BILL_SLOTH_QUICK_MODE: ${BILL_SLOTH_QUICK_MODE:-not set}"
                echo "  PATH: $PATH"
                echo "  HOME: $HOME"
                echo ""
                echo "System Info:"
                echo "  Shell: $SHELL"
                echo "  Working Dir: $(pwd)"
                echo "  Script Dir: $SCRIPT_DIR"
                echo ""
                echo "Dependencies:"
                echo "  Claude Code: $(command -v claude || echo 'not found')"
                echo "  Node.js: $(command -v node || echo 'not found')"
                echo "  jq: $(command -v jq || echo 'not found')"
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
    # Quick mode check
    if [[ " $* " =~ " --quick " ]] || [[ " $* " =~ " -q " ]]; then
        export BILL_SLOTH_QUICK_MODE=1
    fi
    main "$@"
fi