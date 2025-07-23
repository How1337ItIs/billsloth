#!/bin/bash
# LLM_CAPABILITY: local_ok
# Performance Monitoring Wrappers
# Lightweight wrappers to add performance monitoring to existing functions


set -euo pipefail
source "$SCRIPT_DIR/performance_monitoring.sh" 2>/dev/null || true

# Wrap a function with performance monitoring
wrap_function_with_monitoring() {
    local original_function="$1"
    local module_name="$2"
    local operation_name="${3:-$original_function}"
    
    # Check if function exists
    if ! command -v "$original_function" &>/dev/null; then
        return 1
    fi
    
    # Create wrapper function
    eval "
    ${original_function}_monitored() {
        local start_time=\$(date +%s%N)
        local exit_code=0
        
        # Call original function
        $original_function \"\$@\" || exit_code=\$?
        
        # Record performance metrics
        if command -v capture_performance_snapshot &>/dev/null; then
            local end_time=\$(date +%s%N)
            local duration_ms=\$(( (end_time - start_time) / 1000000 ))
            capture_performance_snapshot \"$module_name\" \"$operation_name\" \"\$duration_ms\" >/dev/null 2>&1 || true
        fi
        
        return \$exit_code
    }
    
    # Create alias for easy usage
    alias ${original_function}_perf='${original_function}_monitored'
    "
    
    echo "✅ Performance monitoring wrapper created for $original_function"
}

# Create performance-optimized version of key operations
create_optimized_data_operations() {
    # Optimized store operation with caching
    optimized_store_data() {
        local module="$1"
        local key="$2"
        local value="$3"
        local ttl_hours="${4:-24}"
        local data_type="${5:-string}"
        
        # Performance optimization: Skip if value hasn't changed
        local existing_value
        if existing_value=$(get_data "$module" "$key" "" 2>/dev/null); then
            if [ "$existing_value" = "$value" ]; then
                return 0  # No change needed
            fi
        fi
        
        # Call original function with monitoring
        local start_time=$(date +%s%N)
        local exit_code=0
        
        store_data "$module" "$key" "$value" "$ttl_hours" "$data_type" || exit_code=$?
        
        # Record performance
        if command -v capture_performance_snapshot &>/dev/null; then
            local end_time=$(date +%s%N)
            local duration_ms=$(( (end_time - start_time) / 1000000 ))
            capture_performance_snapshot "data_persistence" "optimized_store_data" "$duration_ms" >/dev/null 2>&1 || true
        fi
        
        return $exit_code
    }
    
    # Optimized batch operations
    batch_store_data() {
        local module="$1"
        shift
        local operations=("$@")
        
        local start_time=$(date +%s%N)
        local operations_count=0
        local failed_operations=0
        
        # Begin transaction if using SQLite
        if [ "$DATABASE_ENGINE" = "sqlite3" ]; then
            local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
            echo "BEGIN TRANSACTION;" | sqlite3 "$db_file" 2>/dev/null || true
        fi
        
        # Process operations in batch
        for operation in "${operations[@]}"; do
            # Expected format: "key:value:ttl:type"
            IFS=':' read -r key value ttl type <<< "$operation"
            
            if optimized_store_data "$module" "$key" "$value" "${ttl:-24}" "${type:-string}"; then
                ((operations_count++))
            else
                ((failed_operations++))
            fi
        done
        
        # Commit transaction if using SQLite
        if [ "$DATABASE_ENGINE" = "sqlite3" ]; then
            local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
            echo "COMMIT;" | sqlite3 "$db_file" 2>/dev/null || true
        fi
        
        # Record batch performance
        if command -v capture_performance_snapshot &>/dev/null; then
            local end_time=$(date +%s%N)
            local duration_ms=$(( (end_time - start_time) / 1000000 ))
            local metadata="{\"operations_count\": $operations_count, \"failed_operations\": $failed_operations}"
            capture_performance_snapshot "data_persistence" "batch_store_data" "$duration_ms" >/dev/null 2>&1 || true
        fi
        
        echo "Batch operation completed: $operations_count successful, $failed_operations failed"
        return $failed_operations
    }
    
    export -f optimized_store_data batch_store_data
}

# Create optimized backup operations
create_optimized_backup_operations() {
    # Smart backup that checks for changes before backing up
    smart_backup() {
        local backup_set="$1"
        local backup_type="${2:-incremental}"
        local destination="${3:-local}"
        
        local start_time=$(date +%s%N)
        
        # Check if backup is needed (simple change detection)
        local config_file="$HOME/.bill-sloth/backups/config/backup_config.json"
        local sources=$(jq -r ".backup_sets.${backup_set}.sources[]?" "$config_file" 2>/dev/null)
        local changes_detected=false
        
        # Quick change detection using modification times
        local last_backup_time=""
        if [ -f "$HOME/.bill-sloth/backups/config/backup_history.json" ]; then
            last_backup_time=$(jq -r --arg set "$backup_set" '.backups[] | select(.backup_set == $set) | .timestamp' "$HOME/.bill-sloth/backups/config/backup_history.json" | tail -1)
        fi
        
        if [ -n "$last_backup_time" ] && [ "$backup_type" = "incremental" ]; then
            # Convert to epoch time for comparison
            local last_backup_epoch=$(date -d "$last_backup_time" +%s 2>/dev/null || echo "0")
            
            # Check if any source directories have changed
            echo "$sources" | while read -r source; do
                if [ -n "$source" ]; then
                    local expanded_source=$(eval echo "$source")
                    if [ -d "$expanded_source" ]; then
                        local source_mtime=$(find "$expanded_source" -type f -newer "@$last_backup_epoch" | head -1)
                        if [ -n "$source_mtime" ]; then
                            changes_detected=true
                            break
                        fi
                    fi
                fi
            done
        else
            changes_detected=true  # Force backup for full backups or first backup
        fi
        
        if [ "$changes_detected" = true ]; then
            echo "Changes detected - proceeding with backup"
            create_backup "$backup_set" "$backup_type" "$destination"
            local backup_exit_code=$?
        else
            echo "No changes detected - skipping backup"
            local backup_exit_code=0
        fi
        
        # Record performance
        if command -v capture_performance_snapshot &>/dev/null; then
            local end_time=$(date +%s%N)
            local duration_ms=$(( (end_time - start_time) / 1000000 ))
            local operation_name="smart_backup_${changes_detected}"
            capture_performance_snapshot "backup_management" "$operation_name" "$duration_ms" >/dev/null 2>&1 || true
        fi
        
        return $backup_exit_code
    }
    
    # Parallel backup for multiple sets
    parallel_backup() {
        local backup_sets=("$@")
        local pids=()
        local results=()
        
        local start_time=$(date +%s%N)
        
        echo "Starting parallel backup for ${#backup_sets[@]} backup sets..."
        
        # Start backups in parallel
        for backup_set in "${backup_sets[@]}"; do
            {
                smart_backup "$backup_set" "incremental" "local"
                echo $? > "/tmp/backup_${backup_set}_result"
            } &
            pids+=($!)
        done
        
        # Wait for all backups to complete
        local failed_backups=0
        for i in "${!pids[@]}"; do
            wait "${pids[$i]}"
            local backup_set="${backup_sets[$i]}"
            local result=$(cat "/tmp/backup_${backup_set}_result" 2>/dev/null || echo "1")
            results+=("$backup_set:$result")
            
            if [ "$result" -ne 0 ]; then
                ((failed_backups++))
            fi
            
            # Clean up temp file
            rm -f "/tmp/backup_${backup_set}_result"
        done
        
        # Record performance
        if command -v capture_performance_snapshot &>/dev/null; then
            local end_time=$(date +%s%N)
            local duration_ms=$(( (end_time - start_time) / 1000000 ))
            local metadata="{\"backup_sets_count\": ${#backup_sets[@]}, \"failed_backups\": $failed_backups}"
            capture_performance_snapshot "backup_management" "parallel_backup" "$duration_ms" >/dev/null 2>&1 || true
        fi
        
        echo "Parallel backup completed: $((${#backup_sets[@]} - failed_backups)) successful, $failed_backups failed"
        return $failed_backups
    }
    
    export -f smart_backup parallel_backup
}

# Create optimized workflow operations
create_optimized_workflow_operations() {
    # Workflow execution with resource monitoring
    resource_aware_workflow() {
        local workflow_id="$1"
        local workflow_data="${2:-{}}"
        
        # Check system resources before starting workflow
        local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%us,//' 2>/dev/null || echo "0")
        local memory_info=$(free -m | grep '^Mem:')
        local memory_total=$(echo "$memory_info" | awk '{print $2}')
        local memory_used=$(echo "$memory_info" | awk '{print $3}')
        local memory_percent=$(awk "BEGIN {printf \"%.1f\", ($memory_used/$memory_total)*100}")
        
        # Apply resource-based constraints
        local max_concurrent_ops=4
        if (( $(echo "$cpu_usage > 70" | bc -l 2>/dev/null || echo "0") )); then
            max_concurrent_ops=2
            echo "High CPU usage detected - reducing workflow concurrency"
        fi
        
        if (( $(echo "$memory_percent > 80" | bc -l 2>/dev/null || echo "0") )); then
            max_concurrent_ops=1
            echo "High memory usage detected - running workflow sequentially"
        fi
        
        local start_time=$(date +%s%N)
        local exit_code=0
        
        # Execute workflow with resource awareness
        if command -v run_workflow &>/dev/null; then
            # Set resource limits
            export MAX_CONCURRENT_OPERATIONS="$max_concurrent_ops"
            run_workflow "$workflow_id" "$workflow_data" || exit_code=$?
            unset MAX_CONCURRENT_OPERATIONS
        else
            echo "Workflow system not available"
            exit_code=1
        fi
        
        # Record performance
        if command -v capture_performance_snapshot &>/dev/null; then
            local end_time=$(date +%s%N)
            local duration_ms=$(( (end_time - start_time) / 1000000 ))
            local metadata="{\"workflow_id\": \"$workflow_id\", \"max_concurrent_ops\": $max_concurrent_ops, \"initial_cpu\": $cpu_usage, \"initial_memory_percent\": $memory_percent}"
            capture_performance_snapshot "workflow_orchestration" "resource_aware_workflow" "$duration_ms" >/dev/null 2>&1 || true
        fi
        
        return $exit_code
    }
    
    export -f resource_aware_workflow
}

# Initialize all performance wrappers
init_performance_wrappers() {
    echo "🚀 Initializing performance wrappers..."
    
    create_optimized_data_operations
    create_optimized_backup_operations
    create_optimized_workflow_operations
    
    # Auto-wrap common functions if they exist
    if command -v store_data &>/dev/null; then
        wrap_function_with_monitoring store_data "data_persistence" "store_data"
    fi
    
    if command -v create_backup &>/dev/null; then
        wrap_function_with_monitoring create_backup "backup_management" "create_backup"
    fi
    
    if command -v run_workflow &>/dev/null; then
        wrap_function_with_monitoring run_workflow "workflow_orchestration" "run_workflow"
    fi
    
    echo "✅ Performance wrappers initialized"
}

# Export functions
export -f wrap_function_with_monitoring init_performance_wrappers
export -f create_optimized_data_operations create_optimized_backup_operations create_optimized_workflow_operations

# Initialize on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_performance_wrappers 2>/dev/null || true
fi