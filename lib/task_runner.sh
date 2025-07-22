#!/bin/bash
# LLM_CAPABILITY: local_ok
# Task Runner Library - Modern replacement for workflow orchestration using Just
# Replaces complex JSON-based workflow system with simple, readable task definitions

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Task runner configuration
TASK_CONFIG_DIR="$HOME/.bill-sloth/tasks"
TASK_HISTORY_DIR="$TASK_CONFIG_DIR/history"
TASK_TEMPLATES_DIR="$TASK_CONFIG_DIR/templates"

# Initialize task runner
init_task_runner() {
    log_info "Initializing Bill Sloth task runner..."
    
    # Create task directories
    mkdir -p "$TASK_CONFIG_DIR"/{history,templates,active}
    
    # Check for Just installation
    if command -v just &> /dev/null; then
        TASK_RUNNER="just"
        log_success "Using Just for task running"
    elif command -v make &> /dev/null; then
        TASK_RUNNER="make"
        log_info "Using Make as fallback task runner"
    else
        TASK_RUNNER="shell"
        log_warning "Using shell-based task runner (install Just for better experience)"
    fi
    
    # Create default justfile if using Just
    if [ "$TASK_RUNNER" = "just" ] && [ ! -f "$TASK_CONFIG_DIR/justfile" ]; then
        create_default_justfile
    fi
    
    export TASK_RUNNER
}

# Create default justfile for common Bill Sloth tasks
create_default_justfile() {
    cat > "$TASK_CONFIG_DIR/justfile" << 'EOF'
# Bill Sloth Task Runner
# Replaces complex JSON workflow system with simple, readable tasks

# Default task - show help
default:
    @just --list --unsorted

# System tasks
backup-all:
    #!/usr/bin/env bash
    echo "🔄 Starting comprehensive backup..."
    bill_backup "bill_critical"
    bill_backup "vrbo_data" 
    bill_backup "edboigames_content"
    echo "✅ All backups complete!"

health-check:
    #!/usr/bin/env bash
    echo "🏥 Running system health check..."
    source ~/.bill-sloth/lib/system_health_monitoring.sh
    check_system_health

# VRBO workflow tasks  
vrbo-guest-onboard guest_name property checkin_date:
    #!/usr/bin/env bash
    echo "🏠 Onboarding guest: {{guest_name}} at {{property}}"
    # Create Google Task
    create_google_task "VRBO" "Prepare for {{guest_name}} at {{property}}" "{{checkin_date}}"
    # Share data with other modules
    booking_data='{"guest": "{{guest_name}}", "property": "{{property}}", "checkin": "{{checkin_date}}"}'
    share_vrbo_booking "$booking_data"
    echo "✅ Guest onboarding workflow complete"

# EdBoiGames content workflow
edboigames-content content_type content_file:
    #!/usr/bin/env bash
    echo "🎮 Processing {{content_type}} content: {{content_file}}"
    # Process through media pipeline
    process_edboigames_content "{{content_type}}" "{{content_file}}"
    # Create publishing task
    create_google_task "EdBoiGames" "Publish {{content_type}} content" "today"
    echo "✅ Content workflow complete"

# Development tasks
test-all:
    #!/usr/bin/env bash
    echo "🧪 Running all tests..."
    bash tests/integration_test_suite.sh
    
lint-check:
    #!/usr/bin/env bash
    echo "🔍 Checking shell scripts..."
    find . -name "*.sh" -exec shellcheck {} + || echo "⚠️  Install shellcheck for linting"

# Custom task execution with logging
run-with-log task_name:
    #!/usr/bin/env bash
    log_file="$HOME/.bill-sloth/tasks/history/$(date +%Y%m%d_%H%M%S)_{{task_name}}.log"
    echo "📝 Logging to: $log_file"
    just {{task_name}} 2>&1 | tee "$log_file"
    echo "✅ Task {{task_name}} completed, log saved"
EOF
    
    log_success "Created default justfile with Bill Sloth workflows"
}

