#!/bin/bash
# Bill Sloth Notification System Library
# Unified notification handling across all desktop environments


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Notification configuration
NOTIFICATION_CONFIG_DIR="$HOME/.bill-sloth/notifications"
NOTIFICATION_LOG="$NOTIFICATION_CONFIG_DIR/notifications.log"
NOTIFICATION_SETTINGS="$NOTIFICATION_CONFIG_DIR/settings.json"

# Notification levels
NOTIFY_SUCCESS="success"
NOTIFY_INFO="info" 
NOTIFY_WARNING="warning"
NOTIFY_ERROR="error"
NOTIFY_PROGRESS="progress"

# Initialize notification system
init_notification_system() {
    log_debug "Initializing notification system..."
    
    # Create notification directory
    create_directory "$NOTIFICATION_CONFIG_DIR"
    
    # Create default settings if not exists
    if [ ! -f "$NOTIFICATION_SETTINGS" ]; then
        create_default_notification_settings
    fi
    
    # Detect available notification methods
    detect_notification_capabilities
}

# Create default notification settings
create_default_notification_settings() {
    log_info "Creating default notification settings..."
    
    cat > "$NOTIFICATION_SETTINGS" << 'EOF'
{
    "version": "1.0",
    "preferences": {
        "desktop_notifications": true,
        "sound_notifications": true,
        "terminal_notifications": true,
        "log_notifications": true,
        "notification_timeout": 5000,
        "priority_filtering": false,
        "quiet_hours": {
            "enabled": false,
            "start": "22:00",
            "end": "08:00"
        }
    },
    "themes": {
        "success": {
            "icon": "✅",
            "color": "\033[0;32m",
            "sound": "complete"
        },
        "info": {
            "icon": "ℹ️",
            "color": "\033[0;34m", 
            "sound": "default"
        },
        "warning": {
            "icon": "⚠️",
            "color": "\033[0;33m",
            "sound": "alert"
        },
        "error": {
            "icon": "❌",
            "color": "\033[0;31m",
            "sound": "error"
        },
        "progress": {
            "icon": "⏳",
            "color": "\033[0;36m",
            "sound": "none"
        }
    }
}
EOF
    
    log_success "Default notification settings created"
}

# Detect available notification capabilities
detect_notification_capabilities() {
    log_debug "Detecting notification capabilities..."
    
    local capabilities_file="$NOTIFICATION_CONFIG_DIR/capabilities.sh"
    
    # Desktop notification capabilities
    local desktop_methods=()
    
    if command -v notify-send &>/dev/null; then
        desktop_methods+=("notify-send")
    fi
    
    if command -v dunstify &>/dev/null; then
        desktop_methods+=("dunstify")
    fi
    
    if command -v kdialog &>/dev/null; then
        desktop_methods+=("kdialog")
    fi
    
    if command -v zenity &>/dev/null; then
        desktop_methods+=("zenity")
    fi
    
    # Terminal notification capabilities
    local terminal_methods=()
    
    if command -v figlet &>/dev/null; then
        terminal_methods+=("figlet")
    fi
    
    if command -v toilet &>/dev/null; then
        terminal_methods+=("toilet")
    fi
    
    # Sound notification capabilities
    local sound_methods=()
    
    if command -v paplay &>/dev/null; then
        sound_methods+=("paplay")
    fi
    
    if command -v aplay &>/dev/null; then
        sound_methods+=("aplay")
    fi
    
    if command -v speaker-test &>/dev/null; then
        sound_methods+=("speaker-test")
    fi
    
    # Save capabilities
    cat > "$capabilities_file" << EOF
# Bill Sloth Notification Capabilities
# Auto-generated on $(date)

DESKTOP_METHODS=(${desktop_methods[*]})
TERMINAL_METHODS=(${terminal_methods[*]})  
SOUND_METHODS=(${sound_methods[*]})

# Primary methods (first available)
PRIMARY_DESKTOP="${desktop_methods[0]:-none}"
PRIMARY_TERMINAL="${terminal_methods[0]:-echo}"
PRIMARY_SOUND="${sound_methods[0]:-none}"
EOF
    
    # Source the capabilities
    source "$capabilities_file"
    
    log_success "Detected notification capabilities: Desktop(${#desktop_methods[@]}), Terminal(${#terminal_methods[@]}), Sound(${#sound_methods[@]})"
}

