#!/bin/bash
# LLM_CAPABILITY: local_ok
# Linux Dependency Validator for Bill Sloth
# Validates and installs all required dependencies with proper error handling

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

# Global tracking
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNINGS=0
MISSING_DEPS=()
INSTALL_COMMANDS=()

log_check() {
    local message="$1"
    echo -e "$message"
}

run_dependency_check() {
    local dep_name="$1"
    local check_command="$2"
    local install_command="$3"
    local severity="${4:-ERROR}"
    
    ((TOTAL_CHECKS++))
    log_check "${BLUE}🔍 Checking: $dep_name${NC}"
    
    if eval "$check_command" >/dev/null 2>&1; then
        ((PASSED_CHECKS++))
        log_check "${GREEN}✅ FOUND: $dep_name${NC}"
        return 0
    else
        if [ "$severity" = "WARNING" ]; then
            ((WARNINGS++))
            log_check "${YELLOW}⚠️  MISSING (optional): $dep_name${NC}"
        else
            ((FAILED_CHECKS++))
            MISSING_DEPS+=("$dep_name")
            INSTALL_COMMANDS+=("$install_command")
            log_check "${RED}❌ MISSING: $dep_name${NC}"
        fi
        return 1
    fi
}

detect_linux_distribution() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    elif [ -f /etc/debian_version ]; then
        echo "debian"
    elif [ -f /etc/redhat-release ]; then
        echo "rhel"
    elif [ -f /etc/arch-release ]; then
        echo "arch"
    else
        echo "unknown"
    fi
}

get_package_manager() {
    local distro=$(detect_linux_distribution)
    
    case "$distro" in
        ubuntu|debian|pop|mint)
            echo "apt"
            ;;
        fedora|centos|rhel|rocky|alma)
            echo "dnf"
            ;;
        arch|manjaro)
            echo "pacman"
            ;;
        opensuse*|suse)
            echo "zypper"
            ;;
        alpine)
            echo "apk"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

check_system_requirements() {
    log_check "${CYAN}🖥️  CHECKING SYSTEM REQUIREMENTS${NC}"
    log_check "=================================="
    
    # Check if we're on Linux
    run_dependency_check "Linux OS" "[ \"\$(uname -s)\" = \"Linux\" ]" "echo 'This script requires Linux'"
    
    # Check architecture
    run_dependency_check "x86_64 Architecture" "[ \"\$(uname -m)\" = \"x86_64\" ]" "echo 'x86_64 architecture required'" "WARNING"
    
    # Check available disk space (need at least 20GB)
    run_dependency_check "Sufficient disk space (20GB+)" "[ \$(df / | awk 'NR==2 {print \$4}') -gt 20971520 ]" "echo 'Free up disk space - need 20GB+'"
    
    # Check RAM (recommend 8GB+)
    run_dependency_check "Sufficient RAM (4GB+)" "[ \$(free -m | awk 'NR==2{print \$2}') -gt 4096 ]" "echo 'Need at least 4GB RAM'" "WARNING"
    
    # Check if running as regular user (not root)
    run_dependency_check "Running as regular user" "[ \"\$EUID\" -ne 0 ]" "echo 'Do not run as root - use regular user account'"
    
    # Check sudo access
    run_dependency_check "Sudo access available" "sudo -n true 2>/dev/null || sudo -v" "echo 'User needs sudo privileges'"
    
    log_check ""
}

check_package_manager() {
    log_check "${CYAN}📦 CHECKING PACKAGE MANAGER${NC}"
    log_check "============================="
    
    local pkg_mgr=$(get_package_manager)
    local distro=$(detect_linux_distribution)
    
    log_check "Detected distribution: $distro"
    log_check "Package manager: $pkg_mgr"
    
    case "$pkg_mgr" in
        "apt")
            run_dependency_check "APT package manager" "command -v apt-get" "echo 'APT should be available on Debian/Ubuntu'"
            run_dependency_check "APT repositories updated" "[ \$(find /var/lib/apt/lists -name '*.Packages' -mtime -1 | wc -l) -gt 0 ]" "sudo apt-get update"
            ;;
        "dnf")
            run_dependency_check "DNF package manager" "command -v dnf" "echo 'DNF should be available on Fedora/RHEL'"
            ;;
        "pacman")
            run_dependency_check "Pacman package manager" "command -v pacman" "echo 'Pacman should be available on Arch'"
            ;;
        *)
            log_check "${YELLOW}⚠️  Unknown package manager - manual installation may be required${NC}"
            ;;
    esac
    
    log_check ""
}

