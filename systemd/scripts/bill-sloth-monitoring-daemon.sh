#!/bin/bash
# Bill Sloth Monitoring Daemon
# Dedicated daemon for performance and health monitoring

set -euo pipefail

# Configuration
DAEMON_NAME="bill-sloth-monitoring"
LOG_FILE="/var/log/bill-sloth/${DAEMON_NAME}.log"

# Bill Sloth paths
BILL_SLOTH_HOME="${BILL_SLOTH_HOME:-$HOME/bill sloth}"
BILL_SLOTH_CONFIG="${BILL_SLOTH_CONFIG:-$HOME/.config/bill-sloth}"

# Monitoring intervals (seconds)
PERFORMANCE_INTERVAL=30
HEALTH_CHECK_INTERVAL=60
ALERT_CHECK_INTERVAL=120

# Source required libraries
source "$BILL_SLOTH_HOME/lib/error_handling.sh" 2>/dev/null || true
source "$BILL_SLOTH_HOME/lib/notification_system.sh" 2>/dev/null || true
source "$BILL_SLOTH_HOME/lib/performance_monitoring.sh" 2>/dev/null || true
source "$BILL_SLOTH_HOME/lib/system_health_monitoring.sh" 2>/dev/null || true

# Logging setup
setup_logging() {
    mkdir -p "$(dirname "$LOG_FILE")"
    exec > >(tee -a "$LOG_FILE")
    exec 2>&1
}

# Signal handlers
handle_sigterm() {
    log_info "Monitoring daemon received SIGTERM - shutting down"
    exit 0
}

handle_sighup() {
    log_info "Monitoring daemon received SIGHUP - reloading configuration"
    reload_monitoring_config
}

# Initialize monitoring systems
init_monitoring_systems() {
    log_info "Initializing monitoring systems..."
    
    # Initialize performance monitoring
    if command -v init_performance_monitoring &>/dev/null; then
        init_performance_monitoring
    fi
    
    # Initialize health monitoring
    if command -v init_health_monitoring &>/dev/null; then
        init_health_monitoring
    fi
    
    log_success "Monitoring systems initialized"
}

# Performance monitoring loop
performance_monitoring_loop() {
    while true; do
        # Capture system-wide performance metrics
        if command -v capture_performance_snapshot &>/dev/null; then
            capture_performance_snapshot "system" "monitoring_daemon" 0 >/dev/null 2>&1 || true
        fi
        
        # Monitor active Bill Sloth processes
        monitor_bill_sloth_processes
        
        sleep "$PERFORMANCE_INTERVAL"
    done
}

# Health checking loop
health_monitoring_loop() {
    while true; do
        # Run comprehensive health check
        run_health_checks
        
        sleep "$HEALTH_CHECK_INTERVAL"
    done
}

# Alert processing loop
alert_processing_loop() {
    while true; do
        # Process and send alerts
        process_pending_alerts
        
        # Clean up old alerts
        cleanup_old_alerts
        
        sleep "$ALERT_CHECK_INTERVAL"
    done
}

# Monitor Bill Sloth specific processes
monitor_bill_sloth_processes() {
    # Get list of Bill Sloth related processes
    local bill_processes=$(pgrep -f "bill.*sloth\|bill_command_center\|backup.*bill" 2>/dev/null || true)
    
    if [ -n "$bill_processes" ]; then
        for pid in $bill_processes; do
            if [ -d "/proc/$pid" ]; then
                # Get process info
                local process_name=$(ps -p "$pid" -o comm= 2>/dev/null || echo "unknown")
                local cpu_usage=$(ps -p "$pid" -o %cpu= 2>/dev/null || echo "0")
                local memory_usage=$(ps -p "$pid" -o %mem= 2>/dev/null || echo "0")
                
                # Record process metrics
                if command -v capture_performance_snapshot &>/dev/null; then
                    # Create a simple JSON for process metrics
                    local process_metrics="{\"pid\": $pid, \"name\": \"$process_name\", \"cpu\": $cpu_usage, \"memory\": $memory_usage}"
                    echo "$process_metrics" | logger -t bill-sloth-monitoring
                fi
                
                # Check for resource violations
                if (( $(echo "$cpu_usage > 50" | bc -l 2>/dev/null || echo "0") )); then
                    log_warning "High CPU usage detected for process $process_name (PID: $pid): ${cpu_usage}%"
                fi
                
                if (( $(echo "$memory_usage > 20" | bc -l 2>/dev/null || echo "0") )); then
                    log_warning "High memory usage detected for process $process_name (PID: $pid): ${memory_usage}%"
                fi
            fi
        done
    fi
}

# Run comprehensive health checks
run_health_checks() {
    local health_issues=0
    
    # Check Bill Sloth core daemon
    if ! pgrep -f "bill-sloth-core-daemon" > /dev/null; then
        log_error "Bill Sloth core daemon is not running"
        ((health_issues++))
        
        # Try to restart it
        if command -v systemctl &>/dev/null; then
            systemctl is-active bill-sloth-core >/dev/null || {
                log_info "Attempting to restart bill-sloth-core service"
                systemctl start bill-sloth-core 2>/dev/null || true
            }
        fi
    fi
    
    # Check database health
    if [ -f "$HOME/.bill-sloth/data/bill_sloth.db" ]; then
        if command -v sqlite3 &>/dev/null; then
            local db_integrity=$(sqlite3 "$HOME/.bill-sloth/data/bill_sloth.db" "PRAGMA integrity_check;" 2>/dev/null || echo "error")
            if [ "$db_integrity" != "ok" ]; then
                log_error "Database integrity check failed: $db_integrity"
                ((health_issues++))
            fi
        fi
    fi
    
    # Check disk space
    local disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//' 2>/dev/null || echo "0")
    if (( disk_usage > 90 )); then
        log_warning "Low disk space: ${disk_usage}% used"
        ((health_issues++))
    fi
    
    # Check critical directories
    local critical_dirs=(
        "$HOME/.bill-sloth"
        "$HOME/.bill-sloth/data"
        "$HOME/.bill-sloth/backups"
    )
    
    for dir in "${critical_dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            log_error "Critical directory missing: $dir"
            ((health_issues++))
            mkdir -p "$dir" 2>/dev/null || true
        fi
    done
    
    # Log health status
    if [ $health_issues -eq 0 ]; then
        log_info "Health check passed - all systems operational"
    else
        log_warning "Health check completed with $health_issues issue(s)"
    fi
    
    # Store health metrics
    if command -v store_health_snapshot &>/dev/null; then
        local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//' 2>/dev/null || echo "0")
        local memory_info=$(free -m | grep '^Mem:')
        local memory_used=$(echo "$memory_info" | awk '{print $3}')
        local memory_total=$(echo "$memory_info" | awk '{print $2}')
        local memory_percent=$(awk "BEGIN {printf \"%.1f\", ($memory_used/$memory_total)*100}" 2>/dev/null || echo "0")
        
        store_health_snapshot "$cpu_usage" "$memory_percent" "$disk_usage" "{\"running_processes\": $(pgrep -c -f bill || echo 0)}" "[]" $((100 - health_issues * 10))
    fi
}

# Process pending alerts
process_pending_alerts() {
    # Check if there are any unresolved alerts in the database
    if command -v sqlite3 &>/dev/null && [ -f "$HOME/.bill-sloth/data/bill_sloth.db" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        
        # Get unresolved critical alerts
        local critical_alerts=$(sqlite3 "$db_file" "SELECT description, metric_value FROM performance_alerts WHERE severity='critical' AND resolved=0 ORDER BY timestamp DESC LIMIT 5;" 2>/dev/null || echo "")
        
        if [ -n "$critical_alerts" ]; then
            log_warning "Active critical alerts detected:"
            echo "$critical_alerts" | while IFS='|' read -r description value; do
                if [ -n "$description" ]; then
                    log_warning "  - $description (Value: $value)"
                fi
            done
            
            # Send notification for critical alerts
            local alert_count=$(echo "$critical_alerts" | grep -c '|' || echo "0")
            if [ "$alert_count" -gt 0 ]; then
                notify_error "Critical Alerts" "$alert_count critical performance alerts require attention"
            fi
        fi
    fi
}

# Clean up old alerts
cleanup_old_alerts() {
    if command -v sqlite3 &>/dev/null && [ -f "$HOME/.bill-sloth/data/bill_sloth.db" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        
        # Mark old resolved alerts for cleanup (keep resolved alerts for 7 days)
        sqlite3 "$db_file" "DELETE FROM performance_alerts WHERE resolved=1 AND resolved_at < datetime('now', '-7 days');" 2>/dev/null || true
        
        # Auto-resolve old warning alerts (after 24 hours)
        sqlite3 "$db_file" "UPDATE performance_alerts SET resolved=1, resolved_at=datetime('now') WHERE severity='warning' AND timestamp < datetime('now', '-24 hours') AND resolved=0;" 2>/dev/null || true
    fi
}

# Reload monitoring configuration
reload_monitoring_config() {
    log_info "Reloading monitoring configuration..."
    
    if [ -f "$BILL_SLOTH_CONFIG/monitoring.conf" ]; then
        source "$BILL_SLOTH_CONFIG/monitoring.conf"
        log_info "Monitoring configuration reloaded"
    fi
    
    # Reinitialize monitoring systems
    init_monitoring_systems
}

# Main monitoring daemon function
main_monitoring_daemon() {
    setup_logging
    
    # Setup signal handling
    trap 'handle_sigterm' TERM INT
    trap 'handle_sighup' HUP
    
    log_info "Starting Bill Sloth monitoring daemon..."
    
    # Initialize monitoring systems
    init_monitoring_systems
    
    log_success "Monitoring daemon initialized successfully"
    
    # Start background monitoring loops
    performance_monitoring_loop &
    local perf_pid=$!
    
    health_monitoring_loop &
    local health_pid=$!
    
    alert_processing_loop &
    local alert_pid=$!
    
    # Wait for any background process to exit
    wait $perf_pid $health_pid $alert_pid
    
    log_info "Monitoring daemon shutting down"
}

# Execute main function
main_monitoring_daemon