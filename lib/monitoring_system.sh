#!/bin/bash
# LLM_CAPABILITY: local_ok
# Comprehensive Monitoring and Alerting System for Bill Sloth Business Services
# Professional-grade monitoring with intelligent alerting

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Configuration
MONITORING_BASE_DIR="$HOME/.bill-sloth/monitoring"
MONITORING_CONFIG="$MONITORING_BASE_DIR/config/monitoring.json"
MONITORING_DB="$MONITORING_BASE_DIR/monitoring.db"
MONITORING_LOGS="$MONITORING_BASE_DIR/logs"
METRICS_CACHE_DIR="$MONITORING_BASE_DIR/cache"

# Service endpoints
VRBO_API_ENDPOINT="http://localhost:8000"
GUEST_COMMS_ENDPOINT="http://localhost:8001"
ANALYTICS_ENDPOINT="http://localhost:8002"
POSTGRES_HOST="localhost"
POSTGRES_PORT="5432"
REDIS_HOST="localhost"
REDIS_PORT="6379"

# Initialize monitoring system
init_monitoring_system() {
    log_info "Initializing comprehensive monitoring system..."
    
    # Create directory structure
    mkdir -p "$MONITORING_BASE_DIR"/{config,logs,cache,alerts,reports}
    mkdir -p "$MONITORING_LOGS"/{services,system,alerts}
    
    # Initialize monitoring database
    init_monitoring_database
    
    # Create monitoring configuration
    if [ ! -f "$MONITORING_CONFIG" ]; then
        create_monitoring_config
    fi
    
    # Initialize metrics cache
    init_metrics_cache
    
    log_success "Monitoring system initialized"
}

# Initialize monitoring database
init_monitoring_database() {
    sqlite3 "$MONITORING_DB" << 'EOF'
CREATE TABLE IF NOT EXISTS service_health (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    service_name TEXT NOT NULL,
    endpoint TEXT,
    status TEXT NOT NULL,
    response_time_ms INTEGER,
    error_message TEXT,
    checked_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS system_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    metric_name TEXT NOT NULL,
    metric_value REAL NOT NULL,
    metric_unit TEXT,
    metric_type TEXT,
    collected_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS alerts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    alert_id TEXT UNIQUE NOT NULL,
    alert_type TEXT NOT NULL,
    severity TEXT NOT NULL,
    service_name TEXT,
    message TEXT NOT NULL,
    details TEXT,
    status TEXT DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP,
    acknowledged_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS alert_rules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    rule_name TEXT UNIQUE NOT NULL,
    service_name TEXT NOT NULL,
    metric_name TEXT NOT NULL,
    condition TEXT NOT NULL,
    threshold_value REAL NOT NULL,
    severity TEXT NOT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS maintenance_windows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    window_name TEXT NOT NULL,
    service_name TEXT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_service_health_service ON service_health(service_name);
CREATE INDEX IF NOT EXISTS idx_service_health_time ON service_health(checked_at);
CREATE INDEX IF NOT EXISTS idx_system_metrics_name ON system_metrics(metric_name);
CREATE INDEX IF NOT EXISTS idx_system_metrics_time ON system_metrics(collected_at);
CREATE INDEX IF NOT EXISTS idx_alerts_status ON alerts(status);
CREATE INDEX IF NOT EXISTS idx_alerts_type ON alerts(alert_type);
EOF
}

# Create monitoring configuration
create_monitoring_config() {
    cat > "$MONITORING_CONFIG" << 'EOF'
{
  "services": {
    "vrbo_automation": {
      "name": "VRBO Automation Service",
      "type": "http",
      "endpoint": "http://localhost:8000/health",
      "timeout": 10,
      "expected_status": 200,
      "critical": true,
      "check_interval": 30
    },
    "guest_communication": {
      "name": "Guest Communication Service",
      "type": "http",
      "endpoint": "http://localhost:8001/health",
      "timeout": 10,
      "expected_status": 200,
      "critical": true,
      "check_interval": 30
    },
    "analytics": {
      "name": "Business Analytics Service",
      "type": "http",
      "endpoint": "http://localhost:8002/health",
      "timeout": 10,
      "expected_status": 200,
      "critical": false,
      "check_interval": 60
    },
    "postgres": {
      "name": "PostgreSQL Database",
      "type": "tcp",
      "host": "localhost",
      "port": 5432,
      "timeout": 5,
      "critical": true,
      "check_interval": 30
    },
    "redis": {
      "name": "Redis Cache",
      "type": "tcp",
      "host": "localhost",
      "port": 6379,
      "timeout": 5,
      "critical": true,
      "check_interval": 30
    },
    "grafana": {
      "name": "Grafana Dashboard",
      "type": "http",
      "endpoint": "http://localhost:3000/api/health",
      "timeout": 10,
      "expected_status": 200,
      "critical": false,
      "check_interval": 60
    }
  },
  "system_metrics": {
    "disk_usage": {
      "name": "Disk Usage",
      "command": "df -h / | awk 'NR==2 {print $5}' | sed 's/%//g'",
      "unit": "percent",
      "warning_threshold": 80,
      "critical_threshold": 90,
      "check_interval": 300
    },
    "memory_usage": {
      "name": "Memory Usage",
      "command": "free | awk 'NR==2{printf \"%.0f\", $3*100/$2}'",
      "unit": "percent",
      "warning_threshold": 80,
      "critical_threshold": 90,
      "check_interval": 60
    },
    "cpu_usage": {
      "name": "CPU Usage",
      "command": "top -bn1 | grep 'Cpu(s)' | awk '{print $2+$4}' | sed 's/%us,//g'",
      "unit": "percent",
      "warning_threshold": 80,
      "critical_threshold": 95,
      "check_interval": 60
    },
    "docker_containers": {
      "name": "Docker Containers Running",
      "command": "docker ps --format 'table {{.Names}}' | tail -n +2 | wc -l",
      "unit": "count",
      "warning_threshold": 5,
      "critical_threshold": 3,
      "comparison": "less_than",
      "check_interval": 60
    },
    "vrbo_api_queue": {
      "name": "VRBO API Queue Size",
      "command": "docker exec bill-redis redis-cli LLEN vrbo_api_queue 2>/dev/null || echo 0",
      "unit": "count",
      "warning_threshold": 100,
      "critical_threshold": 500,
      "check_interval": 120
    },
    "guest_message_queue": {
      "name": "Guest Message Queue Size",
      "command": "docker exec bill-redis redis-cli ZCARD message_queue 2>/dev/null || echo 0",
      "unit": "count",
      "warning_threshold": 50,
      "critical_threshold": 200,
      "check_interval": 120
    }
  },
  "business_metrics": {
    "daily_bookings": {
      "name": "Daily New Bookings",
      "query": "SELECT COUNT(*) FROM bookings WHERE DATE(created_date) = CURRENT_DATE",
      "unit": "count",
      "warning_threshold": 0,
      "comparison": "equals",
      "check_interval": 3600
    },
    "vrbo_sync_age": {
      "name": "Hours Since Last VRBO Sync",
      "query": "SELECT EXTRACT(EPOCH FROM (NOW() - MAX(last_updated)))/3600 FROM properties WHERE sync_status = 'active'",
      "unit": "hours",
      "warning_threshold": 6,
      "critical_threshold": 24,
      "check_interval": 1800
    },
    "failed_messages": {
      "name": "Failed Guest Messages (24h)",
      "query": "SELECT COUNT(*) FROM message_logs WHERE status = 'failed' AND created_at > NOW() - INTERVAL '24 hours'",
      "unit": "count",
      "warning_threshold": 5,
      "critical_threshold": 20,
      "check_interval": 1800
    }
  },
  "alert_channels": {
    "email": {
      "enabled": true,
      "recipients": ["bill@example.com"],
      "severity_filter": ["critical", "warning"]
    },
    "slack": {
      "enabled": false,
      "webhook_url": "",
      "channel": "#alerts",
      "severity_filter": ["critical"]
    },
    "pushover": {
      "enabled": false,
      "user_key": "",
      "api_token": "",
      "severity_filter": ["critical"]
    }
  },
  "alert_rules": {
    "service_down": {
      "description": "Service is down or unreachable",
      "condition": "status != 'healthy'",
      "severity": "critical",
      "cooldown": 300
    },
    "high_response_time": {
      "description": "Service response time is high",
      "condition": "response_time > 5000",
      "severity": "warning",
      "cooldown": 600
    },
    "resource_warning": {
      "description": "System resource usage is high",
      "condition": "metric_value > warning_threshold",
      "severity": "warning",
      "cooldown": 900
    },
    "resource_critical": {
      "description": "System resource usage is critical",
      "condition": "metric_value > critical_threshold",
      "severity": "critical",
      "cooldown": 300
    }
  },
  "general_settings": {
    "check_interval": 30,
    "retention_days": 30,
    "max_alerts_per_hour": 10,
    "alert_aggregation_window": 300,
    "maintenance_mode": false
  }
}
EOF
}

# Initialize metrics cache
init_metrics_cache() {
    # Create Redis-like cache structure using files
    mkdir -p "$METRICS_CACHE_DIR"/{current,history}
    
    # Initialize current metrics file
    echo '{}' > "$METRICS_CACHE_DIR/current/system_metrics.json"
    echo '{}' > "$METRICS_CACHE_DIR/current/service_health.json"
    echo '{}' > "$METRICS_CACHE_DIR/current/business_metrics.json"
}

# Check service health
check_service_health() {
    local service_name="$1"
    
    # Load service configuration
    local service_config=$(jq -r ".services.$service_name" "$MONITORING_CONFIG")
    
    if [ "$service_config" = "null" ]; then
        log_error "Service configuration not found: $service_name"
        return 1
    fi
    
    local service_type=$(echo "$service_config" | jq -r '.type')
    local endpoint=$(echo "$service_config" | jq -r '.endpoint // ""')
    local host=$(echo "$service_config" | jq -r '.host // ""')
    local port=$(echo "$service_config" | jq -r '.port // ""')
    local timeout=$(echo "$service_config" | jq -r '.timeout // 10')
    local expected_status=$(echo "$service_config" | jq -r '.expected_status // 200')
    
    local status="unhealthy"
    local response_time=0
    local error_message=""
    local start_time=$(date +%s%3N)
    
    case "$service_type" in
        "http")
            local response
            response=$(curl -s -w '\n%{http_code}\n%{time_total}' \
                       --max-time "$timeout" \
                       --connect-timeout "$timeout" \
                       "$endpoint" 2>&1 || echo "ERROR")
            
            if [ "$response" != "ERROR" ]; then
                local http_code=$(echo "$response" | tail -n2 | head -n1)
                local time_total=$(echo "$response" | tail -n1)
                response_time=$(echo "$time_total * 1000" | bc | cut -d. -f1)
                
                if [ "$http_code" = "$expected_status" ]; then
                    status="healthy"
                else
                    error_message="HTTP $http_code (expected $expected_status)"
                fi
            else
                error_message="Connection failed or timeout"
                response_time=$((timeout * 1000))
            fi
            ;;
            
        "tcp")
            if timeout "$timeout" bash -c "</dev/tcp/$host/$port" 2>/dev/null; then
                local end_time=$(date +%s%3N)
                response_time=$((end_time - start_time))
                status="healthy"
            else
                error_message="TCP connection failed"
                response_time=$((timeout * 1000))
            fi
            ;;
            
        "command")
            local check_command=$(echo "$service_config" | jq -r '.command')
            if eval "$check_command" >/dev/null 2>&1; then
                local end_time=$(date +%s%3N)
                response_time=$((end_time - start_time))
                status="healthy"
            else
                error_message="Command execution failed"
            fi
            ;;
    esac
    
    # Record health check result
    sqlite3 "$MONITORING_DB" "INSERT INTO service_health 
                              (service_name, endpoint, status, response_time_ms, error_message)
                              VALUES ('$service_name', '$endpoint$host:$port', '$status', $response_time, '$error_message');"
    
    # Update cache
    local current_health=$(cat "$METRICS_CACHE_DIR/current/service_health.json")
    current_health=$(echo "$current_health" | jq \
        ".\"$service_name\" = {
            \"status\": \"$status\",
            \"response_time_ms\": $response_time,
            \"error_message\": \"$error_message\",
            \"last_check\": \"$(date -Iseconds)\"
        }")
    echo "$current_health" > "$METRICS_CACHE_DIR/current/service_health.json"
    
    # Check for alerts
    if [ "$status" != "healthy" ]; then
        local is_critical=$(echo "$service_config" | jq -r '.critical // false')
        local severity="warning"
        if [ "$is_critical" = "true" ]; then
            severity="critical"
        fi
        
        trigger_alert "service_down" "$severity" "$service_name" \
                     "Service $service_name is $status: $error_message"
    fi
    
    return 0
}

