#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=WireGuard Setup, 2=OpenVPN Config, 3=Firewall Rules, 4=Security Audit, 5=Complete VPN Suite
# CLAUDE_PROMPTS: VPN type selection, Server configuration, Security settings
# CLAUDE_DEPENDENCIES: wireguard, openvpn, ufw, iptables, fail2ban
# 🔐 VPN & SECURITY MANAGEMENT - Secure connection protocols
# WireGuard, OpenVPN, and firewall configuration for privacy and security

# Enable error handling
set -euo pipefail

# Load Claude Interactive Bridge for AI/Human hybrid execution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

# Source libraries
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || {
    echo "🔐 VPN & SECURITY MANAGEMENT"
    echo "============================"
}

source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/adaptive_learning.sh" 2>/dev/null || true

# Initialize adaptive learning for this module
init_adaptive_learning "vpn_security" "$0" 2>/dev/null || true

show_banner "VPN & SECURITY" "WireGuard, OpenVPN & Firewall" "SECURITY"

echo "🔐 Bill Sloth VPN & Security Management"
echo "======================================"
echo ""
echo "🛡️ Secure your internet connection and protect your privacy:"
echo "   • WireGuard VPN setup (modern, Android-friendly)"
echo "   • OpenVPN configuration (traditional, widely supported)"
echo "   • Quick VPN connections and management"
echo "   • Firewall configuration for enhanced security"
echo ""
echo "🧠 Designed for neurodivergent users with simple, clear interfaces!"
echo ""

# Detect and save security capabilities
detect_security_capabilities() {
    local capabilities_file="$HOME/.bill-sloth/security-capabilities"
    mkdir -p "$(dirname "$capabilities_file")"
    
    # VPN capabilities
    local vpn_tools=()
    
    if command -v wg &>/dev/null; then
        vpn_tools+=("wireguard")
    fi
    
    if command -v openvpn &>/dev/null; then
        vpn_tools+=("openvpn")
    fi
    
    # Firewall capabilities
    local firewall_tools=()
    
    if command -v ufw &>/dev/null; then
        firewall_tools+=("ufw")
    fi
    
    if command -v iptables &>/dev/null; then
        firewall_tools+=("iptables")
    fi
    
    if command -v firewall-cmd &>/dev/null; then
        firewall_tools+=("firewalld")
    fi
    
    # Save capabilities
    cat > "$capabilities_file" << EOF
# VPN & Security Capabilities
VPN_TOOLS=(${vpn_tools[*]})
FIREWALL_TOOLS=(${firewall_tools[*]})

# Primary tools
PRIMARY_VPN="${vpn_tools[0]:-none}"
PRIMARY_FIREWALL="${firewall_tools[0]:-none}"
EOF
    
    log_success "Detected security capabilities: VPN(${#vpn_tools[@]}), Firewall(${#firewall_tools[@]})"
}

# Main VPN & Security menu
vpn_security_menu() {
    while true; do
        print_separator "=" 50
        echo "🔐 VPN & SECURITY MENU"
        print_separator "=" 50
        echo ""
        
        echo "🛡️ PRIVACY & PROTECTION:"
        echo ""
        echo "  1) 🔐 WireGuard VPN Setup      - Modern, fast VPN (recommended)"
        echo "     💡 Perfect for Android phones, fast connections"
        echo ""
        echo "  2) 🌍 OpenVPN Setup            - Traditional VPN solution" 
        echo "     💡 Works everywhere, widely supported"
        echo ""
        echo "  3) ⚡ VPN Quick Connect        - Connect to configured VPNs"
        echo "     💡 One-click connection to your saved VPNs"
        echo ""
        echo "  4) 🔥 Firewall Configuration  - UFW/iptables security"
        echo "     💡 Block unwanted connections, enhance security"
        echo ""
        echo "  0) Exit VPN & Security"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select security option (0-4)" 30 "0")
        
        case "$choice" in
            1) setup_wireguard_vpn ;;
            2) setup_openvpn ;;
            3) vpn_quick_connect ;;
            4) configure_firewall ;;
            0) 
                echo "🔐 Exiting VPN & Security Management..."
                break
                ;;
            *)
                log_warning "Invalid choice: $choice"
                echo ""
                ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to return to menu..."
            echo ""
        fi
    done
}

