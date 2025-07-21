#!/bin/bash
# Bill Sloth First-Time User Experience
# Guided setup for new users to get started with their adaptive Linux system

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_welcome() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
 __        __   _                            _ 
 \ \      / /__| | ___ ___  _ __ ___   ___  | |
  \ \ /\ / / _ \ |/ __/ _ \| '_ ` _ \ / _ \ | |
   \ V  V /  __/ | (_| (_) | | | | | |  __/ |_|
    \_/\_/ \___|_|\___\___/|_| |_| |_|\___| (_)
                                              
EOF
    echo -e "${NC}"
    echo -e "${PURPLE}🎉 Welcome to Your New Adaptive Linux Power-User System!${NC}"
    echo ""
    echo -e "${BLUE}This setup will help you discover what Bill Sloth can do and${NC}"
    echo -e "${BLUE}customize it to work perfectly with YOUR brain and workflow.${NC}"
    echo ""
}

assess_user_background() {
    echo -e "${CYAN}🧠 LET'S LEARN ABOUT YOU${NC}"
    echo -e "${CYAN}========================${NC}"
    echo ""
    
    echo "I'll ask a few quick questions to customize your experience:"
    echo ""
    
    # Experience level
    echo -e "${YELLOW}1. What's your Linux experience level?${NC}"
    echo "   a) Complete beginner - what's a terminal?"
    echo "   b) Some experience - I can follow tutorials"
    echo "   c) Intermediate - I know bash and can troubleshoot"
    echo "   d) Advanced - I live in the terminal"
    echo ""
    
    read -p "Your choice (a-d): " experience_level
    
    case $experience_level in
        a|A) 
            EXPERIENCE="beginner"
            echo "focus_areas=beginner_friendly" >> ~/.bill-sloth/preferences_simple.txt
            ;;
        b|B) 
            EXPERIENCE="some_experience"
            echo "focus_areas=guided_learning" >> ~/.bill-sloth/preferences_simple.txt
            ;;
        c|C) 
            EXPERIENCE="intermediate"
            echo "focus_areas=intermediate" >> ~/.bill-sloth/preferences_simple.txt
            ;;
        d|D) 
            EXPERIENCE="advanced"
            echo "focus_areas=advanced_user" >> ~/.bill-sloth/preferences_simple.txt
            ;;
        *) 
            EXPERIENCE="intermediate"
            ;;
    esac
    
    echo ""
    
    # Primary interests
    echo -e "${YELLOW}2. What are you most interested in? (Select all that apply)${NC}"
    echo "   a) Gaming and entertainment"
    echo "   b) Programming and development"
    echo "   c) Business and productivity"
    echo "   d) Privacy and security"
    echo "   e) Content creation (video, audio, streaming)"
    echo "   f) System administration and automation"
    echo "   g) Learning and education"
    echo ""
    
    read -p "Enter letters separated by spaces (e.g., 'a c d'): " interests
    
    # Process interests
    for interest in $interests; do
        case $interest in
            a|A) echo "focus_areas=gaming" >> ~/.bill-sloth/preferences_simple.txt ;;
            b|B) echo "focus_areas=development" >> ~/.bill-sloth/preferences_simple.txt ;;
            c|C) echo "focus_areas=business" >> ~/.bill-sloth/preferences_simple.txt ;;
            d|D) echo "focus_areas=security" >> ~/.bill-sloth/preferences_simple.txt ;;
            e|E) echo "focus_areas=content_creation" >> ~/.bill-sloth/preferences_simple.txt ;;
            f|F) echo "focus_areas=sysadmin" >> ~/.bill-sloth/preferences_simple.txt ;;
            g|G) echo "focus_areas=learning" >> ~/.bill-sloth/preferences_simple.txt ;;
        esac
    done
    
    echo ""
    
    # ADHD optimization
    echo -e "${YELLOW}3. Do you prefer systems that are optimized for ADHD/neurodivergent brains?${NC}"
    echo "   (Clear steps, visual progress, minimal overwhelm)"
    echo ""
    
    read -p "Yes/No: " adhd_friendly
    
    if [[ $adhd_friendly =~ ^[Yy] ]]; then
        echo "preferences=adhd_optimized" >> ~/.bill-sloth/preferences_simple.txt
        echo "complexity_preference=simplified" >> ~/.bill-sloth/preferences_simple.txt
    fi
    
    echo ""
    echo -e "${GREEN}✅ Preferences saved! Your modules will adapt to your needs.${NC}"
    echo ""
}

