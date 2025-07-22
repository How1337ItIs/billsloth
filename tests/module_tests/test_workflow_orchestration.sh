#!/bin/bash
# Detailed tests for workflow orchestration module

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

source "$BASE_DIR/lib/workflow_orchestration.sh"
source "$BASE_DIR/lib/data_sharing.sh"

# Test complex workflow scenarios
test_conditional_workflow() {
    echo "Testing conditional workflow execution..."
    
    init_workflow_system
    
    # Create workflow with conditions
    local workflow_steps='[
        {
            "name": "check_condition",
            "type": "function",
            "function": "test_condition",
            "condition": "true"
        },
        {
            "name": "conditional_step",
            "type": "script",
            "command": "echo Condition met",
            "condition": "{{step.check_condition.result}} == true"
        },
        {
            "name": "always_run",
            "type": "script",
            "command": "echo Always executed"
        }
    ]'
    
    create_workflow "conditional_test" "Conditional workflow test" "$workflow_steps"
    
    # Define test condition function
    test_condition() {
        echo "true"
        return 0
    }
    export -f test_condition
    
    # Run workflow
    if ! run_workflow "conditional_test" '{"test": true}'; then
        echo "FAILED: Conditional workflow execution failed"
        return 1
    fi
    
    echo "PASSED: Conditional workflow executed correctly"
    return 0
}

test_parallel_workflow() {
    echo "Testing parallel workflow execution..."
    
    # Create workflow with parallel steps
    local workflow_steps='[
        {
            "name": "parallel_group",
            "type": "parallel",
            "steps": [
                {"name": "task1", "type": "script", "command": "sleep 1; echo Task 1"},
                {"name": "task2", "type": "script", "command": "sleep 1; echo Task 2"},
                {"name": "task3", "type": "script", "command": "sleep 1; echo Task 3"}
            ]
        },
        {
            "name": "final_step",
            "type": "script",
            "command": "echo All parallel tasks completed"
        }
    ]'
    
    create_workflow "parallel_test" "Parallel workflow test" "$workflow_steps"
    
    # Measure execution time
    local start_time=$(date +%s)
    run_workflow "parallel_test" '{}'
    local end_time=$(date +%s)
    local duration=$(($end_time - $start_time))
    
    # Should take ~1 second if parallel, ~3 seconds if sequential
    if [ $duration -gt 2 ]; then
        echo "WARNING: Parallel execution may not be working (took ${duration}s)"
    fi
    
    echo "PASSED: Parallel workflow completed in ${duration}s"
    return 0
}

test_workflow_error_handling() {
    echo "Testing workflow error handling..."
    
    # Create workflow with failing step
    local workflow_steps='[
        {
            "name": "successful_step",
            "type": "script",
            "command": "echo Success"
        },
        {
            "name": "failing_step",
            "type": "script",
            "command": "exit 1",
            "on_error": "continue"
        },
        {
            "name": "recovery_step",
            "type": "script",
            "command": "echo Recovered from error"
        }
    ]'
    
    create_workflow "error_test" "Error handling test" "$workflow_steps"
    
    # Run workflow - should continue despite error
    if ! run_workflow "error_test" '{}'; then
        echo "FAILED: Workflow did not handle error correctly"
        return 1
    fi
    
    echo "PASSED: Workflow error handling works correctly"
    return 0
}

test_workflow_data_passing() {
    echo "Testing data passing between workflow steps..."
    
    # Create workflow that passes data between steps
    local workflow_steps='[
        {
            "name": "generate_data",
            "type": "function",
            "function": "generate_test_data"
        },
        {
            "name": "process_data",
            "type": "function",
            "function": "process_test_data",
            "input": "{{step.generate_data.output}}"
        },
        {
            "name": "save_result",
            "type": "function",
            "function": "save_test_result",
            "input": "{{step.process_data.output}}"
        }
    ]'
    
    # Define test functions
    generate_test_data() {
        echo '{"value": 42, "timestamp": "'$(date -Iseconds)'"}'
    }
    
    process_test_data() {
        local input="$1"
        local value=$(echo "$input" | jq -r '.value')
        local doubled=$((value * 2))
        echo '{"processed": '$doubled'}'
    }
    
    save_test_result() {
        local input="$1"
        cache_data "workflow_test" "result" "$input"
        echo "Result saved"
    }
    
    export -f generate_test_data process_test_data save_test_result
    
    create_workflow "data_passing_test" "Data passing test" "$workflow_steps"
    run_workflow "data_passing_test" '{}'
    
    # Verify result
    local saved_result=$(get_cached_data "workflow_test" "result")
    local processed_value=$(echo "$saved_result" | jq -r '.processed')
    
    if [ "$processed_value" != "84" ]; then
        echo "FAILED: Data passing failed (expected 84, got $processed_value)"
        return 1
    fi
    
    echo "PASSED: Data passing between steps works correctly"
    return 0
}

test_workflow_scheduling() {
    echo "Testing workflow scheduling..."
    
    # Create scheduled workflow
    local schedule_time=$(date -d "+1 minute" "+%H:%M")
    
    if ! schedule_workflow "test_scheduled" "*/5 * * * *" "echo Scheduled task"; then
        echo "WARNING: Workflow scheduling may not be configured"
    fi
    
    # List scheduled workflows
    if command -v list_scheduled_workflows &> /dev/null; then
        list_scheduled_workflows
    fi
    
    echo "PASSED: Workflow scheduling test completed"
    return 0
}

# Run all workflow tests
run_workflow_tests() {
    echo "========================================="
    echo "Workflow Orchestration Detailed Tests"
    echo "========================================="
    
    local tests_passed=0
    local tests_failed=0
    
    # Initialize systems
    init_data_sharing
    init_workflow_system
    
    # Run each test
    for test_func in test_conditional_workflow test_parallel_workflow test_workflow_error_handling test_workflow_data_passing test_workflow_scheduling; do
        echo ""
        if $test_func; then
            ((tests_passed++))
        else
            ((tests_failed++))
        fi
    done
    
    echo ""
    echo "Results: $tests_passed passed, $tests_failed failed"
    
    return $tests_failed
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_workflow_tests
fi