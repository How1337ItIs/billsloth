#!/bin/bash
# EdBoiGames Business Toolkit Controller
# Main menu and component loader

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/interactive.sh" 2>/dev/null || {
    echo "🎮 EDBOIGAMES BUSINESS TOOLKIT"
    echo "============================="
}

source "$SCRIPT_DIR/../../lib/adaptive_learning.sh" 2>/dev/null || {
    echo "⚠️  Adaptive learning not available - using default content"
}

# Initialize adaptive learning
init_adaptive_learning "edboigames_toolkit" "$0" 2>/dev/null || true

# Load components
source "$SCRIPT_DIR/adaptive_detection.sh" 2>/dev/null || true
source "$SCRIPT_DIR/education.sh" 2>/dev/null || true
source "$SCRIPT_DIR/video_production.sh" 2>/dev/null || true
source "$SCRIPT_DIR/software_installation.sh" 2>/dev/null || true
source "$SCRIPT_DIR/optimization.sh" 2>/dev/null || true
source "$SCRIPT_DIR/business_development.sh" 2>/dev/null || true

# Detect user focus and show appropriate banner
USER_FOCUS=$(detect_user_focus)

if [ "$USER_FOCUS" = "business_development" ]; then
    show_banner "EDBOIGAMES BUSINESS" "Partnership & Business Development Tools" "BUSINESS"
    echo "🤝 EdBoiGames Business Development & Partnership Toolkit"
    echo "======================================================="
    echo ""
    echo "🎯 Focused on business operations, partnerships, and growth strategies"
    echo "   for EdBoiGames rather than content creation."
    echo ""
    echo "💼 Business Development Tools:"
    echo "   • Partnership outreach and management"
    echo "   • Revenue stream analysis and optimization" 
    echo "   • Market research and competitive analysis"
    echo "   • Business process automation"
    echo ""
else
    show_banner "EDBOIGAMES CONTENT" "Build your content empire" "GAMING"
    echo "🎮 EdBoiGames YouTube Business & Content Creation Toolkit"
    echo "========================================================"
    echo ""
    echo "🎬 This module focuses on building successful YouTube channels,"
    echo "   video editing, content strategy, and audience monetization."
    echo ""
    echo "💰 Content Creation Focus:"
    echo "   • Video production and editing workflows"
    echo "   • YouTube optimization and growth"
    echo "   • Audience building and engagement"
    echo "   • Content monetization strategies"
    echo ""
fi

echo "🧠 ADAPTIVE NOTE: This module learns from your usage and feedback."
echo "   If the focus doesn't match your needs, provide feedback to improve!"
echo ""

# Main menu function
main_menu() {
    while true; do
        print_separator "=" 60
        echo "🎮 EDBOIGAMES TOOLKIT MENU"
        print_separator "=" 60
        echo ""
        
        if [ "$USER_FOCUS" = "business_development" ]; then
            echo "💼 BUSINESS DEVELOPMENT:"
            echo "  1) Revenue Stream Analysis    - Analyze current income sources"
            echo "  2) Partnership Tools          - Business development utilities"
            echo "  3) Market Research            - Competitive analysis tools"
            echo ""
        fi
        
        echo "🎓 LEARNING & EDUCATION:"
        echo "  4) YouTube Business Basics    - Learn the fundamentals"
        echo "  5) Content Strategy Guide     - Plan your content approach"
        echo "  6) Audio Production Guide     - Audio setup and tools"
        echo "  7) Video Production Guide     - Video creation workflow"
        echo ""
        
        echo "🛠️ SOFTWARE & TOOLS:"
        echo "  8) Video Editing Setup        - Install and configure editors"
        echo "  9) Screen Recording Setup     - Install recording software"
        echo " 10) Audio Tools Installation   - Install audio production tools"
        echo ""
        
        echo "📈 OPTIMIZATION & GROWTH:"
        echo " 11) YouTube Optimization       - SEO and growth strategies"
        echo " 12) Monetization Strategies    - Revenue optimization"
        echo " 13) Final Success Tips         - Advanced growth tactics"
        echo ""
        
        echo "🚀 QUICK ACTIONS:"
        echo " 14) YouTube Bootcamp           - Complete guided setup"
        echo ""
        
        echo " 0) Exit EdBoiGames Toolkit"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select an option (0-14)" 30 "0")
        
        case "$choice" in
            1)
                if [ "$USER_FOCUS" = "business_development" ]; then
                    analyze_revenue_streams
                else
                    log_warning "Option 1 not available in content creation mode"
                fi
                ;;
            2)
                if [ "$USER_FOCUS" = "business_development" ]; then
                    echo "💼 Business Development Tools:"
                    echo "  a) Setup business development toolkit"
                    echo "  b) Partnership management system"
                    echo "  c) Business process automation"
                    read -p "Select tool (a-c): " bd_choice
                    case "$bd_choice" in
                        a) setup_business_development_tools ;;
                        b) setup_partnership_tracker ;;
                        c) setup_business_automation ;;
                        *) log_warning "Invalid choice" ;;
                    esac
                else
                    log_warning "Option 2 not available in content creation mode"
                fi
                ;;
            3)
                if [ "$USER_FOCUS" = "business_development" ]; then
                    setup_market_research_tools
                else
                    log_info "Market research tools coming in next update"
                fi
                ;;
            4) explain_youtube_business ;;
            5) explain_content_strategy ;;
            6) explain_audio_production ;;
            7) explain_video_production ;;
            8) setup_video_editing ;;
            9) setup_screen_recording ;;
            10) 
                echo "🎵 Audio Tools Installation Menu"
                echo "1) Install Audacity (Free audio editor)"
                echo "2) Install LMMS (Free music production)"
                local audio_choice
                audio_choice=$(prompt_with_timeout "Select audio tool" 15 "1")
                case "$audio_choice" in
                    1) install_audacity ;;
                    2) install_lmms ;;
                    *) log_warning "Invalid choice" ;;
                esac
                ;;
            11) explain_youtube_optimization ;;
            12) explain_monetization ;;
            13) final_youtube_tips ;;
            14) youtube_bootcamp ;;
            0)
                log_info "Exiting EdBoiGames Toolkit"
                break
                ;;
            *)
                log_warning "Invalid option: $choice"
                echo "Please select a number between 0 and 14."
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

# Main execution
main() {
    main_menu
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi