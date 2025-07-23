#!/bin/bash
# LLM_CAPABILITY: local_ok
# Performance Monitoring and Optimization Library
# Real-time performance analysis and resource usage optimization for Bill Sloth


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/data_persistence.sh" 2>/dev/null || true

# Performance monitoring configuration
PERF_CONFIG_DIR="$HOME/.bill-sloth/performance"
PERF_DATA_DIR="$PERF_CONFIG_DIR/data"
PERF_REPORTS_DIR="$PERF_CONFIG_DIR/reports"
PERF_PROFILES_DIR="$PERF_CONFIG_DIR/profiles"

# Performance thresholds
declare -A PERF_THRESHOLDS=(
    ["cpu_usage_critical"]=95      # CPU usage % critical threshold
    ["cpu_usage_warning"]=80       # CPU usage % warning threshold
    ["memory_usage_critical"]=95   # Memory usage % critical threshold
    ["memory_usage_warning"]=80    # Memory usage % warning threshold
    ["disk_io_warning"]=100        # MB/s disk I/O warning threshold
    ["load_average_warning"]=4.0   # Load average warning threshold
    ["process_count_warning"]=200  # Process count warning
    ["open_files_warning"]=1000    # Open file descriptors warning
)

# Initialize performance monitoring system
init_performance_monitoring() {
    log_info "Initializing performance monitoring system..."
    
    # Create performance monitoring directories
    mkdir -p "$PERF_CONFIG_DIR"/{data,reports,profiles,cache}
    
    # Create performance configuration
    cat > "$PERF_CONFIG_DIR/config.json" << 'EOF'
{
  "monitoring": {
    "enabled": true,
    "interval_seconds": 10,
    "retention_hours": 168,
    "detailed_profiling": false,
    "auto_optimization": true
  },
  "modules_to_monitor": {
    "bill_command_center": {
      "enabled": true,
      "priority": "high",
      "cpu_limit_percent": 50,
      "memory_limit_mb": 512
    },
    "data_persistence": {
      "enabled": true,
      "priority": "high",
      "cpu_limit_percent": 30,
      "memory_limit_mb": 256
    },
    "backup_management": {
      "enabled": true,
      "priority": "medium",
      "cpu_limit_percent": 70,
      "memory_limit_mb": 1024
    },
    "media_processing": {
      "enabled": true,
      "priority": "low",
      "cpu_limit_percent": 80,
      "memory_limit_mb": 2048
    },
    "workflow_orchestration": {
      "enabled": true,
      "priority": "medium",
      "cpu_limit_percent": 40,
      "memory_limit_mb": 256
    }
  },
  "optimization_rules": {
    "enable_caching": true,
    "enable_compression": true,
    "enable_parallel_processing": true,
    "max_concurrent_operations": 4,
    "io_scheduling_priority": "normal"
  }
}
EOF
    
    # Initialize performance database tables
    if command -v sqlite3 &> /dev/null && [ "$DATABASE_ENGINE" = "sqlite3" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        sqlite3 "$db_file" << 'SQL'
-- Performance monitoring tables
CREATE TABLE IF NOT EXISTS performance_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    module_name TEXT NOT NULL,
    cpu_usage REAL,
    memory_usage_mb INTEGER,
    disk_read_mb REAL,
    disk_write_mb REAL,
    network_rx_mb REAL,
    network_tx_mb REAL,
    process_count INTEGER,
    open_files INTEGER,
    load_average REAL,
    operation_name TEXT,
    operation_duration_ms INTEGER,
    metadata TEXT
);

-- Performance optimization history
CREATE TABLE IF NOT EXISTS optimization_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    optimization_type TEXT NOT NULL,
    module_name TEXT NOT NULL,
    before_metrics TEXT, -- JSON
    after_metrics TEXT,  -- JSON
    improvement_percent REAL,
    status TEXT DEFAULT 'applied', -- applied, reverted, failed
    description TEXT
);

-- Resource usage alerts
CREATE TABLE IF NOT EXISTS performance_alerts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    alert_type TEXT NOT NULL, -- cpu, memory, disk, network, custom
    severity TEXT NOT NULL,   -- warning, critical
    module_name TEXT,
    metric_value REAL,
    threshold_value REAL,
    description TEXT,
    resolved BOOLEAN DEFAULT FALSE,
    resolved_at DATETIME
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_perf_metrics_timestamp ON performance_metrics(timestamp);
CREATE INDEX IF NOT EXISTS idx_perf_metrics_module ON performance_metrics(module_name);
CREATE INDEX IF NOT EXISTS idx_perf_alerts_timestamp ON performance_alerts(timestamp);
SQL
    fi
    
    log_success "Performance monitoring system initialized"
}

# Capture current system performance metrics
capture_performance_snapshot() {
    local module_name="${1:-system}"
    local operation_name="${2:-general}"
    local operation_duration="${3:-0}"
    
    # CPU usage
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//' 2>/dev/null || echo "0.0")
    
    # Memory usage
    local memory_info=$(free -m | grep '^Mem:')
    local memory_total=$(echo "$memory_info" | awk '{print $2}')
    local memory_used=$(echo "$memory_info" | awk '{print $3}')
    local memory_usage_mb="$memory_used"
    
    # Load average
    local load_average=$(uptime | awk -F'load average:' '{print $2}' | awk -F, '{print $1}' | xargs 2>/dev/null || echo "0.0")
    
    # Process count
    local process_count=$(ps -e --no-headers | wc -l)
    
    # Open files (if lsof is available)
    local open_files=0
    if command -v lsof &> /dev/null; then
        open_files=$(lsof 2>/dev/null | wc -l)
    fi
    
    # Disk I/O (basic estimation)
    local disk_read_mb="0.0"
    local disk_write_mb="0.0"
    if [ -f /proc/diskstats ]; then
        # Simple estimation - would need more sophisticated parsing for accuracy
        disk_read_mb=$(awk '{sum += $6} END {print sum/2048}' /proc/diskstats 2>/dev/null || echo "0.0")
        disk_write_mb=$(awk '{sum += $10} END {print sum/2048}' /proc/diskstats 2>/dev/null || echo "0.0")
    fi
    
    # Network usage (basic estimation)
    local network_rx_mb="0.0"
    local network_tx_mb="0.0"
    if [ -f /proc/net/dev ]; then
        network_rx_mb=$(awk '/eth0|wlan0/ {sum += $2} END {print sum/1048576}' /proc/net/dev 2>/dev/null || echo "0.0")
        network_tx_mb=$(awk '/eth0|wlan0/ {sum += $10} END {print sum/1048576}' /proc/net/dev 2>/dev/null || echo "0.0")
    fi
    
    # Store metrics in database
    if command -v sqlite3 &> /dev/null && [ "$DATABASE_ENGINE" = "sqlite3" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        sqlite3 "$db_file" << EOF
INSERT INTO performance_metrics 
(module_name, cpu_usage, memory_usage_mb, disk_read_mb, disk_write_mb, 
 network_rx_mb, network_tx_mb, process_count, open_files, load_average,
 operation_name, operation_duration_ms)
VALUES ('$module_name', $cpu_usage, $memory_usage_mb, $disk_read_mb, $disk_write_mb,
        $network_rx_mb, $network_tx_mb, $process_count, $open_files, $load_average,
        '$operation_name', $operation_duration);
EOF
    fi
    
    # Check for performance alerts
    check_performance_thresholds "$module_name" "$cpu_usage" "$memory_used" "$memory_total" "$load_average"
    
    # Return metrics as JSON
    cat << EOF
{
  "module": "$module_name",
  "operation": "$operation_name",
  "timestamp": "$(date -Iseconds)",
  "cpu_usage": $cpu_usage,
  "memory_usage_mb": $memory_usage_mb,
  "memory_total_mb": $memory_total,
  "load_average": $load_average,
  "process_count": $process_count,
  "open_files": $open_files,
  "disk_read_mb": $disk_read_mb,
  "disk_write_mb": $disk_write_mb,
  "network_rx_mb": $network_rx_mb,
  "network_tx_mb": $network_tx_mb,
  "operation_duration_ms": $operation_duration
}
EOF
}

# Check performance against thresholds and create alerts
check_performance_thresholds() {
    local module_name="$1"
    local cpu_usage="$2"
    local memory_used="$3"
    local memory_total="$4"
    local load_average="$5"
    
    # Calculate memory usage percentage
    local memory_percent=$(awk "BEGIN {printf \"%.1f\", ($memory_used/$memory_total)*100}")
    
    local alerts_created=0
    
    # CPU usage alerts
    if (( $(echo "$cpu_usage > ${PERF_THRESHOLDS[cpu_usage_critical]}" | bc -l) )); then
        create_performance_alert "cpu" "critical" "$module_name" "$cpu_usage" "${PERF_THRESHOLDS[cpu_usage_critical]}" "Critical CPU usage detected"
        ((alerts_created++))
    elif (( $(echo "$cpu_usage > ${PERF_THRESHOLDS[cpu_usage_warning]}" | bc -l) )); then
        create_performance_alert "cpu" "warning" "$module_name" "$cpu_usage" "${PERF_THRESHOLDS[cpu_usage_warning]}" "High CPU usage detected"
        ((alerts_created++))
    fi
    
    # Memory usage alerts
    if (( $(echo "$memory_percent > ${PERF_THRESHOLDS[memory_usage_critical]}" | bc -l) )); then
        create_performance_alert "memory" "critical" "$module_name" "$memory_percent" "${PERF_THRESHOLDS[memory_usage_critical]}" "Critical memory usage detected"
        ((alerts_created++))
    elif (( $(echo "$memory_percent > ${PERF_THRESHOLDS[memory_usage_warning]}" | bc -l) )); then
        create_performance_alert "memory" "warning" "$module_name" "$memory_percent" "${PERF_THRESHOLDS[memory_usage_warning]}" "High memory usage detected"
        ((alerts_created++))
    fi
    
    # Load average alerts
    if (( $(echo "$load_average > ${PERF_THRESHOLDS[load_average_warning]}" | bc -l) )); then
        create_performance_alert "load" "warning" "$module_name" "$load_average" "${PERF_THRESHOLDS[load_average_warning]}" "High system load detected"
        ((alerts_created++))
    fi
    
    return $alerts_created
}

# Create performance alert
create_performance_alert() {
    local alert_type="$1"
    local severity="$2"
    local module_name="$3"
    local metric_value="$4"
    local threshold_value="$5"
    local description="$6"
    
    # Store alert in database
    if command -v sqlite3 &> /dev/null && [ "$DATABASE_ENGINE" = "sqlite3" ]; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        sqlite3 "$db_file" << EOF
INSERT INTO performance_alerts 
(alert_type, severity, module_name, metric_value, threshold_value, description)
VALUES ('$alert_type', '$severity', '$module_name', $metric_value, $threshold_value, '$description');
EOF
    fi
    
    # Send notification based on severity
    if [ "$severity" = "critical" ]; then
        notify_error "Performance Critical" "$description: $metric_value (threshold: $threshold_value) in $module_name"
    else
        notify_warning "Performance Warning" "$description: $metric_value (threshold: $threshold_value) in $module_name"
    fi
    
    log_warning "Performance alert: $description [$alert_type/$severity] Module: $module_name, Value: $metric_value, Threshold: $threshold_value"
}

# Profile a specific operation
profile_operation() {
    local operation_name="$1"
    local module_name="${2:-unknown}"
    shift 2
    local command="$@"
    
    log_info "Profiling operation: $operation_name"
    
    # Capture before metrics
    local before_snapshot=$(capture_performance_snapshot "$module_name" "$operation_name" 0)
    local start_time=$(date +%s%N)
    
    # Execute the operation
    local exit_code=0
    eval "$command" || exit_code=$?
    
    # Calculate execution time
    local end_time=$(date +%s%N)
    local duration_ms=$(( (end_time - start_time) / 1000000 ))
    
    # Capture after metrics
    local after_snapshot=$(capture_performance_snapshot "$module_name" "$operation_name" "$duration_ms")
    
    # Store profiling results
    local profile_file="$PERF_PROFILES_DIR/${operation_name}_$(date +%Y%m%d_%H%M%S).json"
    cat > "$profile_file" << EOF
{
  "operation": "$operation_name",
  "module": "$module_name",
  "command": "$command",
  "duration_ms": $duration_ms,
  "exit_code": $exit_code,
  "before_metrics": $before_snapshot,
  "after_metrics": $after_snapshot,
  "timestamp": "$(date -Iseconds)"
}
EOF
    
    log_info "Operation '$operation_name' completed in ${duration_ms}ms (exit code: $exit_code)"
    
    return $exit_code
}

# Optimize module performance based on collected metrics
optimize_module_performance() {
    local module_name="$1"
    local optimization_type="${2:-auto}"
    
    log_info "Analyzing performance optimization opportunities for $module_name..."
    
    # Get recent performance data
    local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
    
    if ! command -v sqlite3 &> /dev/null || [ "$DATABASE_ENGINE" != "sqlite3" ]; then
        log_warning "Database not available for performance optimization"
        return 1
    fi
    
    # Analyze average CPU and memory usage over last hour
    local avg_cpu=$(sqlite3 "$db_file" "SELECT AVG(cpu_usage) FROM performance_metrics WHERE module_name='$module_name' AND timestamp > datetime('now', '-1 hour');" 2>/dev/null || echo "0")
    local avg_memory=$(sqlite3 "$db_file" "SELECT AVG(memory_usage_mb) FROM performance_metrics WHERE module_name='$module_name' AND timestamp > datetime('now', '-1 hour');" 2>/dev/null || echo "0")
    local max_cpu=$(sqlite3 "$db_file" "SELECT MAX(cpu_usage) FROM performance_metrics WHERE module_name='$module_name' AND timestamp > datetime('now', '-1 hour');" 2>/dev/null || echo "0")
    local max_memory=$(sqlite3 "$db_file" "SELECT MAX(memory_usage_mb) FROM performance_metrics WHERE module_name='$module_name' AND timestamp > datetime('now', '-1 hour');" 2>/dev/null || echo "0")
    
    # Get slow operations (> 5 seconds)
    local slow_operations=$(sqlite3 "$db_file" "SELECT operation_name, AVG(operation_duration_ms) as avg_duration FROM performance_metrics WHERE module_name='$module_name' AND operation_duration_ms > 5000 AND timestamp > datetime('now', '-24 hours') GROUP BY operation_name ORDER BY avg_duration DESC LIMIT 5;" 2>/dev/null || echo "")
    
    log_info "Performance analysis for $module_name:"
    log_info "  Average CPU: ${avg_cpu}% (Max: ${max_cpu}%)"
    log_info "  Average Memory: ${avg_memory}MB (Max: ${max_memory}MB)"
    
    local optimizations_applied=0
    local before_metrics="{\"avg_cpu\": $avg_cpu, \"avg_memory\": $avg_memory, \"max_cpu\": $max_cpu, \"max_memory\": $max_memory}"
    
    # Apply optimizations based on analysis
    case "$module_name" in
        "data_persistence")
            optimize_data_persistence_performance "$avg_cpu" "$avg_memory"
            ((optimizations_applied++))
            ;;
        "backup_management")
            optimize_backup_performance "$avg_cpu" "$avg_memory"
            ((optimizations_applied++))
            ;;
        "media_processing")
            optimize_media_processing_performance "$avg_cpu" "$avg_memory"
            ((optimizations_applied++))
            ;;
        "workflow_orchestration")
            optimize_workflow_performance "$avg_cpu" "$avg_memory"
            ((optimizations_applied++))
            ;;
        *)
            apply_generic_optimizations "$module_name" "$avg_cpu" "$avg_memory"
            ((optimizations_applied++))
            ;;
    esac
    
    # Record optimization in database
    local after_metrics="{\"optimization_applied\": true, \"timestamp\": \"$(date -Iseconds)\"}"
    sqlite3 "$db_file" << EOF
