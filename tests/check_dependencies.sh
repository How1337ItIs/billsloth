#!/bin/bash
# Check required dependencies for Bill Sloth system

echo "======================================"
echo "Bill Sloth Dependency Check"
echo "======================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check function
check_command() {
    local cmd="$1"
    local desc="$2"
    local install_hint="$3"
    
    echo -n "Checking $desc ($cmd)... "
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}INSTALLED${NC}"
        return 0
    else
        echo -e "${RED}MISSING${NC}"
        echo "  Install with: $install_hint"
        return 1
    fi
}

# Required dependencies
echo "Required Dependencies:"
echo "---------------------"
check_command "bash" "Bash shell" "Already installed"
check_command "jq" "JSON processor" "sudo apt install jq"
check_command "curl" "URL transfer tool" "sudo apt install curl"
check_command "git" "Version control" "sudo apt install git"
echo ""

# Optional but recommended
echo "Optional Dependencies:"
echo "---------------------"
check_command "rsync" "File sync tool" "sudo apt install rsync"
check_command "gpg" "Encryption tool" "sudo apt install gnupg"
check_command "rclone" "Cloud storage sync" "curl https://rclone.org/install.sh | sudo bash"
check_command "notify-send" "Desktop notifications" "sudo apt install libnotify-bin"
check_command "kdialog" "KDE dialogs" "sudo apt install kdialog"
check_command "zenity" "GTK dialogs" "sudo apt install zenity"
check_command "espeak" "Text-to-speech" "sudo apt install espeak"
echo ""

# Development tools
echo "Development Tools:"
echo "-----------------"
check_command "npm" "Node package manager" "sudo apt install npm"
check_command "python3" "Python 3" "sudo apt install python3"
check_command "pip3" "Python package manager" "sudo apt install python3-pip"
echo ""

# AI/ML tools (optional)
echo "AI/ML Tools (Optional):"
echo "----------------------"
check_command "ollama" "Local AI models" "curl -fsSL https://ollama.ai/install.sh | sh"
check_command "whisper" "Speech recognition" "pip3 install openai-whisper"
echo ""

# Quick install command
echo "======================================"
echo "Quick Install Commands:"
echo "======================================"
echo ""
echo "Essential packages (Ubuntu/Debian):"
echo -e "${YELLOW}sudo apt update && sudo apt install -y jq curl git rsync gnupg libnotify-bin${NC}"
echo ""
echo "All recommended packages:"
echo -e "${YELLOW}sudo apt update && sudo apt install -y jq curl git rsync gnupg libnotify-bin kdialog zenity espeak npm python3 python3-pip${NC}"
echo ""

# Windows/WSL specific
if grep -q Microsoft /proc/version 2>/dev/null; then
    echo "WSL Detected:"
    echo "------------"
    echo "For notifications to work in WSL, you may need:"
    echo "1. Windows Terminal notifications"
    echo "2. X11 server for Linux GUI apps"
    echo ""
fi