# WireGuard VPN setup (modern, Android-friendly)
setup_wireguard_vpn() {
    print_header "🔐 WIREGUARD VPN SETUP"
    
    echo "WireGuard is the modern VPN solution - fast, secure, and mobile-friendly:"
    echo "• Superior performance compared to OpenVPN"
    echo "• Excellent Android app integration"
    echo "• Simple configuration with QR codes"
    echo "• Lower battery usage on mobile devices"
    echo ""
    
    # Check if WireGuard is installed
    if ! command -v wg &>/dev/null; then
        echo "📦 Installing WireGuard..."
        
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y wireguard wireguard-tools qrencode
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y wireguard-tools qrencode
        elif command -v pacman &>/dev/null; then
            sudo pacman -S wireguard-tools qrencode
        else
            log_error "Could not install WireGuard automatically"
            echo "Please install WireGuard manually from your package manager"
            return 1
        fi
        
        log_success "WireGuard installed"
    else
        log_success "WireGuard is already installed"
    fi
    
    echo ""
    echo "🔧 WireGuard Setup Options:"
    echo "1) Create new WireGuard server (host VPN for Android)"
    echo "2) Connect to existing WireGuard server"
    echo "3) Generate Android client configuration"
    echo "4) Import WireGuard configuration file"
    
    read -p "Select option (1-4): " wg_option
    
    case "$wg_option" in
        1) create_wireguard_server ;;
        2) connect_wireguard_client ;;
        3) generate_android_config ;;
        4) import_wireguard_config ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Create WireGuard server
create_wireguard_server() {
    print_header "🏠 CREATE WIREGUARD SERVER"
    
    echo "Setting up your device as a WireGuard VPN server:"
    echo "• Your Android phone can connect through this server"
    echo "• Encrypts all traffic when on public Wi-Fi"
    echo "• Access your home network remotely"
    echo ""
    
    # Enable IP forwarding
    echo "🔧 Enabling IP forwarding..."
    echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf
    echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
    
    # Create WireGuard directory
    sudo mkdir -p /etc/wireguard
    cd /etc/wireguard
    
    # Generate server keys
    echo "🔑 Generating server keys..."
    sudo wg genkey | sudo tee server_private.key
    sudo cat server_private.key | wg pubkey | sudo tee server_public.key
    
    # Get server IP configuration
    echo ""
    echo "🌐 Network Configuration:"
    echo "1) Use public IP (for external access)"
    echo "2) Use local IP (for LAN access only)"
    
    read -p "Select option (1-2): " ip_option
    
    local server_ip
    if [ "$ip_option" = "1" ]; then
        server_ip=$(curl -s ifconfig.me)
        echo "📡 Using public IP: $server_ip"
    else
        server_ip=$(ip route get 1 | awk '{print $7}' | head -1)
        echo "🏠 Using local IP: $server_ip"
    fi
    
    # Create server configuration
    echo "📝 Creating server configuration..."
    sudo tee /etc/wireguard/wg0.conf << EOF
[Interface]
PrivateKey = $(sudo cat server_private.key)
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = true

# Enable IP forwarding and NAT
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $(ip route | awk '/default/ {print $5}') -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $(ip route | awk '/default/ {print $5}') -j MASQUERADE
EOF
    
    # Start WireGuard service
    echo "🚀 Starting WireGuard service..."
    sudo systemctl enable wg-quick@wg0
    sudo systemctl start wg-quick@wg0
    
    # Create client configuration
    echo ""
    echo "📱 Creating Android client configuration..."
    
    # Generate client keys
    sudo wg genkey | sudo tee client_private.key
    sudo cat client_private.key | wg pubkey | sudo tee client_public.key
    
    # Create client config
    sudo tee android-client.conf << EOF
[Interface]
PrivateKey = $(sudo cat client_private.key)
Address = 10.0.0.2/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = $(sudo cat server_public.key)
Endpoint = $server_ip:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
    
    # Add client to server
    sudo wg set wg0 peer $(sudo cat client_public.key) allowed-ips 10.0.0.2/32
    sudo wg-quick save wg0
    
    # Generate QR code for Android
    echo ""
    echo "📱 QR Code for Android WireGuard app:"
    echo "======================================"
    sudo qrencode -t ansiutf8 < android-client.conf
    echo ""
    
    echo "✅ WireGuard server setup complete!"
    echo ""
    echo "📋 Next steps:"
    echo "1. Install WireGuard app on your Android phone"
    echo "2. Scan the QR code above to add the configuration"
    echo "3. Connect from your phone when on public Wi-Fi"
    echo ""
    echo "🔧 Server status: $(sudo systemctl is-active wg-quick@wg0)"
    echo "📁 Config saved to: /etc/wireguard/android-client.conf"
    
    notify_success "WireGuard Server" "VPN server created and configured"
}

