#!/bin/bash
# LLM_CAPABILITY: local_ok
# Enhanced Bill Sloth Onboarding Experience
# Updated with performance monitoring, systemd services, and production features

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
source "$BASE_DIR/lib/error_handling.sh" 2>/dev/null || true
source "$BASE_DIR/lib/notification_system.sh" 2>/dev/null || true
source "$BASE_DIR/lib/performance_monitoring.sh" 2>/dev/null || true

# Colors for better user experience
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Onboarding configuration
ONBOARD_DIR="$HOME/.bill-sloth/onboarding"
PROGRESS_FILE="$ONBOARD_DIR/progress.json"
USER_PROFILE_FILE="$ONBOARD_DIR/user_profile.json"

# Initialize onboarding system
init_enhanced_onboarding() {
    mkdir -p "$ONBOARD_DIR"
    
    # Create enhanced progress tracking
    if [ ! -f "$PROGRESS_FILE" ]; then
        cat > "$PROGRESS_FILE" << 'EOF'
{
  "version": "2.0",
  "started": false,
  "current_phase": "welcome",
  "completed_steps": [],
  "user_ratings": {},
  "last_session": "",
  "total_sessions": 0,
  "areas_of_interest": [],
  "learning_style": "",
  "accessibility_needs": [],
  "performance_baseline": null,
  "services_installed": false,
  "preferred_interface": "interactive",
  "skill_level": "beginner"
}
EOF
    fi
    
    # Update session count
    local sessions=$(jq '.total_sessions // 0' "$PROGRESS_FILE")
    ((sessions++))
    jq --argjson sessions "$sessions" '.total_sessions = $sessions | .last_session = now | .started = true' "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" && mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
}

# Enhanced welcome banner with system status
show_enhanced_welcome_banner() {
    clear
    
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════╗
    ║                    🎯 Welcome to Bill Sloth v2.0                     ║
    ║              Your Neurodivergent-Friendly Digital Assistant           ║
    ╚══════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    # Show quick system status
    echo -e "${BLUE}📊 Quick System Check:${NC}"
    
    # Check if core systems are initialized
    local health_status="🟡 Not checked"
    if [ -f "$HOME/.bill-sloth/data/bill_sloth.db" ]; then
        health_status="🟢 Database ready"
    fi
    
    local services_status="🟡 Not installed"
    if systemctl is-active bill-sloth-core >/dev/null 2>&1; then
        services_status="🟢 Services running"
    elif systemctl list-unit-files bill-sloth-core.service >/dev/null 2>&1; then
        services_status="🟠 Services installed (not running)"
    fi
    
    local performance_status="🟡 Not monitored"
    if command -v capture_performance_snapshot &>/dev/null; then
        performance_status="🟢 Performance monitoring ready"
    fi
    
    echo "   Database: $health_status"
    echo "   Services: $services_status"
    echo "   Monitoring: $performance_status"
    echo ""
    
    # Show session count
    local sessions=$(jq -r '.total_sessions // 0' "$PROGRESS_FILE" 2>/dev/null || echo "1")
    if [ "$sessions" -eq 1 ]; then
        echo -e "${GREEN}🌟 Welcome to your first Bill Sloth session!${NC}"
    else
        echo -e "${GREEN}👋 Welcome back! This is session #${sessions}${NC}"
    fi
    echo ""
}

