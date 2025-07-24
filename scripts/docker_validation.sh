#!/bin/bash
# LLM_CAPABILITY: local_ok
# Docker Environment Validation Script
# Validates Docker Compose configuration and service readiness

source "$(dirname "$0")/../lib/include_loader.sh"
load_includes "core" "notification" "error_handling"

# Configuration
VALIDATION_LOG="$HOME/.bill-sloth/logs/docker_validation_$(date '+%Y%m%d_%H%M%S').log"
DOCKER_COMPOSE_FILE="docker-compose.yml"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Validation tracking
VALIDATIONS_TOTAL=0
VALIDATIONS_PASSED=0
VALIDATIONS_FAILED=0
VALIDATION_ISSUES=()

log_validation() {
    local message="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $message" >> "$VALIDATION_LOG"
    echo -e "$message"
}

validate_item() {
    local validation_name="$1"
    local validation_command="$2"
    local error_message="$3"
    
    ((VALIDATIONS_TOTAL++))
    log_validation "${BLUE}🔍 Validating: $validation_name${NC}"
    
    if eval "$validation_command" >/dev/null 2>&1; then
        ((VALIDATIONS_PASSED++))
        log_validation "${GREEN}✅ VALID: $validation_name${NC}"
        return 0
    else
        ((VALIDATIONS_FAILED++))
        VALIDATION_ISSUES+=("$validation_name: $error_message")
        log_validation "${RED}❌ INVALID: $validation_name - $error_message${NC}"
        return 1
    fi
}

show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════════╗
║                     🐳 DOCKER VALIDATION SUITE 🐳                             ║
║                                                                                  ║
║  Comprehensive validation of Docker Compose configuration                       ║
║  Service definitions, networking, volumes, and deployment readiness             ║
╚══════════════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

validate_prerequisites() {
    log_validation "${CYAN}🔧 VALIDATING PREREQUISITES${NC}"
    log_validation "================================"
    
    # Docker availability
    validate_item "Docker daemon" \
        "docker info" \
        "Docker daemon not running or not installed"
    
    # Docker Compose availability
    validate_item "Docker Compose" \
        "docker-compose --version" \
        "Docker Compose not installed or not in PATH"
    
    # Docker Compose file exists
    validate_item "Docker Compose file" \
        "[ -f '$DOCKER_COMPOSE_FILE' ]" \
        "docker-compose.yml file not found"
    
    # User permissions
    validate_item "Docker permissions" \
        "docker ps" \
        "Current user cannot access Docker daemon"
    
    log_validation ""
}

validate_compose_syntax() {
    log_validation "${CYAN}📝 VALIDATING COMPOSE SYNTAX${NC}"
    log_validation "================================"
    
    # YAML syntax validation
    validate_item "YAML syntax" \
        "docker-compose config --quiet" \
        "YAML syntax errors in docker-compose.yml"
    
    # Service validation
    validate_item "Service definitions" \
        "docker-compose config --services | wc -l | grep -q '[1-9]'" \
        "No services defined in docker-compose.yml"
    
    # Network validation
    validate_item "Network configuration" \
        "docker-compose config | grep -q 'networks:'" \
        "No networks defined in docker-compose.yml"
    
    # Volume validation
    validate_item "Volume configuration" \
        "docker-compose config | grep -q 'volumes:'" \
        "No volumes defined in docker-compose.yml"
    
    log_validation ""
}

validate_service_configurations() {
    log_validation "${CYAN}🛠️ VALIDATING SERVICE CONFIGURATIONS${NC}"
    log_validation "======================================="
    
    # Get list of services
    local services=$(docker-compose config --services 2>/dev/null)
    
    if [ -z "$services" ]; then
        log_validation "${RED}❌ No services found in docker-compose.yml${NC}"
        return 1
    fi
    
    while IFS= read -r service; do
        log_validation "${BLUE}Validating service: $service${NC}"
        
        # Check if service has build context or image
        validate_item "$service: Build/Image definition" \
            "docker-compose config | grep -A 20 '$service:' | grep -q -E '(image:|build:)'" \
            "Service $service has no image or build definition"
        
        # Check restart policy
        validate_item "$service: Restart policy" \
            "docker-compose config | grep -A 10 '$service:' | grep -q 'restart:'" \
            "Service $service has no restart policy defined"
        
        # Check for environment variables (if applicable)
        if docker-compose config | grep -A 20 "$service:" | grep -q "environment:"; then
            validate_item "$service: Environment variables" \
                "docker-compose config | grep -A 20 '$service:' | grep -A 5 'environment:' | grep -q '.'" \
                "Service $service has empty environment section"
        fi
        
        # Check for volume mounts (if applicable)
        if docker-compose config | grep -A 20 "$service:" | grep -q "volumes:"; then
            validate_item "$service: Volume mounts" \
                "docker-compose config | grep -A 20 '$service:' | grep -A 5 'volumes:' | grep -q '.'" \
                "Service $service has empty volumes section"
        fi
        
    done <<< "$services"
    
    log_validation ""
}

validate_network_configuration() {
    log_validation "${CYAN}🌐 VALIDATING NETWORK CONFIGURATION${NC}"
    log_validation "====================================="
    
    # Check for custom networks
    validate_item "Custom networks defined" \
        "docker-compose config | grep -A 5 'networks:' | grep -q 'bill-network'" \
        "No custom networks defined"
    
    # Check services are connected to networks
    validate_item "Services connected to networks" \
        "docker-compose config | grep -c 'bill-network' | grep -q '[2-9]'" \
        "Services not properly connected to networks"
    
    # Check for port conflicts
    local ports=$(docker-compose config | grep -o '[0-9]*:[0-9]*' | cut -d: -f1 | sort)
    local unique_ports=$(echo "$ports" | sort -u)
    
    if [ "$(echo "$ports" | wc -l)" -ne "$(echo "$unique_ports" | wc -l)" ]; then
        ((VALIDATIONS_FAILED++))
        VALIDATION_ISSUES+=("Port conflicts: Duplicate port mappings found")
        log_validation "${RED}❌ INVALID: Port conflicts detected${NC}"
    else
        ((VALIDATIONS_PASSED++))
        log_validation "${GREEN}✅ VALID: No port conflicts detected${NC}"
    fi
    ((VALIDATIONS_TOTAL++))
    
    log_validation ""
}

validate_volume_configuration() {
    log_validation "${CYAN}💾 VALIDATING VOLUME CONFIGURATION${NC}"
    log_validation "===================================="
    
    # Check for named volumes
    validate_item "Named volumes defined" \
        "docker-compose config | grep -A 10 '^volumes:' | grep -q '.'" \
        "No named volumes defined"
    
    # Check for volume usage in services
    validate_item "Services using volumes" \
        "docker-compose config | grep -c 'volumes:' | grep -q '[2-9]'" \
        "Services not properly using volumes"
    
    # Check for data persistence paths
    local data_dirs=("./data" "./logs" "./config")
    for dir in "${data_dirs[@]}"; do
        validate_item "Data directory: $dir" \
            "docker-compose config | grep -q '$dir'" \
            "Data directory $dir not mounted in any service"
    done
    
    log_validation ""
}

validate_service_dependencies() {
    log_validation "${CYAN}🔗 VALIDATING SERVICE DEPENDENCIES${NC}"
    log_validation "===================================="
    
    # Check for depends_on declarations
    validate_item "Service dependencies defined" \
        "docker-compose config | grep -q 'depends_on:'" \
        "No service dependencies defined"
    
    # Check database dependencies
    validate_item "Database dependencies" \
        "docker-compose config | grep -A 5 'depends_on:' | grep -q 'postgres'" \
        "Services not properly depending on database"
    
    # Check Redis dependencies
    validate_item "Redis dependencies" \
        "docker-compose config | grep -A 5 'depends_on:' | grep -q 'redis'" \
        "Services not properly depending on Redis"
    
    log_validation ""
}

validate_security_configuration() {
    log_validation "${CYAN}🔒 VALIDATING SECURITY CONFIGURATION${NC}"
    log_validation "======================================"
    
    # Check for default passwords
    if docker-compose config | grep -q "password.*admin"; then
        ((VALIDATIONS_FAILED++))
        VALIDATION_ISSUES+=("Security: Default passwords detected")
        log_validation "${RED}❌ INVALID: Default passwords found in configuration${NC}"
    else
        ((VALIDATIONS_PASSED++))
        log_validation "${GREEN}✅ VALID: No obvious default passwords${NC}"
    fi
    ((VALIDATIONS_TOTAL++))
    
    # Check for exposed sensitive ports
    local sensitive_ports=("22" "3306" "5432")
    for port in "${sensitive_ports[@]}"; do
        if docker-compose config | grep -q "\"$port:"; then
            log_validation "${YELLOW}⚠️  WARNING: Sensitive port $port is exposed${NC}"
        fi
    done
    
    # Check for privileged containers
    if docker-compose config | grep -q "privileged: true"; then
        log_validation "${YELLOW}⚠️  WARNING: Privileged containers detected${NC}"
    fi
    
    log_validation ""
}

validate_build_contexts() {
    log_validation "${CYAN}🏗️ VALIDATING BUILD CONTEXTS${NC}"
    log_validation "==============================="
    
    # Find services with build contexts
    local build_services=$(docker-compose config | grep -B 5 "build:" | grep "^  [a-z]" | cut -d: -f1 | sed 's/^  //')
    
    while IFS= read -r service; do
        if [ -n "$service" ]; then
            local build_context=$(docker-compose config | grep -A 5 "$service:" | grep "context:" | awk '{print $2}')
            
            if [ -n "$build_context" ]; then
                validate_item "$service: Build context exists" \
                    "[ -d '$build_context' ]" \
                    "Build context directory $build_context does not exist"
                
                validate_item "$service: Dockerfile exists" \
                    "[ -f '$build_context/Dockerfile' ]" \
                    "Dockerfile not found in $build_context"
                
                # Check for requirements.txt (for Python services)
                if [ -f "$build_context/requirements.txt" ]; then
                    validate_item "$service: Requirements file syntax" \
                        "python3 -m pip install --dry-run -r '$build_context/requirements.txt'" \
                        "Invalid requirements.txt in $build_context"
                fi
            fi
        fi
    done <<< "$build_services"
    
    log_validation ""
}

validate_environment_variables() {
    log_validation "${CYAN}🌍 VALIDATING ENVIRONMENT VARIABLES${NC}"
    log_validation "====================================="
    
    # Check for required environment variables
    local required_env_vars=("DATABASE_URL" "REDIS_URL")
    
    for var in "${required_env_vars[@]}"; do
        validate_item "Environment variable: $var" \
            "docker-compose config | grep -q '$var'" \
            "Required environment variable $var not found"
    done
    
    # Check for password environment variables
    validate_item "Database passwords configured" \
        "docker-compose config | grep -q 'POSTGRES_PASSWORD'" \
        "Database password not configured"
    
    log_validation ""
}

validate_resource_limits() {
    log_validation "${CYAN}⚡ VALIDATING RESOURCE CONFIGURATION${NC}"
    log_validation "====================================="
    
    # Check for memory limits (optional but recommended)
    if docker-compose config | grep -q "mem_limit:"; then
        log_validation "${GREEN}✅ Memory limits configured${NC}"
    else
        log_validation "${YELLOW}⚠️  No memory limits set (consider adding for production)${NC}"
    fi
    
    # Check for CPU limits (optional but recommended)
    if docker-compose config | grep -q "cpus:"; then
        log_validation "${GREEN}✅ CPU limits configured${NC}"
    else
        log_validation "${YELLOW}⚠️  No CPU limits set (consider adding for production)${NC}"
    fi
    
    log_validation ""
}

test_dry_run() {
    log_validation "${CYAN}🧪 TESTING DRY RUN${NC}"
    log_validation "==================="
    
    # Test configuration parsing
    validate_item "Configuration parsing" \
        "docker-compose config" \
        "Failed to parse docker-compose.yml"
    
    # Test service creation (dry run)
    validate_item "Service creation test" \
        "docker-compose config --services" \
        "Failed to list services"
    
    # Test image availability (for images, not builds)
    local images=$(docker-compose config | grep "image:" | awk '{print $2}' | sort -u)
    
    while IFS= read -r image; do
        if [ -n "$image" ] && [[ "$image" != *"localhost"* ]]; then
            log_validation "${BLUE}Testing image availability: $image${NC}"
            if docker pull "$image" >/dev/null 2>&1; then
                log_validation "${GREEN}✅ Image available: $image${NC}"
            else
                log_validation "${YELLOW}⚠️  Image not locally available: $image${NC}"
            fi
        fi
    done <<< "$images"
    
    log_validation ""
}

generate_validation_report() {
    log_validation "${PURPLE}📋 GENERATING VALIDATION REPORT${NC}"
    log_validation "================================="
    
    local success_rate=$(( VALIDATIONS_PASSED * 100 / VALIDATIONS_TOTAL ))
    local report_file="$HOME/.bill-sloth/logs/docker_validation_report_$(date '+%Y%m%d_%H%M%S').txt"
    
    cat > "$report_file" << EOF
BILL SLOTH DOCKER VALIDATION REPORT
Generated: $(date)
Validation Log: $VALIDATION_LOG

SUMMARY:
========
Total Validations: $VALIDATIONS_TOTAL
Passed: $VALIDATIONS_PASSED
Failed: $VALIDATIONS_FAILED
Success Rate: $success_rate%

DOCKER COMPOSE FILE: $DOCKER_COMPOSE_FILE
Services Found: $(docker-compose config --services 2>/dev/null | wc -l)

EOF

    if [ $VALIDATIONS_FAILED -gt 0 ]; then
        echo "VALIDATION ISSUES:" >> "$report_file"
        echo "==================" >> "$report_file"
        for issue in "${VALIDATION_ISSUES[@]}"; do
            echo "- $issue" >> "$report_file"
        done
        echo "" >> "$report_file"
    fi
    
    # Add services list
    echo "CONFIGURED SERVICES:" >> "$report_file"
    echo "===================" >> "$report_file"
    docker-compose config --services 2>/dev/null | sed 's/^/- /' >> "$report_file"
    echo "" >> "$report_file"
    
    cat >> "$report_file" << EOF
DEPLOYMENT READINESS:
====================
$(if [ $success_rate -ge 95 ]; then
    echo "✅ Docker environment is ready for deployment"
elif [ $success_rate -ge 85 ]; then
    echo "⚠️  Docker environment is mostly ready, minor issues to address"
else
    echo "❌ Docker environment needs fixes before deployment"
fi)

NEXT STEPS:
===========
1. Address any validation failures listed above
2. Run: docker-compose up --build -d (when ready)
3. Monitor service startup with: docker-compose logs -f
4. Test service connectivity after deployment

For detailed validation log, see: $VALIDATION_LOG
EOF
    
    log_validation "${GREEN}📊 Validation report generated: $report_file${NC}"
    
    # Display summary
    echo ""
    log_validation "${PURPLE}=====================================${NC}"
    log_validation "${PURPLE}   DOCKER VALIDATION SUMMARY${NC}"
    log_validation "${PURPLE}=====================================${NC}"
    log_validation "Total Validations: ${BLUE}$VALIDATIONS_TOTAL${NC}"
    log_validation "Passed: ${GREEN}$VALIDATIONS_PASSED${NC}"
    log_validation "Failed: ${RED}$VALIDATIONS_FAILED${NC}"
    log_validation "Success Rate: ${YELLOW}$success_rate%${NC}"
    
    if [ $VALIDATIONS_FAILED -gt 0 ]; then
        log_validation ""
        log_validation "${RED}Validation Issues:${NC}"
        for issue in "${VALIDATION_ISSUES[@]}"; do
            log_validation "${RED}  - $issue${NC}"
        done
    fi
    
    echo ""
    if [ $success_rate -ge 95 ]; then
        log_validation "${GREEN}🎉 DOCKER VALIDATION PASSED! Ready for deployment.${NC}"
    elif [ $success_rate -ge 85 ]; then
        log_validation "${YELLOW}⚠️  Minor issues found. Review before deployment.${NC}"
    else
        log_validation "${RED}❌ Significant issues found. Fix before deployment.${NC}"
    fi
    
    return $VALIDATIONS_FAILED
}

main() {
    mkdir -p "$(dirname "$VALIDATION_LOG")"
    
    show_banner
    log_validation "Starting comprehensive Docker environment validation..."
    log_validation ""
    
    # Run all validation suites
    validate_prerequisites
    validate_compose_syntax
    validate_service_configurations
    validate_network_configuration
    validate_volume_configuration
    validate_service_dependencies
    validate_security_configuration
    validate_build_contexts
    validate_environment_variables
    validate_resource_limits
    test_dry_run
    
    # Generate final report
    generate_validation_report
    
    # Return appropriate exit code
    if [ $VALIDATIONS_FAILED -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"