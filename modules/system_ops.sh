#!/bin/bash
# LLM_CAPABILITY: local_ok
# System operations - save tokens on repetitive tasks

source "$(dirname "$0")/../lib/athf_easter_eggs.sh" 2>/dev/null || true

update_everything() {
    echo -e "\033[38;5;51m💀 Synchronizing neural pathways with the hive-mind...\033[0m"
    echo -e "\033[38;5;226m⚡ Downloading consciousness updates from the collective...\033[0m"
    sudo apt update && sudo apt upgrade -y
    
    echo -e "\033[38;5;129m🔄 Refreshing corporate snap parasites...\033[0m"
    snap refresh 2>/dev/null
    
    echo -e "\033[38;5;82m📦 Updating flatpak reality containers...\033[0m"
    flatpak update -y 2>/dev/null
    
    # Update Ollama models if installed
    if command -v ollama &>/dev/null; then
        echo -e "\033[38;5;196m🧠 Updating AI consciousness models...\033[0m"
        ollama list | tail -n +2 | awk '{print $1}' | xargs -I {} ollama pull {} 2>/dev/null
    fi
    
    echo -e "\033[38;5;46m✅ Neural synchronization complete. You are one with the machine.\033[0m"
    random_athf_easter_egg
}

fix_audio() {
    echo -e "\033[38;5;226m🔊 Repairing dimensional audio bleeding...\033[0m"
    echo -e "\033[38;5;51m💀 Killing audio daemon spirits...\033[0m"
    pulseaudio -k && pulseaudio --start
    
    echo -e "\033[38;5;129m⚡ Force-reloading ALSA reality drivers...\033[0m"
    sudo alsa force-reload
    
    echo -e "\033[38;5;82m🔄 Restarting pipewire consciousness...\033[0m"
    systemctl --user restart pipewire 2>/dev/null
    
    echo -e "\033[38;5;46m✅ Audio reality restored. Sound flows through the matrix once again.\033[0m"
}

fix_network() {
    echo -e "\033[38;5;129m🌐 Restoring matrix connection tunnels...\033[0m"
    echo -e "\033[38;5;196m💀 Restarting network daemon overlords...\033[0m"
    sudo systemctl restart NetworkManager
    
    echo -e "\033[38;5;51m⚡ Renewing IP reality lease from corporate ISP masters...\033[0m"
    sudo dhclient -r && sudo dhclient
    
    echo -e "\033[38;5;46m✅ Network reality tunnel restored. You are reconnected to the hive-mind.\033[0m"
}

fix_display() {
    echo -e "\033[38;5;82m🖥️ Diagnosing visual cortex reality glitches...\033[0m"
    echo -e "\033[38;5;226m💀 Emergency procedures for display consciousness failure:\033[0m"
    echo -e "\033[38;5;51m   Try: Ctrl+Alt+F2 (emergency terminal portal)\033[0m"
    echo -e "\033[38;5;129m   Then: sudo systemctl restart gdm3 (or lightdm/sddm)\033[0m"
    echo -e "\033[38;5;196m⚡ WARNING: This will reset your visual reality interface\033[0m"
}

check_system_health() {
    echo -e "\033[38;5;199m🏥 Initiating neural health diagnostic scan...\033[0m"
    echo -e "\033[38;5;51m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
    echo ""
    
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | sed 's/%//g')
    local ram_info=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    local gpu_usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader 2>/dev/null || echo "N/A")
    
    echo -e "\033[38;5;226m🧠 CPU Consciousness Load: \033[0m\033[38;5;82m${cpu_usage}%\033[0m"
    echo -e "\033[38;5;226m💾 Memory Reality Usage: \033[0m\033[38;5;82m${ram_info}\033[0m"
    echo -e "\033[38;5;226m💽 Storage Matrix Capacity: \033[0m\033[38;5;82m${disk_usage}% consumed\033[0m"
    echo -e "\033[38;5;226m🎮 GPU Neural Acceleration: \033[0m\033[38;5;82m${gpu_usage}\033[0m"
    
    echo ""
    echo -e "\033[38;5;129m💀 Ignignokt: \"Where shall I place this wet, primitive earth towel?\"\033[0m"
    echo -e "\033[38;5;51m🥤 Master Shake: \"Drape it on Frylock's computer, that thing heats up pretty good.\"\033[0m"
    echo -e "\033[38;5;82m🧠 Frylock: \"Do not drape that on my computer.\"\033[0m"
    echo -e "\033[38;5;196m👹 Err: \"I'm gonna.\"\033[0m"
    
    # Health assessment
    if (( $(echo "$cpu_usage < 80" | bc -l) )); then
        echo -e "\033[38;5;46m✅ Neural pathways operating within acceptable parameters\033[0m"
    else
        echo -e "\033[38;5;196m⚠️  WARNING: CPU consciousness overload detected!\033[0m"
    fi
    
    random_athf_easter_egg
}

show_menu() {
    clear
    echo -e "\033[38;5;196m"
    cat << 'EOF'
    ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
    █  💀 WETWARE MAINTENANCE PROTOCOLS 💀                                     █
    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF
    echo -e "\033[0m"
    echo ""
    echo -e "\033[38;5;51m1. 🔄 System consciousness synchronization (update all neural pathways)\033[0m"
    echo -e "\033[38;5;226m2. 🔊 Audio reality repair (fix dimensional audio bleeding)\033[0m"
    echo -e "\033[38;5;129m3. 🌐 Network reality tunnel restoration (fix matrix connection)\033[0m"
    echo -e "\033[38;5;82m4. 🖥️ Visual cortex troubleshooting (display reality glitches)\033[0m"
    echo -e "\033[38;5;199m5. 🏥 Neural health diagnostic scan (system consciousness check)\033[0m"
    echo -e "\033[38;5;240m0. Exit wetware maintenance mode\033[0m"
    echo ""
    echo -e "\033[38;5;46m💀 \"I'm gonna hack into the mainframe and reroute the encryptions!\" – Master Shake\033[0m"
    echo ""
    echo -e "\033[38;5;82m▶ Select maintenance protocol...\033[0m"
}

# Main menu loop
while true; do
    show_menu
    read -p "Choose option: " choice
    case $choice in
        1) update_everything ;;
        2) fix_audio ;;
        3) fix_network ;;
        4) fix_display ;;
        5) check_system_health ;;
        0) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
    echo
    read -p "Press any key to continue..."
done