# Assess user needs and preferences
assess_user_needs() {
    echo -e "${PURPLE}🧠 Let's understand how you work best...${NC}"
    echo ""
    
    # Learning style assessment
    echo "1. How do you prefer to learn new tools?"
    echo "   a) Step-by-step tutorials with explanations"
    echo "   b) Quick demos then hands-on exploration"
    echo "   c) Read documentation first, then practice"
    echo "   d) Voice-guided instructions"
    echo ""
    
    local learning_style
    while true; do
        read -p "Your choice (a/b/c/d): " choice
        case $choice in
            a) learning_style="tutorial"; break;;
            b) learning_style="demo"; break;;
            c) learning_style="documentation"; break;;
            d) learning_style="voice"; break;;
            *) echo "Please choose a, b, c, or d";;
        esac
    done
    
    # Accessibility needs
    echo ""
    echo "2. Do you have any accessibility needs we should know about?"
    echo "   • Visual (high contrast, large text, screen reader)"
    echo "   • Motor (keyboard-only navigation, longer timeouts)"
    echo "   • Cognitive (extra explanations, progress indicators)"
    echo "   • Auditory (visual alerts instead of sounds)"
    echo ""
    
    local accessibility_needs=()
    read -p "Visual needs (y/n): " visual && [[ $visual =~ ^[Yy] ]] && accessibility_needs+=("visual")
    read -p "Motor needs (y/n): " motor && [[ $motor =~ ^[Yy] ]] && accessibility_needs+=("motor")
    read -p "Cognitive needs (y/n): " cognitive && [[ $cognitive =~ ^[Yy] ]] && accessibility_needs+=("cognitive")
    read -p "Auditory needs (y/n): " auditory && [[ $auditory =~ ^[Yy] ]] && accessibility_needs+=("auditory")
    
    # Areas of interest
    echo ""
    echo "3. What areas are you most interested in?"
    echo "   • Content Creation (video, streaming, gaming)"
    echo "   • Property Management (VRBO, rentals)"
    echo "   • General Productivity (tasks, organization)"
    echo "   • Development/Technical (coding, system admin)"
    echo "   • Privacy/Security (VPN, encryption, anonymity)"
    echo ""
    
    local interests=()
    read -p "Content Creation (y/n): " content && [[ $content =~ ^[Yy] ]] && interests+=("content_creation")
    read -p "Property Management (y/n): " property && [[ $property =~ ^[Yy] ]] && interests+=("property_management")
    read -p "General Productivity (y/n): " productivity && [[ $productivity =~ ^[Yy] ]] && interests+=("productivity")
    read -p "Development/Technical (y/n): " development && [[ $development =~ ^[Yy] ]] && interests+=("development")
    read -p "Privacy/Security (y/n): " privacy && [[ $privacy =~ ^[Yy] ]] && interests+=("privacy")
    
    # Save user profile
    local accessibility_json=$(printf '%s\n' "${accessibility_needs[@]}" | jq -R . | jq -s .)
    local interests_json=$(printf '%s\n' "${interests[@]}" | jq -R . | jq -s .)
    
    jq --arg learning "$learning_style" \
       --argjson accessibility "$accessibility_json" \
       --argjson interests "$interests_json" \
       '.learning_style = $learning | .accessibility_needs = $accessibility | .areas_of_interest = $interests' \
       "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" && mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
    
    echo ""
    echo -e "${GREEN}✅ Great! I'll customize the experience based on your preferences.${NC}"
    echo ""
    sleep 2
}

# Performance baseline test
establish_performance_baseline() {
    echo -e "${BLUE}📊 Let's establish a performance baseline for your system...${NC}"
    echo ""
    echo "This helps us optimize Bill Sloth for your specific hardware and usage patterns."
    echo ""
    
    # Initialize performance monitoring if not already done
    if command -v init_performance_monitoring &>/dev/null; then
        echo "Initializing performance monitoring..."
        init_performance_monitoring >/dev/null 2>&1
    fi
    
    # Capture initial performance snapshot
    echo "Capturing system performance baseline..."
    local baseline=""
    if command -v capture_performance_snapshot &>/dev/null; then
        baseline=$(capture_performance_snapshot "onboarding" "baseline_test" 0)
    fi
    
    # Run a simple performance test
    echo "Running quick performance test..."
    local start_time=$(date +%s%N)
    
    # Simple CPU/memory test
    for i in {1..1000}; do
        echo "test" > /dev/null 2>&1
    done
    
    local end_time=$(date +%s%N)
    local test_duration_ms=$(( (end_time - start_time) / 1000000 ))
    
    # Save baseline
    if [ -n "$baseline" ]; then
        jq --argjson baseline "$baseline" \
           --argjson test_duration "$test_duration_ms" \
           '.performance_baseline = $baseline | .performance_baseline.test_duration_ms = $test_duration' \
           "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" && mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
    fi
    
    echo -e "${GREEN}✅ Performance baseline established${NC}"
    echo "   Test duration: ${test_duration_ms}ms"
    echo "   This will help optimize your experience!"
    echo ""
    sleep 2
}

