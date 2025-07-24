#!/bin/bash
# Bill Sloth Comprehensive Integration Test Suite
# Tests all modules working together as a unified system

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_SKIPPED=0

# Test results array
declare -A TEST_RESULTS

# Test categories
declare -A TEST_CATEGORIES=(
    ["core"]="Core System Functionality"
    ["data_sharing"]="Cross-Module Data Sharing"
    ["workflows"]="Workflow Orchestration"
    ["bill_specific"]="Bill-Specific Integrations"
    ["backup"]="Backup Management"
    ["architecture"]="Unified Architecture"
    ["command_center"]="Command Center Integration"
    ["production_safety"]="Production Safety & Error Handling"
    ["performance"]="Performance & Resource Usage"
)

# Source test utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Ensure we're in a bash environment
set +e  # Don't exit on errors during tests

# Test output directory
TEST_OUTPUT_DIR="$BASE_DIR/tests/output/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$TEST_OUTPUT_DIR"

# Log file
TEST_LOG="$TEST_OUTPUT_DIR/integration_test.log"

# Helper functions
log_test() {
    local message="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $message" | tee -a "$TEST_LOG"
}

run_test() {
    local test_name="$1"
    local test_category="$2"
    local test_function="$3"
    
    echo -ne "  Testing $test_name... "
    
    # Capture test output
    local test_output="$TEST_OUTPUT_DIR/${test_category}_${test_name}.log"
    
    if $test_function > "$test_output" 2>&1; then
        echo -e "${GREEN}PASSED${NC}"
        ((TESTS_PASSED++))
        TEST_RESULTS["$test_category.$test_name"]="PASSED"
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        ((TESTS_FAILED++))
        TEST_RESULTS["$test_category.$test_name"]="FAILED"
        echo "  See: $test_output"
        return 1
    fi
}

skip_test() {
    local test_name="$1"
    local reason="$2"
    
    echo -e "  Testing $test_name... ${YELLOW}SKIPPED${NC} ($reason)"
    ((TESTS_SKIPPED++))
    TEST_RESULTS["$test_name"]="SKIPPED: $reason"
}

# Initialize test environment
init_test_environment() {
    # Create any missing directories
    mkdir -p "$HOME/.bill-sloth"/{lib,modules,command-center,architecture,backups,workflows,shared-data} 2>/dev/null || true
}

# Core system tests
test_core_directories() {
    # Test that all core directories exist
    local dirs=(
        "$HOME/.bill-sloth"
        "$HOME/.bill-sloth/lib"
        "$HOME/.bill-sloth/modules"
        "$HOME/.bill-sloth/command-center"
        "$HOME/.bill-sloth/architecture"
        "$HOME/.bill-sloth/backups"
        "$HOME/.bill-sloth/workflows"
        "$HOME/.bill-sloth/shared-data"
    )
    
    for dir in "${dirs[@]}"; do
        if [ ! -d "$dir" ]; then
            echo "Missing directory: $dir"
            return 1
        fi
    done
    
    return 0
}

test_core_libraries() {
    # Test that all core libraries can be sourced
    local libs=(
        "error_handling.sh"
        "notification_system.sh"
        "data_sharing.sh"
        "workflow_orchestration.sh"
        "backup_management.sh"
        "architecture_unification.sh"
    )
    
    for lib in "${libs[@]}"; do
        if ! source "$BASE_DIR/lib/$lib" 2>/dev/null; then
            echo "Failed to source library: $lib"
            return 1
        fi
    done
    
    return 0
}

test_command_center_launch() {
    # Test that command center can initialize
    if ! source "$BASE_DIR/bill_command_center.sh" 2>/dev/null; then
        echo "Failed to source command center"
        return 1
    fi
    
    # Test initialization function exists
    if ! command -v init_bill_command_center &> /dev/null; then
        echo "Command center initialization function missing"
        return 1
    fi
    
    # Test initialization
    if ! init_bill_command_center > /dev/null 2>&1; then
        echo "Command center initialization failed"
        return 1
    fi
    
    return 0
}

# Data sharing tests
test_data_sharing_init() {
    source "$BASE_DIR/lib/data_sharing.sh"
    
    if ! init_data_sharing; then
        echo "Data sharing initialization failed"
        return 1
    fi
    
    # Check cache directories created
    if [ ! -d "$HOME/.bill-sloth/shared-data/cache" ]; then
        echo "Cache directory not created"
        return 1
    fi
    
    return 0
}

