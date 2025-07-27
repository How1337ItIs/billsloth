#!/bin/bash
# LLM_CAPABILITY: local_ok
# System Health Monitoring and Alerting Library
# Real-time monitoring of Bill Sloth system components with intelligent alerts


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/data_sharing.sh" 2>/dev/null || true
source "$SCRIPT_DIR/ascii_gallery.sh" 2>/dev/null || true

# Health monitoring configuration
HEALTH_CONFIG_DIR="$HOME/.bill-sloth/health-monitoring"
HEALTH_DATA_DIR="$HEALTH_CONFIG_DIR/data"
HEALTH_LOGS_DIR="$HEALTH_CONFIG_DIR/logs"
HEALTH_ALERTS_DIR="$HEALTH_CONFIG_DIR/alerts"

# Health thresholds and settings
declare -A HEALTH_THRESHOLDS=(
    ["cpu_usage"]=85          # CPU usage % before alert
    ["memory_usage"]=90       # Memory usage % before alert
    ["disk_usage"]=95         # Disk usage % before alert
    ["load_average"]=4.0      # Load average before alert
    ["process_count"]=500     # Max processes before alert
    ["response_time"]=5000    # Max response time (ms) before alert
    ["error_rate"]=10         # Max errors per minute before alert
)

declare -A ALERT_COOLDOWN=(
    ["cpu"]=300              # 5 minutes between CPU alerts
    ["memory"]=300           # 5 minutes between memory alerts
    ["disk"]=600             # 10 minutes between disk alerts
    ["service"]=180          # 3 minutes between service alerts
    ["network"]=120          # 2 minutes between network alerts
)

# Initialize health monitoring system
init_health_monitoring() {
    log_info "Initializing system health monitoring..."
    
    # PRODUCTION SAFETY: Check critical dependencies with user-friendly messages
    source "$SCRIPT_DIR/production_safety.sh" 2>/dev/null || true
    if command -v check_critical_dependencies &>/dev/null; then
        if ! check_critical_dependencies; then
            log_error "Critical dependencies missing - health monitoring may be limited"
            return 1
        fi
    fi
    
    # Create health monitoring directories
    mkdir -p "$HEALTH_CONFIG_DIR"/{data,logs,alerts,config,dashboards}
    
    # Create health configuration
    cat > "$HEALTH_CONFIG_DIR/config/monitoring_config.json" << 'EOF'
{
  "monitoring": {
    "enabled": true,
    "interval_seconds": 30,
    "retention_days": 30,
    "alert_channels": {
      "desktop": true,
      "log": true,
      "email": false,
      "webhook": false
    }
  },
  "modules": {
    "bill_command_center": {
      "enabled": true,
      "critical": true,
      "check_interval": 60
    },
    "data_sharing": {
      "enabled": true,
      "critical": true,
      "check_interval": 30
    },
    "workflow_orchestration": {
      "enabled": true,
      "critical": false,
      "check_interval": 120
    },
    "backup_management": {
      "enabled": true,
      "critical": false,
      "check_interval": 300
    },
    "vrbo_automation": {
      "enabled": true,
      "critical": false,
      "check_interval": 180
    },
    "edboigames_business": {
      "enabled": true,
      "critical": false,
      "check_interval": 300
    }
  },
  "system_checks": {
    "cpu_usage": true,
    "memory_usage": true,
    "disk_usage": true,
    "load_average": true,
    "network_connectivity": true,
    "service_health": true,
    "file_permissions": true
  },
  "thresholds": {
    "cpu_usage": 85,
    "memory_usage": 90,
    "disk_usage": 95,
    "load_average": 4.0,
    "response_time_ms": 5000,
    "error_rate_per_minute": 10
  }
}
EOF
    
    # Create health status database
    cat > "$HEALTH_DATA_DIR/system_status.json" << 'EOF'
{
  "last_check": "",
  "system_health": "unknown",
  "uptime_seconds": 0,
  "checks_performed": 0,
  "alerts_triggered": 0,
  "modules": {},
  "system_metrics": {},
  "recent_alerts": []
}
EOF
    
    # Create alert history
    echo '{"alerts": []}' > "$HEALTH_ALERTS_DIR/alert_history.json"
    
    log_success "Health monitoring system initialized"
}

