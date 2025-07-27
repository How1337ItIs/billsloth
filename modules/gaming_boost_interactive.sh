#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=GameMode Optimizer, 2=Steam Setup, 3=Lutris Gaming, 4=Performance Tweaks, 5=Complete Gaming Suite
# CLAUDE_PROMPTS: Gaming platform selection, Performance tweaks confirmation, Additional tools
# CLAUDE_DEPENDENCIES: steam, lutris, gamemode, cpu-x, htop
# GAMING BOOST - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

# Source the non-interactive gaming boost module
source "$SOURCE_DIR/gaming_boost.sh"

gaming_boost_interactive() {
    # Load ASCII art gallery for cyberpunk effects
    source "$SOURCE_DIR/../lib/ascii_gallery.sh" 2>/dev/null || true
    
    # Show hardcore ASCII art (15% chance)
    if [ $((RANDOM % 7)) -eq 0 ] && command -v show_hardcore_art &>/dev/null; then
        echo ""
        echo -e "${CYBER_GREEN}[GAMING DEMON AWAKENING]${CYBER_RESET}"
        show_hardcore_art "random"
        echo ""
    fi
    
    echo -e "\033[35m"
    cat << 'BANNER'
    ██████╗  █████╗ ███╗   ███╗███████╗    ██████╗  ██████╗  ██████╗ ███████╗████████╗
    ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ██╔══██╗██╔═══██╗██╔═══██╗██╔════╝╚══██╔══╝
    ██║  ███╗███████║██╔████╔██║█████╗      ██████╔╝██║   ██║██║   ██║███████╗   ██║   
    ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██╔══██╗██║   ██║██║   ██║╚════██║   ██║   
    ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ██████╔╝╚██████╔╝╚██████╔╝███████║   ██║   
     ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝   ╚═╝   
BANNER
    echo -e "\033[0m"
    echo ""
    echo "⚡ TIME TO MAX OUT YOUR GAMING RIG, BILL! ⚡"
    echo "🎮 Choose your weapon to dominate the leaderboards!"
    echo "🔥 Each option optimizes different aspects of your gaming setup!"
    echo "💀 Say 'other' to summon Claude Code for more power-ups!"
    echo ""
    echo "1) Install Full Gaming Suite (Recommended)"
    echo "   + Complete setup: Steam, Lutris, MangoHud, GameMode"
    echo "   + Performance optimizations and custom game launcher"
    echo "   + System tuning for maximum FPS"
    echo "   Action: Installs all gaming tools and creates game command"
    echo ""
    echo "2) Steam Only (Gaming platform, mature)"
    echo "   + Huge library, Proton for Windows games"
    echo "   + Achievements, friends, cloud saves"
    echo "   + Official Linux client with good compatibility"
    echo "   Action: Installs Steam with 32-bit support"
    echo ""
    echo "3) Lutris Only (Game manager, open-source)"
    echo "   + Organizes all your games (Steam, GOG, emulators, etc.)"
    echo "   + Community scripts, easy installs"
    echo "   + Great for non-Steam games"
    echo "   Action: Installs Lutris game manager"
    echo ""
    echo "4) Performance Tools Only (MangoHud + GameMode)"
    echo "   + Real-time FPS overlay and performance stats"
    echo "   + System optimization for gaming"
    echo "   + Works with existing games"
    echo "   Action: Installs MangoHud and GameMode"
    echo ""
    echo "5) Custom Game Launcher (Lightweight scripts)"
    echo "   + Simple game mode activation"
    echo "   + Performance optimization toggles"
    echo "   + ADHD-friendly interface with ASCII art"
    echo "   Action: Creates custom game launcher script"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " game_choice
    
    # Ensure log directory exists
    mkdir -p ~/gaming_powerhouse
    
    case $game_choice in
        1)
            echo "[LOG] Bill chose Steam + Proton" >> ~/gaming_powerhouse/assistant.log
            echo "🚂 DEPLOYING STEAM + PROTON - THE GAME DISTRIBUTION GIANT!"
            echo ""
            echo "🎓 WHAT IS STEAM + PROTON?"
            echo "Steam is the world's largest PC gaming platform, and Proton is Valve's"
            echo "compatibility layer that lets Windows games run on Linux seamlessly:"
            echo "• 50,000+ games available"
            echo "• Proton runs Windows games without Windows"
            echo "• Automatic updates and cloud saves"
            echo "• Steam Workshop for mods and community content"
            echo "• Built-in voice chat and social features"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR LINUX GAMERS:"
            echo "• Largest game library on Linux"
            echo "• Proton handles compatibility automatically"
            echo "• Better performance than Windows in many cases"
            echo "• Valve actively improves Linux gaming"
            echo "• One-click install and play experience"
            echo ""
            
            # Install Steam
            if command -v steam &> /dev/null; then
                echo "✅ Steam is already installed!"
            else
                echo "🔧 Installing Steam with Proton support..."
                if [[ "$OSTYPE" == "linux-gnu"* ]] && command -v apt &> /dev/null; then
                    # Enable 32-bit architecture for Steam
                    sudo dpkg --add-architecture i386
                    sudo apt update
                    
                    # Install Steam
                    echo steam steam/question select "I AGREE" | sudo debconf-set-selections
                    echo steam steam/license note '' | sudo debconf-set-selections
                    sudo apt install -y steam
                    
                    echo "✅ Steam installed with Proton support!"
                else
                    echo "Please install Steam from: https://store.steampowered.com/about/"
                    return
                fi
            fi
            
            echo ""
            echo "🚀 STEAM GAMING MASTERY GUIDE"
            echo "============================="
            echo ""
            echo "🎯 FIRST-TIME STEAM SETUP:"
            echo "1. Launch Steam and create/log into your account"
            echo "2. Go to Steam > Settings > Steam Play"
            echo "3. Enable Steam Play for all other titles"
            echo "4. Select latest Proton version"
            echo "5. Restart Steam and start gaming!"
            echo ""
            echo "✅ STEAM + PROTON READY!"
            echo "Launch Steam and enable Proton in Steam > Settings > Steam Play"
            echo ""
            echo "🍔 Meatwad: 'I understand! Now I can play all the games without Windows!'"
            ;;
        2)
            echo "[LOG] Bill chose Lutris" >> ~/gaming_powerhouse/assistant.log
            echo "🎯 DEPLOYING LUTRIS - THE UNIVERSAL GAME MANAGER!"
            echo ""
            echo "Installing Lutris for universal game management..."
            if command -v apt &> /dev/null; then
                sudo apt install -y lutris
                echo "✅ Lutris installed! Launch from applications menu or run 'lutris'."
            else
                echo "❌ APT not available. Opening website for installation."
                xdg-open https://lutris.net/ &
            fi
            ;;
        3)
            echo "[LOG] Bill chose MangoHud" >> ~/gaming_powerhouse/assistant.log
            echo "📊 DEPLOYING MANGOHUD - THE PERFORMANCE MONITOR!"
            echo ""
            echo "Installing MangoHud for performance monitoring..."
            if command -v apt &> /dev/null; then
                sudo apt install -y mangohud
                echo "✅ MangoHud installed!"
                echo "📊 Use 'mangohud %command%' in Steam launch options"
            else
                echo "❌ APT not available. Please install manually."
            fi
            ;;
        4)
            echo "[LOG] Bill chose GameMode" >> ~/gaming_powerhouse/assistant.log
            echo "⚡ DEPLOYING GAMEMODE - THE PERFORMANCE OPTIMIZER!"
            echo ""
            echo "Installing GameMode for automatic performance optimization..."
            if command -v apt &> /dev/null; then
                sudo apt install -y gamemode
                echo "✅ GameMode installed!"
                echo "🎯 Use 'gamemoderun [game]' for performance boost"
            else
                echo "❌ APT not available. Please install manually."
            fi
            ;;
        5)
            echo "[LOG] Bill chose RetroArch" >> ~/gaming_powerhouse/assistant.log
            echo "🕹️ DEPLOYING RETROARCH - THE EMULATION POWERHOUSE!"
            echo ""
            echo "Installing RetroArch for retro gaming..."
            if command -v apt &> /dev/null; then
                sudo apt install -y retroarch
                echo "✅ RetroArch installed!"
            else
                echo "❌ APT not available. Please install manually."
            fi
            ;;
        6)
            echo "[LOG] Bill chose Discord" >> ~/gaming_powerhouse/assistant.log
            echo "🎵 DEPLOYING DISCORD - THE SOCIAL GAMING HUB!"
            echo ""
            echo "Installing Discord for gaming communication..."
            if command -v snap &> /dev/null; then
                sudo snap install discord
                echo "✅ Discord installed!"
            else
                echo "Please install Discord from: https://discord.com/download"
            fi
            ;;
        7)
            echo "[LOG] Bill chose Complete Gaming Suite" >> ~/gaming_powerhouse/assistant.log
            echo "🚀 DEPLOYING COMPLETE LINUX GAMING POWERHOUSE!"
            echo ""
            echo "Installing ALL gaming tools for the ultimate setup..."
            if command -v apt &> /dev/null; then
                echo "Installing Steam, Lutris, MangoHud, GameMode, RetroArch..."
                sudo dpkg --add-architecture i386
                sudo apt update
                echo steam steam/question select "I AGREE" | sudo debconf-set-selections
                sudo apt install -y steam lutris gamemode mangohud retroarch
                echo "✅ Complete gaming suite installed!"
            fi
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/gaming_powerhouse/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR ADVANCED GAMING TOOLS..."
            echo ""
            echo "Claude Code can help you with specialized gaming tools:"
            echo "• Advanced emulation (Dolphin, PCSX2, RPCS3)"
            echo "• Wine gaming (Bottles, PlayOnLinux)"
            echo "• Game streaming and recording tools"
            echo "• Custom controller and hardware setup"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/gaming_powerhouse/assistant.log"
    echo "🔄 You can always re-run this assistant to try a different solution!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    gaming_boost_interactive
fi 