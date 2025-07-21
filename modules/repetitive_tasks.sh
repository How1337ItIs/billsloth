#!/bin/bash
# These are repetitive tasks that would waste tokens
# Claude Code calls these instead of doing them directly

update_system() {
    echo "Updating system packages..."
    sudo apt update && sudo apt upgrade -y
    flatpak update -y
    snap refresh
    echo "System update complete!"
}

install_common_apps() {
    # Apps Bill always wants
    echo "Installing Bill's essential apps..."
    sudo apt install -y discord obs-studio steam qbittorrent vlc firefox curl wget git
    echo "Common apps installed!"
}

fix_audio() {
    echo "Fixing audio issues..."
    pulseaudio -k && pulseaudio --start
    sudo alsa force-reload
    systemctl --user restart pipewire
    echo "Audio fix complete - try your sound now!"
}

check_vpn() {
    if ip addr | grep -q "tun\|wg"; then
        echo "VPN_ACTIVE"
    else
        echo "VPN_INACTIVE"
    fi
}

clean_system() {
    echo "Cleaning system..."
    sudo apt autoremove -y
    sudo apt autoclean
    sudo journalctl --vacuum-time=3d
    echo "System cleaned!"
}

check_gpu() {
    if lspci | grep -i nvidia; then
        echo "NVIDIA_GPU_DETECTED"
    elif lspci | grep -i amd; then
        echo "AMD_GPU_DETECTED"
    else
        echo "INTEGRATED_GPU"
    fi
}

gaming_mode_on() {
    echo "Activating gaming mode..."
    sudo cpupower frequency-set -g performance
    sudo sysctl vm.swappiness=10
    pkill firefox chrome
    echo "Gaming mode activated!"
}

gaming_mode_off() {
    echo "Deactivating gaming mode..."
    sudo cpupower frequency-set -g powersave
    sudo sysctl vm.swappiness=60
    echo "Gaming mode deactivated!"
}

streaming_audio_setup() {
    echo "Setting up streaming audio..."
    pavucontrol &
    pactl load-module module-null-sink sink_name=streaming_sink sink_properties=device.description="Streaming Audio"
    echo "Streaming audio setup complete!"
}

quick_obs_setup() {
    echo "Quick OBS setup..."
    obs --startstreaming &
    echo "OBS launched for streaming!"
}