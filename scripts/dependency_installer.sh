#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth Dependency Installer
# Robust installation with error handling and recovery

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

# Installation tracking
INSTALL_LOG="/tmp/bill_sloth_install.log"
INSTALL_SUCCESS=0
INSTALL_FAILURES=0
TOTAL_INSTALLS=0

log_install() {
    local message="$1"
    echo -e "$message" | tee -a "$INSTALL_LOG"
}

log_success() {
    local message="$1"
    log_install "${GREEN}✅ $message${NC}"
    ((INSTALL_SUCCESS++))
}

log_error() {
    local message="$1"
    log_install "${RED}❌ $message${NC}"
    ((INSTALL_FAILURES++))
}

log_warning() {
    local message="$1"
    log_install "${YELLOW}⚠️  $message${NC}"
}

log_info() {
    local message="$1"
    log_install "${BLUE}ℹ️  $message${NC}"
}

# Safe installation wrapper
safe_install() {
    local description="$1"
    local install_command="$2"
    local verification_command="$3"
    local required="${4:-true}"
    
    ((TOTAL_INSTALLS++))
    log_info "Installing: $description"
    
    # Try installation
    if eval "$install_command" >> "$INSTALL_LOG" 2>&1; then
        # Verify installation worked
        if eval "$verification_command" >/dev/null 2>&1; then
            log_success "$description installed successfully"
            return 0
        else
            log_error "$description installation failed verification"
            if [ "$required" = "true" ]; then
                return 1
            fi
        fi
    else
        log_error "$description installation command failed"
        if [ "$required" = "true" ]; then
            return 1
        fi
    fi
    
    return 0
}

detect_system() {
    # Detect distribution
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO="$ID"
        VERSION="$VERSION_ID"
    else
        DISTRO="unknown"
        VERSION="unknown"
    fi
    
    # Detect package manager
    if command -v apt-get >/dev/null 2>&1; then
        PKG_MGR="apt"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MGR="dnf"
    elif command -v yum >/dev/null 2>&1; then
        PKG_MGR="yum"
    elif command -v pacman >/dev/null 2>&1; then
        PKG_MGR="pacman"
    elif command -v zypper >/dev/null 2>&1; then
        PKG_MGR="zypper"
    else
        PKG_MGR="unknown"
    fi
    
    log_info "Detected system: $DISTRO $VERSION"
    log_info "Package manager: $PKG_MGR"
}

update_package_manager() {
    log_info "Updating package manager..."
    
    case "$PKG_MGR" in
        "apt")
            safe_install "APT package lists" "sudo apt-get update" "[ -f /var/lib/apt/lists/lock ]"
            ;;
        "dnf")
            safe_install "DNF metadata" "sudo dnf check-update || true" "command -v dnf"
            ;;
        "yum")
            safe_install "YUM metadata" "sudo yum check-update || true" "command -v yum"
            ;;
        "pacman")
            safe_install "Pacman database" "sudo pacman -Sy" "command -v pacman"
            ;;
        *)
            log_warning "Unknown package manager - skipping update"
            ;;
    esac
}

install_system_essentials() {
    log_info "Installing system essentials..."
    
    case "$PKG_MGR" in
        "apt")
            safe_install "Build essentials" "sudo apt-get install -y build-essential" "command -v gcc"
            safe_install "Essential tools" "sudo apt-get install -y curl wget git unzip tar jq" "command -v curl && command -v wget && command -v git"
            safe_install "Python development" "sudo apt-get install -y python3 python3-pip python3-venv python3-dev" "command -v python3 && command -v pip3"
            safe_install "Audio libraries" "sudo apt-get install -y alsa-utils portaudio19-dev" "command -v arecord"
            safe_install "System libraries" "sudo apt-get install -y pkg-config libffi-dev libssl-dev" "pkg-config --version"
            ;;
        "dnf")
            safe_install "Development tools" "sudo dnf groupinstall -y 'Development Tools'" "command -v gcc"
            safe_install "Essential tools" "sudo dnf install -y curl wget git unzip tar jq" "command -v curl && command -v wget && command -v git"
            safe_install "Python development" "sudo dnf install -y python3 python3-pip python3-venv python3-devel" "command -v python3 && command -v pip3"
            safe_install "Audio libraries" "sudo dnf install -y alsa-utils portaudio-devel" "command -v arecord"
            safe_install "System libraries" "sudo dnf install -y pkgconfig libffi-devel openssl-devel" "pkg-config --version"
            ;;
        "pacman")
            safe_install "Base development" "sudo pacman -S --noconfirm base-devel" "command -v gcc"
            safe_install "Essential tools" "sudo pacman -S --noconfirm curl wget git unzip tar jq" "command -v curl && command -v wget && command -v git"
            safe_install "Python development" "sudo pacman -S --noconfirm python python-pip" "command -v python3 && command -v pip3"
            safe_install "Audio libraries" "sudo pacman -S --noconfirm alsa-utils portaudio" "command -v arecord"
            safe_install "System libraries" "sudo pacman -S --noconfirm pkgconf libffi openssl" "pkg-config --version"
            ;;
        *)
            log_error "Unsupported package manager: $PKG_MGR"
            return 1
            ;;
    esac
}

install_python_packages() {
    log_info "Installing Python packages..."
    
    # Create virtual environment for Bill Sloth
    VENV_DIR="$HOME/.local/share/bill-sloth/venv"
    if [ ! -d "$VENV_DIR" ]; then
        safe_install "Python virtual environment" "python3 -m venv '$VENV_DIR'" "[ -d '$VENV_DIR' ]"
    fi
    
    # Activate virtual environment
    source "$VENV_DIR/bin/activate" || {
        log_error "Failed to activate virtual environment"
        return 1
    }
    
    # Upgrade pip
    safe_install "pip upgrade" "pip install --upgrade pip" "pip --version"
    
    # Install essential packages
    safe_install "requests" "pip install requests" "python -c 'import requests'"
    safe_install "numpy" "pip install numpy" "python -c 'import numpy'" false
    safe_install "pandas" "pip install pandas" "python -c 'import pandas'" false
    safe_install "matplotlib" "pip install matplotlib" "python -c 'import matplotlib'" false
    safe_install "scikit-learn" "pip install scikit-learn" "python -c 'import sklearn'" false
    
    # Audio processing
    safe_install "PyAudio" "pip install pyaudio" "python -c 'import pyaudio'" false
    safe_install "pydub" "pip install pydub" "python -c 'import pydub'" false
    
    # AI packages (these are large, install with error handling)
    log_info "Installing AI packages (this may take several minutes)..."
    safe_install "OpenAI Whisper" "pip install openai-whisper" "python -c 'import whisper'" false
    safe_install "PyTorch CPU" "pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu" "python -c 'import torch'" false
    
    deactivate
}

install_ollama() {
    log_info "Installing Ollama..."
    
    if command -v ollama >/dev/null 2>&1; then
        log_success "Ollama already installed"
        return 0
    fi
    
    # Download and install Ollama
    safe_install "Ollama" "curl -fsSL https://ollama.ai/install.sh | sh" "command -v ollama"
    
    # Start Ollama service
    if systemctl --user enable ollama 2>/dev/null; then
        systemctl --user start ollama 2>/dev/null || log_warning "Could not start Ollama service"
    else
        log_info "Ollama service setup skipped (may need manual start)"
    fi
    
    # Test Ollama installation
    sleep 2
    if ollama --version >/dev/null 2>&1; then
        log_success "Ollama installation verified"
    else
        log_warning "Ollama installed but may need manual configuration"
    fi
}

install_docker() {
    log_info "Installing Docker..."
    
    if command -v docker >/dev/null 2>&1; then
        log_success "Docker already installed"
    else
        case "$PKG_MGR" in
            "apt")
                # Official Docker installation for Ubuntu/Debian
                safe_install "Docker GPG key" "curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg" "[ -f /usr/share/keyrings/docker-archive-keyring.gpg ]"
                safe_install "Docker repository" "echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DISTRO $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list" "grep -q docker /etc/apt/sources.list.d/docker.list"
                safe_install "Docker package update" "sudo apt-get update" "apt-cache search docker-ce | grep -q docker-ce"
                safe_install "Docker CE" "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin" "command -v docker"
                ;;
            "dnf"|"yum")
                safe_install "Docker" "sudo $PKG_MGR install -y docker docker-compose" "command -v docker"
                ;;
            "pacman")
                safe_install "Docker" "sudo pacman -S --noconfirm docker docker-compose" "command -v docker"
                ;;
            *)
                log_warning "Manual Docker installation may be required"
                ;;
        esac
    fi
    
    # Enable and start Docker service
    safe_install "Docker service" "sudo systemctl enable --now docker" "systemctl is-active docker"
    
    # Add user to docker group
    if ! groups | grep -q docker; then
        safe_install "Docker group membership" "sudo usermod -aG docker $USER" "sudo grep -q $USER /etc/group | grep docker" false
        log_warning "You need to logout and login again for Docker group membership to take effect"
    fi
}

install_additional_tools() {
    log_info "Installing additional tools..."
    
    # Database tools
    case "$PKG_MGR" in
        "apt")
            safe_install "SQLite" "sudo apt-get install -y sqlite3" "command -v sqlite3"
            safe_install "PostgreSQL client" "sudo apt-get install -y postgresql-client" "command -v psql" false
            ;;
        "dnf"|"yum")
            safe_install "SQLite" "sudo $PKG_MGR install -y sqlite" "command -v sqlite3"
            safe_install "PostgreSQL client" "sudo $PKG_MGR install -y postgresql" "command -v psql" false
            ;;
        "pacman")
            safe_install "SQLite" "sudo pacman -S --noconfirm sqlite" "command -v sqlite3"
            safe_install "PostgreSQL client" "sudo pacman -S --noconfirm postgresql" "command -v psql" false
            ;;
    esac
    
    # Audio system setup
    case "$PKG_MGR" in
        "apt")
            safe_install "PulseAudio" "sudo apt-get install -y pulseaudio pulseaudio-utils" "command -v pulseaudio" false
            ;;
        "dnf"|"yum")
            safe_install "PulseAudio" "sudo $PKG_MGR install -y pulseaudio pulseaudio-utils" "command -v pulseaudio" false
            ;;
        "pacman")
            safe_install "PulseAudio" "sudo pacman -S --noconfirm pulseaudio pulseaudio-alsa" "command -v pulseaudio" false
            ;;
    esac
}

verify_installation() {
    log_info "Verifying installation..."
    
    local verification_passed=0
    local verification_total=0
    
    # Core tools verification
    local core_tools=("curl" "wget" "git" "python3" "pip3" "gcc" "make")
    for tool in "${core_tools[@]}"; do
        ((verification_total++))
        if command -v "$tool" >/dev/null 2>&1; then
            ((verification_passed++))
            log_success "$tool verified"
        else
            log_error "$tool verification failed"
        fi
    done
    
    # Python packages verification
    VENV_DIR="$HOME/.local/share/bill-sloth/venv"
    if [ -d "$VENV_DIR" ]; then
        source "$VENV_DIR/bin/activate"
        
        local python_packages=("requests" "numpy" "pandas")
        for package in "${python_packages[@]}"; do
            ((verification_total++))
            if python -c "import $package" 2>/dev/null; then
                ((verification_passed++))
                log_success "Python $package verified"
            else
                log_warning "Python $package not available"
            fi
        done
        
        deactivate
    fi
    
    # Optional tools verification
    local optional_tools=("ollama" "docker" "sqlite3")
    for tool in "${optional_tools[@]}"; do
        ((verification_total++))
        if command -v "$tool" >/dev/null 2>&1; then
            ((verification_passed++))
            log_success "$tool verified"
        else
            log_warning "$tool not available (optional)"
        fi
    done
    
    local verification_rate=$((verification_passed * 100 / verification_total))
    log_info "Verification complete: $verification_passed/$verification_total tools available ($verification_rate%)"
    
    return 0
}

create_environment_setup() {
    log_info "Creating environment setup script..."
    
    local env_script="$HOME/.local/share/bill-sloth/environment.sh"
    mkdir -p "$(dirname "$env_script")"
    
    cat > "$env_script" << EOF
#!/bin/bash
# Bill Sloth Environment Setup
# Source this script to set up the Bill Sloth environment

# Virtual environment
BILL_SLOTH_VENV="$HOME/.local/share/bill-sloth/venv"
if [ -d "\$BILL_SLOTH_VENV" ]; then
    source "\$BILL_SLOTH_VENV/bin/activate"
fi

# Add local bin to PATH
if [ -d "\$HOME/.local/bin" ]; then
    export PATH="\$HOME/.local/bin:\$PATH"
fi

# Bill Sloth specific environment variables
export BILL_SLOTH_HOME="$HOME/.local/share/bill-sloth"
export BILL_SLOTH_CONFIG="\$BILL_SLOTH_HOME/config"
export BILL_SLOTH_DATA="\$BILL_SLOTH_HOME/data"
export BILL_SLOTH_LOGS="\$BILL_SLOTH_HOME/logs"

# Create directories if they don't exist
mkdir -p "\$BILL_SLOTH_CONFIG" "\$BILL_SLOTH_DATA" "\$BILL_SLOTH_LOGS"

echo "🚀 Bill Sloth environment activated"
echo "Python virtual environment: \$(which python 2>/dev/null || echo 'Not activated')"
echo "Bill Sloth home: \$BILL_SLOTH_HOME"
EOF
    
    chmod +x "$env_script"
    log_success "Environment setup script created: $env_script"
    
    # Add to bashrc if not already there
    if ! grep -q "bill-sloth/environment.sh" "$HOME/.bashrc" 2>/dev/null; then
        echo "" >> "$HOME/.bashrc"
        echo "# Bill Sloth environment" >> "$HOME/.bashrc"
        echo "source \"$env_script\"" >> "$HOME/.bashrc"
        log_success "Added Bill Sloth environment to .bashrc"
    fi
}

generate_installation_report() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local report_file="$HOME/.local/share/bill-sloth/installation_report.txt"
    
    mkdir -p "$(dirname "$report_file")"
    
    cat > "$report_file" << EOF
Bill Sloth Installation Report
==============================
Generated: $timestamp
System: $DISTRO $VERSION
Package Manager: $PKG_MGR

Installation Summary:
- Total installations attempted: $TOTAL_INSTALLS
- Successful installations: $INSTALL_SUCCESS
- Failed installations: $INSTALL_FAILURES
- Success rate: $(( INSTALL_SUCCESS * 100 / TOTAL_INSTALLS ))%

Installation Log: $INSTALL_LOG

Next Steps:
1. Logout and login again (for group memberships)
2. Run: source ~/.bashrc (to activate environment)
3. Test Bill Sloth components
4. Run dependency validator again for verification

EOF
    
    log_success "Installation report saved: $report_file"
}

main() {
    # Source aesthetic functions if available
    if [ -f "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh" ]; then
        source "$(dirname "$(dirname "${BASH_SOURCE[0]}")")/lib/aesthetic_functions.sh"
        show_module_banner "BILL SLOTH DEPENDENCY INSTALLER" "Comprehensive installation for Linux deployment" "🚀"
    else
        echo -e "${CYAN}"
        cat << 'EOF'
╔══════════════════════════════════════════════════════════════════════════════╗
║                    🚀 BILL SLOTH DEPENDENCY INSTALLER 🚀                    ║
║                                                                              ║
║              Comprehensive installation of all required dependencies         ║
║                        for Bill Sloth Linux deployment                       ║
╚══════════════════════════════════════════════════════════════════════════════╝
EOF
        echo -e "${NC}"
    fi
    
    # Initialize log
    echo "Bill Sloth Dependency Installation Log" > "$INSTALL_LOG"
    echo "Started: $(date)" >> "$INSTALL_LOG"
    echo "==========================================" >> "$INSTALL_LOG"
    
    log_info "Starting Bill Sloth dependency installation..."
    
    # Detect system
    detect_system
    
    # Check if running as root
    if [ "$EUID" -eq 0 ]; then
        log_error "Do not run this script as root! Use your regular user account."
        exit 1
    fi
    
    # Check sudo access
    if ! sudo -n true 2>/dev/null; then
        log_info "This script requires sudo access. You may be prompted for your password."
        sudo -v || {
            log_error "Sudo access required but not available"
            exit 1
        }
    fi
    
    # Run installations with progress feedback
    if command -v show_thinking >/dev/null 2>&1; then
        show_thinking "Preparing installation sequence"
        sleep 1
    fi
    
    update_package_manager
    install_system_essentials
    install_python_packages
    install_ollama
    install_docker
    install_additional_tools
    
    # Post-installation setup
    create_environment_setup
    verify_installation
    generate_installation_report
    
    # Final summary
    echo ""
    log_info "Installation completed!"
    log_info "Success: $INSTALL_SUCCESS, Failures: $INSTALL_FAILURES, Total: $TOTAL_INSTALLS"
    
    if [ $INSTALL_FAILURES -eq 0 ]; then
        if command -v show_celebration >/dev/null 2>&1; then
            show_celebration
        fi
        log_success "🎉 All dependencies installed successfully!"
        log_info "Logout and login again, then run the Bill Sloth dependency validator to verify."
    else
        log_warning "Some installations failed. Check the installation log for details."
        log_info "Installation log: $INSTALL_LOG"
    fi
    
    log_info "Environment setup: source ~/.bashrc"
    log_info "Installation report: $HOME/.local/share/bill-sloth/installation_report.txt"
}

# Trap to ensure cleanup on exit
trap 'echo "Installation interrupted" >> "$INSTALL_LOG"' INT TERM

# Run main function
main "$@"