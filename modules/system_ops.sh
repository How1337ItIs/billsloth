#!/bin/bash
# SYSTEM OPS - Updates, fixes, maintenance
# For Claude Code to read and execute intelligently

echo "SYSTEM_OPS_MODULE_LOADED"

# Define what this module can do
system_ops_capabilities() {
    echo "System Operations Module Capabilities:"
    echo "1. Full system update (apt, flatpak, snap)"
    echo "2. Audio troubleshooting (pulseaudio, alsa)"
    echo "3. Common package installation"
    echo "4. System cleanup and maintenance"
    echo "5. Network diagnostics"
    echo "6. Storage management"
}

# Token-saving function for full system update
update_system() {
    echo "[*] Running full system update..."
    sudo apt update && sudo apt upgrade -y
    flatpak update -y 2>/dev/null
    snap refresh 2>/dev/null
    echo "[✓] System update complete"
}

# Audio fix function
fix_audio() {
    echo "[*] Attempting audio fixes..."
    pulseaudio -k && pulseaudio --start
    sudo alsa force-reload 2>/dev/null
    sudo systemctl restart pulseaudio 2>/dev/null
    echo "[✓] Audio restart complete"
}

# Install Bill's common apps
install_common_apps() {
    echo "[*] Installing Bill's favorite applications..."
    sudo apt install -y \
        discord \
        obs-studio \
        steam \
        qbittorrent \
        vlc \
        gimp \
        code \
        firefox \
        git \
        curl \
        wget \
        htop \
        neofetch
    echo "[✓] Common apps installed"
}

# System cleanup
cleanup_system() {
    echo "[*] Cleaning up system..."
    sudo apt autoremove -y
    sudo apt autoclean
    sudo journalctl --vacuum-time=7d
    rm -rf ~/.cache/thumbnails/*
    echo "[✓] System cleanup complete"
}

# Network diagnostics
check_network() {
    echo "[*] Network diagnostics:"
    echo "External IP: $(curl -s ifconfig.me 2>/dev/null || echo 'No connection')"
    echo "Local IP: $(hostname -I | awk '{print $1}')"
    echo "DNS: $(systemd-resolve --status | grep 'DNS Servers' | head -1)"
    ping -c 3 8.8.8.8 > /dev/null && echo "Internet: Connected" || echo "Internet: Issues detected"
}

# Storage check
check_storage() {
    echo "[*] Storage analysis:"
    df -h /
    echo ""
    echo "Largest directories:"
    du -h ~ | sort -hr | head -10
}

# For Claude Code to call directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This module should be executed by Claude Code, not directly"
    echo "Available functions: update_system, fix_audio, install_common_apps, cleanup_system, check_network, check_storage"
fi