# Load notification settings
load_notification_settings() {
    if [ -f "$NOTIFICATION_SETTINGS" ]; then
        # Load settings (would use jq in real implementation)
        DESKTOP_NOTIFICATIONS_ENABLED="true"
        SOUND_NOTIFICATIONS_ENABLED="true"
        TERMINAL_NOTIFICATIONS_ENABLED="true"
        LOG_NOTIFICATIONS_ENABLED="true"
        NOTIFICATION_TIMEOUT="5000"
    else
        log_warning "Notification settings not found, using defaults"
        DESKTOP_NOTIFICATIONS_ENABLED="true"
        SOUND_NOTIFICATIONS_ENABLED="true"
        TERMINAL_NOTIFICATIONS_ENABLED="true"
        LOG_NOTIFICATIONS_ENABLED="true"
        NOTIFICATION_TIMEOUT="5000"
    fi
}

# Check if in quiet hours
is_quiet_hours() {
    # Simple implementation - would parse JSON settings in real version
    local current_hour=$(date +%H)
    
    # Default quiet hours: 22:00 to 08:00
    if [ "$current_hour" -ge 22 ] || [ "$current_hour" -lt 8 ]; then
        return 0  # In quiet hours
    else
        return 1  # Not in quiet hours
    fi
}

# Send desktop notification
send_desktop_notification() {
    local level="$1"
    local title="$2"
    local message="$3"
    local urgency="${4:-normal}"
    
    # Load capabilities
    source "$NOTIFICATION_CONFIG_DIR/capabilities.sh" 2>/dev/null || return 1
    
    if [ "$DESKTOP_NOTIFICATIONS_ENABLED" != "true" ]; then
        return 0
    fi
    
    case "$PRIMARY_DESKTOP" in
        "notify-send")
            notify-send \
                --urgency="$urgency" \
                --expire-time="$NOTIFICATION_TIMEOUT" \
                --app-name="Bill Sloth" \
                "$title" "$message" 2>/dev/null &
            ;;
        "dunstify")
            dunstify \
                --urgency="$urgency" \
                --timeout="$NOTIFICATION_TIMEOUT" \
                --appname="Bill Sloth" \
                "$title" "$message" 2>/dev/null &
            ;;
        "kdialog")
            kdialog --title "Bill Sloth: $title" --passivepopup "$message" "$((NOTIFICATION_TIMEOUT/1000))" 2>/dev/null &
            ;;
        "zenity")
            zenity --notification --text="$title: $message" 2>/dev/null &
            ;;
        *)
            log_debug "No desktop notification method available"
            return 1
            ;;
    esac
    
    return 0
}

