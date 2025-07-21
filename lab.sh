#!/bin/bash
# BILL SLOTH LINUX LAB - Main Interface
# Designed for Claude Code execution and interpretation
# "The Matrix has you..." - Morpheus

# Cyber colors for terminal aesthetics
R='\033[0;31m'    # Red (Alert)
G='\033[0;32m'    # Green (Matrix)
B='\033[0;34m'    # Blue (Ice)
P='\033[1;35m'    # Purple (Neon)
C='\033[0;36m'    # Cyan (Ghost)
Y='\033[1;33m'    # Yellow (Warning)
M='\033[0;35m'    # Magenta
W='\033[1;37m'    # White
N='\033[0m'       # Reset

show_banner() {
    clear
    echo -e "${G}"
    cat << 'BANNER'
    ██████╗ ██╗██╗     ██╗         ███████╗██╗      ██████╗ ████████╗██╗  ██╗
    ██╔══██╗██║██║     ██║         ██╔════╝██║     ██╔═══██╗╚══██╔══╝██║  ██║
    ██████╔╝██║██║     ██║         ███████╗██║     ██║   ██║   ██║   ███████║
    ██╔══██╗██║██║     ██║         ╚════██║██║     ██║   ██║   ██║   ██╔══██║
    ██████╔╝██║███████╗███████╗    ███████║███████╗╚██████╔╝   ██║   ██║  ██║
    ╚═════╝ ╚═╝╚══════╝╚══════╝    ╚══════╝╚══════╝ ╚═════╝    ╚═╝   ╚═╝  ╚═╝
    
          L I N U X   L A B   【Linux初心者の助手】  
    ═══════════════════════════════════════════════════════════════════════════
BANNER
    echo -e "${N}"
    
    # Random anime quote for motivation
    if [ -f data/anime_quotes.txt ]; then
        echo -e "${C}$(shuf -n1 data/anime_quotes.txt)${N}\n"
    fi
    
    # System status with hacker aesthetic
    echo -e "${C}┌─[${G}SYSTEM STATUS${C}]──────────────────────────────────┐${N}"
    echo -e "${C}│${N} CPU: ${G}$(lscpu 2>/dev/null | grep 'Model name' | cut -d':' -f2 | xargs || echo 'Unknown')${N}"
    echo -e "${C}│${N} RAM: ${G}$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}' || echo 'Unknown')${N} [${Y}$(free -h 2>/dev/null | awk '/^Mem:/ {print $3}' || echo 'Unknown')${N} used]"
    echo -e "${C}│${N} NET: ${G}$(hostname -I 2>/dev/null | awk '{print $1}' || echo 'Offline')${N}"
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${C}│${N} GPU: ${G}$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)${N}"
    fi
    # VPN Status
    if ip addr | grep -q "tun\|wg"; then
        echo -e "${C}│${N} VPN: ${G}ACTIVE ${N}(safe to torrent)"
    else
        echo -e "${C}│${N} VPN: ${R}INACTIVE ${N}(connect before torrenting)"
    fi
    echo -e "${C}└────────────────────────────────────────────────┘${N}"
}

show_menu() {
    echo -e "\n${P}【WORK & PRODUCTIVITY】${N}"
    check_module "01" "🧠 PRODUCTIVITY SUITE" "ADHD tools, memory aids, focus timers" "productivity_suite"
    check_module "02" "🏖️ VACATION RENTAL MGR" "Guntersville Getaway management" "vacation_rental_manager"
    check_module "03" "🎮 EDBOIGAMES TOOLKIT" "YouTube BD, partnerships, content planning" "edboigames_toolkit"
    
    echo -e "\n${Y}【DATA & MEDIA】${N}"
    check_module "04" "🏴‍☠️ DATA HOARDING" "Torrenting, file organization, disk analytics" "data_hoarding"
    check_module "05" "🎥 STREAMING SETUP" "OBS, audio, scenes" "streaming_setup"
    check_module "06" "🤖 AI PLAYGROUND" "Ollama, Stable Diffusion, local AI" "ai_playground"
    
    echo -e "\n${B}【SYSTEM & TECH】${N}"
    check_module "07" "🔧 SYSTEM OPS" "Updates, fixes, maintenance" "system_ops"
    check_module "08" "🎮 GAMING BOOST" "Steam, performance optimization" "gaming_boost"
    check_module "09" "🛡️ PRIVACY TOOLS" "VPN, encryption, security" "privacy_tools"
    check_module "10" "🎨 CREATIVE CODING" "p5.js, Processing, digital art" "creative_coding"
    
    echo -e "\n${B}【UTILITIES】${N}"
    echo -e "   ${C}U${N}) 🔄 Update all modules (git pull)"
    echo -e "   ${C}A${N}) 📋 Show aliases and shortcuts"
    echo -e "   ${C}H${N}) ❓ Help and documentation"
    echo -e "   ${C}L${N}) 📜 View system logs"
    echo -e "   ${C}0${N}) 🚪 Exit lab"
    
    echo -ne "\n${G}bill@sloth${N}:${B}~/lab${N}$ "
}

check_module() {
    local num=$1
    local name=$2
    local desc=$3
    local module=$4
    
    if [ -f ~/.bill-sloth/${module}.installed ]; then
        echo -e "  ${num}) [${G}ACTIVE${N}] ${name} - ${desc}"
    else
        echo -e "  ${num}) [${R}OFFLINE${N}] ${name} - ${desc}"
    fi
}

install_module() {
    local module=$1
    echo -e "${C}[*] Initializing ${module} module...${N}"
    
    if [ -f modules/${module}.sh ]; then
        echo -e "${Y}[*] Claude Code should now read and execute this module${N}"
        echo -e "${G}[✓] Module structure loaded${N}"
        echo -e "${C}[*] This is where Claude Code takes over for intelligent execution${N}"
        touch ~/.bill-sloth/${module}.installed
        source modules/${module}.sh
    else
        echo -e "${R}[!] Module not found: modules/${module}.sh${N}"
        echo -e "${Y}[*] Available modules:${N}"
        ls -1 modules/ 2>/dev/null || echo "No modules directory found"
    fi
}

show_help() {
    echo -e "${B}┌─[${W}BILL SLOTH HELPER${B}]─────────────────────────────────┐${N}"
    echo -e "${B}│${N} This system is designed to work WITH Claude Code        ${B}│${N}"
    echo -e "${B}│${N} Claude Code reads these modules and executes them       ${B}│${N}"
    echo -e "${B}│${N} intelligently based on your current system state       ${B}│${N}"
    echo -e "${B}│${N}                                                        ${B}│${N}"
    echo -e "${B}│${N} ${G}Quick Commands to tell Claude Code:${N}                  ${B}│${N}"
    echo -e "${B}│${N} - 'Run my productivity suite'                          ${B}│${N}"
    echo -e "${B}│${N} - 'Check vacation rental tasks'                        ${B}│${N}"
    echo -e "${B}│${N} - 'Open EdBoiGames dashboard'                           ${B}│${N}"
    echo -e "${B}│${N} - 'Start data hoarding tools'                          ${B}│${N}"
    echo -e "${B}│${N} - 'Fix my audio'                                       ${B}│${N}"
    echo -e "${B}│${N} - 'Set up streaming'                                   ${B}│${N}"
    echo -e "${B}│${N} - 'Install local AI'                                   ${B}│${N}"
    echo -e "${B}│${N} - 'Update everything'                                  ${B}│${N}"
    echo -e "${B}└────────────────────────────────────────────────────────┘${N}"
}

show_shortcuts() {
    echo -e "${P}[SHORTCUTS AVAILABLE]${N}"
    if [ -f shortcuts/aliases.sh ]; then
        echo -e "${C}System Aliases:${N}"
        grep -E "^alias " shortcuts/aliases.sh | head -10
    fi
    echo -e "${C}\nTo load shortcuts: source shortcuts/aliases.sh${N}"
}

# Initialize
mkdir -p ~/.bill-sloth/{logs,backups,data}
mkdir -p modules prompts shortcuts data

# Create some initial modules if they don't exist
if [ ! -f modules/system_ops.sh ]; then
    echo "# System Operations Module - To be executed by Claude Code" > modules/system_ops.sh
fi

# Main loop
while true; do
    show_banner
    show_menu
    read -r choice
    
    case $choice in
        01) install_module "productivity_suite" ;;
        02) install_module "vacation_rental_manager" ;;
        03) install_module "edboigames_toolkit" ;;
        04) install_module "data_hoarding" ;;
        05) install_module "streaming_setup" ;;
        06) install_module "ai_playground" ;;
        07) install_module "system_ops" ;;
        08) install_module "gaming_boost" ;;
        09) install_module "privacy_tools" ;;
        10) install_module "creative_coding" ;;
        U|u) 
            echo -e "${C}[*] Updating Bill Sloth Lab...${N}"
            git pull origin main 2>/dev/null || echo "Not a git repository or no remote"
            ;;
        A|a) show_shortcuts ;;
        H|h) show_help ;;
        L|l) 
            if [ -f ~/.bill-sloth/logs/lab.log ]; then
                tail -20 ~/.bill-sloth/logs/lab.log
            else
                echo "No logs found"
            fi
            ;;
        0) 
            echo -e "${R}[*] Leaving the lab... またね！${N}"
            exit 0
            ;;
        *)
            echo -e "${R}[!] Invalid choice. Try again.${N}"
            ;;
    esac
    
    echo -e "\n${C}Press Enter to continue...${N}"
    read
done