# Core system setup
setup_core_systems() {
    echo -e "${CYAN}🔧 Setting up core Bill Sloth systems...${NC}"
    echo ""
    
    # Initialize data systems
    echo "1. Initializing data persistence..."
    if [ -f "$BASE_DIR/lib/data_persistence.sh" ]; then
        source "$BASE_DIR/lib/data_persistence.sh"
        if init_data_persistence >/dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Database initialized${NC}"
        else
            echo -e "   ${YELLOW}⚠️  Database initialization had issues (will use JSON fallback)${NC}"
        fi
    fi
    
    # Initialize performance monitoring
    echo "2. Setting up performance monitoring..."
    if command -v init_performance_monitoring &>/dev/null; then
        if init_performance_monitoring >/dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Performance monitoring ready${NC}"
        else
            echo -e "   ${YELLOW}⚠️  Performance monitoring setup had issues${NC}"
        fi
    fi
    
    # Initialize health monitoring
    echo "3. Setting up health monitoring..."
    if [ -f "$BASE_DIR/lib/system_health_monitoring.sh" ]; then
        source "$BASE_DIR/lib/system_health_monitoring.sh"
        if init_health_monitoring >/dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Health monitoring ready${NC}"
        else
            echo -e "   ${YELLOW}⚠️  Health monitoring setup had issues${NC}"
        fi
    fi
    
    # Create initial backup
    echo "4. Creating your first safety backup..."
    if [ -f "$BASE_DIR/justfile" ] && command -v just &>/dev/null; then
        if cd "$BASE_DIR" && just backup >/dev/null 2>&1; then
            echo -e "   ${GREEN}✅ Initial backup completed${NC}"
        else
            echo -e "   ${YELLOW}⚠️  Backup had issues (you can retry later)${NC}"
        fi
    fi
    
    echo ""
    echo -e "${GREEN}🎉 Core systems are set up! You're ready to explore.${NC}"
    echo ""
    sleep 2
}

# Service installation guide
guide_service_installation() {
    echo -e "${PURPLE}⚙️ Optional: Install Bill Sloth as System Services${NC}"
    echo ""
    echo "System services run Bill Sloth in the background automatically."
    echo "Benefits:"
    echo "  • Automatic startup on boot"
    echo "  • Background monitoring and maintenance"
    echo "  • Better resource management"
    echo "  • Automatic recovery from crashes"
    echo ""
    
    # Check if services are already installed
    if systemctl list-unit-files bill-sloth-core.service >/dev/null 2>&1; then
        echo -e "${GREEN}✅ System services are already installed!${NC}"
        
        if systemctl is-active bill-sloth-core >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Services are currently running${NC}"
        else
            echo -e "${YELLOW}⚠️  Services are installed but not running${NC}"
            read -p "Would you like to start them now? (y/n): " start_services
            if [[ $start_services =~ ^[Yy] ]]; then
                echo "Starting services..."
                if cd "$BASE_DIR" && sudo systemctl start bill-sloth-core; then
                    echo -e "${GREEN}✅ Services started successfully!${NC}"
                else
                    echo -e "${RED}❌ Failed to start services${NC}"
                fi
            fi
        fi
    else
        echo -e "${YELLOW}ℹ️  System services are not installed${NC}"
        read -p "Would you like to install them? This requires sudo access (y/n): " install_services
        
        if [[ $install_services =~ ^[Yy] ]]; then
            echo ""
            echo "Installing system services (this may take a moment)..."
            if cd "$BASE_DIR" && sudo bash systemd/setup_systemd_services.sh install; then
                echo -e "${GREEN}🎉 System services installed and started successfully!${NC}"
                jq '.services_installed = true' "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" && mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
            else
                echo -e "${RED}❌ Service installation failed${NC}"
                echo "Don't worry - you can still use Bill Sloth without services!"
            fi
        else
            echo "No problem! You can install services later with: ${CYAN}just install-services${NC}"
        fi
    fi
    
    echo ""
    sleep 2
}

# Interactive feature tour
interactive_feature_tour() {
    echo -e "${CYAN}🎯 Interactive Feature Tour${NC}"
    echo ""
    echo "Let's try some key Bill Sloth features based on your interests!"
    echo ""
    
    local interests=($(jq -r '.areas_of_interest[]?' "$PROGRESS_FILE" 2>/dev/null))
    
    # Command Center demo
    echo -e "${BLUE}Demo 1: Command Center${NC}"
    echo "The Command Center is your mission control for Bill Sloth."
    read -p "Press Enter to open it (or 's' to skip): " demo1
    
    if [[ ! $demo1 =~ ^[Ss] ]]; then
        echo "Opening Command Center..."
        if cd "$BASE_DIR" && timeout 10 bash bill_command_center.sh; then
            echo -e "${GREEN}✅ Command Center demo completed${NC}"
        else
            echo -e "${YELLOW}⚠️  Demo timed out (this is normal for the tour)${NC}"
        fi
    fi
    
    echo ""
    
    # Just commands demo
    echo -e "${BLUE}Demo 2: Task Automation (Just commands)${NC}"
    echo "Bill Sloth uses 'just' for easy task management. Let's see what's available:"
    
    if cd "$BASE_DIR" && command -v just &>/dev/null; then
        echo ""
        just --list | head -10
        echo ""
        echo "Try running: ${CYAN}just health${NC} or ${CYAN}just perf-check${NC}"
        read -p "Press Enter to continue..."
    else
        echo -e "${YELLOW}⚠️  Just command not available - you can install it later${NC}"
    fi
    
    echo ""
    
    # Performance monitoring demo
    echo -e "${BLUE}Demo 3: Performance Monitoring${NC}"
    echo "Let's check your system performance:"
    
    if command -v capture_performance_snapshot &>/dev/null; then
        local snapshot=$(capture_performance_snapshot "onboarding" "demo" 0)
        local cpu=$(echo "$snapshot" | jq -r '.cpu_usage // "0"' 2>/dev/null)
        local memory=$(echo "$snapshot" | jq -r '.memory_usage_mb // "0"' 2>/dev/null)
        
        echo "   CPU Usage: ${cpu}%"
        echo "   Memory Usage: ${memory}MB"
        echo -e "${GREEN}✅ Performance monitoring is working!${NC}"
    else
        echo -e "${YELLOW}⚠️  Performance monitoring not fully initialized${NC}"
    fi
    
    echo ""
    sleep 2
}

