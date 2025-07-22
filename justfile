# Bill Sloth Project Justfile
# ADHD-friendly task automation - Just run `just` to see all tasks

# Default task - show available commands with descriptions
default:
    @echo "🎯 Bill Sloth Task Menu (ADHD-Optimized)"
    @echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    @just --list --unsorted

# 🏥 SYSTEM HEALTH & MAINTENANCE

# Run comprehensive system health check
health:
    #!/usr/bin/env bash
    echo "🏥 Checking Bill Sloth system health..."
    source lib/system_health_monitoring.sh
    check_system_health
    echo "✅ Health check complete!"

# 🚀 PERFORMANCE MONITORING & OPTIMIZATION

# Run comprehensive performance analysis and optimization
perf-analyze:
    #!/usr/bin/env bash
    echo "📊 Running comprehensive performance analysis..."
    bash scripts/performance_analysis.sh full
    echo "✅ Performance analysis and optimization complete!"

# Quick performance status check
perf-check:
    #!/usr/bin/env bash
    echo "⚡ Quick performance check..."
    bash scripts/performance_analysis.sh quick

# Generate detailed performance report
perf-report hours="24":
    #!/usr/bin/env bash
    echo "📈 Generating performance report for last {{hours}} hours..."
    source lib/performance_monitoring.sh
    generate_performance_report {{hours}}

# Optimize specific module performance
perf-optimize module:
    #!/usr/bin/env bash
    echo "⚡ Optimizing {{module}} performance..."
    source lib/performance_monitoring.sh
    optimize_module_performance {{module}}
    echo "✅ {{module}} optimization complete!"

# Profile a specific operation (usage: just perf-profile "backup" "backup_management" "create_backup test_set")
perf-profile operation_name module_name command:
    #!/usr/bin/env bash
    echo "🔍 Profiling {{operation_name}} operation..."
    source lib/performance_monitoring.sh
    profile_operation {{operation_name}} {{module_name}} {{command}}
    echo "✅ Profiling complete - check ~/.bill-sloth/performance/profiles/"

# Clean up old performance data
perf-cleanup days="7":
    #!/usr/bin/env bash
    echo "🧹 Cleaning up performance data older than {{days}} days..."
    source lib/performance_monitoring.sh
    cleanup_performance_data {{days}}
    echo "✅ Performance data cleanup complete!"

# Create backup of all critical data
backup:
    #!/usr/bin/env bash
    echo "💾 Starting comprehensive backup..."
    source lib/backup_management.sh
    create_backup "bill_critical"
    echo "✅ Backup complete!"

# Initialize or repair Bill Sloth data systems
init:
    #!/usr/bin/env bash
    echo "🔧 Initializing Bill Sloth systems..."
    source lib/data_persistence.sh && init_data_persistence
    source lib/workflow_orchestration.sh && init_workflow_system
    source lib/system_health_monitoring.sh && init_health_monitoring
    echo "✅ Systems initialized!"

# Clean expired data and optimize databases
clean:
    #!/usr/bin/env bash
    echo "🧹 Cleaning and optimizing data systems..."
    source lib/data_persistence.sh && maintain_database
    find ~/.bill-sloth/cache -name "*.tmp" -delete 2>/dev/null || true
    echo "✅ Cleanup complete!"

# 🧪 TESTING & DEVELOPMENT

# Run all integration tests
test:
    #!/usr/bin/env bash
    echo "🧪 Running Bill Sloth integration tests..."
    bash tests/integration_test_suite.sh
    
# Quick smoke test for critical functionality
smoke-test:
    #!/usr/bin/env bash
    echo "💨 Running quick smoke tests..."
    bash tests/quick_integration_test.sh

# Check shell script quality
lint:
    #!/usr/bin/env bash
    echo "🔍 Linting shell scripts..."
    if command -v shellcheck &> /dev/null; then
        find . -name "*.sh" -not -path "./external/*" -exec shellcheck {} +
        echo "✅ Shellcheck complete!"
    else
        echo "⚠️  Install shellcheck: apt install shellcheck"
    fi

# Generate/update module documentation
docs:
    #!/usr/bin/env bash
    echo "📚 Generating module documentation..."
    bash scripts/generate_module_docs.sh
    echo "✅ Documentation updated!"

# 🏠 VRBO MANAGEMENT

# Onboard new VRBO guest (usage: just vrbo-guest "John Doe" "Cottage" "2025-08-01")
vrbo-guest guest_name property checkin_date:
    #!/usr/bin/env bash
    echo "🏠 Onboarding VRBO guest: {{guest_name}}"
    source lib/data_persistence.sh
    store_vrbo_booking "{{guest_name}}" "{{property}}" "{{checkin_date}}" "" "{}"
    
    # Create task via Kanboard if available
    source lib/kanboard_integration.sh 2>/dev/null || true
    if command -v create_vrbo_task &>/dev/null; then
        create_vrbo_task "{{guest_name}}" "{{property}}" "{{checkin_date}}"
    else
        # Fallback to workflow orchestration
        source lib/workflow_orchestration.sh
        create_workflow "vrbo_guest_prep" "{{guest_name}}" "{{checkin_date}}"
    fi
    
    echo "✅ {{guest_name}} onboarded for {{property}} on {{checkin_date}}"