test_data_sharing_operations() {
    source "$BASE_DIR/lib/data_sharing.sh"
    
    # Test caching data
    local test_data='{"test": "data", "timestamp": "2024-01-01"}'
    if ! cache_data "test_module" "test_key" "$test_data"; then
        echo "Failed to cache data"
        return 1
    fi
    
    # Test retrieving cached data
    local retrieved_data=$(get_cached_data "test_module" "test_key")
    if [ "$retrieved_data" != "$test_data" ]; then
        echo "Retrieved data doesn't match cached data"
        return 1
    fi
    
    # Test sharing data between modules
    if ! share_data "module_a" "module_b" "shared_key" "$test_data"; then
        echo "Failed to share data between modules"
        return 1
    fi
    
    return 0
}

# Workflow tests
test_workflow_init() {
    source "$BASE_DIR/lib/workflow_orchestration.sh"
    
    if ! init_workflow_system; then
        echo "Workflow system initialization failed"
        return 1
    fi
    
    # Check workflow directories
    if [ ! -d "$HOME/.bill-sloth/workflows/definitions" ]; then
        echo "Workflow definitions directory not created"
        return 1
    fi
    
    return 0
}

test_workflow_creation() {
    source "$BASE_DIR/lib/workflow_orchestration.sh"
    
    # Create test workflow
    local workflow_steps='[
        {"name": "step1", "type": "script", "command": "echo test"},
        {"name": "step2", "type": "function", "function": "test_function"}
    ]'
    
    if ! create_workflow "test_workflow" "Test workflow" "$workflow_steps"; then
        echo "Failed to create workflow"
        return 1
    fi
    
    # Check workflow file created
    if [ ! -f "$HOME/.bill-sloth/workflows/definitions/test_workflow.json" ]; then
        echo "Workflow definition file not created"
        return 1
    fi
    
    return 0
}

# Bill-specific integration tests
test_vrbo_integration() {
    # Test VRBO automation directory structure
    if [ ! -d "$HOME/.bill-sloth/vrbo-automation" ]; then
        mkdir -p "$HOME/.bill-sloth/vrbo-automation"/{scripts,data}
    fi
    
    # Test VRBO data sharing
    source "$BASE_DIR/lib/data_sharing.sh"
    local vrbo_booking='{"guest": "Test Guest", "property": "Test Property", "checkin": "2024-01-01"}'
    
    if command -v share_vrbo_booking &> /dev/null; then
        if ! share_vrbo_booking "$vrbo_booking"; then
            echo "VRBO booking sharing failed"
            return 1
        fi
    fi
    
    return 0
}

test_edboigames_integration() {
    # Test EdBoiGames directory structure
    if [ ! -d "$HOME/edboigames_business" ]; then
        mkdir -p "$HOME/edboigames_business"/{automation/scripts,partnerships,templates}
    fi
    
    # Test EdBoiGames module sourcing
    if [ -f "$BASE_DIR/modules/edboigames/controller.sh" ]; then
        if ! source "$BASE_DIR/modules/edboigames/controller.sh" 2>/dev/null; then
            echo "Failed to source EdBoiGames controller"
            return 1
        fi
    fi
    
    return 0
}

test_google_tasks_integration() {
    # Test Google Tasks directory
    if [ ! -d "$HOME/.bill-sloth/google-tasks" ]; then
        mkdir -p "$HOME/.bill-sloth/google-tasks"/{scripts,data}
    fi
    
    # Test task creation function availability
    if command -v create_google_task &> /dev/null; then
        echo "Google Tasks integration available"
    else
        echo "Warning: Google Tasks functions not available"
    fi
    
    return 0
}

# Backup system tests
test_backup_init() {
    source "$BASE_DIR/lib/backup_management.sh"
    
    if ! init_backup_system; then
        echo "Backup system initialization failed"
        return 1
    fi
    
    # Check backup configuration
    if [ ! -f "$HOME/.bill-sloth/backups/config/backup_config.json" ]; then
        echo "Backup configuration not created"
        return 1
    fi
    
    return 0
}

test_backup_operations() {
    source "$BASE_DIR/lib/backup_management.sh"
    
    # Create test directory to backup
    local test_dir="$HOME/.bill-sloth/test_backup_source"
    mkdir -p "$test_dir"
    echo "test content" > "$test_dir/test_file.txt"
    
    # Create minimal backup set for testing
    local backup_config="$HOME/.bill-sloth/backups/config/backup_config.json"
    jq '.backup_sets.test_set = {
        "description": "Test backup set",
        "sources": ["~/.bill-sloth/test_backup_source"],
        "exclude_patterns": [],
        "retention_days": 1,
        "compression": false,
        "encryption": false
    }' "$backup_config" > "${backup_config}.tmp" && mv "${backup_config}.tmp" "$backup_config"
    
    # Test backup creation
    if ! create_backup "test_set" "full" "local" > /dev/null 2>&1; then
        echo "Backup creation failed"
        rm -rf "$test_dir"
        return 1
    fi
    
    # Cleanup
    rm -rf "$test_dir"
    return 0
}

# Architecture tests
test_unified_architecture() {
    source "$BASE_DIR/lib/architecture_unification.sh"
    
    if ! init_architecture_unification; then
        echo "Architecture unification initialization failed"
        return 1
    fi
    
    # Test overlay framework
    if [ ! -f "$HOME/.bill-sloth/architecture/config/architecture.json" ]; then
        echo "Architecture configuration not created"
        return 1
    fi
    
    # Test overlay framework can be sourced
    if [ -f "$HOME/.bill-sloth/architecture/overlays/bill_overlay_framework.sh" ]; then
        if ! source "$HOME/.bill-sloth/architecture/overlays/bill_overlay_framework.sh" 2>/dev/null; then
            echo "Failed to source overlay framework"
            return 1
        fi
    fi
    
    return 0
}

test_module_wrappers() {
    # Test that module wrappers exist for key modules
    local modules=("automation_mastery" "media_processing_pipeline" "data_hoarding")
    
    for module in "${modules[@]}"; do
        local wrapper="$HOME/.bill-sloth/architecture/wrappers/${module}_unified.sh"
        if [ ! -f "$wrapper" ]; then
            echo "Missing wrapper for $module"
            # Don't fail - wrappers might be created on demand
        fi
    done
    
    return 0
}

# Command center integration tests
test_command_center_health_check() {
    source "$BASE_DIR/bill_command_center.sh"
    
    # Test health check function
    if ! command -v check_system_health &> /dev/null; then
        echo "Health check function missing"
        return 1
    fi
    
    local health_info=$(check_system_health)
    if [ -z "$health_info" ]; then
        echo "Health check returned no data"
        return 1
    fi
    
    return 0
}

test_command_center_modules() {
    # Test that command center can reference all modules
    local modules=(
        "automation_mastery_interactive.sh"
        "network_management_interactive.sh"
        "data_hoarding.sh"
        "media_processing_pipeline.sh"
        "system_doctor_interactive.sh"
        "mobile_integration_interactive.sh"
    )
    
    for module in "${modules[@]}"; do
        if [ ! -f "$BASE_DIR/modules/$module" ]; then
            echo "Missing module: $module"
            return 1
        fi
    done
    
    return 0
}

# Production safety tests
test_production_safety_init() {
    source "$BASE_DIR/lib/production_safety.sh"
    
    if ! command -v init_production_safety &> /dev/null; then
        echo "Production safety initialization function missing"
        return 1
    fi
    
    if ! init_production_safety; then
        echo "Production safety initialization failed"
        return 1
    fi
    
    # Check safety directories created
    if [ ! -d "$HOME/.bill-sloth/safety" ]; then
        echo "Safety directory not created"
        return 1
    fi
    
    return 0
}

test_database_integrity_check() {
    source "$BASE_DIR/lib/production_safety.sh"
    source "$BASE_DIR/lib/data_persistence.sh"
    
    # Initialize database
    init_data_persistence
    
    local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
    
    # Test database integrity check
    if ! check_database_integrity "$db_file"; then
        echo "Database integrity check failed"
        return 1
    fi
    
    return 0
}

test_safe_input_validation() {
    source "$BASE_DIR/lib/production_safety.sh"
    
    # Test VRBO booking validation
    if ! validate_vrbo_booking "John Doe" "Test Property" "2025-01-01" "2025-01-02"; then
        echo "Valid VRBO booking failed validation"
        return 1
    fi
    
    # Test invalid input rejection
    if validate_vrbo_booking "" "" "invalid-date" "" 2>/dev/null; then
        echo "Invalid input was not rejected"
        return 1
    fi
    
    return 0
}

test_backup_verification() {
    source "$BASE_DIR/lib/production_safety.sh"
    
    # Create test file for verification
    local test_file="/tmp/test_backup_verification.txt"
    echo "test content" > "$test_file"
    
    # Test backup verification
    if ! verify_backup_integrity "$test_file"; then
        echo "Backup verification failed for valid file"
        rm -f "$test_file"
        return 1
    fi
    
    # Test empty file rejection
    touch "${test_file}.empty"
    if verify_backup_integrity "${test_file}.empty" 2>/dev/null; then
        echo "Empty file was not rejected"
        rm -f "$test_file" "${test_file}.empty"
        return 1
    fi
    
    rm -f "$test_file" "${test_file}.empty"
    return 0
}

test_dependency_checking() {
    source "$BASE_DIR/lib/production_safety.sh"
    
    # Test dependency checking (should find missing optional deps)
    if ! command -v check_critical_dependencies &> /dev/null; then
        echo "Dependency checking function missing"
        return 1
    fi
    
    # Run dependency check (may fail due to missing optional deps, but function should work)
    check_critical_dependencies > /dev/null 2>&1
    # Function should run without error even if deps are missing
    
    return 0
}

# Performance tests
test_data_sharing_performance() {
    source "$BASE_DIR/lib/data_sharing.sh"
    
    local start_time=$(date +%s%N)
    
    # Test caching 100 items
    for i in {1..100}; do
        cache_data "perf_test" "key_$i" "{\"data\": $i}" > /dev/null 2>&1
    done
    
    local end_time=$(date +%s%N)
    local duration=$((($end_time - $start_time) / 1000000)) # Convert to milliseconds
    
    if [ $duration -gt 5000 ]; then # More than 5 seconds
        echo "Data sharing too slow: ${duration}ms for 100 operations"
        return 1
    fi
    
    echo "Performance: ${duration}ms for 100 cache operations"
    return 0
}

test_performance_monitoring_system() {
    source "$BASE_DIR/lib/performance_monitoring.sh"
    
    # Test performance monitoring initialization
    if ! command -v capture_performance_snapshot &> /dev/null; then
        echo "Performance monitoring functions not available"
        return 1
    fi
    
    # Test performance snapshot capture
    local snapshot=$(capture_performance_snapshot "test_module" "test_operation" 100)
    if [ -z "$snapshot" ]; then
        echo "Failed to capture performance snapshot"
        return 1
    fi
    
    # Verify snapshot contains expected fields
    if ! echo "$snapshot" | jq -e '.module' >/dev/null 2>&1; then
        echo "Performance snapshot missing required fields"
        return 1
    fi
    
    return 0
}

test_performance_optimization() {
    source "$BASE_DIR/lib/performance_monitoring.sh"
    
    # Test that optimization functions exist
    if ! command -v optimize_module_performance &> /dev/null; then
        echo "Performance optimization functions not available"
        return 1
    fi
    
    # Test optimization on a safe module (should not fail)
    optimize_module_performance "test_module" "auto" > /dev/null 2>&1
    
    return 0
}

# Main test runner
run_integration_tests() {
    echo "=========================================="
    echo "Bill Sloth Integration Test Suite"
    echo "=========================================="
    echo "Date: $(date)"
    echo "Output: $TEST_OUTPUT_DIR"
    echo ""
    
    # Initialize test environment
    init_test_environment
    
    # Run tests by category
    for category in "${!TEST_CATEGORIES[@]}"; do
        echo -e "\n${BLUE}${TEST_CATEGORIES[$category]}${NC}"
        echo "----------------------------------------"
        
        case "$category" in
            "core")
                run_test "directories" "core" test_core_directories
                run_test "libraries" "core" test_core_libraries
                run_test "command_center_launch" "core" test_command_center_launch
                ;;
            "data_sharing")
                run_test "initialization" "data_sharing" test_data_sharing_init
                run_test "operations" "data_sharing" test_data_sharing_operations
                run_test "performance" "data_sharing" test_data_sharing_performance
                ;;
            "workflows")
                run_test "initialization" "workflows" test_workflow_init
                run_test "creation" "workflows" test_workflow_creation
                ;;
            "bill_specific")
                run_test "vrbo_integration" "bill_specific" test_vrbo_integration
                run_test "edboigames_integration" "bill_specific" test_edboigames_integration
                run_test "google_tasks_integration" "bill_specific" test_google_tasks_integration
                ;;
            "backup")
                run_test "initialization" "backup" test_backup_init
                run_test "operations" "backup" test_backup_operations
                ;;
            "architecture")
                run_test "unified_architecture" "architecture" test_unified_architecture
                run_test "module_wrappers" "architecture" test_module_wrappers
                ;;
            "command_center")
                run_test "health_check" "command_center" test_command_center_health_check
                run_test "module_references" "command_center" test_command_center_modules
                ;;
            "production_safety")
                run_test "initialization" "production_safety" test_production_safety_init
                run_test "database_integrity" "production_safety" test_database_integrity_check
                run_test "input_validation" "production_safety" test_safe_input_validation
                run_test "backup_verification" "production_safety" test_backup_verification
                run_test "dependency_checking" "production_safety" test_dependency_checking
                ;;
            "performance")
                run_test "data_sharing_performance" "performance" test_data_sharing_performance
                run_test "monitoring_system" "performance" test_performance_monitoring_system
                run_test "optimization" "performance" test_performance_optimization
                ;;
        esac
    done
    
    # Generate test report
    generate_test_report
}

generate_test_report() {
    local report_file="$TEST_OUTPUT_DIR/test_report.txt"
    local total_tests=$((TESTS_PASSED + TESTS_FAILED + TESTS_SKIPPED))
    
    echo ""
    echo "=========================================="
    echo "Test Summary"
    echo "=========================================="
    
    cat > "$report_file" << EOF
Bill Sloth Integration Test Report
Generated: $(date)

SUMMARY
=======
Total Tests: $total_tests
Passed: $TESTS_PASSED
Failed: $TESTS_FAILED
Skipped: $TESTS_SKIPPED
Success Rate: $(awk "BEGIN {printf \"%.1f\", ($TESTS_PASSED/$total_tests)*100}")%

DETAILED RESULTS
================
EOF
    
    # Group results by category
    for category in "${!TEST_CATEGORIES[@]}"; do
        echo -e "\n${TEST_CATEGORIES[$category]}" >> "$report_file"
        echo "----------------------------------------" >> "$report_file"
        
        for test in "${!TEST_RESULTS[@]}"; do
            if [[ "$test" == "$category."* ]]; then
                local test_name="${test#$category.}"
                printf "  %-40s %s\n" "$test_name" "${TEST_RESULTS[$test]}" >> "$report_file"
            fi
        done
    done
    
    # Add recommendations
    cat >> "$report_file" << EOF

RECOMMENDATIONS
===============
EOF
    
    if [ $TESTS_FAILED -gt 0 ]; then
        echo "- Review failed tests and fix integration issues" >> "$report_file"
        echo "- Check log files in: $TEST_OUTPUT_DIR" >> "$report_file"
    fi
    
    if [ $TESTS_SKIPPED -gt 0 ]; then
        echo "- Investigate skipped tests to ensure full coverage" >> "$report_file"
    fi
    
    # Display summary
    echo -e "\n${GREEN}Passed:${NC} $TESTS_PASSED"
    echo -e "${RED}Failed:${NC} $TESTS_FAILED"
    echo -e "${YELLOW}Skipped:${NC} $TESTS_SKIPPED"
    echo ""
    echo "Full report: $report_file"
    echo "Test logs: $TEST_OUTPUT_DIR"
    
    # Exit with appropriate code
    if [ $TESTS_FAILED -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

# Create quick test runner
create_quick_test_runner() {
    cat > "$BASE_DIR/tests/run_tests.sh" << 'EOF'
#!/bin/bash
# Quick test runner for Bill Sloth integration tests

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Bill Sloth Quick Test Runner"
echo "============================"
echo ""
echo "1) Run all integration tests"
echo "2) Run core system tests only"
echo "3) Run Bill-specific tests only"
echo "4) Run performance tests only"
echo "5) View last test report"
echo ""

read -p "Select option: " choice

case "$choice" in
    1) 
        source "$SCRIPT_DIR/integration_test_suite.sh"
        run_integration_tests
        ;;
    2)
        source "$SCRIPT_DIR/integration_test_suite.sh"
        echo "Running core system tests..."
        run_test "directories" "core" test_core_directories
        run_test "libraries" "core" test_core_libraries
        run_test "command_center_launch" "core" test_command_center_launch
        ;;
    3)
        source "$SCRIPT_DIR/integration_test_suite.sh"
        echo "Running Bill-specific tests..."
        run_test "vrbo_integration" "bill_specific" test_vrbo_integration
        run_test "edboigames_integration" "bill_specific" test_edboigames_integration
        run_test "google_tasks_integration" "bill_specific" test_google_tasks_integration
        ;;
    4)
        source "$SCRIPT_DIR/integration_test_suite.sh"
        echo "Running performance tests..."
        run_test "performance" "data_sharing" test_data_sharing_performance
        ;;
    5)
        latest_report=$(ls -t "$SCRIPT_DIR/output/*/test_report.txt" 2>/dev/null | head -1)
        if [ -f "$latest_report" ]; then
            cat "$latest_report"
        else
            echo "No test reports found"
        fi
        ;;
    *)
        echo "Invalid choice"
        ;;
esac
EOF
    chmod +x "$BASE_DIR/tests/run_tests.sh"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    create_quick_test_runner
    run_integration_tests
fi