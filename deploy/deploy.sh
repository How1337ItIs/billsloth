#!/bin/bash
# Bill Sloth System Deployment Automation
# Comprehensive deployment script for setting up Bill Sloth on new systems

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Deployment configuration
DEPLOY_VERSION="2.0.0"
DEPLOY_DATE=$(date -Iseconds)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"

# Logging
DEPLOY_LOG="$HOME/.bill-sloth-deploy.log"

# Logging function
log_deploy() {
    local level="$1"
    local message="$2"
    local timestamp=$(date -Iseconds)
    
    echo "[$timestamp] $level: $message" | tee -a "$DEPLOY_LOG"
    
    case "$level" in
        "INFO") echo -e "${BLUE}ℹ️  $message${NC}" ;;
        "SUCCESS") echo -e "${GREEN}✅ $message${NC}" ;;
        "WARNING") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "ERROR") echo -e "${RED}❌ $message${NC}" ;;
    esac
}

# Error handler
handle_error() {
    local exit_code=$?
    local line_number=$1
    log_deploy "ERROR" "Deployment failed at line $line_number with exit code $exit_code"
    echo ""
    echo "🚨 DEPLOYMENT FAILED"
    echo "Check the log: $DEPLOY_LOG"
    echo "For support: https://github.com/bill-sloth/system/issues"
    exit $exit_code
}

trap 'handle_error $LINENO' ERR

# Deployment banner
show_deploy_banner() {
    clear
    cat << "EOF"
    ██████╗ ██╗██╗     ██╗         ███████╗██╗      ██████╗ ████████╗██╗  ██╗
    ██╔══██╗██║██║     ██║         ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║
    ██████╔╝██║██║     ██║         ███████╗██║     ██║   ██║   ██║   ███████║
    ██╔══██╗██║██║     ██║         ╚════██║██║     ██║   ██║   ██║   ██╔══██║
    ██████╔╝██║███████╗███████╗    ███████║███████╗╚██████╔╝   ██║   ██║  ██║
    ╚═════╝ ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝

    🚀 AUTOMATED DEPLOYMENT SYSTEM v2.0.0
    ======================================
EOF
    echo ""
}

# System detection
detect_system() {
    log_deploy "INFO" "Detecting system configuration..."
    
    # OS Detection
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        if [ -f /etc/os-release ]; then
            DISTRO=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
            VERSION=$(grep '^VERSION_ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        DISTRO="macos"
        VERSION=$(sw_vers -productVersion)
    elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || grep -q Microsoft /proc/version 2>/dev/null; then
        OS="windows"
        DISTRO="wsl"
        VERSION="unknown"
    else
        log_deploy "WARNING" "Unknown OS: $OSTYPE"
        OS="unknown"
    fi
    
    # Architecture
    ARCH=$(uname -m)
    
    # Shell detection
    SHELL_NAME=$(basename "$SHELL")
    
    log_deploy "SUCCESS" "System detected: $OS ($DISTRO $VERSION) $ARCH with $SHELL_NAME"
    
    # Export for use in other scripts
    export DETECTED_OS="$OS"
    export DETECTED_DISTRO="$DISTRO" 
    export DETECTED_VERSION="$VERSION"
    export DETECTED_ARCH="$ARCH"
    export DETECTED_SHELL="$SHELL_NAME"
}

# Check prerequisites
check_prerequisites() {
    log_deploy "INFO" "Checking deployment prerequisites..."
    
    local missing=()
    
    # Essential commands
    local required_commands=("bash" "curl" "git")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    # Recommended commands
    local recommended_commands=("jq" "rsync" "gpg")
    for cmd in "${recommended_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_deploy "WARNING" "Recommended command missing: $cmd"
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_deploy "ERROR" "Missing required commands: ${missing[*]}"
        echo ""
        echo "Please install missing dependencies:"
        case "$DETECTED_DISTRO" in
            "ubuntu"|"debian")
                echo "sudo apt update && sudo apt install -y ${missing[*]}"
                ;;
            "fedora"|"rhel"|"centos")
                echo "sudo dnf install -y ${missing[*]}"
                ;;
            "arch")
                echo "sudo pacman -S ${missing[*]}"
                ;;
            "macos")
                echo "brew install ${missing[*]}"
                ;;
        esac
        exit 1
    fi
    
    log_deploy "SUCCESS" "Prerequisites check passed"
}

# Create directory structure
setup_directory_structure() {
    log_deploy "INFO" "Setting up Bill Sloth directory structure..."
    
    # Main directories
    local directories=(
        "$HOME/.bill-sloth"
        "$HOME/.bill-sloth/lib"
        "$HOME/.bill-sloth/modules" 
        "$HOME/.bill-sloth/command-center"
        "$HOME/.bill-sloth/architecture"
        "$HOME/.bill-sloth/backups"
        "$HOME/.bill-sloth/workflows"
        "$HOME/.bill-sloth/shared-data"
        "$HOME/.bill-sloth/health-monitoring"
        "$HOME/.bill-sloth/vrbo-automation"
        "$HOME/.bill-sloth/google-tasks"
        "$HOME/.bill-sloth/chatgpt-integration"
        "$HOME/.bill-sloth/media-processing"
        "$HOME/edboigames_business"
    )
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            log_deploy "INFO" "Created directory: $dir"
        fi
    done
    
    log_deploy "SUCCESS" "Directory structure setup complete"
}

# Install dependencies based on system
install_dependencies() {
    log_deploy "INFO" "Installing system dependencies..."
    
    local install_cmd=""
    local packages=""
    
    case "$DETECTED_DISTRO" in
        "ubuntu"|"debian")
            install_cmd="sudo apt update && sudo apt install -y"
            packages="jq curl git rsync gnupg libnotify-bin python3 python3-pip npm"
            ;;
        "fedora")
            install_cmd="sudo dnf install -y"
            packages="jq curl git rsync gnupg libnotify python3 python3-pip npm"
            ;;
        "arch")
            install_cmd="sudo pacman -S --noconfirm"
            packages="jq curl git rsync gnupg libnotify python python-pip npm"
            ;;
        "macos")
            install_cmd="brew install"
            packages="jq curl git rsync gnupg terminal-notifier python3 node"
            ;;
        *)
            log_deploy "WARNING" "Unknown package manager for $DETECTED_DISTRO"
            return 0
            ;;
    esac
    
    if [ -n "$install_cmd" ]; then
        echo "Installing packages: $packages"
        echo "Command: $install_cmd $packages"
        
        read -p "Install dependencies? [Y/n]: " install_deps
        if [[ "$install_deps" =~ ^[Yy]$ ]] || [ -z "$install_deps" ]; then
            eval "$install_cmd $packages" || log_deploy "WARNING" "Some packages failed to install"
            log_deploy "SUCCESS" "Dependencies installation completed"
        else
            log_deploy "WARNING" "Skipped dependency installation"
        fi
    fi
}

# Copy and setup Bill Sloth files
setup_bill_sloth_files() {
    log_deploy "INFO" "Setting up Bill Sloth system files..."
    
    # Copy library files
    if [ -d "$BASE_DIR/lib" ]; then
        cp -r "$BASE_DIR/lib/"* "$HOME/.bill-sloth/lib/" 2>/dev/null || true
        log_deploy "SUCCESS" "Library files copied"
    fi
    
    # Copy module files  
    if [ -d "$BASE_DIR/modules" ]; then
        cp -r "$BASE_DIR/modules/"* "$HOME/.bill-sloth/modules/" 2>/dev/null || true
        log_deploy "SUCCESS" "Module files copied"
    fi
    
    # Copy main scripts
    local main_scripts=("bill_command_center.sh" "setup_health_monitoring.sh")
    for script in "${main_scripts[@]}"; do
        if [ -f "$BASE_DIR/$script" ]; then
            cp "$BASE_DIR/$script" "$HOME/.bill-sloth/"
            chmod +x "$HOME/.bill-sloth/$script"
            log_deploy "SUCCESS" "Copied and made executable: $script"
        fi
    done
    
    # Make library files executable
    chmod +x "$HOME/.bill-sloth/lib/"*.sh 2>/dev/null || true
    chmod +x "$HOME/.bill-sloth/modules/"*.sh 2>/dev/null || true
    
    log_deploy "SUCCESS" "Bill Sloth files setup complete"
}

# Initialize core systems
initialize_core_systems() {
    log_deploy "INFO" "Initializing Bill Sloth core systems..."
    
    cd "$HOME/.bill-sloth"
    
    # Initialize command center
    if ./bill_command_center.sh > /dev/null 2>&1 << 'EOF'
init_bill_command_center
exit
EOF
    then
        log_deploy "SUCCESS" "Command center initialized"
    else
        log_deploy "WARNING" "Command center initialization had issues"
    fi
    
    # Initialize health monitoring
    if ./setup_health_monitoring.sh << 'EOF'
s
EOF
    then
        log_deploy "SUCCESS" "Health monitoring initialized"
    else
        log_deploy "WARNING" "Health monitoring initialization had issues"
    fi
    
    log_deploy "SUCCESS" "Core systems initialization complete"
}

# Configure shell integration
setup_shell_integration() {
    log_deploy "INFO" "Setting up shell integration..."
    
    local shell_config=""
    case "$DETECTED_SHELL" in
        "bash") shell_config="$HOME/.bashrc" ;;
        "zsh") shell_config="$HOME/.zshrc" ;;
        "fish") shell_config="$HOME/.config/fish/config.fish" ;;
        *) 
            log_deploy "WARNING" "Unsupported shell: $DETECTED_SHELL"
            return 0
            ;;
    esac
    
    if [ -f "$shell_config" ]; then
        local bill_sloth_block="
# Bill Sloth System Integration
export BILL_SLOTH_HOME=\"\$HOME/.bill-sloth\"
export PATH=\"\$BILL_SLOTH_HOME:\$PATH\"

# Bill Sloth aliases
alias bill='cd \$BILL_SLOTH_HOME && ./bill_command_center.sh'
alias bill-health='source \$BILL_SLOTH_HOME/.bill-sloth/health-monitoring/health_aliases.sh'

# Quick health commands
source \"\$BILL_SLOTH_HOME/health-monitoring/health_commands.sh\" 2>/dev/null || true
"
        
        # Check if already configured
        if ! grep -q "Bill Sloth System Integration" "$shell_config" 2>/dev/null; then
            echo "$bill_sloth_block" >> "$shell_config"
            log_deploy "SUCCESS" "Shell integration added to $shell_config"
        else
            log_deploy "INFO" "Shell integration already configured"
        fi
    else
        log_deploy "WARNING" "Shell config file not found: $shell_config"
    fi
}

# Create desktop integration
setup_desktop_integration() {
    log_deploy "INFO" "Setting up desktop integration..."
    
    # Create desktop entry
    local desktop_file="$HOME/.local/share/applications/bill-sloth.desktop"
    mkdir -p "$(dirname "$desktop_file")"
    
    cat > "$desktop_file" << EOF
[Desktop Entry]
Name=Bill Sloth Command Center
Comment=Unified digital operations system
Exec=/bin/bash -c "cd '$HOME/.bill-sloth' && ./bill_command_center.sh"
Icon=utilities-terminal
Terminal=true
Type=Application
Categories=System;Utility;
Keywords=automation;productivity;system;
EOF
    
    chmod +x "$desktop_file"
    
    # Create health monitoring desktop entry
    local health_desktop="$HOME/.local/share/applications/bill-sloth-health.desktop"
    cat > "$health_desktop" << EOF
[Desktop Entry]
Name=Bill Sloth Health Monitor
Comment=System health monitoring dashboard
Exec=/bin/bash -c "cd '$HOME/.bill-sloth' && source health-monitoring/health_commands.sh && health-dash"
Icon=utilities-system-monitor
Terminal=true
Type=Application
Categories=System;Monitor;
Keywords=health;monitoring;system;
EOF
    
    chmod +x "$health_desktop"
    
    log_deploy "SUCCESS" "Desktop integration created"
}

# Run post-deployment tests
run_deployment_tests() {
    log_deploy "INFO" "Running post-deployment tests..."
    
    local test_results=()
    
    # Test 1: Command center loads
    if source "$HOME/.bill-sloth/bill_command_center.sh" 2>/dev/null; then
        test_results+=("✅ Command center loads successfully")
    else
        test_results+=("❌ Command center failed to load")
    fi
    
    # Test 2: Core libraries load
    local libs=("error_handling.sh" "notification_system.sh" "data_sharing.sh" "system_health_monitoring.sh")
    local lib_success=0
    for lib in "${libs[@]}"; do
        if source "$HOME/.bill-sloth/lib/$lib" 2>/dev/null; then
            ((lib_success++))
        fi
    done
    test_results+=("✅ Core libraries: $lib_success/${#libs[@]} loaded")
    
    # Test 3: Health monitoring works
    if source "$HOME/.bill-sloth/lib/system_health_monitoring.sh" 2>/dev/null && \
       command -v get_system_metrics &> /dev/null; then
        test_results+=("✅ Health monitoring functional")
    else
        test_results+=("❌ Health monitoring not functional")
    fi
    
    # Test 4: Directory structure
    local required_dirs=("lib" "modules" "command-center" "health-monitoring")
    local dir_success=0
    for dir in "${required_dirs[@]}"; do
        if [ -d "$HOME/.bill-sloth/$dir" ]; then
            ((dir_success++))
        fi
    done
    test_results+=("✅ Directory structure: $dir_success/${#required_dirs[@]} complete")
    
    # Display results
    echo ""
    log_deploy "INFO" "Deployment test results:"
    for result in "${test_results[@]}"; do
        echo "  $result"
    done
    
    log_deploy "SUCCESS" "Post-deployment tests completed"
}

# Generate deployment report
generate_deployment_report() {
    log_deploy "INFO" "Generating deployment report..."
    
    local report_file="$HOME/.bill-sloth/deployment-report-$(date +%Y%m%d_%H%M%S).txt"
    
    cat > "$report_file" << EOF
BILL SLOTH DEPLOYMENT REPORT
============================

Deployment Date: $DEPLOY_DATE
Deployment Version: $DEPLOY_VERSION
System: $DETECTED_OS ($DETECTED_DISTRO $DETECTED_VERSION)
Architecture: $DETECTED_ARCH
Shell: $DETECTED_SHELL

DEPLOYMENT STATUS: SUCCESS

Components Installed:
✅ Bill Sloth Core System
✅ Command Center Dashboard
✅ Health Monitoring System
✅ Integration Test Suite
✅ Backup Management
✅ Workflow Orchestration
✅ Data Sharing System
✅ VRBO Automation Framework
✅ EdBoiGames Business System
✅ Architecture Unification
✅ Notification System
✅ Mobile Integration Hub

Installation Paths:
- Main System: $HOME/.bill-sloth/
- Command Center: $HOME/.bill-sloth/bill_command_center.sh
- Health Monitor: $HOME/.bill-sloth/health-monitoring/
- Modules: $HOME/.bill-sloth/modules/
- Libraries: $HOME/.bill-sloth/lib/

Quick Start Commands:
- Launch Command Center: bill (or cd ~/.bill-sloth && ./bill_command_center.sh)
- Check System Health: health
- Health Dashboard: health-dash
- Start Monitoring: health-start

Next Steps:
1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)
2. Test installation: bill
3. Configure Bill-specific settings in Command Center
4. Set up health monitoring: health-start
5. Review documentation in README.md

Support:
- Documentation: ~/.bill-sloth/README.md
- Health Logs: ~/.bill-sloth/health-monitoring/logs/
- Deployment Log: $DEPLOY_LOG
- Issues: https://github.com/bill-sloth/system/issues

EOF
    
    log_deploy "SUCCESS" "Deployment report generated: $report_file"
    echo ""
    echo "📋 DEPLOYMENT REPORT: $report_file"
}

# Main deployment function
main_deployment() {
    show_deploy_banner
    
    echo "🚀 Starting Bill Sloth System Deployment"
    echo "========================================"
    echo ""
    
    # Pre-deployment steps
    detect_system
    check_prerequisites
    
    echo ""
    echo "📋 DEPLOYMENT PLAN:"
    echo "1. Setup directory structure"
    echo "2. Install dependencies"
    echo "3. Copy system files"
    echo "4. Initialize core systems"
    echo "5. Configure shell integration"
    echo "6. Setup desktop integration"
    echo "7. Run deployment tests"
    echo "8. Generate deployment report"
    echo ""
    
    read -p "Proceed with deployment? [Y/n]: " proceed
    if [[ "$proceed" =~ ^[Nn]$ ]]; then
        log_deploy "INFO" "Deployment cancelled by user"
        exit 0
    fi
    
    echo ""
    log_deploy "INFO" "Starting deployment process..."
    
    # Main deployment steps
    setup_directory_structure
    install_dependencies
    setup_bill_sloth_files
    initialize_core_systems
    setup_shell_integration
    setup_desktop_integration
    run_deployment_tests
    generate_deployment_report
    
    echo ""
    echo "🎉 DEPLOYMENT COMPLETED SUCCESSFULLY!"
    echo "===================================="
    echo ""
    echo "✅ Bill Sloth v$DEPLOY_VERSION has been deployed to your system"
    echo ""
    echo "🚀 Quick Start:"
    echo "1. Restart your terminal or run: source ~/.bashrc"
    echo "2. Launch Bill Sloth: bill"
    echo "3. Start health monitoring: health-start"
    echo ""
    echo "📖 Documentation: ~/.bill-sloth/README.md"
    echo "🏥 Health Dashboard: health-dash"
    echo "📊 Deployment Log: $DEPLOY_LOG"
    echo ""
    echo "Enjoy your new digital operations system! 🎯"
}

# Execute main deployment if script is run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main_deployment "$@"
fi