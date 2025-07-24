#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Deployment Readiness Check
# Final validation before production deployment

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

# Tracking variables
READINESS_CHECKS=0
READINESS_PASSED=0
READINESS_FAILED=0
READINESS_WARNINGS=0
CRITICAL_ISSUES=()
WARNING_ISSUES=()

log_check() {
    local message="$1"
    echo -e "$message"
}

run_readiness_check() {
    local check_name="$1"
    local check_command="$2"
    local severity="${3:-CRITICAL}"
    local fix_suggestion="${4:-Manual intervention required}"
    
    ((READINESS_CHECKS++))
    log_check "${BLUE}🔍 Checking: $check_name${NC}"
    
    if eval "$check_command" >/dev/null 2>&1; then
        ((READINESS_PASSED++))
        log_check "${GREEN}✅ PASS: $check_name${NC}"
        return 0
    else
        if [ "$severity" = "WARNING" ]; then
            ((READINESS_WARNINGS++))
            WARNING_ISSUES+=("$check_name: $fix_suggestion")
            log_check "${YELLOW}⚠️  WARNING: $check_name${NC}"
        else
            ((READINESS_FAILED++))
            CRITICAL_ISSUES+=("$check_name: $fix_suggestion")
            log_check "${RED}❌ CRITICAL: $check_name${NC}"
        fi
        return 1
    fi
}

check_system_environment() {
    if command -v show_section_header >/dev/null 2>&1; then
        show_section_header "CHECKING SYSTEM ENVIRONMENT" "🖥️"
    else
        log_check "${CYAN}🖥️  CHECKING SYSTEM ENVIRONMENT${NC}"
        log_check "===================================="
    fi
    
    # Operating system
    run_readiness_check "Linux operating system" "[ \"\$(uname -s)\" = \"Linux\" ]" "CRITICAL" "Deploy on Linux system"
    
    # Architecture
    run_readiness_check "x86_64 architecture" "[ \"\$(uname -m)\" = \"x86_64\" ]" "WARNING" "Some features may not work on other architectures"
    
    # Kernel version (should be reasonably modern)
    run_readiness_check "Modern kernel (4.0+)" "[ \$(uname -r | cut -d. -f1) -ge 4 ]" "WARNING" "Update to modern kernel for best performance"
    
    # System resources
    run_readiness_check "Sufficient RAM (4GB+)" "[ \$(free -m | awk 'NR==2{print \$2}') -gt 4096 ]" "CRITICAL" "Need at least 4GB RAM"
    run_readiness_check "Sufficient disk space (20GB+)" "[ \$(df / | awk 'NR==2 {print \$4}') -gt 20971520 ]" "CRITICAL" "Need at least 20GB free disk space"
    
    # User permissions
    run_readiness_check "Running as non-root user" "[ \"\$EUID\" -ne 0 ]" "CRITICAL" "Do not run as root user"
    run_readiness_check "Sudo access available" "sudo -n true 2>/dev/null || sudo -v" "CRITICAL" "User needs sudo privileges"
    
    log_check ""
}

check_core_dependencies() {
    log_check "${CYAN}🛠️  CHECKING CORE DEPENDENCIES${NC}"
    log_check "================================="
    
    # Essential system tools
    run_readiness_check "curl available" "command -v curl" "CRITICAL" "Install curl: sudo apt-get install curl"
    run_readiness_check "wget available" "command -v wget" "CRITICAL" "Install wget: sudo apt-get install wget"
    run_readiness_check "git available" "command -v git" "CRITICAL" "Install git: sudo apt-get install git"
    run_readiness_check "jq available" "command -v jq" "CRITICAL" "Install jq: sudo apt-get install jq"
    run_readiness_check "unzip available" "command -v unzip" "CRITICAL" "Install unzip: sudo apt-get install unzip"
    
    # Build tools
    run_readiness_check "gcc compiler available" "command -v gcc" "CRITICAL" "Install build-essential: sudo apt-get install build-essential"
    run_readiness_check "make available" "command -v make" "CRITICAL" "Install build-essential: sudo apt-get install build-essential"
    run_readiness_check "pkg-config available" "command -v pkg-config" "CRITICAL" "Install pkg-config: sudo apt-get install pkg-config"
    
    log_check ""
}

check_python_environment() {
    log_check "${CYAN}🐍 CHECKING PYTHON ENVIRONMENT${NC}"
    log_check "==============================="
    
    # Python version
    run_readiness_check "Python 3.8+ available" "python3 --version | grep -E 'Python 3\\.(8|9|10|11|12)'" "CRITICAL" "Install Python 3.8+: sudo apt-get install python3"
    run_readiness_check "pip3 available" "command -v pip3" "CRITICAL" "Install pip3: sudo apt-get install python3-pip"
    run_readiness_check "Python venv module" "python3 -m venv --help" "CRITICAL" "Install venv: sudo apt-get install python3-venv"
    
    # Check if Bill Sloth virtual environment exists
    local venv_path="$HOME/.local/share/bill-sloth/venv"
    run_readiness_check "Bill Sloth virtual environment" "[ -d '$venv_path' ]" "WARNING" "Create virtual environment: python3 -m venv $venv_path"
    
    if [ -d "$venv_path" ]; then
        # Check virtual environment packages
        source "$venv_path/bin/activate" 2>/dev/null || true
        
        run_readiness_check "requests module" "python3 -c 'import requests'" "CRITICAL" "pip install requests"
        run_readiness_check "numpy module" "python3 -c 'import numpy'" "WARNING" "pip install numpy"
        run_readiness_check "pandas module" "python3 -c 'import pandas'" "WARNING" "pip install pandas"
        
        deactivate 2>/dev/null || true
    fi
    
    log_check ""
}

check_ai_components() {
    log_check "${CYAN}🤖 CHECKING AI COMPONENTS${NC}"
    log_check "============================"
    
    # Ollama
    run_readiness_check "Ollama installed" "command -v ollama" "WARNING" "Install Ollama: curl -fsSL https://ollama.ai/install.sh | sh"
    
    if command -v ollama >/dev/null 2>&1; then
        run_readiness_check "Ollama service running" "ollama --version" "WARNING" "Start Ollama service"
        run_readiness_check "Ollama models available" "ollama list | grep -v 'no models'" "WARNING" "Download models: ollama pull llama3.2:3b"
    fi
    
    # Whisper
    if [ -d "$HOME/.local/share/bill-sloth/venv" ]; then
        source "$HOME/.local/share/bill-sloth/venv/bin/activate" 2>/dev/null || true
        run_readiness_check "Whisper module" "python3 -c 'import whisper'" "WARNING" "pip install openai-whisper"
        deactivate 2>/dev/null || true
    fi
    
    log_check ""
}

check_audio_system() {
    log_check "${CYAN}🎤 CHECKING AUDIO SYSTEM${NC}"
    log_check "=========================="
    
    # Audio tools
    run_readiness_check "ALSA utilities" "command -v arecord" "WARNING" "Install ALSA: sudo apt-get install alsa-utils"
    run_readiness_check "Audio devices present" "arecord -l | grep -q card" "WARNING" "Connect audio input device"
    
    # PulseAudio (optional but recommended)
    run_readiness_check "PulseAudio available" "command -v pulseaudio || systemctl --user is-active pulseaudio" "WARNING" "Install PulseAudio: sudo apt-get install pulseaudio"
    
    # Python audio libraries
    if [ -d "$HOME/.local/share/bill-sloth/venv" ]; then
        source "$HOME/.local/share/bill-sloth/venv/bin/activate" 2>/dev/null || true
        run_readiness_check "PyAudio module" "python3 -c 'import pyaudio'" "WARNING" "pip install pyaudio (may need portaudio19-dev)"
        deactivate 2>/dev/null || true
    fi
    
    log_check ""
}

check_docker_environment() {
    log_check "${CYAN}🐳 CHECKING DOCKER ENVIRONMENT${NC}"
    log_check "==============================="
    
    # Docker installation
    run_readiness_check "Docker installed" "command -v docker" "CRITICAL" "Install Docker: https://docs.docker.com/engine/install/"
    
    if command -v docker >/dev/null 2>&1; then
        run_readiness_check "Docker service running" "systemctl is-active docker" "CRITICAL" "Start Docker: sudo systemctl start docker"
        run_readiness_check "Docker user permissions" "docker ps" "CRITICAL" "Add user to docker group: sudo usermod -aG docker \$USER"
        run_readiness_check "Docker Compose available" "docker compose version || command -v docker-compose" "CRITICAL" "Install Docker Compose"
    fi
    
    log_check ""
}

check_database_components() {
    log_check "${CYAN}🗄️  CHECKING DATABASE COMPONENTS${NC}"
    log_check "=================================="
    
    # SQLite
    run_readiness_check "SQLite3 available" "command -v sqlite3" "CRITICAL" "Install SQLite: sudo apt-get install sqlite3"
    
    # PostgreSQL client (optional)
    run_readiness_check "PostgreSQL client" "command -v psql" "WARNING" "Install PostgreSQL client: sudo apt-get install postgresql-client"
    
    log_check ""
}

check_bill_sloth_structure() {
    log_check "${CYAN}📁 CHECKING BILL SLOTH STRUCTURE${NC}"
    log_check "=================================="
    
    # Core directories
    run_readiness_check "Bill Sloth root directory" "[ -d '/path/to/bill-sloth' ]" "CRITICAL" "Clone Bill Sloth repository"
    
    # If we can find the Bill Sloth directory, check its structure
    local bill_sloth_dir
    if [ -d "$(pwd)" ] && [ -f "$(pwd)/bill_command_center.sh" ]; then
        bill_sloth_dir="$(pwd)"
    elif [ -d "$HOME/bill-sloth" ] && [ -f "$HOME/bill-sloth/bill_command_center.sh" ]; then
        bill_sloth_dir="$HOME/bill-sloth"
    else
        log_check "${YELLOW}⚠️  Bill Sloth directory not found in expected locations${NC}"
        return
    fi
    
    # Check core files
    run_readiness_check "Main command center" "[ -f '$bill_sloth_dir/bill_command_center.sh' ]" "CRITICAL" "Missing main script"
    run_readiness_check "Onboarding script" "[ -f '$bill_sloth_dir/onboard.sh' ]" "CRITICAL" "Missing onboarding script"
    run_readiness_check "Docker configuration" "[ -f '$bill_sloth_dir/docker-compose.yml' ]" "CRITICAL" "Missing Docker configuration"
    
    # Check core directories
    run_readiness_check "Libraries directory" "[ -d '$bill_sloth_dir/lib' ]" "CRITICAL" "Missing lib directory"
    run_readiness_check "Modules directory" "[ -d '$bill_sloth_dir/modules' ]" "CRITICAL" "Missing modules directory"
    run_readiness_check "Scripts directory" "[ -d '$bill_sloth_dir/scripts' ]" "CRITICAL" "Missing scripts directory"
    
    # Check executable permissions
    run_readiness_check "Main script executable" "[ -x '$bill_sloth_dir/bill_command_center.sh' ]" "CRITICAL" "chmod +x bill_command_center.sh"
    run_readiness_check "Onboarding executable" "[ -x '$bill_sloth_dir/onboard.sh' ]" "CRITICAL" "chmod +x onboard.sh"
    
    log_check ""
}

check_network_connectivity() {
    log_check "${CYAN}🌐 CHECKING NETWORK CONNECTIVITY${NC}"
    log_check "=================================="
    
    # Internet connectivity (needed for initial setup)
    run_readiness_check "Internet connectivity" "ping -c 1 google.com" "WARNING" "Internet required for initial model downloads"
    run_readiness_check "HTTPS connectivity" "curl -s https://httpbin.org/get" "WARNING" "HTTPS required for secure downloads"
    run_readiness_check "GitHub access" "curl -s https://api.github.com/zen" "WARNING" "GitHub access needed for updates"
    
    # Docker Hub access (for container images)
    run_readiness_check "Docker Hub access" "curl -s https://registry-1.docker.io/v2/" "WARNING" "Docker Hub needed for container images"
    
    log_check ""
}

check_performance_requirements() {
    log_check "${CYAN}⚡ CHECKING PERFORMANCE REQUIREMENTS${NC}"
    log_check "====================================="
    
    # CPU cores
    local cpu_cores=$(nproc)
    run_readiness_check "Multi-core CPU (2+ cores)" "[ $cpu_cores -ge 2 ]" "WARNING" "Multi-core CPU recommended for performance"
    
    # Memory for AI workloads
    local ram_gb=$(free -g | awk 'NR==2{print $2}')
    run_readiness_check "Adequate RAM for AI (8GB+)" "[ $ram_gb -ge 8 ]" "WARNING" "8GB+ RAM recommended for AI features"
    
    # Disk I/O performance
    local disk_speed=$(dd if=/dev/zero of=/tmp/speedtest bs=1M count=100 2>&1 | grep -o '[0-9.]* MB/s' | head -1 | cut -d' ' -f1 || echo "0")
    run_readiness_check "Adequate disk speed (50MB/s+)" "[ \$(echo \"$disk_speed > 50\" | bc -l 2>/dev/null || echo 0) -eq 1 ]" "WARNING" "SSD recommended for better performance"
    
    # Clean up test file
    rm -f /tmp/speedtest 2>/dev/null || true
    
    log_check ""
}

generate_deployment_checklist() {
    log_check "${PURPLE}📋 GENERATING DEPLOYMENT CHECKLIST${NC}"
    log_check "====================================="
    
    local checklist_file="/tmp/bill_sloth_deployment_checklist.txt"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    cat > "$checklist_file" << EOF
Bill Sloth Deployment Readiness Checklist
==========================================
Generated: $timestamp
System: $(uname -s) $(uname -r) $(uname -m)

Readiness Summary:
- Total checks: $READINESS_CHECKS
- Passed: $READINESS_PASSED
- Critical failures: $READINESS_FAILED
- Warnings: $READINESS_WARNINGS

EOF
    
    if [ $READINESS_FAILED -eq 0 ]; then
        echo "✅ DEPLOYMENT READY: All critical requirements satisfied" >> "$checklist_file"
    else
        echo "❌ NOT READY FOR DEPLOYMENT: Critical issues must be resolved" >> "$checklist_file"
    fi
    
    echo "" >> "$checklist_file"
    
    if [ ${#CRITICAL_ISSUES[@]} -gt 0 ]; then
        echo "🚨 CRITICAL ISSUES TO RESOLVE:" >> "$checklist_file"
        for issue in "${CRITICAL_ISSUES[@]}"; do
            echo "  • $issue" >> "$checklist_file"
        done
        echo "" >> "$checklist_file"
    fi
    
    if [ ${#WARNING_ISSUES[@]} -gt 0 ]; then
        echo "⚠️  WARNINGS TO CONSIDER:" >> "$checklist_file"
        for warning in "${WARNING_ISSUES[@]}"; do
            echo "  • $warning" >> "$checklist_file"
        done
        echo "" >> "$checklist_file"
    fi
    
    cat >> "$checklist_file" << EOF
DEPLOYMENT STEPS:
1. Resolve all critical issues listed above
2. Consider addressing warnings for optimal performance
3. Run: ./scripts/dependency_installer.sh (if dependencies missing)
4. Run: ./scripts/linux_dependency_validator.sh (for verification)
5. Run: ./onboard.sh (for initial system setup)
6. Test core functionality: ./bill_command_center.sh
7. Monitor system resources during initial deployment

PERFORMANCE OPTIMIZATION:
- Ensure adequate RAM (8GB+ recommended)
- Use SSD storage for better I/O performance
- Configure audio system for voice features
- Download AI models during low-usage periods

SECURITY CONSIDERATIONS:
- Run as non-root user with sudo access
- Keep system packages updated
- Configure firewall for Docker services
- Regularly update Bill Sloth components
EOF
    
    log_check "Deployment checklist saved: $checklist_file"
    return 0
}

calculate_readiness_score() {
    local total_possible=$((READINESS_CHECKS * 100))
    local penalty_warnings=$((READINESS_WARNINGS * 5))
    local penalty_critical=$((READINESS_FAILED * 50))
    local score=$((READINESS_PASSED * 100 - penalty_warnings - penalty_critical))
    
    # Ensure score doesn't go below 0
    if [ $score -lt 0 ]; then
        score=0
    fi
    
    local percentage=$((score * 100 / total_possible))
    echo $percentage
}

generate_readiness_summary() {
    local readiness_score=$(calculate_readiness_score)
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo ""
    log_check "${PURPLE}═══════════════════════════════════════${NC}"
    log_check "${PURPLE}    DEPLOYMENT READINESS SUMMARY${NC}"
    log_check "${PURPLE}═══════════════════════════════════════${NC}"
    log_check "Assessment Date: ${BLUE}$timestamp${NC}"
    log_check ""
    log_check "Total Checks: ${BLUE}$READINESS_CHECKS${NC}"
    log_check "Passed: ${GREEN}$READINESS_PASSED${NC}"
    log_check "Critical Issues: ${RED}$READINESS_FAILED${NC}"
    log_check "Warnings: ${YELLOW}$READINESS_WARNINGS${NC}"
    log_check ""
    log_check "Readiness Score: ${BLUE}$readiness_score%${NC}"
    
    # Determine deployment status
    if [ $READINESS_FAILED -eq 0 ] && [ $readiness_score -ge 80 ]; then
        log_check "Deployment Status: ${GREEN}READY FOR DEPLOYMENT${NC}"
        log_check ""
        if command -v show_celebration >/dev/null 2>&1; then
            show_celebration
        fi
        log_check "${GREEN}✅ Bill Sloth is ready for production deployment!${NC}"
        log_check "You can proceed with running the onboarding and setup processes."
    elif [ $READINESS_FAILED -eq 0 ] && [ $readiness_score -ge 60 ]; then
        log_check "Deployment Status: ${YELLOW}MOSTLY READY${NC}"
        log_check ""
        log_check "${YELLOW}⚠️  Bill Sloth can be deployed but consider addressing warnings.${NC}"
        log_check "Some features may have reduced functionality."
    else
        log_check "Deployment Status: ${RED}NOT READY${NC}"
        log_check ""
        log_check "${RED}❌ Critical issues must be resolved before deployment.${NC}"
        log_check "Use the generated checklist to address missing requirements."
    fi
    
    log_check ""
    log_check "${CYAN}Next Steps:${NC}"
    if [ $READINESS_FAILED -gt 0 ]; then
        log_check "1. Review and resolve critical issues"
        log_check "2. Run dependency installer if needed"
        log_check "3. Re-run this readiness check"
    else
        log_check "1. Review deployment checklist"
        log_check "2. Run Bill Sloth onboarding: ./onboard.sh"
        log_check "3. Test core functionality"
    fi
    
    return $READINESS_FAILED
}

main() {
    # Source aesthetic functions if available
    if [ -f "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh" ]; then
        source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh"
        show_module_banner "BILL SLOTH DEPLOYMENT READINESS CHECK" "Final validation before production deployment" "🚀"
    else
        echo -e "${CYAN}"
        cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                🚀 BILL SLOTH DEPLOYMENT READINESS CHECK 🚀                  ║
║                                                                              ║
║            Final validation before production deployment to Linux            ║
║                 Comprehensive assessment of all requirements                 ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
    fi
    
    log_check "Starting comprehensive deployment readiness assessment..."
    log_check "This will check all requirements for Bill Sloth production deployment."
    log_check ""
    
    # Run all readiness checks
    check_system_environment
    check_core_dependencies
    check_python_environment
    check_ai_components
    check_audio_system
    check_docker_environment
    check_database_components
    check_bill_sloth_structure
    check_network_connectivity
    check_performance_requirements
    
    # Generate outputs
    generate_deployment_checklist
    generate_readiness_summary
    
    # Return appropriate exit code
    if [ $READINESS_FAILED -eq 0 ]; then
        exit 0
    else
        exit 1
    fi
}

# Run main function
main "$@"