demo_adaptive_learning() {
    echo -e "${CYAN}🧠 ADAPTIVE LEARNING DEMONSTRATION${NC}"
    echo -e "${CYAN}===================================${NC}"
    echo ""
    
    echo -e "${BLUE}Bill Sloth is the first Linux system that learns YOUR workflow.${NC}"
    echo ""
    
    echo -e "${YELLOW}Here's how it works:${NC}"
    echo ""
    echo "🎯 ${GREEN}Smart Feedback${NC}: Rate experiences 1-5 (uses zero AI tokens)"
    echo "🔄 ${GREEN}Auto-Adaptation${NC}: Modules detect patterns and self-modify"
    echo "🤖 ${GREEN}AI Enhancement${NC}: Optional AI customization when you want it"
    echo ""
    
    echo -e "${PURPLE}Real Example:${NC}"
    echo "• EdBoiGames module shows video production tutorials"
    echo "• You rate it: '5 - Wrong focus, I do business development'"
    echo "• Module learns and switches to partnership tools, revenue analysis"
    echo "• Next time: Shows exactly what you need for your work!"
    echo ""
    
    read -p "Press Enter to see your personalized module suggestions..."
    echo ""
}

suggest_first_modules() {
    echo -e "${CYAN}🎯 PERSONALIZED MODULE SUGGESTIONS${NC}"
    echo -e "${CYAN}==================================${NC}"
    echo ""
    
    # Read user preferences
    INTERESTS=$(grep "focus_areas=" ~/.bill-sloth/preferences_simple.txt | cut -d'=' -f2)
    EXPERIENCE=$(grep "focus_areas=" ~/.bill-sloth/preferences_simple.txt | head -1 | cut -d'=' -f2)
    
    echo -e "${BLUE}Based on your preferences, here are the best modules to start with:${NC}"
    echo ""
    
    # Beginner-friendly suggestions
    if [[ $EXPERIENCE == "beginner" ]]; then
        echo -e "${GREEN}🌟 PERFECT FOR BEGINNERS:${NC}"
        echo "   1. system_doctor_interactive     # Check your system health"
        echo "   2. clipboard_mastery_interactive # Advanced copy/paste with AI"
        echo "   3. file_mastery_interactive      # Find files instantly"
        echo ""
    fi
    
    # Interest-based suggestions
    if [[ $INTERESTS == *"gaming"* ]]; then
        echo -e "${GREEN}🎮 GAMING OPTIMIZATION:${NC}"
        echo "   gaming_boost_interactive         # Optimize Linux for gaming"
        echo "   streaming_setup_interactive      # Set up streaming tools"
        echo ""
    fi
    
    if [[ $INTERESTS == *"business"* ]]; then
        echo -e "${GREEN}💼 BUSINESS & PRODUCTIVITY:${NC}"
        echo "   edboigames_toolkit_interactive   # Business development tools"
        echo "   vacation_rental_manager_interactive # VRBO management"
        echo "   productivity_suite_interactive    # Complete productivity setup"
        echo ""
    fi
    
    if [[ $INTERESTS == *"development"* ]]; then
        echo -e "${GREEN}💻 DEVELOPMENT TOOLS:${NC}"
        echo "   ai_playground_interactive        # AI development environment"
        echo "   creative_coding_interactive      # Programming tools setup"
        echo "   launcher_mastery_interactive     # Developer-friendly launcher"
        echo ""
    fi
    
    if [[ $INTERESTS == *"security"* ]]; then
        echo -e "${GREEN}🛡️  SECURITY & PRIVACY:${NC}"
        echo "   defensive_cyber_interactive      # Ethical hacking toolkit"
        echo "   privacy_tools_interactive        # Privacy protection setup"
        echo ""
    fi
    
    # Universal recommendations
    echo -e "${GREEN}⭐ RECOMMENDED FOR EVERYONE:${NC}"
    echo "   text_expansion_interactive       # Smart typing shortcuts"
    echo "   window_mastery_interactive       # Organized window management"
    echo "   automation_mastery_interactive   # Automate repetitive tasks"
    echo ""
    
    echo -e "${PURPLE}💡 Pro Tip: Start with 1-2 modules and let them adapt to you before trying more!${NC}"
    echo ""
}

interactive_first_run() {
    echo -e "${CYAN}🚀 INTERACTIVE FIRST RUN${NC}"
    echo -e "${CYAN}========================${NC}"
    echo ""
    
    echo "Let's run your first module together!"
    echo ""
    
    # Suggest based on experience level
    if [[ $EXPERIENCE == "beginner" ]]; then
        SUGGESTED_MODULE="system_doctor_interactive"
        echo -e "${YELLOW}I recommend starting with System Doctor to check your system health.${NC}"
    else
        SUGGESTED_MODULE="clipboard_mastery_interactive"
        echo -e "${YELLOW}I recommend starting with Clipboard Mastery - it's useful for everyone!${NC}"
    fi
    
    echo ""
    read -p "Run $SUGGESTED_MODULE now? (y/n): " run_module
    
    if [[ $run_module =~ ^[Yy]$ ]]; then
        echo ""
        echo -e "${GREEN}🎯 Launching $SUGGESTED_MODULE...${NC}"
        echo ""
        echo -e "${BLUE}Pay attention to how it asks for feedback - this is how it learns!${NC}"
        echo ""
        
        read -p "Press Enter to launch..."
        
        # Log this as first module usage
        mkdir -p ~/.bill-sloth/usage
        echo "first_run=true" > ~/.bill-sloth/usage/first_time_setup
        echo "$(date)" >> ~/.bill-sloth/usage/first_time_setup
        
        # Run the suggested module
        if [ -f "../modules/$SUGGESTED_MODULE.sh" ]; then
            cd ../modules && ./$SUGGESTED_MODULE.sh
        else
            echo -e "${YELLOW}⚠️  Module not found. Try running: $SUGGESTED_MODULE${NC}"
        fi
    else
        echo ""
        echo -e "${BLUE}No problem! You can run modules anytime by typing their name.${NC}"
    fi
}

show_next_steps() {
    echo ""
    echo -e "${CYAN}🎯 WHAT'S NEXT?${NC}"
    echo -e "${CYAN}===============${NC}"
    echo ""
    
    echo -e "${GREEN}Your Bill Sloth system is ready and learning!${NC}"
    echo ""
    
    echo -e "${YELLOW}🧠 Learning Commands:${NC}"
    echo "   bill-sloth dashboard        # See how modules adapt to you"
    echo "   adapt-modules status        # Check satisfaction scores"
    echo ""
    
    echo -e "${YELLOW}🎮 Quick Access:${NC}"
    echo "   clipboard_mastery_interactive # Advanced clipboard tools"
    echo "   smart-launch 'work mode'     # AI-powered app launcher"
    echo "   everything 'config'          # Instant file search"
    echo ""
    
    echo -e "${YELLOW}🔧 System Health:${NC}"
    echo "   ./scripts/health_check.sh   # Verify everything works"
    echo ""
    
    echo -e "${PURPLE}💡 Remember: The more you use modules and provide feedback,${NC}"
    echo -e "${PURPLE}   the better they become at matching your workflow!${NC}"
    echo ""
    
    echo -e "${GREEN}Welcome to your new adaptive Linux power-user life! 🦥➡️🚀${NC}"
}

# Main setup flow
main() {
    # Create learning directories
    mkdir -p ~/.bill-sloth/{learning,usage,feedback,adaptations}
    
    print_welcome
    
    read -p "Ready to set up your personalized Linux experience? (y/n): " start_setup
    
    if [[ ! $start_setup =~ ^[Yy]$ ]]; then
        echo "Setup cancelled. Run this script anytime: ./scripts/first_time_setup.sh"
        exit 0
    fi
    
    echo ""
    
    # Run setup steps
    assess_user_background
    demo_adaptive_learning
    suggest_first_modules
    interactive_first_run
    show_next_steps
    
    # Mark first-time setup as complete
    echo "completed=$(date)" >> ~/.bill-sloth/usage/first_time_setup
}

# Run main setup
main "$@"