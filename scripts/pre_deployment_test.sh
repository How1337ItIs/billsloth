#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Pre-Deployment Test Suite
# Tests core functionality without external dependencies

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Test tracking
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
SKIPPED_TESTS=0
TEST_RESULTS=()

log_test() {
    local message="$1"
    echo -e "$message"
}

run_test() {
    local test_name="$1"
    local test_command="$2"
    local required="${3:-true}"
    local description="${4:-}"
    
    ((TOTAL_TESTS++))
    log_test "${BLUE}🧪 Testing: $test_name${NC}"
    
    if [ -n "$description" ]; then
        log_test "   $description"
    fi
    
    # Run the test
    local test_output
    local test_exit_code
    
    if test_output=$(eval "$test_command" 2>&1); then
        test_exit_code=0
    else
        test_exit_code=$?
    fi
    
    if [ $test_exit_code -eq 0 ]; then
        ((PASSED_TESTS++))
        log_test "${GREEN}✅ PASS: $test_name${NC}"
        TEST_RESULTS+=("PASS: $test_name")
        return 0
    else
        if [ "$required" = "true" ]; then
            ((FAILED_TESTS++))
            log_test "${RED}❌ FAIL: $test_name${NC}"
            if [ -n "$test_output" ]; then
                log_test "${RED}   Error: $test_output${NC}"
            fi
            TEST_RESULTS+=("FAIL: $test_name - $test_output")
        else
            ((SKIPPED_TESTS++))
            log_test "${YELLOW}⏭️  SKIP: $test_name (optional)${NC}"
            TEST_RESULTS+=("SKIP: $test_name - $test_output")
        fi
        return 1
    fi
}

test_bash_syntax() {
    log_test "${CYAN}📝 TESTING SCRIPT SYNTAX${NC}"
    log_test "========================="
    
    # Find all bash scripts in the project
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test main scripts
    if [ -f "$bill_sloth_dir/bill_command_center.sh" ]; then
        run_test "Main command center syntax" "bash -n '$bill_sloth_dir/bill_command_center.sh'" true "Validate bill_command_center.sh"
    fi
    
    if [ -f "$bill_sloth_dir/onboard.sh" ]; then
        run_test "Onboarding script syntax" "bash -n '$bill_sloth_dir/onboard.sh'" true "Validate onboard.sh"
    fi
    
    # Test library scripts
    if [ -d "$bill_sloth_dir/lib" ]; then
        local lib_scripts=(
            "error_handling.sh"
            "notification.sh"
            "data_persistence.sh"
            "local_llm_integration.sh"
            "offline_voice_processing.sh"
            "performance_optimizer.sh"
            "predictive_analytics.sh"
        )
        
        for script in "${lib_scripts[@]}"; do
            if [ -f "$bill_sloth_dir/lib/$script" ]; then
                run_test "Library $script syntax" "bash -n '$bill_sloth_dir/lib/$script'" true "Validate lib/$script"
            fi
        done
    fi
    
    # Test module scripts (sample)
    if [ -d "$bill_sloth_dir/modules" ]; then
        local module_count=$(find "$bill_sloth_dir/modules" -name "*.sh" -type f | wc -l)
        run_test "Module scripts exist" "[ $module_count -gt 5 ]" true "Found $module_count module scripts"
        
        # Test syntax of a few key modules
        local key_modules=(
            "business_partnerships_interactive.sh"
            "streaming_setup_interactive.sh"
            "network_monitoring_interactive.sh"
        )
        
        for module in "${key_modules[@]}"; do
            if [ -f "$bill_sloth_dir/modules/$module" ]; then
                run_test "Module $module syntax" "bash -n '$bill_sloth_dir/modules/$module'" false "Validate modules/$module"
            fi
        done
    fi
    
    log_test ""
}

test_python_compatibility() {
    log_test "${CYAN}🐍 TESTING PYTHON COMPATIBILITY${NC}"
    log_test "==============================="
    
    # Test Python availability
    run_test "Python 3 available" "command -v python3" true "Check if python3 command exists"
    
    if command -v python3 >/dev/null 2>&1; then
        # Test Python version
        run_test "Python version compatible" "python3 --version | grep -E 'Python 3\\.(8|9|10|11|12)'" true "Python 3.8+ required"
        
        # Test core modules
        run_test "Python json module" "python3 -c 'import json; print(\"JSON OK\")'" true "Test JSON functionality"
        run_test "Python sqlite3 module" "python3 -c 'import sqlite3; print(\"SQLite OK\")'" true "Test SQLite functionality"
        run_test "Python subprocess module" "python3 -c 'import subprocess; print(\"Subprocess OK\")'" true "Test subprocess functionality"
        
        # Test optional modules
        run_test "Python requests module" "python3 -c 'import requests; print(\"Requests OK\")'" false "HTTP functionality"
        run_test "Python pandas module" "python3 -c 'import pandas; print(\"Pandas OK\")'" false "Data analysis functionality"
        run_test "Python numpy module" "python3 -c 'import numpy; print(\"NumPy OK\")'" false "Numerical computing"
    fi
    
    # Test embedded Python scripts
    local analytics_dir="${1:-$(pwd)}/lib"
    if [ -f "$analytics_dir/predictive_analytics.sh" ]; then
        # Extract and test Python code from shell scripts (this is a basic check)
        run_test "Analytics Python code structure" "grep -q 'class BusinessIntelligenceEngine' '$analytics_dir/predictive_analytics.sh'" false "Check analytics Python structure"
    fi
    
    log_test ""
}

test_file_structure() {
    log_test "${CYAN}📁 TESTING FILE STRUCTURE${NC}"
    log_test "==========================="
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test core directories
    run_test "Root directory exists" "[ -d '$bill_sloth_dir' ]" true "Bill Sloth project directory"
    run_test "lib directory exists" "[ -d '$bill_sloth_dir/lib' ]" true "Core libraries directory"
    run_test "modules directory exists" "[ -d '$bill_sloth_dir/modules' ]" true "Interactive modules directory"
    run_test "scripts directory exists" "[ -d '$bill_sloth_dir/scripts' ]" true "Utility scripts directory"
    run_test "config directory exists" "[ -d '$bill_sloth_dir/config' ]" true "Configuration directory"
    run_test "docker directory exists" "[ -d '$bill_sloth_dir/docker' ]" true "Docker services directory"
    
    # Test core files
    run_test "Main entry point exists" "[ -f '$bill_sloth_dir/bill_command_center.sh' ]" true "Main application script"
    run_test "Onboarding script exists" "[ -f '$bill_sloth_dir/onboard.sh' ]" true "User onboarding script"
    run_test "Docker compose config exists" "[ -f '$bill_sloth_dir/docker-compose.yml' ]" true "Docker services configuration"
    run_test "Main documentation exists" "[ -f '$bill_sloth_dir/BILL_SLOTH_GIGA_DOC.md' ]" true "Project documentation"
    run_test "Claude instructions exist" "[ -f '$bill_sloth_dir/CLAUDE.md' ]" true "Development instructions"
    
    # Test executable permissions
    run_test "Main script executable" "[ -x '$bill_sloth_dir/bill_command_center.sh' ]" true "Execute permission on main script"
    run_test "Onboarding script executable" "[ -x '$bill_sloth_dir/onboard.sh' ]" true "Execute permission on onboarding"
    
    # Test library files count
    local lib_count=$(find "$bill_sloth_dir/lib" -name "*.sh" -type f 2>/dev/null | wc -l)
    run_test "Adequate library files" "[ $lib_count -gt 10 ]" true "Found $lib_count library files"
    
    # Test module files count
    local module_count=$(find "$bill_sloth_dir/modules" -name "*.sh" -type f 2>/dev/null | wc -l)
    run_test "Adequate module files" "[ $module_count -gt 30 ]" true "Found $module_count module files"
    
    log_test ""
}

test_configuration_files() {
    log_test "${CYAN}⚙️ TESTING CONFIGURATION FILES${NC}"
    log_test "==============================="
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test JSON configuration files
    if [ -f "$bill_sloth_dir/config/business_optimization_config.json" ]; then
        run_test "Business config JSON valid" "python3 -c 'import json; json.load(open(\"$bill_sloth_dir/config/business_optimization_config.json\"))'" true "Validate business configuration"
    fi
    
    # Test Docker Compose file
    if [ -f "$bill_sloth_dir/docker-compose.yml" ]; then
        run_test "Docker Compose YAML structure" "grep -q 'version:' '$bill_sloth_dir/docker-compose.yml' && grep -q 'services:' '$bill_sloth_dir/docker-compose.yml'" true "Basic YAML structure check"
        run_test "Docker services defined" "grep -A 10 'services:' '$bill_sloth_dir/docker-compose.yml' | grep -q '  [a-z]'" true "Services section populated"
    fi
    
    # Test SQL initialization files
    if [ -d "$bill_sloth_dir/sql/init" ]; then
        run_test "SQL init directory exists" "[ -d '$bill_sloth_dir/sql/init' ]" true "Database initialization directory"
        run_test "Business database schema exists" "[ -f '$bill_sloth_dir/sql/init/01_init_business_db.sql' ]" true "Database schema file"
        
        if [ -f "$bill_sloth_dir/sql/init/01_init_business_db.sql" ]; then
            run_test "SQL syntax basic check" "grep -q 'CREATE TABLE' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "SQL contains table definitions"
        fi
    fi
    
    log_test ""
}

test_docker_configuration() {
    log_test "${CYAN}🐳 TESTING DOCKER CONFIGURATION${NC}"
    log_test "==============================="
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test Docker service directories
    local docker_services=(
        "vrbo-automation"
        "guest-communication"
        "analytics"
        "service-health-monitor"
    )
    
    for service in "${docker_services[@]}"; do
        if [ -d "$bill_sloth_dir/docker/$service" ]; then
            run_test "Docker service $service directory" "[ -d '$bill_sloth_dir/docker/$service' ]" true "Service directory structure"
            run_test "Docker service $service Dockerfile" "[ -f '$bill_sloth_dir/docker/$service/Dockerfile' ]" true "Service container definition"
            run_test "Docker service $service requirements" "[ -f '$bill_sloth_dir/docker/$service/requirements.txt' ]" true "Python dependencies"
            run_test "Docker service $service main script" "[ -f '$bill_sloth_dir/docker/$service/main.py' ]" true "Service implementation"
            
            # Test Dockerfile syntax (basic)
            if [ -f "$bill_sloth_dir/docker/$service/Dockerfile" ]; then
                run_test "Dockerfile $service FROM statement" "grep -q '^FROM' '$bill_sloth_dir/docker/$service/Dockerfile'" true "Valid Dockerfile structure"
            fi
            
            # Test Python requirements format
            if [ -f "$bill_sloth_dir/docker/$service/requirements.txt" ]; then
                run_test "Requirements $service format" "grep -E '^[a-zA-Z0-9_-]+([><=]=?[0-9.]+)?\$' '$bill_sloth_dir/docker/$service/requirements.txt'" false "Valid pip requirements format"
            fi
        fi
    done
    
    log_test ""
}

test_script_dependencies() {
    log_test "${CYAN}🔗 TESTING SCRIPT DEPENDENCIES${NC}"
    log_test "==============================="
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test if scripts properly source their dependencies
    if [ -f "$bill_sloth_dir/lib/local_llm_integration.sh" ]; then
        run_test "LLM integration sources error handling" "grep -q 'source.*error_handling.sh' '$bill_sloth_dir/lib/local_llm_integration.sh'" true "Check dependency sourcing"
    fi
    
    if [ -f "$bill_sloth_dir/lib/offline_voice_processing.sh" ]; then
        run_test "Voice processing sources notification" "grep -q 'source.*notification.sh' '$bill_sloth_dir/lib/offline_voice_processing.sh'" true "Check dependency sourcing"
    fi
    
    # Test for circular dependencies (basic check)
    run_test "No obvious circular dependencies" "! find '$bill_sloth_dir/lib' -name '*.sh' -exec grep -l 'source.*lib/' {} \\; | xargs grep -l 'source.*lib/' | head -1" false "Basic circular dependency check"
    
    log_test ""
}

test_generated_scripts() {
    log_test "${CYAN}🚀 TESTING GENERATED INSTALLATION SCRIPTS${NC}"
    log_test "==========================================="
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test dependency validation script
    if [ -f "$bill_sloth_dir/scripts/linux_dependency_validator.sh" ]; then
        run_test "Dependency validator syntax" "bash -n '$bill_sloth_dir/scripts/linux_dependency_validator.sh'" true "Validate dependency checker"
        run_test "Dependency validator functions" "grep -q 'detect_linux_distribution' '$bill_sloth_dir/scripts/linux_dependency_validator.sh'" true "Check key functions"
    fi
    
    if [ -f "$bill_sloth_dir/scripts/dependency_installer.sh" ]; then
        run_test "Dependency installer syntax" "bash -n '$bill_sloth_dir/scripts/dependency_installer.sh'" true "Validate dependency installer"
        run_test "Dependency installer safety" "grep -q 'set -euo pipefail' '$bill_sloth_dir/scripts/dependency_installer.sh'" true "Check safety settings"
    fi
    
    if [ -f "$bill_sloth_dir/scripts/deployment_readiness_check.sh" ]; then
        run_test "Deployment checker syntax" "bash -n '$bill_sloth_dir/scripts/deployment_readiness_check.sh'" true "Validate deployment checker"
    fi
    
    # Test setup scripts
    if [ -f "$bill_sloth_dir/bin/setup-local-ai" ]; then
        run_test "AI setup script syntax" "bash -n '$bill_sloth_dir/bin/setup-local-ai'" true "Validate AI setup script"
    fi
    
    if [ -f "$bill_sloth_dir/bin/voice-independence" ]; then
        run_test "Voice independence script syntax" "bash -n '$bill_sloth_dir/bin/voice-independence'" true "Validate voice setup script"
    fi
    
    log_test ""
}

test_data_structures() {
    log_test "${CYAN}🗄️  TESTING DATA STRUCTURES${NC}"
    log_test "==========================="
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    # Test database schema if available
    if [ -f "$bill_sloth_dir/sql/init/01_init_business_db.sql" ]; then
        # Test for essential tables
        run_test "Database has properties table" "grep -q 'CREATE TABLE.*properties' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "VRBO properties table"
        run_test "Database has bookings table" "grep -q 'CREATE TABLE.*bookings' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "Booking records table"
        run_test "Database has partnerships table" "grep -q 'CREATE TABLE.*partnerships' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "Business partnerships table"
        run_test "Database has revenue_records table" "grep -q 'CREATE TABLE.*revenue_records' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "Revenue tracking table"
        
        # Test for indexes
        run_test "Database has performance indexes" "grep -q 'CREATE INDEX' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "Performance optimization indexes"
        
        # Test for views
        run_test "Database has summary views" "grep -q 'CREATE VIEW' '$bill_sloth_dir/sql/init/01_init_business_db.sql'" true "Business intelligence views"
    fi
    
    log_test ""
}

create_compatibility_report() {
    log_test "${PURPLE}📊 GENERATING COMPATIBILITY REPORT${NC}"
    log_test "===================================="
    
    local report_file="/tmp/bill_sloth_compatibility_report.txt"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    
    cat > "$report_file" << EOF
Bill Sloth Pre-Deployment Compatibility Report
===============================================
Generated: $timestamp
Test Environment: $(uname -s) $(uname -r) $(uname -m)

Test Summary:
- Total tests: $TOTAL_TESTS
- Passed: $PASSED_TESTS
- Failed: $FAILED_TESTS
- Skipped: $SKIPPED_TESTS
- Success rate: $success_rate%

Detailed Results:
EOF
    
    for result in "${TEST_RESULTS[@]}"; do
        echo "  $result" >> "$report_file"
    done
    
    cat >> "$report_file" << EOF

Compatibility Assessment:
EOF
    
    if [ $success_rate -ge 90 ]; then
        echo "✅ EXCELLENT: System is highly compatible with Bill Sloth" >> "$report_file"
    elif [ $success_rate -ge 75 ]; then
        echo "✅ GOOD: System is compatible with minor issues" >> "$report_file"
    elif [ $success_rate -ge 60 ]; then
        echo "⚠️  WARNING: System has compatibility issues that should be addressed" >> "$report_file"
    else
        echo "❌ CRITICAL: System has major compatibility issues" >> "$report_file"
    fi
    
    cat >> "$report_file" << EOF

Recommendations:
- Run dependency installer if Python/system tools failed
- Check file permissions if executable tests failed
- Validate JSON/YAML files if configuration tests failed
- Review script syntax if bash validation failed

Next Steps:
1. Address any critical failures
2. Run: ./scripts/linux_dependency_validator.sh
3. Run: ./scripts/dependency_installer.sh (if needed)
4. Run: ./scripts/deployment_readiness_check.sh
EOF
    
    log_test "Compatibility report saved: $report_file"
}

generate_test_summary() {
    local success_rate=$((PASSED_TESTS * 100 / TOTAL_TESTS))
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo ""
    log_test "${PURPLE}═══════════════════════════════════════${NC}"
    log_test "${PURPLE}    PRE-DEPLOYMENT TEST SUMMARY${NC}"
    log_test "${PURPLE}═══════════════════════════════════════${NC}"
    log_test "Test Date: ${BLUE}$timestamp${NC}"
    log_test ""
    log_test "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
    log_test "Passed: ${GREEN}$PASSED_TESTS${NC}"
    log_test "Failed: ${RED}$FAILED_TESTS${NC}"
    log_test "Skipped: ${YELLOW}$SKIPPED_TESTS${NC}"
    log_test "Success Rate: ${BLUE}$success_rate%${NC}"
    log_test ""
    
    if [ $success_rate -ge 90 ]; then
        if command -v show_celebration >/dev/null 2>&1; then
            show_celebration
        fi
        log_test "${GREEN}🎉 EXCELLENT COMPATIBILITY${NC}"
        log_test "Bill Sloth is ready for deployment on Linux systems."
    elif [ $success_rate -ge 75 ]; then
        log_test "${GREEN}✅ GOOD COMPATIBILITY${NC}"
        log_test "Bill Sloth should work well with minor adjustments."
    elif [ $success_rate -ge 60 ]; then
        log_test "${YELLOW}⚠️  COMPATIBILITY ISSUES${NC}"
        log_test "Address failing tests before deployment."
    else
        log_test "${RED}❌ MAJOR COMPATIBILITY ISSUES${NC}"
        log_test "Significant problems must be resolved."
    fi
    
    log_test ""
    log_test "${CYAN}Next Steps:${NC}"
    log_test "1. Review compatibility report for specific issues"
    log_test "2. Run dependency validation and installation scripts"
    log_test "3. Re-run tests after addressing failures"
    log_test "4. Proceed to deployment readiness check"
    
    return $FAILED_TESTS
}

main() {
    # Source aesthetic functions if available
    if [ -f "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh" ]; then
        source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh"
        show_module_banner "BILL SLOTH PRE-DEPLOYMENT TESTS" "Testing without external dependencies" "🧪"
    else
        echo -e "${CYAN}"
        cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                   🧪 BILL SLOTH PRE-DEPLOYMENT TESTS 🧪                     ║
║                                                                              ║
║           Comprehensive testing without external dependencies                ║
║              Validates core functionality and compatibility                  ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
    fi
    
    local bill_sloth_dir="${1:-$(pwd)}"
    
    log_test "Starting pre-deployment compatibility tests..."
    log_test "Testing Bill Sloth directory: $bill_sloth_dir"
    log_test "Test environment: $(uname -s) $(uname -r) $(uname -m)"
    log_test ""
    
    # Run all test suites
    test_bash_syntax "$bill_sloth_dir"
    test_python_compatibility "$bill_sloth_dir"
    test_file_structure "$bill_sloth_dir"
    test_configuration_files "$bill_sloth_dir"
    test_docker_configuration "$bill_sloth_dir"
    test_script_dependencies "$bill_sloth_dir"
    test_generated_scripts "$bill_sloth_dir"
    test_data_structures "$bill_sloth_dir"
    
    # Generate outputs
    create_compatibility_report
    generate_test_summary
    
    # Return exit code based on test results
    if [ $FAILED_TESTS -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"