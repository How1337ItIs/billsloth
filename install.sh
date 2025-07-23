#!/bin/bash
# Bill Sloth Complete System Installer
# One-command setup for the entire adaptive Linux power-user system


set -euo pipefail

BILL_SLOTH_VERSION="2.0-adaptive"
INSTALL_LOG="$HOME/bill-sloth-install.log"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" >> "$INSTALL_LOG"
    echo -e "$1"
}

print_header() {
    clear
    echo -e "${CYAN}"
    cat << 'EOF'
   ____  _ _ _    ____  _       _   _     
  |  _ \(_) | |  / ___|| | ___ | |_| |__  
  | |_) | | | |  \___ \| |/ _ \| __| '_ \ 
  |  _ <| | | |   ___) | | (_) | |_| | | |
  |_| \_\_|_|_|  |____/|_|\___/ \__|_| |_|
                                         
EOF
    echo -e "${NC}"
    echo -e "${PURPLE}🦥 Bill Sloth Linux Power-User System v${BILL_SLOTH_VERSION}${NC}"
    echo -e "${BLUE}The First Adaptive Linux Toolkit That Learns Your Workflow${NC}"
    echo ""
}

check_system() {
    log "🔍 Checking system compatibility..."
    
    # Check if Linux
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        log "${RED}❌ This installer is designed for Linux systems${NC}"
        exit 1
    fi
    
    # Check if bash 4+
    if (( BASH_VERSINFO[0] < 4 )); then
        log "${RED}❌ Bash 4.0+ required. Current version: $BASH_VERSION${NC}"
        exit 1
    fi
    
    # Check internet connectivity
    if ! ping -c 1 google.com &> /dev/null; then
        log "${YELLOW}⚠️  No internet connection detected. Some features may not install properly.${NC}"
    fi
    
    log "${GREEN}✅ System compatibility check passed${NC}"
}

install_dependencies() {
    log "📦 Installing system dependencies..."
    
    # Detect package manager
    if command -v apt &> /dev/null; then
        PACKAGE_MANAGER="apt"
        INSTALL_CMD="sudo apt update && sudo apt install -y"
    elif command -v dnf &> /dev/null; then
        PACKAGE_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    elif command -v pacman &> /dev/null; then
        PACKAGE_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    else
        log "${RED}❌ No supported package manager found (apt, dnf, or pacman)${NC}"
        exit 1
    fi
    
    log "Using package manager: $PACKAGE_MANAGER"
    
    # Core dependencies
    CORE_DEPS="curl wget git bc jq"
    
    # Power-user tool dependencies  
    POWER_DEPS="rofi copyq fd-find ripgrep fzf tree ncdu rsync"
    
    # Security tool dependencies
    SECURITY_DEPS="nmap wireshark nikto john hashcat"
    
    # Install core dependencies (required)
    log "Installing core dependencies: $CORE_DEPS"
    eval "$INSTALL_CMD $CORE_DEPS" || {
        log "${RED}❌ Failed to install core dependencies${NC}"
        exit 1
    }
    
    # Install power-user tools (optional)
    log "Installing power-user tools: $POWER_DEPS"
    eval "$INSTALL_CMD $POWER_DEPS" || {
        log "${YELLOW}⚠️  Some power-user tools failed to install - continuing anyway${NC}"
    }
    
    # Install security tools (optional)
    log "Installing security tools: $SECURITY_DEPS"
    eval "$INSTALL_CMD $SECURITY_DEPS" || {
        log "${YELLOW}⚠️  Some security tools failed to install - continuing anyway${NC}"
    }
    
    log "${GREEN}✅ Dependencies installation completed${NC}"
}

check_nodejs() {
    log "🟢 Checking Node.js installation..."
    
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version | cut -d'v' -f2)
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1)
        
        if [ "$MAJOR_VERSION" -ge 18 ]; then
            log "${GREEN}✅ Node.js $NODE_VERSION is compatible${NC}"
            return 0
        else
            log "${YELLOW}⚠️  Node.js $NODE_VERSION found, but version 18+ required${NC}"
        fi
    else
        log "${YELLOW}⚠️  Node.js not found${NC}"
    fi
    
    log "📥 Installing Node.js 18..."
    
    # Install Node.js via NodeSource
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs || {
        log "${RED}❌ Failed to install Node.js${NC}"
        exit 1
    }
    
    log "${GREEN}✅ Node.js installation completed${NC}"
}

check_claude_code() {
    log "🤖 Checking Claude Code CLI..."
    
    if command -v claude &> /dev/null; then
        log "${GREEN}✅ Claude Code CLI is already installed${NC}"
        return 0
    fi
    
    log "📥 Installing Claude Code CLI..."
    
    # Install Claude Code
    npm install -g @anthropic-ai/claude-code || {
        log "${RED}❌ Failed to install Claude Code CLI${NC}"
        log "${YELLOW}Please install manually: npm install -g @anthropic-ai/claude-code${NC}"
        return 1
    }
    
    log "${GREEN}✅ Claude Code CLI installation completed${NC}"
    log "${BLUE}💡 Run 'claude' to authenticate with your Claude AI account${NC}"
}

setup_bill_sloth() {
    log "🦥 Setting up Bill Sloth system..."
    
    # Create Bill Sloth directory structure
    mkdir -p ~/.bill-sloth/{learning,usage,feedback,adaptations}
    mkdir -p ~/.local/bin
    mkdir -p ~/.config
    
    # Copy Bill Sloth files to system locations
    if [ -f "./bin/bill-sloth" ]; then
        cp ./bin/bill-sloth ~/.local/bin/
        chmod +x ~/.local/bin/bill-sloth
        log "✅ Bill Sloth command installed"
    fi
    
    # Add ~/.local/bin to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
        log "✅ Added ~/.local/bin to PATH"
    fi
    
    # Initialize adaptive learning system
    if [ -f "./lib/adaptive_learning.sh" ]; then
        source ./lib/adaptive_learning.sh
        initialize_adaptive_system
        log "✅ Adaptive learning system initialized"
    fi
    
    log "${GREEN}✅ Bill Sloth system setup completed${NC}"
}

run_health_check() {
    log "🔍 Running system health check..."
    
    if [ -f "./scripts/health_check.sh" ]; then
        chmod +x ./scripts/health_check.sh
        ./scripts/health_check.sh | tee -a "$INSTALL_LOG"
    else
        log "${YELLOW}⚠️  Health check script not found${NC}"
    fi
}

enhance_existing_modules() {
    log "🧠 Enhancing modules with adaptive learning..."
    
    if [ -f "./scripts/batch_enhance_modules.sh" ]; then
        chmod +x ./scripts/batch_enhance_modules.sh
        ./scripts/batch_enhance_modules.sh | tee -a "$INSTALL_LOG"
        log "${GREEN}✅ Modules enhanced with adaptive learning${NC}"
    else
        log "${YELLOW}⚠️  Batch enhancement script not found${NC}"
    fi
}

show_completion_message() {
    clear
    print_header
    
    echo -e "${GREEN}🎉 BILL SLOTH INSTALLATION COMPLETE!${NC}"
    echo -e "${GREEN}====================================${NC}"
    echo ""
    
    echo -e "${BLUE}🚀 Your Linux system is now a powerful, adaptive toolkit that learns your workflow!${NC}"
    echo ""
    
    echo -e "${CYAN}🎯 WHAT YOU CAN DO NOW:${NC}"
    echo ""
    
    echo -e "${YELLOW}📋 Power-User Tools:${NC}"
    echo "   clipboard_mastery_interactive    # Advanced clipboard with AI"
    echo "   text_expansion_interactive       # Smart text expansion"
    echo "   file_mastery_interactive         # Lightning-fast file operations"
    echo "   launcher_mastery_interactive     # AI-powered app launcher"
    echo "   system_doctor_interactive        # System diagnostics"
    echo ""
    
    echo -e "${YELLOW}🛡️  Security Tools:${NC}"
    echo "   defensive_cyber_interactive      # Ethical hacking toolkit"
    echo ""
    
    echo -e "${YELLOW}🧠 Adaptive Learning:${NC}"
    echo "   bill-sloth dashboard            # View learning insights"
    echo "   adapt-modules status            # Check module satisfaction"
    echo ""
    
    echo -e "${YELLOW}🔧 System Management:${NC}"
    echo "   ./scripts/health_check.sh       # Verify system health"
    echo ""
    
    echo -e "${PURPLE}💡 GETTING STARTED:${NC}"
    echo ""
    echo "1. ${CYAN}Authenticate Claude Code:${NC}"
    echo "   claude"
    echo ""
    echo "2. ${CYAN}Try your first module:${NC}"
    echo "   clipboard_mastery_interactive"
    echo ""
    echo "3. ${CYAN}See what's possible:${NC}"
    echo "   claude 'Show me what Bill Sloth can do'"
    echo ""
    
    if [ -f "$INSTALL_LOG" ]; then
        echo -e "${BLUE}📋 Installation log saved to: $INSTALL_LOG${NC}"
    fi
    
    echo ""
    echo -e "${GREEN}Welcome to your new adaptive Linux power-user system! 🦥➡️🚀${NC}"
}

# Main installation flow
main() {
    print_header
    
    log "🚀 Starting Bill Sloth installation..."
    log "Installation log: $INSTALL_LOG"
    
    echo -e "${BLUE}This will install the complete Bill Sloth adaptive Linux power-user system.${NC}"
    echo ""
    echo -e "${YELLOW}Components to install:${NC}"
    echo "• Adaptive learning system"
    echo "• Windows power-user tool equivalents"
    echo "• Ethical hacking security toolkit"
    echo "• AI-powered automation and workflows"
    echo "• System diagnostics and health monitoring"
    echo ""
    
    read -p "Continue with installation? (y/n): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log "❌ Installation cancelled by user"
        exit 0
    fi
    
    echo ""
    log "🎯 Starting installation process..."
    
    # Run installation steps
    check_system
    install_dependencies
    check_nodejs
    check_claude_code
    setup_bill_sloth
    enhance_existing_modules
    run_health_check
    
    log "✅ Installation completed successfully"
    
    show_completion_message
}

# Run main installation
main "$@"