# Send terminal notification
send_terminal_notification() {
    local level="$1"
    local title="$2"
    local message="$3"
    
    if [ "$TERMINAL_NOTIFICATIONS_ENABLED" != "true" ]; then
        return 0
    fi
    
    # Get theme colors and icons
    local icon color
    case "$level" in
        "$NOTIFY_SUCCESS")
            icon="✅"
            color="\033[0;32m"
            ;;
        "$NOTIFY_INFO")
            icon="ℹ️"
            color="\033[0;34m"
            ;;
        "$NOTIFY_WARNING")
            icon="⚠️"
            color="\033[0;33m"
            ;;
        "$NOTIFY_ERROR")
            icon="❌"
            color="\033[0;31m"
            ;;
        "$NOTIFY_PROGRESS")
            icon="⏳"
            color="\033[0;36m"
            ;;
        *)
            icon="•"
            color="\033[0;37m"
            ;;
    esac
    
    # Load capabilities
    source "$NOTIFICATION_CONFIG_DIR/capabilities.sh" 2>/dev/null || return 1
    
    # Enhanced terminal display for important notifications
    if [ "$level" = "$NOTIFY_ERROR" ] || [ "$level" = "$NOTIFY_SUCCESS" ]; then
        echo ""
        printf "${color}╭─────────────────────────────────────────╮\033[0m\n"
        printf "${color}│ $icon  %-35s │\033[0m\n" "$title"
        printf "${color}├─────────────────────────────────────────┤\033[0m\n"
        
        # Word wrap message
        echo "$message" | fold -w 35 | while read -r line; do
            printf "${color}│ %-37s │\033[0m\n" "$line"
        done
        
        printf "${color}╰─────────────────────────────────────────╯\033[0m\n"
        echo ""
    else
        # Simple one-line notification
        printf "${color}$icon $title: $message\033[0m\n"
    fi
    
    return 0
}

# Send sound notification
send_sound_notification() {
    local level="$1"
    
    if [ "$SOUND_NOTIFICATIONS_ENABLED" != "true" ]; then
        return 0
    fi
    
    if is_quiet_hours; then
        return 0  # Skip sounds during quiet hours
    fi
    
    # Load capabilities
    source "$NOTIFICATION_CONFIG_DIR/capabilities.sh" 2>/dev/null || return 1
    
    # Simple beep patterns for different notification types
    case "$level" in
        "$NOTIFY_SUCCESS")
            # High-low beep for success
            if [ "$PRIMARY_SOUND" = "speaker-test" ]; then
                timeout 0.2s speaker-test -t sine -f 800 -l 1 2>/dev/null &
                sleep 0.1
                timeout 0.2s speaker-test -t sine -f 600 -l 1 2>/dev/null &
            fi
            ;;
        "$NOTIFY_ERROR")
            # Low-high-low beep for error
            if [ "$PRIMARY_SOUND" = "speaker-test" ]; then
                timeout 0.3s speaker-test -t sine -f 400 -l 1 2>/dev/null &
                sleep 0.1
                timeout 0.2s speaker-test -t sine -f 800 -l 1 2>/dev/null &
                sleep 0.1
                timeout 0.3s speaker-test -t sine -f 400 -l 1 2>/dev/null &
            fi
            ;;
        "$NOTIFY_WARNING")
            # Double beep for warning
            if [ "$PRIMARY_SOUND" = "speaker-test" ]; then
                timeout 0.2s speaker-test -t sine -f 600 -l 1 2>/dev/null &
                sleep 0.1
                timeout 0.2s speaker-test -t sine -f 600 -l 1 2>/dev/null &
            fi
            ;;
        *)
            # Single beep for info/progress
            if [ "$PRIMARY_SOUND" = "speaker-test" ]; then
                timeout 0.2s speaker-test -t sine -f 600 -l 1 2>/dev/null &
            fi
            ;;
    esac
    
    return 0
}

# Log notification
log_notification() {
    local level="$1"
    local title="$2"
    local message="$3"
    
    if [ "$LOG_NOTIFICATIONS_ENABLED" != "true" ]; then
        return 0
    fi
    
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $title: $message" >> "$NOTIFICATION_LOG"
    
    # Rotate log if it gets too large (keep last 1000 lines)
    if [ -f "$NOTIFICATION_LOG" ] && [ $(wc -l < "$NOTIFICATION_LOG") -gt 1000 ]; then
        tail -1000 "$NOTIFICATION_LOG" > "$NOTIFICATION_LOG.tmp"
        mv "$NOTIFICATION_LOG.tmp" "$NOTIFICATION_LOG"
    fi
    
    return 0
}

# Main notification function
notify() {
    local level="$1"
    local title="$2"
    local message="$3"
    local urgency="${4:-normal}"
    
    # Initialize if not done already
    if [ ! -d "$NOTIFICATION_CONFIG_DIR" ]; then
        init_notification_system
    fi
    
    # Load settings
    load_notification_settings
    
    # Send notifications through all enabled channels
    send_desktop_notification "$level" "$title" "$message" "$urgency"
    send_terminal_notification "$level" "$title" "$message"
    send_sound_notification "$level"
    log_notification "$level" "$title" "$message"
    
    return 0
}

# Convenience functions for different notification types
notify_success() {
    local title="$1"
    local message="$2"
    notify "$NOTIFY_SUCCESS" "$title" "$message" "normal"
}

notify_info() {
    local title="$1"
    local message="$2"
    notify "$NOTIFY_INFO" "$title" "$message" "normal"
}

notify_warning() {
    local title="$1"
    local message="$2"
    notify "$NOTIFY_WARNING" "$title" "$message" "normal"
}

notify_error() {
    local title="$1"
    local message="$2"
    notify "$NOTIFY_ERROR" "$title" "$message" "critical"
}

notify_progress() {
    local title="$1"
    local message="$2"
    notify "$NOTIFY_PROGRESS" "$title" "$message" "low"
}

# Progress notification with percentage
notify_progress_percent() {
    local title="$1"
    local percent="$2"
    local message="$3"
    
    local bar=""
    local filled=$((percent / 5))  # 20 character bar
    local empty=$((20 - filled))
    
    for ((i=0; i<filled; i++)); do bar+="█"; done
    for ((i=0; i<empty; i++)); do bar+="░"; done
    
    notify_progress "$title" "$bar $percent% - $message"
}

# Module completion notification
notify_module_complete() {
    local module_name="$1"
    local completion_message="${2:-Module completed successfully}"
    
    notify_success "Bill Sloth" "$module_name: $completion_message"
}

# Long-running task notification
notify_task_complete() {
    local task_name="$1"
    local duration="${2:-}"
    
    local message="$task_name completed"
    if [ -n "$duration" ]; then
        message="$message in $duration"
    fi
    
    notify_success "Task Complete" "$message"
}

# Voice command notification
notify_voice_command() {
    local command="$1"
    local result="$2"
    
    notify_info "Voice Command" "$command: $result"
}

# ADHD-friendly reminder notification
notify_reminder() {
    local title="$1"
    local message="$2"
    local priority="${3:-normal}"
    
    # Add gentle ADHD-friendly phrasing
    local adhd_message="💡 Gentle reminder: $message"
    
    case "$priority" in
        "high")
            notify_warning "$title" "$adhd_message"
            ;;
        "urgent")
            notify_error "$title" "$adhd_message"
            ;;
        *)
            notify_info "$title" "$adhd_message"
            ;;
    esac
}

# Export notification functions
export -f init_notification_system notify notify_success notify_info notify_warning
export -f notify_error notify_progress notify_progress_percent notify_module_complete
export -f notify_task_complete notify_voice_command notify_reminder

# Main function for standalone execution
notification_main() {
    local command="$1"
    shift || true
    
    case "$command" in
        init)
            init_notification_system
            ;;
        test)
            echo "Testing notification system..."
            notify_info "Test" "This is a test info notification"
            sleep 1
            notify_success "Test" "This is a test success notification"
            sleep 1
            notify_warning "Test" "This is a test warning notification"
            sleep 1
            notify_error "Test" "This is a test error notification"
            ;;
        progress)
            echo "Testing progress notifications..."
            for i in {0..100..10}; do
                notify_progress_percent "Test Progress" "$i" "Processing data..."
                sleep 0.5
            done
            notify_success "Test Complete" "Progress test finished"
            ;;
        *)
            echo "Usage: $0 {init|test|progress}"
            echo ""
            echo "Commands:"
            echo "  init     - Initialize notification system"
            echo "  test     - Test all notification types"
            echo "  progress - Test progress notifications"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    notification_main "$@"
fi