#!/bin/bash
# Setup comprehensive health monitoring for Bill Sloth system

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/system_health_monitoring.sh"
source "$SCRIPT_DIR/lib/error_handling.sh" 2>/dev/null || true

echo "🏥 BILL SLOTH HEALTH MONITORING SETUP"
echo "====================================="
echo ""

log_info "Setting up comprehensive health monitoring system..."

# Initialize health monitoring
init_health_monitoring

# Create health dashboard
create_health_dashboard

# Generate initial health report
echo "📊 Generating initial health report..."
generate_health_report "detailed" > /dev/null

# Create systemd service for monitoring daemon (optional)
create_monitoring_service() {
    local service_file="/etc/systemd/system/bill-sloth-health.service"
    
    if [ -w "/etc/systemd/system" ] 2>/dev/null; then
        log_info "Creating systemd service for health monitoring..."
        
        sudo cat > "$service_file" << EOF
[Unit]
Description=Bill Sloth Health Monitoring Daemon
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME/bill\ sloth
ExecStart=/bin/bash -c 'source $SCRIPT_DIR/lib/system_health_monitoring.sh && start_health_monitoring 30'
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF
        
        sudo systemctl daemon-reload
        log_success "Systemd service created: $service_file"
        echo "To enable automatic startup: sudo systemctl enable bill-sloth-health"
        echo "To start now: sudo systemctl start bill-sloth-health"
    else
        log_warning "Cannot create systemd service (no write access to /etc/systemd/system)"
    fi
}

# Create cron job for health monitoring (alternative to systemd)
create_cron_monitoring() {
    log_info "Setting up cron-based health monitoring..."
    
    # Create monitoring script
    cat > "$HOME/.bill-sloth/health-monitoring/cron_health_check.sh" << EOF
#!/bin/bash
# Cron-based health monitoring for Bill Sloth

cd "$SCRIPT_DIR"
source "lib/system_health_monitoring.sh"

# Generate health report and check for issues
health_report=\$(generate_health_report "summary")
overall_status=\$(echo "\$health_report" | jq -r '.overall_status // "unknown"')

# Log health status
echo "[\$(date -Iseconds)] Health Status: \$overall_status" >> "$HOME/.bill-sloth/health-monitoring/logs/cron_monitoring.log"

# If critical status, send alert
if [ "\$overall_status" = "critical" ]; then
    send_health_alert "System health critical - immediate attention required" "critical"
fi
EOF
    
    chmod +x "$HOME/.bill-sloth/health-monitoring/cron_health_check.sh"
    
    # Add to crontab (check every 5 minutes)
    local cron_entry="*/5 * * * * $HOME/.bill-sloth/health-monitoring/cron_health_check.sh"
    
    echo "Add this to your crontab (crontab -e):"
    echo "$cron_entry"
    
    log_success "Cron monitoring script created"
}

# Setup monitoring alerts
setup_alert_system() {
    log_info "Configuring alert system..."
    
    # Create alert configuration
    cat > "$HOME/.bill-sloth/health-monitoring/config/alert_config.json" << 'EOF'
{
  "channels": {
    "desktop": {
      "enabled": true,
      "urgency": "normal"
    },
    "log": {
      "enabled": true,
      "file": "alerts.log"
    },
    "email": {
      "enabled": false,
      "smtp_server": "",
      "smtp_port": 587,
      "username": "",
      "password": "",
      "to_address": "",
      "from_address": ""
    },
    "webhook": {
      "enabled": false,
      "url": "",
      "method": "POST",
      "headers": {}
    }
  },
  "alert_rules": {
    "cpu_critical": {
      "threshold": 95,
      "duration_seconds": 300,
      "cooldown_seconds": 600
    },
    "memory_critical": {
      "threshold": 95,
      "duration_seconds": 180,
      "cooldown_seconds": 300
    },
    "disk_critical": {
      "threshold": 98,
      "duration_seconds": 60,
      "cooldown_seconds": 3600
    },
    "module_failure": {
      "severity": "critical",
      "cooldown_seconds": 180
    }
  }
}
EOF
    
    log_success "Alert system configured"
}

