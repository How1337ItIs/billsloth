#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Achievement System - Gamify the automation journey
# Tracks milestones and celebrates user accomplishments

# Achievement database path
ACHIEVEMENT_DB="$HOME/.bill-sloth/data/achievements.json"
ACHIEVEMENT_LOG="$HOME/.bill-sloth/data/achievement_log.txt"

# Initialize achievement system
init_achievement_system() {
    mkdir -p "$(dirname "$ACHIEVEMENT_DB")"
    
    if [ ! -f "$ACHIEVEMENT_DB" ]; then
        cat > "$ACHIEVEMENT_DB" << 'EOF'
{
  "unlocked_achievements": [],
  "stats": {
    "modules_mastered": 0,
    "automations_created": 0,
    "commands_learned": 0,
    "streaks": {
      "current_daily": 0,
      "longest_daily": 0,
      "last_activity": ""
    }
  },
  "milestones": {
    "first_module": false,
    "automation_master": false,
    "ai_awakening": false,
    "sloth_sensei": false,
    "cybersloth": false
  }
}
EOF
    fi
}

# Achievement definitions
declare -A ACHIEVEMENTS=(
    ["first_steps"]="🎯 First Steps|Completed your first Bill Sloth module|Welcome to the matrix, broadbrain!"
    ["automation_master"]="🤖 Automation Master|Created 5 custom automations|You're becoming one with the machines"
    ["ai_awakening"]="🧠 AI Awakening|Successfully integrated AI into your workflow|The neural pathways are forming..."
    ["voice_commander"]="🎤 Voice Commander|Used voice control 10 times|Speaking the language of the future"
    ["data_hoarder"]="💾 Data Hoarder|Organized 1GB+ of digital content|Your digital fortress grows stronger"
    ["sloth_sensei"]="🦥 Sloth Sensei|Mastered 3+ modules completely|Teaching others the way of the sloth"
    ["cybersloth"]="⚡ Cybersloth|Used advanced features across multiple modules|Maximum sloth efficiency achieved"
    ["easter_hunter"]="🥚 Easter Hunter|Discovered 5+ ATHF easter eggs|'I get it! It ain't making me laugh, but I get it!'"
    ["week_warrior"]="📅 Week Warrior|Daily activity streak of 7 days|Consistency is the sloth way"
    ["problem_solver"]="🔧 Problem Solver|Successfully resolved 3+ system issues|Turning chaos into automation"
)

# Check and unlock achievements
check_achievement() {
    local achievement_id="$1"
    local current_count="${2:-1}"
    local required_count="${3:-1}"
    
    init_achievement_system
    
    # Check if already unlocked
    if jq -r ".unlocked_achievements[]" "$ACHIEVEMENT_DB" 2>/dev/null | grep -q "^$achievement_id$"; then
        return 0
    fi
    
    # Check if requirement met
    if [ "$current_count" -ge "$required_count" ]; then
        unlock_achievement "$achievement_id"
    fi
}

# Unlock achievement with celebration
unlock_achievement() {
    local achievement_id="$1"
    
    if [ -z "${ACHIEVEMENTS[$achievement_id]}" ]; then
        return 1
    fi
    
    # Parse achievement data
    IFS='|' read -r icon title description <<< "${ACHIEVEMENTS[$achievement_id]}"
    
    # Add to database
    local temp_file=$(mktemp)
    jq --arg id "$achievement_id" '.unlocked_achievements += [$id]' "$ACHIEVEMENT_DB" > "$temp_file" && mv "$temp_file" "$ACHIEVEMENT_DB"
    
    # Log achievement
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $title" >> "$ACHIEVEMENT_LOG"
    
    # Show celebration
    show_achievement_celebration "$icon" "$title" "$description"
}

# Achievement celebration animation
show_achievement_celebration() {
    local icon="$1"
    local title="$2"
    local description="$3"
    
    # Clear screen for dramatic effect
    clear
    
    # Animated achievement unlock
    echo ""
    echo ""
    echo -e "\033[38;5;226m████████████████████████████████████████████████████████\033[0m"
    sleep 0.1
    echo -e "\033[38;5;226m██                                                    ██\033[0m"
    sleep 0.1
    echo -e "\033[38;5;226m██    \033[38;5;196m⚡ ACHIEVEMENT UNLOCKED! ⚡\033[38;5;226m                ██\033[0m"
    sleep 0.2
    echo -e "\033[38;5;226m██                                                    ██\033[0m"
    echo -e "\033[38;5;226m██    $icon $title\033[38;5;226m"
    local padding=$((50 - ${#title} - 3))
    printf "%*s██\033[0m\n" $padding ""
    sleep 0.2
    echo -e "\033[38;5;226m██                                                    ██\033[0m"
    echo -e "\033[38;5;226m██    \033[38;5;51m$description\033[38;5;226m"
    local desc_padding=$((50 - ${#description}))
    printf "%*s██\033[0m\n" $desc_padding ""
    sleep 0.1
    echo -e "\033[38;5;226m██                                                    ██\033[0m"
    echo -e "\033[38;5;226m████████████████████████████████████████████████████████\033[0m"
    echo ""
    
    # ATHF celebration with real quotes
    echo "🧙 wwwyzzerdd: 'Congratulations, you have been signed up to receive e-mails.'"
    echo "🍔 Meatwad: 'I get it! It ain't making me laugh, but I get it!'"
    echo ""
    
    # Confetti effect
    for i in {1..3}; do
        echo -e "\033[38;5;$((RANDOM % 256))m✦\033[0m \033[38;5;$((RANDOM % 256))m✧\033[0m \033[38;5;$((RANDOM % 256))m✦\033[0m \033[38;5;$((RANDOM % 256))m✧\033[0m \033[38;5;$((RANDOM % 256))m✦\033[0m"
        sleep 0.1
    done
    
    echo ""
    echo "Press Enter to continue your sloth journey..."
    read -r
}

# Update daily activity streak
update_activity_streak() {
    init_achievement_system
    
    local today=$(date '+%Y-%m-%d')
    local last_activity=$(jq -r '.stats.streaks.last_activity' "$ACHIEVEMENT_DB")
    local current_streak=$(jq -r '.stats.streaks.current_daily' "$ACHIEVEMENT_DB")
    
    if [ "$last_activity" = "$today" ]; then
        return 0  # Already counted today
    fi
    
    local temp_file=$(mktemp)
    
    # Calculate new streak
    if [ "$last_activity" = "$(date -d 'yesterday' '+%Y-%m-%d')" ]; then
        # Consecutive day
        new_streak=$((current_streak + 1))
    else
        # Streak broken
        new_streak=1
    fi
    
    # Update database
    jq --arg today "$today" --arg streak "$new_streak" '
        .stats.streaks.last_activity = $today |
        .stats.streaks.current_daily = ($streak | tonumber) |
        if (.stats.streaks.current_daily > .stats.streaks.longest_daily) then
            .stats.streaks.longest_daily = .stats.streaks.current_daily
        else . end
    ' "$ACHIEVEMENT_DB" > "$temp_file" && mv "$temp_file" "$ACHIEVEMENT_DB"
    
    # Check streak achievements
    if [ "$new_streak" -eq 7 ]; then
        check_achievement "week_warrior" 7 7
    fi
}

# Increment stat and check achievements
increment_stat() {
    local stat_name="$1"
    local increment="${2:-1}"
    
    init_achievement_system
    
    local temp_file=$(mktemp)
    jq --arg stat "$stat_name" --arg inc "$increment" '
        .stats[$stat] = ((.stats[$stat] // 0) + ($inc | tonumber))
    ' "$ACHIEVEMENT_DB" > "$temp_file" && mv "$temp_file" "$ACHIEVEMENT_DB"
    
    # Get new value
    local new_value=$(jq -r ".stats.$stat_name" "$ACHIEVEMENT_DB")
    
    # Check specific achievements
    case "$stat_name" in
        "modules_mastered")
            if [ "$new_value" -eq 1 ]; then
                check_achievement "first_steps" 1 1
            elif [ "$new_value" -eq 3 ]; then
                check_achievement "sloth_sensei" 3 3
            fi
            ;;
        "automations_created")
            if [ "$new_value" -ge 5 ]; then
                check_achievement "automation_master" 5 5
            fi
            ;;
        "voice_commands_used")
            if [ "$new_value" -ge 10 ]; then
                check_achievement "voice_commander" 10 10
            fi
            ;;
    esac
}

# Show achievement progress
show_achievement_status() {
    init_achievement_system
    
    echo ""
    echo -e "\033[38;5;226m🏆 ACHIEVEMENT STATUS\033[0m"
    echo "===================="
    echo ""
    
    # Show unlocked achievements
    local unlocked_count=0
    echo -e "\033[38;5;46m✓ UNLOCKED ACHIEVEMENTS:\033[0m"
    while IFS= read -r achievement_id; do
        if [ -n "$achievement_id" ] && [ "$achievement_id" != "null" ]; then
            IFS='|' read -r icon title description <<< "${ACHIEVEMENTS[$achievement_id]}"
            echo "  $icon $title"
            unlocked_count=$((unlocked_count + 1))
        fi
    done < <(jq -r '.unlocked_achievements[]?' "$ACHIEVEMENT_DB" 2>/dev/null)
    
    if [ "$unlocked_count" -eq 0 ]; then
        echo "  🎯 Start your journey to unlock achievements!"
    fi
    
    echo ""
    echo -e "\033[38;5;208m📊 STATS:\033[0m"
    
    # Show current stats
    local modules=$(jq -r '.stats.modules_mastered' "$ACHIEVEMENT_DB" 2>/dev/null || echo 0)
    local automations=$(jq -r '.stats.automations_created' "$ACHIEVEMENT_DB" 2>/dev/null || echo 0)
    local streak=$(jq -r '.stats.streaks.current_daily' "$ACHIEVEMENT_DB" 2>/dev/null || echo 0)
    local longest_streak=$(jq -r '.stats.streaks.longest_daily' "$ACHIEVEMENT_DB" 2>/dev/null || echo 0)
    
    echo "  📚 Modules Mastered: $modules"
    echo "  🤖 Automations Created: $automations"
    echo "  🔥 Current Streak: $streak days"
    echo "  🏅 Longest Streak: $longest_streak days"
    
    echo ""
    echo -e "\033[38;5;51m🎯 NEXT MILESTONES:\033[0m"
    
    # Show next achievements to unlock
    if [ "$modules" -eq 0 ]; then
        echo "  🎯 Complete your first module to unlock 'First Steps'"
    elif [ "$modules" -lt 3 ]; then
        echo "  🦥 Master $((3 - modules)) more modules to become 'Sloth Sensei'"
    fi
    
    if [ "$automations" -lt 5 ]; then
        echo "  🤖 Create $((5 - automations)) more automations for 'Automation Master'"
    fi
    
    if [ "$streak" -lt 7 ]; then
        echo "  📅 Keep daily streak for $((7 - streak)) more days for 'Week Warrior'"
    fi
    
    echo ""
}

# Mark module as mastered
mark_module_mastered() {
    local module_name="$1"
    increment_stat "modules_mastered"
    update_activity_streak
    
    echo "🎉 Module mastered: $module_name"
}

# Mark automation created
mark_automation_created() {
    local automation_name="$1"
    increment_stat "automations_created"
    update_activity_streak
    
    echo "🤖 Automation created: $automation_name"
}

# Mark voice command used
mark_voice_command_used() {
    increment_stat "voice_commands_used"
}

# Export functions
export -f init_achievement_system
export -f check_achievement
export -f unlock_achievement
export -f show_achievement_celebration
export -f update_activity_streak
export -f increment_stat
export -f show_achievement_status
export -f mark_module_mastered
export -f mark_automation_created
export -f mark_voice_command_used

# Initialize on source
init_achievement_system