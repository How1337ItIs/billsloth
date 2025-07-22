#!/bin/bash
# Bill Sloth Core System Daemon
# Main daemon process for Bill Sloth system services

set -euo pipefail

# Configuration
DAEMON_NAME="bill-sloth-core"
PID_FILE="/run/bill-sloth/${DAEMON_NAME}.pid"
LOG_FILE="/var/log/bill-sloth/${DAEMON_NAME}.log"
LOCK_FILE="/var/lock/bill-sloth/${DAEMON_NAME}.lock"

# Bill Sloth paths
BILL_SLOTH_HOME="${BILL_SLOTH_HOME:-$HOME/bill sloth}"
BILL_SLOTH_CONFIG="${BILL_SLOTH_CONFIG:-$HOME/.config/bill-sloth}"

# Source Bill Sloth libraries
source "$BILL_SLOTH_HOME/lib/error_handling.sh" 2>/dev/null || true
source "$BILL_SLOTH_HOME/lib/notification_system.sh" 2>/dev/null || true
source "$BILL_SLOTH_HOME/lib/data_persistence.sh" 2>/dev/null || true
source "$BILL_SLOTH_HOME/lib/performance_monitoring.sh" 2>/dev/null || true

# Logging setup
setup_logging() {
    mkdir -p "$(dirname "$LOG_FILE")" "$(dirname "$PID_FILE")" "$(dirname "$LOCK_FILE")"
    exec > >(tee -a "$LOG_FILE")
    exec 2>&1
}

# Signal handlers
handle_sigterm() {
    log_info "Received SIGTERM - shutting down gracefully"
    stop_daemon
    exit 0
}

handle_sighup() {
    log_info "Received SIGHUP - reloading configuration"
    reload_daemon
}

handle_sigusr1() {
    log_info "Received SIGUSR1 - generating status report"
    generate_status_report
}

# Setup signal handling
setup_signals() {
    trap 'handle_sigterm' TERM
    trap 'handle_sighup' HUP
    trap 'handle_sigusr1' USR1
}

# Initialize Bill Sloth core systems
init_core_systems() {
    log_info "Initializing Bill Sloth core systems..."
    
    # Initialize data persistence
    if command -v init_data_persistence &>/dev/null; then
        init_data_persistence || {
            log_error "Failed to initialize data persistence"
            return 1
        }
    fi
    
    # Initialize performance monitoring
    if command -v init_performance_monitoring &>/dev/null; then
        init_performance_monitoring || {
            log_error "Failed to initialize performance monitoring"
            return 1
        }
    fi
    
    # Initialize health monitoring
    if [ -f "$BILL_SLOTH_HOME/lib/system_health_monitoring.sh" ]; then
        source "$BILL_SLOTH_HOME/lib/system_health_monitoring.sh"
        init_health_monitoring || {
            log_error "Failed to initialize health monitoring"
            return 1
        }
    fi
    
    log_success "Core systems initialized successfully"
}

# Main daemon loop
daemon_main_loop() {
    log_info "Starting Bill Sloth core daemon main loop"
    
    local loop_counter=0
    local health_check_interval=60  # Check health every minute
    local performance_check_interval=300  # Check performance every 5 minutes
    
    while true; do
        ((loop_counter++))
        
        # Systemd watchdog notification
        if command -v systemd-notify &>/dev/null; then
            systemd-notify WATCHDOG=1
        fi
        
        # Health monitoring
        if (( loop_counter % health_check_interval == 0 )); then
            if command -v capture_performance_snapshot &>/dev/null; then
                capture_performance_snapshot "core_daemon" "health_check" 0 >/dev/null 2>&1 || true
            fi
            
            # Check system health and handle critical issues
            check_system_resources
        fi
        
        # Performance analysis
        if (( loop_counter % performance_check_interval == 0 )); then
            log_info "Running periodic performance analysis..."
            if [ -f "$BILL_SLOTH_HOME/scripts/performance_analysis.sh" ]; then
                bash "$BILL_SLOTH_HOME/scripts/performance_analysis.sh" quick >/dev/null 2>&1 || true
            fi
        fi
        
        # Sleep for 1 second
        sleep 1
        
        # Reset counter to prevent overflow
        if (( loop_counter > 86400 )); then  # Reset daily
            loop_counter=0
        fi
    done
}

# Check system resources and take action if needed
check_system_resources() {
    # Get current resource usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//' 2>/dev/null || echo "0")
    local memory_info=$(free -m | grep '^Mem:')
    local memory_used=$(echo "$memory_info" | awk '{print $3}')
    local memory_total=$(echo "$memory_info" | awk '{print $2}')
    local memory_percent=$(awk "BEGIN {printf \"%.1f\", ($memory_used/$memory_total)*100}" 2>/dev/null || echo "0")
    
    # Take action if resources are critically high
    if (( $(echo "$cpu_usage > 90" | bc -l 2>/dev/null || echo "0") )); then
        log_warning "Critical CPU usage: ${cpu_usage}% - initiating resource management"
        # Reduce system load
        reduce_system_load
    fi
    
    if (( $(echo "$memory_percent > 95" | bc -l 2>/dev/null || echo "0") )); then
        log_warning "Critical memory usage: ${memory_percent}% - initiating memory cleanup"
        # Clean up memory
        cleanup_memory
    fi
}