# Collect system metrics
collect_system_metrics() {
    log_debug "Collecting system metrics..."
    
    local metrics_config=$(jq -r '.system_metrics' "$MONITORING_CONFIG")
    local metric_names=$(echo "$metrics_config" | jq -r 'keys[]')
    
    echo "$metric_names" | while read -r metric_name; do
        local metric_config=$(echo "$metrics_config" | jq -r ".\"$metric_name\"")
        local command=$(echo "$metric_config" | jq -r '.command')
        local unit=$(echo "$metric_config" | jq -r '.unit // ""')
        local warning_threshold=$(echo "$metric_config" | jq -r '.warning_threshold // null')
        local critical_threshold=$(echo "$metric_config" | jq -r '.critical_threshold // null')
        local comparison=$(echo "$metric_config" | jq -r '.comparison // "greater_than"')
        
        # Execute metric collection command
        local metric_value
        metric_value=$(eval "$command" 2>/dev/null || echo 0)
        
        # Ensure numeric value
        if ! [[ "$metric_value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            metric_value=0
        fi
        
        # Record metric
        sqlite3 "$MONITORING_DB" "INSERT INTO system_metrics 
                                  (metric_name, metric_value, metric_unit, metric_type)
                                  VALUES ('$metric_name', $metric_value, '$unit', 'system');"
        
        # Update cache
        local current_metrics=$(cat "$METRICS_CACHE_DIR/current/system_metrics.json")
        current_metrics=$(echo "$current_metrics" | jq \
            ".\"$metric_name\" = {
                \"value\": $metric_value,
                \"unit\": \"$unit\",
                \"collected_at\": \"$(date -Iseconds)\"
            }")
        echo "$current_metrics" > "$METRICS_CACHE_DIR/current/system_metrics.json"
        
        # Check thresholds and trigger alerts
        check_metric_thresholds "$metric_name" "$metric_value" \
                               "$warning_threshold" "$critical_threshold" "$comparison"
    done
}

# Collect business metrics
collect_business_metrics() {
    log_debug "Collecting business metrics..."
    
    local metrics_config=$(jq -r '.business_metrics' "$MONITORING_CONFIG")
    local metric_names=$(echo "$metrics_config" | jq -r 'keys[]')
    
    echo "$metric_names" | while read -r metric_name; do
        local metric_config=$(echo "$metrics_config" | jq -r ".\"$metric_name\"")
        local query=$(echo "$metric_config" | jq -r '.query')
        local unit=$(echo "$metric_config" | jq -r '.unit // ""')
        local warning_threshold=$(echo "$metric_config" | jq -r '.warning_threshold // null')
        local critical_threshold=$(echo "$metric_config" | jq -r '.critical_threshold // null')
        local comparison=$(echo "$metric_config" | jq -r '.comparison // "greater_than"')
        
        # Execute database query
        local metric_value
        metric_value=$(docker exec bill-postgres psql -U bill -d bill_business -t -c "$query" 2>/dev/null | xargs || echo 0)
        
        # Ensure numeric value
        if ! [[ "$metric_value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
            metric_value=0
        fi
        
        # Record metric
        sqlite3 "$MONITORING_DB" "INSERT INTO system_metrics 
                                  (metric_name, metric_value, metric_unit, metric_type)
                                  VALUES ('$metric_name', $metric_value, '$unit', 'business');"
        
        # Update cache
        local current_metrics=$(cat "$METRICS_CACHE_DIR/current/business_metrics.json")
        current_metrics=$(echo "$current_metrics" | jq \
            ".\"$metric_name\" = {
                \"value\": $metric_value,
                \"unit\": \"$unit\",
                \"collected_at\": \"$(date -Iseconds)\"
            }")
        echo "$current_metrics" > "$METRICS_CACHE_DIR/current/business_metrics.json"
        
        # Check thresholds and trigger alerts
        check_metric_thresholds "$metric_name" "$metric_value" \
                               "$warning_threshold" "$critical_threshold" "$comparison"
    done
}

# Check metric thresholds
check_metric_thresholds() {
    local metric_name="$1"
    local metric_value="$2"
    local warning_threshold="$3"
    local critical_threshold="$4"
    local comparison="${5:-greater_than}"
    
    # Skip if no thresholds defined
    if [ "$warning_threshold" = "null" ] && [ "$critical_threshold" = "null" ]; then
        return 0
    fi
    
    local alert_triggered=false
    local severity=""
    local message=""
    
    # Check critical threshold first
    if [ "$critical_threshold" != "null" ]; then
        if compare_values "$metric_value" "$critical_threshold" "$comparison"; then
            severity="critical"
            message="Critical threshold exceeded: $metric_name = $metric_value (threshold: $critical_threshold)"
            alert_triggered=true
        fi
    fi
    
    # Check warning threshold if critical not triggered
    if [ "$alert_triggered" = "false" ] && [ "$warning_threshold" != "null" ]; then
        if compare_values "$metric_value" "$warning_threshold" "$comparison"; then
            severity="warning"
            message="Warning threshold exceeded: $metric_name = $metric_value (threshold: $warning_threshold)"
            alert_triggered=true
        fi
    fi
    
    # Trigger alert if threshold exceeded
    if [ "$alert_triggered" = "true" ]; then
        trigger_alert "metric_threshold" "$severity" "$metric_name" "$message"
    fi
}

# Compare values based on comparison type
compare_values() {
    local value1="$1"
    local value2="$2"
    local comparison="$3"
    
    case "$comparison" in
        "greater_than") 
            [ "$(echo "$value1 > $value2" | bc)" -eq 1 ] ;;
        "less_than") 
            [ "$(echo "$value1 < $value2" | bc)" -eq 1 ] ;;
        "equals") 
            [ "$(echo "$value1 == $value2" | bc)" -eq 1 ] ;;
        "not_equals") 
            [ "$(echo "$value1 != $value2" | bc)" -eq 1 ] ;;
        *) 
            [ "$(echo "$value1 > $value2" | bc)" -eq 1 ] ;;
    esac
}