# Show upcoming VRBO bookings (usage: just vrbo-upcoming [days])
vrbo-upcoming days="30":
    #!/usr/bin/env bash
    echo "📅 Upcoming VRBO bookings (next {{days}} days):"
    source lib/data_persistence.sh
    get_upcoming_bookings {{days}}

# 🎮 EDBOIGAMES CONTENT

# Process new EdBoiGames content (usage: just edboigames-content video /path/to/file.mp4)
edboigames-content content_type file_path:
    #!/usr/bin/env bash
    echo "🎮 Processing {{content_type}}: {{file_path}}"
    
    # Use FileBot integration if available
    source lib/filebot_integration.sh 2>/dev/null || true
    if command -v process_edboigames_content &>/dev/null; then
        process_edboigames_content "{{content_type}}" "{{file_path}}"
    else
        # Fallback to media pipeline
        if [ -f "modules/media_processing_pipeline.sh" ]; then
            bash modules/media_processing_pipeline.sh "{{file_path}}"
        fi
    fi
    
    # Store content metadata
    source lib/data_persistence.sh
    content_metadata="{\"type\": \"{{content_type}}\", \"file\": \"{{file_path}}\", \"status\": \"processed\"}"
    store_data "edboigames" "content_$(date +%s)" "$content_metadata"
    
    echo "✅ Content processing complete for {{file_path}}"

# Check EdBoiGames content status
edboigames-status:
    #!/usr/bin/env bash
    echo "🎮 EdBoiGames Content Status:"
    source lib/data_persistence.sh
    # Show recent content entries
    sqlite3 ~/.bill-sloth/data/bill_sloth.db "SELECT content_type, title, status, created_at FROM edboigames_content ORDER BY created_at DESC LIMIT 10;" 2>/dev/null || echo "No content tracked yet"

# 🔧 MODULE MANAGEMENT

# Launch specific module interactively (usage: just module productivity)
module module_name:
    #!/usr/bin/env bash
    module_file="modules/{{module_name}}_interactive.sh"
    if [ -f "$module_file" ]; then
        echo "🚀 Launching {{module_name}} module..."
        bash "$module_file"
    elif [ -f "modules/{{module_name}}.sh" ]; then
        echo "🚀 Launching {{module_name}} module..."
        bash "modules/{{module_name}}.sh"
    else
        echo "❌ Module '{{module_name}}' not found"
        echo "Available modules:"
        ls modules/*interactive.sh | sed 's/.*\///;s/_interactive.sh//' | sort
    fi

# List all available modules
modules:
    #!/usr/bin/env bash
    echo "📦 Available Bill Sloth Modules:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    find modules/ -name "*interactive.sh" | sed 's/.*\///;s/_interactive.sh//' | sort | while read module; do
        echo "  🔹 $module (use: just module $module)"
    done

# Launch the main command center
center:
    #!/usr/bin/env bash
    echo "🎯 Launching Bill Sloth Command Center..."
    bash bill_command_center.sh

# Launch onboarding system
onboard:
    #!/usr/bin/env bash
    echo "🎓 Starting Bill Sloth onboarding..."
    bash onboard.sh

# 📊 ANALYTICS & MONITORING

# Show system usage analytics
analytics:
    #!/usr/bin/env bash
    echo "📊 Bill Sloth Usage Analytics:"
    source lib/data_persistence.sh
    if [ -f ~/.bill-sloth/data/bill_sloth.db ]; then
        echo "Module Usage:"
        sqlite3 ~/.bill-sloth/data/bill_sloth.db "SELECT module_name, COUNT(*) as usage_count FROM module_usage GROUP BY module_name ORDER BY usage_count DESC;"
        echo ""
    fi
    
    # Show cross-module integration status
    source lib/cross_module_integration.sh
    show_integration_status

# Show recent task history
history:
    #!/usr/bin/env bash
    echo "📜 Recent Task History:"
    source lib/data_persistence.sh
    if [ -f ~/.bill-sloth/data/bill_sloth.db ]; then
        sqlite3 ~/.bill-sloth/data/bill_sloth.db "SELECT task_name, status, started_at FROM task_history ORDER BY started_at DESC LIMIT 10;"
    else
        echo "No task history available yet"
    fi

# 🔄 AUTOMATION & WORKFLOWS

# Start voice control system
voice:
    #!/usr/bin/env bash
    echo "🎤 Starting voice control system..."
    if [ -f "external/linux-voice-control/linux-voice-control" ]; then
        cd external/linux-voice-control && ./linux-voice-control
    else
        echo "❌ Voice control not installed. Run: bash modules/voice_assistant_interactive.sh"
    fi

# Run adaptive learning analysis
learn:
    #!/usr/bin/env bash
    echo "🧠 Running adaptive learning analysis..."
    source lib/adaptive_learning.sh
    analyze_usage_patterns
    suggest_optimizations

# Create custom automation workflow
automate workflow_name:
    #!/usr/bin/env bash
    echo "⚙️ Creating automation workflow: {{workflow_name}}"
    source lib/workflow_orchestration.sh
    create_custom_workflow "{{workflow_name}}"
    echo "✅ Workflow '{{workflow_name}}' created"

# 🔧 DEVELOPMENT UTILITIES

# Set up development environment
dev-setup:
    #!/usr/bin/env bash
    echo "🛠️ Setting up development environment..."
    bash scripts/first_time_setup.sh
    just init
    echo "✅ Development environment ready!"

# ⚙️ SYSTEMD SERVICE MANAGEMENT

# Install Bill Sloth as systemd services (requires sudo)
install-services:
    #!/usr/bin/env bash
    echo "🔧 Installing Bill Sloth systemd services..."
    sudo bash systemd/setup_systemd_services.sh install
    echo "✅ Systemd services installed!"

# Uninstall Bill Sloth systemd services (requires sudo)
uninstall-services:
    #!/usr/bin/env bash
    echo "🗑️ Uninstalling Bill Sloth systemd services..."
    sudo bash systemd/setup_systemd_services.sh uninstall
    echo "✅ Systemd services uninstalled!"

# Check systemd service status
service-status:
    #!/usr/bin/env bash
    echo "📊 Bill Sloth Service Status:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    systemctl status bill-sloth-core --no-pager || echo "Core service not installed"
    echo ""
    systemctl status bill-sloth-monitoring --no-pager || echo "Monitoring service not installed"
    echo ""
    systemctl list-timers bill-sloth-* --no-pager || echo "No timers installed"

# Start Bill Sloth services
start-services:
    #!/usr/bin/env bash
    echo "▶️ Starting Bill Sloth services..."
    sudo systemctl start bill-sloth-core
    echo "✅ Services started!"

# Stop Bill Sloth services  
stop-services:
    #!/usr/bin/env bash
    echo "⏹️ Stopping Bill Sloth services..."
    sudo systemctl stop bill-sloth-core
    echo "✅ Services stopped!"

# Restart Bill Sloth services
restart-services:
    #!/usr/bin/env bash
    echo "🔄 Restarting Bill Sloth services..."
    sudo systemctl restart bill-sloth-core
    echo "✅ Services restarted!"

# View Bill Sloth service logs
service-logs service="bill-sloth-core":
    #!/usr/bin/env bash
    echo "📋 Viewing {{service}} logs (Ctrl+C to exit)..."
    journalctl -u {{service}} -f

# Check for missing dependencies
deps:
    #!/usr/bin/env bash
    echo "📋 Checking dependencies..."
    bash tests/check_dependencies.sh

# Troubleshoot system issues
troubleshoot:
    #!/usr/bin/env bash
    echo "🔍 Running troubleshooting diagnostics..."
    bash scripts/troubleshoot.sh

# Update Bill Sloth system
update:
    #!/usr/bin/env bash
    echo "⬆️ Updating Bill Sloth system..."
    git pull
    just clean
    just init
    echo "✅ Update complete!"

# Show system status dashboard
status:
    #!/usr/bin/env bash
    echo "📊 Bill Sloth System Status:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    just health | tail -5
    echo ""
    echo "Recent Activity:"
    just history | head -5

# Emergency diagnostic and repair
emergency:
    #!/usr/bin/env bash
    echo "🚨 EMERGENCY MODE: Running diagnostic and repair..."
    just health
    just backup
    just clean
    just init
    echo "🛡️ Emergency procedures complete!"

# 🔗 CROSS-MODULE INTEGRATION

# Show detailed integration status and workflow connectivity
integration:
    #!/usr/bin/env bash
    echo "🔗 Bill Sloth Cross-Module Integration Status:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    source lib/cross_module_integration.sh
    show_integration_status

# Test cross-module workflows (usage: just test-integration)
test-integration:
    #!/usr/bin/env bash
    echo "🧪 Testing cross-module integration workflows..."
    source lib/cross_module_integration.sh
    
    # Test VRBO integration
    echo "Testing VRBO → Task integration..."
    quick_vrbo_integration "Test Guest" "Test Property" "$(date -d '+3 days' +%Y-%m-%d)"
    
    # Test content integration  
    echo "Testing EdBoiGames → Media integration..."
    quick_content_integration "video" "/tmp/test_video.mp4"
    
    echo "✅ Integration tests complete!"

# Setup integration triggers for automation
setup-triggers:
    #!/usr/bin/env bash
    echo "⚙️ Setting up cross-module integration triggers..."
    source lib/cross_module_integration.sh
    setup_integration_triggers
    echo "✅ Triggers configured for seamless automation!"