# Connect to existing WireGuard server
connect_wireguard_client() {
    print_header "🌍 CONNECT TO WIREGUARD SERVER"
    
    echo "Connect to an existing WireGuard VPN server:"
    echo "• Import configuration from VPN provider"
    echo "• Connect to your own WireGuard server"
    echo "• Manage multiple VPN connections"
    echo ""
    
    # List existing configurations
    local configs=($(find /etc/wireguard -name "*.conf" 2>/dev/null | xargs basename -s .conf))
    
    if [ ${#configs[@]} -gt 0 ]; then
        echo "📋 Available WireGuard configurations:"
        for i in "${!configs[@]}"; do
            echo "$((i+1))) ${configs[i]}"
        done
        echo "$((${#configs[@]}+1))) Import new configuration"
        echo ""
        
        read -p "Select configuration (1-$((${#configs[@]}+1))): " config_choice
        
        if [ "$config_choice" -le "${#configs[@]}" ] && [ "$config_choice" -gt 0 ]; then
            local selected_config="${configs[$((config_choice-1))]}"
            echo "🔗 Connecting to $selected_config..."
            
            sudo systemctl stop wg-quick@* 2>/dev/null || true
            sudo systemctl start wg-quick@$selected_config
            
            if sudo systemctl is-active wg-quick@$selected_config &>/dev/null; then
                log_success "Connected to $selected_config"
                echo "📊 Connection status:"
                sudo wg show
            else
                log_error "Failed to connect to $selected_config"
            fi
        elif [ "$config_choice" -eq "$((${#configs[@]}+1))" ]; then
            import_wireguard_config
        else
            log_warning "Invalid selection"
        fi
    else
        echo "⚠️ No WireGuard configurations found"
        echo "Would you like to import a configuration file?"
        read -p "Import now? (y/n): " import_now
        if [[ $import_now =~ ^[Yy]$ ]]; then
            import_wireguard_config
        fi
    fi
}

# Generate Android configuration
generate_android_config() {
    print_header "📱 GENERATE ANDROID CONFIG"
    
    echo "Generate a new Android client configuration:"
    echo "• Creates configuration for WireGuard Android app"
    echo "• Generates QR code for easy setup"
    echo "• Adds client to existing server"
    echo ""
    
    if [ ! -f /etc/wireguard/server_private.key ]; then
        log_error "WireGuard server not found. Please set up server first."
        return 1
    fi
    
    cd /etc/wireguard
    
    # Get next available IP
    local used_ips=$(sudo wg show wg0 allowed-ips | grep -o '10\.0\.0\.[0-9]*' | cut -d. -f4 | sort -n | tail -1)
    local next_ip=$((used_ips + 1))
    
    echo "📝 Creating client configuration for IP: 10.0.0.$next_ip"
    
    # Generate client keys
    sudo wg genkey | sudo tee client_${next_ip}_private.key
    sudo cat client_${next_ip}_private.key | wg pubkey | sudo tee client_${next_ip}_public.key
    
    # Get server endpoint
    local server_ip=$(curl -s ifconfig.me)
    
    # Create client config
    sudo tee android-client-${next_ip}.conf << EOF
[Interface]
PrivateKey = $(sudo cat client_${next_ip}_private.key)
Address = 10.0.0.${next_ip}/24
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = $(sudo cat server_public.key)
Endpoint = $server_ip:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
    
    # Add client to server
    sudo wg set wg0 peer $(sudo cat client_${next_ip}_public.key) allowed-ips 10.0.0.${next_ip}/32
    sudo wg-quick save wg0
    
    # Generate QR code
    echo ""
    echo "📱 QR Code for Android WireGuard app:"
    echo "======================================"
    sudo qrencode -t ansiutf8 < android-client-${next_ip}.conf
    echo ""
    
    log_success "Android configuration created"
    echo "📁 Config saved to: /etc/wireguard/android-client-${next_ip}.conf"
    
    notify_success "WireGuard Client" "Android configuration generated"
}

# Import WireGuard configuration
import_wireguard_config() {
    print_header "📥 IMPORT WIREGUARD CONFIG"
    
    echo "Import WireGuard configuration from file:"
    echo "• VPN provider .conf files"
    echo "• Custom WireGuard configurations"
    echo "• Backup configurations"
    echo ""
    
    read -p "📁 Enter path to .conf file: " config_file
    
    if [ ! -f "$config_file" ]; then
        log_error "Configuration file not found: $config_file"
        return 1
    fi
    
    # Validate configuration
    if ! grep -q "\[Interface\]" "$config_file" || ! grep -q "\[Peer\]" "$config_file"; then
        log_error "Invalid WireGuard configuration file"
        return 1
    fi
    
    # Get configuration name
    local config_name=$(basename "$config_file" .conf)
    read -p "📝 Configuration name [$config_name]: " custom_name
    config_name=${custom_name:-$config_name}
    
    # Copy configuration
    sudo cp "$config_file" "/etc/wireguard/${config_name}.conf"
    sudo chmod 600 "/etc/wireguard/${config_name}.conf"
    
    log_success "Configuration imported as: $config_name"
    
    # Test connection
    echo ""
    read -p "🔗 Test connection now? (y/n): " test_now
    if [[ $test_now =~ ^[Yy]$ ]]; then
        sudo systemctl stop wg-quick@* 2>/dev/null || true
        sudo systemctl start wg-quick@$config_name
        
        if sudo systemctl is-active wg-quick@$config_name &>/dev/null; then
            log_success "Successfully connected to $config_name"
            echo "📊 Connection status:"
            sudo wg show
        else
            log_error "Failed to connect to $config_name"
        fi
    fi
    
    notify_success "WireGuard Import" "Configuration imported: $config_name"
}

# OpenVPN setup
setup_openvpn() {
    print_header "🌍 OPENVPN SETUP"
    
    echo "OpenVPN is the traditional VPN solution - widely supported:"
    echo "• Works on almost every device and platform"
    echo "• Supported by most VPN providers"
    echo "• Highly configurable and reliable"
    echo "• Good for compatibility with older systems"
    echo ""
    
    # Check if OpenVPN is installed
    if ! command -v openvpn &>/dev/null; then
        echo "📦 Installing OpenVPN..."
        
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y openvpn network-manager-openvpn network-manager-openvpn-gnome
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y openvpn NetworkManager-openvpn NetworkManager-openvpn-gnome
        elif command -v pacman &>/dev/null; then
            sudo pacman -S openvpn networkmanager-openvpn
        else
            log_error "Could not install OpenVPN automatically"
            echo "Please install OpenVPN manually from your package manager"
            return 1
        fi
        
        log_success "OpenVPN installed"
    else
        log_success "OpenVPN is already installed"
    fi
    
    echo ""
    echo "🔧 OpenVPN Setup Options:"
    echo "1) Import .ovpn config file from VPN provider"
    echo "2) Create OpenVPN server (host VPN)"
    echo "3) Connect to configured OpenVPN"
    echo "4) Manage OpenVPN connections"
    
    read -p "Select option (1-4): " ovpn_option
    
    case "$ovpn_option" in
        1) import_openvpn_config ;;
        2) create_openvpn_server ;;
        3) connect_openvpn ;;
        4) manage_openvpn_connections ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Import OpenVPN configuration
