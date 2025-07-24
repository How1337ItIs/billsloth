#!/bin/bash
# LLM_CAPABILITY: local_ok
# System Readiness Check - Comprehensive validation without external dependencies
# Validates system architecture, file integrity, and deployment readiness

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check tracking
CHECKS_TOTAL=0
CHECKS_PASSED=0
CHECKS_FAILED=0
WARNINGS=0
CRITICAL_ISSUES=()
WARNINGS_LIST=()

log_check() {
    local message="$1"
    echo -e "$message"
}

run_check() {
    local check_name="$1"
    local check_command="$2"
    local severity="${3:-ERROR}"
    
    ((CHECKS_TOTAL++))
    log_check "${BLUE}🔍 Checking: $check_name${NC}"
    
    if eval "$check_command" >/dev/null 2>&1; then
        ((CHECKS_PASSED++))
        log_check "${GREEN}✅ PASS: $check_name${NC}"
        return 0
    else
        if [ "$severity" = "WARNING" ]; then
            ((WARNINGS++))
            WARNINGS_LIST+=("$check_name")
            log_check "${YELLOW}⚠️  WARNING: $check_name${NC}"
        else
            ((CHECKS_FAILED++))
            CRITICAL_ISSUES+=("$check_name")
            log_check "${RED}❌ CRITICAL: $check_name${NC}"
        fi
        return 1
    fi
}

show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🎯 SYSTEM READINESS CHECK 🎯                            ║
║                                                                              ║
║  Comprehensive validation of Bill Sloth system architecture                 ║
║  File integrity, configuration, and deployment readiness                    ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

check_core_architecture() {
    log_check "${CYAN}🏗️ CHECKING CORE ARCHITECTURE${NC}"
    log_check "================================"
    
    # Essential directories
    run_check "Core directory: lib" "[ -d 'lib' ]"
    run_check "Core directory: modules" "[ -d 'modules' ]"
    run_check "Core directory: docker" "[ -d 'docker' ]"
    run_check "Core directory: config" "[ -d 'config' ]"
    run_check "Core directory: scripts" "[ -d 'scripts' ]"
    run_check "Core directory: docs" "[ -d 'docs' ]"
    
    # Essential files
    run_check "Main entry point: bill_command_center.sh" "[ -f 'bill_command_center.sh' ]"
    run_check "Onboarding script: onboard.sh" "[ -f 'onboard.sh' ]"
    run_check "Docker configuration: docker-compose.yml" "[ -f 'docker-compose.yml' ]"
    run_check "Main documentation: BILL_SLOTH_GIGA_DOC.md" "[ -f 'BILL_SLOTH_GIGA_DOC.md' ]"
    run_check "Project instructions: CLAUDE.md" "[ -f 'CLAUDE.md' ]"
    
    # Library files count
    local lib_count=$(find lib -name "*.sh" -type f 2>/dev/null | wc -l)
    run_check "Library files present ($lib_count found)" "[ $lib_count -gt 10 ]"
    
    # Module files count
    local module_count=$(find modules -name "*.sh" -type f 2>/dev/null | wc -l)
    run_check "Module files present ($module_count found)" "[ $module_count -gt 5 ]"
    
    log_check ""
}

check_docker_services() {
    log_check "${CYAN}🐳 CHECKING DOCKER SERVICES${NC}"
    log_check "==============================="
    
    # Docker service directories
    local docker_services=(
        "docker/vrbo-automation"
        "docker/guest-communication"
        "docker/analytics"
        "docker/service-health-monitor"
    )
    
    for service in "${docker_services[@]}"; do
        run_check "Service directory: $(basename $service)" "[ -d '$service' ]"
        if [ -d "$service" ]; then
            run_check "Dockerfile: $(basename $service)" "[ -f '$service/Dockerfile' ]"
            run_check "Requirements: $(basename $service)" "[ -f '$service/requirements.txt' ]"
            run_check "Main script: $(basename $service)" "[ -f '$service/main.py' ]"
        fi
    done
    
    log_check ""
}

check_business_systems() {
    log_check "${CYAN}💼 CHECKING BUSINESS SYSTEMS${NC}"
    log_check "==============================="
    
    # Business configuration
    run_check "Business optimization config" "[ -f 'config/business_optimization_config.json' ]"
    
    # Email automation
    run_check "Email automation library" "[ -f 'lib/advanced_email_automation.sh' ]"
    
    # Revenue analytics
    run_check "Revenue analytics service" "[ -f 'docker/revenue-analytics/main.py' ]"
    
    # Database initialization
    run_check "Database initialization SQL" "[ -d 'sql/init' ]"
    run_check "Business database schema" "[ -f 'sql/init/01_init_business_db.sql' ]"
    
    # Backup systems
    run_check "Enhanced backup management" "[ -f 'lib/backup_management_enhanced.sh' ]"
    
    # Monitoring systems
    run_check "System monitoring library" "[ -f 'lib/monitoring_system.sh' ]"
    
    log_check ""
}

check_voice_control() {
    log_check "${CYAN}🎤 CHECKING VOICE CONTROL${NC}"
    log_check "============================="
    
    # Voice control library
    run_check "Voice control library" "[ -f 'lib/voice_control.sh' ]"
    
    # Voice optimization scripts
    run_check "Voice control optimizer" "[ -f 'bin/voice-control-optimizer' ]"
    run_check "Voice mode switcher" "[ -f 'bin/voice-mode-switcher' ]"
    run_check "Voice test script" "[ -f 'bin/test-voice-control' ]"
    
    log_check ""
}

check_windows_setup() {
    log_check "${CYAN}🪟 CHECKING WINDOWS SETUP${NC}"
    log_check "============================="
    
    # Windows setup scripts
    run_check "Windows setup directory" "[ -d 'windows-setup' ]"
    run_check "ISO creation system" "[ -f 'windows-setup/MATURE_CUSTOM_ISO_SYSTEM.ps1' ]"
    run_check "Ubuntu installer prep" "[ -f 'windows-setup/ubuntu-installer-prep.ps1' ]"
    run_check "Disk partition manager" "[ -f 'windows-setup/disk-partition-manager.ps1' ]"
    run_check "Auto setup script" "[ -f 'windows-setup/bill-sloth-auto-setup.ps1' ]"
    
    log_check ""
}

check_script_syntax() {
    log_check "${CYAN}📝 CHECKING SCRIPT SYNTAX${NC}"
    log_check "============================="
    
    # Main scripts syntax
    if command -v bash >/dev/null 2>&1; then
        local main_scripts=(
            "bill_command_center.sh"
            "onboard.sh"
        )
        
        for script in "${main_scripts[@]}"; do
            if [ -f "$script" ]; then
                run_check "Script syntax: $script" "bash -n '$script'"
            fi
        done
        
        # Library scripts syntax (sample)
        local lib_scripts=(
            "lib/core.sh"
            "lib/notification.sh"
            "lib/error_handling.sh"
        )
        
        for script in "${lib_scripts[@]}"; do
            if [ -f "$script" ]; then
                run_check "Library syntax: $(basename $script)" "bash -n '$script'"
            fi
        done
        
        # Module scripts syntax (sample)
        local module_scripts=(
            "modules/business_partnerships_interactive.sh"
            "modules/streaming_setup_interactive.sh"
        )
        
        for script in "${module_scripts[@]}"; do
            if [ -f "$script" ]; then
                run_check "Module syntax: $(basename $script)" "bash -n '$script'"
            fi
        done
    else
        run_check "Bash interpreter available" "false" "WARNING"
    fi
    
    log_check ""
}

check_configuration_files() {
    log_check "${CYAN}⚙️ CHECKING CONFIGURATION FILES${NC}"
    log_check "================================="
    
    # JSON configuration validation (simplified)
    local json_files=(
        "config/business_optimization_config.json"
    )
    
    for json_file in "${json_files[@]}"; do
        if [ -f "$json_file" ]; then
            # Basic JSON structure check
            run_check "JSON structure: $(basename $json_file)" "grep -q '{' '$json_file' && grep -q '}' '$json_file'"
        fi
    done
    
    # Docker Compose YAML structure check
    if [ -f "docker-compose.yml" ]; then
        run_check "Docker Compose structure" "grep -q 'version:' 'docker-compose.yml' && grep -q 'services:' 'docker-compose.yml'"
        run_check "Docker Compose has services" "grep -A 10 'services:' 'docker-compose.yml' | grep -q '  [a-z]'"
    fi
    
    log_check ""
}

check_documentation() {
    log_check "${CYAN}📚 CHECKING DOCUMENTATION${NC}"
    log_check "============================="
    
    # Documentation files
    run_check "Main documentation exists" "[ -f 'BILL_SLOTH_GIGA_DOC.md' ]"
    run_check "Main documentation not empty" "[ -s 'BILL_SLOTH_GIGA_DOC.md' ]"
    
    run_check "Claude instructions exist" "[ -f 'CLAUDE.md' ]"
    run_check "Claude instructions not empty" "[ -s 'CLAUDE.md' ]"
    
    # README files
    local readme_count=$(find . -name "README.md" -type f 2>/dev/null | wc -l)
    run_check "README files present ($readme_count found)" "[ $readme_count -gt 0 ]" "WARNING"
    
    # Module documentation
    local doc_count=$(find docs -name "*.md" -type f 2>/dev/null | wc -l)
    run_check "Documentation files present ($doc_count found)" "[ $doc_count -gt 5 ]"
    
    log_check ""
}

check_data_persistence() {
    log_check "${CYAN}💾 CHECKING DATA PERSISTENCE${NC}"
    log_check "==============================="
    
    # Data persistence library
    run_check "Data persistence library" "[ -f 'lib/data_persistence.sh' ]"
    
    # Database schema
    run_check "SQL initialization directory" "[ -d 'sql/init' ]"
    
    # Backup management
    run_check "Backup management library" "[ -f 'lib/backup_management.sh' ]"
    run_check "Enhanced backup management" "[ -f 'lib/backup_management_enhanced.sh' ]"
    
    log_check ""
}

check_security_features() {
    log_check "${CYAN}🔒 CHECKING SECURITY FEATURES${NC}"
    log_check "==============================="
    
    # Security libraries
    run_check "Input sanitization library" "[ -f 'lib/input_sanitization.sh' ]"
    run_check "Error handling library" "[ -f 'lib/error_handling.sh' ]"
    
    # Kill switch
    run_check "Kill switch mechanism" "[ -f 'lib/kill_switch.sh' ]"
    
    # Check for sensitive files (should not exist)
    run_check "No exposed secrets" "! find . -name '*.key' -o -name '*.pem' -o -name '.env' | grep -q '.'"
    
    log_check ""
}

check_integration_capabilities() {
    log_check "${CYAN}🔗 CHECKING INTEGRATION CAPABILITIES${NC}"
    log_check "======================================"
    
    # Cross-module integration
    run_check "Cross-module integration library" "[ -f 'lib/cross_module_integration.sh' ]"
    
    # Data sharing capabilities
    run_check "Data sharing library" "[ -f 'lib/data_sharing.sh' ]"
    
    # Adaptive learning
    run_check "Adaptive learning library" "[ -f 'lib/adaptive_learning.sh' ]"
    
    # Module health checker
    run_check "Module health checker" "[ -f 'lib/module_health_checker.sh' ]"
    
    log_check ""
}

check_testing_infrastructure() {
    log_check "${CYAN}🧪 CHECKING TESTING INFRASTRUCTURE${NC}"
    log_check "==================================="
    
    # Test scripts
    run_check "Integration test suite" "[ -f 'scripts/integration_test_suite.sh' ]"
    run_check "Docker validation script" "[ -f 'scripts/docker_validation.sh' ]"
    run_check "System readiness check" "[ -f 'scripts/system_readiness_check.sh' ]"
    
    # Test directory
    run_check "Tests directory" "[ -d 'tests' ]" "WARNING"
    
    log_check ""
}

calculate_readiness_score() {
    local total_possible=$((CHECKS_TOTAL + WARNINGS))
    local success_score=$((CHECKS_PASSED * 100 / CHECKS_TOTAL))
    local warning_penalty=$((WARNINGS * 5))
    local final_score=$((success_score - warning_penalty))
    
    # Ensure score doesn't go below 0
    if [ $final_score -lt 0 ]; then
        final_score=0
    fi
    
    echo $final_score
}

generate_readiness_report() {
    log_check "${PURPLE}📊 GENERATING READINESS REPORT${NC}"
    log_check "================================"
    
    local readiness_score=$(calculate_readiness_score)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Determine readiness status
    local readiness_status
    local status_color
    local recommendations
    
    if [ $readiness_score -ge 95 ] && [ $CHECKS_FAILED -eq 0 ]; then
        readiness_status="PRODUCTION READY"
        status_color="$GREEN"
        recommendations="System is ready for production deployment"
    elif [ $readiness_score -ge 85 ] && [ $CHECKS_FAILED -le 2 ]; then
        readiness_status="MOSTLY READY"
        status_color="$YELLOW"
        recommendations="Address critical issues before production deployment"
    elif [ $readiness_score -ge 70 ]; then
        readiness_status="NEEDS WORK"
        status_color="$YELLOW"
        recommendations="Significant improvements needed before deployment"
    else
        readiness_status="NOT READY"
        status_color="$RED"
        recommendations="Major issues must be resolved before deployment"
    fi
    
    echo ""
    log_check "${PURPLE}════════════════════════════════${NC}"
    log_check "${PURPLE}    SYSTEM READINESS SUMMARY${NC}"
    log_check "${PURPLE}════════════════════════════════${NC}"
    log_check "Generated: ${BLUE}$timestamp${NC}"
    log_check ""
    log_check "Total Checks: ${BLUE}$CHECKS_TOTAL${NC}"
    log_check "Passed: ${GREEN}$CHECKS_PASSED${NC}"
    log_check "Critical Issues: ${RED}$CHECKS_FAILED${NC}"
    log_check "Warnings: ${YELLOW}$WARNINGS${NC}"
    log_check ""
    log_check "Readiness Score: ${BLUE}$readiness_score/100${NC}"
    log_check "Status: ${status_color}$readiness_status${NC}"
    log_check ""
    
    if [ ${#CRITICAL_ISSUES[@]} -gt 0 ]; then
        log_check "${RED}Critical Issues:${NC}"
        for issue in "${CRITICAL_ISSUES[@]}"; do
            log_check "${RED}  ❌ $issue${NC}"
        done
        log_check ""
    fi
    
    if [ ${#WARNINGS_LIST[@]} -gt 0 ]; then
        log_check "${YELLOW}Warnings:${NC}"
        for warning in "${WARNINGS_LIST[@]}"; do
            log_check "${YELLOW}  ⚠️  $warning${NC}"
        done
        log_check ""
    fi
    
    log_check "${CYAN}Component Status:${NC}"
    log_check "• Core Architecture: $([ -f 'bill_command_center.sh' ] && echo '✅' || echo '❌')"
    log_check "• Docker Services: $([ -d 'docker' ] && echo '✅' || echo '❌')"
    log_check "• Business Systems: $([ -f 'lib/advanced_email_automation.sh' ] && echo '✅' || echo '❌')"
    log_check "• Voice Control: $([ -f 'lib/voice_control.sh' ] && echo '✅' || echo '❌')"
    log_check "• Windows Setup: $([ -f 'windows-setup/MATURE_CUSTOM_ISO_SYSTEM.ps1' ] && echo '✅' || echo '❌')"
    log_check "• Documentation: $([ -f 'BILL_SLOTH_GIGA_DOC.md' ] && echo '✅' || echo '❌')"
    log_check ""
    
    log_check "${CYAN}Recommendations:${NC}"
    log_check "$recommendations"
    
    if [ $CHECKS_FAILED -gt 0 ]; then
        log_check ""
        log_check "${RED}Next Steps:${NC}"
        log_check "1. Address all critical issues listed above"
        log_check "2. Re-run this readiness check after fixes"
        log_check "3. Consider environment-specific testing"
        log_check "4. Validate with actual deployment when ready"
    fi
    
    return $CHECKS_FAILED
}

main() {
    show_banner
    log_check "Starting comprehensive system readiness assessment..."
    log_check ""
    
    # Run all checks
    check_core_architecture
    check_docker_services
    check_business_systems
    check_voice_control
    check_windows_setup
    check_script_syntax
    check_configuration_files
    check_documentation
    check_data_persistence
    check_security_features
    check_integration_capabilities
    check_testing_infrastructure
    
    # Generate final report
    generate_readiness_report
    
    # Return appropriate exit code
    if [ $CHECKS_FAILED -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"