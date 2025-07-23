#!/bin/bash
# LLM_CAPABILITY: local_ok  
# Cross-Module Integration Library
# Seamless data flow and workflow orchestration between Bill Sloth modules


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/data_persistence.sh" 2>/dev/null || true

# Integration configuration
INTEGRATION_DATA_DIR="$HOME/.bill-sloth/integration"
SHARED_DATA_DIR="$INTEGRATION_DATA_DIR/shared_data"
WORKFLOW_QUEUE_DIR="$INTEGRATION_DATA_DIR/workflow_queue"

# Initialize cross-module integration
init_cross_module_integration() {
    log_info "Initializing cross-module integration..."
    
    # Create integration directories
    mkdir -p "$INTEGRATION_DATA_DIR"/{shared_data,workflow_queue,triggers,events}
    mkdir -p "$SHARED_DATA_DIR"/{vrbo,edboigames,productivity,system}
    
    # Create event bus for module communication
    touch "$INTEGRATION_DATA_DIR/event_bus.log"
    
    log_success "Cross-module integration initialized"
}

# === REAL MODULE INTEGRATION FUNCTIONS ===

# VRBO → Task Management Integration
integrate_vrbo_to_tasks() {
    local guest_name="$1"
    local property="$2" 
    local checkin_date="$3"
    
    notify_info "VRBO Integration" "Creating tasks for $guest_name..."
    
    # Store in shared data for other modules
    local vrbo_data="{
        \"guest_name\": \"$guest_name\",
        \"property\": \"$property\",
        \"checkin_date\": \"$checkin_date\",
        \"created_at\": \"$(date -Iseconds)\",
        \"status\": \"tasks_pending\"
    }"
    
    store_data "integration" "vrbo_booking_$(date +%s)" "$vrbo_data"
    
    # Create checklist tasks
    create_vrbo_task_checklist "$guest_name" "$property" "$checkin_date"
    
    # Trigger productivity module if available
    if [ -f "$SCRIPT_DIR/../modules/productivity_suite_interactive.sh" ]; then
        log_event "vrbo_booking_created" "$vrbo_data"
    fi
    
    notify_success "Integration Complete" "VRBO booking integrated with task management"
}

# Create VRBO task checklist
create_vrbo_task_checklist() {
    local guest_name="$1"
    local property="$2"
    local checkin_date="$3"
    
    # Calculate preparation timeline
    local prep_date=$(date -d "$checkin_date -3 days" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)
    
    # Define task checklist
    local tasks=(
        "Clean $property thoroughly|$prep_date|high"
        "Stock supplies (towels, toilet paper, etc)|$prep_date|high"
        "Check all appliances and utilities|$prep_date|medium"
        "Prepare welcome materials for $guest_name|$prep_date|medium"
        "Send check-in instructions to $guest_name|$(date -d "$checkin_date -1 day" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)|high"
        "Verify property access (lockbox, keys)|$(date -d "$checkin_date -1 day" +%Y-%m-%d 2>/dev/null || date +%Y-%m-%d)|high"
    )
    
    # Create tasks in data system
    for task_info in "${tasks[@]}"; do
        IFS='|' read -r task_title task_date task_priority <<< "$task_info"
        
        local task_data="{
            \"title\": \"$task_title\",
            \"due_date\": \"$task_date\", 
            \"priority\": \"$task_priority\",
            \"category\": \"vrbo\",
            \"guest\": \"$guest_name\",
            \"property\": \"$property\",
            \"status\": \"pending\"
        }"
        
        store_data "tasks" "vrbo_task_$(date +%s)" "$task_data"
    done
    
    echo "✅ Created ${#tasks[@]} preparation tasks for $guest_name"
}

# EdBoiGames → Media Processing Integration
integrate_edboigames_to_media() {
    local content_type="$1"
    local file_path="$2"
    
    notify_info "EdBoiGames Integration" "Processing $content_type content..."
    
    # Store content metadata
    local content_data="{
        \"content_type\": \"$content_type\",
        \"file_path\": \"$file_path\",
        \"created_at\": \"$(date -Iseconds)\",
        \"status\": \"processing\"
    }"
    
    store_data "integration" "edboigames_content_$(date +%s)" "$content_data"
    
    # Create processing workflow
    create_content_processing_workflow "$content_type" "$file_path"
    
    # Trigger media processing if available
    if [ -f "$SCRIPT_DIR/../modules/media_processing_pipeline.sh" ]; then
        log_event "content_processing_started" "$content_data"
        bash "$SCRIPT_DIR/../modules/media_processing_pipeline.sh" "$file_path"
    fi
    
    notify_success "Integration Complete" "Content queued for processing"
}