# Get current system metrics
get_system_metrics() {
    local timestamp=$(date -Iseconds)
    
    # CPU Usage
    local cpu_usage
    if command -v top &> /dev/null; then
        cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    elif [ -r /proc/loadavg ]; then
        local load=$(cat /proc/loadavg | awk '{print $1}')
        cpu_usage=$(awk "BEGIN {printf \"%.1f\", $load * 25}")  # Rough approximation
    else
        cpu_usage=0
    fi
    
    # Memory Usage
    local memory_usage=0
    if [ -r /proc/meminfo ]; then
        local mem_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local mem_available=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        if [ ! -z "$mem_total" ] && [ ! -z "$mem_available" ]; then
            memory_usage=$(awk "BEGIN {printf \"%.1f\", (($mem_total - $mem_available) / $mem_total) * 100}")
        fi
    fi
    
    # Disk Usage
    local disk_usage=0
    if command -v df &> /dev/null; then
        disk_usage=$(df -h "$HOME" | tail -1 | awk '{print $5}' | sed 's/%//')
    fi
    
    # Load Average
    local load_average=0
    if [ -r /proc/loadavg ]; then
        load_average=$(cat /proc/loadavg | awk '{print $1}')
    fi
    
    # Process Count
    local process_count=0
    if [ -d /proc ]; then
        process_count=$(ls -1 /proc | grep -E '^[0-9]+$' | wc -l)
    fi
    
    # Network connectivity test
    local network_ok="false"
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        network_ok="true"
    fi
    
    # Create metrics JSON
    cat << EOF
{
  "timestamp": "$timestamp",
  "cpu_usage": $cpu_usage,
  "memory_usage": $memory_usage,
  "disk_usage": $disk_usage,
  "load_average": $load_average,
  "process_count": $process_count,
  "network_connectivity": $network_ok,
  "uptime": "$(uptime -s 2>/dev/null || echo 'unknown')"
}
EOF
}

# Check module health
check_module_health() {
    local module_name="$1"
    local check_type="${2:-basic}"
    
    case "$module_name" in
        "bill_command_center")
            check_command_center_health "$check_type"
            ;;
        "data_sharing")
            check_data_sharing_health "$check_type"
            ;;
        "workflow_orchestration")
            check_workflow_health "$check_type"
            ;;
        "backup_management")
            check_backup_health "$check_type"
            ;;
        "vrbo_automation")
            check_vrbo_health "$check_type"
            ;;
        "edboigames_business")
            check_edboigames_health "$check_type"
            ;;
        *)
            echo '{"status": "unknown", "message": "Module not monitored"}'
            ;;
    esac
}

# Check command center health
check_command_center_health() {
    local check_type="$1"
    local status="healthy"
    local message=""
    local details=""
    
    # Check if command center script exists and is executable
    if [ ! -f "$SCRIPT_DIR/../bill_command_center.sh" ]; then
        status="critical"
        message="Command center script not found"
    elif [ ! -x "$SCRIPT_DIR/../bill_command_center.sh" ]; then
        status="warning"
        message="Command center script not executable"
    else
        # Try to source and test basic functions
        if source "$SCRIPT_DIR/../bill_command_center.sh" 2>/dev/null; then
            if command -v init_bill_command_center &> /dev/null; then
                message="Command center operational"
                
                # Extended check
                if [ "$check_type" = "extended" ]; then
                    local config_dir="$HOME/.bill-sloth/command-center"
                    if [ ! -d "$config_dir" ]; then
                        status="warning"
                        message="Command center config directory missing"
                    elif [ ! -f "$config_dir/config/system_status.json" ]; then
                        status="warning"
                        message="System status config missing"
                    fi
                fi
            else
                status="warning"
                message="Command center functions not available"
            fi
        else
            status="critical"
            message="Command center script has errors"
        fi
    fi
    
    # Get additional details
    if [ "$check_type" = "extended" ]; then
        local activity_logs=0
        if [ -f "$HOME/.bill-sloth/command-center/logs/activity.log" ]; then
            activity_logs=$(wc -l < "$HOME/.bill-sloth/command-center/logs/activity.log" 2>/dev/null || echo "0")
        fi
        details='{"activity_logs": '$activity_logs', "last_check": "'$(date -Iseconds)'"}'
    fi
    
    echo "{\"module\": \"bill_command_center\", \"status\": \"$status\", \"message\": \"$message\", \"details\": $details}"
}

# Check data sharing health
check_data_sharing_health() {
    local check_type="$1"
    local status="healthy"
    local message=""
    local details=""
    
    # Test data sharing functionality
    if source "$SCRIPT_DIR/data_sharing.sh" 2>/dev/null; then
        if command -v cache_data &> /dev/null; then
            # Try a test cache operation
            local test_key="health_check_$(date +%s)"
            local test_data='{"health_check": true, "timestamp": "'$(date -Iseconds)'"}'
            
            if cache_data "health_monitoring" "$test_key" "$test_data" 2>/dev/null; then
                if [ ! -z "$(get_cached_data "health_monitoring" "$test_key" 2>/dev/null)" ]; then
                    message="Data sharing operational"
                    
                    # Clean up test data
                    rm -f "$HOME/.bill-sloth/shared-data/cache/health_monitoring/$test_key" 2>/dev/null
                else
                    status="warning"
                    message="Data retrieval failing"
                fi
            else
                status="critical"
                message="Data caching failing"
            fi
        else
            status="critical"
            message="Data sharing functions not available"
        fi
    else
        status="critical"
        message="Data sharing library not loadable"
    fi
    
    # Extended checks
    if [ "$check_type" = "extended" ]; then
        local cache_size=0
        local cache_files=0
        if [ -d "$HOME/.bill-sloth/shared-data/cache" ]; then
            cache_files=$(find "$HOME/.bill-sloth/shared-data/cache" -type f 2>/dev/null | wc -l)
            cache_size=$(du -sb "$HOME/.bill-sloth/shared-data/cache" 2>/dev/null | cut -f1 || echo "0")
        fi
        details='{"cache_files": '$cache_files', "cache_size_bytes": '$cache_size'}'
    fi
    
    echo "{\"module\": \"data_sharing\", \"status\": \"$status\", \"message\": \"$message\", \"details\": $details}"
}

# Check workflow health
check_workflow_health() {
    local check_type="$1"
    local status="healthy"
    local message=""
    local details=""
    
    if source "$SCRIPT_DIR/workflow_orchestration.sh" 2>/dev/null; then
        if command -v create_workflow &> /dev/null; then
            message="Workflow system operational"
            
            # Check workflow directory structure
            if [ ! -d "$HOME/.bill-sloth/workflows" ]; then
                status="warning"
                message="Workflow directories missing"
            fi
        else
            status="warning"
            message="Workflow functions not available"
        fi
    else
        status="critical"
        message="Workflow system not loadable"
    fi
    
    if [ "$check_type" = "extended" ]; then
        local workflows=0
        local active_workflows=0
        if [ -d "$HOME/.bill-sloth/workflows/definitions" ]; then
            workflows=$(find "$HOME/.bill-sloth/workflows/definitions" -name "*.json" 2>/dev/null | wc -l)
        fi
        if [ -d "$HOME/.bill-sloth/workflows/state/active" ]; then
            active_workflows=$(find "$HOME/.bill-sloth/workflows/state/active" -name "*.state" 2>/dev/null | wc -l)
        fi
        details='{"total_workflows": '$workflows', "active_workflows": '$active_workflows'}'
    fi
    
    echo "{\"module\": \"workflow_orchestration\", \"status\": \"$status\", \"message\": \"$message\", \"details\": $details}"
}

# Check backup health
check_backup_health() {
    local check_type="$1"
    local status="healthy"
    local message=""
    local details=""
    
    if source "$SCRIPT_DIR/backup_management.sh" 2>/dev/null; then
        if command -v create_backup &> /dev/null; then
            message="Backup system operational"
            
            # Check backup configuration
            if [ ! -f "$HOME/.bill-sloth/backups/config/backup_config.json" ]; then
                status="warning"
                message="Backup configuration missing"
            fi
        else
            status="critical"
            message="Backup functions not available"
        fi
    else
        status="critical"
        message="Backup system not loadable"
    fi
    
    if [ "$check_type" = "extended" ]; then
        local backup_count=0
        local last_backup=""
        if [ -d "$HOME/.bill-sloth/backups/local" ]; then
            backup_count=$(find "$HOME/.bill-sloth/backups/local" -name "backup_*" -type f 2>/dev/null | wc -l)
            last_backup=$(find "$HOME/.bill-sloth/backups/local" -name "backup_*" -type f 2>/dev/null | sort | tail -1 | xargs ls -l --time-style=+%Y-%m-%d 2>/dev/null | awk '{print $6}' || echo "unknown")
        fi
        details='{"backup_count": '$backup_count', "last_backup": "'$last_backup'"}'
    fi
    
    echo "{\"module\": \"backup_management\", \"status\": \"$status\", \"message\": \"$message\", \"details\": $details}"
}

# Check VRBO automation health
check_vrbo_health() {
    local check_type="$1"
    local status="healthy"
    local message="VRBO automation configured"
    local details=""
    
    if [ ! -d "$HOME/.bill-sloth/vrbo-automation" ]; then
        status="warning"
        message="VRBO automation not configured"
    elif [ ! -d "$HOME/.bill-sloth/vrbo-automation/data" ]; then
        status="warning"
        message="VRBO data directory missing"
    fi
    
    if [ "$check_type" = "extended" ]; then
        local property_count=0
        if [ -d "$HOME/.bill-sloth/vrbo-automation/data" ]; then
            property_count=$(find "$HOME/.bill-sloth/vrbo-automation/data" -name "*.json" 2>/dev/null | wc -l)
        fi
        details='{"property_count": '$property_count'}'
    fi
    
    echo "{\"module\": \"vrbo_automation\", \"status\": \"$status\", \"message\": \"$message\", \"details\": $details}"
}

# Check EdBoiGames health
check_edboigames_health() {
    local check_type="$1"
    local status="healthy"
    local message="EdBoiGames business system configured"
    local details=""
    
    if [ ! -d "$HOME/edboigames_business" ]; then
        status="warning"
        message="EdBoiGames business not configured"
    elif [ ! -d "$HOME/edboigames_business/automation" ]; then
        status="warning"
        message="EdBoiGames automation directory missing"
    fi
    
    if [ "$check_type" = "extended" ]; then
        local content_count=0
        if [ -d "$HOME/edboigames_business" ]; then
            content_count=$(find "$HOME/edboigames_business" -name "*.json" -o -name "*.csv" 2>/dev/null | wc -l)
        fi
        details='{"content_files": '$content_count'}'
    fi
    
    echo "{\"module\": \"edboigames_business\", \"status\": \"$status\", \"message\": \"$message\", \"details\": $details}"
}

# Evaluate health status and trigger alerts if needed
evaluate_health_and_alert() {
    local metrics="$1"
    local module_checks="$2"
    
    # Extract metrics
    local cpu_usage=$(echo "$metrics" | jq -r '.cpu_usage // 0')
    local memory_usage=$(echo "$metrics" | jq -r '.memory_usage // 0')
    local disk_usage=$(echo "$metrics" | jq -r '.disk_usage // 0')
    local load_average=$(echo "$metrics" | jq -r '.load_average // 0')
    local network_ok=$(echo "$metrics" | jq -r '.network_connectivity // "false"')
    
    # Check system thresholds
    local alerts=()
    
    # CPU Alert
    if (( $(echo "$cpu_usage > ${HEALTH_THRESHOLDS[cpu_usage]}" | bc -l 2>/dev/null || echo "0") )); then
        if ! recent_alert "cpu"; then
            alerts+=("CPU usage critical: ${cpu_usage}% (threshold: ${HEALTH_THRESHOLDS[cpu_usage]}%)")
            record_alert "cpu" "CPU usage critical: ${cpu_usage}%"
        fi
    fi
    
    # Memory Alert
    if (( $(echo "$memory_usage > ${HEALTH_THRESHOLDS[memory_usage]}" | bc -l 2>/dev/null || echo "0") )); then
        if ! recent_alert "memory"; then
            alerts+=("Memory usage critical: ${memory_usage}% (threshold: ${HEALTH_THRESHOLDS[memory_usage]}%)")
            record_alert "memory" "Memory usage critical: ${memory_usage}%"
        fi
    fi
    
    # Disk Alert
    if (( $(echo "$disk_usage > ${HEALTH_THRESHOLDS[disk_usage]}" | bc -l 2>/dev/null || echo "0") )); then
        if ! recent_alert "disk"; then
            alerts+=("Disk usage critical: ${disk_usage}% (threshold: ${HEALTH_THRESHOLDS[disk_usage]}%)")
            record_alert "disk" "Disk usage critical: ${disk_usage}%"
        fi
    fi
    
    # Network Alert
    if [ "$network_ok" = "false" ]; then
        if ! recent_alert "network"; then
            alerts+=("Network connectivity lost")
            record_alert "network" "Network connectivity lost"
        fi
    fi
    
    # Module alerts
    local critical_modules=$(echo "$module_checks" | jq -r '.[] | select(.status == "critical") | .module')
    if [ ! -z "$critical_modules" ]; then
        echo "$critical_modules" | while read module; do
            if ! recent_alert "service_$module"; then
                local msg=$(echo "$module_checks" | jq -r ".[] | select(.module == \"$module\") | .message")
                alerts+=("Critical module failure: $module - $msg")
                record_alert "service_$module" "Critical module failure: $module - $msg"
            fi
        done
    fi
    
    # Send alerts
    for alert in "${alerts[@]}"; do
        send_health_alert "$alert"
    done
}

# Check if we recently sent an alert of this type
recent_alert() {
    local alert_type="$1"
    local cooldown=${ALERT_COOLDOWN[$alert_type]:-300}
    local alert_file="$HEALTH_ALERTS_DIR/last_${alert_type}_alert"
    
    if [ -f "$alert_file" ]; then
        local last_alert=$(cat "$alert_file")
        local current_time=$(date +%s)
        local time_diff=$((current_time - last_alert))
        
        if [ $time_diff -lt $cooldown ]; then
            return 0  # Recent alert found
        fi
    fi
    
    return 1  # No recent alert
}

# Record alert timestamp
record_alert() {
    local alert_type="$1"
    local message="$2"
    local timestamp=$(date +%s)
    
    # Record last alert time
    echo "$timestamp" > "$HEALTH_ALERTS_DIR/last_${alert_type}_alert"
    
    # Add to alert history
    local history_file="$HEALTH_ALERTS_DIR/alert_history.json"
    local alert_entry="{\"timestamp\": \"$(date -Iseconds)\", \"type\": \"$alert_type\", \"message\": \"$message\"}"
    
    # Update alert history (keep last 100 alerts)
    if command -v jq &> /dev/null; then
        jq --argjson entry "$alert_entry" '.alerts += [$entry] | .alerts = (.alerts | sort_by(.timestamp) | .[-100:])' "$history_file" > "${history_file}.tmp" && mv "${history_file}.tmp" "$history_file"
    else
        # Fallback without jq
        echo "$alert_entry" >> "$HEALTH_ALERTS_DIR/alert_log.txt"
    fi
}

# Send health alert
send_health_alert() {
    local message="$1"
    local severity="${2:-warning}"
    
    # Add skull to critical alerts (5% chance)
    if [ "$severity" = "critical" ] && [ $((RANDOM % 20)) -eq 0 ] && command -v show_cyber_skull &>/dev/null; then
        echo ""
        echo -e "${CYBER_RED}[CRITICAL SYSTEM ALERT]${CYBER_RESET}"
        show_cyber_skull "compact"
        echo ""
    fi
    
    # Log alert
    log_warning "HEALTH ALERT: $message"
    
    # Desktop notification
    if command -v notify_warning &> /dev/null; then
        notify_warning "System Health Alert" "$message"
    fi
    
    # Write to alert log
    echo "[$(date -Iseconds)] $severity: $message" >> "$HEALTH_LOGS_DIR/alerts.log"
}

# Generate comprehensive health report
generate_health_report() {
    local report_type="${1:-summary}"
    local timestamp=$(date -Iseconds)
    
    log_info "Generating $report_type health report..."
    
    # Get system metrics
    local metrics=$(get_system_metrics)
    
    # Get module health
    local modules=("bill_command_center" "data_sharing" "workflow_orchestration" "backup_management" "vrbo_automation" "edboigames_business")
    local module_results="["
    local first=true
    
    for module in "${modules[@]}"; do
        if [ "$first" = true ]; then
            first=false
        else
            module_results+=","
        fi
        local check_type="basic"
        if [ "$report_type" = "detailed" ]; then
            check_type="extended"
        fi
        module_results+=$(check_module_health "$module" "$check_type")
    done
    module_results+="]"
    
    # Create comprehensive report
    local report=$(cat << EOF
{
  "report_type": "$report_type",
  "generated_at": "$timestamp",
  "system_metrics": $metrics,
  "module_health": $module_results,
  "overall_status": "$(calculate_overall_status "$module_results")",
  "recommendations": $(generate_recommendations "$metrics" "$module_results")
}
EOF
)
    
    # Save report
    local report_file="$HEALTH_DATA_DIR/health_report_$(date +%Y%m%d_%H%M%S).json"
    echo "$report" > "$report_file"
    
    # Update latest report
    echo "$report" > "$HEALTH_DATA_DIR/latest_health_report.json"
    
    log_success "Health report generated: $report_file"
    echo "$report"
}

# Calculate overall system status
calculate_overall_status() {
    local module_results="$1"
    
    if command -v jq &> /dev/null; then
        local critical_count=$(echo "$module_results" | jq '[.[] | select(.status == "critical")] | length')
        local warning_count=$(echo "$module_results" | jq '[.[] | select(.status == "warning")] | length')
        
        if [ "$critical_count" -gt 0 ]; then
            echo "critical"
        elif [ "$warning_count" -gt 0 ]; then
            echo "warning"
        else
            echo "healthy"
        fi
    else
        # Fallback without jq
        if echo "$module_results" | grep -q '"status": "critical"'; then
            echo "critical"
        elif echo "$module_results" | grep -q '"status": "warning"'; then
            echo "warning"
        else
            echo "healthy"
        fi
    fi
}

# Generate recommendations based on health status
generate_recommendations() {
    local metrics="$1"
    local module_results="$2"
    
    local recommendations="[]"
    
    if command -v jq &> /dev/null; then
        # System recommendations based on metrics
        local cpu_usage=$(echo "$metrics" | jq -r '.cpu_usage // 0')
        local memory_usage=$(echo "$metrics" | jq -r '.memory_usage // 0')
        local disk_usage=$(echo "$metrics" | jq -r '.disk_usage // 0')
        
        local recs="["
        local rec_count=0
        
        # CPU recommendations
        if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || echo "0") )); then
            if [ $rec_count -gt 0 ]; then recs+=","; fi
            recs+='{"type": "performance", "priority": "high", "message": "High CPU usage detected. Consider reducing background processes or upgrading hardware."}'
            ((rec_count++))
        fi
        
        # Memory recommendations  
        if (( $(echo "$memory_usage > 85" | bc -l 2>/dev/null || echo "0") )); then
            if [ $rec_count -gt 0 ]; then recs+=","; fi
            recs+='{"type": "performance", "priority": "high", "message": "High memory usage detected. Consider closing unused applications or adding more RAM."}'
            ((rec_count++))
        fi
        
        # Disk recommendations
        if (( $(echo "$disk_usage > 90" | bc -l 2>/dev/null || echo "0") )); then
            if [ $rec_count -gt 0 ]; then recs+=","; fi
            recs+='{"type": "storage", "priority": "critical", "message": "Disk space critically low. Clean up old files or expand storage."}'
            ((rec_count++))
        fi
        
        # Module recommendations
        local critical_modules=$(echo "$module_results" | jq -r '.[] | select(.status == "critical") | .module')
        if [ ! -z "$critical_modules" ]; then
            echo "$critical_modules" | while read module; do
                if [ $rec_count -gt 0 ]; then recs+=","; fi
                recs+="{\"type\": \"module\", \"priority\": \"critical\", \"message\": \"Fix critical issues in $module module.\"}"
                ((rec_count++))
            done
        fi
        
        recs+="]"
        recommendations="$recs"
    fi
    
    echo "$recommendations"
}

# Start health monitoring daemon
start_health_monitoring() {
    local interval="${1:-30}"  # Check every 30 seconds by default
    
    log_info "Starting health monitoring daemon (interval: ${interval}s)..."
    
    # Create daemon PID file
    local pid_file="$HEALTH_CONFIG_DIR/health_monitor.pid"
    echo $$ > "$pid_file"
    
    # Monitoring loop
    while true; do
        # Check if we should continue running
        if [ ! -f "$pid_file" ] || [ "$(cat "$pid_file")" != "$$" ]; then
            log_info "Health monitoring daemon stopping..."
            break
        fi
        
        # Get system metrics
        local metrics=$(get_system_metrics)
        
        # Check all modules
        local modules=("bill_command_center" "data_sharing" "workflow_orchestration" "backup_management" "vrbo_automation" "edboigames_business")
        local module_results="["
        local first=true
        
        for module in "${modules[@]}"; do
            if [ "$first" = true ]; then
                first=false
            else
                module_results+=","
            fi
            module_results+=$(check_module_health "$module" "basic")
        done
        module_results+="]"
        
        # Evaluate health and send alerts if needed
        evaluate_health_and_alert "$metrics" "$module_results"
        
        # Update status database
        local status_update=$(cat << EOF
{
  "last_check": "$(date -Iseconds)",
  "system_health": "$(calculate_overall_status "$module_results")",
  "uptime_seconds": $(cat /proc/uptime 2>/dev/null | awk '{print int($1)}' || echo "0"),
  "checks_performed": $(cat "$HEALTH_DATA_DIR/system_status.json" 2>/dev/null | jq -r '.checks_performed // 0' | awk '{print $1 + 1}'),
  "system_metrics": $metrics,
  "modules": $module_results
}
EOF
)
        
        echo "$status_update" > "$HEALTH_DATA_DIR/system_status.json"
        
        # Log health check
        echo "[$(date -Iseconds)] Health check completed - Status: $(calculate_overall_status "$module_results")" >> "$HEALTH_LOGS_DIR/monitoring.log"
        
        # Wait for next interval
        sleep "$interval"
    done
}

# Stop health monitoring daemon
stop_health_monitoring() {
    local pid_file="$HEALTH_CONFIG_DIR/health_monitor.pid"
    
    if [ -f "$pid_file" ]; then
        local pid=$(cat "$pid_file")
        if kill -0 "$pid" 2>/dev/null; then
            log_info "Stopping health monitoring daemon (PID: $pid)..."
            kill "$pid"
            rm -f "$pid_file"
            log_success "Health monitoring daemon stopped"
        else
            log_warning "Health monitoring daemon not running"
            rm -f "$pid_file"
        fi
    else
        log_warning "Health monitoring daemon PID file not found"
    fi
}

# Create health monitoring dashboard
create_health_dashboard() {
    cat > "$HEALTH_CONFIG_DIR/dashboards/health_dashboard.sh" << 'EOF'
#!/bin/bash
# Bill Sloth System Health Dashboard

HEALTH_CONFIG_DIR="$HOME/.bill-sloth/health-monitoring"
source "$HOME/.bill-sloth/lib/system_health_monitoring.sh"

show_health_dashboard() {
    while true; do
        clear
        echo "🏥 BILL SLOTH SYSTEM HEALTH DASHBOARD"
        echo "====================================="
        echo ""
        
        # Get latest health report
        if [ -f "$HEALTH_CONFIG_DIR/data/latest_health_report.json" ]; then
            local report=$(cat "$HEALTH_CONFIG_DIR/data/latest_health_report.json")
            local overall_status=$(echo "$report" | jq -r '.overall_status // "unknown"')
            local last_check=$(echo "$report" | jq -r '.generated_at // "unknown"')
            
            # Overall status
            case "$overall_status" in
                "healthy") echo "🟢 OVERALL STATUS: HEALTHY" ;;
                "warning") echo "🟡 OVERALL STATUS: WARNING" ;;
                "critical") echo "🔴 OVERALL STATUS: CRITICAL" ;;
                *) echo "⚪ OVERALL STATUS: UNKNOWN" ;;
            esac
            echo "Last Check: $last_check"
            echo ""
            
            # System metrics
            echo "📊 SYSTEM METRICS:"
            local metrics=$(echo "$report" | jq -r '.system_metrics')
            echo "  CPU Usage: $(echo "$metrics" | jq -r '.cpu_usage')%"
            echo "  Memory Usage: $(echo "$metrics" | jq -r '.memory_usage')%"
            echo "  Disk Usage: $(echo "$metrics" | jq -r '.disk_usage')%"
            echo "  Load Average: $(echo "$metrics" | jq -r '.load_average')"
            echo "  Network: $(echo "$metrics" | jq -r '.network_connectivity')"
            echo ""
            
            # Module status
            echo "🔧 MODULE HEALTH:"
            echo "$report" | jq -r '.module_health[] | "  \(.module): \(.status) - \(.message)"'
            echo ""
            
        else
            echo "⚠️  No health report available"
            echo ""
        fi
        
        echo "⚙️  ACTIONS:"
        echo "1) Generate new health report"
        echo "2) Start monitoring daemon"
        echo "3) Stop monitoring daemon"
        echo "4) View alert history"
        echo "5) Configure thresholds"
        echo "6) View detailed report"
        echo "0) Exit"
        echo ""
        
        read -p "Select action: " action
        
        case $action in
            1) generate_health_report "detailed" ;;
            2) 
                echo "Starting health monitoring daemon..."
                start_health_monitoring &
                echo "✅ Daemon started"
                ;;
            3) stop_health_monitoring ;;
            4)
                echo "📋 Recent Alerts:"
                if [ -f "$HEALTH_CONFIG_DIR/alerts/alert_history.json" ]; then
                    jq -r '.alerts[-10:] | .[] | "\(.timestamp): \(.message)"' "$HEALTH_CONFIG_DIR/alerts/alert_history.json"
                else
                    echo "No alerts recorded"
                fi
                ;;
            5)
                echo "Current thresholds:"
                echo "CPU: ${HEALTH_THRESHOLDS[cpu_usage]}%"
                echo "Memory: ${HEALTH_THRESHOLDS[memory_usage]}%"
                echo "Disk: ${HEALTH_THRESHOLDS[disk_usage]}%"
                ;;
            6)
                if [ -f "$HEALTH_CONFIG_DIR/data/latest_health_report.json" ]; then
                    jq '.' "$HEALTH_CONFIG_DIR/data/latest_health_report.json"
                else
                    echo "No detailed report available"
                fi
                ;;
            0) exit ;;
            *) echo "Invalid choice" ;;
        esac
        
        if [ "$action" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to continue..."
        fi
    done
}

# Start dashboard
show_health_dashboard
EOF
    chmod +x "$HEALTH_CONFIG_DIR/dashboards/health_dashboard.sh"
    
    log_success "Health dashboard created at: $HEALTH_CONFIG_DIR/dashboards/health_dashboard.sh"
}

# Export functions
export -f init_health_monitoring get_system_metrics check_module_health
export -f generate_health_report start_health_monitoring stop_health_monitoring
export -f create_health_dashboard evaluate_health_and_alert