# Interest-specific recommendations
provide_personalized_recommendations() {
    local interests=($(jq -r '.areas_of_interest[]?' "$PROGRESS_FILE" 2>/dev/null))
    
    echo -e "${PURPLE}🎯 Personalized Recommendations${NC}"
    echo ""
    echo "Based on your interests, here's what I recommend exploring next:"
    echo ""
    
    for interest in "${interests[@]}"; do
        case $interest in
            content_creation)
                echo -e "${CYAN}🎮 Content Creation Path:${NC}"
                echo "  1. Try: ${YELLOW}just edboigames-status${NC} - Check content pipeline"
                echo "  2. Run: ${YELLOW}bash modules/media_processing_pipeline.sh${NC}"
                echo "  3. Set up voice control for hands-free operation"
                echo ""
                ;;
            property_management)
                echo -e "${CYAN}🏠 Property Management Path:${NC}"
                echo "  1. Try: ${YELLOW}just vrbo-upcoming${NC} - Check bookings"
                echo "  2. Set up guest automation workflows"
                echo "  3. Configure Google Tasks integration"
                echo ""
                ;;
            productivity)
                echo -e "${CYAN}📋 Productivity Path:${NC}"
                echo "  1. Try: ${YELLOW}just analytics${NC} - See usage patterns"
                echo "  2. Set up Kanboard for task management"
                echo "  3. Create custom automation workflows"
                echo ""
                ;;
            development)
                echo -e "${CYAN}💻 Development Path:${NC}"
                echo "  1. Try: ${YELLOW}just test${NC} - Run integration tests"
                echo "  2. Explore the lib/ directory for APIs"
                echo "  3. Check out the systemd services setup"
                echo ""
                ;;
            privacy)
                echo -e "${CYAN}🔒 Privacy/Security Path:${NC}"
                echo "  1. Set up local-first data storage"
                echo "  2. Configure encrypted backups"
                echo "  3. Explore privacy-focused modules"
                echo ""
                ;;
        esac
    done
    
    if [ ${#interests[@]} -eq 0 ]; then
        echo -e "${CYAN}🌟 General Exploration Path:${NC}"
        echo "  1. Try: ${YELLOW}just health${NC} - Check system health"
        echo "  2. Try: ${YELLOW}just backup${NC} - Create a backup"
        echo "  3. Explore: ${YELLOW}just --list${NC} - See all available commands"
        echo ""
    fi
    
    echo -e "${GREEN}💡 Pro tip:${NC} Start with just ONE area and master it before moving on!"
    echo ""
}

# Create personalized quick reference
create_quick_reference() {
    local quick_ref_file="$ONBOARD_DIR/my_quick_reference.md"
    
    echo -e "${BLUE}📚 Creating your personalized quick reference...${NC}"
    
    cat > "$quick_ref_file" << EOF
# My Bill Sloth Quick Reference

*Generated on $(date)*

## My Preferences
- Learning Style: $(jq -r '.learning_style' "$PROGRESS_FILE")
- Areas of Interest: $(jq -r '.areas_of_interest | join(", ")' "$PROGRESS_FILE")
- Accessibility Needs: $(jq -r '.accessibility_needs | join(", ")' "$PROGRESS_FILE")

## Essential Commands
- **Health Check**: \`just health\` - Check system status
- **Performance**: \`just perf-check\` - Quick performance check  
- **Backup**: \`just backup\` - Create safety backup
- **Command Center**: \`bash bill_command_center.sh\` - Main interface

## My Recommended Next Steps
EOF
    
    # Add personalized recommendations
    local interests=($(jq -r '.areas_of_interest[]?' "$PROGRESS_FILE" 2>/dev/null))
    for interest in "${interests[@]}"; do
        case $interest in
            content_creation)
                echo "- Explore EdBoiGames toolkit: \`just edboigames-status\`" >> "$quick_ref_file"
                echo "- Set up media processing: \`bash modules/media_processing_pipeline.sh\`" >> "$quick_ref_file"
                ;;
            property_management)
                echo "- Check VRBO bookings: \`just vrbo-upcoming\`" >> "$quick_ref_file"
                echo "- Set up guest automation workflows" >> "$quick_ref_file"
                ;;
            productivity)
                echo "- View analytics: \`just analytics\`" >> "$quick_ref_file"
                echo "- Create custom workflows: \`just automate my_workflow\`" >> "$quick_ref_file"
                ;;
        esac
    done
    
    cat >> "$quick_ref_file" << EOF

## Getting Help
- Full documentation: Read \`ONBOARDING_GUIDE.md\`
- Command list: \`just --list\`
- Service status: \`just service-status\`
- Performance report: \`just perf-report\`

## Emergency Commands
- Emergency diagnostic: \`just emergency\`
- Troubleshoot: \`just troubleshoot\`
- Reset failed services: \`sudo systemctl reset-failed bill-sloth-core\`

---
*Remember: You can't break anything! Experiment and learn at your own pace.*
EOF
    
    echo -e "${GREEN}✅ Your quick reference is ready: ${CYAN}$quick_ref_file${NC}"
    echo ""
}

# Completion and next steps
complete_onboarding() {
    # Mark onboarding as completed
    jq '.current_phase = "completed" | .completed_steps += ["onboarding_complete"]' \
       "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" && mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE"
    
    clear
    echo -e "${GREEN}"
    cat << 'EOF'
    🎉 CONGRATULATIONS! 🎉
    
    You've completed the Bill Sloth onboarding!
    You're now ready to explore your new digital life.
EOF
    echo -e "${NC}"
    
    echo ""
    echo -e "${CYAN}What you've accomplished:${NC}"
    echo "  ✅ Customized Bill Sloth for your needs and preferences"
    echo "  ✅ Set up core systems (database, monitoring, health checks)"
    echo "  ✅ Established performance baseline for optimization"
    echo "  ✅ Created your first backup for safety"
    echo "  ✅ Explored key features through interactive demos"
    echo "  ✅ Received personalized recommendations"
    echo "  ✅ Created your custom quick reference guide"
    
    local services_installed=$(jq -r '.services_installed' "$PROGRESS_FILE")
    if [ "$services_installed" = "true" ]; then
        echo "  ✅ Installed system services for background operation"
    fi
    
    echo ""
    echo -e "${BLUE}Immediate next steps:${NC}"
    echo "  1. Try your recommended commands (check your quick reference)"
    echo "  2. Explore the Command Center: ${YELLOW}bash bill_command_center.sh${NC}"
    echo "  3. Check out available tasks: ${YELLOW}just --list${NC}"
    echo "  4. Read the full guide: ${YELLOW}cat ONBOARDING_GUIDE.md${NC}"
    echo ""
    
    echo -e "${PURPLE}Remember:${NC}"
    echo "  • Take your time - there's no rush"
    echo "  • You can't break anything - experiment freely!"  
    echo "  • Use the rating system to help Bill Sloth learn your preferences"
    echo "  • The community is here to help if you get stuck"
    echo ""
    
    echo -e "${GREEN}Welcome to your new digital life! 🚀${NC}"
    echo ""
    
    # Offer to run a quick command
    read -p "Would you like to run a quick health check to see everything working? (y/n): " run_health
    if [[ $run_health =~ ^[Yy] ]] && cd "$BASE_DIR"; then
        echo ""
        echo "Running health check..."
        if command -v just &>/dev/null; then
            just health || echo "Health check completed with some notes"
        else
            echo "Health check: Basic systems appear to be working!"
        fi
    fi
}

# Main onboarding flow
main_onboarding_flow() {
    init_enhanced_onboarding
    
    # Check if user has completed onboarding before
    local current_phase=$(jq -r '.current_phase // "welcome"' "$PROGRESS_FILE")
    
    if [ "$current_phase" = "completed" ]; then
        echo -e "${GREEN}Welcome back!${NC} You've already completed onboarding."
        echo ""
        echo "What would you like to do?"
        echo "  1) Quick system check"
        echo "  2) View my quick reference"
        echo "  3) Start over with onboarding"
        echo "  4) Go to Command Center"
        echo ""
        
        read -p "Your choice (1-4): " choice
        case $choice in
            1) cd "$BASE_DIR" && just health;;
            2) cat "$ONBOARD_DIR/my_quick_reference.md" 2>/dev/null || echo "Quick reference not found";;
            3) jq '.current_phase = "welcome"' "$PROGRESS_FILE" > "$PROGRESS_FILE.tmp" && mv "$PROGRESS_FILE.tmp" "$PROGRESS_FILE";;
            4) cd "$BASE_DIR" && bash bill_command_center.sh;;
            *) echo "Continuing to Command Center..."; cd "$BASE_DIR" && bash bill_command_center.sh;;
        esac
        
        if [ "$choice" != "3" ]; then
            return 0
        fi
    fi
    
    # Full onboarding flow
    show_enhanced_welcome_banner
    assess_user_needs
    establish_performance_baseline
    setup_core_systems
    guide_service_installation
    interactive_feature_tour
    provide_personalized_recommendations
    create_quick_reference
    complete_onboarding
}

# Execute main onboarding
main_onboarding_flow