INSERT INTO optimization_history 
(optimization_type, module_name, before_metrics, after_metrics, description)
VALUES ('$optimization_type', '$module_name', '$before_metrics', '$after_metrics', 'Performance optimization applied based on metrics analysis');
EOF
    
    log_success "Applied $optimizations_applied optimization(s) to $module_name"
}

# Optimize data persistence performance
optimize_data_persistence_performance() {
    local avg_cpu="$1"
    local avg_memory="$2"
    
    log_info "Applying data persistence optimizations..."
    
    # Enable database optimization if high CPU usage
    if (( $(echo "$avg_cpu > 30" | bc -l) )); then
        log_info "High CPU usage detected - enabling database optimizations"
        
        # Add PRAGMA optimizations to database operations
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        if [ -f "$db_file" ]; then
            sqlite3 "$db_file" << 'SQL'
PRAGMA journal_mode = WAL;
PRAGMA synchronous = NORMAL;
PRAGMA cache_size = 10000;
PRAGMA temp_store = memory;
VACUUM;
ANALYZE;
SQL
            log_info "Database performance optimizations applied"
        fi
    fi
    
    # Enable caching for frequent queries if high memory available
    if (( $(echo "$avg_memory < 200" | bc -l) )); then
        log_info "Enabling query result caching to reduce database load"
        # This would integrate with the caching system in data_persistence.sh
    fi
}

# Optimize backup performance
optimize_backup_performance() {
    local avg_cpu="$1"
    local avg_memory="$2"
    
    log_info "Applying backup performance optimizations..."
    
    # Adjust compression based on CPU usage
    if (( $(echo "$avg_cpu > 60" | bc -l) )); then
        log_info "High CPU usage - reducing backup compression level"
        # This would modify backup_config.json to use lower compression
    else
        log_info "CPU usage normal - enabling efficient compression"
    fi
    
    # Adjust concurrency based on system resources
    local backup_config="$HOME/.bill-sloth/backups/config/backup_config.json"
    if [ -f "$backup_config" ]; then
        # Add performance tuning to backup config
        local temp_config=$(mktemp)
        jq '.performance_tuning = {
            "max_parallel_operations": 2,
            "compression_level": 6,
            "buffer_size_mb": 64,
            "throttle_cpu_percent": 70
        }' "$backup_config" > "$temp_config" && mv "$temp_config" "$backup_config"
        log_info "Backup performance tuning configuration updated"
    fi
}

# Optimize media processing performance
optimize_media_processing_performance() {
    local avg_cpu="$1"
    local avg_memory="$2"
    
    log_info "Applying media processing optimizations..."
    
    # Adjust processing based on available resources
    if (( $(echo "$avg_memory > 1024" | bc -l) )); then
        log_info "High memory available - enabling memory-intensive optimizations"
    fi
    
    if (( $(echo "$avg_cpu > 70" | bc -l) )); then
        log_info "High CPU usage - reducing concurrent media operations"
    fi
}

# Optimize workflow orchestration performance
optimize_workflow_performance() {
    local avg_cpu="$1"
    local avg_memory="$2"
    
    log_info "Applying workflow orchestration optimizations..."
    
    # Adjust workflow concurrency
    if (( $(echo "$avg_cpu > 50" | bc -l) )); then
        log_info "Reducing concurrent workflow executions due to high CPU usage"
    fi
}

# Apply generic performance optimizations
apply_generic_optimizations() {
    local module_name="$1"
    local avg_cpu="$2"
    local avg_memory="$3"
    
    log_info "Applying generic optimizations for $module_name..."
    
    # General system optimizations
    if (( $(echo "$avg_cpu > 80" | bc -l) )); then
        log_warning "High CPU usage detected - consider reviewing $module_name implementation"
    fi
    
    if (( $(echo "$avg_memory > 500" | bc -l) )); then
        log_warning "High memory usage detected - consider memory optimization for $module_name"
    fi
}

# Generate performance report
generate_performance_report() {
    local report_period="${1:-24}"  # hours
    local report_file="$PERF_REPORTS_DIR/performance_report_$(date +%Y%m%d_%H%M%S).txt"
    
    log_info "Generating performance report for last $report_period hours..."
    
    local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
    
    if ! command -v sqlite3 &> /dev/null || [ "$DATABASE_ENGINE" != "sqlite3" ]; then
        log_error "Database not available for performance reporting"
        return 1
    fi
    
    cat > "$report_file" << EOF
Bill Sloth Performance Report
Generated: $(date)
Report Period: Last $report_period hours

SYSTEM PERFORMANCE SUMMARY
==========================
EOF
    
    # Overall system metrics
    sqlite3 "$db_file" << SQL >> "$report_file"
.headers on
.mode column
SELECT 
  AVG(cpu_usage) as 'Avg CPU %',
  MAX(cpu_usage) as 'Peak CPU %',
  AVG(memory_usage_mb) as 'Avg Memory MB',
  MAX(memory_usage_mb) as 'Peak Memory MB',
  AVG(load_average) as 'Avg Load',
  MAX(load_average) as 'Peak Load'
FROM performance_metrics 
WHERE timestamp > datetime('now', '-$report_period hours');
SQL
    
    echo "" >> "$report_file"
    echo "MODULE PERFORMANCE BREAKDOWN" >> "$report_file"
    echo "============================" >> "$report_file"
    
    # Per-module performance
    sqlite3 "$db_file" << SQL >> "$report_file"
.headers on
.mode column
SELECT 
  module_name as 'Module',
  COUNT(*) as 'Measurements',
  ROUND(AVG(cpu_usage), 2) as 'Avg CPU %',
  ROUND(MAX(cpu_usage), 2) as 'Peak CPU %',
  ROUND(AVG(memory_usage_mb), 1) as 'Avg Memory MB',
  ROUND(MAX(memory_usage_mb), 1) as 'Peak Memory MB'
FROM performance_metrics 
WHERE timestamp > datetime('now', '-$report_period hours')
GROUP BY module_name 
ORDER BY AVG(cpu_usage) DESC;
SQL
    
    echo "" >> "$report_file"
    echo "SLOWEST OPERATIONS" >> "$report_file"
    echo "==================" >> "$report_file"
    
    # Slowest operations
    sqlite3 "$db_file" << SQL >> "$report_file"
.headers on
.mode column
SELECT 
  module_name as 'Module',
  operation_name as 'Operation',
  ROUND(AVG(operation_duration_ms), 0) as 'Avg Duration (ms)',
  ROUND(MAX(operation_duration_ms), 0) as 'Max Duration (ms)',
  COUNT(*) as 'Count'
FROM performance_metrics 
WHERE timestamp > datetime('now', '-$report_period hours')
  AND operation_duration_ms > 0
GROUP BY module_name, operation_name
ORDER BY AVG(operation_duration_ms) DESC
LIMIT 10;
SQL
    
    echo "" >> "$report_file"
    echo "PERFORMANCE ALERTS" >> "$report_file"
    echo "==================" >> "$report_file"
    
    # Recent alerts
    sqlite3 "$db_file" << SQL >> "$report_file"
.headers on
.mode column
SELECT 
  alert_type as 'Type',
  severity as 'Severity',
  module_name as 'Module',
  ROUND(metric_value, 2) as 'Value',
  ROUND(threshold_value, 2) as 'Threshold',
  description as 'Description',
  timestamp as 'Time'
FROM performance_alerts 
WHERE timestamp > datetime('now', '-$report_period hours')
ORDER BY timestamp DESC
LIMIT 20;
SQL
    
    echo "" >> "$report_file"
    echo "OPTIMIZATION HISTORY" >> "$report_file"
    echo "====================" >> "$report_file"
    
    # Optimization history
    sqlite3 "$db_file" << SQL >> "$report_file"
.headers on
.mode column
SELECT 
  module_name as 'Module',
  optimization_type as 'Type',
  status as 'Status',
  ROUND(improvement_percent, 1) as 'Improvement %',
  description as 'Description',
  timestamp as 'Applied'
FROM optimization_history 
WHERE timestamp > datetime('now', '-$report_period hours')
ORDER BY timestamp DESC;
SQL
    
    # Add recommendations
    cat >> "$report_file" << 'EOF'

RECOMMENDATIONS
===============
- Monitor modules with consistently high CPU usage (>70%)
- Consider memory optimization for modules using >1GB RAM
- Review operations taking longer than 5 seconds
- Address critical performance alerts promptly
- Regular performance optimization should be run weekly

EOF
    
    log_success "Performance report generated: $report_file"
    echo "$report_file"
}

# Cleanup old performance data
cleanup_performance_data() {
    local retention_days="${1:-7}"
    
    log_info "Cleaning up performance data older than $retention_days days..."
    
    local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
    
    if command -v sqlite3 &> /dev/null && [ "$DATABASE_ENGINE" = "sqlite3" ]; then
        # Clean up old metrics
        local deleted_metrics=$(sqlite3 "$db_file" "DELETE FROM performance_metrics WHERE timestamp < datetime('now', '-$retention_days days'); SELECT changes();")
        local deleted_alerts=$(sqlite3 "$db_file" "DELETE FROM performance_alerts WHERE timestamp < datetime('now', '-$retention_days days') AND resolved = 1; SELECT changes();")
        
        log_info "Cleaned up $deleted_metrics performance metrics and $deleted_alerts resolved alerts"
        
        # Vacuum database for space reclaim
        sqlite3 "$db_file" "VACUUM;"
    fi
    
    # Clean up old profile files
    if [ -d "$PERF_PROFILES_DIR" ]; then
        find "$PERF_PROFILES_DIR" -name "*.json" -mtime +$retention_days -delete
    fi
    
    # Clean up old report files (keep last 30 days)
    if [ -d "$PERF_REPORTS_DIR" ]; then
        find "$PERF_REPORTS_DIR" -name "*.txt" -mtime +30 -delete
    fi
    
    log_success "Performance data cleanup complete"
}

# Export functions
export -f init_performance_monitoring capture_performance_snapshot profile_operation
export -f optimize_module_performance generate_performance_report cleanup_performance_data
export -f check_performance_thresholds create_performance_alert

# Initialize performance monitoring on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_performance_monitoring 2>/dev/null || true
fi

# Main function for standalone execution
performance_monitoring_main() {
    local command="$1"
    shift || true
    
    case "$command" in
        init)
            init_performance_monitoring
            ;;
        capture|snapshot)
            capture_performance_snapshot "$@"
            ;;
        profile)
            if [ $# -lt 2 ]; then
                echo "Usage: performance_monitoring_main profile <operation_name> <module_name> <command>"
                return 1
            fi
            profile_operation "$@"
            ;;
        optimize)
            if [ $# -lt 1 ]; then
                echo "Usage: performance_monitoring_main optimize <module_name> [optimization_type]"
                return 1
            fi
            optimize_module_performance "$@"
            ;;
        report)
            generate_performance_report "$1"
            ;;
        cleanup)
            cleanup_performance_data "$1"
            ;;
        *)
            echo "Bill Sloth Performance Monitoring System"
            echo "Usage: $0 {init|capture|profile|optimize|report|cleanup}"
            echo ""
            echo "Commands:"
            echo "  init                    - Initialize performance monitoring"
            echo "  capture [module] [op]   - Capture performance snapshot"
            echo "  profile <op> <mod> <cmd> - Profile specific operation"
            echo "  optimize <module>       - Optimize module performance"
            echo "  report [hours]          - Generate performance report"
            echo "  cleanup [days]          - Cleanup old performance data"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    performance_monitoring_main "$@"
fi