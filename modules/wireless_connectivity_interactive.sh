#!/bin/bash
# LLM_CAPABILITY: auto
# 📡 WIRELESS CONNECTIVITY MANAGEMENT - Local connection protocols
# Wi-Fi, Bluetooth, mobile hotspot, and network profile management

# Enable error handling
set -euo pipefail

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || {
    echo "📡 WIRELESS CONNECTIVITY MANAGEMENT"
    echo "=================================="
}

source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/adaptive_learning.sh" 2>/dev/null || true

# Initialize adaptive learning for this module
init_adaptive_learning "wireless_connectivity" "$0" 2>/dev/null || true

show_banner "WIRELESS CONNECTIVITY" "Wi-Fi, Bluetooth & Hotspot" "WIRELESS"

echo "📡 Bill Sloth Wireless Connectivity Management"
echo "============================================="
echo ""
echo "📶 Manage all your wireless connections in one place:"
echo "   • Wi-Fi networks - scan, connect, troubleshoot"
echo "   • Bluetooth devices - pair phones, headphones, mice"
echo "   • Mobile hotspot - share your internet connection"
echo "   • Network profiles - save and manage connection settings"
echo ""
echo "🧠 Simple, ADHD-friendly wireless management!"
echo ""

# Detect and save wireless capabilities
detect_wireless_capabilities() {
    local capabilities_file="$HOME/.bill-sloth/wireless-capabilities"
    mkdir -p "$(dirname "$capabilities_file")"
    
    # Wi-Fi capabilities
    local wifi_tools=()
    
    if command -v nmcli &>/dev/null; then
        wifi_tools+=("networkmanager")
    fi
    
    if command -v iwctl &>/dev/null; then
        wifi_tools+=("iwd")
    fi
    
    if command -v wpa_cli &>/dev/null; then
        wifi_tools+=("wpa_supplicant")
    fi
    
    # Bluetooth capabilities
    local bluetooth_tools=()
    
    if command -v bluetoothctl &>/dev/null; then
        bluetooth_tools+=("bluetoothctl")
    fi
    
    if command -v hciconfig &>/dev/null; then
        bluetooth_tools+=("bluez")
    fi
    
    # Hotspot capabilities
    local hotspot_tools=()
    
    if command -v hostapd &>/dev/null; then
        hotspot_tools+=("hostapd")
    fi
    
    if command -v create_ap &>/dev/null; then
        hotspot_tools+=("create_ap")
    fi
    
    # Save capabilities
    cat > "$capabilities_file" << EOF
# Wireless Connectivity Capabilities
WIFI_TOOLS=(${wifi_tools[*]})
BLUETOOTH_TOOLS=(${bluetooth_tools[*]})
HOTSPOT_TOOLS=(${hotspot_tools[*]})

# Primary tools
PRIMARY_WIFI="${wifi_tools[0]:-none}"
PRIMARY_BLUETOOTH="${bluetooth_tools[0]:-none}"
PRIMARY_HOTSPOT="${hotspot_tools[0]:-none}"
EOF
    
    log_success "Detected wireless capabilities: Wi-Fi(${#wifi_tools[@]}), Bluetooth(${#bluetooth_tools[@]}), Hotspot(${#hotspot_tools[@]})"
}

# Main wireless connectivity menu
wireless_connectivity_menu() {
    while true; do
        print_separator "=" 50
        echo "📡 WIRELESS CONNECTIVITY MENU"
        print_separator "=" 50
        echo ""
        
        echo "📶 WIRELESS CONNECTIONS:"
        echo ""
        echo "  1) 📶 Wi-Fi Management         - Connect to wireless networks"
        echo "     💡 Scan, connect, save networks, troubleshoot issues"
        echo ""
        echo "  2) 🔵 Bluetooth Management     - Pair devices and transfer files"
        echo "     💡 Connect phones, headphones, mice, keyboards"
        echo ""
        echo "  3) 📱 Mobile Hotspot           - Share your internet connection"
        echo "     💡 Turn your computer into a Wi-Fi hotspot"
        echo ""
        echo "  4) 💾 Network Profiles         - Save and manage connections"
        echo "     💡 Quick switching between home, work, coffee shop"
        echo ""
        echo "  0) Exit Wireless Management"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select wireless option (0-4)" 30 "0")
        
        case "$choice" in
            1) manage_wifi ;;
            2) manage_bluetooth ;;
            3) setup_mobile_hotspot ;;
            4) manage_network_profiles ;;
            0) 
                echo "📡 Exiting Wireless Connectivity Management..."
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

# Wi-Fi Management
manage_wifi() {
    print_header "📶 WI-FI MANAGEMENT"
    
    echo "🌐 Manage your Wi-Fi connections:"
    echo "• Scan for available networks"
    echo "• Connect to new networks"
    echo "• Manage saved networks"
    echo "• Troubleshoot connection issues"
    echo ""
    
    # Check Wi-Fi status
    local wifi_status="❌ Not connected"
    local current_ssid=""
    
    if command -v nmcli &>/dev/null; then
        local connection_info=$(nmcli -t -f ACTIVE,SSID dev wifi | grep "^yes:")
        if [ -n "$connection_info" ]; then
            current_ssid=$(echo "$connection_info" | cut -d: -f2)
            wifi_status="✅ Connected to: $current_ssid"
        fi
    fi
    
    echo "📊 Current Wi-Fi Status: $wifi_status"
    echo ""
    
    echo "🔧 Wi-Fi Management Options:"
    echo "1) Scan for networks"
    echo "2) Connect to network"
    echo "3) Disconnect from network"
    echo "4) Show saved networks"
    echo "5) Forget network"
    echo "6) Show current connection"
    echo "7) Wi-Fi troubleshooting"
    echo "8) Create Wi-Fi profile"
    
    read -p "Select option (1-8): " wifi_option
    
    case "$wifi_option" in
        1) scan_wifi_networks ;;
        2) connect_wifi_network ;;
        3) disconnect_wifi ;;
        4) show_saved_networks ;;
        5) forget_wifi_network ;;
        6) show_current_connection ;;
        7) troubleshoot_wifi ;;
        8) create_wifi_profile ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Scan for Wi-Fi networks
scan_wifi_networks() {
    print_header "🔍 SCAN WI-FI NETWORKS"
    
    echo "🔍 Scanning for available Wi-Fi networks..."
    echo ""
    
    if command -v nmcli &>/dev/null; then
        # Refresh scan
        nmcli dev wifi rescan 2>/dev/null || true
        sleep 2
        
        echo "📡 Available Networks:"
        echo "===================="
        
        # Show networks with better formatting
        nmcli -f SSID,SIGNAL,SECURITY dev wifi | grep -v '^--' | head -20 | while read ssid signal security; do
            if [ "$ssid" != "SSID" ] && [ -n "$ssid" ]; then
                local signal_bar=""
                if [[ $signal =~ ^[0-9]+$ ]]; then
                    if [ $signal -ge 75 ]; then signal_bar="📶📶📶📶"
                    elif [ $signal -ge 50 ]; then signal_bar="📶📶📶"
                    elif [ $signal -ge 25 ]; then signal_bar="📶📶"
                    else signal_bar="📶"; fi
                fi
                
                local security_icon="🔓"
                if [[ $security == *"WPA"* ]]; then security_icon="🔒"; fi
                
                echo "$security_icon $ssid - $signal_bar ($signal%)"
            fi
        done
        
    elif command -v iwctl &>/dev/null; then
        echo "📡 Using iwd to scan networks..."
        iwctl station wlan0 scan
        sleep 3
        iwctl station wlan0 get-networks
        
    else
        log_error "No Wi-Fi management tool found"
        echo "Please install NetworkManager or iwd"
        return 1
    fi
    
    echo ""
    log_success "Network scan complete"
}

# Connect to Wi-Fi network
connect_wifi_network() {
    print_header "🔗 CONNECT TO WI-FI"
    
    echo "🌐 Connect to a Wi-Fi network:"
    echo ""
    
    # Show available networks first
    echo "📡 Available networks:"
    scan_wifi_networks
    
    echo ""
    read -p "📝 Enter network name (SSID): " ssid
    
    if [ -z "$ssid" ]; then
        log_warning "Network name cannot be empty"
        return 1
    fi
    
    # Check if network is open or secured
    local security_type=""
    if command -v nmcli &>/dev/null; then
        security_type=$(nmcli -f SSID,SECURITY dev wifi | grep "$ssid" | awk '{print $2}')
    fi
    
    if [[ $security_type == *"WPA"* ]] || [[ $security_type == *"WEP"* ]]; then
        read -s -p "🔒 Enter password: " password
        echo ""
        
        if command -v nmcli &>/dev/null; then
            echo "🔗 Connecting to $ssid..."
            if nmcli dev wifi connect "$ssid" password "$password"; then
                log_success "Successfully connected to $ssid"
                echo "📊 Connection details:"
                nmcli -f GENERAL.CONNECTION,IP4.ADDRESS,IP4.DNS dev show | grep -E "(CONNECTION|ADDRESS|DNS)"
            else
                log_error "Failed to connect to $ssid"
                echo "💡 Troubleshooting tips:"
                echo "• Check password is correct"
                echo "• Try moving closer to router"
                echo "• Check if network uses special authentication"
            fi
        else
            log_warning "NetworkManager not available"
        fi
    else
        # Open network
        echo "🔓 Connecting to open network: $ssid"
        if command -v nmcli &>/dev/null; then
            if nmcli dev wifi connect "$ssid"; then
                log_success "Successfully connected to $ssid"
            else
                log_error "Failed to connect to $ssid"
            fi
        fi
    fi
    
    notify_success "Wi-Fi" "Connection attempt completed"
}

# Disconnect from Wi-Fi
disconnect_wifi() {
    print_header "🔌 DISCONNECT WI-FI"
    
    echo "🔌 Disconnect from current Wi-Fi network"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        local current_connection=$(nmcli -t -f NAME,TYPE con show --active | grep wifi | cut -d: -f1)
        
        if [ -n "$current_connection" ]; then
            echo "📊 Currently connected to: $current_connection"
            read -p "Disconnect from this network? (y/n): " confirm
            
            if [[ $confirm =~ ^[Yy]$ ]]; then
                nmcli con down "$current_connection"
                log_success "Disconnected from Wi-Fi"
            else
                echo "Disconnect cancelled"
            fi
        else
            echo "ℹ️ Not currently connected to any Wi-Fi network"
        fi
    else
        echo "⚠️ NetworkManager not available"
    fi
}

# Show saved networks
show_saved_networks() {
    print_header "💾 SAVED WI-FI NETWORKS"
    
    echo "📋 Your saved Wi-Fi networks:"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        echo "Network Name                     | Auto-Connect | Last Used"
        echo "================================|==============|==========="
        
        nmcli -f NAME,AUTOCONNECT,TIMESTAMP-REAL con show | grep -v "^NAME" | grep -v "^--" | while read name autoconnect timestamp; do
            if [[ $name != *"ethernet"* ]] && [[ $name != *"docker"* ]] && [[ $name != *"bridge"* ]]; then
                printf "%-30s | %-12s | %s\n" "$name" "$autoconnect" "$timestamp"
            fi
        done
        
        echo ""
        echo "💡 Auto-Connect: Networks that connect automatically when in range"
        
    else
        echo "⚠️ NetworkManager not available"
    fi
}

# Forget Wi-Fi network
forget_wifi_network() {
    print_header "🗑️ FORGET WI-FI NETWORK"
    
    echo "🗑️ Remove a saved Wi-Fi network:"
    echo "This will delete the saved password and settings"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        echo "📋 Saved networks:"
        local networks=($(nmcli -t -f NAME con show | grep -v "ethernet\|docker\|bridge"))
        
        if [ ${#networks[@]} -eq 0 ]; then
            echo "ℹ️ No saved networks found"
            return 0
        fi
        
        for i in "${!networks[@]}"; do
            echo "$((i+1))) ${networks[i]}"
        done
        
        echo ""
        read -p "Select network to forget (1-${#networks[@]}): " net_choice
        
        if [ "$net_choice" -le "${#networks[@]}" ] && [ "$net_choice" -gt 0 ]; then
            local selected_network="${networks[$((net_choice-1))]}"
            
            echo "⚠️ This will permanently delete the connection: $selected_network"
            read -p "Continue? (type 'yes'): " confirm
            
            if [ "$confirm" = "yes" ]; then
                nmcli con delete "$selected_network"
                log_success "Network forgotten: $selected_network"
            else
                echo "Operation cancelled"
            fi
        else
            log_warning "Invalid selection"
        fi
    else
        echo "⚠️ NetworkManager not available"
    fi
}

# Show current connection
show_current_connection() {
    print_header "📊 CURRENT CONNECTION"
    
    echo "📊 Current network connection details:"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        # Active connections
        echo "🔗 Active Connections:"
        echo "===================="
        nmcli -f NAME,TYPE,DEVICE con show --active
        
        echo ""
        echo "📡 Wi-Fi Details:"
        echo "================"
        nmcli -f GENERAL.CONNECTION,GENERAL.STATE,IP4.ADDRESS,IP4.GATEWAY,IP4.DNS dev show | grep -E "(CONNECTION|STATE|ADDRESS|GATEWAY|DNS)"
        
        echo ""
        echo "📶 Signal Information:"
        echo "===================="
        nmcli -f SSID,SIGNAL,FREQ,CHANNEL dev wifi | head -5
        
    else
        echo "⚠️ NetworkManager not available"
        echo "📊 Basic connection info:"
        ip addr show | grep -E "(inet |UP|DOWN)"
    fi
}

# Wi-Fi troubleshooting
troubleshoot_wifi() {
    print_header "🔧 WI-FI TROUBLESHOOTING"
    
    echo "🔧 Wi-Fi connection troubleshooting:"
    echo ""
    
    echo "🔍 Running diagnostic tests..."
    echo ""
    
    # Check Wi-Fi adapter
    echo "1. 📡 Wi-Fi Adapter Status:"
    if command -v nmcli &>/dev/null; then
        local wifi_enabled=$(nmcli radio wifi)
        if [ "$wifi_enabled" = "enabled" ]; then
            echo "   ✅ Wi-Fi radio is enabled"
        else
            echo "   ❌ Wi-Fi radio is disabled"
            read -p "   🔧 Enable Wi-Fi now? (y/n): " enable_wifi
            if [[ $enable_wifi =~ ^[Yy]$ ]]; then
                nmcli radio wifi on
                echo "   ✅ Wi-Fi enabled"
            fi
        fi
    fi
    
    # Check network interface
    echo ""
    echo "2. 🔌 Network Interface Status:"
    local wifi_interface=$(ip link show | grep -E "wlan|wlp" | head -1 | cut -d: -f2 | tr -d ' ')
    if [ -n "$wifi_interface" ]; then
        echo "   ✅ Wi-Fi interface found: $wifi_interface"
        local interface_status=$(ip link show "$wifi_interface" | grep -o "state [A-Z]*" | cut -d' ' -f2)
        echo "   📊 Interface state: $interface_status"
    else
        echo "   ❌ No Wi-Fi interface found"
    fi
    
    # Check drivers
    echo ""
    echo "3. 🔧 Driver Status:"
    if lsmod | grep -q "iwlwifi\|ath9k\|rtl\|brcm"; then
        echo "   ✅ Wi-Fi drivers loaded"
        lsmod | grep -E "iwlwifi|ath9k|rtl|brcm" | head -3
    else
        echo "   ⚠️ Wi-Fi drivers may not be loaded"
    fi
    
    # Test connectivity
    echo ""
    echo "4. 🌐 Connectivity Test:"
    if ping -c 1 8.8.8.8 &>/dev/null; then
        echo "   ✅ Internet connectivity working"
    else
        echo "   ❌ No internet connectivity"
        
        # Test local network
        local gateway=$(ip route | grep default | awk '{print $3}' | head -1)
        if [ -n "$gateway" ]; then
            if ping -c 1 "$gateway" &>/dev/null; then
                echo "   ✅ Local network connectivity OK"
                echo "   💡 Issue may be with DNS or internet routing"
            else
                echo "   ❌ Cannot reach local gateway"
                echo "   💡 Wi-Fi connection or router issue"
            fi
        fi
    fi
    
    # Common solutions
    echo ""
    echo "🔧 Common Solutions:"
    echo "=================="
    echo "1) Restart network service: sudo systemctl restart NetworkManager"
    echo "2) Reset network interface: sudo ip link set $wifi_interface down && sudo ip link set $wifi_interface up"
    echo "3) Forget and reconnect to network"
    echo "4) Check router settings and passwords"
    echo "5) Move closer to router to test signal strength"
    echo "6) Restart router/modem"
    echo ""
    
    read -p "🔧 Try restarting NetworkManager? (y/n): " restart_nm
    if [[ $restart_nm =~ ^[Yy]$ ]]; then
        echo "🔄 Restarting NetworkManager..."
        sudo systemctl restart NetworkManager
        sleep 3
        echo "✅ NetworkManager restarted"
    fi
    
    notify_success "Wi-Fi Troubleshooting" "Diagnostic tests completed"
}

# Create Wi-Fi profile
create_wifi_profile() {
    print_header "💾 CREATE WI-FI PROFILE"
    
    echo "💾 Create a Wi-Fi connection profile:"
    echo "• Save network settings for easy switching"
    echo "• Configure advanced options"
    echo "• Set auto-connect preferences"
    echo ""
    
    read -p "📝 Profile name: " profile_name
    read -p "📡 Network SSID: " ssid
    
    echo ""
    echo "🔒 Security type:"
    echo "1) Open (no password)"
    echo "2) WPA/WPA2 Personal"
    echo "3) WPA/WPA2 Enterprise"
    
    read -p "Select security type (1-3): " security_type
    
    local password=""
    if [ "$security_type" = "2" ]; then
        read -s -p "🔒 Password: " password
        echo ""
    fi
    
    echo ""
    echo "⚙️ Advanced options:"
    read -p "🔄 Auto-connect when available? (y/n): " autoconnect
    read -p "🏠 Connect only to this network at home? (y/n): " home_only
    
    if command -v nmcli &>/dev/null; then
        local cmd="nmcli con add type wifi con-name '$profile_name' ssid '$ssid'"
        
        if [ "$security_type" = "2" ]; then
            cmd="$cmd wifi-sec.key-mgmt wpa-psk wifi-sec.psk '$password'"
        fi
        
        if [[ $autoconnect =~ ^[Yy]$ ]]; then
            cmd="$cmd connection.autoconnect yes"
        else
            cmd="$cmd connection.autoconnect no"
        fi
        
        echo "💾 Creating Wi-Fi profile..."
        eval "$cmd"
        
        if [ $? -eq 0 ]; then
            log_success "Wi-Fi profile created: $profile_name"
            echo "📊 Profile details saved"
        else
            log_error "Failed to create Wi-Fi profile"
        fi
    else
        echo "⚠️ NetworkManager not available for profile creation"
    fi
    
    notify_success "Wi-Fi Profile" "Profile creation completed"
}

# Bluetooth Management
manage_bluetooth() {
    print_header "🔵 BLUETOOTH MANAGEMENT"
    
    echo "🔵 Manage Bluetooth devices and connections:"
    echo "• Pair phones, headphones, keyboards, mice"
    echo "• Transfer files between devices"
    echo "• Manage paired devices"
    echo "• Troubleshoot connection issues"
    echo ""
    
    # Check Bluetooth status
    local bt_status="❌ Disabled"
    if command -v bluetoothctl &>/dev/null; then
        if bluetoothctl show | grep -q "Powered: yes"; then
            bt_status="✅ Enabled"
        fi
    fi
    
    echo "📊 Bluetooth Status: $bt_status"
    echo ""
    
    echo "🔧 Bluetooth Management Options:"
    echo "1) Enable/Disable Bluetooth"
    echo "2) Scan for devices"
    echo "3) Pair new device"
    echo "4) Show paired devices"
    echo "5) Connect to device"
    echo "6) Remove paired device"
    echo "7) Send file to device"
    echo "8) Bluetooth troubleshooting"
    
    read -p "Select option (1-8): " bt_option
    
    case "$bt_option" in
        1) toggle_bluetooth ;;
        2) scan_bluetooth_devices ;;
        3) pair_bluetooth_device ;;
        4) show_paired_devices ;;
        5) connect_bluetooth_device ;;
        6) remove_bluetooth_device ;;
        7) send_bluetooth_file ;;
        8) troubleshoot_bluetooth ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Toggle Bluetooth
toggle_bluetooth() {
    print_header "🔵 BLUETOOTH TOGGLE"
    
    if command -v bluetoothctl &>/dev/null; then
        local bt_powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
        
        if [ "$bt_powered" = "yes" ]; then
            echo "🔵 Bluetooth is currently enabled"
            read -p "Disable Bluetooth? (y/n): " disable_bt
            if [[ $disable_bt =~ ^[Yy]$ ]]; then
                bluetoothctl power off
                log_success "Bluetooth disabled"
            fi
        else
            echo "❌ Bluetooth is currently disabled"
            read -p "Enable Bluetooth? (y/n): " enable_bt
            if [[ $enable_bt =~ ^[Yy]$ ]]; then
                bluetoothctl power on
                bluetoothctl discoverable on
                log_success "Bluetooth enabled and discoverable"
            fi
        fi
    else
        log_error "Bluetoothctl not found - install bluez package"
    fi
}

# Scan for Bluetooth devices
scan_bluetooth_devices() {
    print_header "🔍 SCAN BLUETOOTH DEVICES"
    
    echo "🔍 Scanning for nearby Bluetooth devices..."
    echo ""
    
    if command -v bluetoothctl &>/dev/null; then
        # Enable Bluetooth if not enabled
        bluetoothctl power on
        bluetoothctl discoverable on
        
        echo "📡 Scanning for 15 seconds..."
        bluetoothctl scan on &
        local scan_pid=$!
        
        sleep 15
        kill $scan_pid 2>/dev/null || true
        bluetoothctl scan off
        
        echo ""
        echo "📱 Discovered devices:"
        echo "===================="
        bluetoothctl devices | while read device_line; do
            local mac=$(echo "$device_line" | awk '{print $2}')
            local name=$(echo "$device_line" | cut -d' ' -f3-)
            local device_type="📱"
            
            # Try to determine device type
            if [[ $name == *"Headphone"* ]] || [[ $name == *"Headset"* ]]; then
                device_type="🎧"
            elif [[ $name == *"Mouse"* ]]; then
                device_type="🖱️"
            elif [[ $name == *"Keyboard"* ]]; then
                device_type="⌨️"
            elif [[ $name == *"Phone"* ]] || [[ $name == *"Android"* ]] || [[ $name == *"iPhone"* ]]; then
                device_type="📱"
            fi
            
            echo "$device_type $name ($mac)"
        done
        
        echo ""
        log_success "Scan complete - devices listed above"
        
    else
        log_error "Bluetoothctl not available"
    fi
}

# Pair Bluetooth device
pair_bluetooth_device() {
    print_header "🔗 PAIR BLUETOOTH DEVICE"
    
    echo "🔗 Pair a new Bluetooth device:"
    echo ""
    
    # Scan first
    scan_bluetooth_devices
    
    echo ""
    read -p "📝 Enter device MAC address (XX:XX:XX:XX:XX:XX): " device_mac
    
    if [[ ! $device_mac =~ ^[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}:[0-9A-Fa-f]{2}$ ]]; then
        log_error "Invalid MAC address format"
        return 1
    fi
    
    if command -v bluetoothctl &>/dev/null; then
        echo "🔗 Pairing with device $device_mac..."
        
        # Make sure Bluetooth is on
        bluetoothctl power on
        bluetoothctl discoverable on
        bluetoothctl pairable on
        
        # Attempt pairing
        bluetoothctl pair "$device_mac"
        
        sleep 3
        
        # Trust the device
        bluetoothctl trust "$device_mac"
        
        # Try to connect
        bluetoothctl connect "$device_mac"
        
        if bluetoothctl info "$device_mac" | grep -q "Connected: yes"; then
            log_success "Successfully paired and connected to device"
            
            # Show device info
            echo "📊 Device information:"
            bluetoothctl info "$device_mac" | grep -E "(Name|Alias|Connected|Trusted|Paired)"
        else
            log_warning "Device paired but connection failed"
            echo "💡 Try connecting manually from the device list"
        fi
        
    else
        log_error "Bluetoothctl not available"
    fi
    
    notify_success "Bluetooth Pairing" "Pairing attempt completed"
}

# Show paired devices
show_paired_devices() {
    print_header "📋 PAIRED BLUETOOTH DEVICES"
    
    echo "📋 Your paired Bluetooth devices:"
    echo ""
    
    if command -v bluetoothctl &>/dev/null; then
        echo "Device Name                      | MAC Address       | Status"
        echo "================================|==================|========"
        
        bluetoothctl devices | while read device_line; do
            local mac=$(echo "$device_line" | awk '{print $2}')
            local name=$(echo "$device_line" | cut -d' ' -f3-)
            
            local status="❌ Disconnected"
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                status="✅ Connected"
            fi
            
            printf "%-30s | %-17s | %s\n" "$name" "$mac" "$status"
        done
        
        echo ""
        echo "💡 Connected devices can be used immediately"
        echo "💡 Disconnected devices need to be connected first"
        
    else
        log_error "Bluetoothctl not available"
    fi
}

# Connect to Bluetooth device
connect_bluetooth_device() {
    print_header "🔗 CONNECT BLUETOOTH DEVICE"
    
    echo "🔗 Connect to a paired Bluetooth device:"
    echo ""
    
    if command -v bluetoothctl &>/dev/null; then
        local devices=($(bluetoothctl devices | awk '{print $2}'))
        local device_names=($(bluetoothctl devices | cut -d' ' -f3-))
        
        if [ ${#devices[@]} -eq 0 ]; then
            echo "ℹ️ No paired devices found"
            echo "Please pair a device first (option 3)"
            return 0
        fi
        
        echo "📋 Paired devices:"
        for i in "${!devices[@]}"; do
            local mac="${devices[i]}"
            local name="${device_names[i]}"
            local status="❌ Disconnected"
            
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                status="✅ Connected"
            fi
            
            echo "$((i+1))) $name - $status"
        done
        
        echo ""
        read -p "Select device to connect (1-${#devices[@]}): " device_choice
        
        if [ "$device_choice" -le "${#devices[@]}" ] && [ "$device_choice" -gt 0 ]; then
            local selected_mac="${devices[$((device_choice-1))]}"
            local selected_name="${device_names[$((device_choice-1))]}"
            
            echo "🔗 Connecting to $selected_name..."
            
            if bluetoothctl connect "$selected_mac"; then
                log_success "Successfully connected to $selected_name"
            else
                log_error "Failed to connect to $selected_name"
                echo "💡 Make sure the device is turned on and in range"
            fi
        else
            log_warning "Invalid selection"
        fi
        
    else
        log_error "Bluetoothctl not available"
    fi
}

# Remove Bluetooth device
remove_bluetooth_device() {
    print_header "🗑️ REMOVE BLUETOOTH DEVICE"
    
    echo "🗑️ Remove a paired Bluetooth device:"
    echo "This will unpair the device permanently"
    echo ""
    
    if command -v bluetoothctl &>/dev/null; then
        local devices=($(bluetoothctl devices | awk '{print $2}'))
        local device_names=($(bluetoothctl devices | cut -d' ' -f3-))
        
        if [ ${#devices[@]} -eq 0 ]; then
            echo "ℹ️ No paired devices found"
            return 0
        fi
        
        echo "📋 Paired devices:"
        for i in "${!devices[@]}"; do
            echo "$((i+1))) ${device_names[i]}"
        done
        
        echo ""
        read -p "Select device to remove (1-${#devices[@]}): " device_choice
        
        if [ "$device_choice" -le "${#devices[@]}" ] && [ "$device_choice" -gt 0 ]; then
            local selected_mac="${devices[$((device_choice-1))]}"
            local selected_name="${device_names[$((device_choice-1))]}"
            
            echo "⚠️ This will permanently remove: $selected_name"
            read -p "Continue? (type 'yes'): " confirm
            
            if [ "$confirm" = "yes" ]; then
                bluetoothctl disconnect "$selected_mac" 2>/dev/null || true
                bluetoothctl untrust "$selected_mac"
                bluetoothctl remove "$selected_mac"
                
                log_success "Device removed: $selected_name"
            else
                echo "Operation cancelled"
            fi
        else
            log_warning "Invalid selection"
        fi
        
    else
        log_error "Bluetoothctl not available"
    fi
}

# Send file via Bluetooth
send_bluetooth_file() {
    print_header "📤 SEND FILE VIA BLUETOOTH"
    
    echo "📤 Send file to Bluetooth device:"
    echo ""
    
    read -p "📁 Enter file path to send: " file_path
    
    if [ ! -f "$file_path" ]; then
        log_error "File not found: $file_path"
        return 1
    fi
    
    # Show connected devices
    if command -v bluetoothctl &>/dev/null; then
        local connected_devices=($(bluetoothctl devices | awk '{print $2}' | while read mac; do
            if bluetoothctl info "$mac" | grep -q "Connected: yes"; then
                echo "$mac"
            fi
        done))
        
        if [ ${#connected_devices[@]} -eq 0 ]; then
            echo "⚠️ No connected Bluetooth devices found"
            echo "Please connect to a device first"
            return 1
        fi
        
        echo "📋 Connected devices:"
        for i in "${!connected_devices[@]}"; do
            local mac="${connected_devices[i]}"
            local name=$(bluetoothctl info "$mac" | grep "Name:" | cut -d: -f2- | sed 's/^ *//')
            echo "$((i+1))) $name ($mac)"
        done
        
        echo ""
        read -p "Select device (1-${#connected_devices[@]}): " device_choice
        
        if [ "$device_choice" -le "${#connected_devices[@]}" ] && [ "$device_choice" -gt 0 ]; then
            local target_mac="${connected_devices[$((device_choice-1))]}"
            
            echo "📤 Sending file to device..."
            
            if command -v bluetooth-sendto &>/dev/null; then
                bluetooth-sendto --device="$target_mac" "$file_path"
            elif command -v obexftp &>/dev/null; then
                obexftp -b "$target_mac" -p "$file_path"
            else
                log_error "No Bluetooth file transfer tool found"
                echo "Install bluetooth-sendto or obexftp package"
                return 1
            fi
            
            log_success "File transfer initiated"
            
        else
            log_warning "Invalid selection"
        fi
        
    else
        log_error "Bluetoothctl not available"
    fi
}

# Bluetooth troubleshooting
troubleshoot_bluetooth() {
    print_header "🔧 BLUETOOTH TROUBLESHOOTING"
    
    echo "🔧 Bluetooth connection troubleshooting:"
    echo ""
    
    echo "🔍 Running diagnostic tests..."
    echo ""
    
    # Check Bluetooth service
    echo "1. 📡 Bluetooth Service Status:"
    if systemctl is-active bluetooth &>/dev/null; then
        echo "   ✅ Bluetooth service is running"
    else
        echo "   ❌ Bluetooth service is not running"
        read -p "   🔧 Start Bluetooth service? (y/n): " start_bt
        if [[ $start_bt =~ ^[Yy]$ ]]; then
            sudo systemctl start bluetooth
            echo "   ✅ Bluetooth service started"
        fi
    fi
    
    # Check Bluetooth adapter
    echo ""
    echo "2. 🔌 Bluetooth Adapter Status:"
    if command -v hciconfig &>/dev/null; then
        local hci_status=$(hciconfig 2>/dev/null)
        if [ -n "$hci_status" ]; then
            echo "   ✅ Bluetooth adapter detected"
            echo "$hci_status" | head -5
        else
            echo "   ❌ No Bluetooth adapter found"
        fi
    else
        echo "   ⚠️ hciconfig not available (install bluez-utils)"
    fi
    
    # Check power status
    echo ""
    echo "3. 🔋 Power Status:"
    if command -v bluetoothctl &>/dev/null; then
        local powered=$(bluetoothctl show | grep "Powered:" | awk '{print $2}')
        if [ "$powered" = "yes" ]; then
            echo "   ✅ Bluetooth is powered on"
        else
            echo "   ❌ Bluetooth is powered off"
        fi
        
        local discoverable=$(bluetoothctl show | grep "Discoverable:" | awk '{print $2}')
        echo "   📡 Discoverable: $discoverable"
        
        local pairable=$(bluetoothctl show | grep "Pairable:" | awk '{print $2}')
        echo "   🔗 Pairable: $pairable"
    fi
    
    # Check kernel modules
    echo ""
    echo "4. 🔧 Kernel Modules:"
    if lsmod | grep -q "bluetooth"; then
        echo "   ✅ Bluetooth kernel modules loaded"
        lsmod | grep bluetooth | head -3
    else
        echo "   ❌ Bluetooth kernel modules not loaded"
    fi
    
    # Common solutions
    echo ""
    echo "🔧 Common Solutions:"
    echo "=================="
    echo "1) Restart Bluetooth service: sudo systemctl restart bluetooth"
    echo "2) Reset Bluetooth adapter: sudo hciconfig hci0 reset"
    echo "3) Clear Bluetooth cache: sudo rm -rf /var/lib/bluetooth/*/cache"
    echo "4) Reload kernel modules: sudo modprobe -r btusb && sudo modprobe btusb"
    echo "5) Check device compatibility and drivers"
    echo ""
    
    read -p "🔧 Try restarting Bluetooth service? (y/n): " restart_bt
    if [[ $restart_bt =~ ^[Yy]$ ]]; then
        echo "🔄 Restarting Bluetooth service..."
        sudo systemctl restart bluetooth
        sleep 3
        echo "✅ Bluetooth service restarted"
    fi
    
    notify_success "Bluetooth Troubleshooting" "Diagnostic tests completed"
}

# Mobile Hotspot Setup
setup_mobile_hotspot() {
    print_header "📱 MOBILE HOTSPOT SETUP"
    
    echo "📱 Turn your computer into a Wi-Fi hotspot:"
    echo "• Share your internet connection with other devices"
    echo "• Connect phones, tablets, other computers"
    echo "• Create temporary networks for events or travel"
    echo ""
    
    echo "🔧 Hotspot Setup Options:"
    echo "1) Create new hotspot"
    echo "2) Start existing hotspot"
    echo "3) Stop hotspot"
    echo "4) Show hotspot status"
    echo "5) Remove hotspot configuration"
    
    read -p "Select option (1-5): " hotspot_option
    
    case "$hotspot_option" in
        1) create_hotspot ;;
        2) start_hotspot ;;
        3) stop_hotspot ;;
        4) show_hotspot_status ;;
        5) remove_hotspot ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Create hotspot
create_hotspot() {
    print_header "🆕 CREATE HOTSPOT"
    
    echo "🆕 Create a new Wi-Fi hotspot:"
    echo ""
    
    read -p "📡 Hotspot name (SSID): " hotspot_ssid
    read -s -p "🔒 Password (min 8 characters): " hotspot_password
    echo ""
    
    if [ ${#hotspot_password} -lt 8 ]; then
        log_error "Password must be at least 8 characters"
        return 1
    fi
    
    echo ""
    echo "🌐 Internet sharing options:"
    echo "1) Share ethernet connection"
    echo "2) Share Wi-Fi connection"
    echo "3) Share mobile data connection"
    
    read -p "Select connection to share (1-3): " share_option
    
    local connection_to_share=""
    case "$share_option" in
        1) connection_to_share="ethernet" ;;
        2) connection_to_share="wifi" ;;
        3) connection_to_share="mobile" ;;
        *) log_warning "Invalid option" && return 1 ;;
    esac
    
    if command -v nmcli &>/dev/null; then
        echo "📱 Creating hotspot configuration..."
        
        # Create hotspot profile
        nmcli con add type wifi ifname '*' con-name "Hotspot-$hotspot_ssid" autoconnect no ssid "$hotspot_ssid"
        nmcli con modify "Hotspot-$hotspot_ssid" 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
        nmcli con modify "Hotspot-$hotspot_ssid" wifi-sec.key-mgmt wpa-psk wifi-sec.psk "$hotspot_password"
        
        log_success "Hotspot configuration created: $hotspot_ssid"
        
        echo ""
        read -p "🚀 Start hotspot now? (y/n): " start_now
        if [[ $start_now =~ ^[Yy]$ ]]; then
            nmcli con up "Hotspot-$hotspot_ssid"
            if [ $? -eq 0 ]; then
                log_success "Hotspot started successfully"
                echo "📊 Hotspot details:"
                echo "   📡 Name: $hotspot_ssid"
                echo "   🔒 Password: $hotspot_password"
                echo "   📱 Devices can now connect to this network"
            else
                log_error "Failed to start hotspot"
            fi
        fi
        
    elif command -v create_ap &>/dev/null; then
        echo "📱 Using create_ap to start hotspot..."
        
        # Find network interfaces
        local wifi_interface=$(ip link show | grep -E "wlan|wlp" | head -1 | cut -d: -f2 | tr -d ' ')
        local internet_interface=$(ip route | grep default | awk '{print $5}' | head -1)
        
        if [ -z "$wifi_interface" ]; then
            log_error "No Wi-Fi interface found"
            return 1
        fi
        
        echo "🚀 Starting hotspot with create_ap..."
        sudo create_ap "$wifi_interface" "$internet_interface" "$hotspot_ssid" "$hotspot_password" &
        
        log_success "Hotspot started with create_ap"
        
    else
        log_error "No hotspot tool available"
        echo "Install NetworkManager or create_ap package"
        return 1
    fi
    
    notify_success "Mobile Hotspot" "Hotspot configuration completed"
}

# Start hotspot
start_hotspot() {
    print_header "🚀 START HOTSPOT"
    
    if command -v nmcli &>/dev/null; then
        local hotspots=($(nmcli con show | grep -E "Hotspot|hotspot" | awk '{print $1}'))
        
        if [ ${#hotspots[@]} -eq 0 ]; then
            echo "ℹ️ No hotspot configurations found"
            echo "Create a new hotspot first (option 1)"
            return 0
        fi
        
        echo "📋 Available hotspot configurations:"
        for i in "${!hotspots[@]}"; do
            echo "$((i+1))) ${hotspots[i]}"
        done
        
        echo ""
        read -p "Select hotspot to start (1-${#hotspots[@]}): " hotspot_choice
        
        if [ "$hotspot_choice" -le "${#hotspots[@]}" ] && [ "$hotspot_choice" -gt 0 ]; then
            local selected_hotspot="${hotspots[$((hotspot_choice-1))]}"
            
            echo "🚀 Starting hotspot: $selected_hotspot"
            nmcli con up "$selected_hotspot"
            
            if [ $? -eq 0 ]; then
                log_success "Hotspot started successfully"
                echo "📱 Devices can now connect to your hotspot"
            else
                log_error "Failed to start hotspot"
            fi
        else
            log_warning "Invalid selection"
        fi
        
    else
        log_error "NetworkManager not available"
    fi
}

# Stop hotspot
stop_hotspot() {
    print_header "🛑 STOP HOTSPOT"
    
    if command -v nmcli &>/dev/null; then
        local active_hotspots=($(nmcli con show --active | grep -E "Hotspot|hotspot" | awk '{print $1}'))
        
        if [ ${#active_hotspots[@]} -eq 0 ]; then
            echo "ℹ️ No active hotspots found"
            return 0
        fi
        
        echo "📋 Active hotspots:"
        for hotspot in "${active_hotspots[@]}"; do
            echo "🔥 $hotspot"
        done
        
        echo ""
        read -p "Stop all hotspots? (y/n): " stop_all
        if [[ $stop_all =~ ^[Yy]$ ]]; then
            for hotspot in "${active_hotspots[@]}"; do
                nmcli con down "$hotspot"
                echo "🛑 Stopped: $hotspot"
            done
            log_success "All hotspots stopped"
        fi
        
    else
        log_error "NetworkManager not available"
    fi
}

# Show hotspot status
show_hotspot_status() {
    print_header "📊 HOTSPOT STATUS"
    
    echo "📊 Current hotspot status:"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        echo "🔥 Hotspot Connections:"
        echo "====================="
        nmcli con show | grep -E "Hotspot|hotspot" | while read con_line; do
            local name=$(echo "$con_line" | awk '{print $1}')
            local status="❌ Inactive"
            
            if nmcli con show --active | grep -q "$name"; then
                status="✅ Active"
            fi
            
            echo "$name - $status"
        done
        
        echo ""
        echo "📱 Connected Devices:"
        echo "==================="
        
        # Show DHCP leases if available
        if [ -f /var/lib/dhcp/dhcpd.leases ]; then
            echo "🔍 DHCP lease information:"
            sudo grep -E "lease|client-hostname|hardware ethernet" /var/lib/dhcp/dhcpd.leases | tail -10
        else
            echo "ℹ️ DHCP lease information not available"
        fi
        
        # Show network statistics
        echo ""
        echo "📈 Network Statistics:"
        echo "===================="
        ip -s link show | grep -E "ap|wlan" -A 3
        
    else
        echo "⚠️ NetworkManager not available"
    fi
}

# Remove hotspot
remove_hotspot() {
    print_header "🗑️ REMOVE HOTSPOT"
    
    echo "🗑️ Remove hotspot configuration:"
    echo "This will permanently delete the hotspot settings"
    echo ""
    
    if command -v nmcli &>/dev/null; then
        local hotspots=($(nmcli con show | grep -E "Hotspot|hotspot" | awk '{print $1}'))
        
        if [ ${#hotspots[@]} -eq 0 ]; then
            echo "ℹ️ No hotspot configurations found"
            return 0
        fi
        
        echo "📋 Hotspot configurations:"
        for i in "${!hotspots[@]}"; do
            echo "$((i+1))) ${hotspots[i]}"
        done
        
        echo ""
        read -p "Select hotspot to remove (1-${#hotspots[@]}): " hotspot_choice
        
        if [ "$hotspot_choice" -le "${#hotspots[@]}" ] && [ "$hotspot_choice" -gt 0 ]; then
            local selected_hotspot="${hotspots[$((hotspot_choice-1))]}"
            
            echo "⚠️ This will permanently delete: $selected_hotspot"
            read -p "Continue? (type 'yes'): " confirm
            
            if [ "$confirm" = "yes" ]; then
                nmcli con down "$selected_hotspot" 2>/dev/null || true
                nmcli con delete "$selected_hotspot"
                
                log_success "Hotspot configuration removed: $selected_hotspot"
            else
                echo "Operation cancelled"
            fi
        else
            log_warning "Invalid selection"
        fi
        
    else
        log_error "NetworkManager not available"
    fi
}

# Network Profiles Management
manage_network_profiles() {
    print_header "💾 NETWORK PROFILES MANAGEMENT"
    
    echo "💾 Manage network connection profiles:"
    echo "• Save current network settings"
    echo "• Switch between work, home, travel profiles"
    echo "• Backup and restore network configurations"
    echo ""
    
    echo "🔧 Profile Management Options:"
    echo "1) Create new profile from current settings"
    echo "2) Load existing profile"
    echo "3) List all profiles"
    echo "4) Export profile to file"
    echo "5) Import profile from file"
    echo "6) Delete profile"
    
    read -p "Select option (1-6): " profile_option
    
    case "$profile_option" in
        1) create_network_profile ;;
        2) load_network_profile ;;
        3) list_network_profiles ;;
        4) export_network_profile ;;
        5) import_network_profile ;;
        6) delete_network_profile ;;
        *) log_warning "Invalid option" ;;
    esac
}

# Create network profile
create_network_profile() {
    print_header "💾 CREATE NETWORK PROFILE"
    
    echo "💾 Create a network profile from current settings:"
    echo ""
    
    read -p "📝 Profile name (e.g., Home, Work, Coffee-Shop): " profile_name
    
    if [ -z "$profile_name" ]; then
        log_error "Profile name cannot be empty"
        return 1
    fi
    
    # Create profiles directory
    mkdir -p ~/.bill-sloth/network-profiles
    
    local profile_file="$HOME/.bill-sloth/network-profiles/${profile_name}.profile"
    
    echo "💾 Saving current network configuration..."
    
    {
        echo "# Network Profile: $profile_name"
        echo "# Created: $(date)"
        echo ""
        
        echo "# Network Connections"
        if command -v nmcli &>/dev/null; then
            nmcli con show
        fi
        
        echo ""
        echo "# Active Connections"
        if command -v nmcli &>/dev/null; then
            nmcli con show --active
        fi
        
        echo ""
        echo "# Network Interfaces"
        ip addr show
        
        echo ""
        echo "# Routing Table"
        ip route show
        
        echo ""
        echo "# DNS Configuration"
        cat /etc/resolv.conf 2>/dev/null || echo "DNS config not accessible"
        
    } > "$profile_file"
    
    log_success "Network profile created: $profile_name"
    echo "📁 Profile saved to: $profile_file"
    
    notify_success "Network Profile" "Profile created: $profile_name"
}

# Load network profile
load_network_profile() {
    print_header "📂 LOAD NETWORK PROFILE"
    
    local profiles_dir="$HOME/.bill-sloth/network-profiles"
    
    if [ ! -d "$profiles_dir" ]; then
        echo "ℹ️ No network profiles found"
        echo "Create a profile first (option 1)"
        return 0
    fi
    
    local profiles=($(find "$profiles_dir" -name "*.profile" -exec basename {} .profile \;))
    
    if [ ${#profiles[@]} -eq 0 ]; then
        echo "ℹ️ No network profiles found"
        return 0
    fi
    
    echo "📋 Available network profiles:"
    for i in "${!profiles[@]}"; do
        local profile_file="$profiles_dir/${profiles[i]}.profile"
        local created_date=$(grep "# Created:" "$profile_file" | cut -d: -f2-)
        echo "$((i+1))) ${profiles[i]} (Created:$created_date)"
    done
    
    echo ""
    read -p "Select profile to load (1-${#profiles[@]}): " profile_choice
    
    if [ "$profile_choice" -le "${#profiles[@]}" ] && [ "$profile_choice" -gt 0 ]; then
        local selected_profile="${profiles[$((profile_choice-1))]}"
        local profile_file="$profiles_dir/${selected_profile}.profile"
        
        echo "📂 Loading profile: $selected_profile"
        echo ""
        echo "⚠️ This is currently a display-only feature"
        echo "📋 Profile contents:"
        echo ""
        cat "$profile_file"
        
        echo ""
        echo "💡 To fully implement profile loading:"
        echo "• Disconnect current connections"
        echo "• Apply saved network configurations"
        echo "• Reconnect to stored networks"
        
    else
        log_warning "Invalid selection"
    fi
}

# List network profiles
list_network_profiles() {
    print_header "📋 LIST NETWORK PROFILES"
    
    local profiles_dir="$HOME/.bill-sloth/network-profiles"
    
    if [ ! -d "$profiles_dir" ]; then
        echo "ℹ️ No network profiles directory found"
        return 0
    fi
    
    echo "📋 Network profiles:"
    echo ""
    
    find "$profiles_dir" -name "*.profile" | while read profile_file; do
        local profile_name=$(basename "$profile_file" .profile)
        local created_date=$(grep "# Created:" "$profile_file" | cut -d: -f2-)
        local file_size=$(du -h "$profile_file" | cut -f1)
        
        echo "📄 $profile_name"
        echo "   📅 Created:$created_date"
        echo "   📊 Size: $file_size"
        echo ""
    done
}

# Export network profile
export_network_profile() {
    print_header "📤 EXPORT NETWORK PROFILE"
    
    local profiles_dir="$HOME/.bill-sloth/network-profiles"
    
    if [ ! -d "$profiles_dir" ]; then
        echo "ℹ️ No network profiles found"
        return 0
    fi
    
    local profiles=($(find "$profiles_dir" -name "*.profile" -exec basename {} .profile \;))
    
    if [ ${#profiles[@]} -eq 0 ]; then
        echo "ℹ️ No network profiles found"
        return 0
    fi
    
    echo "📋 Available profiles to export:"
    for i in "${!profiles[@]}"; do
        echo "$((i+1))) ${profiles[i]}"
    done
    
    echo ""
    read -p "Select profile to export (1-${#profiles[@]}): " profile_choice
    
    if [ "$profile_choice" -le "${#profiles[@]}" ] && [ "$profile_choice" -gt 0 ]; then
        local selected_profile="${profiles[$((profile_choice-1))]}"
        
        read -p "📁 Export location (default: ~/Downloads): " export_path
        export_path=${export_path:-"$HOME/Downloads"}
        
        local source_file="$profiles_dir/${selected_profile}.profile"
        local target_file="$export_path/${selected_profile}_network_profile.txt"
        
        cp "$source_file" "$target_file"
        
        log_success "Profile exported to: $target_file"
        
    else
        log_warning "Invalid selection"
    fi
}

# Import network profile
import_network_profile() {
    print_header "📥 IMPORT NETWORK PROFILE"
    
    echo "📥 Import a network profile from file:"
    echo ""
    
    read -p "📁 Enter path to profile file: " profile_file
    
    if [ ! -f "$profile_file" ]; then
        log_error "Profile file not found: $profile_file"
        return 1
    fi
    
    read -p "📝 Profile name for import: " profile_name
    
    if [ -z "$profile_name" ]; then
        log_error "Profile name cannot be empty"
        return 1
    fi
    
    # Create profiles directory
    mkdir -p ~/.bill-sloth/network-profiles
    
    local target_file="$HOME/.bill-sloth/network-profiles/${profile_name}.profile"
    
    cp "$profile_file" "$target_file"
    
    log_success "Network profile imported: $profile_name"
    echo "📁 Profile available at: $target_file"
    
    notify_success "Network Profile" "Profile imported: $profile_name"
}

# Delete network profile
delete_network_profile() {
    print_header "🗑️ DELETE NETWORK PROFILE"
    
    local profiles_dir="$HOME/.bill-sloth/network-profiles"
    
    if [ ! -d "$profiles_dir" ]; then
        echo "ℹ️ No network profiles found"
        return 0
    fi
    
    local profiles=($(find "$profiles_dir" -name "*.profile" -exec basename {} .profile \;))
    
    if [ ${#profiles[@]} -eq 0 ]; then
        echo "ℹ️ No network profiles found"
        return 0
    fi
    
    echo "📋 Available profiles to delete:"
    for i in "${!profiles[@]}"; do
        echo "$((i+1))) ${profiles[i]}"
    done
    
    echo ""
    read -p "Select profile to delete (1-${#profiles[@]}): " profile_choice
    
    if [ "$profile_choice" -le "${#profiles[@]}" ] && [ "$profile_choice" -gt 0 ]; then
        local selected_profile="${profiles[$((profile_choice-1))]}"
        local profile_file="$profiles_dir/${selected_profile}.profile"
        
        echo "⚠️ This will permanently delete: $selected_profile"
        read -p "Continue? (type 'yes'): " confirm
        
        if [ "$confirm" = "yes" ]; then
            rm "$profile_file"
            log_success "Network profile deleted: $selected_profile"
        else
            echo "Operation cancelled"
        fi
    else
        log_warning "Invalid selection"
    fi
}

# Main execution
main() {
    echo "📡 Wireless Connectivity Management Center"
    echo "🧠 ADHD-friendly wireless management - simple and focused!"
    echo ""
    
    # Detect capabilities
    detect_wireless_capabilities
    
    # Run main menu
    wireless_connectivity_menu
    
    echo ""
    echo "📡 Thank you for using Wireless Connectivity Management!"
    echo "📶 Stay connected wherever you go!"
    
    # Update adaptive learning
    update_adaptive_learning "wireless_connectivity" "completed_session" 2>/dev/null || true
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi