#!/bin/bash
# LLM_CAPABILITY: local_ok  
# Service Management Library - Systemd user services for Bill Sloth
# Replaces custom daemon implementations with proper process management


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Service configuration
SERVICE_DIR="$HOME/.config/systemd/user"
BILL_SLOTH_SERVICES_DIR="$HOME/.bill-sloth/services"
SERVICE_LOG_DIR="$HOME/.bill-sloth/logs/services"

# Initialize service management
init_service_management() {
    log_info "Initializing Bill Sloth service management..."
    
    # Check for systemd
    if systemctl --user --version &>/dev/null; then
        SERVICE_ENGINE="systemd"
        mkdir -p "$SERVICE_DIR" "$SERVICE_LOG_DIR"
        systemctl --user daemon-reload
        log_success "Using systemd user services"
    else
        SERVICE_ENGINE="custom"
        mkdir -p "$BILL_SLOTH_SERVICES_DIR" "$SERVICE_LOG_DIR"
        log_warning "systemd not available, using custom process management"
    fi
    
    export SERVICE_ENGINE
}

# Create systemd service file
create_systemd_service() {
    local service_name="$1"
    local description="$2"
    local exec_start="$3"
    local restart_policy="${4:-on-failure}"
    local user_group="${5:-}"
    local environment="${6:-}"
    local working_directory="${7:-$HOME}"
    
    local service_file="$SERVICE_DIR/bill-sloth-${service_name}.service"
    
    cat > "$service_file" << EOF
[Unit]
Description=Bill Sloth - $description
After=graphical-session.target
Wants=graphical-session.target

[Service]
Type=simple
ExecStart=$exec_start
Restart=$restart_policy
RestartSec=5
StandardOutput=append:$SERVICE_LOG_DIR/${service_name}.log
StandardError=append:$SERVICE_LOG_DIR/${service_name}.error.log
WorkingDirectory=$working_directory
Environment="HOME=$HOME"
Environment="PATH=/usr/local/bin:/usr/bin:/bin"
$environment

[Install]
WantedBy=default.target
EOF

    # Reload systemd and enable service
    systemctl --user daemon-reload
    systemctl --user enable "bill-sloth-${service_name}.service"
    
    log_success "Created systemd service: bill-sloth-${service_name}"
}

# Create custom service wrapper (fallback)
create_custom_service() {
    local service_name="$1"
    local description="$2"
    local exec_start="$3"
    local restart_policy="${4:-on-failure}"
    
    local service_script="$BILL_SLOTH_SERVICES_DIR/${service_name}.sh"
    local pid_file="$BILL_SLOTH_SERVICES_DIR/${service_name}.pid"
    
    cat > "$service_script" << EOF
#!/bin/bash
# Custom service wrapper for $service_name
# $description

PID_FILE="$pid_file"
LOG_FILE="$SERVICE_LOG_DIR/${service_name}.log"
ERROR_LOG="$SERVICE_LOG_DIR/${service_name}.error.log"

start_service() {
    if [ -f "\$PID_FILE" ] && kill -0 "\$(cat "\$PID_FILE")" 2>/dev/null; then
        echo "Service $service_name already running"
        return 1
    fi
    
    echo "Starting $service_name..."
    nohup $exec_start >> "\$LOG_FILE" 2>> "\$ERROR_LOG" &
    local service_pid=\$!
    echo \$service_pid > "\$PID_FILE"
    
    # Verify service started
    sleep 2
    if kill -0 \$service_pid 2>/dev/null; then
        echo "✅ $service_name started (PID: \$service_pid)"
        return 0
    else
        echo "❌ Failed to start $service_name"
        rm -f "\$PID_FILE"
        return 1
    fi
}

stop_service() {
    if [ ! -f "\$PID_FILE" ]; then
        echo "Service $service_name not running"
        return 0
    fi
    
    local service_pid=\$(cat "\$PID_FILE")
    if kill -0 \$service_pid 2>/dev/null; then
        echo "Stopping $service_name (PID: \$service_pid)..."
        kill \$service_pid
        
        # Wait for graceful shutdown
        for i in {1..10}; do
            if ! kill -0 \$service_pid 2>/dev/null; then
                break
            fi
            sleep 1
        done
        
        # Force kill if still running
        if kill -0 \$service_pid 2>/dev/null; then
            echo "Force killing $service_name..."
            kill -9 \$service_pid
        fi
        
        echo "✅ $service_name stopped"
    fi
    
    rm -f "\$PID_FILE"
}

restart_service() {
    stop_service
    sleep 2
    start_service
}

status_service() {
    if [ -f "\$PID_FILE" ] && kill -0 "\$(cat "\$PID_FILE")" 2>/dev/null; then
        echo "✅ $service_name is running (PID: \$(cat "\$PID_FILE"))"
        return 0
    else
        echo "❌ $service_name is not running"
        return 1
    fi
}

case "\$1" in
    start) start_service ;;
    stop) stop_service ;;
    restart) restart_service ;;
    status) status_service ;;
    *)
        echo "Usage: \$0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOF

    chmod +x "$service_script"
    log_success "Created custom service wrapper: $service_name"
}

# Create Bill Sloth service
create_bill_service() {
    local service_name="$1"
    local description="$2"
    local exec_start="$3"
    local restart_policy="${4:-on-failure}"
    local environment="${5:-}"
    local working_directory="${6:-$HOME}"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            create_systemd_service "$service_name" "$description" "$exec_start" "$restart_policy" "" "$environment" "$working_directory"
            ;;
        "custom")
            create_custom_service "$service_name" "$description" "$exec_start" "$restart_policy"
            ;;
    esac
}

# Start service
start_service() {
    local service_name="$1"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            if systemctl --user start "bill-sloth-${service_name}.service"; then
                notify_success "Service Started" "🚀 $service_name is now running"
                log_success "Started systemd service: $service_name"
            else
                notify_error "Service Failed" "❌ Could not start $service_name"
                log_error "Failed to start systemd service: $service_name"
                return 1
            fi
            ;;
        "custom")
            if [ -f "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" ]; then
                "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" start
            else
                log_error "Custom service script not found: $service_name"
                return 1
            fi
            ;;
    esac
}

# Stop service
stop_service() {
    local service_name="$1"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            if systemctl --user stop "bill-sloth-${service_name}.service"; then
                notify_info "Service Stopped" "⏹️ $service_name has been stopped"
                log_success "Stopped systemd service: $service_name"
            else
                log_warning "Could not stop systemd service: $service_name"
                return 1
            fi
            ;;
        "custom")
            if [ -f "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" ]; then
                "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" stop
            else
                log_error "Custom service script not found: $service_name"
                return 1
            fi
            ;;
    esac
}

# Restart service
restart_service() {
    local service_name="$1"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            if systemctl --user restart "bill-sloth-${service_name}.service"; then
                notify_info "Service Restarted" "🔄 $service_name has been restarted"
                log_success "Restarted systemd service: $service_name"
            else
                log_error "Failed to restart systemd service: $service_name"
                return 1
            fi
            ;;
        "custom")
            if [ -f "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" ]; then
                "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" restart
            else
                log_error "Custom service script not found: $service_name"
                return 1
            fi
            ;;
    esac
}

# Get service status
get_service_status() {
    local service_name="$1"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            if systemctl --user is-active "bill-sloth-${service_name}.service" &>/dev/null; then
                echo "running"
            else
                echo "stopped"
            fi
            ;;
        "custom")
            if [ -f "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" ]; then
                if "$BILL_SLOTH_SERVICES_DIR/${service_name}.sh" status &>/dev/null; then
                    echo "running"
                else
                    echo "stopped"
                fi
            else
                echo "not_configured"
            fi
            ;;
    esac
}

# Enable service auto-start
enable_service() {
    local service_name="$1"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            systemctl --user enable "bill-sloth-${service_name}.service"
            log_success "Enabled auto-start for service: $service_name"
            ;;
        "custom")
            # Add to user's .profile or .bashrc for custom services
            local startup_line="$BILL_SLOTH_SERVICES_DIR/${service_name}.sh start &"
            
            if ! grep -q "$startup_line" "$HOME/.profile" 2>/dev/null; then
                echo "# Bill Sloth service auto-start" >> "$HOME/.profile"
                echo "$startup_line" >> "$HOME/.profile"
                log_success "Added $service_name to user startup (.profile)"
            fi
            ;;
    esac
}

# Disable service auto-start  
disable_service() {
    local service_name="$1"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            systemctl --user disable "bill-sloth-${service_name}.service"
            log_success "Disabled auto-start for service: $service_name"
            ;;
        "custom")
            # Remove from .profile
            if [ -f "$HOME/.profile" ]; then
                sed -i "\|$BILL_SLOTH_SERVICES_DIR/${service_name}.sh start|d" "$HOME/.profile"
                log_success "Removed $service_name from user startup"
            fi
            ;;
    esac
}

# Setup core Bill Sloth services
setup_core_services() {
    echo "🔧 Setting up core Bill Sloth services..."
    
    # Health Monitoring Service
    create_bill_service "health-monitor" \
        "System Health Monitoring Daemon" \
        "$SCRIPT_DIR/../bin/system-health --daemon" \
        "always" \
        "Environment=\"HEALTH_CHECK_INTERVAL=30\""
    
    # Voice Assistant Service  
    if [ -f "$SCRIPT_DIR/../bin/voice-assistant-daemon" ]; then
        create_bill_service "voice-assistant" \
            "Voice Command Assistant Daemon" \
            "$SCRIPT_DIR/../bin/voice-assistant-daemon" \
            "on-failure"
    fi
    
    # Data Maintenance Service (runs periodically)
    create_bill_service "data-maintenance" \
        "Data Persistence Maintenance" \
        "$SCRIPT_DIR/data_persistence.sh maintain" \
        "no" \
        "Environment=\"DATABASE_MAINTENANCE=true\""
    
    # Create timer for data maintenance (systemd only)
    if [ "$SERVICE_ENGINE" = "systemd" ]; then
        create_systemd_timer "data-maintenance" "Run data maintenance daily" "daily"
    fi
    
    echo "✅ Core services configured"
}

# Create systemd timer
create_systemd_timer() {
    local service_name="$1"
    local description="$2"
    local schedule="$3" # hourly, daily, weekly, or OnCalendar format
    
    local timer_file="$SERVICE_DIR/bill-sloth-${service_name}.timer"
    
    # Convert simple schedules to OnCalendar format
    local on_calendar=""
    case "$schedule" in
        "hourly") on_calendar="hourly" ;;
        "daily") on_calendar="daily" ;;
        "weekly") on_calendar="weekly" ;;
        *) on_calendar="$schedule" ;;
    esac
    
    cat > "$timer_file" << EOF
[Unit]
Description=Bill Sloth - $description Timer
Requires=bill-sloth-${service_name}.service

[Timer]
OnCalendar=$on_calendar
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl --user daemon-reload
    systemctl --user enable "bill-sloth-${service_name}.timer"
    
    log_success "Created systemd timer: bill-sloth-${service_name}.timer"
}

