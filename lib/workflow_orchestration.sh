#!/bin/bash
# LLM_CAPABILITY: local_ok
# Workflow Orchestration Library
# Cross-module data sharing and workflow management for Bill Sloth system


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Global workflow configuration
WORKFLOW_DATA_DIR="$HOME/.bill-sloth/workflows"
WORKFLOW_STATE_DIR="$WORKFLOW_DATA_DIR/state"
WORKFLOW_LOGS_DIR="$WORKFLOW_DATA_DIR/logs"
WORKFLOW_CONFIG_DIR="$WORKFLOW_DATA_DIR/config"

# Initialize workflow system
init_workflow_system() {
    log_info "Initializing workflow orchestration system..."
    
    # Create workflow directories
    mkdir -p "$WORKFLOW_DATA_DIR"/{state,logs,config,data,templates}
    mkdir -p "$WORKFLOW_STATE_DIR"/{active,completed,failed,pending}
    
    # Create workflow registry
    touch "$WORKFLOW_CONFIG_DIR/workflow_registry.json"
    
    # Initialize workflow state tracking
    if [ ! -f "$WORKFLOW_STATE_DIR/workflow_counter.txt" ]; then
        echo "0" > "$WORKFLOW_STATE_DIR/workflow_counter.txt"
    fi
    
    log_success "Workflow system initialized"
}

# Generate unique workflow ID
generate_workflow_id() {
    local prefix="$1"
    local counter=$(cat "$WORKFLOW_STATE_DIR/workflow_counter.txt")
    counter=$((counter + 1))
    echo "$counter" > "$WORKFLOW_STATE_DIR/workflow_counter.txt"
    echo "${prefix}_$(date +%Y%m%d)_${counter}"
}

# Create workflow definition
create_workflow() {
    local workflow_name="$1"
    local description="$2"
    local steps="$3"  # JSON array of steps
    
    local workflow_id=$(generate_workflow_id "$workflow_name")
    local workflow_file="$WORKFLOW_CONFIG_DIR/${workflow_id}.json"
    
    cat > "$workflow_file" << EOF
{
  "id": "$workflow_id",
  "name": "$workflow_name",
  "description": "$description",
  "created": "$(date -Iseconds)",
  "status": "pending",
  "steps": $steps,
  "data": {},
  "logs": []
}
EOF
    
    echo "$workflow_id"
}

# Start workflow execution
start_workflow() {
    local workflow_id="$1"
    local input_data="$2"  # JSON string
    
    local workflow_file="$WORKFLOW_CONFIG_DIR/${workflow_id}.json"
    local state_file="$WORKFLOW_STATE_DIR/active/${workflow_id}.state"
    
    if [ ! -f "$workflow_file" ]; then
        log_error "Workflow $workflow_id not found"
        return 1
    fi
    
    # Update workflow status
    jq --arg status "running" --arg started "$(date -Iseconds)" \
       '.status = $status | .started = $started' \
       "$workflow_file" > "${workflow_file}.tmp" && mv "${workflow_file}.tmp" "$workflow_file"
    
    # Create state tracking
    cat > "$state_file" << EOF
{
  "workflow_id": "$workflow_id",
  "status": "running",
  "current_step": 0,
  "started": "$(date -Iseconds)",
  "data": $input_data,
  "step_results": []
}
EOF
    
    log_info "Started workflow: $workflow_id"
    notify_info "Workflow Started" "Workflow $workflow_id is now running"
}

# Execute workflow step
execute_workflow_step() {
    local workflow_id="$1"
    local step_index="$2"
    
    local workflow_file="$WORKFLOW_CONFIG_DIR/${workflow_id}.json"
    local state_file="$WORKFLOW_STATE_DIR/active/${workflow_id}.state"
    
    if [ ! -f "$state_file" ]; then
        log_error "Workflow state not found: $workflow_id"
        return 1
    fi
    
    # Get step definition
    local step_data=$(jq -r ".steps[$step_index]" "$workflow_file")
    local step_type=$(echo "$step_data" | jq -r '.type')
    local step_module=$(echo "$step_data" | jq -r '.module')
    local step_function=$(echo "$step_data" | jq -r '.function')
    local step_params=$(echo "$step_data" | jq -r '.parameters')
    
    log_info "Executing step $step_index: $step_type"
    
    # Execute step based on type
    local step_result=""
    case "$step_type" in
        "module_function")
            step_result=$(execute_module_function "$step_module" "$step_function" "$step_params")
            ;;
        "data_transform")
            step_result=$(execute_data_transform "$step_params")
            ;;
        "notification")
            step_result=$(execute_notification_step "$step_params")
            ;;
        "wait")
            step_result=$(execute_wait_step "$step_params")
            ;;
        *)
            log_error "Unknown step type: $step_type"
            return 1
            ;;
    esac
    
    # Update state with step result
    local current_state=$(cat "$state_file")
    echo "$current_state" | jq --arg result "$step_result" --arg step "$step_index" \
        '.step_results[$step | tonumber] = $result | .current_step = ($step | tonumber) + 1' \
        > "${state_file}.tmp" && mv "${state_file}.tmp" "$state_file"
    
    log_success "Step $step_index completed"
}

# Execute module function
execute_module_function() {
    local module="$1"
    local function="$2"
    local params="$3"
    
    case "$module" in
        "vrbo_automation")
            source "$SCRIPT_DIR/../~/.bill-sloth/vrbo-automation/scripts/guest-communication.sh" 2>/dev/null
            eval "$function $params"
            ;;
        "google_tasks")
            source "$SCRIPT_DIR/../~/.bill-sloth/google-tasks/scripts/tasks-manager.sh" 2>/dev/null
            eval "$function $params"
            ;;
        "chatgpt_integration")
            source "$SCRIPT_DIR/../~/.bill-sloth/chatgpt-integration/scripts/chatgpt-helper.sh" 2>/dev/null
            eval "$function $params"
            ;;
        "data_automation")
            source "$SCRIPT_DIR/../~/.bill-sloth/data-automation/scripts/data-processor.sh" 2>/dev/null
            eval "$function $params"
            ;;
        "network_management")
            source "$SCRIPT_DIR/../modules/network_management_interactive.sh" 2>/dev/null
            eval "$function $params"
            ;;
        *)
            log_error "Unknown module: $module"
            return 1
            ;;
    esac
}

# Execute data transformation
execute_data_transform() {
    local transform_config="$1"
    local operation=$(echo "$transform_config" | jq -r '.operation')
    local input_field=$(echo "$transform_config" | jq -r '.input_field')
    local output_field=$(echo "$transform_config" | jq -r '.output_field')
    
    case "$operation" in
        "extract_email")
            # Extract email from text
            echo "email_extracted"
            ;;
        "format_date")
            # Format date
            echo "date_formatted"
            ;;
        "calculate_revenue")
            # Calculate revenue
            echo "revenue_calculated"
            ;;
        *)
            echo "transform_completed"
            ;;
    esac
}

# Execute notification step
execute_notification_step() {
    local notification_config="$1"
    local message=$(echo "$notification_config" | jq -r '.message')
    local type=$(echo "$notification_config" | jq -r '.type')
    
    case "$type" in
        "success")
            notify_success "Workflow Update" "$message"
            ;;
        "warning")
            notify_warning "Workflow Warning" "$message"
            ;;
        "error")
            notify_error "Workflow Error" "$message"
            ;;
        *)
            notify_info "Workflow Info" "$message"
            ;;
    esac
    
    echo "notification_sent"
}

# Execute wait step
execute_wait_step() {
    local wait_config="$1"
    local duration=$(echo "$wait_config" | jq -r '.duration')
    
    log_info "Waiting for $duration seconds..."
    sleep "$duration"
    echo "wait_completed"
}

# Complete workflow
complete_workflow() {
    local workflow_id="$1"
    local status="$2"  # "completed" or "failed"
    
    local workflow_file="$WORKFLOW_CONFIG_DIR/${workflow_id}.json"
    local state_file="$WORKFLOW_STATE_DIR/active/${workflow_id}.state"
    
    # Update workflow status
    jq --arg status "$status" --arg completed "$(date -Iseconds)" \
       '.status = $status | .completed = $completed' \
       "$workflow_file" > "${workflow_file}.tmp" && mv "${workflow_file}.tmp" "$workflow_file"
    
    # Move state file to appropriate directory
    if [ "$status" = "completed" ]; then
        mv "$state_file" "$WORKFLOW_STATE_DIR/completed/"
        notify_success "Workflow Complete" "Workflow $workflow_id completed successfully"
    else
        mv "$state_file" "$WORKFLOW_STATE_DIR/failed/"
        notify_error "Workflow Failed" "Workflow $workflow_id failed"
    fi
    
    log_info "Workflow $workflow_id $status"
}

# Run complete workflow
run_workflow() {
    local workflow_id="$1"
    local input_data="$2"
    
    start_workflow "$workflow_id" "$input_data"
    
    local workflow_file="$WORKFLOW_CONFIG_DIR/${workflow_id}.json"
    local step_count=$(jq '.steps | length' "$workflow_file")
    
    # Execute each step
    for ((i=0; i<step_count; i++)); do
        if ! execute_workflow_step "$workflow_id" "$i"; then
            complete_workflow "$workflow_id" "failed"
            return 1
        fi
    done
    
    complete_workflow "$workflow_id" "completed"
}

# === PREDEFINED WORKFLOWS FOR BILL ===

# Create VRBO guest onboarding workflow
create_vrbo_guest_workflow() {
    local steps='[
        {
            "type": "module_function",
            "module": "vrbo_automation",
            "function": "process_new_booking",
            "parameters": "{\"source\": \"email\"}"
        },
        {
            "type": "module_function",
            "module": "google_tasks",
            "function": "create_guest_tasks",
            "parameters": "{\"task_type\": \"preparation\"}"
        },
        {
            "type": "module_function",
            "module": "chatgpt_integration",
            "function": "generate_welcome_message",
            "parameters": "{\"template\": \"guest_welcome\"}"
        },
        {
            "type": "notification",
            "parameters": "{\"type\": \"success\", \"message\": \"Guest onboarding workflow completed\"}"
        }
    ]'
    
    create_workflow "vrbo_guest_onboarding" "Automated VRBO guest onboarding process" "$steps"
}

# Create partnership evaluation workflow
create_partnership_workflow() {
    local steps='[
        {
            "type": "data_transform",
            "parameters": "{\"operation\": \"extract_email\", \"input_field\": \"inquiry\", \"output_field\": \"contact_email\"}"
        },
        {
            "type": "module_function",
            "module": "chatgpt_integration",
            "function": "analyze_partnership_potential",
            "parameters": "{\"analysis_type\": \"business_fit\"}"
        },
        {
            "type": "module_function",
            "module": "google_tasks",
            "function": "create_partnership_tasks",
            "parameters": "{\"priority\": \"high\"}"
        },
        {
            "type": "notification",
            "parameters": "{\"type\": \"info\", \"message\": \"New partnership inquiry processed\"}"
        }
    ]'
    
    create_workflow "partnership_evaluation" "Automated partnership inquiry evaluation" "$steps"
}

# Create revenue reporting workflow
create_revenue_workflow() {
    local steps='[
        {
            "type": "module_function",
            "module": "data_automation",
            "function": "collect_revenue_data",
            "parameters": "{\"period\": \"monthly\"}"
        },
        {
            "type": "data_transform",
            "parameters": "{\"operation\": \"calculate_revenue\", \"input_field\": \"raw_data\", \"output_field\": \"totals\"}"
        },
        {
            "type": "module_function",
            "module": "chatgpt_integration",
            "function": "generate_revenue_insights",
            "parameters": "{\"report_type\": \"monthly_summary\"}"
        },
        {
            "type": "notification",
            "parameters": "{\"type\": \"success\", \"message\": \"Monthly revenue report generated\"}"
        }
    ]'
    
    create_workflow "revenue_reporting" "Automated monthly revenue reporting" "$steps"
}

# List all workflows
list_workflows() {
    print_header "📋 WORKFLOW REGISTRY"
    
    if [ ! -d "$WORKFLOW_CONFIG_DIR" ]; then
        log_warning "Workflow system not initialized"
        return 1
    fi
    
    echo "Active Workflows:"
    ls -1 "$WORKFLOW_STATE_DIR/active/"*.state 2>/dev/null | wc -l || echo "0"
    echo ""
    
    echo "Available Workflow Templates:"
    for workflow_file in "$WORKFLOW_CONFIG_DIR"/*.json; do
        if [ -f "$workflow_file" ]; then
            local workflow_id=$(basename "$workflow_file" .json)
            local workflow_name=$(jq -r '.name' "$workflow_file")
            local workflow_desc=$(jq -r '.description' "$workflow_file")
            echo "  • $workflow_id: $workflow_name"
            echo "    $workflow_desc"
            echo ""
        fi
    done
}

# Monitor workflow status
monitor_workflows() {
    print_header "📊 WORKFLOW MONITORING"
    
    echo "📈 Workflow Statistics:"
    echo "  Active: $(ls -1 "$WORKFLOW_STATE_DIR/active/"*.state 2>/dev/null | wc -l)"
    echo "  Completed: $(ls -1 "$WORKFLOW_STATE_DIR/completed/"*.state 2>/dev/null | wc -l)"
    echo "  Failed: $(ls -1 "$WORKFLOW_STATE_DIR/failed/"*.state 2>/dev/null | wc -l)"
    echo ""
    
    echo "🏃 Currently Running:"
    for state_file in "$WORKFLOW_STATE_DIR/active/"*.state; do
        if [ -f "$state_file" ]; then
            local workflow_id=$(jq -r '.workflow_id' "$state_file")
            local current_step=$(jq -r '.current_step' "$state_file")
            local started=$(jq -r '.started' "$state_file")
            echo "  • $workflow_id (Step $current_step, Started: $started)"
        fi
    done
}

# Setup predefined workflows for Bill
setup_bill_workflows() {
    log_info "Setting up Bill's predefined workflows..."
    
    init_workflow_system
    
    # Create predefined workflows
    local vrbo_id=$(create_vrbo_guest_workflow)
    local partnership_id=$(create_partnership_workflow)
    local revenue_id=$(create_revenue_workflow)
    
    log_success "Created workflows:"
    echo "  • VRBO Guest Onboarding: $vrbo_id"
    echo "  • Partnership Evaluation: $partnership_id"
    echo "  • Revenue Reporting: $revenue_id"
    
    # Create workflow launcher script
    cat > "$WORKFLOW_DATA_DIR/launch_workflow.sh" << 'EOF'
#!/bin/bash
echo "🚀 BILL'S WORKFLOW LAUNCHER"
echo "=========================="
echo ""
echo "Available Workflows:"
echo "1) VRBO Guest Onboarding"
echo "2) Partnership Evaluation"  
echo "3) Revenue Reporting"
echo "4) List All Workflows"
echo "5) Monitor Active Workflows"
echo ""
read -p "Select workflow (1-5): " choice

case $choice in
    1) run_workflow "vrbo_guest_onboarding" '{"trigger": "manual"}' ;;
    2) run_workflow "partnership_evaluation" '{"trigger": "manual"}' ;;
    3) run_workflow "revenue_reporting" '{"trigger": "manual"}' ;;
    4) list_workflows ;;
    5) monitor_workflows ;;
    *) echo "Invalid choice" ;;
esac
EOF
    chmod +x "$WORKFLOW_DATA_DIR/launch_workflow.sh"
    
    log_success "Workflow orchestration system ready!"
    echo ""
    echo "🚀 Quick Start:"
    echo "  • Launch workflows: $WORKFLOW_DATA_DIR/launch_workflow.sh"
    echo "  • Monitor workflows: monitor_workflows"
    echo "  • Workflow data: $WORKFLOW_DATA_DIR"
}

# Export functions
export -f init_workflow_system generate_workflow_id create_workflow start_workflow
export -f execute_workflow_step complete_workflow run_workflow list_workflows
export -f monitor_workflows setup_bill_workflows
export -f create_vrbo_guest_workflow create_partnership_workflow create_revenue_workflow