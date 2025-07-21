#!/bin/bash
# LLM_CAPABILITY: local_ok
# Privacy tools and safe torrenting

check_vpn_status() {
    if ip addr | grep -qE "tun|wg"; then
        echo "✅ VPN is ACTIVE"
        echo "IP: $(curl -s ifconfig.me)"
        return 0
    else
        echo "❌ VPN is NOT ACTIVE"
        echo "⚠️  Your real IP: $(curl -s ifconfig.me)"
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
    cat > ~/bin/vpn-killswitch << 'EOF'
#!/bin/bash
echo "🔥 VPN Kill Switch"
echo "This will block ALL internet if VPN drops!"
echo "Continue? (y/n)"
read -r confirm

if [[ $confirm == "y" ]]; then
    # Flush existing rules
    sudo iptables -F
    sudo iptables -X
    
    # Default deny
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT DROP
    
    # Allow loopback
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A OUTPUT -o lo -j ACCEPT
    
    # Allow VPN
    sudo iptables -A OUTPUT -o tun+ -j ACCEPT
    sudo iptables -A INPUT -i tun+ -j ACCEPT
    
    echo "✅ Kill switch ACTIVE - No internet without VPN!"
fi
EOF
    chmod +x ~/bin/vpn-killswitch
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