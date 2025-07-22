#!/bin/bash
# EdBoiGames Business Toolkit - Adaptive Detection
# Detects user focus and preferences for dynamic module adaptation

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/error_handling.sh" 2>/dev/null || true

# Adaptive content selection based on user behavior
detect_user_focus() {
    init_adaptive_learning 2>/dev/null || true
    
    # Check if user has indicated business development focus
    if grep -q "focus_areas=business\|focus_areas=bd\|focus_areas=partnerships" "$HOME/.bill-sloth/learning/preferences_simple.txt" 2>/dev/null; then
        echo "business_development"
        return
    fi
    
    # Check if user has given negative feedback to video production content
    if grep -q "wrong_focus" "$HOME/.bill-sloth/learning/feedback_simple.log" 2>/dev/null; then
        recent_video_feedback=$(grep "video_production\|youtube\|content_creation" "$HOME/.bill-sloth/learning/feedback_simple.log" 2>/dev/null | tail -3 | grep -c "|[12]|")
        if [ "$recent_video_feedback" -ge 2 ]; then
            echo "business_development"
            return
        fi
    fi
    
    # Check for business-related directories and files
    business_indicators=0
    content_indicators=0
    
    # Business indicators
    [ -d "$HOME/Business" ] && ((business_indicators++))
    [ -d "$HOME/Partnerships" ] && ((business_indicators++))
    [ -f "$HOME/business_plan.md" ] && ((business_indicators++))
    [ -d "$HOME/Revenue" ] && ((business_indicators++))
    [ -d "$HOME/VacationRental" ] && ((business_indicators += 2))  # Strong business indicator
    
    # Content creation indicators  
    [ -d "$HOME/Videos" ] && ((content_indicators++))
    [ -d "$HOME/Content" ] && ((content_indicators++))
    [ -d "$HOME/YouTube" ] && ((content_indicators++))
    [ -f "$HOME/content_calendar.md" ] && ((content_indicators++))
    [ -d "$HOME/Media" ] && ((content_indicators++))
    
    # Check for gaming-related content
    [ -d "$HOME/Games" ] && ((content_indicators++))
    [ -d "$HOME/Streaming" ] && ((content_indicators++))
    [ -d "$HOME/OBS" ] && ((content_indicators++))
    
    # Check usage history if available
    if [ -f "$HOME/.billsloth-usage/edboigames_focus.log" ]; then
        recent_business=$(tail -10 "$HOME/.billsloth-usage/edboigames_focus.log" 2>/dev/null | grep -c "business" || echo "0")
        recent_content=$(tail -10 "$HOME/.billsloth-usage/edboigames_focus.log" 2>/dev/null | grep -c "content" || echo "0")
        
        if [ $recent_business -gt $recent_content ]; then
            ((business_indicators += 2))
        else
            ((content_indicators += 2))
        fi
    fi
    
    # Return focus based on indicators, with adaptive learning taking precedence
    if [ $business_indicators -gt $content_indicators ]; then
        echo "business_development"
    else
        echo "content_creation"
    fi
}

# Detect specific user needs and preferences
detect_user_preferences() {
    local preferences=()
    
    # Gaming focus detection
    if [ -d "$HOME/Games" ] || command -v steam &>/dev/null; then
        preferences+=("gaming")
    fi
    
    # Streaming detection
    if command -v obs-studio &>/dev/null || [ -d "$HOME/OBS" ]; then
        preferences+=("streaming")
    fi
    
    # Video editing detection
    if command -v kdenlive &>/dev/null || command -v davinci-resolve &>/dev/null; then
        preferences+=("video_editing")
    fi
    
    # Business automation detection
    if [ -d "$HOME/VacationRental" ] || [ -f "$HOME/business_automation.md" ]; then
        preferences+=("business_automation")
    fi
    
    # Audio production detection
    if command -v audacity &>/dev/null || command -v lmms &>/dev/null; then
        preferences+=("audio_production")
    fi
    
    # Return preferences as comma-separated string
    IFS=","
    echo "${preferences[*]}"
    IFS=" "
}

# Check user skill level based on installed tools and usage
detect_skill_level() {
    local skill_points=0
    
    # Beginner indicators (0-2 points)
    [ -d "$HOME/Desktop" ] && ((skill_points++))
    
    # Intermediate indicators (2-5 points)
    if command -v git &>/dev/null; then
        ((skill_points += 2))
    fi
    
    if command -v docker &>/dev/null; then
        ((skill_points += 2))
    fi
    
    # Advanced indicators (5+ points)
    if [ -d "$HOME/.config" ] && [ "$(ls -la "$HOME/.config" 2>/dev/null | wc -l)" -gt 20 ]; then
        ((skill_points += 3))
    fi
    
    if command -v vim &>/dev/null && [ -f "$HOME/.vimrc" ]; then
        ((skill_points += 2))
    fi
    
    # Return skill level
    if [ $skill_points -lt 3 ]; then
        echo "beginner"
    elif [ $skill_points -lt 7 ]; then
        echo "intermediate"
    else
        echo "advanced"
    fi
}

# Log user focus for adaptive learning
log_user_focus() {
    local focus_type="$1"
    local preferences="$2"
    local skill_level="$3"
    
    mkdir -p "$HOME/.billsloth-usage"
    
    # Log the focus type
    echo "$(date): focus=$focus_type" >> "$HOME/.billsloth-usage/edboigames_focus.log"
    
    # Log preferences if provided
    if [ ! -z "$preferences" ]; then
        echo "$(date): preferences=$preferences" >> "$HOME/.billsloth-usage/edboigames_preferences.log"
    fi
    
    # Log skill level if provided
    if [ ! -z "$skill_level" ]; then
        echo "$(date): skill_level=$skill_level" >> "$HOME/.billsloth-usage/edboigames_skill.log"
    fi
}

# Get adaptive recommendations based on detection
get_adaptive_recommendations() {
    local focus=$(detect_user_focus)
    local preferences=$(detect_user_preferences)
    local skill_level=$(detect_skill_level)
    
    log_user_focus "$focus" "$preferences" "$skill_level"
    
    echo "🧠 ADAPTIVE RECOMMENDATIONS:"
    echo "Focus: $focus"
    echo "Preferences: $preferences"
    echo "Skill Level: $skill_level"
    echo ""
    
    case "$focus" in
        "business_development")
            echo "💼 Recommended Business Development Path:"
            echo "• Revenue Stream Analysis"
            echo "• Partnership Tools Setup"
            echo "• Market Research Tools"
            echo "• Business Process Automation"
            ;;
        "content_creation")
            echo "🎬 Recommended Content Creation Path:"
            echo "• Video Production Setup"
            echo "• YouTube Optimization Tools"
            echo "• Content Strategy Planning"
            echo "• Audience Building Tools"
            ;;
    esac
    
    # Skill-based recommendations
    case "$skill_level" in
        "beginner")
            echo ""
            echo "👶 Beginner-Friendly Recommendations:"
            echo "• Start with guided setup wizards"
            echo "• Use visual tools and GUIs"
            echo "• Focus on one tool at a time"
            ;;
        "intermediate")
            echo ""
            echo "🎯 Intermediate Recommendations:"
            echo "• Explore automation workflows"
            echo "• Learn command-line tools"
            echo "• Set up development environment"
            ;;
        "advanced")
            echo ""
            echo "🚀 Advanced Recommendations:"
            echo "• Custom script development"
            echo "• Advanced automation setups"
            echo "• Integration with external APIs"
            ;;
    esac
}

# Export functions for use in other modules
export -f detect_user_focus detect_user_preferences detect_skill_level log_user_focus get_adaptive_recommendations