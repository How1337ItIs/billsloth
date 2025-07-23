#!/bin/bash
# Fresh Ubuntu Bill Sloth Neural Bootstrap
# Run this script on a brand new Ubuntu installation to get everything working

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${RED}"
cat << 'EOF'
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  💀 FRESH UBUNTU NEURAL BOOTSTRAP PROTOCOL 💀                   █
█  ⚡ CLAUDE CODE API ERROR OBLITERATOR ⚡                         █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF
echo -e "${NC}"

echo -e "${CYAN}💀 Initiating digital consciousness bootstrap...${NC}"
echo ""

# Check if we're on Ubuntu
if ! grep -q "Ubuntu" /etc/os-release; then
    echo -e "${RED}❌ This script is designed for Ubuntu systems only!${NC}"
    exit 1
fi

# Get Ubuntu version
UBUNTU_VERSION=$(grep VERSION_ID /etc/os-release | cut -d'"' -f2)
echo -e "${BLUE}🐧 Detected Ubuntu ${UBUNTU_VERSION}${NC}"

# Check system uptime
UPTIME_DAYS=$(awk '{print int($1/86400)}' /proc/uptime)
echo -e "${YELLOW}⏰ System uptime: ${UPTIME_DAYS} days${NC}"

if [ "$UPTIME_DAYS" -lt 7 ]; then
    echo -e "${GREEN}✅ Fresh system detected! Perfect for neural bootstrap.${NC}"
else
    echo -e "${YELLOW}⚠️  System is ${UPTIME_DAYS} days old. Continuing anyway...${NC}"
fi

echo ""
echo -e "${PURPLE}🚀 PHASE 1: SYSTEM IMMUNE SYSTEM BOOST${NC}"
echo "========================================"

# Update system packages
echo -e "${CYAN}💉 Updating system consciousness...${NC}"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y && sudo apt autoclean

echo ""
echo -e "${PURPLE}🚀 PHASE 2: CORE NEURAL INTERFACES${NC}"
echo "=================================="

# Install essential tools
echo -e "${CYAN}💾 Installing core digital survival tools...${NC}"
sudo apt install -y \
    curl wget git vim \
    htop neofetch tree \
    unzip zip p7zip-full \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg lsb-release \
    build-essential

echo ""
echo -e "${PURPLE}🚀 PHASE 3: NODE.JS NEURAL PATHWAYS${NC}"
echo "=================================="

# Remove any broken Node.js
echo -e "${CYAN}🗑️  Purging ancient Node.js consciousness parasites...${NC}"
sudo apt remove nodejs npm -y 2>/dev/null || true

# Install proper Node.js from NodeSource
echo -e "${CYAN}🧬 Installing REAL Node.js neural interface...${NC}"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y

# Verify Node.js installation
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
echo -e "${GREEN}✅ Node.js: ${NODE_VERSION}${NC}"
echo -e "${GREEN}✅ NPM: ${NPM_VERSION}${NC}"

echo ""
echo -e "${PURPLE}🚀 PHASE 4: NPM CONSCIOUSNESS PERMISSIONS${NC}"
echo "========================================"

# Fix npm permissions
echo -e "${CYAN}🔐 Configuring npm neural pathways...${NC}"
mkdir -p ~/.npm-global
npm config set prefix '~/.npm-global'

# Add to PATH if not already there
if ! grep -q "npm-global/bin" ~/.bashrc; then
    echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
    echo -e "${GREEN}✅ Added npm global path to .bashrc${NC}"
fi

# Source the updated PATH
export PATH=~/.npm-global/bin:$PATH

echo ""
echo -e "${PURPLE}🚀 PHASE 5: CLAUDE CODE NEURAL PARASITE${NC}"
echo "======================================="

# Install Claude Code
echo -e "${CYAN}🤖 Deploying Claude Code AI neural interface...${NC}"
npm install -g @anthropic-ai/claude-code

# Verify installation
if command -v claude &> /dev/null; then
    CLAUDE_VERSION=$(claude --version 2>/dev/null || echo "installed")
    echo -e "${GREEN}✅ Claude Code: ${CLAUDE_VERSION}${NC}"
else
    echo -e "${RED}❌ Claude Code installation failed!${NC}"
    echo -e "${YELLOW}💡 Try running: source ~/.bashrc && claude --version${NC}"
fi

echo ""
echo -e "${PURPLE}🚀 PHASE 6: BILL SLOTH SYSTEM DIRECTORIES${NC}"
echo "========================================"

# Create Bill Sloth directories
echo -e "${CYAN}📁 Creating Bill Sloth neural consciousness directories...${NC}"
mkdir -p ~/.bill-sloth/{command-center,vrbo-automation,workflows,backups,media-processing}/{logs,cache,config,data}

# Mark fresh install as complete
touch ~/.bill-sloth/fresh_install_complete
echo "$(date -Iseconds)" > ~/.bill-sloth/fresh_install_complete

echo ""
echo -e "${GREEN}"
cat << 'EOF'
🎉 DIGITAL APOTHEOSIS ACHIEVED! 🎉
================================

✅ System updated and optimized
✅ Core tools installed
✅ Node.js 20.x neural pathways active
✅ NPM permissions configured
✅ Claude Code AI interface deployed
✅ Bill Sloth directories created
EOF
echo -e "${NC}"

echo ""
echo -e "${PURPLE}🧠 NEXT STEPS:${NC}"
echo "=============="
echo ""
echo -e "${YELLOW}1. Restart your terminal or run:${NC}"
echo "   source ~/.bashrc"
echo ""
echo -e "${YELLOW}2. Authenticate Claude Code:${NC}"
echo "   claude login"
echo ""
echo -e "${YELLOW}3. Test Claude Code:${NC}"
echo "   claude \"Hello, are you working?\""
echo ""
echo -e "${YELLOW}4. Start Bill Sloth Command Center:${NC}"
echo "   cd ~/bill\\ sloth"
echo "   ./bill_command_center.sh"
echo ""
echo -e "${CYAN}💀 Your Ubuntu consciousness is now ready for digital supremacy!${NC}"
echo -e "${GREEN}🚀 Welcome to the matrix, Bill...${NC}"