# Trigger alert
trigger_alert() {
    local alert_type="$1"
    local severity="$2"
    local service_name="$3"
    local message="$4"
    local details="${5:-}"
    
    local alert_id="${alert_type}_${service_name}_$(date +%s)"
    
    # Check if similar alert already exists (cooldown)
    local cooldown=$(jq -r ".alert_rules.$alert_type.cooldown // 300" "$MONITORING_CONFIG")
    local existing_alert=$(sqlite3 "$MONITORING_DB" "
        SELECT COUNT(*) FROM alerts 
        WHERE alert_type = '$alert_type' 
        AND service_name = '$service_name' 
        AND status = 'active'
        AND created_at > datetime('now', '-$cooldown seconds')
    ")
    
    if [ "$existing_alert" -gt 0 ]; then
        log_debug "Alert suppressed due to cooldown: $alert_type ($service_name)"
        return 0
    fi
    
    # Check maintenance window
    if is_in_maintenance_window "$service_name"; then
        log_debug "Alert suppressed due to maintenance window: $service_name"
        return 0
    fi
    
    # Record alert
    sqlite3 "$MONITORING_DB" "INSERT INTO alerts 
                              (alert_id, alert_type, severity, service_name, message, details)
                              VALUES ('$alert_id', '$alert_type', '$severity', '$service_name', '$message', '$details');"
    
    log_warning "Alert triggered: $alert_id - $message"
    
    # Send notifications
    send_alert_notifications "$alert_id" "$severity" "$service_name" "$message" "$details"
    
    return 0
}

# Check if service is in maintenance window
is_in_maintenance_window() {
    local service_name="$1"
    
    local maintenance_count=$(sqlite3 "$MONITORING_DB" "
        SELECT COUNT(*) FROM maintenance_windows 
        WHERE service_name = '$service_name'
        AND datetime('now') BETWEEN start_time AND end_time
    ")
    
    [ "$maintenance_count" -gt 0 ]
}

# Send alert notifications
send_alert_notifications() {
    local alert_id="$1"
    local severity="$2"
    local service_name="$3"
    local message="$4"
    local details="$5"
    
    # Load notification settings
    local alert_channels=$(jq -r '.alert_channels' "$MONITORING_CONFIG")
    
    # Email notifications
    local email_enabled=$(echo "$alert_channels" | jq -r '.email.enabled // false')
    if [ "$email_enabled" = "true" ]; then
        local email_severities=$(echo "$alert_channels" | jq -r '.email.severity_filter[]' 2>/dev/null || echo "")
        if echo "$email_severities" | grep -q "$severity"; then
            send_email_alert "$alert_id" "$severity" "$service_name" "$message" "$details"
        fi
    fi
    
    # Slack notifications
    local slack_enabled=$(echo "$alert_channels" | jq -r '.slack.enabled // false')
    if [ "$slack_enabled" = "true" ]; then
        local slack_severities=$(echo "$alert_channels" | jq -r '.slack.severity_filter[]' 2>/dev/null || echo "")
        if echo "$slack_severities" | grep -q "$severity"; then
            send_slack_alert "$alert_id" "$severity" "$service_name" "$message" "$details"
        fi
    fi
}

# Send email alert
send_email_alert() {
    local alert_id="$1"
    local severity="$2"
    local service_name="$3"
    local message="$4"
    local details="$5"
    
    local subject="[$severity] Bill Sloth Alert: $service_name"
    local body="Alert ID: $alert_id
Service: $service_name
Severity: $severity
Time: $(date)

Message: $message

Details: $details

---
Bill Sloth Monitoring System"
    
    # Use notification system to send email
    notify_error "Monitoring Alert" "$body" 2>/dev/null || log_warning "Failed to send email alert"
}

# Send Slack alert
send_slack_alert() {
    local alert_id="$1"
    local severity="$2"
    local service_name="$3"
    local message="$4"
    local details="$5"
    
    local webhook_url=$(jq -r '.alert_channels.slack.webhook_url' "$MONITORING_CONFIG")
    local channel=$(jq -r '.alert_channels.slack.channel // "#alerts"' "$MONITORING_CONFIG")
    
    if [ -n "$webhook_url" ] && [ "$webhook_url" != "null" ]; then
        local color="warning"
        if [ "$severity" = "critical" ]; then
            color="danger"
        fi
        
        local payload=$(jq -n \
            --arg channel "$channel" \
            --arg text "Bill Sloth Alert: $service_name" \
            --arg color "$color" \
            --arg alert_id "$alert_id" \
            --arg severity "$severity" \
            --arg service "$service_name" \
            --arg message "$message" \
            --arg time "$(date)" \
            '{
                channel: $channel,
                text: $text,
                attachments: [{
                    color: $color,
                    fields: [
                        {title: "Alert ID", value: $alert_id, short: true},
                        {title: "Severity", value: $severity, short: true},
                        {title: "Service", value: $service, short: true},
                        {title: "Time", value: $time, short: true},
                        {title: "Message", value: $message, short: false}
                    ]
                }]
            }')
        
        curl -s -X POST -H 'Content-type: application/json' \
             --data "$payload" "$webhook_url" >/dev/null || \
             log_warning "Failed to send Slack alert"
    fi
}

# Run comprehensive monitoring check
run_monitoring_check() {
    log_info "Running comprehensive monitoring check..."
    
    # Check if maintenance mode is enabled
    local maintenance_mode=$(jq -r '.general_settings.maintenance_mode // false' "$MONITORING_CONFIG")
    if [ "$maintenance_mode" = "true" ]; then
        log_info "Monitoring in maintenance mode - skipping checks"
        return 0
    fi
    
    # Check all services
    local services=$(jq -r '.services | keys[]' "$MONITORING_CONFIG")
    echo "$services" | while read -r service_name; do
        check_service_health "$service_name"
    done
    
    # Collect system metrics
    collect_system_metrics
    
    # Collect business metrics
    collect_business_metrics
    
    # Clean up old data
    cleanup_old_monitoring_data
    
    log_success "Monitoring check completed"
}

# Cleanup old monitoring data
cleanup_old_monitoring_data() {
    local retention_days=$(jq -r '.general_settings.retention_days // 30' "$MONITORING_CONFIG")
    
    # Clean up old service health records
    sqlite3 "$MONITORING_DB" "DELETE FROM service_health 
                              WHERE checked_at < datetime('now', '-$retention_days days');"
    
    # Clean up old metrics
    sqlite3 "$MONITORING_DB" "DELETE FROM system_metrics 
                              WHERE collected_at < datetime('now', '-$retention_days days');"
    
    # Clean up resolved alerts
    sqlite3 "$MONITORING_DB" "DELETE FROM alerts 
                              WHERE status = 'resolved' 
                              AND resolved_at < datetime('now', '-$retention_days days');"
}

# Get monitoring dashboard
get_monitoring_dashboard() {
    echo "🖥️  BILL SLOTH MONITORING DASHBOARD"
    echo "=================================="
    echo ""
    
    # Service health summary
    echo "🏥 Service Health:"
    echo "=================="
    
    local services=$(jq -r '.services | keys[]' "$MONITORING_CONFIG")
    echo "$services" | while read -r service_name; do
        local health_data=$(sqlite3 "$MONITORING_DB" "
            SELECT status, response_time_ms, error_message
            FROM service_health 
            WHERE service_name = '$service_name'
            ORDER BY checked_at DESC 
            LIMIT 1
        ")
        
        if [ -n "$health_data" ]; then
            IFS='|' read -r status response_time error <<< "$health_data"
            local status_icon="❌"
            if [ "$status" = "healthy" ]; then
                status_icon="✅"
            fi
            
            printf "  %s %-25s %s (%sms)\n" "$status_icon" "$service_name" "$status" "$response_time"
            if [ -n "$error" ] && [ "$error" != "" ]; then
                printf "      Error: %s\n" "$error"
            fi
        else
            printf "  ❓ %-25s No data\n" "$service_name"
        fi
    done
    
    echo ""
    
    # System metrics
    echo "📊 System Metrics:"
    echo "=================="
    
    local current_metrics=$(cat "$METRICS_CACHE_DIR/current/system_metrics.json")
    local metric_names=$(echo "$current_metrics" | jq -r 'keys[]')
    
    echo "$metric_names" | while read -r metric_name; do
        local metric_data=$(echo "$current_metrics" | jq -r ".\"$metric_name\"")
        local value=$(echo "$metric_data" | jq -r '.value')
        local unit=$(echo "$metric_data" | jq -r '.unit')
        
        printf "  📈 %-25s %s %s\n" "$metric_name" "$value" "$unit"
    done
    
    echo ""
    
    # Active alerts
    echo "🚨 Active Alerts:"
    echo "================="
    
    local active_alerts=$(sqlite3 "$MONITORING_DB" -header -column "
        SELECT 
            severity,
            service_name,
            message,
            datetime(created_at) as created
        FROM alerts 
        WHERE status = 'active'
        ORDER BY created_at DESC
        LIMIT 10
    ")
    
    if [ -n "$active_alerts" ]; then
        echo "$active_alerts"
    else
        echo "  ✅ No active alerts"
    fi
    
    echo ""
    
    # Recent activity
    echo "📝 Recent Activity (Last 24h):"
    echo "==============================="
    
    sqlite3 "$MONITORING_DB" -header -column "
        SELECT 
            'Service Check' as type,
            service_name as target,
            status as result,
            datetime(checked_at) as timestamp
        FROM service_health 
        WHERE checked_at > datetime('now', '-24 hours')
        AND status != 'healthy'
        UNION ALL
        SELECT 
            'Alert' as type,
            service_name as target,
            severity as result,
            datetime(created_at) as timestamp
        FROM alerts 
        WHERE created_at > datetime('now', '-24 hours')
        ORDER BY timestamp DESC
        LIMIT 10
    "
}

# Get service uptime statistics
get_uptime_stats() {
    local service_name="${1:-all}"
    
    echo "📈 UPTIME STATISTICS"
    echo "===================="
    echo ""
    
    if [ "$service_name" = "all" ]; then
        # Overall uptime for all services
        local services=$(jq -r '.services | keys[]' "$MONITORING_CONFIG")
        echo "$services" | while read -r svc_name; do
            calculate_service_uptime "$svc_name"
        done
    else
        calculate_service_uptime "$service_name"
    fi
}

# Calculate service uptime
calculate_service_uptime() {
    local service_name="$1"
    
    # Calculate uptime for different periods
    local periods=("1 day" "7 days" "30 days")
    
    printf "Service: %s\n" "$service_name"
    printf "%-10s %-15s %-15s %-15s\n" "Period" "Total Checks" "Healthy" "Uptime %"
    printf "%-10s %-15s %-15s %-15s\n" "------" "-----------" "-------" "---------"
    
    for period in "${periods[@]}"; do
        local total_checks=$(sqlite3 "$MONITORING_DB" "
            SELECT COUNT(*)
            FROM service_health 
            WHERE service_name = '$service_name'
            AND checked_at > datetime('now', '-$period')
        ")
        
        local healthy_checks=$(sqlite3 "$MONITORING_DB" "
            SELECT COUNT(*)
            FROM service_health 
            WHERE service_name = '$service_name'
            AND status = 'healthy'
            AND checked_at > datetime('now', '-$period')
        ")
        
        local uptime_percent=0
        if [ "$total_checks" -gt 0 ]; then
            uptime_percent=$(echo "scale=2; $healthy_checks * 100 / $total_checks" | bc)
        fi
        
        printf "%-10s %-15s %-15s %-15s%%\n" \
               "${period%% *}${period##* }" "$total_checks" "$healthy_checks" "$uptime_percent"
    done
    
    echo ""
}

# Set maintenance window
set_maintenance_window() {
    local service_name="$1"
    local duration_hours="$2"
    local description="${3:-Scheduled maintenance}"
    
    local start_time=$(date -Iseconds)
    local end_time=$(date -d "+$duration_hours hours" -Iseconds)
    
    sqlite3 "$MONITORING_DB" "INSERT INTO maintenance_windows 
                              (window_name, service_name, start_time, end_time, description)
                              VALUES ('maint_$(date +%s)', '$service_name', '$start_time', '$end_time', '$description');"
    
    log_info "Maintenance window set for $service_name: $duration_hours hours"
}

# Generate monitoring report
generate_monitoring_report() {
    local report_type="${1:-daily}"
    local output_format="${2:-text}"
    
    local report_file="$MONITORING_BASE_DIR/reports/monitoring_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "BILL SLOTH MONITORING REPORT"
        echo "Generated: $(date)"
        echo "Report Type: $report_type"
        echo "=================================="
        echo ""
        
        # Service health summary
        get_monitoring_dashboard
        echo ""
        
        # Uptime statistics
        get_uptime_stats
        echo ""
        
        # Alert summary
        echo "🚨 ALERT SUMMARY"
        echo "================"
        
        local period_filter=""
        case "$report_type" in
            "hourly") period_filter="-1 hour" ;;
            "daily") period_filter="-1 day" ;;
            "weekly") period_filter="-7 days" ;;
            "monthly") period_filter="-30 days" ;;
            *) period_filter="-1 day" ;;
        esac
        
        sqlite3 "$MONITORING_DB" -header -column "
            SELECT 
                severity,
                COUNT(*) as count,
                GROUP_CONCAT(DISTINCT service_name) as services
            FROM alerts 
            WHERE created_at > datetime('now', '$period_filter')
            GROUP BY severity
            ORDER BY count DESC
        "
        
        echo ""
        
        # Performance trends
        echo "📊 PERFORMANCE TRENDS"
        echo "===================="
        
        sqlite3 "$MONITORING_DB" -header -column "
            SELECT 
                service_name,
                AVG(response_time_ms) as avg_response_time,
                MIN(response_time_ms) as min_response_time,
                MAX(response_time_ms) as max_response_time
            FROM service_health 
            WHERE checked_at > datetime('now', '$period_filter')
            AND status = 'healthy'
            GROUP BY service_name
            ORDER BY avg_response_time DESC
        "
        
    } > "$report_file"
    
    echo "Monitoring report generated: $report_file"
    
    # Email report if configured
    local email_reports=$(jq -r '.general_settings.email_reports // false' "$MONITORING_CONFIG")
    if [ "$email_reports" = "true" ]; then
        notify_info "Monitoring Report" "$(cat "$report_file")"
    fi
}

