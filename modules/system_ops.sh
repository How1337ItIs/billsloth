#!/bin/bash
# LLM_CAPABILITY: local_ok
# System operations - save tokens on repetitive tasks

update_everything() {
    echo "🔄 Updating all systems..."
    sudo apt update && sudo apt upgrade -y
    snap refresh 2>/dev/null
    flatpak update -y 2>/dev/null
    
    # Update Ollama models if installed
    if command -v ollama &>/dev/null; then
        ollama list | tail -n +2 | awk '{print $1}' | xargs -I {} ollama pull {} 2>/dev/null
    fi
}

fix_audio() {
    echo "🔊 Attempting audio fixes..."
    pulseaudio -k && pulseaudio --start
    sudo alsa force-reload
    systemctl --user restart pipewire 2>/dev/null
}

fix_network() {
    echo "🌐 Resetting network..."
    sudo systemctl restart NetworkManager
    sudo dhclient -r && sudo dhclient
}

fix_display() {
    echo "🖥️ Display troubleshooting..."
    echo "Try: Ctrl+Alt+F2 for console, then:"
    echo "sudo systemctl restart gdm3 (or lightdm/sddm)"
}

check_system_health() {
    echo "CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo "RAM: $(free -h | awk '/^Mem:/ {print $3 "/" $2}')"
    echo "Disk: $(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')% used"
    echo "GPU: $(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader 2>/dev/null || echo "N/A")"
}