# List all Bill Sloth services
list_services() {
    echo "📋 Bill Sloth Services:"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            echo ""
            echo "🔧 Systemd Services:"
            systemctl --user list-units 'bill-sloth-*.service' --all --no-pager | grep -E '(UNIT|bill-sloth-)'
            
            echo ""
            echo "⏰ Systemd Timers:"
            systemctl --user list-timers 'bill-sloth-*.timer' --no-pager | grep -E '(NEXT|bill-sloth-)'
            ;;
        "custom")
            echo ""
            if [ -d "$BILL_SLOTH_SERVICES_DIR" ]; then
                for service_script in "$BILL_SLOTH_SERVICES_DIR"/*.sh; do
                    [ -f "$service_script" ] || continue
                    local service_name=$(basename "$service_script" .sh)
                    local status=$("$service_script" status &>/dev/null && echo "✅ running" || echo "❌ stopped")
                    echo "  • $service_name: $status"
                done
            else
                echo "  No custom services found"
            fi
            ;;
    esac
}

# Show service logs
show_service_logs() {
    local service_name="$1"
    local lines="${2:-50}"
    
    case "$SERVICE_ENGINE" in
        "systemd")
            echo "📝 Recent logs for $service_name:"
            journalctl --user -u "bill-sloth-${service_name}.service" -n "$lines" --no-pager
            ;;
        "custom")
            local log_file="$SERVICE_LOG_DIR/${service_name}.log"
            if [ -f "$log_file" ]; then
                echo "📝 Recent logs for $service_name:"
                tail -n "$lines" "$log_file"
            else
                echo "⚠️  No logs found for $service_name"
            fi
            ;;
    esac
}

# Service management dashboard
service_dashboard() {
    while true; do
        clear
        echo "🔧 BILL SLOTH SERVICE MANAGEMENT"
        echo "==============================="
        echo ""
        
        list_services
        echo ""
        
        echo "⚙️  ACTIONS:"
        echo "1) Start service"
        echo "2) Stop service"
        echo "3) Restart service"
        echo "4) Enable auto-start"
        echo "5) Disable auto-start"
        echo "6) View service logs"
        echo "7) Setup core services"
        echo "8) Service status details"
        echo "0) Exit"
        echo ""
        
        read -p "Select action: " action
        
        case $action in
            1|2|3|4|5|6)
                read -p "Service name: " service_name
                case $action in
                    1) start_service "$service_name" ;;
                    2) stop_service "$service_name" ;;
                    3) restart_service "$service_name" ;;
                    4) enable_service "$service_name" ;;
                    5) disable_service "$service_name" ;;
                    6) show_service_logs "$service_name" ;;
                esac
                ;;
            7) setup_core_services ;;
            8) 
                read -p "Service name: " service_name
                local status=$(get_service_status "$service_name")
                echo "Status of $service_name: $status"
                ;;
            0) break ;;
            *) echo "Invalid choice" ;;
        esac
        
        if [ "$action" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to continue..."
        fi
    done
}

# Export functions
export -f init_service_management create_bill_service start_service stop_service
export -f restart_service get_service_status enable_service disable_service
export -f setup_core_services list_services show_service_logs service_dashboard

# Initialize on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_service_management 2>/dev/null || true
fi

# Main function for standalone execution
service_management_main() {
    local command="$1"
    shift || true
    
    case "$command" in
        init)
            init_service_management
            ;;
        setup)
            setup_core_services
            ;;
        start)
            start_service "$1"
            ;;
        stop)
            stop_service "$1"
            ;;
        restart)
            restart_service "$1"
            ;;
        status)
            if [ -n "$1" ]; then
                get_service_status "$1"
            else
                list_services
            fi
            ;;
        enable)
            enable_service "$1"
            ;;
        disable)
            disable_service "$1"
            ;;
        logs)
            show_service_logs "$1" "$2"
            ;;
        dashboard)
            service_dashboard
            ;;
        *)
            echo "Bill Sloth Service Management"
            echo "Usage: $0 {init|setup|start|stop|restart|status|enable|disable|logs|dashboard}"
            echo ""
            echo "Commands:"
            echo "  init          - Initialize service management system"
            echo "  setup         - Setup core Bill Sloth services"
            echo "  start <name>  - Start a service"
            echo "  stop <name>   - Stop a service"
            echo "  restart <name> - Restart a service"
            echo "  status [name] - Show service status"
            echo "  enable <name> - Enable auto-start"
            echo "  disable <name> - Disable auto-start"
            echo "  logs <name> [lines] - Show service logs"
            echo "  dashboard     - Interactive service management"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    service_management_main "$@"
fi