# Create content processing workflow
create_content_processing_workflow() {
    local content_type="$1"
    local file_path="$2"
    
    case "$content_type" in
        "video")
            create_video_processing_tasks "$file_path"
            ;;
        "thumbnail") 
            create_thumbnail_processing_tasks "$file_path"
            ;;
        "description")
            create_description_processing_tasks "$file_path"
            ;;
        *)
            create_generic_content_tasks "$content_type" "$file_path"
            ;;
    esac
}

# Create video processing task chain
create_video_processing_tasks() {
    local file_path="$1"
    local filename=$(basename "$file_path")
    
    local tasks=(
        "Process video: $filename|today|high"
        "Create thumbnail for: $filename|today|medium"
        "Generate video description|today|medium"
        "Upload to EdBoiGames channel|today|medium"
        "Schedule social media posts|today|low"
        "Update content calendar|today|low"
    )
    
    # Create task sequence
    for task_info in "${tasks[@]}"; do
        IFS='|' read -r task_title task_date task_priority <<< "$task_info"
        
        local task_data="{
            \"title\": \"$task_title\",
            \"due_date\": \"$(date +%Y-%m-%d)\",
            \"priority\": \"$task_priority\",
            \"category\": \"edboigames\",
            \"content_type\": \"video\",
            \"file_path\": \"$file_path\",
            \"status\": \"pending\"
        }"
        
        store_data "tasks" "edboigames_task_$(date +%s)" "$task_data"
    done
    
    echo "✅ Created video processing workflow for $filename"
}

# System Health → Notification Integration
integrate_health_to_notifications() {
    local cpu_usage="$1"
    local memory_usage="$2"
    local disk_usage="$3"
    local issues="$4"
    
    # Store health data for other modules
    local health_data="{
        \"cpu_usage\": $cpu_usage,
        \"memory_usage\": $memory_usage,
        \"disk_usage\": $disk_usage,
        \"issues\": \"$issues\",
        \"timestamp\": \"$(date -Iseconds)\"
    }"
    
    store_data "integration" "health_snapshot_$(date +%s)" "$health_data"
    
    # Trigger alerts based on thresholds
    if (( $(echo "$cpu_usage > 80" | bc -l 2>/dev/null || echo 0) )); then
        notify_warning "High CPU Usage" "CPU at ${cpu_usage}% - Consider closing some applications"
        create_system_optimization_task "high_cpu"
    fi
    
    if (( $(echo "$memory_usage > 85" | bc -l 2>/dev/null || echo 0) )); then
        notify_warning "High Memory Usage" "Memory at ${memory_usage}% - System may slow down"
        create_system_optimization_task "high_memory"
    fi
    
    if (( $(echo "$disk_usage > 90" | bc -l 2>/dev/null || echo 0) )); then
        notify_warning "Low Disk Space" "Disk at ${disk_usage}% - Time to clean up files"
        create_system_cleanup_task
    fi
}

# Create system optimization tasks
create_system_optimization_task() {
    local issue_type="$1"
    
    local task_data="{
        \"title\": \"Optimize system performance: $issue_type\",
        \"due_date\": \"$(date +%Y-%m-%d)\",
        \"priority\": \"high\",
        \"category\": \"system\",
        \"issue_type\": \"$issue_type\",
        \"status\": \"pending\"
    }"
    
    store_data "tasks" "system_task_$(date +%s)" "$task_data"
    echo "🔧 Created system optimization task for: $issue_type"
}

# === EVENT LOGGING AND TRIGGERING ===

# Log cross-module event
log_event() {
    local event_type="$1"
    local event_data="$2"
    
    local event_entry="{
        \"timestamp\": \"$(date -Iseconds)\",
        \"type\": \"$event_type\",
        \"data\": $event_data
    }"
    
    echo "$event_entry" >> "$INTEGRATION_DATA_DIR/event_bus.log"
}

# Trigger module based on event
trigger_module_from_event() {
    local event_type="$1"
    local event_data="$2"
    
    case "$event_type" in
        "vrbo_booking_created")
            # Could trigger email automation, calendar updates, etc.
            log_info "VRBO booking created - triggering related modules"
            ;;
        "content_processing_started")
            # Could trigger social media scheduling, analytics tracking, etc.
            log_info "Content processing started - triggering media workflow"
            ;;
        "system_health_alert")
            # Could trigger maintenance modules, backup acceleration, etc.
            log_info "System health alert - triggering maintenance workflows"
            ;;
    esac
}

