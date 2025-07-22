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
