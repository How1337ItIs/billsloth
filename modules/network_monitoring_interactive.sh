#!/bin/bash
# LLM_CAPABILITY: local_ok
# Interactive Network Monitoring - Real-time analysis and diagnostics
# Part of the Bill Sloth neurodivergent-optimized automation system

source "$(dirname "$0")/../lib/include_loader.sh"
load_includes "core" "notification" "adaptive_learning" "data_persistence" "error_handling" "system_info"

# Configuration and constants
NETWORK_CONFIG_DIR="$HOME/.config/network-monitoring"
MONITORING_LOG="$NETWORK_CONFIG_DIR/monitoring.log"

# Ensure directories exist
mkdir -p "$NETWORK_CONFIG_DIR"

show_ascii_header() {
    echo -e "\033[38;5;51m"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║  📊 NETWORK MONITORING COMMAND CENTER 📊                                ║  
    ║  ═══════════════════════════════════════════════════════════════════    ║
    ║  🔍 Real-time network analysis and diagnostic tools                     ║
    ║  📈 Bandwidth monitoring and traffic analysis                           ║
    ║  🌐 Device discovery and connection scanning                            ║
    ║  🚀 Internet speed testing and performance metrics                      ║
    ╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "\033[0m"
}

print_header() {
    clear
    show_ascii_header
    echo -e "\033[38;5;129m💀 Carl: \"I don't need no instructions to know how to rock!\" 🎸\033[0m"
    echo -e "\033[38;5;226m⚡ Frylock: \"Carl, that's a network monitoring tool, not a guitar.\"\033[0m"
    echo ""
}

show_menu() {
    print_header
    echo -e "\033[38;5;46m🎯 SELECT YOUR NETWORK MONITORING MISSION:\033[0m"
    echo ""
    echo -e "\033[38;5;51m1. 📊 Real-time Bandwidth Monitor\033[0m - Live traffic analysis and usage stats"
    echo -e "\033[38;5;82m2. 🔍 Network Device Scanner\033[0m - Discover all connected devices"
    echo -e "\033[38;5;226m3. 🚀 Internet Speed Test\033[0m - Comprehensive connection analysis"
    echo -e "\033[38;5;129m4. 📈 Network Status Dashboard\033[0m - Complete system overview"
    echo ""
    echo -e "\033[38;5;240m0. ← Return to Main Menu\033[0m"
    echo ""
    echo -e "\033[38;5;196m💀 Master Shake: \"I'm monitoring the network with my mind powers!\" 🧠\033[0m"
    echo ""
}

monitor_bandwidth() {
    print_header
    echo -e "\033[38;5;51m📊 REAL-TIME BANDWIDTH MONITORING\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
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
            echo "============================"
            
            if command -v vnstat &>/dev/null; then
                echo "📊 Daily traffic summary:"
                vnstat -d -i $(ip route | awk '/default/ { print $5 }' | head -1)
                echo ""
                echo "📊 Monthly traffic summary:"
                vnstat -m -i $(ip route | awk '/default/ { print $5 }' | head -1)
            else
                echo "🔄 Installing vnstat for historical analysis..."
                sudo apt update && sudo apt install -y vnstat
                sudo systemctl enable vnstat
                sudo systemctl start vnstat
                echo "📋 vnstat needs time to collect data. Run this option again later."
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
    
    collect_feedback "network_monitoring" "bandwidth_monitoring"
}

scan_network_devices() {
    print_header
    echo -e "\033[38;5;82m🔍 NETWORK DEVICE SCANNER\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
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
    
    collect_feedback "network_monitoring" "network_scanning"
}

run_speed_test() {
    print_header
    echo -e "\033[38;5;226m🚀 INTERNET SPEED TEST\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
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
    
    collect_feedback "network_monitoring" "speed_test"
}

# Speedtest CLI (Ookla)
run_speedtest_cli() {
    echo "🚀 Running Ookla Speedtest..."
    echo ""
    
    # Check if speedtest is installed
    if ! command -v speedtest &>/dev/null; then
        echo "📥 Installing Speedtest CLI..."
        
        # Install speedtest-cli
        if command -v apt &>/dev/null; then
            sudo apt update
            sudo apt install -y speedtest-cli
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y speedtest-cli
        elif command -v yum &>/dev/null; then
            sudo yum install -y speedtest-cli
        else
            echo "⚠️ Please install speedtest-cli manually"
            return 1
        fi
    fi
    
    echo "🔄 Testing connection speed..."
    speedtest-cli --simple
    
    # Save results to file
    local results_file="$NETWORK_CONFIG_DIR/speed_test_results.txt"
    echo "$(date): $(speedtest-cli --simple)" >> "$results_file"
    
    echo ""
    echo "✅ Results saved to: $results_file"
}

# Fast.com test using curl
run_fast_com_test() {
    echo "🚀 Running Fast.com Speed Test..."
    echo ""
    
    if ! command -v fast &>/dev/null; then
        echo "📥 Installing fast-cli..."
        
        # Install fast-cli via npm if available
        if command -v npm &>/dev/null; then
            sudo npm install -g fast-cli
        else
            echo "⚠️ npm required for fast-cli. Using curl fallback..."
            
            echo "🔄 Testing download speed via curl..."
            local start_time=$(date +%s.%N)
            curl -o /dev/null -s -w "%{speed_download}\n" "http://speed.cloudflare.com/__down?bytes=100000000" | \
                awk '{printf "Download: %.2f Mbps\n", $1*8/1000000}'
            
            return 0
        fi
    fi
    
    echo "🔄 Testing connection with Fast.com..."
    fast --upload
}

# Basic connectivity test
run_basic_connectivity_test() {
    echo "🔄 Running Basic Connectivity Test..."
    echo ""
    
    # Test ping to various servers
    local test_servers=("8.8.8.8" "1.1.1.1" "google.com" "cloudflare.com")
    
    echo "📡 Ping Tests:"
    echo "=============="
    
    for server in "${test_servers[@]}"; do
        echo -n "Testing $server: "
        if ping -c 3 -W 3 "$server" &>/dev/null; then
            local avg_time=$(ping -c 3 "$server" | tail -1 | awk -F'/' '{print $5}')
            echo "✅ ${avg_time}ms"
        else
            echo "❌ Failed"
        fi
    done
    
    echo ""
    echo "🔍 DNS Resolution Test:"
    echo "======================"
    
    local dns_servers=("8.8.8.8" "1.1.1.1" "208.67.222.222")
    
    for dns in "${dns_servers[@]}"; do
        echo -n "Testing DNS $dns: "
        if nslookup google.com "$dns" &>/dev/null; then
            echo "✅ Working"
        else
            echo "❌ Failed"
        fi
    done
    
    echo ""
    echo "📊 Network Interface Status:"
    echo "=========================="
    ip addr show | grep -E "(UP|DOWN)" | head -5
}

# Comprehensive speed test
run_comprehensive_speed_test() {
    echo "🔄 Running Comprehensive Speed Test Analysis..."
    echo ""
    
    echo "1️⃣ Basic connectivity check..."
    run_basic_connectivity_test
    
    echo ""
    echo "2️⃣ Speedtest CLI results..."
    run_speedtest_cli
    
    echo ""
    echo "3️⃣ Fast.com comparison..."
    run_fast_com_test
    
    echo ""
    echo "📊 Network Interface Statistics:"
    echo "==============================="
    
    local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
    
    if [ -n "$interface" ]; then
        echo "Interface: $interface"
        ip -s link show "$interface" | tail -2
    fi
    
    # Save comprehensive results
    local results_file="$NETWORK_CONFIG_DIR/speed_test_results.txt"
    echo "$(date): Comprehensive test completed" >> "$results_file"
    
    echo ""
    echo "✅ Comprehensive analysis complete!"
    echo "📁 Results saved to: $results_file"
}

show_network_status() {
    print_header
    echo -e "\033[38;5;129m📈 NETWORK STATUS DASHBOARD\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # Network interface information
    echo "🌐 Network Interfaces:"
    echo "===================="
    ip addr show | grep -E "(UP|DOWN|inet )" | while IFS= read -r line; do
        if [[ $line == *": "* ]]; then
            echo "📡 $line"
        elif [[ $line == *"inet "* ]]; then
            echo "   $line"
        fi
    done
    
    echo ""
    echo "🔗 Routing Information:"
    echo "====================="
    echo "Default Gateway: $(ip route | awk '/default/ { print $3 }' | head -1)"
    echo "Primary Interface: $(ip route | awk '/default/ { print $5 }' | head -1)"
    
    echo ""
    echo "📊 Connection Statistics:"
    echo "========================"
    
    # Active connections count
    local tcp_connections=$(ss -t | wc -l)
    local udp_connections=$(ss -u | wc -l)
    
    echo "TCP Connections: $tcp_connections"
    echo "UDP Connections: $udp_connections"
    
    echo ""
    echo "🔍 DNS Configuration:"
    echo "===================="
    if [ -f /etc/resolv.conf ]; then
        grep "nameserver" /etc/resolv.conf | head -3
    fi
    
    echo ""
    echo "📈 Interface Statistics (Last 5 minutes):"
    echo "========================================"
    
    local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
    if [ -n "$interface" ]; then
        ip -s link show "$interface" | tail -4
    fi
    
    echo ""
    echo "🛡️ Firewall Status:"
    echo "=================="
    if command -v ufw &>/dev/null; then
        ufw status
    elif command -v iptables &>/dev/null; then
        echo "iptables rules: $(iptables -L | wc -l) rules active"
    else
        echo "No firewall detected"
    fi
    
    echo ""
    echo "🔄 Press any key to refresh dashboard..."
    read -n 1
}

# Main menu loop
main() {
    while true; do
        show_menu
        read -p "🎯 Choose your monitoring mission (0-4): " choice
        
        case $choice in
            1) monitor_bandwidth ;;
            2) scan_network_devices ;;
            3) run_speed_test ;;
            4) show_network_status ;;
            0) 
                echo -e "\033[38;5;46m✅ Returning to main menu...\033[0m"
                exit 0 
                ;;
            *)
                echo -e "\033[38;5;196m❌ Invalid choice. Please select 0-4.\033[0m"
                sleep 2
                ;;
        esac
        
        echo ""
        echo -e "\033[38;5;82m🔄 Press any key to continue...\033[0m"
        read -n 1
    done
}

# Start the application
main "$@"