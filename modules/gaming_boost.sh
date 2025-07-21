#!/bin/bash
# LLM_CAPABILITY: local_ok
# Gaming performance optimization

install_gaming_tools() {
    echo "🎮 Installing gaming essentials..."
    
    # Enable 32-bit architecture
    sudo dpkg --add-architecture i386
    sudo apt update
    
    # Steam
    echo steam steam/question select "I AGREE" | sudo debconf-set-selections
    echo steam steam/license note '' | sudo debconf-set-selections
    sudo apt install steam -y
    
    # Performance tools
    sudo apt install gamemode mangohud lutris -y
}

optimize_for_gaming() {
    echo "⚡ Optimizing system for gaming..."
    
    # Kill unnecessary processes
    pkill -f firefox 2>/dev/null
    pkill -f chrome 2>/dev/null
    pkill -f discord 2>/dev/null  # Unless streaming
    
    # Set CPU governor to performance
    echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    
    # Disable compositor (if using GNOME)
    gsettings set org.gnome.mutter unredirect-always true 2>/dev/null
}

create_game_command() {
    cat > ~/bin/game << 'EOF'
#!/bin/bash
echo -e "\033[35m"
cat << 'BANNER'
    ██████╗  █████╗ ███╗   ███╗███████╗    ███╗   ███╗ ██████╗ ██████╗ ███████╗
    ██╔════╝ ██╔══██╗████╗ ████║██╔════╝    ████╗ ████║██╔═══██╗██╔══██╗██╔════╝
    ██║  ███╗███████║██╔████╔██║█████╗      ██╔████╔██║██║   ██║██║  ██║█████╗  
    ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝      ██║╚██╔╝██║██║   ██║██║  ██║██╔══╝  
    ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗    ██║ ╚═╝ ██║╚██████╔╝██████╔╝███████╗
     ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝
BANNER
echo -e "\033[0m"

echo "1) Launch Steam"
echo "2) Launch Lutris"
echo "3) Just optimize performance"
echo "4) Check game compatibility (ProtonDB)"
read -p "Choice: " choice

case $choice in
    1) optimize_for_gaming && gamemoderun steam ;;
    2) optimize_for_gaming && gamemoderun lutris ;;
    3) optimize_for_gaming && echo "✅ System optimized for gaming!" ;;
    4) xdg-open "https://www.protondb.com" ;;
esac
EOF
    chmod +x ~/bin/game
}