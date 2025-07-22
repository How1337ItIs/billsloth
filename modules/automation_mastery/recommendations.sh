#!/bin/bash
# Automation Mastery - Recommendations Component
# Shows personalized automation recommendations based on user assessment

# Ensure error handling is available
if [ -z "$ERROR_HANDLING_LOADED" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../../lib/error_handling.sh" 2>/dev/null || {
        echo "Warning: Error handling library not available"
    }
fi

# Show existing recommendations
generate_recommendations() {
    local recommendations_file="$HOME/.bill-sloth/automation-assessment/recommendations.md"
    
    print_header "🎯 YOUR AUTOMATION RECOMMENDATIONS"
    
    if [ -f "$recommendations_file" ]; then
        log_info "Showing your personalized recommendations from previous assessment"
        echo ""
        
        if command -v cat &>/dev/null; then
            cat "$recommendations_file"
        else
            echo "Recommendations available at: $recommendations_file"
        fi
        
        echo ""
        echo "📝 Want updated recommendations?"
        if confirm "Run a new assessment?"; then
            assess_personal_workflows
        fi
    else
        log_info "No previous assessment found"
        echo ""
        echo "To get personalized automation recommendations, you'll need to complete"
        echo "the workflow assessment first. This takes about 5-10 minutes and will"
        echo "give you customized suggestions based on your specific needs."
        echo ""
        
        if confirm "Start the workflow assessment now?"; then
            assess_personal_workflows
        else
            echo ""
            echo "You can run the assessment anytime by selecting option 1 from the main menu."
        fi
    fi
}

# Quick recommendations without full assessment
quick_recommendations() {
    print_header "⚡ QUICK AUTOMATION WINS"
    
    echo "Here are some universal automation ideas that work for almost everyone:"
    echo ""
    
    echo "🔥 **Start Here (5 minutes each):**"
    echo ""
    echo "1. **Email Filters**"
    echo "   • Auto-sort newsletters to a folder"
    echo "   • Flag emails from your boss as important"
    echo "   • Auto-delete obvious spam"
    echo ""
    
    echo "2. **Phone Shortcuts** (iOS/Android)"
    echo "   • \"I'm running late\" text to frequently contacted people"
    echo "   • Toggle WiFi + Bluetooth + Do Not Disturb for focus mode"
    echo "   • Auto-respond to texts when driving"
    echo ""
    
    echo "3. **Calendar Automation**"
    echo "   • Buffer time between meetings (15-30 minutes)"
    echo "   • Automatic decline for overlapping meetings"
    echo "   • Daily agenda email every morning"
    echo ""
    
    echo "4. **File Organization**"
    echo "   • Auto-move screenshots to organized folders"
    echo "   • Backup important folders to cloud storage"
    echo "   • Clear Downloads folder monthly"
    echo ""
    
    echo "🚀 **Next Level (30+ minutes each):**"
    echo ""
    echo "5. **Social Media Scheduling**"
    echo "   • Post to multiple platforms at once"
    echo "   • Auto-share blog posts across networks"
    echo "   • Respond to mentions automatically"
    echo ""
    
    echo "6. **Smart Home Integration**"
    echo "   • Lights on/off based on calendar events"
    echo "   • Music that matches your focus/work mode"
    echo "   • Security system that knows your schedule"
    echo ""
    
    echo "7. **Business Process Automation**"
    echo "   • Invoice generation from time tracking"
    echo "   • Client onboarding sequences"
    echo "   • Expense tracking from receipts"
    echo ""
    
    echo "💡 **Pro Tips:**"
    echo "• Start with ONE automation and get it working perfectly"
    echo "• Document what you automate so you remember later"
    echo "• Test automations thoroughly before relying on them"
    echo "• Review and update automations monthly"
    echo ""
    
    if confirm "Want personalized recommendations?"; then
        assess_personal_workflows
    fi
}

# Export functions
export -f generate_recommendations quick_recommendations