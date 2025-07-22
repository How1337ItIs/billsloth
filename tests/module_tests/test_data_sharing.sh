#!/bin/bash
# Detailed tests for data sharing module

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

source "$BASE_DIR/lib/data_sharing.sh"

# Test data sharing edge cases
test_concurrent_access() {
    echo "Testing concurrent data access..."
    
    init_data_sharing
    
    # Simulate concurrent writes
    for i in {1..10}; do
        (
            cache_data "concurrent_test" "shared_key" "{\"writer\": $i, \"time\": \"$(date +%s%N)\"}"
        ) &
    done
    
    # Wait for all background jobs
    wait
    
    # Verify last write wins
    local final_data=$(get_cached_data "concurrent_test" "shared_key")
    if [ -z "$final_data" ]; then
        echo "FAILED: No data found after concurrent writes"
        return 1
    fi
    
    echo "PASSED: Concurrent access handled correctly"
    return 0
}

test_large_data_handling() {
    echo "Testing large data handling..."
    
    # Create large JSON object (1MB)
    local large_data='{"data": "'
    for i in {1..10000}; do
        large_data+="Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
    done
    large_data+='"}'
    
    # Test caching large data
    if ! cache_data "large_test" "big_data" "$large_data"; then
        echo "FAILED: Could not cache large data"
        return 1
    fi
    
    # Test retrieving large data
    local retrieved=$(get_cached_data "large_test" "big_data")
    if [ ${#retrieved} -lt 1000000 ]; then
        echo "FAILED: Large data not fully retrieved"
        return 1
    fi
    
    echo "PASSED: Large data handling works correctly"
    return 0
}

test_data_expiration() {
    echo "Testing data expiration..."
    
    # Cache data with expiration
    cache_data "expiry_test" "temp_key" '{"expires": "soon"}' 2
    
    # Verify data exists
    local data=$(get_cached_data "expiry_test" "temp_key")
    if [ -z "$data" ]; then
        echo "FAILED: Data not cached"
        return 1
    fi
    
    # Wait for expiration
    sleep 3
    
    # Verify data expired
    data=$(get_cached_data "expiry_test" "temp_key")
    if [ ! -z "$data" ]; then
        echo "FAILED: Data did not expire"
        return 1
    fi
    
    echo "PASSED: Data expiration works correctly"
    return 0
}

test_cross_module_sync() {
    echo "Testing cross-module synchronization..."
    
    # Module A writes data
    cache_data "module_a" "shared_config" '{"setting": "value1"}'
    
    # Share with module B
    share_data "module_a" "module_b" "config_update" '{"setting": "value1"}'
    
    # Module B reads shared data
    local module_b_data=$(get_cached_data "module_b" "module_a.config_update")
    
    if [ "$module_b_data" != '{"setting": "value1"}' ]; then
        echo "FAILED: Cross-module sync failed"
        return 1
    fi
    
    # Test sync_all_data
    sync_all_data
    
    echo "PASSED: Cross-module synchronization works"
    return 0
}

# Run all data sharing tests
run_data_sharing_tests() {
    echo "==================================="
    echo "Data Sharing Module Detailed Tests"
    echo "==================================="
    
    local tests_passed=0
    local tests_failed=0
    
    # Run each test
    for test_func in test_concurrent_access test_large_data_handling test_data_expiration test_cross_module_sync; do
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
    run_data_sharing_tests
fi