# Reduce system load during high CPU usage
reduce_system_load() {
    log_info "Reducing system load..."
    
    # Throttle background operations
    if pgrep -f "bill.*backup" > /dev/null; then
        log_info "Pausing backup operations temporarily"
        pkill -STOP -f "bill.*backup" || true
        
        # Resume after 5 minutes
        (sleep 300; pkill -CONT -f "bill.*backup" 2>/dev/null || true) &
    fi
    
    # Reduce processing priority for non-critical operations
    if pgrep -f "bill.*media" > /dev/null; then
        log_info "Reducing priority for media processing"
        renice 10 $(pgrep -f "bill.*media") 2>/dev/null || true
    fi
}

# Clean up memory during high usage
cleanup_memory() {
    log_info "Cleaning up memory usage..."
    
    # Clean up caches
    if [ -d "$HOME/.bill-sloth/cache" ]; then
        find "$HOME/.bill-sloth/cache" -type f -mtime +1 -delete 2>/dev/null || true
    fi
    
    # Optimize database
    if command -v sqlite3 &>/dev/null && [ -f "$HOME/.bill-sloth/data/bill_sloth.db" ]; then
        sqlite3 "$HOME/.bill-sloth/data/bill_sloth.db" "VACUUM;" 2>/dev/null || true
    fi
    
    # Force garbage collection if possible
    sync
}

# Generate status report
generate_status_report() {
    local status_file="/tmp/bill-sloth-status-$(date +%s).txt"
    
    cat > "$status_file" << EOF
Bill Sloth Core Daemon Status Report
Generated: $(date)
PID: $$
Uptime: $(ps -o etime= -p $$)

System Resources:
CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//')
Memory Usage: $(free -m | awk '/^Mem:/ {printf "%.1f%%", $3/$2 * 100}')
Load Average: $(uptime | awk -F'load average:' '{print $2}')

Bill Sloth Status:
Core Systems: $(pgrep -c -f "bill-sloth" || echo "0") processes running
Data Directory: $(du -sh ~/.bill-sloth 2>/dev/null | cut -f1 || echo "N/A")
Last Performance Check: $(date)

Recent Activity:
$(tail -5 "$LOG_FILE" 2>/dev/null || echo "No recent activity")
EOF
    
    log_info "Status report generated: $status_file"
    
    # Send to systemd journal
    logger -t bill-sloth-core "Status report: $(cat "$status_file")"
}

# Start daemon
start_daemon() {
    # Check if already running
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        log_error "Daemon already running with PID $(cat "$PID_FILE")"
        exit 1
    fi
    
    setup_logging
    setup_signals
    
    log_info "Starting Bill Sloth core daemon..."
    
    # Initialize systems
    if ! init_core_systems; then
        log_error "Failed to initialize core systems"
        exit 1
    fi
    
    # Create PID file
    echo $$ > "$PID_FILE"
    
    # Notify systemd we're ready
    if command -v systemd-notify &>/dev/null; then
        systemd-notify READY=1
    fi
    
    log_success "Bill Sloth core daemon started (PID: $$)"
    
    # Enter main loop
    daemon_main_loop
}

# Stop daemon
stop_daemon() {
    log_info "Stopping Bill Sloth core daemon..."
    
    # Cleanup resources
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat "$PID_FILE")
        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid"
            
            # Wait for graceful shutdown
            local timeout=15
            while [ $timeout -gt 0 ] && kill -0 "$pid" 2>/dev/null; do
                sleep 1
                ((timeout--))
            done
            
            # Force kill if still running
            if kill -0 "$pid" 2>/dev/null; then
                log_warning "Daemon didn't stop gracefully, forcing shutdown"
                kill -KILL "$pid" 2>/dev/null || true
            fi
        fi
        
        rm -f "$PID_FILE"
    fi
    
    # Cleanup lock file
    rm -f "$LOCK_FILE"
    
    log_info "Bill Sloth core daemon stopped"
}

# Reload daemon configuration
reload_daemon() {
    log_info "Reloading Bill Sloth core daemon configuration..."
    
    # Reload configuration files
    if [ -f "$BILL_SLOTH_CONFIG/core.conf" ]; then
        source "$BILL_SLOTH_CONFIG/core.conf"
        log_info "Configuration reloaded"
    fi
    
    # Reinitialize systems that support reload
    init_core_systems
    
    log_success "Configuration reload completed"
}

# Get daemon status
status_daemon() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "Bill Sloth core daemon is running (PID: $(cat "$PID_FILE"))"
        return 0
    else
        echo "Bill Sloth core daemon is not running"
        return 1
    fi
}

# Main execution
main() {
    case "${1:-}" in
        start)
            start_daemon
            ;;
        stop)
            stop_daemon
            ;;
        restart)
            stop_daemon
            sleep 2
            start_daemon
            ;;
        reload)
            reload_daemon
            ;;
        status)
            status_daemon
            ;;
        *)
            echo "Usage: $0 {start|stop|restart|reload|status}"
            exit 1
            ;;
    esac
}

# Execute main function
main "$@"