# Start monitoring daemon
start_monitoring_daemon() {
    log_info "Starting monitoring daemon..."
    
    local daemon_pid_file="$MONITORING_BASE_DIR/monitoring.pid"
    
    # Check if already running
    if [ -f "$daemon_pid_file" ]; then
        local existing_pid=$(cat "$daemon_pid_file")
        if kill -0 "$existing_pid" 2>/dev/null; then
            log_warning "Monitoring daemon already running (PID: $existing_pid)"
            return 1
        else
            rm -f "$daemon_pid_file"
        fi
    fi
    
    # Start daemon in background
    (
        echo $$ > "$daemon_pid_file"
        
        while true; do
            run_monitoring_check
            
            # Sleep for check interval
            local check_interval=$(jq -r '.general_settings.check_interval // 30' "$MONITORING_CONFIG")
            sleep "$check_interval"
        done
    ) &
    
    local daemon_pid=$!
    echo "$daemon_pid" > "$daemon_pid_file"
    
    log_success "Monitoring daemon started (PID: $daemon_pid)"
}

# Stop monitoring daemon
stop_monitoring_daemon() {
    local daemon_pid_file="$MONITORING_BASE_DIR/monitoring.pid"
    
    if [ -f "$daemon_pid_file" ]; then
        local daemon_pid=$(cat "$daemon_pid_file")
        if kill "$daemon_pid" 2>/dev/null; then
            rm -f "$daemon_pid_file"
            log_success "Monitoring daemon stopped"
        else
            log_warning "Failed to stop monitoring daemon"
            return 1
        fi
    else
        log_warning "Monitoring daemon not running"
        return 1
    fi
}

# Export functions
export -f init_monitoring_system run_monitoring_check get_monitoring_dashboard
export -f check_service_health collect_system_metrics collect_business_metrics
export -f get_uptime_stats set_maintenance_window generate_monitoring_report
export -f start_monitoring_daemon stop_monitoring_daemon

# Initialize on first source
if [ ! -f "$MONITORING_BASE_DIR/.monitoring-initialized" ]; then
    init_monitoring_system
    touch "$MONITORING_BASE_DIR/.monitoring-initialized"
fi

# Main function for standalone execution
main() {
    local command="${1:-check}"
    shift || true
    
    case "$command" in
        init) init_monitoring_system ;;
        check) run_monitoring_check ;;
        dashboard) get_monitoring_dashboard ;;
        uptime) get_uptime_stats "$@" ;;
        maintenance) set_maintenance_window "$@" ;;
        report) generate_monitoring_report "$@" ;;
        start) start_monitoring_daemon ;;
        stop) stop_monitoring_daemon ;;
        service) check_service_health "$@" ;;
        *)
            echo "Usage: $0 {init|check|dashboard|uptime|maintenance|report|start|stop|service}"
            echo ""
            echo "Commands:"
            echo "  init                       - Initialize monitoring system"
            echo "  check                      - Run monitoring check"
            echo "  dashboard                  - Show monitoring dashboard"
            echo "  uptime [service]           - Show uptime statistics"
            echo "  maintenance <svc> <hours>  - Set maintenance window"
            echo "  report [type] [format]     - Generate monitoring report"
            echo "  start                      - Start monitoring daemon"
            echo "  stop                       - Stop monitoring daemon"
            echo "  service <name>             - Check specific service"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi