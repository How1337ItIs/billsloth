#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Contextual Personality System
# ATHF characters respond based on context and user actions

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Context-aware ATHF personality responses
contextual_athf_response() {
    local context="$1"
    local action="$2"
    local success="${3:-true}"
    
    case "$context" in
        "automation")
            if [ "$success" = "true" ]; then
                case "$action" in
                    "created"|"setup"|"configured")
                        echo "🧙 wwwyzzerdd: 'Congratulations, you have been signed up to receive automation!'"
                        echo "🧠 Frylock: 'Excellent work. The system is functioning within optimal parameters.'"
                        ;;
                    "completed"|"finished")
                        echo "🍔 Meatwad: 'I helped with the automation! I understand!'"
                        echo "🥤 Shake: 'Yeah, that was all my plan. I'm the automation master here.'"
                        ;;
                    *)
                        echo "🧙 wwwyzzerdd: 'Welcome to the cyberland portal of productivity, broadbrain.'"
                        ;;
                esac
            else
                echo "👨 Carl: 'Yeah, I keep getting these freakin' automation errors!'"
                echo "🧠 Frylock: 'Let me analyze the error logs and determine the optimal solution.'"
            fi
            ;;
        "data"|"backup"|"storage")
            if [ "$success" = "true" ]; then
                case "$action" in
                    "backed_up"|"saved"|"stored")
                        echo "🧙 wwwyzzerdd: 'This is live streaming data backup, broadbrain.'"
                        echo "🧠 Frylock: 'Data integrity verified. Your information is secure.'"
                        ;;
                    "organized"|"sorted")
                        echo "🍔 Meatwad: 'I put all the data in the right boxes! Did I do good?'"
                        ;;
                    *)
                        echo "🧙 wwwyzzerdd: 'You have entered the cyberland portal of data mastery.'"
                        ;;
                esac
            else
                echo "👨 Carl: 'My computer's all screwed up! I lost everything!'"
                echo "🧠 Frylock: 'Don't panic. We can recover this data using redundant systems.'"
            fi
            ;;
        "ai"|"neural"|"learning")
            if [ "$success" = "true" ]; then
                case "$action" in
                    "trained"|"learned"|"optimized")
                        echo "🧠 Frylock: 'Neural pathways successfully established. Learning protocols active.'"
                        echo "🧙 wwwyzzerdd: 'That's wireless intelligence, broadbrain.'"
                        ;;
                    "generated"|"created")
                        echo "🍔 Meatwad: 'The computer brain made something new! I understand!'"
                        ;;
                    *)
                        echo "🧠 Frylock: 'Initiating artificial intelligence subroutines.'"
                        ;;
                esac
            else
                echo "🥤 Shake: 'This AI stuff is stupid. I could do better with my brain.'"
                echo "🧠 Frylock: 'Let me recalibrate the neural network parameters.'"
            fi
            ;;
        "voice"|"audio"|"speech")
            if [ "$success" = "true" ]; then
                echo "🍔 Meatwad: 'I can hear you! I understand what you're saying!'"
                echo "🧙 wwwyzzerdd: 'Voice recognition protocols activated, broadbrain.'"
            else
                echo "🍔 Meatwad: 'I don't get it! I can't hear you good!'"
                echo "👨 Carl: 'This voice thing ain't working right!'"
            fi
            ;;
        "network"|"internet"|"connection")
            if [ "$success" = "true" ]; then
                case "$action" in
                    "connected"|"online")
                        echo "🧙 wwwyzzerdd: 'He can hear you now, Fry man. You are on the brainframe.'"
                        echo "🧠 Frylock: 'Network connectivity established. All systems nominal.'"
                        ;;
                    "secured"|"encrypted")
                        echo "🧙 wwwyzzerdd: 'Welcome to secure cyberland transmission.'"
                        ;;
                    *)
                        echo "🧙 wwwyzzerdd: 'This is live streaming network management, broadbrain.'"
                        ;;
                esac
            else
                echo "👨 Carl: 'My internet's not working! I can't get my emails!'"
                echo "🧙 wwwyzzerdd: 'You are not on the brainframe. Connection failed.'"
            fi
            ;;
        "gaming"|"entertainment"|"fun")
            if [ "$success" = "true" ]; then
                case "$action" in
                    "optimized"|"boosted")
                        echo "🥤 Shake: 'Yeah, gaming performance! I'm number one in the hood, G!'"
                        echo "🍔 Meatwad: 'The games run really fast now! Wheee!'"
                        ;;
                    "installed"|"setup")
                        echo "🧠 Frylock: 'Gaming environment successfully configured for optimal performance.'"
                        ;;
                    *)
                        echo "🥤 Shake: 'Time for some serious gaming. I'm gonna dominate!'"
                        ;;
                esac
            else
                echo "🥤 Shake: 'This game is stupid! I bet I could make a better one.'"
                echo "👨 Carl: 'All these games nowadays are too complicated.'"
            fi
            ;;
        "error"|"problem"|"failure")
            case "$action" in
                "fixed"|"resolved"|"solved")
                    echo "🧠 Frylock: 'Problem resolved. All systems have been restored to normal operation.'"
                    echo "🍔 Meatwad: 'Yay! You fixed it! I understand!'"
                    ;;
                "investigating"|"debugging")
                    echo "🧠 Frylock: 'Let me run a comprehensive diagnostic to identify the root cause.'"
                    echo "🧙 wwwyzzerdd: 'Analyzing cyberland error protocols, broadbrain.'"
                    ;;
                *)
                    echo "👨 Carl: 'Something's broken again! Why does this always happen to me?'"
                    echo "🧠 Frylock: 'Calm down. Let's approach this systematically.'"
                    ;;
            esac
            ;;
        "achievement"|"success"|"milestone")
            case "$action" in
                "unlocked"|"earned"|"achieved")
                    echo "🍔 Meatwad: 'You did something really good! I'm proud of you!'"
                    echo "🥤 Shake: 'Yeah, well, I taught you everything you know.'"
                    echo "🧙 wwwyzzerdd: 'Congratulations, you have been signed up to receive achievements!'"
                    ;;
                "progress"|"learning")
                    echo "🧠 Frylock: 'Your skill development is progressing at an acceptable rate.'"
                    echo "🍔 Meatwad: 'You're getting really smart! I understand!'"
                    ;;
                *)
                    echo "🥤 Shake: 'Obviously you learned from the best. That would be me.'"
                    ;;
            esac
            ;;
        "startup"|"initialization"|"boot")
            echo "🧙 wwwyzzerdd: 'System initialization protocols activated, broadbrain.'"
            echo "🧠 Frylock: 'All subsystems online. Welcome to the Bill Sloth neural interface.'"
            echo "🍔 Meatwad: 'Hi! I'm ready to help! I understand!'"
            ;;
        *)
            # Default responses for unspecified contexts
            if [ "$success" = "true" ]; then
                local responses=(
                    "🍔 Meatwad: 'That worked good! I understand!'"
                    "🧠 Frylock: 'Operation completed successfully.'"
                    "🧙 wwwyzzerdd: 'Welcome to successful operation completion, broadbrain.'"
                    "🥤 Shake: 'Yeah, that was all part of my master plan.'"
                )
            else
                local responses=(
                    "👨 Carl: 'Aw, come on! Not again!'"
                    "🧠 Frylock: 'Let me analyze this and find a solution.'"
                    "🍔 Meatwad: 'Something went wrong, but don't worry! I still understand!'"
                    "🧙 wwwyzzerdd: 'Error detected in cyberland operations.'"
                )
            fi
            
            # Select random response
            local random_index=$((RANDOM % ${#responses[@]}))
            echo "${responses[$random_index]}"
            ;;
    esac
}

# Quick context responses for common scenarios
quick_athf_success() {
    local context="$1"
    contextual_athf_response "$context" "completed" "true"
}

quick_athf_error() {
    local context="$1"
    contextual_athf_response "$context" "error" "false"
}

quick_athf_startup() {
    local context="$1"
    contextual_athf_response "$context" "startup" "true"
}

# Time-based personality variations
time_based_greeting() {
    local hour=$(date +%H)
    
    if [ "$hour" -lt 6 ]; then
        echo "🦥 Sloth Mode: 'It's really early, broadbrain. Let's take this slow.'"
        echo "🍔 Meatwad: 'I'm still sleepy but I'll try to help!'"
    elif [ "$hour" -lt 12 ]; then
        echo "☀️ Morning Protocol: 'Good morning, broadbrain! Ready to automate your day?'"
        echo "🧠 Frylock: 'Morning systems initialized. Productivity levels optimal.'"
    elif [ "$hour" -lt 17 ]; then
        echo "⚡ Afternoon Power: 'Afternoon productivity session activated!'"
        echo "🥤 Shake: 'Yeah, it's prime time for getting stuff done!'"
    elif [ "$hour" -lt 21 ]; then
        echo "🌅 Evening Wind-Down: 'Evening automation protocols engaged.'"
        echo "🧙 wwwyzzerdd: 'This is live streaming evening productivity, broadbrain.'"
    else
        echo "🌙 Night Owl Mode: 'Late night hacking session detected.'"
        echo "👨 Carl: 'You're up late too? I can't sleep either.'"
    fi
}

# Mood-based responses based on recent user activity
mood_response() {
    local recent_errors="${1:-0}"
    local recent_successes="${2:-0}"
    
    if [ "$recent_errors" -gt 3 ] && [ "$recent_successes" -eq 0 ]; then
        echo "🧠 Frylock: 'You seem to be having a challenging session. Let me help you troubleshoot.'"
        echo "🍔 Meatwad: 'Don't worry! Even when things break, I still understand you're trying!'"
    elif [ "$recent_successes" -gt 5 ]; then
        echo "🥤 Shake: 'You're on fire today! Obviously you learned from watching me.'"
        echo "🧙 wwwyzzerdd: 'Achievement streak detected, broadbrain. Welcome to Instant Success!'"
    else
        echo "🧠 Frylock: 'You're making steady progress. Keep up the methodical approach.'"
    fi
}

# Export functions
export -f contextual_athf_response
export -f quick_athf_success
export -f quick_athf_error
export -f quick_athf_startup
export -f time_based_greeting
export -f mood_response