# Execute task with Bill Sloth personality
run_task() {
    local task_name="$1"
    shift
    local args="$@"
    
    notify_info "Task Starting" "🚀 Running task: $task_name"
    
    local start_time=$(date +%s)
    local log_file="$TASK_HISTORY_DIR/$(date +%Y%m%d_%H%M%S)_${task_name}.log"
    
    case "$TASK_RUNNER" in
        "just")
            if cd "$TASK_CONFIG_DIR" && just "$task_name" $args 2>&1 | tee "$log_file"; then
                local end_time=$(date +%s)
                local duration=$((end_time - start_time))
                notify_success "Task Complete!" "✅ $task_name finished in ${duration}s"
                return 0
            else
                notify_error "Task Failed" "❌ $task_name encountered an error"
                return 1
            fi
            ;;
        "make")
            if cd "$TASK_CONFIG_DIR" && make "$task_name" 2>&1 | tee "$log_file"; then
                notify_success "Task Complete!" "✅ $task_name finished"
                return 0
            else
                notify_error "Task Failed" "❌ $task_name encountered an error"
                return 1
            fi
            ;;
        "shell")
            # Fallback to shell-based execution
            run_shell_task "$task_name" $args
            ;;
    esac
}

# Shell-based task execution for systems without Just/Make
run_shell_task() {
    local task_name="$1"
    shift
    local args="$@"
    
    case "$task_name" in
        "backup-all")
            echo "🔄 Starting comprehensive backup..."
            if command -v bill_backup &> /dev/null; then
                bill_backup "bill_critical"
                bill_backup "vrbo_data" 
                bill_backup "edboigames_content"
                echo "✅ All backups complete!"
            else
                echo "⚠️  bill_backup not available"
                return 1
            fi
            ;;
        "health-check")
            echo "🏥 Running system health check..."
            if [ -f "$HOME/.bill-sloth/lib/system_health_monitoring.sh" ]; then
                source "$HOME/.bill-sloth/lib/system_health_monitoring.sh"
                check_system_health
            else
                echo "⚠️  Health monitoring not available"
                return 1
            fi
            ;;
        "test-all")
            echo "🧪 Running all tests..."
            if [ -f tests/integration_test_suite.sh ]; then
                bash tests/integration_test_suite.sh
            else
                echo "⚠️  Test suite not found"
                return 1
            fi
            ;;
        *)
            log_error "Unknown task: $task_name"
            echo "Available tasks: backup-all, health-check, test-all"
            return 1
            ;;
    esac
}

# List available tasks
list_tasks() {
    case "$TASK_RUNNER" in
        "just")
            echo "📋 Available tasks (powered by Just):"
            cd "$TASK_CONFIG_DIR" && just --list --unsorted
            ;;
        "make")
            echo "📋 Available tasks (powered by Make):"
            cd "$TASK_CONFIG_DIR" && make help 2>/dev/null || echo "Run 'make' to see available targets"
            ;;
        "shell")
            echo "📋 Available tasks (shell-based):"
            echo "  backup-all     - Run all backup sets"
            echo "  health-check   - System health monitoring"
            echo "  test-all       - Run integration tests"
            ;;
    esac
}

# Create custom task template
create_task_template() {
    local template_name="$1"
    local description="$2"
    
    cat > "$TASK_TEMPLATES_DIR/${template_name}.just" << EOF
# Bill Sloth Task Template: $template_name
# $description

$template_name:
    #!/usr/bin/env bash
    echo "🚀 Starting $template_name..."
    # Add your commands here
    echo "✅ $template_name complete!"
EOF
    
    log_success "Created task template: $template_name"
    echo "Edit: $TASK_TEMPLATES_DIR/${template_name}.just"
}