# Create health monitoring quick commands
create_health_commands() {
    log_info "Creating health monitoring quick commands..."
    
    # Create command aliases
    cat > "$HOME/.bill-sloth/health-monitoring/health_commands.sh" << 'EOF'
#!/bin/bash
# Quick health monitoring commands

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")/.."
source "$SCRIPT_DIR/lib/system_health_monitoring.sh"

# Quick health check
health() {
    echo "🏥 Bill Sloth System Health"
    echo "=========================="
    generate_health_report "summary" | jq -r '
        "Overall Status: \(.overall_status | ascii_upcase)",
        "Last Check: \(.generated_at)",
        "",
        "📊 System Metrics:",
        "  CPU Usage: \(.system_metrics.cpu_usage)%",
        "  Memory Usage: \(.system_metrics.memory_usage)%",
        "  Disk Usage: \(.system_metrics.disk_usage)%",
        "  Network: \(.system_metrics.network_connectivity)",
        "",
        "🔧 Module Status:",
        (.module_health[] | "  \(.module): \(.status)")
    '
}

# Start monitoring
health-start() {
    echo "🚀 Starting health monitoring daemon..."
    start_health_monitoring &
    echo "✅ Health monitoring started in background"
}

# Stop monitoring
health-stop() {
    echo "⏹️ Stopping health monitoring daemon..."
    stop_health_monitoring
}

# Show dashboard
health-dash() {
    if [ -f "$HOME/.bill-sloth/health-monitoring/dashboards/health_dashboard.sh" ]; then
        "$HOME/.bill-sloth/health-monitoring/dashboards/health_dashboard.sh"
    else
        echo "❌ Health dashboard not found"
    fi
}

# Show alerts
health-alerts() {
    echo "🚨 Recent Health Alerts"
    echo "======================"
    if [ -f "$HOME/.bill-sloth/health-monitoring/alerts/alert_history.json" ]; then
        jq -r '.alerts[-10:] | .[] | "\(.timestamp): \(.message)"' \
            "$HOME/.bill-sloth/health-monitoring/alerts/alert_history.json"
    else
        echo "No alerts recorded"
    fi
}

# Export functions
export -f health health-start health-stop health-dash health-alerts
EOF
    
    chmod +x "$HOME/.bill-sloth/health-monitoring/health_commands.sh"
    
    # Create aliases file
    cat > "$HOME/.bill-sloth/health-monitoring/health_aliases.sh" << 'EOF'
# Add these to your ~/.bashrc or ~/.zshrc for quick health commands

# Source health commands
source ~/.bill-sloth/health-monitoring/health_commands.sh

# Create aliases
alias health-check='health'
alias health-status='health'
alias health-start='health-start'
alias health-stop='health-stop'
alias health-dashboard='health-dash'
alias health-alerts='health-alerts'
EOF
    
    log_success "Health commands created"
    echo "💡 Add to ~/.bashrc: source ~/.bill-sloth/health-monitoring/health_aliases.sh"
}

# Main setup
echo "1️⃣  Initializing health monitoring system..."
init_health_monitoring

echo ""
echo "2️⃣  Creating health dashboard..."
create_health_dashboard

echo ""
echo "3️⃣  Setting up alert system..."
setup_alert_system

echo ""
echo "4️⃣  Creating quick commands..."
create_health_commands

echo ""
echo "5️⃣  Generating initial health report..."
generate_health_report "detailed" > /dev/null

echo ""
echo "6️⃣  Optional: Automated monitoring setup"
echo "Choose monitoring method:"
echo "a) Systemd service (recommended for desktop/server)"
echo "b) Cron-based monitoring (fallback option)"
echo "c) Manual monitoring only"
echo "s) Skip automated monitoring"

read -p "Select option [a/b/c/s]: " monitor_choice

case "$monitor_choice" in
    "a"|"A")
        create_monitoring_service
        ;;
    "b"|"B")
        create_cron_monitoring
        ;;
    "c"|"C")
        echo "Manual monitoring selected. Use 'health-start' to begin monitoring."
        ;;
    *)
        echo "Skipping automated monitoring setup."
        ;;
esac

echo ""
echo "🎉 HEALTH MONITORING SETUP COMPLETE!"
echo "====================================="
echo ""
echo "📋 What's been set up:"
echo "  ✅ Health monitoring system initialized"
echo "  ✅ Interactive health dashboard created"
echo "  ✅ Alert system configured"
echo "  ✅ Quick command shortcuts created"
echo ""
echo "🚀 Quick Start:"
echo "  • View health status: health"
echo "  • Open dashboard: health-dash"
echo "  • Start monitoring: health-start"
echo "  • View alerts: health-alerts"
echo ""
echo "📂 Files created:"
echo "  • Dashboard: ~/.bill-sloth/health-monitoring/dashboards/health_dashboard.sh"
echo "  • Commands: ~/.bill-sloth/health-monitoring/health_commands.sh"
echo "  • Config: ~/.bill-sloth/health-monitoring/config/"
echo ""
echo "🔧 Next steps:"
echo "  1. Add health aliases to your shell: source ~/.bill-sloth/health-monitoring/health_aliases.sh"
echo "  2. Test the dashboard: health-dash"
echo "  3. Start monitoring: health-start"
echo "  4. Open Bill Sloth Command Center to see health integration"