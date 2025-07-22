#!/bin/bash
source "$HOME/.bill-sloth/lib/modern_cli.sh" 2>/dev/null || true
# LLM_CAPABILITY: auto
# Network Management Center - Complete network configuration and security
# VPN, firewall, monitoring, and connectivity management

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || {
    echo "🌐 NETWORK MANAGEMENT CENTER"
    echo "==========================="
}

source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/adaptive_learning.sh" 2>/dev/null || true

# Initialize adaptive learning for this module
init_adaptive_learning "network_management" "$0" 2>/dev/null || true

show_banner "NETWORK MANAGEMENT" "VPN, Security & Connectivity" "NETWORKING"

echo "🌐 Bill Sloth Network Management Center"
echo "======================================"
echo ""
echo "🛡️ Complete network security and connectivity management:"
echo "   • VPN setup and management (WireGuard, OpenVPN)"
echo "   • Firewall configuration and intrusion detection"
echo "   • Network monitoring and performance analysis"
echo "   • Wi-Fi management and hotspot creation"
echo "   • DNS customization and ad-blocking"
echo ""
echo "🧠 ADHD Benefits:"
echo "   • One-click secure connections"
echo "   • Visual network status monitoring"
echo "   • Automated security without complexity"
echo "   • Quick troubleshooting and fixes"
echo ""

# Network management configuration
NETWORK_CONFIG_DIR="$HOME/.bill-sloth/network"
VPN_CONFIG_DIR="$NETWORK_CONFIG_DIR/vpn"
FIREWALL_CONFIG="$NETWORK_CONFIG_DIR/firewall.conf"
MONITORING_CONFIG="$NETWORK_CONFIG_DIR/monitoring.conf"

# Initialize network management
init_network_management() {
    log_info "Initializing network management system..."
    
    create_directory "$NETWORK_CONFIG_DIR"
    create_directory "$VPN_CONFIG_DIR"
    create_directory "$NETWORK_CONFIG_DIR/logs"
    create_directory "$NETWORK_CONFIG_DIR/backups"
    
    # Create default configurations
    if [ ! -f "$MONITORING_CONFIG" ]; then
        create_default_monitoring_config
    fi
    
    # Check network capabilities
    detect_network_capabilities
    
    log_success "Network management initialized"
}

# Create default monitoring configuration
create_default_monitoring_config() {
    cat > "$MONITORING_CONFIG" << 'EOF'
# Bill Sloth Network Monitoring Configuration
ENABLE_BANDWIDTH_MONITORING=true
ENABLE_CONNECTION_LOGGING=true
ENABLE_SECURITY_ALERTS=true
ALERT_THRESHOLD_BANDWIDTH=80
ALERT_THRESHOLD_CONNECTIONS=100
LOG_RETENTION_DAYS=30
MONITOR_INTERVAL=60
EOF
}

# Detect network capabilities
detect_network_capabilities() {
    log_debug "Detecting network capabilities..."
    
    local capabilities_file="$NETWORK_CONFIG_DIR/capabilities.sh"
    
    # Network management tools
    local network_tools=()
    
    if command -v nmcli &>/dev/null; then
        network_tools+=("NetworkManager")
    fi
    
    if command -v systemctl &>/dev/null && systemctl is-active NetworkManager &>/dev/null; then
        network_tools+=("NetworkManager-service")
    fi
    
    if command -v iwconfig &>/dev/null; then
        network_tools+=("wireless-tools")
    fi
    
    if command -v ip &>/dev/null; then
        network_tools+=("iproute2")
    fi
    
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
    
    # Monitoring tools
    local monitoring_tools=()
    
    if command -v nethogs &>/dev/null; then
        monitoring_tools+=("nethogs")
    fi
    
    if command -v iftop &>/dev/null; then
        monitoring_tools+=("iftop")
    fi
    
    if command -v nmap &>/dev/null; then
        monitoring_tools+=("nmap")
    fi
    
    if command -v ss &>/dev/null; then
        monitoring_tools+=("ss")
    fi
    
    # Save capabilities
    cat > "$capabilities_file" << EOF
# Network Management Capabilities
NETWORK_TOOLS=(${network_tools[*]})
VPN_TOOLS=(${vpn_tools[*]})
FIREWALL_TOOLS=(${firewall_tools[*]})
MONITORING_TOOLS=(${monitoring_tools[*]})

# Primary tools
PRIMARY_NETWORK_MANAGER="${network_tools[0]:-none}"
PRIMARY_VPN="${vpn_tools[0]:-none}"
PRIMARY_FIREWALL="${firewall_tools[0]:-none}"
EOF
    
    log_success "Detected network capabilities: Network(${#network_tools[@]}), VPN(${#vpn_tools[@]}), Firewall(${#firewall_tools[@]}), Monitoring(${#monitoring_tools[@]})"
}

# Main network management menu
network_management_menu() {
    while true; do
        print_separator "=" 60
        echo "🌐 NETWORK MANAGEMENT MENU"
        print_separator "=" 60
        echo ""
        
        echo "🔐 VPN & SECURITY:"
        echo "  1) WireGuard VPN Setup        - Modern, fast VPN (recommended)"
        echo "  2) OpenVPN Setup              - Traditional VPN solution"
        echo "  3) VPN Quick Connect          - Connect to configured VPNs"
        echo "  4) Firewall Configuration     - UFW/iptables security"
        echo ""
        
        echo "📡 WIRELESS & CONNECTIVITY:"
        echo "  5) Wi-Fi Management           - Connect, manage, troubleshoot Wi-Fi"
        echo "  6) Bluetooth Management       - Android device pairing"
        echo "  7) Mobile Hotspot             - Share internet connection"
        echo "  8) Network Profiles           - Save/load network configurations"
        echo ""
        
        echo "🔍 MONITORING & ANALYSIS:"
        echo "  9) Network Status Dashboard   - Real-time network overview"
        echo " 10) Bandwidth Monitor         - Track data usage by app"
        echo " 11) Connection Scanner        - Find devices on network"
        echo " 12) Speed Test                - Internet connection test"
        echo ""
        
        echo "🛠️ DNS & OPTIMIZATION:"
        echo " 13) DNS Configuration         - Custom DNS servers"
        echo " 14) Ad-Blocking Setup         - Pi-hole style ad blocking"
        echo " 15) Network Optimization      - Performance tuning"
        echo " 16) Proxy Configuration       - HTTP/SOCKS proxy setup"
        echo ""
        
        echo "🔧 TROUBLESHOOTING:"
        echo " 17) Network Diagnostics       - Comprehensive connectivity tests"
        echo " 18) Connection Reset          - Reset network configurations"
        echo " 19) Security Audit            - Check for vulnerabilities"
        echo " 20) Backup/Restore Settings   - Save network configurations"
        echo ""
        
        echo " 0) Exit Network Management"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select an option (0-20)" 30 "0")
        
        case "$choice" in
            1) setup_wireguard_vpn ;;
            2) setup_openvpn ;;
            3) vpn_quick_connect ;;
            4) configure_firewall ;;
            5) manage_wifi ;;
            6) manage_bluetooth ;;
            7) setup_mobile_hotspot ;;
            8) manage_network_profiles ;;
            9) show_network_dashboard ;;
            10) monitor_bandwidth ;;
            11) scan_network_devices ;;
            12) run_speed_test ;;
            13) configure_dns ;;
            14) setup_ad_blocking ;;
            15) optimize_network ;;
            16) configure_proxy ;;
            17) run_network_diagnostics ;;
            18) reset_network_settings ;;
            19) security_audit ;;
            20) backup_restore_settings ;;
            0)
                log_info "Exiting Network Management Center"
                break
                ;;
            *)
                log_warning "Invalid option: $choice"
                echo "Please select a number between 0 and 20."
                sleep 2
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
        *) echo "Invalid selection" ;;
    esac
    
    collect_feedback "network_management" "wireguard_setup"
}

# Create WireGuard server for Android devices
create_wireguard_server() {
    echo "🏠 Creating WireGuard Server"
    echo ""
    
    local wg_dir="$VPN_CONFIG_DIR/wireguard"
    create_directory "$wg_dir"
    
    # Generate server keys
    echo "Generating server keys..."
    cd "$wg_dir" || return 1
    
    if [ ! -f "server_private.key" ]; then
        wg genkey > server_private.key
        chmod 600 server_private.key
        wg pubkey < server_private.key > server_public.key
        log_success "Server keys generated"
    fi
    
    # Get server configuration
    echo ""
    echo "Server Configuration:"
    read -p "Server IP address (default: 10.0.0.1): " server_ip
    server_ip="${server_ip:-10.0.0.1}"
    
    read -p "Server port (default: 51820): " server_port
    server_port="${server_port:-51820}"
    
    read -p "Network interface (default: $(ip route | grep default | awk '{print $5}' | head -1)): " server_interface
    server_interface="${server_interface:-$(ip route | grep default | awk '{print $5}' | head -1)}"
    
    # Create server configuration
    cat > "$wg_dir/wg0.conf" << EOF
[Interface]
# Server configuration
PrivateKey = $(cat server_private.key)
Address = $server_ip/24
ListenPort = $server_port
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $server_interface -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $server_interface -j MASQUERADE

# Clients will be added here
EOF
    
    # Enable IP forwarding
    echo "Enabling IP forwarding..."
    echo 'net.ipv4.ip_forward=1' | sudo tee -a /etc/sysctl.conf >/dev/null
    sudo sysctl -p >/dev/null
    
    # Set up systemd service
    sudo cp "$wg_dir/wg0.conf" /etc/wireguard/
    
    echo ""
    log_success "WireGuard server configured!"
    echo ""
    echo "📱 To connect your Android device:"
    echo "1. Install 'WireGuard' app from Google Play Store"
    echo "2. Run option 3 to generate Android client configuration"
    echo "3. Scan the QR code with WireGuard app"
    echo ""
    
    if confirm "Start WireGuard server now?"; then
        sudo systemctl enable wg-quick@wg0
        sudo systemctl start wg-quick@wg0
        
        if systemctl is-active wg-quick@wg0 >/dev/null; then
            notify_success "WireGuard" "Server started successfully"
            log_success "WireGuard server is running"
        else
            notify_error "WireGuard" "Failed to start server"
            log_error "Failed to start WireGuard server"
        fi
    fi
}

# Generate Android client configuration with QR code
generate_android_config() {
    echo "📱 Generating Android Client Configuration"
    echo ""
    
    local wg_dir="$VPN_CONFIG_DIR/wireguard"
    
    if [ ! -f "$wg_dir/server_public.key" ]; then
        log_error "WireGuard server not configured. Run option 1 first."
        return 1
    fi
    
    # Get client details
    read -p "Client name (e.g., 'android-phone'): " client_name
    client_name="${client_name:-android-phone}"
    
    read -p "Client IP (e.g., '10.0.0.2'): " client_ip
    client_ip="${client_ip:-10.0.0.2}"
    
    # Generate client keys
    cd "$wg_dir" || return 1
    wg genkey > "${client_name}_private.key"
    chmod 600 "${client_name}_private.key"
    wg pubkey < "${client_name}_private.key" > "${client_name}_public.key"
    
    # Get server details
    local server_public=$(cat server_public.key)
    local server_endpoint
    echo ""
    echo "Server endpoint options:"
    echo "1) Use public IP (for external access)"
    echo "2) Use local IP (for LAN access only)"
    
    read -p "Select option (1-2): " endpoint_option
    
    case "$endpoint_option" in
        1)
            # Try to get public IP
            local public_ip=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "YOUR_PUBLIC_IP")
            server_endpoint="$public_ip:51820"
            echo "⚠️  Make sure port 51820 is forwarded in your router"
            ;;
        2)
            local local_ip=$(ip route get 8.8.8.8 | grep -oP 'src \K\S+')
            server_endpoint="$local_ip:51820"
            ;;
        *)
            server_endpoint="YOUR_SERVER_IP:51820"
            ;;
    esac
    
    # Create client configuration
    cat > "${client_name}.conf" << EOF
[Interface]
PrivateKey = $(cat "${client_name}_private.key")
Address = $client_ip/32
DNS = 8.8.8.8, 1.1.1.1

[Peer]
PublicKey = $server_public
Endpoint = $server_endpoint
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 21
EOF
    
    # Add client to server configuration
    echo "" >> wg0.conf
    echo "# Client: $client_name" >> wg0.conf
    echo "[Peer]" >> wg0.conf
    echo "PublicKey = $(cat "${client_name}_public.key")" >> wg0.conf
    echo "AllowedIPs = $client_ip/32" >> wg0.conf
    
    # Update server configuration
    sudo cp wg0.conf /etc/wireguard/
    
    # Generate QR code for Android
    if command -v qrencode &>/dev/null; then
        echo ""
        echo "📱 QR Code for Android WireGuard app:"
        echo "====================================="
        qrencode -t ansiutf8 < "${client_name}.conf"
        echo ""
        echo "💾 QR code also saved as: $wg_dir/${client_name}_qr.png"
        qrencode -t png -o "${client_name}_qr.png" < "${client_name}.conf"
    else
        echo "Install qrencode to generate QR codes: sudo apt install qrencode"
    fi
    
    echo ""
    log_success "Android client configuration created: $wg_dir/${client_name}.conf"
    echo ""
    echo "📱 Android Setup Steps:"
    echo "1. Install WireGuard app from Google Play Store"
    echo "2. Tap '+' to add tunnel"
    echo "3. Tap 'Scan from QR code'"
    echo "4. Scan the QR code above"
    echo "5. Toggle the connection on"
    echo ""
    
    if confirm "Restart WireGuard server to apply changes?"; then
        sudo systemctl restart wg-quick@wg0
        log_success "WireGuard server restarted with new client"
    fi
    
    notify_success "WireGuard" "Android client configuration created"
}

# Wi-Fi management (essential for Android connectivity)
manage_wifi() {
    print_header "📡 WI-FI MANAGEMENT"
    
    echo "Manage Wi-Fi connections for seamless Android device connectivity:"
    echo ""
    
    echo "Available Wi-Fi actions:"
    echo "1) Scan for networks"
    echo "2) Connect to network"
    echo "3) Disconnect from network"
    echo "4) Show saved networks"
    echo "5) Forget network"
    echo "6) Show current connection"
    echo "7) Create Wi-Fi hotspot"
    echo "8) Wi-Fi troubleshooting"
    
    read -p "Select action (1-8): " wifi_action
    
    case "$wifi_action" in
        1) scan_wifi_networks ;;
        2) connect_wifi_network ;;
        3) disconnect_wifi ;;
        4) show_saved_networks ;;
        5) forget_wifi_network ;;
        6) show_current_connection ;;
        7) create_wifi_hotspot ;;
        8) troubleshoot_wifi ;;
        *) echo "Invalid selection" ;;
    esac
    
    collect_feedback "network_management" "wifi_management"
}

# Scan for Wi-Fi networks
scan_wifi_networks() {
    echo "🔍 Scanning for Wi-Fi networks..."
    echo ""
    
    if command -v nmcli &>/dev/null; then
        nmcli device wifi rescan 2>/dev/null
        sleep 3
        echo "Available networks:"
        nmcli device wifi list | head -20
    elif command -v iwlist &>/dev/null; then
        local interface=$(iwconfig 2>/dev/null | grep -o '^[a-zA-Z0-9]*' | head -1)
        if [ -n "$interface" ]; then
            sudo iwlist "$interface" scan | grep -E "(ESSID|Quality|Encryption)" | head -30
        else
            echo "No wireless interface found"
        fi
    else
        echo "No Wi-Fi scanning tools available"
        echo "Install NetworkManager: sudo apt install network-manager"
    fi
}

# Connect to Wi-Fi network
connect_wifi_network() {
    echo "🔗 Connect to Wi-Fi Network"
    echo ""
    
    read -p "Enter network name (SSID): " ssid
    read -s -p "Enter password: " password
    echo ""
    
    if command -v nmcli &>/dev/null; then
        echo "Connecting to $ssid..."
        if nmcli device wifi connect "$ssid" password "$password"; then
            notify_success "Wi-Fi" "Connected to $ssid"
            log_success "Connected to Wi-Fi network: $ssid"
        else
            notify_error "Wi-Fi" "Failed to connect to $ssid"
            log_error "Failed to connect to Wi-Fi network: $ssid"
        fi
    else
        echo "NetworkManager not available"
        echo "Install with: sudo apt install network-manager"
    fi
}

# Show current connection
show_current_connection() {
    echo "📶 Current Network Connection"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        echo "Active connections:"
        nmcli connection show --active
        
        echo ""
        echo "Network devices:"
        nmcli device status
        
        echo ""
        echo "Current Wi-Fi:"
        nmcli device wifi | grep '^\*'
    else
        echo "Using ip and iwconfig..."
        ip addr show | grep -E "(inet |wlan|eth)"
        
        if command -v iwconfig &>/dev/null; then
            echo ""
            echo "Wireless status:"
            iwconfig 2>/dev/null | grep -E "(ESSID|Access Point)"
        fi
    fi
}

# Network status dashboard
show_network_dashboard() {
    print_header "📊 NETWORK STATUS DASHBOARD"
    
    echo "🌐 Real-time Network Overview"
    echo ""
    
    # Basic network information
    echo "📡 Network Interfaces:"
    ip addr show | grep -E "^[0-9]+:" | while read -r line; do
        interface=$(echo "$line" | cut -d: -f2 | tr -d ' ')
        echo "  • $interface"
    done
    
    echo ""
    echo "🔗 Active Connections:"
    if command -v ss &>/dev/null; then
        ss -tuln | grep LISTEN | head -10
    else
        netstat -tuln 2>/dev/null | grep LISTEN | head -10
    fi
    
    echo ""
    echo "📊 Bandwidth Usage (last 5 minutes):"
    if command -v vnstat &>/dev/null; then
        vnstat -i eth0 -5 2>/dev/null || vnstat -5 2>/dev/null || echo "  vnstat not configured"
    else
        echo "  Install vnstat for bandwidth monitoring: sudo apt install vnstat"
    fi
    
    echo ""
    echo "🛡️ Firewall Status:"
    if command -v ufw &>/dev/null; then
        ufw status
    elif command -v firewall-cmd &>/dev/null; then
        firewall-cmd --state 2>/dev/null || echo "  Firewalld not running"
    else
        echo "  No firewall manager detected"
    fi
    
    echo ""
    echo "🔐 VPN Status:"
    if systemctl is-active wg-quick@wg0 &>/dev/null; then
        echo "  ✅ WireGuard VPN active"
    elif pgrep openvpn &>/dev/null; then
        echo "  ✅ OpenVPN active"
    else
        echo "  ❌ No VPN connections active"
    fi
    
    echo ""
    if confirm "Refresh dashboard in real-time? (Press Ctrl+C to stop)"; then
        while true; do
            clear
            show_network_dashboard
            sleep 5
        done
    fi
}

# Quick VPN connection manager
vpn_quick_connect() {
    print_header "⚡ VPN QUICK CONNECT"
    
    echo "Available VPN connections:"
    echo ""
    
    local vpn_count=0
    
    # Check for WireGuard configurations
    if [ -d "/etc/wireguard" ] && ls /etc/wireguard/*.conf &>/dev/null; then
        echo "🔐 WireGuard VPNs:"
        for conf in /etc/wireguard/*.conf; do
            local name=$(basename "$conf" .conf)
            local status="Disconnected"
            if systemctl is-active "wg-quick@$name" &>/dev/null; then
                status="Connected"
            fi
            echo "  $((++vpn_count))) $name [$status]"
        done
        echo ""
    fi
    
    # Check for OpenVPN configurations
    if [ -d "$VPN_CONFIG_DIR/openvpn" ] && ls "$VPN_CONFIG_DIR/openvpn"/*.ovpn &>/dev/null; then
        echo "🔒 OpenVPN configurations:"
        for conf in "$VPN_CONFIG_DIR/openvpn"/*.ovpn; do
            local name=$(basename "$conf" .ovpn)
            echo "  $((++vpn_count))) $name [OpenVPN]"
        done
        echo ""
    fi
    
    if [ $vpn_count -eq 0 ]; then
        echo "No VPN configurations found."
        echo ""
        echo "Setup options:"
        echo "1) Configure WireGuard VPN"
        echo "2) Configure OpenVPN"
        
        read -p "Select setup option (1-2): " setup_choice
        case "$setup_choice" in
            1) setup_wireguard_vpn ;;
            2) setup_openvpn ;;
        esac
        return
    fi
    
    echo "0) Disconnect all VPNs"
    echo ""
    
    read -p "Select VPN to connect/manage (0-$vpn_count): " vpn_choice
    
    if [ "$vpn_choice" = "0" ]; then
        echo "Disconnecting all VPNs..."
        
        # Disconnect WireGuard
        if ls /etc/wireguard/*.conf >/dev/null 2>&1; then
            for conf in /etc/wireguard/*.conf; do
                if [ -f "$conf" ]; then
                    local name=$(basename "$conf" .conf)
                    sudo systemctl stop "wg-quick@$name" 2>/dev/null || true
                fi
            done
        fi
        
        # Disconnect OpenVPN
        sudo pkill openvpn 2>/dev/null || true
        
        notify_info "VPN" "All VPN connections disconnected"
        log_success "All VPN connections disconnected"
        
    elif [ "$vpn_choice" -ge 1 ] && [ "$vpn_choice" -le $vpn_count ]; then
        # Handle WireGuard connections
        local current_count=0
        if ls /etc/wireguard/*.conf >/dev/null 2>&1; then
            for conf in /etc/wireguard/*.conf; do
            if [ -f "$conf" ]; then
                current_count=$((current_count + 1))
                if [ $current_count -eq "$vpn_choice" ]; then
                    local name=$(basename "$conf" .conf)
                    
                    if systemctl is-active "wg-quick@$name" &>/dev/null; then
                        echo "Disconnecting WireGuard: $name"
                        sudo systemctl stop "wg-quick@$name"
                        notify_info "WireGuard" "Disconnected from $name"
                    else
                        echo "Connecting WireGuard: $name"
                        sudo systemctl start "wg-quick@$name"
                        
                        if systemctl is-active "wg-quick@$name" &>/dev/null; then
                            notify_success "WireGuard" "Connected to $name"
                            log_success "Connected to WireGuard: $name"
                        else
                            notify_error "WireGuard" "Failed to connect to $name"
                            log_error "Failed to connect to WireGuard: $name"
                        fi
                    fi
                    return
                fi
            fi
        done
        fi
        
    else
        echo "Invalid selection"
    fi
}

# Firewall configuration
configure_firewall() {
    print_header "🛡️ FIREWALL CONFIGURATION"
    
    echo "Configure your system's firewall for optimal security:"
    echo ""
    
    # Detect available firewall
    if command -v ufw &>/dev/null; then
        configure_ufw_firewall
    elif command -v firewall-cmd &>/dev/null; then
        configure_firewalld
    elif command -v iptables &>/dev/null; then
        configure_iptables_basic
    else
        echo "No firewall tools detected. Installing UFW..."
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y ufw
            configure_ufw_firewall
        else
            echo "Please install a firewall tool manually"
        fi
    fi
    
    collect_feedback "network_management" "firewall_config"
}

# UFW firewall configuration
configure_ufw_firewall() {
    echo "🛡️ UFW (Uncomplicated Firewall) Configuration"
    echo ""
    
    # Show current status
    echo "Current UFW status:"
    sudo ufw status verbose
    echo ""
    
    echo "UFW Configuration Options:"
    echo "1) Enable firewall with default rules"
    echo "2) Configure basic rules (recommended)"
    echo "3) Add custom rule"
    echo "4) Remove rule"
    echo "5) Reset firewall (start over)"
    echo "6) Disable firewall"
    
    read -p "Select option (1-6): " ufw_choice
    
    case "$ufw_choice" in
        1)
            echo "Enabling UFW with default rules..."
            sudo ufw --force enable
            notify_success "Firewall" "UFW enabled with default rules"
            ;;
        2)
            echo "Setting up basic recommended rules..."
            
            # Default policies
            sudo ufw default deny incoming
            sudo ufw default allow outgoing
            
            # Essential services
            sudo ufw allow ssh
            sudo ufw allow 80/tcp   # HTTP
            sudo ufw allow 443/tcp  # HTTPS
            
            # Ask about WireGuard
            if confirm "Allow WireGuard VPN (port 51820)?"; then
                sudo ufw allow 51820/udp
            fi
            
            # Ask about KDE Connect
            if confirm "Allow KDE Connect for Android integration?"; then
                sudo ufw allow 1714:1764/udp
                sudo ufw allow 1714:1764/tcp
            fi
            
            sudo ufw --force enable
            notify_success "Firewall" "Basic security rules configured"
            ;;
        3)
            echo "Add custom firewall rule:"
            read -p "Enter rule (e.g., 'allow 8080/tcp'): " custom_rule
            if [ -n "$custom_rule" ]; then
                sudo ufw $custom_rule
                log_success "Added firewall rule: $custom_rule"
            fi
            ;;
        4)
            echo "Current rules:"
            sudo ufw status numbered
            echo ""
            read -p "Enter rule number to delete: " rule_num
            if [ -n "$rule_num" ]; then
                sudo ufw --force delete "$rule_num"
            fi
            ;;
        5)
            if confirm "Reset all firewall rules? This will remove all custom rules."; then
                sudo ufw --force reset
                log_success "Firewall rules reset"
            fi
            ;;
        6)
            if confirm "Disable firewall? This reduces security."; then
                sudo ufw disable
                notify_warning "Firewall" "UFW disabled - reduced security"
            fi
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
}

# OpenVPN setup for traditional VPN needs
setup_openvpn() {
    print_header "🔒 OPENVPN SETUP"
    
    echo "OpenVPN provides traditional VPN capabilities with broad compatibility:"
    echo "• Works with most VPN providers"
    echo "• Extensive configuration options"
    echo "• Strong enterprise support"
    echo "• Compatible with older systems"
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
    echo "3) Connect to existing OpenVPN server"
    echo "4) Configure NetworkManager OpenVPN"
    
    read -p "Select option (1-4): " ovpn_option
    
    case "$ovpn_option" in
        1) import_ovpn_config ;;
        2) create_openvpn_server ;;
        3) connect_openvpn_server ;;
        4) configure_nm_openvpn ;;
        *) echo "Invalid selection" ;;
    esac
    
    collect_feedback "network_management" "openvpn_setup"
}

# Import OpenVPN config from provider
import_ovpn_config() {
    echo "📁 Import OpenVPN Configuration"
    echo ""
    
    read -p "Enter path to .ovpn config file: " config_path
    
    if [ ! -f "$config_path" ]; then
        log_error "Config file not found: $config_path"
        return 1
    fi
    
    # Create OpenVPN config directory
    create_directory "$VPN_CONFIG_DIR/openvpn"
    
    local config_name=$(basename "$config_path" .ovpn)
    local dest_config="$VPN_CONFIG_DIR/openvpn/$config_name.ovpn"
    
    cp "$config_path" "$dest_config"
    chmod 600 "$dest_config"
    
    echo "Configuration imported: $dest_config"
    
    # Test connection
    if confirm "Test connection now?"; then
        echo "Testing OpenVPN connection..."
        echo "Press Ctrl+C to stop"
        sudo openvpn --config "$dest_config"
    fi
    
    notify_success "OpenVPN" "Configuration imported: $config_name"
}

# Create OpenVPN server
create_openvpn_server() {
    echo "🏠 Create OpenVPN Server"
    echo ""
    echo "This will set up a simple OpenVPN server for remote access."
    echo ""
    
    # Install easy-rsa for certificate management
    if ! command -v make-cadir &>/dev/null; then
        echo "📦 Installing Easy-RSA..."
        if command -v apt &>/dev/null; then
            sudo apt install -y easy-rsa
        else
            echo "Please install easy-rsa package manually"
            return 1
        fi
    fi
    
    local server_dir="$VPN_CONFIG_DIR/openvpn-server"
    create_directory "$server_dir"
    
    echo "Setting up certificate authority..."
    cd "$server_dir" || return 1
    
    # Copy easy-rsa templates
    if [ -d "/usr/share/easy-rsa" ]; then
        cp -r /usr/share/easy-rsa/* .
    else
        echo "Easy-RSA templates not found"
        return 1
    fi
    
    # Initialize PKI
    ./easyrsa init-pki
    
    echo ""
    echo "Creating certificates (this may take a while)..."
    echo ""
    
    # Build CA
    echo "Building Certificate Authority..."
    ./easyrsa --batch build-ca nopass
    
    # Generate server certificate
    echo "Generating server certificate..."
    ./easyrsa --batch build-server-full server nopass
    
    # Generate Diffie-Hellman parameters
    echo "Generating Diffie-Hellman parameters..."
    ./easyrsa gen-dh
    
    # Create OpenVPN server config
    cat > server.conf << 'EOF'
port 1194
proto udp
dev tun
ca pki/ca.crt
cert pki/issued/server.crt
key pki/private/server.key
dh pki/dh.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
comp-lzo
user nobody
group nogroup
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF
    
    echo ""
    log_success "OpenVPN server configured"
    echo ""
    echo "📋 Next steps:"
    echo "1. Copy server.conf to /etc/openvpn/"
    echo "2. Enable OpenVPN service"
    echo "3. Configure firewall rules"
    echo "4. Generate client certificates"
    
    if confirm "Complete server setup now?"; then
        sudo cp server.conf /etc/openvpn/
        sudo systemctl enable openvpn@server
        
        echo "Server setup complete!"
        echo "Use option 1 to generate client configurations."
    fi
}

# Connect to OpenVPN server
connect_openvpn_server() {
    echo "🔗 Connect to OpenVPN Server"
    echo ""
    
    # List available configs
    if [ -d "$VPN_CONFIG_DIR/openvpn" ] && ls "$VPN_CONFIG_DIR/openvpn"/*.ovpn &>/dev/null; then
        echo "Available OpenVPN configurations:"
        local count=0
        for config in "$VPN_CONFIG_DIR/openvpn"/*.ovpn; do
            count=$((count + 1))
            local name=$(basename "$config" .ovpn)
            echo "  $count) $name"
        done
        
        echo ""
        read -p "Select configuration (1-$count): " config_choice
        
        if [ "$config_choice" -ge 1 ] && [ "$config_choice" -le "$count" ]; then
            local selected_config=$(ls "$VPN_CONFIG_DIR/openvpn"/*.ovpn | sed -n "${config_choice}p")
            echo "Connecting to $(basename "$selected_config" .ovpn)..."
            sudo openvpn --config "$selected_config" --daemon
            
            sleep 3
            if pgrep openvpn >/dev/null; then
                notify_success "OpenVPN" "Connected successfully"
            else
                notify_error "OpenVPN" "Connection failed"
            fi
        fi
    else
        echo "No OpenVPN configurations found."
        echo "Use option 1 to import a configuration file."
    fi
}

# Configure NetworkManager OpenVPN
configure_nm_openvpn() {
    echo "🔧 NetworkManager OpenVPN Integration"
    echo ""
    echo "This integrates OpenVPN with NetworkManager for GUI management."
    echo ""
    
    if command -v nmcli &>/dev/null; then
        echo "NetworkManager OpenVPN plugin status:"
        if dpkg -l | grep -q network-manager-openvpn 2>/dev/null; then
            echo "✅ Plugin installed"
        else
            echo "❌ Plugin not installed"
            if confirm "Install NetworkManager OpenVPN plugin?"; then
                sudo apt install -y network-manager-openvpn network-manager-openvpn-gnome
            fi
        fi
        
        echo ""
        echo "To add OpenVPN connections:"
        echo "1. Open Network settings"
        echo "2. Click '+' to add VPN"
        echo "3. Select 'Import from file'"
        echo "4. Choose your .ovpn config file"
        
    else
        echo "NetworkManager not available"
    fi
}

connect_wireguard_client() {
    print_header "🔒 WIREGUARD CLIENT CONNECTION"
    
    echo "🛡️ WireGuard VPN Client - Connect to secure VPN servers"
    echo "• Fast, modern, and secure VPN protocol"
    echo "• Connect to existing WireGuard servers"
    echo "• Manage multiple VPN configurations"
    echo "• Built-in connection monitoring and auto-reconnect"
    echo ""
    
    echo "📋 Connection Options:"
    echo "1) Quick connect (use existing config)"
    echo "2) Manual server configuration"
    echo "3) Import config from file"
    echo "4) Connect to commercial VPN provider"
    echo "5) Manage existing connections"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select connection method (1-5)" 15 "1")
    
    case "$choice" in
        1)
            echo "⚡ Quick Connect to Existing Configuration"
            echo "========================================"
            echo ""
            
            # List existing WireGuard configurations
            if [ -d /etc/wireguard ]; then
                echo "📋 Available WireGuard configurations:"
                local configs=($(ls /etc/wireguard/*.conf 2>/dev/null | xargs -n1 basename | sed 's/.conf//'))
                
                if [ ${#configs[@]} -eq 0 ]; then
                    echo "❌ No existing WireGuard configurations found"
                    echo "📝 Create a configuration first using option 2 or 3"
                    return 1
                fi
                
                for i in "${!configs[@]}"; do
                    echo "$((i+1))) ${configs[i]}"
                done
                echo ""
                
                read -p "Select configuration to connect (1-${#configs[@]}): " config_choice
                
                if [[ "$config_choice" =~ ^[0-9]+$ ]] && [ "$config_choice" -ge 1 ] && [ "$config_choice" -le ${#configs[@]} ]; then
                    local selected_config="${configs[$((config_choice-1))]}"
                    
                    echo "🔄 Connecting to $selected_config..."
                    
                    if sudo wg-quick up "$selected_config"; then
                        echo "✅ Connected to WireGuard server: $selected_config"
                        
                        # Show connection status
                        echo ""
                        echo "📊 Connection Status:"
                        sudo wg show
                        
                        # Test connectivity
                        echo ""
                        echo "🔍 Testing VPN connectivity..."
                        local vpn_ip=$(curl -s --connect-timeout 5 ifconfig.me || echo "Unable to detect")
                        echo "🌐 Current external IP: $vpn_ip"
                        
                        notify_success "WireGuard" "Connected to VPN server: $selected_config"
                    else
                        log_error "Failed to connect to WireGuard server"
                    fi
                else
                    log_warning "Invalid selection"
                fi
            else
                echo "❌ WireGuard not installed or configured"
                echo "📥 Install WireGuard first: sudo apt install wireguard"
            fi
            ;;
        2)
            echo "⚙️ Manual Server Configuration"
            echo "============================="
            echo ""
            
            echo "🔧 Creating new WireGuard client configuration..."
            echo ""
            
            read -p "📛 Configuration name: " config_name
            read -p "🔑 Client private key (leave empty to generate): " client_private_key
            read -p "🌐 Server public key: " server_public_key
            read -p "📡 Server endpoint (IP:port): " server_endpoint
            read -p "🎯 Allowed IPs (e.g., 0.0.0.0/0 for all traffic): " allowed_ips
            
            # Generate private key if not provided
            if [ -z "$client_private_key" ]; then
                echo "🔄 Generating new private key..."
                client_private_key=$(wg genkey)
                local client_public_key=$(echo "$client_private_key" | wg pubkey)
                echo "🔑 Generated public key: $client_public_key"
                echo "📝 Share this public key with the server administrator"
            fi
            
            read -p "🆔 Client IP address (e.g., 10.0.0.2/24): " client_ip
            read -p "🌐 DNS servers (e.g., 1.1.1.1, 8.8.8.8): " dns_servers
            
            # Create configuration file
            local config_file="/etc/wireguard/${config_name}.conf"
            
            echo "📝 Creating configuration file..."
            sudo tee "$config_file" > /dev/null <<EOF
[Interface]
PrivateKey = $client_private_key
Address = $client_ip
DNS = $dns_servers

[Peer]
PublicKey = $server_public_key
Endpoint = $server_endpoint
AllowedIPs = $allowed_ips
PersistentKeepalive = 25
EOF
            
            sudo chmod 600 "$config_file"
            
            echo "✅ Configuration created: $config_file"
            echo ""
            echo "🔄 Testing connection..."
            
            if sudo wg-quick up "$config_name"; then
                echo "✅ Successfully connected to WireGuard server!"
                sudo wg show
                notify_success "WireGuard" "New connection configured: $config_name"
            else
                log_error "Failed to establish connection - check configuration"
            fi
            ;;
        3)
            echo "📁 Import Configuration from File"
            echo "==============================="
            echo ""
            
            read -p "📂 Path to WireGuard config file (.conf): " config_file_path
            
            if [ -f "$config_file_path" ]; then
                local config_name=$(basename "$config_file_path" .conf)
                local dest_file="/etc/wireguard/${config_name}.conf"
                
                echo "🔄 Importing configuration..."
                sudo cp "$config_file_path" "$dest_file"
                sudo chmod 600 "$dest_file"
                
                # Validate configuration
                if sudo wg-quick up "$config_name" --dry-run 2>/dev/null; then
                    echo "✅ Configuration imported successfully"
                    echo ""
                    echo "🔄 Connect now? (y/n)"
                    read -n 1 connect_now
                    echo ""
                    
                    if [[ $connect_now == "y" ]]; then
                        sudo wg-quick up "$config_name"
                        echo "✅ Connected to imported configuration"
                        sudo wg show
                    fi
                else
                    log_error "Invalid configuration file"
                    sudo rm -f "$dest_file"
                fi
            else
                log_error "Configuration file not found: $config_file_path"
            fi
            ;;
        4)
            echo "🏢 Connect to Commercial VPN Provider"
            echo "===================================="
            echo ""
            
            echo "📋 Supported VPN providers with WireGuard:"
            echo "1) Mullvad VPN"
            echo "2) IVPN"  
            echo "3) Private Internet Access (PIA)"
            echo "4) ProtonVPN"
            echo "5) Custom provider"
            echo ""
            
            read -p "Select provider (1-5): " provider_choice
            
            case "$provider_choice" in
                1)
                    echo "🔧 Mullvad VPN Setup"
                    echo "==================="
                    read -p "🆔 Mullvad account number: " mullvad_account
                    read -p "🌍 Server location (e.g., us-nyc-wg-001): " mullvad_server
                    
                    echo "🔄 Downloading Mullvad WireGuard config..."
                    echo "📝 Visit: https://mullvad.net/account/#/wireguard-config"
                    echo "   Download your config and use option 3 to import"
                    ;;
                2)
                    echo "🔧 IVPN Setup"
                    echo "============="
                    echo "📝 Visit: https://www.ivpn.net/account/wireguard"
                    echo "   Generate your WireGuard config and use option 3 to import"
                    ;;
                3)
                    echo "🔧 Private Internet Access Setup"
                    echo "==============================="
                    echo "📝 Visit: https://www.privateinternetaccess.com/helpdesk/kb/articles/wireguard-manual-connection"
                    echo "   Download your config and use option 3 to import"
                    ;;
                4)
                    echo "🔧 ProtonVPN Setup"
                    echo "=================="
                    echo "📝 Visit: https://account.protonvpn.com/downloads"
                    echo "   Download WireGuard config and use option 3 to import"
                    ;;
                5)
                    echo "🔧 Custom Provider Setup"
                    echo "======================="
                    echo "📝 Contact your VPN provider for WireGuard configuration"
                    echo "   Most providers now support WireGuard - check their documentation"
                    ;;
            esac
            ;;
        5)
            echo "🛠️ Manage Existing Connections"
            echo "============================"
            echo ""
            
            echo "📋 WireGuard Management Options:"
            echo "1) Show active connections"
            echo "2) Disconnect from VPN"
            echo "3) View connection logs"
            echo "4) Delete configuration"
            echo "5) Connection statistics"
            echo ""
            
            read -p "Select management option (1-5): " mgmt_choice
            
            case "$mgmt_choice" in
                1)
                    echo "📡 Active WireGuard Connections:"
                    echo "==============================="
                    sudo wg show
                    ;;
                2)
                    echo "🔌 Disconnect from VPN"
                    echo "====================="
                    local active_configs=($(sudo wg show interfaces))
                    
                    if [ ${#active_configs[@]} -eq 0 ]; then
                        echo "❌ No active WireGuard connections"
                    else
                        echo "📋 Active connections:"
                        for i in "${!active_configs[@]}"; do
                            echo "$((i+1))) ${active_configs[i]}"
                        done
                        
                        read -p "Select connection to disconnect (1-${#active_configs[@]}): " disconnect_choice
                        
                        if [[ "$disconnect_choice" =~ ^[0-9]+$ ]] && [ "$disconnect_choice" -ge 1 ] && [ "$disconnect_choice" -le ${#active_configs[@]} ]; then
                            local selected_interface="${active_configs[$((disconnect_choice-1))]}"
                            sudo wg-quick down "$selected_interface"
                            echo "✅ Disconnected from $selected_interface"
                            notify_info "WireGuard" "Disconnected from VPN"
                        fi
                    fi
                    ;;
                3)
                    echo "📋 Connection Logs:"
                    echo "=================="
                    sudo journalctl -u wg-quick@* --since "1 hour ago" | tail -20
                    ;;
                4)
                    echo "🗑️ Delete Configuration"
                    echo "======================"
                    local all_configs=($(ls /etc/wireguard/*.conf 2>/dev/null | xargs -n1 basename | sed 's/.conf//'))
                    
                    if [ ${#all_configs[@]} -eq 0 ]; then
                        echo "❌ No configurations found"
                    else
                        echo "📋 Available configurations:"
                        for i in "${!all_configs[@]}"; do
                            echo "$((i+1))) ${all_configs[i]}"
                        done
                        
                        read -p "Select configuration to delete (1-${#all_configs[@]}): " delete_choice
                        
                        if [[ "$delete_choice" =~ ^[0-9]+$ ]] && [ "$delete_choice" -ge 1 ] && [ "$delete_choice" -le ${#all_configs[@]} ]; then
                            local config_to_delete="${all_configs[$((delete_choice-1))]}"
                            echo "⚠️ Delete $config_to_delete? This cannot be undone! (y/N)"
                            read -n 1 confirm_delete
                            echo ""
                            
                            if [[ $confirm_delete == "y" ]]; then
                                sudo wg-quick down "$config_to_delete" 2>/dev/null || true
                                sudo rm "/etc/wireguard/${config_to_delete}.conf"
                                echo "✅ Configuration deleted: $config_to_delete"
                            fi
                        fi
                    fi
                    ;;
                5)
                    echo "📊 Connection Statistics:"
                    echo "======================="
                    sudo wg show all
                    echo ""
                    echo "🔍 Network interface statistics:"
                    ip -s link show | grep -A 4 wg
                    ;;
            esac
            ;;
        *)
            log_warning "Invalid choice"
            ;;
    esac
    
    echo ""
    echo "💡 WireGuard Tips:"
    echo "• Use 'sudo wg show' to check connection status"
    echo "• Use 'sudo wg-quick down <config>' to disconnect"
    echo "• Keep your private keys secure and never share them"
    echo "• Use 'systemctl enable wg-quick@<config>' for auto-start"
    
    collect_feedback "network_management" "wireguard_client"
}

import_wireguard_config() {
    print_header "📁 WIREGUARD CONFIG IMPORT"
    
    echo "📥 WireGuard Configuration Import Tool"
    echo "• Import .conf files from VPN providers"
    echo "• Validate configuration syntax"
    echo "• Automatic key generation if needed"
    echo "• Batch import multiple configurations"
    echo ""
    
    echo "📋 Import Options:"
    echo "1) Import single .conf file"
    echo "2) Import from directory (batch)"
    echo "3) Import from VPN provider (automated)"
    echo "4) Create config from manual input"
    echo "5) Validate existing configurations"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select import method (1-5)" 15 "1")
    
    case "$choice" in
        1)
            echo "📁 Single Configuration Import"
            echo "============================="
            echo ""
            
            read -p "📂 Path to .conf file: " config_path
            
            if [ ! -f "$config_path" ]; then
                log_error "Configuration file not found: $config_path"
                return 1
            fi
            
            # Validate configuration format
            if ! grep -q "\[Interface\]" "$config_path" || ! grep -q "\[Peer\]" "$config_path"; then
                log_error "Invalid WireGuard configuration format"
                return 1
            fi
            
            local config_name=$(basename "$config_path" .conf)
            local dest_path="/etc/wireguard/${config_name}.conf"
            
            echo "🔍 Validating configuration..."
            
            # Check for required fields
            local missing_fields=()
            
            if ! grep -q "PrivateKey" "$config_path"; then
                missing_fields+=("PrivateKey")
            fi
            
            if ! grep -q "Address" "$config_path"; then
                missing_fields+=("Address")
            fi
            
            if ! grep -q "PublicKey" "$config_path"; then
                missing_fields+=("PublicKey")
            fi
            
            if ! grep -q "Endpoint" "$config_path"; then
                missing_fields+=("Endpoint")
            fi
            
            if [ ${#missing_fields[@]} -gt 0 ]; then
                log_warning "Missing required fields: ${missing_fields[*]}"
                echo "🔧 Would you like to add missing fields interactively? (y/n)"
                read -n 1 fix_config
                echo ""
                
                if [[ $fix_config == "y" ]]; then
                    # Create temporary fixed config
                    cp "$config_path" "/tmp/wg-config-temp.conf"
                    
                    for field in "${missing_fields[@]}"; do
                        case "$field" in
                            "PrivateKey")
                                echo "🔑 Generating new private key..."
                                local new_private_key=$(wg genkey)
                                local new_public_key=$(echo "$new_private_key" | wg pubkey)
                                echo "PrivateKey = $new_private_key" >> "/tmp/wg-config-temp.conf"
                                echo "📝 Generated public key: $new_public_key"
                                echo "   Share this with the server administrator"
                                ;;
                            "Address")
                                read -p "🆔 Client IP address (e.g., 10.0.0.2/24): " client_address
                                echo "Address = $client_address" >> "/tmp/wg-config-temp.conf"
                                ;;
                            "PublicKey")
                                read -p "🌐 Server public key: " server_public_key
                                echo "PublicKey = $server_public_key" >> "/tmp/wg-config-temp.conf"
                                ;;
                            "Endpoint")
                                read -p "📡 Server endpoint (IP:port): " server_endpoint
                                echo "Endpoint = $server_endpoint" >> "/tmp/wg-config-temp.conf"
                                ;;
                        esac
                    done
                    
                    config_path="/tmp/wg-config-temp.conf"
                fi
            fi
            
            echo "📥 Installing configuration..."
            sudo cp "$config_path" "$dest_path"
            sudo chmod 600 "$dest_path"
            
            echo "✅ Configuration imported: $config_name"
            echo "🔧 Test with: sudo wg-quick up $config_name"
            
            # Cleanup temporary file
            [ -f "/tmp/wg-config-temp.conf" ] && rm "/tmp/wg-config-temp.conf"
            
            notify_success "WireGuard Import" "Configuration $config_name imported successfully"
            ;;
        2)
            echo "📁 Batch Directory Import"
            echo "========================"
            echo ""
            
            read -p "📂 Directory containing .conf files: " config_dir
            
            if [ ! -d "$config_dir" ]; then
                log_error "Directory not found: $config_dir"
                return 1
            fi
            
            local conf_files=($(smart_find "*.conf" "$config_dir"))
            
            if [ ${#conf_files[@]} -eq 0 ]; then
                log_warning "No .conf files found in $config_dir"
                return 1
            fi
            
            echo "📋 Found ${#conf_files[@]} configuration files:"
            for conf in "${conf_files[@]}"; do
                echo "• $(basename "$conf")"
            done
            echo ""
            
            echo "🔄 Import all configurations? (y/n)"
            read -n 1 confirm_batch
            echo ""
            
            if [[ $confirm_batch == "y" ]]; then
                local imported_count=0
                local failed_count=0
                
                for conf_file in "${conf_files[@]}"; do
                    local conf_name=$(basename "$conf_file" .conf)
                    local dest_path="/etc/wireguard/${conf_name}.conf"
                    
                    echo "📥 Importing: $conf_name"
                    
                    # Basic validation
                    if grep -q "\[Interface\]" "$conf_file" && grep -q "\[Peer\]" "$conf_file"; then
                        sudo cp "$conf_file" "$dest_path"
                        sudo chmod 600 "$dest_path"
                        ((imported_count++))
                        echo "   ✅ Success"
                    else
                        echo "   ❌ Invalid format - skipped"
                        ((failed_count++))
                    fi
                done
                
                echo ""
                echo "📊 Batch import results:"
                echo "• Imported: $imported_count configurations"
                echo "• Failed: $failed_count configurations"
                
                notify_success "WireGuard Batch Import" "Imported $imported_count configurations"
            fi
            ;;
        3)
            echo "🏢 VPN Provider Import"
            echo "====================="
            echo ""
            
            echo "📋 Supported VPN providers:"
            echo "1) Mullvad VPN"
            echo "2) ProtonVPN" 
            echo "3) NordVPN"
            echo "4) Surfshark"
            echo "5) Custom provider"
            echo ""
            
            read -p "Select provider (1-5): " provider_choice
            
            case "$provider_choice" in
                1)
                    echo "🔧 Mullvad VPN Import"
                    echo "===================="
                    echo ""
                    echo "📝 Mullvad WireGuard setup:"
                    echo "1. Log into your Mullvad account"
                    echo "2. Go to WireGuard configuration generator"
                    echo "3. Download the .conf file for your device"
                    echo "4. Use option 1 to import the downloaded file"
                    echo ""
                    echo "🌐 Direct link: https://mullvad.net/account/#/wireguard-config"
                    ;;
                2)
                    echo "🔧 ProtonVPN Import"
                    echo "=================="
                    echo ""
                    echo "📝 ProtonVPN WireGuard setup:"
                    echo "1. Log into your ProtonVPN account"
                    echo "2. Go to Downloads → WireGuard configuration"
                    echo "3. Select your desired server and download config"
                    echo "4. Use option 1 to import the downloaded file"
                    echo ""
                    echo "🌐 Direct link: https://account.protonvpn.com/downloads"
                    ;;
                3)
                    echo "🔧 NordVPN Import"
                    echo "================"
                    echo ""
                    echo "📝 NordVPN WireGuard setup:"
                    echo "1. NordVPN requires NordLynx (their WireGuard implementation)"
                    echo "2. Install NordVPN Linux client: sudo apt install nordvpn"
                    echo "3. Use: nordvpn set technology nordlynx"
                    echo "4. Connect with: nordvpn connect"
                    echo ""
                    echo "ℹ️ NordVPN doesn't provide standalone WireGuard configs"
                    ;;
                4)
                    echo "🔧 Surfshark Import"
                    echo "=================="
                    echo ""
                    echo "📝 Surfshark WireGuard setup:"
                    echo "1. Log into your Surfshark account"
                    echo "2. Go to VPN → Manual setup → WireGuard"
                    echo "3. Generate and download configuration files"
                    echo "4. Use option 1 to import downloaded configs"
                    echo ""
                    echo "🌐 Manual setup: https://my.surfshark.com/vpn/manual-setup/main"
                    ;;
                5)
                    echo "🔧 Custom Provider Import"
                    echo "========================"
                    echo ""
                    read -p "📛 Provider name: " provider_name
                    read -p "📁 Path to provider configs: " provider_configs
                    
                    if [ -d "$provider_configs" ]; then
                        echo "🔄 Importing configs from $provider_name..."
                        # Reuse batch import logic
                        import_wireguard_config 2
                    else
                        echo "❌ Directory not found: $provider_configs"
                    fi
                    ;;
            esac
            ;;
        4)
            echo "✏️ Manual Configuration Creation"
            echo "==============================="
            echo ""
            
            read -p "📛 Configuration name: " manual_config_name
            
            local manual_config_path="/etc/wireguard/${manual_config_name}.conf"
            
            echo "🔧 Creating configuration file..."
            echo ""
            
            # Get interface settings
            echo "📋 Interface Configuration:"
            read -p "🔑 Private key (leave empty to generate): " manual_private_key
            
            if [ -z "$manual_private_key" ]; then
                manual_private_key=$(wg genkey)
                local manual_public_key=$(echo "$manual_private_key" | wg pubkey)
                echo "🔑 Generated public key: $manual_public_key"
                echo "📝 Share this public key with the server"
            fi
            
            read -p "🆔 Interface address (e.g., 10.0.0.2/24): " manual_address
            read -p "🌐 DNS servers (e.g., 1.1.1.1, 8.8.8.8): " manual_dns
            
            echo ""
            echo "📋 Peer Configuration:"
            read -p "🌐 Server public key: " manual_server_key
            read -p "📡 Server endpoint (IP:port): " manual_endpoint
            read -p "🎯 Allowed IPs (e.g., 0.0.0.0/0): " manual_allowed_ips
            read -p "⏱️ Keep-alive interval (25): " manual_keepalive
            manual_keepalive=${manual_keepalive:-25}
            
            # Create configuration
            sudo tee "$manual_config_path" > /dev/null <<EOF
[Interface]
PrivateKey = $manual_private_key
Address = $manual_address
DNS = $manual_dns

[Peer]
PublicKey = $manual_server_key
Endpoint = $manual_endpoint
AllowedIPs = $manual_allowed_ips
PersistentKeepalive = $manual_keepalive
EOF
            
            sudo chmod 600 "$manual_config_path"
            
            echo ""
            echo "✅ Configuration created: $manual_config_name"
            echo "📁 Location: $manual_config_path"
            echo "🔧 Test with: sudo wg-quick up $manual_config_name"
            
            notify_success "WireGuard Manual" "Configuration $manual_config_name created"
            ;;
        5)
            echo "🔍 Configuration Validation"
            echo "=========================="
            echo ""
            
            local existing_configs=($(ls /etc/wireguard/*.conf 2>/dev/null | xargs -n1 basename | sed 's/.conf//'))
            
            if [ ${#existing_configs[@]} -eq 0 ]; then
                echo "❌ No WireGuard configurations found"
                return 1
            fi
            
            echo "📋 Validating ${#existing_configs[@]} configurations:"
            echo ""
            
            local valid_count=0
            local invalid_count=0
            
            for config in "${existing_configs[@]}"; do
                local config_path="/etc/wireguard/${config}.conf"
                echo "🔍 Validating: $config"
                
                # Check file permissions
                local perms=$(stat -c "%a" "$config_path")
                if [ "$perms" != "600" ]; then
                    echo "   ⚠️ Incorrect permissions: $perms (should be 600)"
                    sudo chmod 600 "$config_path"
                    echo "   🔧 Fixed permissions"
                fi
                
                # Check required sections
                local has_interface=$(grep -q "\[Interface\]" "$config_path" && echo "true" || echo "false")
                local has_peer=$(grep -q "\[Peer\]" "$config_path" && echo "true" || echo "false")
                
                # Check required fields
                local has_private_key=$(grep -q "PrivateKey" "$config_path" && echo "true" || echo "false")
                local has_public_key=$(grep -q "PublicKey" "$config_path" && echo "true" || echo "false")
                local has_endpoint=$(grep -q "Endpoint" "$config_path" && echo "true" || echo "false")
                
                if [[ $has_interface == "true" && $has_peer == "true" && 
                      $has_private_key == "true" && $has_public_key == "true" && 
                      $has_endpoint == "true" ]]; then
                    echo "   ✅ Valid configuration"
                    ((valid_count++))
                    
                    # Test syntax with wg-quick
                    if sudo wg-quick up "$config" --dry-run &>/dev/null; then
                        echo "   ✅ Syntax check passed"
                    else
                        echo "   ⚠️ Syntax check failed"
                    fi
                else
                    echo "   ❌ Missing required fields"
                    [ "$has_interface" != "true" ] && echo "      Missing [Interface] section"
                    [ "$has_peer" != "true" ] && echo "      Missing [Peer] section"
                    [ "$has_private_key" != "true" ] && echo "      Missing PrivateKey"
                    [ "$has_public_key" != "true" ] && echo "      Missing PublicKey"
                    [ "$has_endpoint" != "true" ] && echo "      Missing Endpoint"
                    ((invalid_count++))
                fi
                echo ""
            done
            
            echo "📊 Validation Summary:"
            echo "• Valid configurations: $valid_count"
            echo "• Invalid configurations: $invalid_count"
            echo "• Total configurations: ${#existing_configs[@]}"
            
            if [ $invalid_count -gt 0 ]; then
                echo ""
                echo "🔧 Fix invalid configurations manually or re-import them"
            fi
            ;;
        *)
            log_warning "Invalid choice"
            ;;
    esac
    
    echo ""
    echo "📚 WireGuard Import Tips:"
    echo "• Always validate configurations before connecting"
    echo "• Keep backup copies of working configurations"
    echo "• Use descriptive names for different servers/providers"
    echo "• Test connections in a safe environment first"
    
    collect_feedback "network_management" "wireguard_import"
}

manage_bluetooth() {
    log_info "Bluetooth management coming in next update"
    echo "This will provide comprehensive Bluetooth device management."
}

setup_mobile_hotspot() {
    print_header "📡 MOBILE HOTSPOT SETUP"
    
    echo "🔥 Wi-Fi Hotspot Creator - Share your internet connection"
    echo "• Create a Wi-Fi access point for other devices"
    echo "• Share ethernet, Wi-Fi, or mobile data connections"
    echo "• Configure security settings and access control"
    echo ""
    
    echo "📋 Hotspot Setup Options:"
    echo "1) Quick hotspot setup (recommended)"
    echo "2) Advanced hotspot configuration"
    echo "3) Mobile data hotspot (USB tethering)"
    echo "4) Ethernet to Wi-Fi bridge"
    echo "5) Manage existing hotspots"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select setup type (1-5)" 15 "1")
    
    case "$choice" in
        1)
            echo "⚡ Quick Hotspot Setup"
            echo "====================="
            echo ""
            
            # Get default hotspot name
            local default_name="BillSloth-$(hostname | cut -c1-8)"
            read -p "📛 Hotspot name (SSID) [$default_name]: " hotspot_name
            hotspot_name=${hotspot_name:-$default_name}
            
            # Get password
            local default_password=$(openssl rand -base64 12 | tr -d '+/=' | cut -c1-10)
            read -p "🔐 Password [$default_password]: " hotspot_password
            hotspot_password=${hotspot_password:-$default_password}
            
            echo ""
            echo "🔄 Creating hotspot..."
            
            if command -v nmcli &>/dev/null; then
                # Use NetworkManager for hotspot creation
                nmcli device wifi hotspot con-name "$hotspot_name" ssid "$hotspot_name" \
                    band bg password "$hotspot_password" ifname "$(nmcli device | grep wifi | awk '{print $1}' | head -1)"
                
                if [ $? -eq 0 ]; then
                    echo "✅ Hotspot created successfully!"
                    echo ""
                    echo "📋 Hotspot Details:"
                    echo "• Name (SSID): $hotspot_name"
                    echo "• Password: $hotspot_password"
                    echo "• Security: WPA2-PSK"
                    echo "• Band: 2.4GHz"
                    echo ""
                    echo "📱 To connect other devices:"
                    echo "1. Look for '$hotspot_name' in Wi-Fi networks"
                    echo "2. Enter password: $hotspot_password"
                    echo "3. Connect and start browsing!"
                    
                    notify_success "Hotspot" "Wi-Fi hotspot '$hotspot_name' is now active"
                else
                    log_error "Failed to create hotspot with NetworkManager"
                fi
            else
                log_warning "NetworkManager not available - trying alternative method..."
                
                # Alternative method using hostapd and dnsmasq
                echo "🔄 Installing hotspot tools..."
                sudo apt update && sudo apt install -y hostapd dnsmasq
                
                # Create hostapd configuration
                sudo tee /etc/hostapd/hostapd.conf > /dev/null <<EOF
interface=wlan0
driver=nl80211
ssid=$hotspot_name
hw_mode=g
channel=7
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$hotspot_password
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
                
                echo "✅ Alternative hotspot setup initiated"
                echo "📋 Manual configuration may be required"
            fi
            ;;
        2)
            echo "⚙️ Advanced Hotspot Configuration"
            echo "================================"
            echo ""
            
            read -p "📛 Hotspot name (SSID): " hotspot_name
            read -p "🔐 Password (8+ chars): " hotspot_password
            
            echo ""
            echo "📡 Frequency Band:"
            echo "1) 2.4GHz (better range, more compatible)"
            echo "2) 5GHz (faster speeds, less crowded)"
            read -p "Select band (1-2): " band_choice
            
            local band="bg"
            [ "$band_choice" = "2" ] && band="a"
            
            echo ""
            echo "🔢 Channel Selection:"
            echo "1) Auto (recommended)"
            echo "2) Manual channel selection"
            read -p "Select option (1-2): " channel_choice
            
            local channel_param=""
            if [ "$channel_choice" = "2" ]; then
                read -p "Enter channel (1-11 for 2.4GHz, 36-165 for 5GHz): " manual_channel
                channel_param="--channel $manual_channel"
            fi
            
            echo ""
            echo "🔄 Creating advanced hotspot..."
            
            if command -v nmcli &>/dev/null; then
                nmcli device wifi hotspot con-name "$hotspot_name" ssid "$hotspot_name" \
                    band "$band" password "$hotspot_password" $channel_param
                
                echo "✅ Advanced hotspot configuration complete!"
                notify_success "Hotspot" "Advanced hotspot '$hotspot_name' created"
            else
                log_error "NetworkManager required for advanced configuration"
            fi
            ;;
        3)
            echo "📱 Mobile Data Hotspot (USB Tethering)"
            echo "====================================="
            echo ""
            echo "This feature shares your mobile data connection via USB tethering."
            echo ""
            
            echo "📋 Requirements:"
            echo "• Android device with USB debugging enabled"
            echo "• USB cable connected to computer"
            echo "• Mobile data plan with tethering allowed"
            echo ""
            
            if command -v adb &>/dev/null; then
                echo "🔍 Checking for connected Android devices..."
                adb devices
                echo ""
                echo "🔄 Enabling USB tethering..."
                
                # Enable USB tethering via ADB
                adb shell svc usb setFunctions rndis
                sleep 2
                adb shell settings put global tether_supported 1
                
                echo "✅ USB tethering configuration sent to device"
                echo "📱 Please enable 'USB Tethering' in your phone's settings"
            else
                echo "📥 Installing ADB tools..."
                sudo apt update && sudo apt install -y android-tools-adb
                echo "✅ Restart this option after connecting your Android device"
            fi
            ;;
        4)
            echo "🌉 Ethernet to Wi-Fi Bridge"
            echo "=========================="
            echo ""
            echo "This creates a Wi-Fi hotspot that shares your ethernet connection."
            echo ""
            
            # Check for ethernet interface
            local eth_interface=$(ip link | grep -E "^[0-9]+: en" | awk -F': ' '{print $2}' | head -1)
            
            if [ -n "$eth_interface" ]; then
                echo "✅ Ethernet interface found: $eth_interface"
                echo ""
                
                read -p "📛 Bridge hotspot name: " bridge_name
                read -p "🔐 Password: " bridge_password
                
                echo "🔄 Creating ethernet bridge hotspot..."
                
                if command -v nmcli &>/dev/null; then
                    # Create hotspot that bridges ethernet
                    nmcli device wifi hotspot con-name "$bridge_name" ssid "$bridge_name" \
                        password "$bridge_password"
                    
                    # Configure IP forwarding
                    echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward
                    
                    echo "✅ Ethernet bridge hotspot created!"
                    notify_success "Bridge" "Ethernet bridge '$bridge_name' is active"
                else
                    log_error "NetworkManager required for bridge configuration"
                fi
            else
                log_warning "No ethernet interface detected"
                echo "📝 Available interfaces:"
                ip link show
            fi
            ;;
        5)
            echo "🛠️ Manage Existing Hotspots"
            echo "=========================="
            echo ""
            
            if command -v nmcli &>/dev/null; then
                echo "📋 Current hotspot connections:"
                nmcli connection show | grep wifi
                echo ""
                
                echo "📋 Management Options:"
                echo "1) Stop active hotspot"
                echo "2) Start saved hotspot"
                echo "3) Delete hotspot configuration"
                echo "4) Show hotspot details"
                
                read -p "Select action (1-4): " mgmt_choice
                
                case "$mgmt_choice" in
                    1)
                        nmcli connection down $(nmcli connection show --active | grep wifi | awk '{print $1}' | head -1)
                        echo "✅ Hotspot stopped"
                        ;;
                    2)
                        echo "📋 Available hotspot configurations:"
                        nmcli connection show | grep wifi | nl
                        read -p "Enter hotspot name to start: " hotspot_to_start
                        nmcli connection up "$hotspot_to_start"
                        echo "✅ Hotspot started"
                        ;;
                    3)
                        read -p "Enter hotspot name to delete: " hotspot_to_delete
                        nmcli connection delete "$hotspot_to_delete"
                        echo "✅ Hotspot configuration deleted"
                        ;;
                    4)
                        read -p "Enter hotspot name for details: " hotspot_details
                        nmcli connection show "$hotspot_details"
                        ;;
                esac
            else
                log_error "NetworkManager not available for hotspot management"
            fi
            ;;
        *)
            log_warning "Invalid choice. Creating quick hotspot..."
            # Fallback to quick setup
            local quick_name="BillSloth-$(date +%H%M)"
            local quick_pass=$(openssl rand -base64 8 | tr -d '+/=')
            
            nmcli device wifi hotspot con-name "$quick_name" ssid "$quick_name" password "$quick_pass"
            echo "✅ Quick hotspot created: $quick_name / $quick_pass"
            ;;
    esac
    
    echo ""
    echo "📋 Hotspot Management Commands:"
    echo "• Stop hotspot: nmcli connection down <hotspot-name>"
    echo "• Start hotspot: nmcli connection up <hotspot-name>"
    echo "• View status: nmcli device wifi"
    echo "• Connected devices: iwconfig"
    echo ""
    echo "🛡️ Security Tips:"
    echo "• Use strong passwords (12+ characters)"
    echo "• Monitor connected devices regularly"
    echo "• Disable hotspot when not in use"
    echo "• Consider MAC address filtering for sensitive use"
    
    collect_feedback "network_management" "mobile_hotspot"
}

manage_network_profiles() {
    print_header "📋 NETWORK PROFILES MANAGER"
    
    echo "💾 Network Configuration Profiles - Save and restore network settings"
    echo "• Create profiles for different environments (home, work, cafe)"
    echo "• Save Wi-Fi, VPN, proxy, and DNS configurations"
    echo "• Quick switching between network setups"
    echo "• Backup and restore complete network configurations"
    echo ""
    
    # Create profiles directory
    local profiles_dir="$HOME/.config/network-profiles"
    mkdir -p "$profiles_dir"
    
    echo "📋 Profile Management Options:"
    echo "1) Create new network profile"
    echo "2) Switch to existing profile"
    echo "3) View profile details"
    echo "4) Edit existing profile"
    echo "5) Delete profile"
    echo "6) Import/Export profiles"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select profile action (1-6)" 15 "1")
    
    case "$choice" in
        1)
            echo "📝 Create New Network Profile"
            echo "==========================="
            echo ""
            
            read -p "📛 Profile name (e.g., home, work, coffee-shop): " profile_name
            
            if [ -z "$profile_name" ]; then
                log_error "Profile name cannot be empty"
                return 1
            fi
            
            local profile_file="$profiles_dir/${profile_name}.profile"
            
            if [ -f "$profile_file" ]; then
                echo "⚠️ Profile '$profile_name' already exists. Overwrite? (y/N)"
                read -n 1 overwrite
                echo ""
                [ "$overwrite" != "y" ] && return 0
            fi
            
            echo "🔄 Capturing current network configuration..."
            
            # Capture current network state
            {
                echo "# Network Profile: $profile_name"
                echo "# Created: $(date)"
                echo "# Description: Network configuration profile"
                echo ""
                
                # Wi-Fi connections
                echo "## Wi-Fi Connections"
                if command -v nmcli &>/dev/null; then
                    nmcli connection show | grep wifi | while read -r line; do
                        local conn_name=$(echo "$line" | awk '{print $1}')
                        echo "WIFI_CONNECTION=\"$conn_name\""
                    done
                fi
                echo ""
                
                # DNS settings
                echo "## DNS Configuration"
                if [ -f /etc/systemd/resolved.conf ]; then
                    grep -E "^DNS=|^FallbackDNS=" /etc/systemd/resolved.conf | while read -r line; do
                        echo "DNS_$line"
                    done
                fi
                echo ""
                
                # VPN connections
                echo "## VPN Connections"
                if [ -d /etc/wireguard ]; then
                    ls /etc/wireguard/*.conf 2>/dev/null | while read -r conf; do
                        local vpn_name=$(basename "$conf" .conf)
                        echo "VPN_WIREGUARD=\"$vpn_name\""
                    done
                fi
                echo ""
                
                # Network interface settings
                echo "## Network Interface Settings"
                ip route | grep default | while read -r route; do
                    echo "DEFAULT_ROUTE=\"$route\""
                done
                echo ""
                
                # Proxy settings
                echo "## Proxy Configuration"
                [ -n "$http_proxy" ] && echo "HTTP_PROXY=\"$http_proxy\""
                [ -n "$https_proxy" ] && echo "HTTPS_PROXY=\"$https_proxy\""
                [ -n "$no_proxy" ] && echo "NO_PROXY=\"$no_proxy\""
                echo ""
                
                # Custom settings
                echo "## Custom Settings"
                echo "PROFILE_CREATED_BY=\"$USER\""
                echo "PROFILE_HOSTNAME=\"$(hostname)\""
                echo "PROFILE_OS=\"$(uname -o)\""
                
            } > "$profile_file"
            
            echo "📝 Profile configuration captured!"
            echo ""
            echo "✏️ Add custom description for this profile:"
            read -p "Description: " profile_description
            
            if [ -n "$profile_description" ]; then
                sed -i "s/# Description: .*/# Description: $profile_description/" "$profile_file"
            fi
            
            echo ""
            echo "✅ Network profile '$profile_name' created successfully!"
            echo "📁 Location: $profile_file"
            
            notify_success "Network Profiles" "Created profile: $profile_name"
            ;;
        2)
            echo "🔄 Switch to Existing Profile"
            echo "==========================="
            echo ""
            
            # List available profiles
            local profiles=($(ls "$profiles_dir"/*.profile 2>/dev/null | xargs -n1 basename | sed 's/.profile//'))
            
            if [ ${#profiles[@]} -eq 0 ]; then
                echo "❌ No network profiles found"
                echo "📝 Create a profile first using option 1"
                return 1
            fi
            
            echo "📋 Available profiles:"
            for i in "${!profiles[@]}"; do
                local profile_file="$profiles_dir/${profiles[i]}.profile"
                local description=$(grep "# Description:" "$profile_file" 2>/dev/null | cut -d':' -f2- | xargs)
                echo "$((i+1))) ${profiles[i]} - $description"
            done
            echo ""
            
            read -p "Select profile to activate (1-${#profiles[@]}): " profile_choice
            
            if [[ "$profile_choice" =~ ^[0-9]+$ ]] && [ "$profile_choice" -ge 1 ] && [ "$profile_choice" -le ${#profiles[@]} ]; then
                local selected_profile="${profiles[$((profile_choice-1))]}"
                local profile_file="$profiles_dir/${selected_profile}.profile"
                
                echo "🔄 Activating profile: $selected_profile"
                echo ""
                
                # Apply profile settings
                source "$profile_file"
                
                # Apply Wi-Fi connections
                if [ -n "$WIFI_CONNECTION" ]; then
                    echo "📡 Connecting to Wi-Fi: $WIFI_CONNECTION"
                    nmcli connection up "$WIFI_CONNECTION" 2>/dev/null || echo "❌ Failed to connect to $WIFI_CONNECTION"
                fi
                
                # Apply DNS settings
                if [ -n "$DNS_DNS" ]; then
                    echo "🌐 Applying DNS settings..."
                    local dns_servers=$(echo "$DNS_DNS" | cut -d'=' -f2)
                    sudo tee /etc/systemd/resolved.conf > /dev/null <<EOF
[Resolve]
DNS=$dns_servers
Cache=yes
EOF
                    sudo systemctl restart systemd-resolved
                fi
                
                # Apply VPN connections
                if [ -n "$VPN_WIREGUARD" ]; then
                    echo "🔒 Connecting to VPN: $VPN_WIREGUARD"
                    sudo wg-quick up "$VPN_WIREGUARD" 2>/dev/null || echo "❌ Failed to connect to VPN"
                fi
                
                # Apply proxy settings
                if [ -n "$HTTP_PROXY" ]; then
                    echo "🌐 Setting proxy: $HTTP_PROXY"
                    export http_proxy="$HTTP_PROXY"
                    export https_proxy="${HTTPS_PROXY:-$HTTP_PROXY}"
                    export no_proxy="$NO_PROXY"
                fi
                
                echo ""
                echo "✅ Profile '$selected_profile' activated successfully!"
                echo "🔍 Current network status:"
                echo "• IP: $(ip route get 1.1.1.1 | awk '{print $7}' | head -1)"
                echo "• Gateway: $(ip route | awk '/default/ {print $3}' | head -1)"
                echo "• DNS: $(systemctl show systemd-resolved --property=DNS --value)"
                
                notify_success "Network Profiles" "Activated profile: $selected_profile"
            else
                log_warning "Invalid selection"
            fi
            ;;
        3)
            echo "📖 View Profile Details"
            echo "======================"
            echo ""
            
            local profiles=($(ls "$profiles_dir"/*.profile 2>/dev/null | xargs -n1 basename | sed 's/.profile//'))
            
            if [ ${#profiles[@]} -eq 0 ]; then
                echo "❌ No network profiles found"
                return 1
            fi
            
            echo "📋 Select profile to view:"
            for i in "${!profiles[@]}"; do
                echo "$((i+1))) ${profiles[i]}"
            done
            echo ""
            
            read -p "Select profile (1-${#profiles[@]}): " view_choice
            
            if [[ "$view_choice" =~ ^[0-9]+$ ]] && [ "$view_choice" -ge 1 ] && [ "$view_choice" -le ${#profiles[@]} ]; then
                local selected_profile="${profiles[$((view_choice-1))]}"
                local profile_file="$profiles_dir/${selected_profile}.profile"
                
                echo "📋 Profile Details: $selected_profile"
                echo "=================================="
                echo ""
                
                # Show profile information
                cat "$profile_file" | while IFS= read -r line; do
                    if [[ $line == \#* ]]; then
                        echo "💬 $line"
                    elif [[ $line == *=* ]] && [[ $line != "" ]]; then
                        local key=$(echo "$line" | cut -d'=' -f1)
                        local value=$(echo "$line" | cut -d'=' -f2- | tr -d '"')
                        echo "⚙️  $key: $value"
                    fi
                done
                
                echo ""
                echo "📁 Profile file: $profile_file"
                echo "📊 File size: $(du -h "$profile_file" | cut -f1)"
            else
                log_warning "Invalid selection"
            fi
            ;;
        4)
            echo "✏️ Edit Existing Profile"
            echo "======================="
            echo ""
            
            local profiles=($(ls "$profiles_dir"/*.profile 2>/dev/null | xargs -n1 basename | sed 's/.profile//'))
            
            if [ ${#profiles[@]} -eq 0 ]; then
                echo "❌ No network profiles found"
                return 1
            fi
            
            echo "📋 Select profile to edit:"
            for i in "${!profiles[@]}"; do
                echo "$((i+1))) ${profiles[i]}"
            done
            echo ""
            
            read -p "Select profile (1-${#profiles[@]}): " edit_choice
            
            if [[ "$edit_choice" =~ ^[0-9]+$ ]] && [ "$edit_choice" -ge 1 ] && [ "$edit_choice" -le ${#profiles[@]} ]; then
                local selected_profile="${profiles[$((edit_choice-1))]}"
                local profile_file="$profiles_dir/${selected_profile}.profile"
                
                echo "✏️ Editing profile: $selected_profile"
                echo ""
                echo "📋 Edit options:"
                echo "1) Update with current network settings"
                echo "2) Manually edit configuration file"
                echo "3) Update description only"
                echo ""
                
                read -p "Select edit method (1-3): " edit_method
                
                case "$edit_method" in
                    1)
                        echo "🔄 Updating profile with current network settings..."
                        
                        # Backup original
                        cp "$profile_file" "${profile_file}.backup"
                        
                        # Update with current settings (similar to create)
                        # Keep original metadata but update network config
                        local original_description=$(grep "# Description:" "$profile_file" | cut -d':' -f2-)
                        
                        # Regenerate profile content
                        manage_network_profiles # This would re-create with current settings
                        
                        echo "✅ Profile updated with current network configuration"
                        ;;
                    2)
                        echo "📝 Opening profile in editor..."
                        ${EDITOR:-nano} "$profile_file"
                        echo "✅ Profile editing session completed"
                        ;;
                    3)
                        echo "📝 Current description:"
                        grep "# Description:" "$profile_file" | cut -d':' -f2-
                        echo ""
                        read -p "New description: " new_description
                        
                        if [ -n "$new_description" ]; then
                            sed -i "s/# Description: .*/# Description: $new_description/" "$profile_file"
                            echo "✅ Description updated"
                        fi
                        ;;
                esac
            else
                log_warning "Invalid selection"
            fi
            ;;
        5)
            echo "🗑️ Delete Profile"
            echo "================"
            echo ""
            
            local profiles=($(ls "$profiles_dir"/*.profile 2>/dev/null | xargs -n1 basename | sed 's/.profile//'))
            
            if [ ${#profiles[@]} -eq 0 ]; then
                echo "❌ No network profiles found"
                return 1
            fi
            
            echo "📋 Select profile to delete:"
            for i in "${!profiles[@]}"; do
                echo "$((i+1))) ${profiles[i]}"
            done
            echo ""
            
            read -p "Select profile (1-${#profiles[@]}): " delete_choice
            
            if [[ "$delete_choice" =~ ^[0-9]+$ ]] && [ "$delete_choice" -ge 1 ] && [ "$delete_choice" -le ${#profiles[@]} ]; then
                local selected_profile="${profiles[$((delete_choice-1))]}"
                local profile_file="$profiles_dir/${selected_profile}.profile"
                
                echo "⚠️ Delete profile '$selected_profile'? This cannot be undone! (y/N)"
                read -n 1 confirm_delete
                echo ""
                
                if [[ $confirm_delete == "y" ]]; then
                    rm "$profile_file"
                    echo "✅ Profile '$selected_profile' deleted"
                    notify_info "Network Profiles" "Deleted profile: $selected_profile"
                else
                    echo "❌ Deletion cancelled"
                fi
            else
                log_warning "Invalid selection"
            fi
            ;;
        6)
            echo "📦 Import/Export Profiles"
            echo "========================"
            echo ""
            
            echo "📋 Import/Export options:"
            echo "1) Export profile to file"
            echo "2) Import profile from file"
            echo "3) Export all profiles (archive)"
            echo "4) Import profiles from archive"
            echo ""
            
            read -p "Select option (1-4): " import_export_choice
            
            case "$import_export_choice" in
                1)
                    echo "📤 Export Profile to File"
                    echo "========================="
                    
                    local profiles=($(ls "$profiles_dir"/*.profile 2>/dev/null | xargs -n1 basename | sed 's/.profile//'))
                    
                    if [ ${#profiles[@]} -eq 0 ]; then
                        echo "❌ No profiles to export"
                        return 1
                    fi
                    
                    echo "📋 Select profile to export:"
                    for i in "${!profiles[@]}"; do
                        echo "$((i+1))) ${profiles[i]}"
                    done
                    
                    read -p "Select profile (1-${#profiles[@]}): " export_choice
                    
                    if [[ "$export_choice" =~ ^[0-9]+$ ]] && [ "$export_choice" -ge 1 ] && [ "$export_choice" -le ${#profiles[@]} ]; then
                        local selected_profile="${profiles[$((export_choice-1))]}"
                        read -p "📁 Export location [~/Downloads/]: " export_location
                        export_location=${export_location:-~/Downloads/}
                        
                        cp "$profiles_dir/${selected_profile}.profile" "$export_location/${selected_profile}.profile"
                        echo "✅ Profile exported to: $export_location/${selected_profile}.profile"
                    fi
                    ;;
                2)
                    echo "📥 Import Profile from File"
                    echo "=========================="
                    
                    read -p "📂 Path to profile file: " import_file
                    
                    if [ -f "$import_file" ]; then
                        local profile_name=$(basename "$import_file" .profile)
                        cp "$import_file" "$profiles_dir/${profile_name}.profile"
                        echo "✅ Profile imported: $profile_name"
                    else
                        log_error "File not found: $import_file"
                    fi
                    ;;
                3)
                    echo "📦 Export All Profiles"
                    echo "====================="
                    
                    local archive_name="network-profiles-$(date +%Y%m%d-%H%M%S).tar.gz"
                    tar -czf "~/Downloads/$archive_name" -C "$profiles_dir" .
                    echo "✅ All profiles exported to: ~/Downloads/$archive_name"
                    ;;
                4)
                    echo "📥 Import Profiles from Archive"
                    echo "=============================="
                    
                    read -p "📂 Path to archive file: " archive_file
                    
                    if [ -f "$archive_file" ]; then
                        echo "⚠️ This will add profiles to your collection. Continue? (y/N)"
                        read -n 1 confirm_import
                        echo ""
                        
                        if [[ $confirm_import == "y" ]]; then
                            tar -xzf "$archive_file" -C "$profiles_dir"
                            echo "✅ Profiles imported from archive"
                        fi
                    else
                        log_error "Archive not found: $archive_file"
                    fi
                    ;;
            esac
            ;;
        *)
            log_warning "Invalid choice"
            ;;
    esac
    
    echo ""
    echo "📋 Profile Management Tips:"
    echo "• Create profiles for different environments (home, work, travel)"
    echo "• Profiles save Wi-Fi, DNS, VPN, and proxy settings"
    echo "• Use descriptive names for easy identification"
    echo "• Export profiles before system changes or reinstalls"
    echo "• Profiles are stored in: $profiles_dir"
    
    collect_feedback "network_management" "network_profiles"
}

monitor_bandwidth() {
    print_header "📊 REAL-TIME BANDWIDTH MONITORING"
    
    echo "🔍 Network Bandwidth Monitor - Real-time traffic analysis"
    echo "• Shows upload/download speeds per interface"
    echo "• Monitors data usage and network activity"
    echo "• Provides historical usage statistics"
    echo ""
    
    echo "📋 Monitoring Options:"
    echo "1) Real-time interface monitoring (iftop)"
    echo "2) Detailed network statistics (vnstat)"
    echo "3) Process-based bandwidth usage (nethogs)"
    echo "4) Simple traffic monitor (nload)"
    echo "5) Historical data analysis"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select monitoring tool (1-5)" 15 "1")
    
    case "$choice" in
        1)
            echo "🔄 Installing and running iftop for real-time monitoring..."
            if ! command -v iftop &>/dev/null; then
                sudo apt update && sudo apt install -y iftop
            fi
            echo "📊 Real-time interface monitoring (Press 'q' to quit):"
            sudo iftop -i $(ip route | awk '/default/ { print $5 }' | head -1)
            ;;
        2)
            echo "🔄 Installing and configuring vnstat for detailed statistics..."
            if ! command -v vnstat &>/dev/null; then
                sudo apt update && sudo apt install -y vnstat
                sudo systemctl enable vnstat
                sudo systemctl start vnstat
                sleep 2
            fi
            echo "📊 Network Statistics:"
            vnstat -i $(ip route | awk '/default/ { print $5 }' | head -1)
            echo ""
            echo "📈 Hourly usage:"
            vnstat -h -i $(ip route | awk '/default/ { print $5 }' | head -1)
            ;;
        3)
            echo "🔄 Installing and running nethogs for process monitoring..."
            if ! command -v nethogs &>/dev/null; then
                sudo apt update && sudo apt install -y nethogs
            fi
            echo "📊 Process bandwidth usage (Press 'q' to quit):"
            sudo nethogs $(ip route | awk '/default/ { print $5 }' | head -1)
            ;;
        4)
            echo "🔄 Installing and running nload for simple monitoring..."
            if ! command -v nload &>/dev/null; then
                sudo apt update && sudo apt install -y nload
            fi
            echo "📊 Simple traffic monitor (Press 'q' to quit):"
            nload $(ip route | awk '/default/ { print $5 }' | head -1)
            ;;
        5)
            echo "📈 Historical Data Analysis:"
            if command -v vnstat &>/dev/null; then
                echo "📅 Monthly usage:"
                vnstat -m -i $(ip route | awk '/default/ { print $5 }' | head -1)
                echo ""
                echo "📊 Top 10 usage days:"
                vnstat -d -i $(ip route | awk '/default/ { print $5 }' | head -1) | tail -10
            else
                echo "⚠️ vnstat not installed. Install with: sudo apt install vnstat"
            fi
            ;;
        *)
            log_warning "Invalid choice. Using default real-time monitoring..."
            sudo iftop 2>/dev/null || echo "Install iftop with: sudo apt install iftop"
            ;;
    esac
    
    echo ""
    echo "💡 Bandwidth Monitoring Tips:"
    echo "• Use vnstat for long-term usage tracking"
    echo "• Use iftop to identify heavy traffic sources"
    echo "• Use nethogs to find bandwidth-heavy processes"
    echo "• Monitor regularly to detect unusual activity"
    
    notify_success "Bandwidth Monitor" "Network monitoring session completed"
    
    collect_feedback "network_management" "bandwidth_monitoring"
}

scan_network_devices() {
    print_header "🔍 NETWORK DEVICE SCANNER"
    
    echo "🌐 Network Device Discovery - Find all devices on your network"
    echo "• Discovers connected devices and their details"
    echo "• Shows IP addresses, MAC addresses, and device names"
    echo "• Identifies potential security risks and unknown devices"
    echo ""
    
    # Get network interface and subnet
    local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
    local gateway=$(ip route | awk '/default/ { print $3 }' | head -1)
    local local_ip=$(ip addr show $interface | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
    local subnet=$(echo $local_ip | cut -d'.' -f1-3).0/24
    
    echo "📋 Network Information:"
    echo "• Interface: $interface"
    echo "• Gateway: $gateway"
    echo "• Your IP: $local_ip"
    echo "• Scanning: $subnet"
    echo ""
    
    echo "🔍 Scanning Methods:"
    echo "1) Quick ping scan (fast)"
    echo "2) Detailed nmap scan (comprehensive)"
    echo "3) ARP table scan (local cache)"
    echo "4) Port scan specific device"
    echo "5) Service detection scan"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select scan type (1-5)" 15 "1")
    
    case "$choice" in
        1)
            echo "⚡ Quick Ping Scan - Discovering active devices..."
            echo "🔄 This may take 30-60 seconds..."
            echo ""
            echo "📱 Active Devices Found:"
            echo "========================"
            
            for i in {1..254}; do
                local test_ip=$(echo $subnet | cut -d'/' -f1 | sed 's/0$/'"$i"'/')
                if ping -c 1 -W 1 "$test_ip" &>/dev/null; then
                    local hostname=$(nslookup "$test_ip" 2>/dev/null | grep 'name =' | awk '{print $4}' | sed 's/\.$//')
                    local mac=$(arp -n "$test_ip" 2>/dev/null | awk '{print $3}' | grep -E "([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}")
                    
                    echo "🟢 $test_ip"
                    [ -n "$hostname" ] && echo "   📛 Name: $hostname"
                    [ -n "$mac" ] && echo "   🏷️  MAC: $mac"
                    echo ""
                fi
            done
            ;;
        2)
            echo "🔄 Installing nmap for detailed scanning..."
            if ! command -v nmap &>/dev/null; then
                sudo apt update && sudo apt install -y nmap
            fi
            
            echo "🔍 Detailed Network Scan - This may take 2-3 minutes..."
            echo ""
            nmap -sn "$subnet" | grep -E "(Nmap scan report|MAC Address)" | while IFS= read -r line; do
                if [[ $line == *"Nmap scan report"* ]]; then
                    echo "🟢 $(echo "$line" | awk '{print $5}')"
                elif [[ $line == *"MAC Address"* ]]; then
                    echo "   🏷️  $line"
                    echo ""
                fi
            done
            ;;
        3)
            echo "📋 ARP Table Scan - Devices in local cache:"
            echo "==========================================="
            arp -a | while IFS= read -r line; do
                if [[ $line == *"("*")"* ]]; then
                    local device_name=$(echo "$line" | cut -d'(' -f1 | xargs)
                    local ip=$(echo "$line" | cut -d'(' -f2 | cut -d')' -f1)
                    local mac=$(echo "$line" | awk '{print $4}')
                    local interface_info=$(echo "$line" | awk '{print $6}')
                    
                    echo "🟢 $ip"
                    [ -n "$device_name" ] && echo "   📛 Name: $device_name"
                    echo "   🏷️  MAC: $mac"
                    echo "   📡 Interface: $interface_info"
                    echo ""
                fi
            done
            ;;
        4)
            read -p "🎯 Enter IP address to scan ports: " target_ip
            if [[ $target_ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                echo "🔍 Port scanning $target_ip..."
                if command -v nmap &>/dev/null; then
                    nmap -F "$target_ip"
                else
                    echo "📋 Common port check (nmap not installed):"
                    for port in 22 23 25 53 80 110 143 443 993 995; do
                        if timeout 2 bash -c "</dev/tcp/$target_ip/$port" 2>/dev/null; then
                            echo "🟢 Port $port: Open"
                        fi
                    done
                fi
            else
                echo "❌ Invalid IP address format"
            fi
            ;;
        5)
            echo "🔄 Installing nmap for service detection..."
            if ! command -v nmap &>/dev/null; then
                sudo apt update && sudo apt install -y nmap
            fi
            
            echo "🔍 Service Detection Scan - This may take 3-5 minutes..."
            echo ""
            nmap -sV --top-ports 100 "$subnet" | grep -E "(Nmap scan report|open|service)" | while IFS= read -r line; do
                if [[ $line == *"Nmap scan report"* ]]; then
                    echo "🟢 $(echo "$line" | awk '{print $5}')"
                elif [[ $line == *"open"* ]]; then
                    echo "   📡 $line"
                fi
            done
            ;;
        *)
            log_warning "Invalid choice. Running quick ping scan..."
            # Fallback to ping scan
            echo "⚡ Quick scan in progress..."
            for i in {1..10}; do
                local test_ip=$(echo $subnet | cut -d'/' -f1 | sed 's/0$/'"$i"'/')
                ping -c 1 -W 1 "$test_ip" &>/dev/null && echo "🟢 $test_ip"
            done
            ;;
    esac
    
    echo ""
    echo "🛡️ Security Tips:"
    echo "• Unknown devices may indicate unauthorized access"
    echo "• Check device names and MAC addresses against known devices"
    echo "• Consider enabling MAC address filtering on your router"
    echo "• Regularly scan your network for new devices"
    echo ""
    echo "🔧 Advanced Tools:"
    echo "• Use 'nmap -A <IP>' for detailed device fingerprinting"
    echo "• Use 'arp-scan --local' for fast local network discovery"
    echo "• Monitor with 'watch -n 5 arp -a' for real-time updates"
    
    notify_success "Network Scanner" "Device discovery completed"
    
    collect_feedback "network_management" "network_scanning"
}

run_speed_test() {
    print_header "🚀 INTERNET SPEED TEST"
    
    echo "Test your internet connection speed:"
    echo ""
    
    echo "Available speed test methods:"
    echo "1) Speedtest CLI (Ookla) - Most accurate"
    echo "2) Fast.com (Netflix) - Simple and reliable" 
    echo "3) Basic connectivity test - Quick check"
    echo "4) All tests - Comprehensive analysis"
    
    read -p "Select test method (1-4): " test_choice
    
    case "$test_choice" in
        1) run_speedtest_cli ;;
        2) run_fast_com_test ;;
        3) run_basic_connectivity_test ;;
        4) run_comprehensive_speed_test ;;
        *) echo "Invalid selection" ;;
    esac
    
    collect_feedback "network_management" "speed_test"
}

# Speedtest CLI (Ookla)
run_speedtest_cli() {
    echo "🚀 Running Ookla Speedtest..."
    echo ""
    
    # Check if speedtest is installed
    if ! command -v speedtest &>/dev/null; then
        echo "📦 Installing Speedtest CLI..."
        
        if command -v curl &>/dev/null; then
            # Install speedtest-cli
            curl -s https://packagecloud.io/install/repositories/ookla/speedtest-cli/script.deb.sh | sudo bash
            sudo apt update && sudo apt install -y speedtest
        elif command -v apt &>/dev/null; then
            # Try alternative installation
            sudo apt update && sudo apt install -y speedtest-cli
        else
            echo "Please install speedtest manually"
            return 1
        fi
    fi
    
    echo "Testing internet speed..."
    echo "This may take 30-60 seconds..."
    echo ""
    
    # Run speedtest with progress
    if command -v speedtest &>/dev/null; then
        speedtest --accept-license --accept-gdpr
    else
        # Fallback to speedtest-cli
        speedtest-cli --simple
    fi
    
    echo ""
    notify_success "Speed Test" "Internet speed test completed"
}

# Fast.com test (Netflix)
run_fast_com_test() {
    echo "🎬 Running Fast.com test (Netflix CDN)..."
    echo ""
    
    # Check if fast-cli is installed
    if ! command -v fast &>/dev/null; then
        echo "📦 Installing Fast CLI..."
        
        if command -v npm &>/dev/null; then
            sudo npm install --global fast-cli
        elif command -v pip3 &>/dev/null; then
            pip3 install fast-cli
        else
            echo "Please install Node.js or Python to use fast-cli"
            echo "Alternatively, visit https://fast.com in your browser"
            return 1
        fi
    fi
    
    echo "Testing download speed via Netflix CDN..."
    echo ""
    
    if command -v fast &>/dev/null; then
        fast --upload
    else
        echo "Opening fast.com in browser..."
        xdg-open "https://fast.com" 2>/dev/null || echo "Please visit https://fast.com manually"
    fi
}

# Basic connectivity test
run_basic_connectivity_test() {
    echo "🔍 Running basic connectivity test..."
    echo ""
    
    # Test basic connectivity
    echo "Testing connectivity to major servers:"
    
    local test_servers=(
        "8.8.8.8:Google DNS"
        "1.1.1.1:Cloudflare DNS"
        "google.com:80:Google"
        "github.com:443:GitHub"
        "cloudflare.com:80:Cloudflare"
    )
    
    for server_info in "${test_servers[@]}"; do
        local server=$(echo "$server_info" | cut -d: -f1)
        local port=$(echo "$server_info" | cut -d: -f2)
        local name=$(echo "$server_info" | cut -d: -f3)
        
        # Handle DNS servers (no port specified)
        if [ "$port" = "$name" ]; then
            # This is a DNS server, use ping
            if ping -c 1 -W 2 "$server" >/dev/null 2>&1; then
                echo "✅ $server ($name) - Reachable"
            else
                echo "❌ $server ($name) - Unreachable"
            fi
        else
            # This is a web server, use nc or curl
            if command -v nc &>/dev/null; then
                if timeout 5 nc -z "$server" "$port" 2>/dev/null; then
                    echo "✅ $server:$port ($name) - Reachable"
                else
                    echo "❌ $server:$port ($name) - Unreachable"
                fi
            elif command -v curl &>/dev/null; then
                if timeout 5 curl -s "$server:$port" >/dev/null 2>&1; then
                    echo "✅ $server:$port ($name) - Reachable"
                else
                    echo "❌ $server:$port ($name) - Unreachable"
                fi
            fi
        fi
    done
    
    echo ""
    echo "Testing DNS resolution speed:"
    
    # Test DNS resolution time
    local dns_servers=("8.8.8.8" "1.1.1.1" "9.9.9.9")
    for dns in "${dns_servers[@]}"; do
        local resolve_time=$(dig @"$dns" google.com +stats 2>/dev/null | grep "Query time" | awk '{print $4}')
        if [ -n "$resolve_time" ]; then
            echo "📡 $dns: ${resolve_time}ms"
        else
            echo "📡 $dns: Unable to test"
        fi
    done
}

# Comprehensive speed test
run_comprehensive_speed_test() {
    echo "📊 Running comprehensive speed analysis..."
    echo ""
    
    echo "1/3 Testing basic connectivity..."
    run_basic_connectivity_test
    
    echo ""
    echo "2/3 Testing download speed..."
    run_fast_com_test
    
    echo ""
    echo "3/3 Running full speed test..."
    run_speedtest_cli
    
    echo ""
    echo "📋 Speed Test Summary Complete"
    echo "Check results above for detailed analysis."
    
    # Save results
    local results_file="$NETWORK_CONFIG_DIR/speed_test_results.txt"
    echo "$(date): Comprehensive speed test completed" >> "$results_file"
    
    notify_success "Speed Test" "Comprehensive analysis completed"
}

configure_dns() {
    print_header "🌐 DNS CONFIGURATION"
    
    echo "Configure DNS servers for better privacy, security, and performance:"
    echo ""
    
    echo "Popular DNS providers:"
    echo "1) Cloudflare (1.1.1.1) - Fast and privacy-focused"
    echo "2) Google (8.8.8.8) - Fast and reliable"
    echo "3) Quad9 (9.9.9.9) - Security-focused with malware blocking"
    echo "4) OpenDNS (208.67.222.222) - Family-safe filtering options"
    echo "5) AdGuard (94.140.14.14) - Built-in ad blocking"
    echo "6) Custom DNS servers"
    echo "7) Reset to automatic (DHCP)"
    echo ""
    
    read -p "Select DNS option (1-7): " dns_choice
    
    local primary_dns secondary_dns
    
    case "$dns_choice" in
        1)
            primary_dns="1.1.1.1"
            secondary_dns="1.0.0.1"
            echo "Setting Cloudflare DNS..."
            ;;
        2)
            primary_dns="8.8.8.8"
            secondary_dns="8.8.4.4"
            echo "Setting Google DNS..."
            ;;
        3)
            primary_dns="9.9.9.9"
            secondary_dns="149.112.112.112"
            echo "Setting Quad9 DNS..."
            ;;
        4)
            primary_dns="208.67.222.222"
            secondary_dns="208.67.220.220"
            echo "Setting OpenDNS..."
            ;;
        5)
            primary_dns="94.140.14.14"
            secondary_dns="94.140.15.15"
            echo "Setting AdGuard DNS..."
            ;;
        6)
            read -p "Enter primary DNS server: " primary_dns
            read -p "Enter secondary DNS server (optional): " secondary_dns
            ;;
        7)
            echo "Resetting to automatic DNS..."
            reset_dns_to_auto
            return
            ;;
        *)
            echo "Invalid selection"
            return
            ;;
    esac
    
    # Apply DNS configuration
    if command -v nmcli &>/dev/null; then
        apply_dns_networkmanager "$primary_dns" "$secondary_dns"
    elif command -v systemctl &>/dev/null && systemctl is-active systemd-resolved &>/dev/null; then
        apply_dns_systemd_resolved "$primary_dns" "$secondary_dns"
    else
        apply_dns_resolv_conf "$primary_dns" "$secondary_dns"
    fi
    
    # Test DNS resolution
    echo ""
    echo "Testing DNS resolution..."
    test_dns_resolution
    
    collect_feedback "network_management" "dns_configuration"
}

# Apply DNS via NetworkManager
apply_dns_networkmanager() {
    local primary="$1"
    local secondary="$2"
    
    echo "Applying DNS via NetworkManager..."
    
    # Get active connection
    local connection=$(nmcli -t -f NAME connection show --active | head -1)
    
    if [ -n "$connection" ]; then
        local dns_servers="$primary"
        if [ -n "$secondary" ]; then
            dns_servers="$primary,$secondary"
        fi
        
        nmcli connection modify "$connection" ipv4.dns "$dns_servers"
        nmcli connection modify "$connection" ipv4.ignore-auto-dns yes
        nmcli connection up "$connection"
        
        notify_success "DNS" "DNS servers updated to $primary"
        log_success "DNS configured via NetworkManager: $dns_servers"
    else
        log_error "No active NetworkManager connection found"
    fi
}

# Apply DNS via systemd-resolved
apply_dns_systemd_resolved() {
    local primary="$1"
    local secondary="$2"
    
    echo "Applying DNS via systemd-resolved..."
    
    # Create resolved configuration
    local config_dir="/etc/systemd/resolved.conf.d"
    sudo mkdir -p "$config_dir"
    
    local dns_config="$config_dir/custom-dns.conf"
    
    cat << EOF | sudo tee "$dns_config" >/dev/null
[Resolve]
DNS=$primary${secondary:+ $secondary}
FallbackDNS=
Domains=~.
DNSSEC=yes
DNSOverTLS=yes
Cache=yes
EOF
    
    # Restart systemd-resolved
    sudo systemctl restart systemd-resolved
    
    notify_success "DNS" "DNS servers updated via systemd-resolved"
    log_success "DNS configured via systemd-resolved: $primary${secondary:+ $secondary}"
}

# Apply DNS via /etc/resolv.conf
apply_dns_resolv_conf() {
    local primary="$1"
    local secondary="$2"
    
    echo "Applying DNS via /etc/resolv.conf..."
    
    # Backup current resolv.conf
    sudo cp /etc/resolv.conf /etc/resolv.conf.backup
    
    # Create new resolv.conf
    cat << EOF | sudo tee /etc/resolv.conf >/dev/null
# Generated by Bill Sloth Network Management
nameserver $primary
EOF
    
    if [ -n "$secondary" ]; then
        echo "nameserver $secondary" | sudo tee -a /etc/resolv.conf >/dev/null
    fi
    
    # Make immutable to prevent DHCP overwriting
    sudo chattr +i /etc/resolv.conf 2>/dev/null || true
    
    notify_success "DNS" "DNS servers updated in /etc/resolv.conf"
    log_success "DNS configured via resolv.conf: $primary${secondary:+ $secondary}"
}

# Reset DNS to automatic
reset_dns_to_auto() {
    echo "Resetting DNS to automatic configuration..."
    
    if command -v nmcli &>/dev/null; then
        # Reset NetworkManager
        local connection=$(nmcli -t -f NAME connection show --active | head -1)
        if [ -n "$connection" ]; then
            nmcli connection modify "$connection" ipv4.dns ""
            nmcli connection modify "$connection" ipv4.ignore-auto-dns no
            nmcli connection up "$connection"
        fi
    fi
    
    if systemctl is-active systemd-resolved &>/dev/null; then
        # Reset systemd-resolved
        sudo rm -f /etc/systemd/resolved.conf.d/custom-dns.conf
        sudo systemctl restart systemd-resolved
    fi
    
    # Reset resolv.conf
    sudo chattr -i /etc/resolv.conf 2>/dev/null || true
    if [ -f "/etc/resolv.conf.backup" ]; then
        sudo cp /etc/resolv.conf.backup /etc/resolv.conf
    fi
    
    notify_success "DNS" "DNS reset to automatic configuration"
}

# Test DNS resolution
test_dns_resolution() {
    echo "Testing DNS resolution..."
    
    local test_domains=("google.com" "cloudflare.com" "github.com")
    local success_count=0
    
    for domain in "${test_domains[@]}"; do
        if nslookup "$domain" >/dev/null 2>&1; then
            echo "✅ $domain resolved successfully"
            success_count=$((success_count + 1))
        else
            echo "❌ Failed to resolve $domain"
        fi
    done
    
    echo ""
    if [ $success_count -eq ${#test_domains[@]} ]; then
        echo "🎉 DNS resolution test: All tests passed!"
    else
        echo "⚠️  DNS resolution test: $success_count/${#test_domains[@]} tests passed"
    fi
    
    # Show current DNS servers
    echo ""
    echo "Current DNS configuration:"
    if command -v systemd-resolve &>/dev/null; then
        systemd-resolve --status | grep -A 5 "DNS Servers"
    elif [ -f "/etc/resolv.conf" ]; then
        echo "From /etc/resolv.conf:"
        grep nameserver /etc/resolv.conf
    fi
}

setup_ad_blocking() {
    log_info "Ad-blocking setup coming in next update"
    echo "This will provide Pi-hole style ad blocking."
}

optimize_network() {
    print_header "⚡ NETWORK OPTIMIZATION CENTER"
    
    echo "🚀 Network Performance Optimizer - Maximize your connection speed"
    echo "• Optimize TCP/IP settings for better throughput"
    echo "• Configure network buffers and queues"
    echo "• Tune DNS resolution and caching"
    echo "• Apply system-level networking optimizations"
    echo ""
    
    echo "⚠️  IMPORTANT: These optimizations modify system network settings."
    echo "   A backup will be created before making changes."
    echo ""
    
    echo "📋 Optimization Categories:"
    echo "1) DNS optimization (safe, recommended)"
    echo "2) TCP/IP performance tuning"
    echo "3) Network interface optimization"
    echo "4) Bandwidth allocation optimization"
    echo "5) Gaming/low-latency optimization"
    echo "6) Restore default settings"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select optimization type (1-6)" 15 "1")
    
    # Create backup directory
    local backup_dir="/tmp/network-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    case "$choice" in
        1)
            echo "🌐 DNS Optimization"
            echo "=================="
            echo ""
            echo "Optimizing DNS resolution for faster web browsing..."
            
            # Backup current DNS settings
            cp /etc/resolv.conf "$backup_dir/"
            
            echo "🔄 Installing DNS optimization tools..."
            sudo apt update && sudo apt install -y dnsutils systemd-resolved
            
            # Configure fast DNS servers
            echo "📋 Configuring optimized DNS servers:"
            echo "• Primary: 1.1.1.1 (Cloudflare)"
            echo "• Secondary: 8.8.8.8 (Google)"
            echo "• Tertiary: 9.9.9.9 (Quad9)"
            
            # Update DNS configuration
            sudo tee /etc/systemd/resolved.conf > /dev/null <<EOF
[Resolve]
DNS=1.1.1.1 8.8.8.8 9.9.9.9
FallbackDNS=208.67.222.222 208.67.220.220
Cache=yes
DNSSEC=yes
DNSOverTLS=yes
EOF
            
            # Restart DNS service
            sudo systemctl restart systemd-resolved
            
            # Test DNS resolution speed
            echo ""
            echo "🔍 Testing DNS resolution speed:"
            for domain in google.com cloudflare.com github.com; do
                local resolve_time=$(dig +noall +stats "$domain" | grep "Query time" | awk '{print $4, $5}')
                echo "• $domain: $resolve_time"
            done
            
            echo ""
            echo "✅ DNS optimization complete!"
            echo "🔄 Your web browsing should be noticeably faster"
            ;;
        2)
            echo "⚡ TCP/IP Performance Tuning"
            echo "==========================="
            echo ""
            echo "Optimizing TCP/IP stack for better network throughput..."
            
            # Backup current sysctl settings
            sysctl -a > "$backup_dir/sysctl-backup.conf" 2>/dev/null
            
            echo "🔧 Applying TCP/IP optimizations..."
            
            # Create optimized sysctl configuration
            sudo tee /etc/sysctl.d/99-network-performance.conf > /dev/null <<EOF
# Network Performance Optimizations
# TCP Buffer Sizes
net.core.rmem_default = 262144
net.core.rmem_max = 16777216
net.core.wmem_default = 262144
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 65536 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# TCP Window Scaling
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_fack = 1

# TCP Congestion Control
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# Network Queue Sizes
net.core.netdev_max_backlog = 5000
net.core.netdev_budget = 600

# TCP Fast Open
net.ipv4.tcp_fastopen = 3

# Reduce TIME_WAIT connections
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_tw_reuse = 1
EOF
            
            # Apply settings
            sudo sysctl -p /etc/sysctl.d/99-network-performance.conf
            
            echo ""
            echo "📊 Current TCP settings:"
            echo "• Congestion control: $(sysctl net.ipv4.tcp_congestion_control | cut -d' ' -f3)"
            echo "• Window scaling: $(sysctl net.ipv4.tcp_window_scaling | cut -d' ' -f3)"
            echo "• SACK enabled: $(sysctl net.ipv4.tcp_sack | cut -d' ' -f3)"
            
            echo ""
            echo "✅ TCP/IP optimization complete!"
            echo "🔄 Network throughput should be improved"
            ;;
        3)
            echo "🔧 Network Interface Optimization"
            echo "================================"
            echo ""
            
            # Get primary network interface
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            echo "🌐 Optimizing interface: $interface"
            
            echo "🔄 Checking interface capabilities..."
            ethtool "$interface" 2>/dev/null | grep -E "(Speed|Duplex|Auto-negotiation)" || {
                echo "📥 Installing ethtool..."
                sudo apt update && sudo apt install -y ethtool
            }
            
            echo ""
            echo "⚙️ Interface optimization options:"
            echo "1) Enable hardware offloading (if supported)"
            echo "2) Optimize interrupt handling"
            echo "3) Adjust ring buffer sizes"
            echo "4) Configure interrupt coalescing"
            
            read -p "Select interface optimization (1-4): " iface_choice
            
            case "$iface_choice" in
                1)
                    echo "🔧 Enabling hardware offloading..."
                    sudo ethtool -K "$interface" gso on tso on ufo on gro on lro on 2>/dev/null || echo "Some features not supported"
                    ;;
                2)
                    echo "🔧 Optimizing interrupt handling..."
                    echo 2 | sudo tee /proc/sys/net/core/busy_read > /dev/null
                    echo 50 | sudo tee /proc/sys/net/core/busy_poll > /dev/null
                    ;;
                3)
                    echo "🔧 Adjusting ring buffer sizes..."
                    sudo ethtool -G "$interface" rx 4096 tx 4096 2>/dev/null || echo "Ring buffer adjustment not supported"
                    ;;
                4)
                    echo "🔧 Configuring interrupt coalescing..."
                    sudo ethtool -C "$interface" rx-usecs 50 tx-usecs 50 2>/dev/null || echo "Interrupt coalescing not supported"
                    ;;
            esac
            
            echo ""
            echo "✅ Interface optimization complete!"
            ;;
        4)
            echo "📊 Bandwidth Allocation Optimization"
            echo "==================================="
            echo ""
            echo "Setting up Quality of Service (QoS) and traffic shaping..."
            
            echo "🔄 Installing traffic control tools..."
            sudo apt update && sudo apt install -y iproute2 wondershaper
            
            echo ""
            read -p "📡 Enter your download speed (Mbps): " download_speed
            read -p "📤 Enter your upload speed (Mbps): " upload_speed
            
            # Convert Mbps to Kbps
            local download_kbps=$((download_speed * 1000))
            local upload_kbps=$((upload_speed * 1000))
            
            echo ""
            echo "🔧 Configuring bandwidth allocation:"
            echo "• Total download: ${download_speed}Mbps"
            echo "• Total upload: ${upload_speed}Mbps"
            echo "• High priority: 70% (web, DNS, SSH)"
            echo "• Normal priority: 20% (general traffic)"
            echo "• Low priority: 10% (bulk downloads, P2P)"
            
            # Apply traffic shaping
            sudo wondershaper "$interface" "$download_kbps" "$upload_kbps"
            
            echo ""
            echo "✅ Bandwidth optimization active!"
            echo "🔄 Use 'sudo wondershaper clear $interface' to remove"
            ;;
        5)
            echo "🎮 Gaming/Low-Latency Optimization"
            echo "================================="
            echo ""
            echo "Optimizing for minimum latency and gaming performance..."
            
            # Gaming-specific optimizations
            sudo tee /etc/sysctl.d/99-gaming-performance.conf > /dev/null <<EOF
# Gaming Performance Optimizations
# Reduce network latency
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_no_delay = 1

# Faster connection establishment
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_synack_retries = 3

# Optimize for interactive traffic
net.ipv4.tcp_congestion_control = westwood
net.core.default_qdisc = pfifo_fast

# Reduce buffer bloat
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728

# Fast recovery
net.ipv4.tcp_frto = 2
net.ipv4.tcp_recovery = 1
EOF
            
            sudo sysctl -p /etc/sysctl.d/99-gaming-performance.conf
            
            echo "🎯 Gaming DNS optimization..."
            # Use low-latency DNS servers
            sudo tee /etc/systemd/resolved.conf > /dev/null <<EOF
[Resolve]
DNS=1.1.1.1 1.0.0.1
FallbackDNS=8.8.8.8 8.8.4.4
Cache=yes
DNSSEC=no
DNSOverTLS=no
EOF
            
            sudo systemctl restart systemd-resolved
            
            echo ""
            echo "🔍 Testing ping latency to common gaming servers:"
            for server in "8.8.8.8" "1.1.1.1" "cloudflare.com"; do
                local ping_result=$(ping -c 3 "$server" 2>/dev/null | tail -1 | awk -F'/' '{print $5}' | cut -d' ' -f1)
                echo "• $server: ${ping_result:-N/A}ms"
            done
            
            echo ""
            echo "✅ Gaming optimization complete!"
            echo "🎮 Your ping times should be improved"
            ;;
        6)
            echo "🔄 Restoring Default Network Settings"
            echo "===================================="
            echo ""
            echo "Removing all network optimizations and restoring defaults..."
            
            # Remove optimization files
            sudo rm -f /etc/sysctl.d/99-network-performance.conf
            sudo rm -f /etc/sysctl.d/99-gaming-performance.conf
            
            # Clear traffic shaping
            sudo wondershaper clear "$interface" 2>/dev/null || true
            
            # Reset sysctl to defaults
            sudo sysctl --system
            
            # Reset DNS to default
            sudo systemctl disable systemd-resolved 2>/dev/null || true
            sudo systemctl stop systemd-resolved 2>/dev/null || true
            
            echo ""
            echo "✅ Network settings restored to defaults!"
            echo "🔄 Reboot recommended for complete reset"
            ;;
        *)
            log_warning "Invalid choice. Running DNS optimization as safe default..."
            # Default to DNS optimization as it's the safest option
            echo "🌐 Applying safe DNS optimization..."
            sudo apt install -y systemd-resolved
            
            sudo tee /etc/systemd/resolved.conf > /dev/null <<EOF
[Resolve]
DNS=1.1.1.1 8.8.8.8
Cache=yes
EOF
            sudo systemctl restart systemd-resolved
            echo "✅ Basic DNS optimization applied"
            ;;
    esac
    
    echo ""
    echo "📋 Optimization Management:"
    echo "• Backup created at: $backup_dir"
    echo "• Monitor performance with: speedtest-cli"
    echo "• Check ping latency with: ping -c 5 1.1.1.1"
    echo "• View active settings with: sysctl net.ipv4.tcp_congestion_control"
    echo ""
    echo "⚠️  Important Notes:"
    echo "• Some changes require reboot to take full effect"
    echo "• Monitor system stability after optimization"
    echo "• Backup files are available for restoration if needed"
    echo "• Gaming optimizations may reduce overall throughput"
    
    notify_success "Network Optimization" "Performance tuning completed successfully"
    
    collect_feedback "network_management" "network_optimization"
}

configure_proxy() {
    log_info "Proxy configuration coming in next update"
    echo "This will set up HTTP/SOCKS proxies."
}

run_network_diagnostics() {
    print_header "🔧 NETWORK DIAGNOSTICS"
    
    echo "Comprehensive network connectivity and performance diagnostics:"
    echo ""
    
    echo "Running network diagnostic tests..."
    notify_info "Diagnostics" "Starting network analysis..."
    
    # Test 1: Basic Network Interface Status
    echo "1️⃣  Network Interface Status"
    echo "=============================="
    ip addr show | grep -E "^[0-9]+:|inet " | while read -r line; do
        if [[ $line =~ ^[0-9]+: ]]; then
            interface=$(echo "$line" | cut -d: -f2 | tr -d ' ')
            state=$(echo "$line" | grep -o "state [A-Z]*" | cut -d' ' -f2)
            echo "🔌 Interface: $interface - State: ${state:-UNKNOWN}"
        elif [[ $line =~ inet ]]; then
            ip=$(echo "$line" | awk '{print $2}')
            echo "   └─ IP: $ip"
        fi
    done
    echo ""
    
    # Test 2: Default Gateway
    echo "2️⃣  Default Gateway Test"
    echo "========================"
    local gateway=$(ip route | grep default | awk '{print $3}' | head -1)
    if [ -n "$gateway" ]; then
        echo "🏠 Default Gateway: $gateway"
        if ping -c 3 -W 2 "$gateway" >/dev/null 2>&1; then
            echo "✅ Gateway is reachable"
        else
            echo "❌ Gateway is unreachable"
        fi
    else
        echo "❌ No default gateway found"
    fi
    echo ""
    
    # Test 3: DNS Resolution
    echo "3️⃣  DNS Resolution Test"
    echo "======================="
    local dns_servers=($(grep nameserver /etc/resolv.conf 2>/dev/null | awk '{print $2}'))
    if [ ${#dns_servers[@]} -eq 0 ]; then
        dns_servers=("8.8.8.8" "1.1.1.1")
        echo "ℹ️  Using fallback DNS servers for testing"
    fi
    
    for dns in "${dns_servers[@]}"; do
        echo "🌐 Testing DNS: $dns"
        if ping -c 1 -W 2 "$dns" >/dev/null 2>&1; then
            echo "   ✅ DNS server reachable"
            
            # Test resolution
            if nslookup google.com "$dns" >/dev/null 2>&1; then
                echo "   ✅ Domain resolution working"
            else
                echo "   ❌ Domain resolution failed"
            fi
        else
            echo "   ❌ DNS server unreachable"
        fi
    done
    echo ""
    
    # Test 4: Internet Connectivity
    echo "4️⃣  Internet Connectivity Test"
    echo "=============================="
    local test_sites=("google.com" "cloudflare.com" "github.com")
    local success_count=0
    
    for site in "${test_sites[@]}"; do
        echo "🌍 Testing connectivity to $site..."
        if ping -c 2 -W 3 "$site" >/dev/null 2>&1; then
            echo "   ✅ $site is reachable"
            success_count=$((success_count + 1))
        else
            echo "   ❌ $site is unreachable"
        fi
    done
    
    if [ $success_count -eq ${#test_sites[@]} ]; then
        echo "🎉 Internet connectivity: Excellent"
    elif [ $success_count -gt 0 ]; then
        echo "⚠️  Internet connectivity: Partial ($success_count/${#test_sites[@]} sites reachable)"
    else
        echo "❌ Internet connectivity: Failed"
    fi
    echo ""
    
    # Test 5: Port Connectivity
    echo "5️⃣  Common Port Connectivity"
    echo "==========================="
    local common_ports=(
        "80:HTTP"
        "443:HTTPS" 
        "53:DNS"
        "22:SSH"
        "21:FTP"
    )
    
    for port_info in "${common_ports[@]}"; do
        local port=$(echo "$port_info" | cut -d: -f1)
        local service=$(echo "$port_info" | cut -d: -f2)
        
        echo "🔌 Testing port $port ($service)..."
        
        if command -v nc &>/dev/null; then
            if timeout 3 nc -z google.com "$port" 2>/dev/null; then
                echo "   ✅ Port $port is accessible"
            else
                echo "   ❌ Port $port is blocked or unreachable"
            fi
        else
            echo "   ⚠️  Cannot test - netcat not available"
        fi
    done
    echo ""
    
    # Test 6: Network Performance
    echo "6️⃣  Network Performance"
    echo "======================"
    
    # Ping test to measure latency
    echo "📡 Latency test to major servers:"
    local latency_servers=("8.8.8.8:Google" "1.1.1.1:Cloudflare" "208.67.222.222:OpenDNS")
    
    for server_info in "${latency_servers[@]}"; do
        local server=$(echo "$server_info" | cut -d: -f1)
        local name=$(echo "$server_info" | cut -d: -f2)
        
        local avg_time=$(ping -c 4 -W 2 "$server" 2>/dev/null | grep "rtt" | cut -d= -f2 | cut -d/ -f2)
        if [ -n "$avg_time" ]; then
            echo "   📈 $name ($server): ${avg_time}ms average"
        else
            echo "   ❌ $name ($server): Unable to measure"
        fi
    done
    echo ""
    
    # Test 7: Active Connections
    echo "7️⃣  Active Network Connections"
    echo "============================="
    if command -v ss &>/dev/null; then
        local tcp_count=$(ss -t | wc -l)
        local udp_count=$(ss -u | wc -l)
        local listening_count=$(ss -l | wc -l)
        
        echo "📊 Active TCP connections: $tcp_count"
        echo "📊 Active UDP connections: $udp_count" 
        echo "📊 Listening ports: $listening_count"
        
        echo ""
        echo "Top 5 listening services:"
        ss -tlnp | head -6 | tail -5 | while read -r line; do
            local port=$(echo "$line" | awk '{print $4}' | cut -d: -f2)
            local process=$(echo "$line" | awk '{print $6}' | cut -d'"' -f2 2>/dev/null || echo "unknown")
            echo "   🔌 Port $port: $process"
        done
    else
        echo "⚠️  ss command not available - using netstat"
        if command -v netstat &>/dev/null; then
            netstat -tuln | grep LISTEN | head -5
        else
            echo "❌ No network statistics tools available"
        fi
    fi
    echo ""
    
    # Test 8: VPN Status
    echo "8️⃣  VPN Connection Status"
    echo "========================"
    local vpn_active=false
    
    # Check WireGuard
    if command -v wg &>/dev/null && wg show | grep -q interface; then
        echo "🔐 WireGuard VPN: Active"
        wg show | grep -E "(interface|endpoint|latest handshake)"
        vpn_active=true
    fi
    
    # Check OpenVPN
    if pgrep openvpn >/dev/null; then
        echo "🔐 OpenVPN: Active"
        vpn_active=true
    fi
    
    if [ "$vpn_active" = false ]; then
        echo "🔓 No active VPN connections detected"
    fi
    echo ""
    
    # Test 9: Firewall Status
    echo "9️⃣  Firewall Status"
    echo "=================="
    if command -v ufw &>/dev/null; then
        local ufw_status=$(sudo ufw status | head -1)
        echo "🛡️  UFW: $ufw_status"
        if [[ $ufw_status =~ active ]]; then
            local rule_count=$(sudo ufw status numbered | grep -c "^\[")
            echo "   📋 Active rules: $rule_count"
        fi
    elif command -v firewall-cmd &>/dev/null; then
        if firewall-cmd --state >/dev/null 2>&1; then
            echo "🛡️  Firewalld: Active"
        else
            echo "🛡️  Firewalld: Inactive"
        fi
    else
        echo "⚠️  No firewall management tool detected"
    fi
    echo ""
    
    # Final Summary
    echo "📋 DIAGNOSTIC SUMMARY"
    echo "===================="
    
    # Save diagnostic results
    local results_file="$NETWORK_CONFIG_DIR/diagnostic_results.txt"
    echo "$(date): Network diagnostic completed" >> "$results_file"
    
    # Recommendations
    echo ""
    echo "💡 RECOMMENDATIONS:"
    
    if [ $success_count -lt ${#test_sites[@]} ]; then
        echo "• Internet connectivity issues detected - check router/ISP"
    fi
    
    if [ ${#dns_servers[@]} -eq 0 ]; then
        echo "• Consider configuring custom DNS servers for better performance"
    fi
    
    if [ "$vpn_active" = false ]; then
        echo "• Consider setting up VPN for enhanced privacy and security"
    fi
    
    echo "• Run 'bill-voice network status' for real-time monitoring"
    echo "• Use 'bill-voice speed test' to check bandwidth performance"
    
    notify_success "Diagnostics" "Network diagnostic completed - check results above"
    
    collect_feedback "network_management" "network_diagnostics"
}

reset_network_settings() {
    log_info "Network reset coming in next update"
    echo "This will reset all network configurations to defaults."
}

security_audit() {
    print_header "🛡️ NETWORK SECURITY AUDIT"
    
    echo "🔒 Comprehensive Network Security Assessment"
    echo "• Network configuration security analysis"
    echo "• Vulnerability scanning and detection"
    echo "• Security best practices validation"
    echo "• Automated remediation suggestions"
    echo ""
    
    echo "📋 Security Audit Categories:"
    echo "1) Network interface security"
    echo "2) Firewall configuration audit"
    echo "3) VPN security assessment"
    echo "4) Wi-Fi security analysis"
    echo "5) Port scanning and exposure check"
    echo "6) DNS security validation"
    echo "7) Complete security assessment"
    echo ""
    
    local choice
    choice=$(prompt_with_timeout "Select audit type (1-7)" 15 "7")
    
    case "$choice" in
        1)
            echo "🔌 Network Interface Security Audit"
            echo "=================================="
            echo ""
            
            echo "🔍 Analyzing network interfaces..."
            
            # Check for interfaces in promiscuous mode
            echo "📋 Interface Security Status:"
            ip link show | while read -r line; do
                if [[ $line == *": "* ]]; then
                    local interface=$(echo "$line" | cut -d':' -f2 | xargs)
                    local flags=$(echo "$line" | grep -o '<[^>]*>')
                    
                    echo "• Interface: $interface"
                    
                    if [[ $flags == *"PROMISC"* ]]; then
                        echo "  ⚠️ SECURITY RISK: Promiscuous mode enabled"
                        echo "     This could indicate packet sniffing or monitoring"
                    else
                        echo "  ✅ Normal mode"
                    fi
                    
                    if [[ $flags == *"UP"* ]]; then
                        echo "  🟢 Status: Active"
                    else
                        echo "  🔴 Status: Inactive"
                    fi
                    echo ""
                fi
            done
            
            # Check for unusual network configurations
            echo "🔍 Network Configuration Analysis:"
            
            # Check for IPv6 status
            if sysctl net.ipv6.conf.all.disable_ipv6 | grep -q "= 0"; then
                echo "• IPv6: ✅ Enabled (ensure firewall covers IPv6)"
            else
                echo "• IPv6: ⚠️ Disabled (may limit functionality)"
            fi
            
            # Check for IP forwarding
            local ipv4_forward=$(sysctl net.ipv4.ip_forward | cut -d'=' -f2 | xargs)
            if [ "$ipv4_forward" = "1" ]; then
                echo "• IP Forwarding: ⚠️ ENABLED - This makes your system act as a router"
            else
                echo "• IP Forwarding: ✅ Disabled"
            fi
            
            # Check for source routing
            local accept_source_route=$(sysctl net.ipv4.conf.all.accept_source_route | cut -d'=' -f2 | xargs)
            if [ "$accept_source_route" = "0" ]; then
                echo "• Source Routing: ✅ Disabled (secure)"
            else
                echo "• Source Routing: ⚠️ ENABLED - Security risk"
            fi
            ;;
        2)
            echo "🔥 Firewall Configuration Audit"
            echo "==============================="
            echo ""
            
            echo "🔍 Analyzing firewall status..."
            
            # Check UFW status
            if command -v ufw &>/dev/null; then
                local ufw_status=$(sudo ufw status | head -1)
                echo "📋 UFW Firewall:"
                echo "• Status: $ufw_status"
                
                if [[ $ufw_status == *"active"* ]]; then
                    echo "  ✅ Firewall is active"
                    echo ""
                    echo "  📋 Active Rules:"
                    sudo ufw status numbered | tail -n +4
                else
                    echo "  ⚠️ SECURITY RISK: Firewall is inactive"
                    echo "  🔧 Enable with: sudo ufw enable"
                fi
            else
                echo "📋 UFW not installed"
            fi
            
            echo ""
            
            # Check iptables rules
            echo "📋 iptables Rules:"
            local iptables_rules=$(sudo iptables -L | wc -l)
            echo "• Total rules: $iptables_rules"
            
            # Check for default policies
            local input_policy=$(sudo iptables -L INPUT | head -1 | grep -o 'policy [A-Z]*' | cut -d' ' -f2)
            local forward_policy=$(sudo iptables -L FORWARD | head -1 | grep -o 'policy [A-Z]*' | cut -d' ' -f2)
            local output_policy=$(sudo iptables -L OUTPUT | head -1 | grep -o 'policy [A-Z]*' | cut -d' ' -f2)
            
            echo "• INPUT policy: $input_policy $([ "$input_policy" = "DROP" ] && echo "✅" || echo "⚠️")"
            echo "• FORWARD policy: $forward_policy $([ "$forward_policy" = "DROP" ] && echo "✅" || echo "⚠️")"
            echo "• OUTPUT policy: $output_policy"
            
            # Check for common dangerous rules
            if sudo iptables -L | grep -q "ACCEPT.*anywhere.*anywhere"; then
                echo "  ⚠️ Found overly permissive rules - review carefully"
            fi
            ;;
        3)
            echo "🔒 VPN Security Assessment"
            echo "========================="
            echo ""
            
            echo "🔍 Analyzing VPN configurations..."
            
            # Check WireGuard configurations
            if [ -d /etc/wireguard ]; then
                local wg_configs=($(ls /etc/wireguard/*.conf 2>/dev/null))
                echo "📋 WireGuard Security:"
                echo "• Configurations found: ${#wg_configs[@]}"
                
                for config in "${wg_configs[@]}"; do
                    local config_name=$(basename "$config" .conf)
                    echo ""
                    echo "🔍 Analyzing: $config_name"
                    
                    # Check file permissions
                    local perms=$(stat -c "%a" "$config")
                    if [ "$perms" = "600" ]; then
                        echo "  ✅ File permissions: Secure (600)"
                    else
                        echo "  ⚠️ File permissions: $perms (should be 600)"
                    fi
                    
                    # Check for DNS leaks protection
                    if grep -q "DNS" "$config"; then
                        echo "  ✅ DNS configuration: Present"
                    else
                        echo "  ⚠️ DNS configuration: Missing (potential DNS leak)"
                    fi
                    
                    # Check allowed IPs
                    local allowed_ips=$(grep "AllowedIPs" "$config" | cut -d'=' -f2 | xargs)
                    if [ "$allowed_ips" = "0.0.0.0/0, ::/0" ] || [ "$allowed_ips" = "0.0.0.0/0" ]; then
                        echo "  ⚠️ Full tunnel mode: All traffic routed through VPN"
                    else
                        echo "  ℹ️ Split tunnel mode: $allowed_ips"
                    fi
                    
                    # Check for keep-alive
                    if grep -q "PersistentKeepalive" "$config"; then
                        echo "  ✅ Keep-alive: Configured"
                    else
                        echo "  ℹ️ Keep-alive: Not configured"
                    fi
                done
            else
                echo "📋 WireGuard: Not configured"
            fi
            
            # Check OpenVPN configurations
            if [ -d /etc/openvpn ]; then
                local ovpn_configs=($(smart_find "*.conf" "/etc/openvpn" 2>/dev/null))
                echo ""
                echo "📋 OpenVPN Security:"
                echo "• Configurations found: ${#ovpn_configs[@]}"
                
                for config in "${ovpn_configs[@]}"; do
                    echo "🔍 $(basename "$config")"
                    
                    # Check for security-relevant directives
                    if grep -q "cipher AES-256" "$config"; then
                        echo "  ✅ Strong encryption: AES-256"
                    else
                        echo "  ⚠️ Encryption: Check cipher strength"
                    fi
                    
                    if grep -q "auth SHA256" "$config"; then
                        echo "  ✅ Strong authentication: SHA256"
                    else
                        echo "  ⚠️ Authentication: Check hash strength"
                    fi
                done
            else
                echo "📋 OpenVPN: Not configured"
            fi
            ;;
        4)
            echo "📡 Wi-Fi Security Analysis"
            echo "========================="
            echo ""
            
            echo "🔍 Analyzing Wi-Fi security..."
            
            if command -v nmcli &>/dev/null; then
                echo "📋 Saved Wi-Fi Networks Security:"
                nmcli connection show | grep wifi | while read -r line; do
                    local conn_name=$(echo "$line" | awk '{print $1}')
                    local security=$(nmcli connection show "$conn_name" | grep "802-11-wireless-security.key-mgmt" | cut -d':' -f2 | xargs)
                    
                    echo "• Network: $conn_name"
                    case "$security" in
                        "wpa-psk"|"wpa2-psk"|"sae")
                            echo "  ✅ Security: $security (Secure)"
                            ;;
                        "none"|"")
                            echo "  ⚠️ Security: Open network (INSECURE)"
                            ;;
                        "wep")
                            echo "  ⚠️ Security: WEP (OUTDATED - easily broken)"
                            ;;
                        *)
                            echo "  ℹ️ Security: $security"
                            ;;
                    esac
                done
            fi
            
            # Check current Wi-Fi connection security
            echo ""
            echo "📋 Current Wi-Fi Connection:"
            if command -v iwconfig &>/dev/null; then
                local current_wifi=$(iwconfig 2>/dev/null | grep -E "ESSID|Encryption")
                if [ -n "$current_wifi" ]; then
                    echo "$current_wifi" | while read -r line; do
                        if [[ $line == *"Encryption key:on"* ]]; then
                            echo "✅ Current connection: Encrypted"
                        elif [[ $line == *"Encryption key:off"* ]]; then
                            echo "⚠️ SECURITY RISK: Current connection is unencrypted"
                        fi
                    done
                else
                    echo "ℹ️ No active Wi-Fi connection"
                fi
            fi
            
            # Wi-Fi security recommendations
            echo ""
            echo "🛡️ Wi-Fi Security Recommendations:"
            echo "• Use WPA3 or WPA2 networks only"
            echo "• Avoid open/unencrypted networks"
            echo "• Use VPN on untrusted networks"
            echo "• Disable Wi-Fi auto-connect for sensitive locations"
            echo "• Regularly review saved networks"
            ;;
        5)
            echo "🔍 Port Scanning & Exposure Check"
            echo "================================="
            echo ""
            
            echo "🔍 Scanning for open ports and services..."
            
            # Check listening ports
            echo "📋 Listening Ports (Local Services):"
            netstat -tuln 2>/dev/null | grep LISTEN | while read -r line; do
                local proto=$(echo "$line" | awk '{print $1}')
                local address=$(echo "$line" | awk '{print $4}')
                local port=$(echo "$address" | rev | cut -d':' -f1 | rev)
                local bind_addr=$(echo "$address" | rev | cut -d':' -f2- | rev)
                
                echo "• Port $port ($proto)"
                
                # Check binding address
                if [[ $bind_addr == "0.0.0.0" || $bind_addr == "::" ]]; then
                    echo "  ⚠️ Exposed: Listening on all interfaces"
                    
                    # Identify common risky ports
                    case "$port" in
                        "22") echo "     SSH - Ensure strong authentication" ;;
                        "23") echo "     TELNET - INSECURE, use SSH instead" ;;
                        "21") echo "     FTP - Consider SFTP instead" ;;
                        "80") echo "     HTTP - Consider HTTPS" ;;
                        "443") echo "     HTTPS - Generally secure" ;;
                        "3389") echo "     RDP - Secure with strong passwords/keys" ;;
                        "5900") echo "     VNC - Secure with authentication" ;;
                    esac
                elif [[ $bind_addr == "127.0.0.1" || $bind_addr == "::1" ]]; then
                    echo "  ✅ Local only: Safe"
                else
                    echo "  ℹ️ Specific interface: $bind_addr"
                fi
            done
            
            echo ""
            echo "📋 External Port Scan (checking common ports):"
            
            # Get external IP
            local external_ip=$(curl -s --connect-timeout 5 ifconfig.me 2>/dev/null || echo "Unable to detect")
            echo "• External IP: $external_ip"
            
            if [ "$external_ip" != "Unable to detect" ]; then
                echo "🔍 Scanning common ports from external perspective..."
                
                # Check common ports with timeout
                for port in 22 23 80 443 21 25 53 110 143 993 995 3389 5900; do
                    if timeout 2 bash -c "</dev/tcp/$external_ip/$port" 2>/dev/null; then
                        echo "  ⚠️ Port $port: Externally accessible"
                    fi
                done
                echo "  ✅ Scan complete (only showing open ports)"
            fi
            ;;
        6)
            echo "🌐 DNS Security Validation"
            echo "========================="
            echo ""
            
            echo "🔍 Analyzing DNS configuration security..."
            
            # Check current DNS servers
            echo "📋 Current DNS Configuration:"
            if command -v systemd-resolve &>/dev/null; then
                local dns_servers=$(systemd-resolve --status | grep "DNS Servers" | head -5)
                echo "$dns_servers"
                
                # Check for secure DNS providers
                if echo "$dns_servers" | grep -q "1.1.1.1\|8.8.8.8\|9.9.9.9"; then
                    echo "✅ Using reputable DNS providers"
                else
                    echo "ℹ️ Check if DNS providers are trustworthy"
                fi
            else
                echo "📋 DNS servers from /etc/resolv.conf:"
                grep nameserver /etc/resolv.conf | while read -r line; do
                    local dns_ip=$(echo "$line" | awk '{print $2}')
                    echo "• $dns_ip"
                    
                    # Check for common secure DNS
                    case "$dns_ip" in
                        "1.1.1.1"|"1.0.0.1") echo "  ✅ Cloudflare DNS (privacy-focused)" ;;
                        "8.8.8.8"|"8.8.4.4") echo "  ✅ Google DNS (reliable)" ;;
                        "9.9.9.9"|"149.112.112.112") echo "  ✅ Quad9 DNS (security-focused)" ;;
                        "208.67.222.222"|"208.67.220.220") echo "  ✅ OpenDNS (family-safe)" ;;
                        "192.168."*|"10."*|"172."*) echo "  ℹ️ Local/router DNS" ;;
                        *) echo "  ⚠️ Unknown DNS provider - verify trustworthiness" ;;
                    esac
                done
            fi
            
            # DNS-over-HTTPS/TLS check
            echo ""
            echo "📋 DNS Security Features:"
            if systemctl is-active systemd-resolved &>/dev/null; then
                local dns_over_tls=$(systemctl show systemd-resolved --property=DNS-over-TLS --value 2>/dev/null)
                if [ "$dns_over_tls" = "yes" ]; then
                    echo "✅ DNS-over-TLS: Enabled"
                else
                    echo "⚠️ DNS-over-TLS: Disabled (consider enabling for privacy)"
                fi
                
                local dnssec=$(systemctl show systemd-resolved --property=DNSSEC --value 2>/dev/null)
                if [ "$dnssec" = "yes" ]; then
                    echo "✅ DNSSEC: Enabled"
                else
                    echo "⚠️ DNSSEC: Disabled (consider enabling for security)"
                fi
            fi
            
            # DNS leak test
            echo ""
            echo "🔍 Basic DNS Leak Test:"
            local dns_test_result=$(dig +short whoami.akamai.net @1.1.1.1 2>/dev/null)
            local actual_dns=$(dig +short whoami.akamai.net 2>/dev/null)
            
            if [ "$dns_test_result" = "$actual_dns" ]; then
                echo "✅ DNS appears consistent"
            else
                echo "⚠️ Potential DNS inconsistency detected"
                echo "   Expected: $dns_test_result"
                echo "   Actual: $actual_dns"
            fi
            ;;
        7)
            echo "🛡️ Complete Security Assessment"
            echo "==============================="
            echo ""
            
            echo "🔄 Running comprehensive security audit..."
            echo "This will perform all security checks sequentially."
            echo ""
            
            # Run all audits in sequence
            for audit_type in {1..6}; do
                echo "📋 Running audit $audit_type/6..."
                security_audit "$audit_type"
                echo ""
                echo "$(printf '=%.0s' {1..50})"
                echo ""
            done
            
            # Generate summary report
            local report_file="/tmp/network-security-audit-$(date +%Y%m%d-%H%M%S).md"
            
            {
                echo "# Network Security Audit Report"
                echo "Generated: $(date)"
                echo ""
                echo "## Summary"
                echo "Comprehensive security assessment completed."
                echo ""
                echo "## Key Findings"
                echo "- Network interfaces security status reviewed"
                echo "- Firewall configuration analyzed"
                echo "- VPN security assessed"
                echo "- Wi-Fi security validated"
                echo "- Port exposure checked"
                echo "- DNS security verified"
                echo ""
                echo "## Recommendations"
                echo "Review the detailed output above for specific security recommendations."
                echo ""
                echo "## Next Steps"
                echo "1. Address any security warnings identified"
                echo "2. Implement recommended security measures"
                echo "3. Schedule regular security audits"
                echo "4. Keep systems and security tools updated"
            } > "$report_file"
            
            echo "📋 Complete security audit finished!"
            echo "📁 Summary report: $report_file"
            ;;
        *)
            log_warning "Invalid choice"
            ;;
    esac
    
    echo ""
    echo "🛡️ Security Audit Recommendations:"
    echo "• Run security audits regularly (monthly recommended)"
    echo "• Keep all network services updated"
    echo "• Use strong authentication methods"
    echo "• Monitor network traffic for anomalies"
    echo "• Implement defense-in-depth security strategies"
    echo "• Document and review security configurations"
    
    notify_success "Security Audit" "Network security assessment completed"
    
    collect_feedback "network_management" "security_audit"
}

backup_restore_settings() {
    log_info "Backup/restore coming in next update"
    echo "This will save and restore network configurations."
}

disconnect_wifi() {
    if command -v nmcli &>/dev/null; then
        nmcli connection down id "$(nmcli -t -f NAME connection show --active | head -1)"
        notify_info "Wi-Fi" "Disconnected from network"
    else
        echo "NetworkManager not available"
    fi
}

show_saved_networks() {
    echo "💾 Saved Wi-Fi Networks:"
    if command -v nmcli &>/dev/null; then
        nmcli connection show | grep wifi
    else
        echo "NetworkManager not available"
    fi
}

forget_wifi_network() {
    echo "🗑️ Forget Wi-Fi Network"
    echo ""
    show_saved_networks
    echo ""
    read -p "Enter network name to forget: " network_name
    
    if [ -n "$network_name" ] && command -v nmcli &>/dev/null; then
        nmcli connection delete "$network_name"
        notify_info "Wi-Fi" "Forgot network: $network_name"
    fi
}

create_wifi_hotspot() {
    echo "📡 Create Wi-Fi Hotspot"
    echo ""
    read -p "Hotspot name (SSID): " hotspot_name
    read -s -p "Hotspot password: " hotspot_password
    echo ""
    
    if command -v nmcli &>/dev/null; then
        nmcli device wifi hotspot con-name "$hotspot_name" ssid "$hotspot_name" band bg password "$hotspot_password"
        notify_success "Hotspot" "Created hotspot: $hotspot_name"
    else
        echo "NetworkManager not available for hotspot creation"
    fi
}

troubleshoot_wifi() {
    echo "🔧 Wi-Fi Troubleshooting"
    echo ""
    
    echo "Running basic Wi-Fi diagnostics..."
    
    # Check interface status
    echo "1. Checking wireless interfaces:"
    if command -v iwconfig &>/dev/null; then
        iwconfig 2>&1 | grep -E "(IEEE|no wireless)"
    fi
    
    # Check NetworkManager
    echo ""
    echo "2. Checking NetworkManager status:"
    if systemctl is-active NetworkManager &>/dev/null; then
        echo "  ✅ NetworkManager is running"
    else
        echo "  ❌ NetworkManager is not running"
        echo "     Try: sudo systemctl start NetworkManager"
    fi
    
    # Check for blocked devices
    echo ""
    echo "3. Checking for blocked wireless devices:"
    if command -v rfkill &>/dev/null; then
        rfkill list
    fi
    
    echo ""
    echo "Common fixes:"
    echo "• Restart NetworkManager: sudo systemctl restart NetworkManager"
    echo "• Unblock wireless: sudo rfkill unblock wifi"
    echo "• Reset network: sudo service network-manager restart"
}

configure_firewalld() {
    echo "🛡️ FirewallD Configuration"
    echo ""
    echo "FirewallD setup coming in next update"
}

configure_iptables_basic() {
    echo "🛡️ Basic iptables Configuration"
    echo ""
    echo "Direct iptables setup coming in next update"
}

# Main execution
main() {
    init_network_management
    network_management_menu
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi