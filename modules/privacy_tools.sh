#!/bin/bash
# LLM_CAPABILITY: local_ok
# Privacy tools and safe torrenting

check_vpn_status() {
    if ip addr | grep -qE "tun|wg"; then
        echo "✅ VPN is ACTIVE"
        echo "IP: $(curl -s ifconfig.me)"
        echo '"I got a virus. It’s called being awesome." – Master Shake'
        return 0
    else
        echo "❌ VPN is NOT ACTIVE"
        echo "⚠️  Your real IP: $(curl -s ifconfig.me)"
        echo '"I got a virus. It’s called being awesome." – Master Shake'
        return 1
    fi
}

install_vpn_tools() {
    echo "🔐 Installing VPN tools..."
    sudo apt install openvpn wireguard network-manager-openvpn-gnome -y
    
    # ProtonVPN CLI
    curl -fsSL https://raw.githubusercontent.com/ProtonVPN/linux-cli/master/protonvpn.sh | sudo bash
}

setup_vpn_killswitch() {
    echo "🔥 Setting up VPN kill switch (using centralized implementation)..."
    
    # Create wrapper script that uses centralized kill-switch
    cat > ~/bin/vpn-killswitch << 'EOF'
#!/bin/bash
# VPN Kill Switch - Uses centralized Bill Sloth implementation

# Source centralized kill-switch library
BILL_SLOTH_LIB="$HOME/.bill-sloth/lib/kill_switch.sh"
if [ -f "$BILL_SLOTH_LIB" ]; then
    source "$BILL_SLOTH_LIB"
else
    echo "ERROR: Bill Sloth kill-switch library not found at $BILL_SLOTH_LIB"
    echo "Please ensure Bill Sloth is properly installed."
    exit 1
fi

echo "🔥 VPN Kill Switch (Bill Sloth Centralized)"
echo "This will block ALL internet if VPN drops!"
echo "Continue? (y/n)"
read -r confirm

if [[ $confirm == "y" ]]; then
    kill_switch_enable
else
    echo "Kill switch setup cancelled."
fi
EOF
    chmod +x ~/bin/vpn-killswitch
    
    echo "✅ VPN kill switch script created (uses centralized implementation)"
}

setup_safe_torrenting() {
    echo "🏴‍☠️ Setting up safe torrenting..."
    sudo apt install qbittorrent transmission-cli -y
    
    # Create qBittorrent config with safety settings
    mkdir -p ~/.config/qBittorrent
    cat > ~/.config/qBittorrent/qBittorrent.conf << 'EOF'
[Preferences]
Connection\GlobalDLLimit=0
Connection\GlobalUPLimit=500
General\UseRandomPort=true
BitTorrent\Encryption=2
BitTorrent\AnonymousMode=true
EOF

    # Create VPN check for torrenting
    cat > ~/bin/torrent-safe << 'EOF'
#!/bin/bash
if check_vpn_status; then
    echo "✅ Safe to torrent!"
    qbittorrent &
else
    echo "⚠️  START YOUR VPN FIRST!"
    echo "Try: protonvpn-cli connect"
fi
EOF
    chmod +x ~/bin/torrent-safe
}