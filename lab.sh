#!/bin/bash
# BILL SLOTH LINUX LAB - Main Interface
# Designed for Claude Code execution and interpretation
# "Number one in the hood, G!" - Master Shake
# "I understand! I understand!" - Meatwad

# Generate context for Claude Code at session start
echo "🤖 Preparing Claude Code context..."

set -euo pipefail

# Load Claude Interactive Bridge for AI/Human hybrid execution
source "$(dirname "$0")/lib/claude_interactive_bridge.sh" 2>/dev/null || true

# ATHF colors for terminal aesthetics
R='\033[0;31m'    # Red (Shake)
G='\033[0;32m'    # Green (Frylock)
B='\033[0;34m'    # Blue (Carl's Pool)
P='\033[1;35m'    # Purple (Meatwad)
C='\033[0;36m'    # Cyan (wwwyzzerdd)
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
            ╭─────────────────────────────────────────────────╮
            │    ☆ﾟ.*･｡ﾟ  S L O W  &  S T E A D Y  ﾟ｡･*.ﾟ☆   │
            │                                                 │
            │        🦥    /|_/|   Chill vibes only    🦥      │
            │           (  o.o  )   Taking it slow...         │
            │            > ^ <      One task at a time        │
            │                                                 │
            ╰─────────────────────────────────────────────────╯
BANNER
    echo -e "${N}"
    
    # Midas Whale developer credit
    if (( RANDOM % 10 == 0 )); then
      echo -e "\033[36m🐋 Developed (or perhaps conjured) by Midas Marsupius Whale 👑🐋 — legend says he's a wombat in a whale suit who somehow also embodies King Midas. Some say he was just King Midas until a time-traveling whale on acid bit him, making him an immortal anthropomorphic whale creature. Others say he was always a wombat. All of it may be true.\033[0m\n"
    else
      echo -e "\033[36m🐋 Developer: Midas Whale 👑🐋\033[0m\n"
    fi
    
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
    echo -e "${C}└────────────────────────────────────────────────┘${N}"
}

show_menu() {
    echo -e "\n${P}【WORK & PRODUCTIVITY】${N}"
    echo "  1) Productivity Suite (Run)"
    echo "  1a) Audit Productivity Suite"
    echo "  2) Data Hoarding (Run)"
    echo "  2a) Audit Data Hoarding"
    echo "  3) Streaming Setup (Run)"
    echo "  3a) Audit Streaming Setup"
    echo "  4) Gaming Boost (Run)"
    echo "  4a) Audit Gaming Boost"
    echo "  5) Privacy Tools (Run)"
    echo "  5a) Audit Privacy Tools"
    echo "  6) Creative Coding (Run)"
    echo "  6a) Audit Creative Coding"
    echo "  7) AI Playground (Run)"
    echo "  7a) Audit AI Playground"
    echo "  8) System Ops (Run)"
    echo "  8a) Audit System Ops"
    echo "  9) EdBoiGames Toolkit (Run)"
    echo "  9a) Audit EdBoiGames Toolkit"
    echo " 10) Repetitive Tasks (Run)"
    echo " 10a) Audit Repetitive Tasks"
    echo " 11) Vacation Rental Manager (Run)"
    echo " 11a) Audit Vacation Rental Manager"
    echo ""
    echo -e "${C}【LOCAL AI】${N}"
    echo "  L) Local AI (install / toggle)"
    echo "  0) Exit"
    echo ""
    if is_claude_execution; then
        menu_choice=$(claude_enhanced_read "Your choice: " "1" "main_menu")
    else
        read -p "Your choice: " menu_choice
    fi
    case $menu_choice in
        1|1a) run_with_claude_bridge modules/productivity_suite_interactive.sh ;;
        2|2a) run_with_claude_bridge modules/data_hoarding_interactive.sh ;;
        3|3a) run_with_claude_bridge modules/streaming_setup_interactive.sh ;;
        4|4a) run_with_claude_bridge modules/gaming_boost_interactive.sh ;;
        5|5a) run_with_claude_bridge modules/privacy_tools_interactive.sh ;;
        6|6a) run_with_claude_bridge modules/creative_coding_interactive.sh ;;
        7|7a) run_with_claude_bridge modules/ai_playground_interactive.sh ;;
        8|8a) run_with_claude_bridge modules/system_ops_interactive.sh ;;
        9|9a) run_with_claude_bridge modules/edboigames_toolkit_interactive.sh ;;
        10|10a) run_with_claude_bridge modules/repetitive_tasks_interactive.sh ;;
        11|11a) run_with_claude_bridge modules/vacation_rental_manager_interactive.sh ;;
        L|l) toggle_local_ai ;;
        0) echo "Bye!"; exit 0 ;;
        *) echo "No valid choice. Try again."; show_menu ;;
    esac
    echo "\nYou can always re-run the menu to explore or audit other modules!"
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
    echo -e "${B}│${N} - 'Fix my audio'                                       ${B}│${N}"
    echo -e "${B}│${N} - 'Set up streaming'                                   ${B}│${N}"
    echo -e "${B}│${N} - 'Install local AI'                                   ${B}│${N}"
    echo -e "${B}│${N} - 'Optimize for gaming'                                ${B}│${N}"
    echo -e "${B}│${N} - 'Check my VPN'                                       ${B}│${N}"
    echo -e "${B}│${N} - 'Update everything'                                  ${B}│${N}"
    echo -e "${B}│${N} - 'Start work mode'                                    ${B}│${N}"
    echo -e "${B}│${N} - 'Open rental dashboard'                              ${B}│${N}"
    echo -e "${B}│${N} - 'Launch EdBoiGames tools'                            ${B}│${N}"
    echo -e "${B}│${N} - 'Organize my files'                                  ${B}│${N}"
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

toggle_local_ai() {
    echo -e "\n${P}🤖 LOCAL AI MANAGEMENT${N}"
    echo "======================"
    
    # Check if local AI is installed
    if command -v interpreter &> /dev/null && command -v ollama &> /dev/null; then
        echo "✅ Local AI stack is installed"
        echo "📊 Installed models:"
        ollama list 2>/dev/null | head -5
    else
        echo "📦 Local AI stack not installed"
        echo ""
        echo "🚀 Install local AI stack? (Open Interpreter + Ollama + CodeLlama 13B)"
        echo "This enables offline AI capabilities for file operations, log parsing, etc."
        echo "Size: ~7GB download"
        echo ""
        read -p "Install now? (y/n): " install_choice
        if [[ $install_choice =~ ^[Yy]$ ]]; then
            bash modules/local_llm_setup.sh
            return
        else
            echo "Skipping installation"
            return
        fi
    fi
    
    # Toggle offline mode
    echo ""
    echo "🧠 Current AI brain: $( [[ ${OFFLINE_MODE:-0} -eq 1 ]] && echo 'Local model (offline)' || echo 'Claude Code (cloud)' )"
    echo ""
    echo "Options:"
    echo "1) Use local AI (offline mode)"
    echo "2) Use Claude Code (cloud mode)" 
    echo "3) Auto-detect based on task"
    echo "0) Back to main menu"
    echo ""
    read -p "Your choice: " ai_choice
    
    case $ai_choice in
        1)
            export OFFLINE_MODE=1
            unset FORCE_CLOUD
            echo "🤖 Switched to local AI mode"
            echo "All AI calls will use local models when possible"
            ;;
        2)
            export FORCE_CLOUD=1
            unset OFFLINE_MODE
            echo "☁️ Switched to cloud mode"
            echo "All AI calls will prefer Claude Code"
            ;;
        3)
            unset OFFLINE_MODE FORCE_CLOUD
            echo "🎯 Auto-detect mode enabled"
            echo "AI choice depends on task capability and availability"
            ;;
        0)
            return
            ;;
    esac
    
    echo ""
    echo "💡 Current session settings applied. Use OFFLINE_MODE=1 ./lab.sh to make permanent."
}

global_interactive_launcher() {
    echo "\n🌟 BILL SLOTH GLOBAL INTERACTIVE LAUNCHER"
    echo "========================================="
    echo "Choose a workflow to explore. Each module will help you pick the best tools for your needs!"
    echo ""
    echo "1) Productivity Suite"
    echo "2) Data Hoarding"
    echo "3) Streaming Setup"
    echo "4) Gaming Boost"
    echo "5) Privacy Tools"
    echo "6) Creative Coding"
    echo "7) AI Playground"
    echo "8) System Ops"
    echo "9) EdBoiGames Toolkit"
    echo "10) Repetitive Tasks"
    echo "11) Vacation Rental Manager"
    echo "0) Exit"
    echo ""
    read -p "Your choice: " global_choice
    case $global_choice in
        1) bash modules/productivity_suite_interactive.sh ;;
        2) bash modules/data_hoarding_interactive.sh ;;
        3) bash modules/streaming_setup_interactive.sh ;;
        4) bash modules/gaming_boost_interactive.sh ;;
        5) bash modules/privacy_tools_interactive.sh ;;
        6) bash modules/creative_coding_interactive.sh ;;
        7) bash modules/ai_playground_interactive.sh ;;
        8) bash modules/system_ops_interactive.sh ;;
        9) bash modules/edboigames_toolkit_interactive.sh ;;
        10) bash modules/repetitive_tasks_interactive.sh ;;
        11) bash modules/vacation_rental_manager_interactive.sh ;;
        0) echo "Bye!"; exit 0 ;;
        *) echo "No valid choice. Try again."; global_interactive_launcher ;;
    esac
    echo "\nYou can always re-run the global launcher to explore other modules!"
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
        01) echo "Use interactive menu instead (choice 'I')"; sleep 2 ;;
        02) echo "Use interactive menu instead (choice 'I')"; sleep 2 ;;
        03) echo "Use interactive menu instead (choice 'I')"; sleep 2 ;;
        04) install_module "system_ops" ;;
        05) install_module "streaming_setup" ;;
        06) install_module "ai_playground" ;;
        07) install_module "gaming_boost" ;;
        08) install_module "privacy_tools" ;;
        09) install_module "creative_coding" ;;
        10) install_module "data_hoarding" ;;
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