# === INTEGRATED DASHBOARD FUNCTIONS ===

# Show cross-module status
show_integration_status() {
    echo "🔗 BILL SLOTH INTEGRATION STATUS"
    echo "================================="
    echo ""
    
    # VRBO integration status
    echo "🏠 VRBO Integration:"
    local vrbo_bookings=$(get_data_count "integration" "vrbo_booking_*")
    local vrbo_tasks=$(get_data_count "tasks" "vrbo_task_*")
    echo "   • Active bookings: $vrbo_bookings"
    echo "   • Pending tasks: $vrbo_tasks"
    echo ""
    
    # EdBoiGames integration status
    echo "🎮 EdBoiGames Integration:"
    local content_items=$(get_data_count "integration" "edboigames_content_*")
    local content_tasks=$(get_data_count "tasks" "edboigames_task_*")
    echo "   • Content items: $content_items"
    echo "   • Processing tasks: $content_tasks"
    echo ""
    
    # System integration status
    echo "⚙️ System Integration:"
    local health_snapshots=$(get_data_count "integration" "health_snapshot_*")
    local system_tasks=$(get_data_count "tasks" "system_task_*")
    echo "   • Health snapshots: $health_snapshots"
    echo "   • System tasks: $system_tasks"
    echo ""
    
    # Recent events
    echo "📡 Recent Integration Events:"
    if [ -f "$INTEGRATION_DATA_DIR/event_bus.log" ]; then
        tail -5 "$INTEGRATION_DATA_DIR/event_bus.log" | jq -r '"   • " + .timestamp + ": " + .type' 2>/dev/null || echo "   • No recent events"
    else
        echo "   • Event bus not initialized"
    fi
}

# Get count of data items matching pattern
get_data_count() {
    local module="$1"
    local pattern="$2"
    
    if [ -f ~/.bill-sloth/data/bill_sloth.db ]; then
        sqlite3 ~/.bill-sloth/data/bill_sloth.db "SELECT COUNT(*) FROM data_cache WHERE module='$module' AND key LIKE '${pattern}%';" 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# === WORKFLOW AUTOMATION ===

# Auto-trigger integration workflows
setup_integration_triggers() {
    log_info "Setting up integration triggers..."
    
    # Create trigger scripts for common workflows
    mkdir -p "$INTEGRATION_DATA_DIR/triggers"
    
    # VRBO booking trigger
    cat > "$INTEGRATION_DATA_DIR/triggers/vrbo_booking.sh" << 'EOF'
#!/bin/bash
# Auto-trigger VRBO integration when new booking detected
source ~/.bill-sloth/lib/cross_module_integration.sh
integrate_vrbo_to_tasks "$1" "$2" "$3"
EOF
    chmod +x "$INTEGRATION_DATA_DIR/triggers/vrbo_booking.sh"
    
    # Content processing trigger
    cat > "$INTEGRATION_DATA_DIR/triggers/content_processing.sh" << 'EOF'
#!/bin/bash
# Auto-trigger content integration when new media detected
source ~/.bill-sloth/lib/cross_module_integration.sh
integrate_edboigames_to_media "$1" "$2"
EOF
    chmod +x "$INTEGRATION_DATA_DIR/triggers/content_processing.sh"
    
    log_success "Integration triggers ready"
}

# === CONVENIENCE FUNCTIONS FOR JUSTFILE ===

# Quick VRBO integration (called from justfile)
quick_vrbo_integration() {
    local guest_name="$1"
    local property="$2"
    local checkin_date="$3"
    
    integrate_vrbo_to_tasks "$guest_name" "$property" "$checkin_date"
    show_integration_status
}

# Quick content integration (called from justfile)  
quick_content_integration() {
    local content_type="$1"
    local file_path="$2"
    
    integrate_edboigames_to_media "$content_type" "$file_path"
    show_integration_status
}

# Export functions
export -f init_cross_module_integration integrate_vrbo_to_tasks integrate_edboigames_to_media
export -f integrate_health_to_notifications log_event trigger_module_from_event
export -f show_integration_status setup_integration_triggers
export -f quick_vrbo_integration quick_content_integration

# Initialize on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_cross_module_integration 2>/dev/null || true
fi