check_core_system_tools() {
    log_check "${CYAN}🛠️  CHECKING CORE SYSTEM TOOLS${NC}"
    log_check "==============================="
    
    # Essential tools
    run_dependency_check "curl" "command -v curl" "install_curl"
    run_dependency_check "wget" "command -v wget" "install_wget"
    run_dependency_check "git" "command -v git" "install_git"
    run_dependency_check "unzip" "command -v unzip" "install_unzip"
    run_dependency_check "tar" "command -v tar" "install_tar"
    run_dependency_check "jq" "command -v jq" "install_jq"
    
    # Build tools (needed for some Python packages)
    run_dependency_check "gcc compiler" "command -v gcc" "install_build_tools"
    run_dependency_check "make" "command -v make" "install_build_tools"
    run_dependency_check "pkg-config" "command -v pkg-config" "install_build_tools"
    
    log_check ""
}

check_python_environment() {
    log_check "${CYAN}🐍 CHECKING PYTHON ENVIRONMENT${NC}"
    log_check "==============================="
    
    # Python installation
    run_dependency_check "Python 3.8+" "python3 --version | grep -E 'Python 3\.(8|9|10|11|12)'" "install_python3"
    run_dependency_check "pip3" "command -v pip3" "install_pip3"
    run_dependency_check "python3-venv" "python3 -m venv --help" "install_python3_venv"
    
    # Python development headers (needed for some packages)
    run_dependency_check "Python dev headers" "python3 -c 'import distutils.util'" "install_python3_dev" "WARNING"
    
    # Essential Python packages for Bill Sloth
    run_dependency_check "requests module" "python3 -c 'import requests'" "pip3 install --user requests"
    
    log_check ""
}

check_audio_system() {
    log_check "${CYAN}🎤 CHECKING AUDIO SYSTEM${NC}"
    log_check "=========================="
    
    # Audio libraries and tools
    run_dependency_check "ALSA utilities" "command -v arecord" "install_alsa_utils"
    run_dependency_check "PulseAudio" "command -v pulseaudio || systemctl --user is-active pulseaudio" "install_pulseaudio" "WARNING"
    run_dependency_check "PortAudio dev" "pkg-config --exists portaudio-2.0" "install_portaudio_dev"
    
    # Check audio devices
    run_dependency_check "Audio input device" "arecord -l | grep -q card" "echo 'No audio input devices found - check hardware'" "WARNING"
    
    # Python audio libraries
    run_dependency_check "PyAudio" "python3 -c 'import pyaudio'" "install_python_audio_libs"
    
    log_check ""
}

check_ai_dependencies() {
    log_check "${CYAN}🤖 CHECKING AI DEPENDENCIES${NC}"
    log_check "============================="
    
    # Ollama
    run_dependency_check "Ollama" "command -v ollama" "install_ollama"
    
    # Python AI libraries
    run_dependency_check "NumPy" "python3 -c 'import numpy'" "pip3 install --user numpy"
    run_dependency_check "PyTorch" "python3 -c 'import torch'" "install_pytorch" "WARNING"
    run_dependency_check "Whisper" "python3 -c 'import whisper'" "pip3 install --user openai-whisper"
    
    # Scientific computing (for analytics)
    run_dependency_check "Pandas" "python3 -c 'import pandas'" "pip3 install --user pandas" "WARNING"
    run_dependency_check "Scikit-learn" "python3 -c 'import sklearn'" "pip3 install --user scikit-learn" "WARNING"
    run_dependency_check "Matplotlib" "python3 -c 'import matplotlib'" "pip3 install --user matplotlib" "WARNING"
    
    log_check ""
}

check_docker_environment() {
    log_check "${CYAN}🐳 CHECKING DOCKER ENVIRONMENT${NC}"
    log_check "==============================="
    
    run_dependency_check "Docker" "command -v docker" "install_docker"
    run_dependency_check "Docker Compose" "command -v docker-compose || docker compose version" "install_docker_compose"
    run_dependency_check "Docker service" "systemctl is-active docker" "sudo systemctl enable --now docker"
    run_dependency_check "Docker user access" "docker ps" "sudo usermod -aG docker \$USER && echo 'Logout and login again'"
    
    log_check ""
}

check_database_tools() {
    log_check "${CYAN}🗄️  CHECKING DATABASE TOOLS${NC}"
    log_check "============================="
    
    run_dependency_check "SQLite3" "command -v sqlite3" "install_sqlite3"
    run_dependency_check "PostgreSQL client" "command -v psql" "install_postgresql_client" "WARNING"
    
    log_check ""
}

# Installation functions for different package managers
install_with_apt() {
    local packages="$1"
    sudo apt-get update && sudo apt-get install -y $packages
}

install_with_dnf() {
    local packages="$1"
    sudo dnf install -y $packages
}

install_with_pacman() {
    local packages="$1"
    sudo pacman -S --noconfirm $packages
}

# Specific installation functions
install_curl() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "curl" ;;
        "dnf") install_with_dnf "curl" ;;
        "pacman") install_with_pacman "curl" ;;
        *) echo "Manual installation required: curl" ;;
    esac
}

install_wget() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "wget" ;;
        "dnf") install_with_dnf "wget" ;;
        "pacman") install_with_pacman "wget" ;;
        *) echo "Manual installation required: wget" ;;
    esac
}

install_git() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "git" ;;
        "dnf") install_with_dnf "git" ;;
        "pacman") install_with_pacman "git" ;;
        *) echo "Manual installation required: git" ;;
    esac
}

install_unzip() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "unzip" ;;
        "dnf") install_with_dnf "unzip" ;;
        "pacman") install_with_pacman "unzip" ;;
        *) echo "Manual installation required: unzip" ;;
    esac
}

install_tar() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "tar" ;;
        "dnf") install_with_dnf "tar" ;;
        "pacman") install_with_pacman "tar" ;;
        *) echo "Manual installation required: tar" ;;
    esac
}

install_jq() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "jq" ;;
        "dnf") install_with_dnf "jq" ;;
        "pacman") install_with_pacman "jq" ;;
        *) echo "Manual installation required: jq" ;;
    esac
}

install_build_tools() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "build-essential pkg-config" ;;
        "dnf") install_with_dnf "gcc gcc-c++ make pkg-config" ;;
        "pacman") install_with_pacman "base-devel pkg-config" ;;
        *) echo "Manual installation required: build tools" ;;
    esac
}

install_python3() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "python3 python3-pip python3-venv" ;;
        "dnf") install_with_dnf "python3 python3-pip python3-venv" ;;
        "pacman") install_with_pacman "python python-pip" ;;
        *) echo "Manual installation required: python3" ;;
    esac
}

install_pip3() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "python3-pip" ;;
        "dnf") install_with_dnf "python3-pip" ;;
        "pacman") install_with_pacman "python-pip" ;;
        *) echo "Manual installation required: pip3" ;;
    esac
}

install_python3_venv() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "python3-venv" ;;
        "dnf") install_with_dnf "python3-venv" ;;
        *) echo "python -m venv should work by default" ;;
    esac
}

install_python3_dev() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "python3-dev python3-distutils" ;;
        "dnf") install_with_dnf "python3-devel" ;;
        "pacman") echo "Python dev headers included by default" ;;
        *) echo "Manual installation required: python dev headers" ;;
    esac
}

install_alsa_utils() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "alsa-utils" ;;
        "dnf") install_with_dnf "alsa-utils" ;;
        "pacman") install_with_pacman "alsa-utils" ;;
        *) echo "Manual installation required: alsa-utils" ;;
    esac
}

install_pulseaudio() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "pulseaudio pulseaudio-utils" ;;
        "dnf") install_with_dnf "pulseaudio pulseaudio-utils" ;;
        "pacman") install_with_pacman "pulseaudio pulseaudio-alsa" ;;
        *) echo "Manual installation required: pulseaudio" ;;
    esac
}

install_portaudio_dev() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "portaudio19-dev" ;;
        "dnf") install_with_dnf "portaudio-devel" ;;
        "pacman") install_with_pacman "portaudio" ;;
        *) echo "Manual installation required: portaudio development files" ;;
    esac
}

install_python_audio_libs() {
    pip3 install --user pyaudio pydub
}

install_ollama() {
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL https://ollama.ai/install.sh | sh
    else
        echo "curl required to install Ollama - install curl first"
        return 1
    fi
}

install_pytorch() {
    # Install CPU version by default
    pip3 install --user torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
}

install_docker() {
    case "$(get_package_manager)" in
        "apt") 
            curl -fsSL https://get.docker.com | sh
            ;;
        "dnf") 
            install_with_dnf "docker docker-compose"
            ;;
        "pacman") 
            install_with_pacman "docker docker-compose"
            ;;
        *) 
            echo "Manual Docker installation required - visit https://docs.docker.com/engine/install/"
            ;;
    esac
}

install_docker_compose() {
    if command -v docker >/dev/null 2>&1; then
        # Try Docker Compose V2 first
        if ! docker compose version >/dev/null 2>&1; then
            # Fall back to standalone docker-compose
            case "$(get_package_manager)" in
                "apt") install_with_apt "docker-compose" ;;
                "dnf") install_with_dnf "docker-compose" ;;
                "pacman") install_with_pacman "docker-compose" ;;
                *) 
                    # Install via pip as fallback
                    pip3 install --user docker-compose
                    ;;
            esac
        fi
    else
        echo "Docker must be installed before Docker Compose"
        return 1
    fi
}

install_sqlite3() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "sqlite3" ;;
        "dnf") install_with_dnf "sqlite" ;;
        "pacman") install_with_pacman "sqlite" ;;
        *) echo "Manual installation required: sqlite3" ;;
    esac
}

install_postgresql_client() {
    case "$(get_package_manager)" in
        "apt") install_with_apt "postgresql-client" ;;
        "dnf") install_with_dnf "postgresql" ;;
        "pacman") install_with_pacman "postgresql" ;;
        *) echo "Manual installation required: postgresql client" ;;
    esac
}

generate_installation_script() {
    log_check "${PURPLE}📝 GENERATING INSTALLATION SCRIPT${NC}"
    log_check "===================================="
    
    local install_script="./bill_sloth_install_dependencies.sh"
    
    cat > "$install_script" << 'EOF'
#!/bin/bash
# Bill Sloth Dependency Installation Script
# Auto-generated based on system analysis

set -euo pipefail

echo "🚀 Installing Bill Sloth dependencies..."
echo "========================================"

# Update package manager
EOF
    
    case "$(get_package_manager)" in
        "apt")
            echo "sudo apt-get update" >> "$install_script"
            ;;
        "dnf")
            echo "sudo dnf check-update || true" >> "$install_script"
            ;;
    esac
    
    # Add installation commands for missing dependencies
    for cmd in "${INSTALL_COMMANDS[@]}"; do
        echo "" >> "$install_script"
        echo "echo '📦 Installing: $cmd'" >> "$install_script"
        echo "$cmd" >> "$install_script"
    done
    
    cat >> "$install_script" << 'EOF'

echo ""
echo "✅ Dependency installation completed!"
echo ""
echo "Next steps:"
echo "1. Logout and login again (for Docker group membership)"
echo "2. Run the Bill Sloth dependency validator again"
echo "3. Follow any remaining manual installation instructions"
EOF
    
    chmod +x "$install_script"
    
    log_check "Installation script created: $install_script"
    log_check "Run it with: ./$install_script"
}

generate_summary_report() {
    local success_rate=$((PASSED_CHECKS * 100 / TOTAL_CHECKS))
    
    echo ""
    log_check "${PURPLE}═══════════════════════════════════════${NC}"
    log_check "${PURPLE}    BILL SLOTH DEPENDENCY SUMMARY${NC}"
    log_check "${PURPLE}═══════════════════════════════════════${NC}"
    
    log_check "Total Checks: ${BLUE}$TOTAL_CHECKS${NC}"
    log_check "Passed: ${GREEN}$PASSED_CHECKS${NC}"
    log_check "Failed: ${RED}$FAILED_CHECKS${NC}"
    log_check "Warnings: ${YELLOW}$WARNINGS${NC}"
    log_check "Success Rate: ${BLUE}$success_rate%${NC}"
    
    if [ $FAILED_CHECKS -eq 0 ]; then
        log_check ""
        log_check "${GREEN}🎉 ALL DEPENDENCIES SATISFIED!${NC}"
        log_check "${GREEN}Bill Sloth is ready for deployment.${NC}"
        return 0
    else
        log_check ""
        log_check "${RED}❌ MISSING DEPENDENCIES:${NC}"
        for dep in "${MISSING_DEPS[@]}"; do
            log_check "${RED}  • $dep${NC}"
        done
        
        log_check ""
        log_check "${YELLOW}📋 RECOMMENDED ACTION:${NC}"
        log_check "Run the generated installation script to install missing dependencies:"
        log_check "${CYAN}./bill_sloth_install_dependencies.sh${NC}"
        
        return 1
    fi
}

main() {
    # Source aesthetic functions if available
    if [ -f "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh" ]; then
        source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh"
        show_module_banner "BILL SLOTH DEPENDENCY VALIDATOR" "Comprehensive validation for Linux deployment" "🔍"
    else
        echo -e "${CYAN}"
        cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                   🔍 BILL SLOTH DEPENDENCY VALIDATOR 🔍                     ║
║                                                                              ║
║           Comprehensive validation of all system requirements               ║
║                     for Bill Sloth Linux deployment                         ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
    fi
    
    log_check "Starting comprehensive dependency validation..."
    log_check "Detected system: $(uname -s) $(uname -m)"
    log_check "Distribution: $(detect_linux_distribution)"
    log_check "Package manager: $(get_package_manager)"
    log_check ""
    
    # Run all checks
    check_system_requirements
    check_package_manager
    check_core_system_tools
    check_python_environment
    check_audio_system
    check_ai_dependencies
    check_docker_environment
    check_database_tools
    
    # Generate installation script if needed
    if [ $FAILED_CHECKS -gt 0 ]; then
        generate_installation_script
    fi
    
    # Generate summary
    generate_summary_report
}

# Run main function
main "$@"