#!/bin/bash
# Test fixtures and utilities for Bill Sloth integration tests

# Create test environment
create_test_environment() {
    local test_home="$HOME/.bill-sloth-test"
    
    # Backup existing environment if needed
    if [ -d "$HOME/.bill-sloth" ]; then
        echo "Backing up existing .bill-sloth directory..."
        mv "$HOME/.bill-sloth" "$HOME/.bill-sloth.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Create clean test environment
    mkdir -p "$test_home"/{lib,modules,command-center,architecture,backups,workflows,shared-data}
    
    # Copy essential files
    cp -r "$BASE_DIR/lib/"* "$test_home/lib/" 2>/dev/null || true
    
    echo "Test environment created at: $test_home"
}

# Restore original environment
restore_environment() {
    if [ -d "$HOME/.bill-sloth.backup."* ]; then
        local latest_backup=$(ls -d "$HOME/.bill-sloth.backup."* | tail -1)
        rm -rf "$HOME/.bill-sloth"
        mv "$latest_backup" "$HOME/.bill-sloth"
        echo "Environment restored from backup"
    fi
}

# Create mock data for testing
create_mock_vrbo_data() {
    local vrbo_dir="$HOME/.bill-sloth/vrbo-automation/data"
    mkdir -p "$vrbo_dir"
    
    cat > "$vrbo_dir/test_property.json" << EOF
{
    "property_id": "test_001",
    "name": "Test Beach House",
    "address": "123 Test Beach Rd",
    "bookings": [
        {
            "guest": "John Doe",
            "checkin": "2024-02-01",
            "checkout": "2024-02-05",
            "status": "confirmed"
        }
    ]
}
EOF
}

create_mock_edboigames_data() {
    local edboigames_dir="$HOME/edboigames_business/data"
    mkdir -p "$edboigames_dir"
    
    cat > "$edboigames_dir/partnerships.json" << EOF
{
    "partnerships": [
        {
            "name": "Test Partner Inc",
            "type": "content",
            "status": "active",
            "revenue_share": 0.3
        }
    ]
}
EOF
}

# Validation helpers
validate_json_file() {
    local file="$1"
    
    if [ ! -f "$file" ]; then
        echo "File not found: $file"
        return 1
    fi
    
    if ! jq empty "$file" 2>/dev/null; then
        echo "Invalid JSON in: $file"
        return 1
    fi
    
    return 0
}

validate_directory_structure() {
    local base_dir="$1"
    shift
    local required_dirs=("$@")
    
    for dir in "${required_dirs[@]}"; do
        if [ ! -d "$base_dir/$dir" ]; then
            echo "Missing required directory: $base_dir/$dir"
            return 1
        fi
    done
    
    return 0
}

# Performance testing utilities
measure_function_time() {
    local function_name="$1"
    shift
    local args=("$@")
    
    local start_time=$(date +%s%N)
    $function_name "${args[@]}"
    local exit_code=$?
    local end_time=$(date +%s%N)
    
    local duration=$((($end_time - $start_time) / 1000000)) # milliseconds
    echo "Function $function_name took ${duration}ms"
    
    return $exit_code
}

# Stress testing utilities
stress_test_data_sharing() {
    local iterations="${1:-1000}"
    
    source "$BASE_DIR/lib/data_sharing.sh"
    init_data_sharing
    
    echo "Stress testing data sharing with $iterations iterations..."
    
    local start_time=$(date +%s)
    
    for i in $(seq 1 $iterations); do
        cache_data "stress_test" "key_$i" "{\"iteration\": $i, \"timestamp\": \"$(date -Iseconds)\"}"
        
        if [ $((i % 100)) -eq 0 ]; then
            echo -n "."
        fi
    done
    
    local end_time=$(date +%s)
    local duration=$(($end_time - $start_time))
    
    echo ""
    echo "Completed $iterations operations in ${duration}s"
    echo "Average: $(awk "BEGIN {printf \"%.2f\", $duration/$iterations*1000}")ms per operation"
}

# Integration scenario tests
test_full_vrbo_workflow() {
    echo "Testing complete VRBO workflow..."
    
    # 1. Create booking
    local booking_data='{
        "guest": "Integration Test Guest",
        "property": "Test Property",
        "checkin": "2024-02-15",
        "checkout": "2024-02-20"
    }'
    
    # 2. Share booking data
    source "$BASE_DIR/lib/data_sharing.sh"
    share_data "vrbo_automation" "google_tasks" "new_booking" "$booking_data"
    
    # 3. Create workflow
    source "$BASE_DIR/lib/workflow_orchestration.sh"
    local workflow_steps='[
        {"name": "create_task", "type": "function", "function": "create_guest_task"},
        {"name": "send_welcome", "type": "script", "command": "echo Welcome email sent"},
        {"name": "prepare_property", "type": "function", "function": "prepare_property"}
    ]'
    
    create_workflow "test_vrbo_workflow" "Test VRBO Workflow" "$workflow_steps"
    
    # 4. Run workflow
    run_workflow "test_vrbo_workflow" "$booking_data"
    
    echo "VRBO workflow test completed"
}

# Export test utilities
export -f create_test_environment restore_environment
export -f create_mock_vrbo_data create_mock_edboigames_data
export -f validate_json_file validate_directory_structure
export -f measure_function_time stress_test_data_sharing
export -f test_full_vrbo_workflow