# Migration helper: Convert old workflow to Just task
migrate_workflow_to_task() {
    local workflow_file="$1"
    
    if [ ! -f "$workflow_file" ]; then
        log_error "Workflow file not found: $workflow_file"
        return 1
    fi
    
    local workflow_name=$(jq -r '.name' "$workflow_file" 2>/dev/null)
    local workflow_desc=$(jq -r '.description' "$workflow_file" 2>/dev/null)
    
    if [ "$workflow_name" = "null" ] || [ -z "$workflow_name" ]; then
        log_error "Invalid workflow file format"
        return 1
    fi
    
    echo "🔄 Converting workflow '$workflow_name' to Just task..."
    
    # Create basic task structure
    cat >> "$TASK_CONFIG_DIR/justfile" << EOF

# Migrated from workflow: $workflow_desc
$workflow_name:
    #!/usr/bin/env bash
    echo "🚀 Running migrated workflow: $workflow_name"
    # TODO: Convert workflow steps to bash commands
    # Original workflow: $workflow_file
    echo "⚠️  Migration incomplete - manual conversion required"
EOF
    
    log_success "Basic migration complete for: $workflow_name"
    echo "💡 Manual step conversion required in: $TASK_CONFIG_DIR/justfile"
}

# Show task execution history
show_task_history() {
    local limit="${1:-10}"
    
    echo "📊 Recent task executions (last $limit):"
    if [ -d "$TASK_HISTORY_DIR" ]; then
        ls -lt "$TASK_HISTORY_DIR"/*.log 2>/dev/null | head -n "$limit" | while read -r line; do
            local log_file=$(echo "$line" | awk '{print $NF}')
            local task_name=$(basename "$log_file" .log | cut -d'_' -f3-)
            local timestamp=$(basename "$log_file" .log | cut -d'_' -f1-2)
            echo "  📝 $task_name ($timestamp)"
        done
    else
        echo "  No task history found"
    fi
}

# Install Just if not present
install_just() {
    echo "📦 Installing Just task runner..."
    
    # Try package managers first
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y just
    elif command -v pacman &> /dev/null; then
        sudo pacman -S just
    elif command -v brew &> /dev/null; then
        brew install just
    else
        # Fallback to direct download
        echo "📥 Downloading Just binary..."
        local arch=$(uname -m)
        local os=$(uname -s | tr '[:upper:]' '[:lower:]')
        
        case "$arch" in
            x86_64) arch="x86_64" ;;
            aarch64) arch="aarch64" ;;
            arm64) arch="aarch64" ;;
            *) 
                log_error "Unsupported architecture: $arch"
                return 1
                ;;
        esac
        
        local download_url="https://github.com/casey/just/releases/latest/download/just-${arch}-unknown-${os}-musl.tar.gz"
        local temp_dir=$(mktemp -d)
        
        if curl -L "$download_url" | tar -xz -C "$temp_dir"; then
            sudo mv "$temp_dir/just" /usr/local/bin/just
            sudo chmod +x /usr/local/bin/just
            rm -rf "$temp_dir"
            log_success "Just installed successfully"
        else
            log_error "Failed to download Just"
            return 1
        fi
    fi
    
    # Reinitialize with Just
    init_task_runner
}

# Export functions
export -f init_task_runner run_task list_tasks create_task_template
export -f migrate_workflow_to_task show_task_history install_just

# Initialize on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_task_runner 2>/dev/null || true
fi

# Main function for standalone execution
task_runner_main() {
    local command="$1"
    shift || true
    
    case "$command" in
        init)
            init_task_runner
            ;;
        run)
            run_task "$@"
            ;;
        list)
            list_tasks
            ;;
        template)
            if [ $# -lt 2 ]; then
                echo "Usage: task_runner_main template <name> <description>"
                return 1
            fi
            create_task_template "$1" "$2"
            ;;
        migrate)
            migrate_workflow_to_task "$1"
            ;;
        history)
            show_task_history "$1"
            ;;
        install-just)
            install_just
            ;;
        *)
            echo "Bill Sloth Task Runner"
            echo "Usage: $0 {init|run|list|template|migrate|history|install-just}"
            echo ""
            echo "Commands:"
            echo "  init          - Initialize task runner system"
            echo "  run <task>    - Execute a task"
            echo "  list          - Show available tasks" 
            echo "  template      - Create task template"
            echo "  migrate       - Convert old workflow to task"
            echo "  history       - Show recent task executions"
            echo "  install-just  - Install Just task runner"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    task_runner_main "$@"
fi