import_openvpn_config() {
    print_header "📥 IMPORT OPENVPN CONFIG"
    
    echo "Import OpenVPN configuration from your VPN provider:"
    echo "• Download .ovpn file from your VPN provider"
    echo "• Import authentication credentials"
    echo "• Set up automatic connection"
    echo ""
    
    read -p "📁 Enter path to .ovpn file: " ovpn_file
    
    if [ ! -f "$ovpn_file" ]; then
        log_error "OpenVPN file not found: $ovpn_file"
        return 1
    fi
    
    # Create OpenVPN directory
    sudo mkdir -p /etc/openvpn/client
    
    # Get configuration name
    local config_name=$(basename "$ovpn_file" .ovpn)
    read -p "📝 Configuration name [$config_name]: " custom_name
    config_name=${custom_name:-$config_name}
    
    # Copy configuration
    sudo cp "$ovpn_file" "/etc/openvpn/client/${config_name}.conf"
    
    # Check if authentication is needed
    if grep -q "auth-user-pass" "/etc/openvpn/client/${config_name}.conf"; then
        echo ""
        echo "🔐 VPN requires username and password authentication"
        read -p "Username: " vpn_username
        read -s -p "Password: " vpn_password
        echo ""
        
        # Create auth file
        echo -e "$vpn_username\n$vpn_password" | sudo tee "/etc/openvpn/client/${config_name}.auth"
        sudo chmod 600 "/etc/openvpn/client/${config_name}.auth"
        
        # Update config to use auth file
        sudo sed -i "s/auth-user-pass.*/auth-user-pass \/etc\/openvpn\/client\/${config_name}.auth/" "/etc/openvpn/client/${config_name}.conf"
    fi
    
    log_success "OpenVPN configuration imported: $config_name"
    
    # Test connection
    echo ""
    read -p "🔗 Test connection now? (y/n): " test_now
    if [[ $test_now =~ ^[Yy]$ ]]; then
        echo "🔗 Connecting to $config_name..."
        sudo systemctl start openvpn-client@$config_name
        
        sleep 5
        
        if sudo systemctl is-active openvpn-client@$config_name &>/dev/null; then
            log_success "Successfully connected to $config_name"
            echo "📊 Connection status:"
            ip addr show tun0 2>/dev/null || echo "VPN interface not found"
        else
            log_error "Failed to connect to $config_name"
            echo "Check logs: sudo journalctl -u openvpn-client@$config_name"
        fi
    fi
    
    notify_success "OpenVPN Import" "Configuration imported: $config_name"
}

# Create OpenVPN server
create_openvpn_server() {
    print_header "🏠 CREATE OPENVPN SERVER"
    
    echo "⚠️ Setting up OpenVPN server is complex and requires careful configuration."
    echo "For most users, we recommend using WireGuard instead (option 1 in main menu)."
    echo ""
    echo "🔧 OpenVPN server setup requires:"
    echo "• Certificate Authority (CA) setup"
    echo "• Server and client certificates"
    echo "• Complex firewall rules"
    echo "• Port forwarding configuration"
    echo ""
    
    read -p "Continue with OpenVPN server setup? (y/n): " continue_setup
    if [[ ! $continue_setup =~ ^[Yy]$ ]]; then
        echo "Setup cancelled. Consider using WireGuard for easier server setup."
        return 0
    fi
    
    echo "🚀 This will install and configure OpenVPN server using easy-rsa..."
    echo "This process may take several minutes."
    
    # Install dependencies
    if command -v apt &>/dev/null; then
        sudo apt install -y easy-rsa
    else
        log_error "Automatic OpenVPN server setup only supported on Debian/Ubuntu"
        echo "Please follow manual setup guide for your distribution"
        return 1
    fi
    
    # Run simplified server setup
    echo "📝 Setting up OpenVPN server with default configuration..."
    echo "For production use, please follow detailed security guides."
    
    notify_success "OpenVPN Server" "Basic server setup initiated (complex setup required)"
}

# Connect to OpenVPN
connect_openvpn() {
    print_header "🔗 CONNECT TO OPENVPN"
    
    # List available configurations
    local configs=($(find /etc/openvpn/client -name "*.conf" 2>/dev/null | xargs basename -s .conf))
    
    if [ ${#configs[@]} -eq 0 ]; then
        echo "⚠️ No OpenVPN configurations found"
        echo "Please import a configuration file first (option 1)"
        return 1
    fi
    
    echo "📋 Available OpenVPN configurations:"
    for i in "${!configs[@]}"; do
        local status="❌ Disconnected"
        if sudo systemctl is-active openvpn-client@${configs[i]} &>/dev/null; then
            status="✅ Connected"
        fi
        echo "$((i+1))) ${configs[i]} - $status"
    done
    echo "0) Disconnect all VPNs"
    echo ""
    
    read -p "Select configuration (0-${#configs[@]}): " config_choice
    
    if [ "$config_choice" = "0" ]; then
        echo "🔌 Disconnecting all OpenVPN connections..."
        sudo systemctl stop openvpn-client@*
        log_success "All VPN connections disconnected"
        return 0
    fi
    
    if [ "$config_choice" -le "${#configs[@]}" ] && [ "$config_choice" -gt 0 ]; then
        local selected_config="${configs[$((config_choice-1))]}"
        
        # Disconnect other VPNs first
        sudo systemctl stop openvpn-client@* 2>/dev/null || true
        sudo systemctl stop wg-quick@* 2>/dev/null || true
        
        echo "🔗 Connecting to $selected_config..."
        sudo systemctl start openvpn-client@$selected_config
        
        sleep 5
        
        if sudo systemctl is-active openvpn-client@$selected_config &>/dev/null; then
            log_success "Connected to $selected_config"
            echo "📊 Connection status:"
            ip addr show tun0 2>/dev/null || echo "VPN interface not found"
        else
            log_error "Failed to connect to $selected_config"
            echo "Check logs: sudo journalctl -u openvpn-client@$selected_config"
        fi
    else
        log_warning "Invalid selection"
    fi
}

# Manage OpenVPN connections
manage_openvpn_connections() {
    print_header "🛠️ MANAGE OPENVPN CONNECTIONS"
    
    echo "📋 OpenVPN Connection Management:"
    echo "1) List all configurations"
    echo "2) Enable auto-start for configuration"
    echo "3) Disable auto-start for configuration"
    echo "4) Remove configuration"
    echo "5) View connection logs"
    
    read -p "Select option (1-5): " mgmt_option
    
    case "$mgmt_option" in
        1)
            echo "📁 Available configurations:"
            find /etc/openvpn/client -name "*.conf" 2>/dev/null | while read config; do
                local name=$(basename "$config" .conf)
                local status="❌ Stopped"
                if sudo systemctl is-active openvpn-client@$name &>/dev/null; then
                    status="✅ Running"
                fi
                local enabled="🔄 Manual"
                if sudo systemctl is-enabled openvpn-client@$name &>/dev/null; then
                    enabled="🚀 Auto-start"
                fi
                echo "  $name - $status - $enabled"
            done
            ;;
        2|3)
            local configs=($(find /etc/openvpn/client -name "*.conf" 2>/dev/null | xargs basename -s .conf))
            if [ ${#configs[@]} -eq 0 ]; then
                echo "No configurations found"
                return 1
            fi
            
            echo "Select configuration:"
            for i in "${!configs[@]}"; do
                echo "$((i+1))) ${configs[i]}"
            done
            read -p "Configuration: " cfg_choice
            
            if [ "$cfg_choice" -le "${#configs[@]}" ] && [ "$cfg_choice" -gt 0 ]; then
                local selected="${configs[$((cfg_choice-1))]}"
                if [ "$mgmt_option" = "2" ]; then
                    sudo systemctl enable openvpn-client@$selected
                    log_success "Auto-start enabled for $selected"
                else
                    sudo systemctl disable openvpn-client@$selected
                    log_success "Auto-start disabled for $selected"
                fi
            fi
            ;;
        4)
            echo "⚠️ This will permanently delete the configuration file"
            local configs=($(find /etc/openvpn/client -name "*.conf" 2>/dev/null | xargs basename -s .conf))
            if [ ${#configs[@]} -eq 0 ]; then
                echo "No configurations found"
                return 1
            fi
            
            echo "Select configuration to remove:"
            for i in "${!configs[@]}"; do
                echo "$((i+1))) ${configs[i]}"
            done
            read -p "Configuration: " cfg_choice
            
            if [ "$cfg_choice" -le "${#configs[@]}" ] && [ "$cfg_choice" -gt 0 ]; then
                local selected="${configs[$((cfg_choice-1))]}"
                read -p "Really delete $selected? (type 'yes'): " confirm
                if [ "$confirm" = "yes" ]; then
                    sudo systemctl stop openvpn-client@$selected 2>/dev/null || true
                    sudo systemctl disable openvpn-client@$selected 2>/dev/null || true
                    sudo rm -f "/etc/openvpn/client/${selected}.conf"
                    sudo rm -f "/etc/openvpn/client/${selected}.auth"
                    log_success "Configuration $selected removed"
                fi
            fi
            ;;
        5)
            echo "📊 Recent OpenVPN logs:"
            sudo journalctl -u "openvpn-client@*" --since "1 hour ago" | tail -20
            ;;
    esac
}

# VPN Quick Connect
vpn_quick_connect() {
    print_header "⚡ VPN QUICK CONNECT"
    
    echo "🚀 Connect to your configured VPNs quickly:"
    echo ""
    
    # Check for WireGuard configurations
    local wg_configs=($(find /etc/wireguard -name "*.conf" 2>/dev/null | xargs basename -s .conf))
    
    # Check for OpenVPN configurations  
    local ovpn_configs=($(find /etc/openvpn/client -name "*.conf" 2>/dev/null | xargs basename -s .conf))
    
    if [ ${#wg_configs[@]} -eq 0 ] && [ ${#ovpn_configs[@]} -eq 0 ]; then
        echo "⚠️ No VPN configurations found"
        echo "Please set up WireGuard (option 1) or OpenVPN (option 2) first"
        return 1
    fi
    
    echo "📋 Available VPN connections:"
    local all_configs=()
    local config_types=()
    
    # Add WireGuard configs
    for config in "${wg_configs[@]}"; do
        local status="❌ Disconnected"
        if sudo systemctl is-active wg-quick@$config &>/dev/null; then
            status="✅ Connected"
        fi
        echo "${#all_configs[@]}) 🔐 $config (WireGuard) - $status"
        all_configs+=("$config")
        config_types+=("wireguard")
    done
    
    # Add OpenVPN configs
    for config in "${ovpn_configs[@]}"; do
        local status="❌ Disconnected"
        if sudo systemctl is-active openvpn-client@$config &>/dev/null; then
            status="✅ Connected"
        fi
        echo "${#all_configs[@]}) 🌍 $config (OpenVPN) - $status"
        all_configs+=("$config")
        config_types+=("openvpn")
    done
    
    echo "${#all_configs[@]}) 🔌 Disconnect all VPNs"
    echo ""
    
    read -p "Select VPN (0-${#all_configs[@]}): " vpn_choice
    
    if [ "$vpn_choice" = "${#all_configs[@]}" ]; then
        echo "🔌 Disconnecting all VPNs..."
        sudo systemctl stop wg-quick@* 2>/dev/null || true
        sudo systemctl stop openvpn-client@* 2>/dev/null || true
        log_success "All VPN connections disconnected"
        return 0
    fi
    
    if [ "$vpn_choice" -lt "${#all_configs[@]}" ] && [ "$vpn_choice" -ge 0 ]; then
        local selected_config="${all_configs[$vpn_choice]}"
        local config_type="${config_types[$vpn_choice]}"
        
        # Disconnect other VPNs first
        sudo systemctl stop wg-quick@* 2>/dev/null || true
        sudo systemctl stop openvpn-client@* 2>/dev/null || true
        
        echo "🔗 Connecting to $selected_config..."
        
        if [ "$config_type" = "wireguard" ]; then
            sudo systemctl start wg-quick@$selected_config
            if sudo systemctl is-active wg-quick@$selected_config &>/dev/null; then
                log_success "Connected to $selected_config (WireGuard)"
                echo "📊 WireGuard status:"
                sudo wg show
            else
                log_error "Failed to connect to $selected_config"
            fi
        else
            sudo systemctl start openvpn-client@$selected_config
            sleep 3
            if sudo systemctl is-active openvpn-client@$selected_config &>/dev/null; then
                log_success "Connected to $selected_config (OpenVPN)"
                echo "📊 OpenVPN status:"
                ip addr show tun0 2>/dev/null || echo "VPN interface not found"
            else
                log_error "Failed to connect to $selected_config"
            fi
        fi
    else
        log_warning "Invalid selection"
    fi
}

# Configure Firewall
configure_firewall() {
    print_header "🔥 FIREWALL CONFIGURATION"
    
    echo "🛡️ Set up firewall protection for your system:"
    echo "• Block unwanted incoming connections"
    echo "• Allow necessary services and applications"
    echo "• Create security rules for network access"
    echo "• Monitor and log connection attempts"
    echo ""
    
    # Check available firewall tools
    local firewall_tool=""
    if command -v ufw &>/dev/null; then
        firewall_tool="ufw"
        echo "🔥 Using UFW (Uncomplicated Firewall) - beginner-friendly"
    elif command -v firewall-cmd &>/dev/null; then
        firewall_tool="firewalld"
        echo "🔥 Using firewalld - enterprise firewall"
    elif command -v iptables &>/dev/null; then
        firewall_tool="iptables"
        echo "🔥 Using iptables - advanced firewall"
    else
        echo "📦 Installing UFW firewall..."
        if command -v apt &>/dev/null; then
            sudo apt install -y ufw
            firewall_tool="ufw"
        else
            log_error "Could not install firewall automatically"
            return 1
        fi
    fi
    
    echo ""
    echo "🔧 Firewall Configuration Options:"
    echo "1) Enable firewall with default rules"
    echo "2) Configure basic rules (recommended)"
    echo "3) Add custom rule"
    echo "4) Remove rule"
    echo "5) Reset firewall (start over)"
    echo "6) Disable firewall"
    
    read -p "Select option (1-6): " fw_option
    
    case "$fw_option" in
        1) enable_default_firewall "$firewall_tool" ;;
        2) configure_basic_firewall "$firewall_tool" ;;
        3) add_custom_firewall_rule "$firewall_tool" ;;
        4) remove_firewall_rule "$firewall_tool" ;;
        5) reset_firewall "$firewall_tool" ;;
        6) disable_firewall "$firewall_tool" ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Enable default firewall
enable_default_firewall() {
    local tool="$1"
    
    echo "🛡️ Enabling firewall with secure default rules..."
    
    if [ "$tool" = "ufw" ]; then
        # Reset and set defaults
        sudo ufw --force reset
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        
        # Allow essential services
        sudo ufw allow ssh
        sudo ufw allow 22/tcp
        
        # Enable firewall
        sudo ufw --force enable
        
        echo "✅ UFW firewall enabled with default rules"
        echo "📋 Current status:"
        sudo ufw status
        
    elif [ "$tool" = "firewalld" ]; then
        sudo systemctl start firewalld
        sudo systemctl enable firewalld
        sudo firewall-cmd --set-default-zone=public
        
        echo "✅ Firewalld enabled with default rules"
        echo "📋 Current status:"
        sudo firewall-cmd --state
        
    else
        echo "⚠️ Manual iptables configuration required"
        echo "Please configure iptables manually for your security needs"
    fi
    
    log_success "Firewall enabled with default security rules"
    notify_success "Firewall" "Default security rules activated"
}

# Configure basic firewall
configure_basic_firewall() {
    local tool="$1"
    
    echo "🔧 Setting up basic firewall rules..."
    echo ""
    
    if [ "$tool" = "ufw" ]; then
        # Reset firewall
        sudo ufw --force reset
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        
        echo "🔐 Configuring common services:"
        echo ""
        
        # SSH access
        read -p "Allow SSH access? (y/n): " allow_ssh
        if [[ $allow_ssh =~ ^[Yy]$ ]]; then
            sudo ufw allow ssh
            echo "✅ SSH access allowed"
        fi
        
        # Web browsing (usually allowed by default outgoing)
        echo "✅ Web browsing (HTTP/HTTPS) allowed by default"
        
        # Common applications
        read -p "Allow email clients (IMAP/SMTP)? (y/n): " allow_email
        if [[ $allow_email =~ ^[Yy]$ ]]; then
            sudo ufw allow out 587/tcp  # SMTP
            sudo ufw allow out 993/tcp  # IMAP SSL
            echo "✅ Email client access allowed"
        fi
        
        # VPN ports
        read -p "Allow VPN connections (WireGuard/OpenVPN)? (y/n): " allow_vpn
        if [[ $allow_vpn =~ ^[Yy]$ ]]; then
            sudo ufw allow 51820/udp  # WireGuard
            sudo ufw allow 1194/udp   # OpenVPN
            echo "✅ VPN ports allowed"
        fi
        
        # Gaming/streaming
        read -p "Allow gaming and streaming ports? (y/n): " allow_gaming
        if [[ $allow_gaming =~ ^[Yy]$ ]]; then
            sudo ufw allow out 3478:3497/udp  # Gaming/Discord
            sudo ufw allow out 1935/tcp       # Streaming
            echo "✅ Gaming and streaming ports allowed"
        fi
        
        # Enable firewall
        sudo ufw --force enable
        
        echo ""
        echo "✅ Basic firewall configuration complete"
        echo "📋 Current rules:"
        sudo ufw status numbered
        
    else
        echo "⚠️ Basic configuration only available for UFW"
        echo "Please configure $tool manually"
    fi
    
    notify_success "Firewall" "Basic security rules configured"
}

# Add custom firewall rule
add_custom_firewall_rule() {
    local tool="$1"
    
    echo "➕ Add custom firewall rule"
    echo ""
    
    if [ "$tool" = "ufw" ]; then
        echo "🔧 Rule types:"
        echo "1) Allow incoming port"
        echo "2) Allow outgoing port"
        echo "3) Allow application"
        echo "4) Allow from specific IP"
        
        read -p "Select rule type (1-4): " rule_type
        
        case "$rule_type" in
            1)
                read -p "Port number: " port
                read -p "Protocol (tcp/udp): " protocol
                sudo ufw allow in $port/$protocol
                echo "✅ Allowed incoming $protocol/$port"
                ;;
            2)
                read -p "Port number: " port
                read -p "Protocol (tcp/udp): " protocol
                sudo ufw allow out $port/$protocol
                echo "✅ Allowed outgoing $protocol/$port"
                ;;
            3)
                echo "📋 Available applications:"
                sudo ufw app list
                read -p "Application name: " app_name
                sudo ufw allow "$app_name"
                echo "✅ Allowed application: $app_name"
                ;;
            4)
                read -p "IP address: " ip_addr
                sudo ufw allow from $ip_addr
                echo "✅ Allowed access from: $ip_addr"
                ;;
        esac
        
        echo ""
        echo "📋 Updated firewall status:"
        sudo ufw status numbered
        
    else
        echo "⚠️ Custom rules only supported for UFW in this interface"
        echo "For $tool, please use command line tools directly"
    fi
}

# Remove firewall rule
remove_firewall_rule() {
    local tool="$1"
    
    echo "➖ Remove firewall rule"
    echo ""
    
    if [ "$tool" = "ufw" ]; then
        echo "📋 Current firewall rules:"
        sudo ufw status numbered
        echo ""
        
        read -p "Rule number to remove: " rule_num
        if [[ $rule_num =~ ^[0-9]+$ ]]; then
            sudo ufw --force delete $rule_num
            echo "✅ Rule $rule_num removed"
            echo ""
            echo "📋 Updated firewall status:"
            sudo ufw status numbered
        else
            log_warning "Invalid rule number"
        fi
    else
        echo "⚠️ Rule removal only supported for UFW in this interface"
    fi
}

# Reset firewall
reset_firewall() {
    local tool="$1"
    
    echo "🔄 Reset firewall configuration"
    echo "⚠️ This will remove all custom rules and disable the firewall"
    echo ""
    
    read -p "Really reset firewall? (type 'yes'): " confirm
    if [ "$confirm" = "yes" ]; then
        if [ "$tool" = "ufw" ]; then
            sudo ufw --force reset
            echo "✅ UFW firewall reset to defaults"
        elif [ "$tool" = "firewalld" ]; then
            sudo firewall-cmd --complete-reload
            echo "✅ Firewalld configuration reloaded"
        else
            echo "⚠️ Manual reset required for $tool"
        fi
        
        log_success "Firewall configuration reset"
    else
        echo "Reset cancelled"
    fi
}

# Disable firewall
disable_firewall() {
    local tool="$1"
    
    echo "⚠️ Disable firewall protection"
    echo "This will leave your system more vulnerable to network attacks"
    echo ""
    
    read -p "Really disable firewall? (type 'yes'): " confirm
    if [ "$confirm" = "yes" ]; then
        if [ "$tool" = "ufw" ]; then
            sudo ufw disable
            echo "⚠️ UFW firewall disabled"
        elif [ "$tool" = "firewalld" ]; then
            sudo systemctl stop firewalld
            sudo systemctl disable firewalld
            echo "⚠️ Firewalld disabled"
        else
            echo "⚠️ Manual disable required for $tool"
        fi
        
        log_warning "Firewall disabled - system security reduced"
        notify_success "Firewall" "Firewall protection disabled"
    else
        echo "Disable cancelled - firewall remains active"
    fi
}

# Main execution
main() {
    echo "🔐 VPN & Security Management Center"
    echo "🧠 Designed for ADHD brains - simple, clear, effective!"
    echo ""
    
    # Detect capabilities
    detect_security_capabilities
    
    # Run main menu
    vpn_security_menu
    
    echo ""
    echo "🔐 Thank you for using VPN & Security Management!"
    echo "🛡️ Stay secure and protect your privacy!"
    
    # Update adaptive learning
    update_adaptive_learning "vpn_security" "completed_session" 2>/dev/null || true
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi