#!/bin/bash
# LLM_CAPABILITY: local_ok
# CLAUDE_OPTIONS: 1=Network Scanner, 2=Connectivity Test, 3=Speed Test, 4=DNS Checker, 5=Complete Diagnostic Suite
# CLAUDE_PROMPTS: Diagnostic tool selection, Network configuration, Test parameters
# CLAUDE_DEPENDENCIES: nmap, ping, traceroute, speedtest-cli, dig
# Interactive Network Diagnostics - Troubleshooting and repair tools
# Part of the Bill Sloth neurodivergent-optimized automation system

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

source "$(dirname "$0")/../lib/include_loader.sh"
load_includes "core" "notification" "adaptive_learning" "data_persistence" "error_handling" "system_info"

# Configuration and constants
NETWORK_CONFIG_DIR="$HOME/.config/network-diagnostics"
DIAGNOSTICS_LOG="$NETWORK_CONFIG_DIR/diagnostics.log"

# Ensure directories exist
mkdir -p "$NETWORK_CONFIG_DIR"

show_ascii_header() {
    echo -e "\033[38;5;196m"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║  🔧 NETWORK DIAGNOSTICS COMMAND CENTER 🔧                              ║  
    ║  ═══════════════════════════════════════════════════════════════════    ║
    ║  🏥 Comprehensive network troubleshooting and repair                    ║
    ║  🔍 Connection analysis and problem detection                           ║
    ║  🛠️ Automated fixes and manual repair tools                            ║
    ║  📊 Security auditing and vulnerability scanning                        ║
    ╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "\033[0m"
}

print_header() {
    clear
    show_ascii_header
    echo -e "\033[38;5;129m💀 Err: \"We shall use the power of the network to destroy our enemies!\" ⚡\033[0m"
    echo -e "\033[38;5;51m🥤 Master Shake: \"Yeah, and fix my internet while you're at it.\"\033[0m"
    echo ""
}

show_menu() {
    print_header
    echo -e "\033[38;5;46m🎯 SELECT YOUR DIAGNOSTIC MISSION:\033[0m"
    echo ""
    echo -e "\033[38;5;51m1. 🔍 Comprehensive Network Analysis\033[0m - Full connectivity and performance check"
    echo -e "\033[38;5;82m2. 🛠️ Network Repair Tools\033[0m - Automated fixes for common issues"
    echo -e "\033[38;5;226m3. 🏥 Connection Troubleshooter\033[0m - Step-by-step problem solving"
    echo -e "\033[38;5;129m4. 🛡️ Security Audit\033[0m - Vulnerability scanning and security analysis"
    echo ""
    echo -e "\033[38;5;240m0. ← Return to Main Menu\033[0m"
    echo ""
    echo -e "\033[38;5;196m💀 Ignignokt: \"Your network shall be analyzed with the fury of a thousand suns!\" ☀️\033[0m"
    echo ""
}

run_comprehensive_analysis() {
    print_header
    echo -e "\033[38;5;51m🔍 COMPREHENSIVE NETWORK ANALYSIS\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔬 Complete network connectivity and performance diagnostics"
    echo ""
    
    notify_info "Diagnostics" "Starting comprehensive network analysis..."
    
    # Test 1: Network Interface Status
    echo "1️⃣  NETWORK INTERFACE STATUS"
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
    echo "2️⃣  DEFAULT GATEWAY TEST"
    echo "========================"
    local gateway=$(ip route | grep default | awk '{print $3}' | head -1)
    if [ -n "$gateway" ]; then
        echo "🏠 Default Gateway: $gateway"
        if ping -c 3 -W 2 "$gateway" >/dev/null 2>&1; then
            echo "✅ Gateway is reachable"
        else
            echo "❌ Gateway is unreachable"
            echo "💡 This suggests a local network issue"
        fi
    else
        echo "❌ No default gateway found"
        echo "💡 Check network configuration or cable connection"
    fi
    echo ""
    
    # Test 3: DNS Resolution
    echo "3️⃣  DNS RESOLUTION TEST"
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
                echo "   💡 DNS server may be overloaded or filtering traffic"
            fi
        else
            echo "   ❌ DNS server unreachable"
        fi
    done
    echo ""
    
    # Test 4: Internet Connectivity
    echo "4️⃣  INTERNET CONNECTIVITY TEST"
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
        echo "💡 Some sites may be blocked or experiencing issues"
    else
        echo "❌ Internet connectivity: Failed"
        echo "💡 Check ISP connection or try network repair tools"
    fi
    echo ""
    
    # Test 5: Latency Analysis
    echo "5️⃣  NETWORK LATENCY ANALYSIS"
    echo "============================"
    echo "📡 Measuring latency to major servers:"
    local latency_servers=("8.8.8.8:Google" "1.1.1.1:Cloudflare" "208.67.222.222:OpenDNS")
    
    for server_info in "${latency_servers[@]}"; do
        local server=$(echo "$server_info" | cut -d: -f1)
        local name=$(echo "$server_info" | cut -d: -f2)
        
        local avg_time=$(ping -c 4 -W 2 "$server" 2>/dev/null | grep "rtt" | cut -d= -f2 | cut -d/ -f2)
        if [ -n "$avg_time" ]; then
            local latency_ms=$(echo "$avg_time" | cut -d. -f1)
            echo "   📈 $name ($server): ${avg_time}ms average"
            
            # Provide latency assessment
            if [ "$latency_ms" -lt 20 ]; then
                echo "      🚀 Excellent latency"
            elif [ "$latency_ms" -lt 50 ]; then
                echo "      ✅ Good latency"
            elif [ "$latency_ms" -lt 100 ]; then
                echo "      ⚠️ Fair latency"
            else
                echo "      ❌ High latency - may affect real-time applications"
            fi
        else
            echo "   ❌ $name ($server): Unable to measure"
        fi
    done
    echo ""
    
    # Test 6: VPN Status
    echo "6️⃣  VPN CONNECTION STATUS"
    echo "========================"
    local vpn_active=false
    
    # Check WireGuard
    if command -v wg &>/dev/null && wg show | grep -q interface; then
        echo "🔐 WireGuard VPN: Active"
        wg show | grep -E "(interface|endpoint|latest handshake)" | while IFS= read -r line; do
            echo "   $line"
        done
        vpn_active=true
    fi
    
    # Check OpenVPN
    if pgrep openvpn >/dev/null; then
        echo "🔐 OpenVPN: Active"
        local openvpn_config=$(ps aux | grep openvpn | grep -v grep | awk '{print $11}' | head -1)
        echo "   Config: ${openvpn_config:-Unknown}"
        vpn_active=true
    fi
    
    if [ "$vpn_active" = false ]; then
        echo "🔓 No active VPN connections detected"
        echo "💡 Consider using VPN for enhanced privacy and security"
    fi
    echo ""
    
    # Test 7: Firewall Status
    echo "7️⃣  FIREWALL STATUS"
    echo "=================="
    if command -v ufw &>/dev/null; then
        local ufw_status=$(sudo ufw status | head -1)
        echo "🛡️  UFW: $ufw_status"
        if [[ $ufw_status =~ active ]]; then
            local rule_count=$(sudo ufw status numbered | grep -c "^\[")
            echo "   📋 Active rules: $rule_count"
            echo "   💡 Firewall is protecting your system"
        else
            echo "   ⚠️ Firewall is inactive - consider enabling it"
        fi
    elif command -v firewall-cmd &>/dev/null; then
        if firewall-cmd --state >/dev/null 2>&1; then
            echo "🛡️  Firewalld: Active"
        else
            echo "🛡️  Firewalld: Inactive"
        fi
    else
        echo "⚠️  No firewall management tool detected"
        echo "💡 Consider installing and configuring UFW"
    fi
    echo ""
    
    # Generate Summary Report
    echo "📋 ANALYSIS SUMMARY"
    echo "=================="
    
    # Save diagnostic results
    local results_file="$NETWORK_CONFIG_DIR/analysis_results_$(date +%Y%m%d_%H%M%S).txt"
    {
        echo "Network Analysis Report - $(date)"
        echo "=================================="
        echo "Gateway reachable: $([ -n "$gateway" ] && ping -c 1 -W 2 "$gateway" >/dev/null 2>&1 && echo "Yes" || echo "No")"
        echo "Internet connectivity: $success_count/${#test_sites[@]} sites reachable"
        echo "VPN status: $([ "$vpn_active" = true ] && echo "Active" || echo "Inactive")"
        echo "Firewall status: $(command -v ufw &>/dev/null && sudo ufw status | head -1 || echo "Unknown")"
    } > "$results_file"
    
    echo "📁 Results saved to: $results_file"
    echo ""
    
    # Provide recommendations
    echo "💡 RECOMMENDATIONS:"
    if [ $success_count -lt ${#test_sites[@]} ]; then
        echo "• Run network repair tools to fix connectivity issues"
    fi
    if [ "$vpn_active" = false ]; then
        echo "• Consider setting up VPN for enhanced privacy"
    fi
    echo "• Use network monitoring tools for ongoing analysis"
    echo "• Run security audit to check for vulnerabilities"
    
    notify_success "Analysis" "Comprehensive network analysis completed"
    collect_feedback "network_diagnostics" "comprehensive_analysis"
}

network_repair_tools() {
    print_header
    echo -e "\033[38;5;82m🛠️ NETWORK REPAIR TOOLS\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔧 Automated fixes for common network issues"
    echo "• Reset network interfaces and configurations"
    echo "• Clear DNS cache and reset resolution"
    echo "• Restart network services and connections"
    echo "• Fix routing table and gateway issues"
    echo ""
    
    echo "📋 Repair Options:"
    echo "1) Quick network reset (restart interfaces)"
    echo "2) DNS cache flush and reset"
    echo "3) Reset network routing table"
    echo "4) Restart network services"
    echo "5) Complete network stack reset"
    echo "6) Fix common Wi-Fi issues"
    echo ""
    
    read -p "Select repair option (1-6): " repair_choice
    
    case "$repair_choice" in
        1)
            echo "🔄 Quick Network Interface Reset"
            echo "==============================="
            echo ""
            
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            
            if [ -n "$interface" ]; then
                echo "🔧 Resetting network interface: $interface"
                
                # Bring interface down and up
                echo "   • Bringing interface down..."
                sudo ip link set "$interface" down
                sleep 2
                
                echo "   • Bringing interface up..."
                sudo ip link set "$interface" up
                sleep 3
                
                # Restart DHCP if using NetworkManager
                if command -v nmcli &>/dev/null; then
                    echo "   • Renewing DHCP lease..."
                    local connection=$(nmcli -t -f NAME connection show --active | head -1)
                    if [ -n "$connection" ]; then
                        nmcli connection down "$connection"
                        sleep 2
                        nmcli connection up "$connection"
                    fi
                fi
                
                echo "✅ Interface reset complete!"
                echo "📋 Testing connectivity..."
                
                if ping -c 2 -W 3 8.8.8.8 >/dev/null 2>&1; then
                    echo "🎉 Internet connectivity restored!"
                    notify_success "Repair" "Network interface reset successful"
                else
                    echo "⚠️ Interface reset but connectivity still limited"
                fi
            else
                echo "❌ No active interface found"
            fi
            ;;
            
        2)
            echo "🌐 DNS Cache Flush and Reset"
            echo "============================"
            echo ""
            
            echo "🔧 Clearing DNS caches..."
            
            # Flush systemd-resolved cache
            if command -v systemd-resolve &>/dev/null; then
                echo "   • Flushing systemd-resolved cache..."
                sudo systemd-resolve --flush-caches
            fi
            
            # Clear dnsmasq cache if running
            if pgrep dnsmasq >/dev/null; then
                echo "   • Restarting dnsmasq..."
                sudo systemctl restart dnsmasq
            fi
            
            # Reset resolv.conf if needed
            echo "   • Checking DNS configuration..."
            if [ ! -s /etc/resolv.conf ]; then
                echo "   • Restoring default DNS servers..."
                {
                    echo "nameserver 8.8.8.8"
                    echo "nameserver 1.1.1.1"
                } | sudo tee /etc/resolv.conf > /dev/null
            fi
            
            echo "✅ DNS reset complete!"
            echo "📋 Testing DNS resolution..."
            
            if nslookup google.com >/dev/null 2>&1; then
                echo "🎉 DNS resolution working!"
                notify_success "Repair" "DNS reset successful"
            else
                echo "⚠️ DNS issues persist - try different DNS servers"
            fi
            ;;
            
        3)
            echo "🗺️ Reset Network Routing Table"
            echo "=============================="
            echo ""
            
            echo "🔧 Resetting routing table..."
            
            # Backup current routes
            local backup_file="$NETWORK_CONFIG_DIR/routes_backup_$(date +%Y%m%d_%H%M%S).txt"
            ip route show > "$backup_file"
            echo "   • Current routes backed up to: $backup_file"
            
            # Get interface and gateway info before reset
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            local old_gateway=$(ip route | awk '/default/ { print $3 }' | head -1)
            
            if [ -n "$interface" ] && [ -n "$old_gateway" ]; then
                echo "   • Current gateway: $old_gateway via $interface"
                
                # Clear routing table (except local routes)
                echo "   • Clearing routing table..."
                sudo ip route flush table main
                
                # Re-add default route
                echo "   • Re-adding default route..."
                sudo ip route add default via "$old_gateway" dev "$interface"
                
                # Restart NetworkManager to restore proper routes
                if command -v nmcli &>/dev/null; then
                    echo "   • Restarting NetworkManager..."
                    sudo systemctl restart NetworkManager
                    sleep 5
                fi
                
                echo "✅ Routing table reset complete!"
                echo "📋 Testing connectivity..."
                
                if ping -c 2 -W 3 "$old_gateway" >/dev/null 2>&1; then
                    echo "🎉 Gateway connectivity restored!"
                    notify_success "Repair" "Routing table reset successful"
                else
                    echo "⚠️ Gateway unreachable after reset"
                fi
            else
                echo "❌ Cannot determine current network configuration"
            fi
            ;;
            
        4)
            echo "🔄 Restart Network Services"
            echo "=========================="
            echo ""
            
            echo "🔧 Restarting network services..."
            
            # Restart NetworkManager
            if command -v nmcli &>/dev/null; then
                echo "   • Restarting NetworkManager..."
                sudo systemctl restart NetworkManager
                sleep 3
            fi
            
            # Restart systemd-networkd if active
            if systemctl is-active systemd-networkd >/dev/null 2>&1; then
                echo "   • Restarting systemd-networkd..."
                sudo systemctl restart systemd-networkd
                sleep 2
            fi
            
            # Restart systemd-resolved
            if systemctl is-active systemd-resolved >/dev/null 2>&1; then
                echo "   • Restarting systemd-resolved..."
                sudo systemctl restart systemd-resolved
                sleep 2
            fi
            
            # Restart wpa_supplicant for Wi-Fi
            if systemctl is-active wpa_supplicant >/dev/null 2>&1; then
                echo "   • Restarting wpa_supplicant..."
                sudo systemctl restart wpa_supplicant
                sleep 2
            fi
            
            echo "✅ Network services restarted!"
            echo "📋 Testing connectivity..."
            
            sleep 5  # Wait for services to fully start
            if ping -c 2 -W 3 8.8.8.8 >/dev/null 2>&1; then
                echo "🎉 Network services restored connectivity!"
                notify_success "Repair" "Network services restart successful"
            else
                echo "⚠️ Services restarted but connectivity issues remain"
            fi
            ;;
            
        5)
            echo "🔄 Complete Network Stack Reset"
            echo "=============================="
            echo ""
            
            echo "⚠️ This will perform a complete network reset including:"
            echo "   • All network interfaces"
            echo "   • DNS cache and configuration"
            echo "   • Routing tables"
            echo "   • Network services"
            echo ""
            
            if confirm "Proceed with complete network reset?"; then
                echo "🔧 Performing complete network reset..."
                
                # Stop all network services
                echo "   • Stopping network services..."
                sudo systemctl stop NetworkManager 2>/dev/null
                sudo systemctl stop systemd-networkd 2>/dev/null
                sudo systemctl stop wpa_supplicant 2>/dev/null
                
                # Reset all interfaces
                echo "   • Resetting all interfaces..."
                for iface in $(ip link show | grep '^[0-9]' | cut -d':' -f2 | tr -d ' '); do
                    if [[ "$iface" != "lo" ]]; then
                        sudo ip link set "$iface" down 2>/dev/null
                        sudo ip addr flush dev "$iface" 2>/dev/null
                    fi
                done
                
                # Clear routing tables
                echo "   • Clearing routing tables..."
                sudo ip route flush table main 2>/dev/null
                
                # Clear DNS
                echo "   • Resetting DNS..."
                sudo systemctl restart systemd-resolved 2>/dev/null
                
                # Restart network services
                echo "   • Restarting network services..."
                sudo systemctl start NetworkManager 2>/dev/null
                sleep 10
                
                echo "✅ Complete network reset finished!"
                echo "📋 Testing connectivity..."
                
                sleep 10  # Wait longer for full initialization
                if ping -c 3 -W 5 8.8.8.8 >/dev/null 2>&1; then
                    echo "🎉 Complete network reset successful!"
                    notify_success "Repair" "Complete network reset successful"
                else
                    echo "⚠️ Network reset complete but connectivity not restored"
                    echo "💡 May require manual configuration or hardware check"
                fi
            else
                echo "❌ Complete network reset cancelled"
            fi
            ;;
            
        6)
            echo "📶 Fix Common Wi-Fi Issues"
            echo "========================="
            echo ""
            
            echo "🔧 Diagnosing and fixing Wi-Fi problems..."
            
            # Find Wi-Fi interface
            local wifi_interface=$(iwconfig 2>/dev/null | grep -E '^wl|^wlan' | cut -d' ' -f1 | head -1)
            
            if [ -n "$wifi_interface" ]; then
                echo "   • Wi-Fi interface found: $wifi_interface"
                
                # Check if interface is up
                if ip link show "$wifi_interface" | grep -q "state UP"; then
                    echo "   ✅ Wi-Fi interface is active"
                else
                    echo "   🔧 Bringing Wi-Fi interface up..."
                    sudo ip link set "$wifi_interface" up
                fi
                
                # Restart Wi-Fi
                echo "   • Restarting Wi-Fi connection..."
                sudo nmcli radio wifi off
                sleep 2
                sudo nmcli radio wifi on
                sleep 5
                
                # Scan for networks
                echo "   • Scanning for available networks..."
                local network_count=$(nmcli device wifi list | wc -l)
                echo "   📡 Found $((network_count - 1)) Wi-Fi networks"
                
                # Try to reconnect to known networks
                echo "   • Attempting to reconnect to saved networks..."
                nmcli connection up $(nmcli connection show | grep wifi | head -1 | awk '{print $1}') 2>/dev/null
                
                echo "✅ Wi-Fi troubleshooting complete!"
                
                # Test Wi-Fi connectivity
                if ping -c 2 -W 3 8.8.8.8 >/dev/null 2>&1; then
                    echo "🎉 Wi-Fi connectivity restored!"
                    notify_success "Repair" "Wi-Fi issues resolved"
                else
                    echo "⚠️ Wi-Fi interface active but no internet connectivity"
                    echo "💡 Check Wi-Fi password or router settings"
                fi
            else
                echo "❌ No Wi-Fi interface found"
                echo "💡 Check if Wi-Fi drivers are installed"
            fi
            ;;
            
        *)
            echo "❌ Invalid selection"
            ;;
    esac
    
    collect_feedback "network_diagnostics" "repair_tools"
}

connection_troubleshooter() {
    print_header
    echo -e "\033[38;5;226m🏥 CONNECTION TROUBLESHOOTER\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔍 Step-by-step guided troubleshooting for network issues"
    echo ""
    
    echo "What type of connection problem are you experiencing?"
    echo ""
    echo "1) No internet connection at all"
    echo "2) Slow or intermittent connection"
    echo "3) Cannot reach specific websites"
    echo "4) Wi-Fi connection problems"
    echo "5) Ethernet/wired connection issues"
    echo "6) VPN connection problems"
    echo ""
    
    read -p "Select problem type (1-6): " problem_type
    
    case "$problem_type" in
        1)
            troubleshoot_no_internet
            ;;
        2)
            troubleshoot_slow_connection
            ;;
        3)
            troubleshoot_specific_sites
            ;;
        4)
            troubleshoot_wifi_issues
            ;;
        5)
            troubleshoot_ethernet_issues
            ;;
        6)
            troubleshoot_vpn_issues
            ;;
        *)
            echo "❌ Invalid selection"
            ;;
    esac
    
    collect_feedback "network_diagnostics" "connection_troubleshooter"
}

troubleshoot_no_internet() {
    echo ""
    echo "🔍 TROUBLESHOOTING: No Internet Connection"
    echo "========================================"
    echo ""
    
    # Step 1: Check physical connections
    echo "STEP 1: Physical Connection Check"
    echo "--------------------------------"
    echo "Please verify:"
    echo "• Ethernet cable is securely connected (if using wired)"
    echo "• Wi-Fi is enabled and connected to correct network"
    echo "• Router/modem power lights are on"
    echo "• All cables are undamaged"
    echo ""
    
    if ! confirm "Are all physical connections secure?"; then
        echo "💡 Please check and secure all physical connections, then restart this troubleshooter."
        return 1
    fi
    
    # Step 2: Test local network
    echo ""
    echo "STEP 2: Local Network Test"
    echo "-------------------------"
    echo "🔍 Testing connection to your router..."
    
    local gateway=$(ip route | grep default | awk '{print $3}' | head -1)
    if [ -n "$gateway" ]; then
        echo "Router IP: $gateway"
        if ping -c 3 -W 2 "$gateway" >/dev/null 2>&1; then
            echo "✅ Local network connection: OK"
        else
            echo "❌ Cannot reach router"
            echo ""
            echo "💡 SOLUTION: Local network issue detected"
            echo "   • Restart your router (unplug for 30 seconds)"
            echo "   • Check Wi-Fi password if using wireless"
            echo "   • Try connecting different device to same network"
            return 1
        fi
    else
        echo "❌ No router found in routing table"
        echo ""
        echo "💡 SOLUTION: Network configuration issue"
        echo "   • Run network repair tools (option 2 from main menu)"
        echo "   • Restart network services"
        return 1
    fi
    
    # Step 3: Test DNS
    echo ""
    echo "STEP 3: DNS Resolution Test"
    echo "---------------------------"
    echo "🔍 Testing DNS servers..."
    
    if nslookup google.com >/dev/null 2>&1; then
        echo "✅ DNS resolution: OK"
    else
        echo "❌ DNS resolution failed"
        echo ""
        echo "💡 SOLUTION: DNS issue detected"
        echo "   • Try changing DNS servers:"
        echo "     - Google DNS: 8.8.8.8, 8.8.4.4"
        echo "     - Cloudflare DNS: 1.1.1.1, 1.0.0.1"
        echo "   • Run DNS repair from network repair tools"
        return 1
    fi
    
    # Step 4: Test internet connectivity
    echo ""
    echo "STEP 4: Internet Connectivity Test"
    echo "==================================="
    echo "🔍 Testing connection to external servers..."
    
    local test_sites=("8.8.8.8" "1.1.1.1" "google.com")
    local success_count=0
    
    for site in "${test_sites[@]}"; do
        if ping -c 2 -W 3 "$site" >/dev/null 2>&1; then
            echo "✅ $site: Reachable"
            success_count=$((success_count + 1))
        else
            echo "❌ $site: Unreachable"
        fi
    done
    
    if [ $success_count -eq 0 ]; then
        echo ""
        echo "💡 SOLUTION: Internet service provider (ISP) issue"
        echo "   • Contact your ISP to report outage"
        echo "   • Check ISP status page for known issues"
        echo "   • Try restarting your modem"
    elif [ $success_count -lt ${#test_sites[@]} ]; then
        echo ""
        echo "💡 PARTIAL CONNECTIVITY: Some servers unreachable"
        echo "   • May be temporary server issues"
        echo "   • Try again in a few minutes"
    else
        echo ""
        echo "🎉 GOOD NEWS: Internet connectivity appears to be working!"
        echo "   • The issue may have resolved itself"
        echo "   • Try refreshing your web browser"
    fi
}

troubleshoot_slow_connection() {
    echo ""
    echo "🔍 TROUBLESHOOTING: Slow or Intermittent Connection"
    echo "================================================="
    echo ""
    
    # Step 1: Speed test
    echo "STEP 1: Connection Speed Test"
    echo "----------------------------"
    echo "🚀 Running speed test..."
    
    if command -v speedtest-cli &>/dev/null; then
        speedtest-cli --simple
    else
        echo "💡 Installing speedtest tool..."
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y speedtest-cli
            speedtest-cli --simple
        else
            echo "⚠️ Cannot install speedtest - using ping test instead"
            
            echo "📡 Latency test:"
            for server in "8.8.8.8:Google" "1.1.1.1:Cloudflare"; do
                local ip=$(echo "$server" | cut -d: -f1)
                local name=$(echo "$server" | cut -d: -f2)
                local avg_time=$(ping -c 10 "$ip" 2>/dev/null | grep "rtt" | cut -d= -f2 | cut -d/ -f2)
                echo "   $name: ${avg_time:-timeout}ms"
            done
        fi
    fi
    
    echo ""
    echo "STEP 2: Bandwidth Usage Analysis"
    echo "-------------------------------"
    echo "🔍 Checking for bandwidth-heavy processes..."
    
    if command -v nethogs &>/dev/null; then
        echo "💡 Run 'sudo nethogs' to see real-time bandwidth usage by process"
    else
        echo "📥 Installing network monitoring tools..."
        sudo apt update && sudo apt install -y nethogs iftop 2>/dev/null
    fi
    
    # Check for common bandwidth hogs
    echo ""
    echo "🔍 Common causes of slow connections:"
    echo "   • Multiple devices streaming video"
    echo "   • Large file downloads/uploads"
    echo "   • Software updates running in background"
    echo "   • Cloud backup services syncing"
    echo "   • Gaming or video calls"
    echo ""
    
    if confirm "Are there multiple devices or applications using the internet heavily?"; then
        echo ""
        echo "💡 SOLUTION: Bandwidth Management"
        echo "   • Pause non-essential downloads"
        echo "   • Limit video quality on streaming services"
        echo "   • Use QoS settings on your router"
        echo "   • Consider upgrading internet plan"
        echo "   • Use network optimization tools (option 2 from main menu)"
    else
        echo ""
        echo "STEP 3: Network Interference Check"
        echo "==================================="
        
        # Check Wi-Fi interference
        local wifi_interface=$(iwconfig 2>/dev/null | grep -E '^wl|^wlan' | cut -d' ' -f1 | head -1)
        if [ -n "$wifi_interface" ]; then
            echo "🔍 Checking Wi-Fi interference..."
            
            if command -v iwlist &>/dev/null; then
                local channel_count=$(iwlist "$wifi_interface" scan 2>/dev/null | grep -c "Frequency")
                echo "   📡 Found $channel_count Wi-Fi networks nearby"
                
                if [ "$channel_count" -gt 10 ]; then
                    echo "   ⚠️ High Wi-Fi congestion detected"
                    echo ""
                    echo "💡 SOLUTION: Wi-Fi Interference"
                    echo "   • Change Wi-Fi channel on router (try 1, 6, or 11 for 2.4GHz)"
                    echo "   • Switch to 5GHz band if available"
                    echo "   • Move closer to router"
                    echo "   • Remove obstacles between device and router"
                fi
            fi
        fi
        
        echo ""
        echo "💡 Additional optimization suggestions:"
        echo "   • Restart router and modem"
        echo "   • Update network drivers"
        echo "   • Scan for malware that might be using bandwidth"
        echo "   • Check router firmware updates"
    fi
}

troubleshoot_specific_sites() {
    echo ""
    echo "🔍 TROUBLESHOOTING: Cannot Reach Specific Websites"
    echo "================================================="
    echo ""
    
    read -p "Enter the website you cannot reach (e.g., example.com): " problem_site
    
    if [ -z "$problem_site" ]; then
        echo "❌ No website specified"
        return 1
    fi
    
    echo ""
    echo "🔍 Testing connectivity to: $problem_site"
    echo ""
    
    # Test 1: DNS resolution
    echo "STEP 1: DNS Resolution Test"
    echo "-------------------------"
    if nslookup "$problem_site" >/dev/null 2>&1; then
        local site_ip=$(nslookup "$problem_site" | grep -A 1 "Name:" | tail -1 | awk '{print $2}')
        echo "✅ DNS resolution: OK"
        echo "   IP address: $site_ip"
    else
        echo "❌ DNS resolution failed"
        echo ""
        echo "💡 SOLUTION: DNS issue with specific site"
        echo "   • Site may be down or domain expired"
        echo "   • Try different DNS servers (8.8.8.8 or 1.1.1.1)"
        echo "   • Check if domain name is spelled correctly"
        return 1
    fi
    
    # Test 2: Ping test
    echo ""
    echo "STEP 2: Connectivity Test"
    echo "------------------------"
    if ping -c 3 -W 3 "$problem_site" >/dev/null 2>&1; then
        echo "✅ Ping test: OK"
    else
        echo "❌ Ping test failed"
        echo ""
        echo "💡 Possible causes:"
        echo "   • Website blocks ping requests (normal for many sites)"
        echo "   • Firewall blocking connection"
        echo "   • Geographical restrictions"
    fi
    
    # Test 3: HTTP connectivity
    echo ""
    echo "STEP 3: HTTP/HTTPS Test"
    echo "---------------------"
    if command -v curl &>/dev/null; then
        if curl -s --connect-timeout 10 "http://$problem_site" >/dev/null 2>&1; then
            echo "✅ HTTP connection: OK"
        else
            echo "❌ HTTP connection failed"
        fi
        
        if curl -s --connect-timeout 10 "https://$problem_site" >/dev/null 2>&1; then
            echo "✅ HTTPS connection: OK"
        else
            echo "❌ HTTPS connection failed"
            echo ""
            echo "💡 SOLUTION: HTTPS/Security issue"
            echo "   • Try accessing with http:// instead of https://"
            echo "   • Check if antivirus is blocking the site"
            echo "   • Clear browser cache and cookies"
            echo "   • Try different web browser"
        fi
    else
        echo "⚠️ curl not available for HTTP testing"
    fi
    
    # Test 4: Alternative access methods
    echo ""
    echo "STEP 4: Alternative Access Test"
    echo "-----------------------------"
    echo "🔍 Testing alternative access methods..."
    
    # Test with different DNS
    echo "   • Testing with Google DNS..."
    if nslookup "$problem_site" 8.8.8.8 >/dev/null 2>&1; then
        echo "     ✅ Accessible via Google DNS"
    else
        echo "     ❌ Not accessible via Google DNS"
    fi
    
    echo ""
    echo "💡 Additional troubleshooting steps:"
    echo "   • Check website status at: downforeveryoneorjustme.com"
    echo "   • Try accessing from mobile data instead of Wi-Fi"
    echo "   • Check if your ISP blocks the website"
    echo "   • Try using VPN to bypass geographic restrictions"
    echo "   • Clear browser DNS cache (chrome://net-internals/#dns)"
}

troubleshoot_wifi_issues() {
    echo ""
    echo "🔍 TROUBLESHOOTING: Wi-Fi Connection Problems"
    echo "============================================"
    echo ""
    
    # Find Wi-Fi interface
    local wifi_interface=$(iwconfig 2>/dev/null | grep -E '^wl|^wlan' | cut -d' ' -f1 | head -1)
    
    if [ -z "$wifi_interface" ]; then
        echo "❌ No Wi-Fi interface found"
        echo ""
        echo "💡 SOLUTION: Wi-Fi hardware issue"
        echo "   • Check if Wi-Fi drivers are installed"
        echo "   • Verify Wi-Fi card is recognized: lspci | grep -i wireless"
        echo "   • Install appropriate drivers for your Wi-Fi card"
        return 1
    fi
    
    echo "📡 Wi-Fi interface found: $wifi_interface"
    echo ""
    
    # Step 1: Check Wi-Fi status
    echo "STEP 1: Wi-Fi Status Check"
    echo "------------------------"
    
    if ip link show "$wifi_interface" | grep -q "state UP"; then
        echo "✅ Wi-Fi interface is active"
    else
        echo "⚠️ Wi-Fi interface is down"
        echo "🔧 Bringing Wi-Fi interface up..."
        sudo ip link set "$wifi_interface" up
        sleep 2
    fi
    
    # Check if Wi-Fi radio is enabled
    if command -v nmcli &>/dev/null; then
        local wifi_enabled=$(nmcli radio wifi)
        if [ "$wifi_enabled" = "enabled" ]; then
            echo "✅ Wi-Fi radio is enabled"
        else
            echo "🔧 Enabling Wi-Fi radio..."
            nmcli radio wifi on
            sleep 3
        fi
    fi
    
    # Step 2: Scan for networks
    echo ""
    echo "STEP 2: Network Scan"
    echo "------------------"
    echo "🔍 Scanning for available Wi-Fi networks..."
    
    if command -v nmcli &>/dev/null; then
        local network_count=$(nmcli device wifi list | wc -l)
        echo "📡 Found $((network_count - 1)) Wi-Fi networks"
        
        if [ $network_count -lt 2 ]; then
            echo "⚠️ No Wi-Fi networks detected"
            echo ""
            echo "💡 SOLUTION: Wi-Fi scanning issues"
            echo "   • Move closer to router"
            echo "   • Check if router is broadcasting SSID"
            echo "   • Restart Wi-Fi on router"
            echo "   • Check Wi-Fi frequency band (2.4GHz vs 5GHz)"
        else
            echo "📋 Top available networks:"
            nmcli device wifi list | head -5 | tail -4
        fi
    fi
    
    # Step 3: Connection status
    echo ""
    echo "STEP 3: Connection Status"
    echo "-----------------------"
    
    local current_ssid=$(iwconfig "$wifi_interface" 2>/dev/null | grep "ESSID" | cut -d'"' -f2)
    
    if [ -n "$current_ssid" ] && [ "$current_ssid" != "off/any" ]; then
        echo "✅ Connected to: $current_ssid"
        
        # Check signal strength
        local signal_level=$(iwconfig "$wifi_interface" 2>/dev/null | grep "Signal level" | awk -F'=' '{print $3}' | awk '{print $1}')
        if [ -n "$signal_level" ]; then
            echo "📶 Signal strength: $signal_level"
        fi
        
        # Test internet through Wi-Fi
        echo "🔍 Testing internet connectivity..."
        if ping -c 3 -W 3 8.8.8.8 >/dev/null 2>&1; then
            echo "✅ Internet connectivity: OK"
            echo ""
            echo "🎉 Wi-Fi appears to be working correctly!"
        else
            echo "❌ No internet connectivity"
            echo ""
            echo "💡 SOLUTION: Connected to Wi-Fi but no internet"
            echo "   • Check router internet connection"
            echo "   • Restart router"
            echo "   • Check if router requires authentication"
        fi
    else
        echo "❌ Not connected to any Wi-Fi network"
        echo ""
        
        read -p "Enter Wi-Fi network name (SSID) to connect: " target_ssid
        if [ -n "$target_ssid" ]; then
            read -s -p "Enter Wi-Fi password: " wifi_password
            echo ""
            
            echo "🔧 Attempting to connect to: $target_ssid"
            
            if command -v nmcli &>/dev/null; then
                if nmcli device wifi connect "$target_ssid" password "$wifi_password"; then
                    echo "✅ Successfully connected to $target_ssid"
                    
                    # Test connectivity
                    sleep 5
                    if ping -c 3 -W 3 8.8.8.8 >/dev/null 2>&1; then
                        echo "🎉 Internet connectivity established!"
                    else
                        echo "⚠️ Connected but no internet access"
                    fi
                else
                    echo "❌ Failed to connect"
                    echo ""
                    echo "💡 SOLUTION: Connection failed"
                    echo "   • Check password spelling"
                    echo "   • Verify network name (SSID)"
                    echo "   • Check if network uses special authentication"
                    echo "   • Try forgetting and re-adding the network"
                fi
            fi
        fi
    fi
}

troubleshoot_ethernet_issues() {
    echo ""
    echo "🔍 TROUBLESHOOTING: Ethernet/Wired Connection Issues"
    echo "==================================================="
    echo ""
    
    # Find ethernet interface
    local eth_interface=$(ip link show | grep -E "^[0-9]+: (en|eth)" | head -1 | cut -d: -f2 | xargs)
    
    if [ -z "$eth_interface" ]; then
        echo "❌ No ethernet interface found"
        echo ""
        echo "💡 SOLUTION: Ethernet hardware issue"
        echo "   • Check if ethernet drivers are installed"
        echo "   • Verify ethernet card is recognized: lspci | grep -i ethernet"
        echo "   • Install appropriate drivers for your ethernet card"
        return 1
    fi
    
    echo "🔌 Ethernet interface found: $eth_interface"
    echo ""
    
    # Step 1: Physical connection check
    echo "STEP 1: Physical Connection Check"
    echo "-------------------------------"
    
    local link_status=$(cat "/sys/class/net/$eth_interface/carrier" 2>/dev/null)
    if [ "$link_status" = "1" ]; then
        echo "✅ Ethernet cable is connected"
        
        # Get link speed if available
        local speed=$(cat "/sys/class/net/$eth_interface/speed" 2>/dev/null)
        if [ -n "$speed" ] && [ "$speed" != "-1" ]; then
            echo "🚀 Link speed: ${speed}Mbps"
        fi
    else
        echo "❌ No ethernet cable detected"
        echo ""
        echo "💡 SOLUTION: Physical connection issue"
        echo "   • Check ethernet cable is securely plugged in"
        echo "   • Try a different ethernet cable"
        echo "   • Check cable for physical damage"
        echo "   • Try different ethernet port on router/switch"
        return 1
    fi
    
    # Step 2: Interface status
    echo ""
    echo "STEP 2: Interface Status"
    echo "----------------------"
    
    if ip link show "$eth_interface" | grep -q "state UP"; then
        echo "✅ Ethernet interface is active"
    else
        echo "🔧 Bringing ethernet interface up..."
        sudo ip link set "$eth_interface" up
        sleep 3
        
        if ip link show "$eth_interface" | grep -q "state UP"; then
            echo "✅ Ethernet interface activated"
        else
            echo "❌ Failed to activate ethernet interface"
            echo ""
            echo "💡 SOLUTION: Interface activation failed"
            echo "   • Check driver compatibility"
            echo "   • Try manual network configuration"
            return 1
        fi
    fi
    
    # Step 3: IP configuration
    echo ""
    echo "STEP 3: IP Configuration"
    echo "----------------------"
    
    local eth_ip=$(ip addr show "$eth_interface" | grep 'inet ' | awk '{print $2}' | head -1)
    
    if [ -n "$eth_ip" ]; then
        echo "✅ IP address assigned: $eth_ip"
    else
        echo "❌ No IP address assigned"
        echo "🔧 Requesting IP address via DHCP..."
        
        if command -v dhclient &>/dev/null; then
            sudo dhclient "$eth_interface"
            sleep 5
            
            eth_ip=$(ip addr show "$eth_interface" | grep 'inet ' | awk '{print $2}' | head -1)
            if [ -n "$eth_ip" ]; then
                echo "✅ IP address obtained: $eth_ip"
            else
                echo "❌ DHCP failed"
                echo ""
                echo "💡 SOLUTION: DHCP failure"
                echo "   • Check if DHCP is enabled on router"
                echo "   • Try restarting router"
                echo "   • Configure static IP manually"
                echo "   • Check if MAC address is blocked"
                return 1
            fi
        fi
    fi
    
    # Step 4: Gateway connectivity
    echo ""
    echo "STEP 4: Gateway Connectivity"
    echo "--------------------------"
    
    local gateway=$(ip route | grep "default.*$eth_interface" | awk '{print $3}' | head -1)
    
    if [ -n "$gateway" ]; then
        echo "🏠 Gateway: $gateway"
        
        if ping -c 3 -W 3 "$gateway" >/dev/null 2>&1; then
            echo "✅ Gateway reachable"
            
            # Test internet
            echo "🔍 Testing internet connectivity..."
            if ping -c 3 -W 3 8.8.8.8 >/dev/null 2>&1; then
                echo "🎉 Ethernet connection working perfectly!"
            else
                echo "⚠️ Gateway reachable but no internet"
                echo ""
                echo "💡 SOLUTION: Router/ISP issue"
                echo "   • Check router internet connection"
                echo "   • Restart router and modem"
                echo "   • Contact ISP if issue persists"
            fi
        else
            echo "❌ Gateway unreachable"
            echo ""
            echo "💡 SOLUTION: Gateway connectivity issue"
            echo "   • Check ethernet cable to router"
            echo "   • Restart router"
            echo "   • Check if on correct network segment"
        fi
    else
        echo "❌ No gateway configured"
        echo ""
        echo "💡 SOLUTION: Routing configuration issue"
        echo "   • Run network repair tools"
        echo "   • Restart network services"
        echo "   • Check DHCP server configuration"
    fi
}

troubleshoot_vpn_issues() {
    echo ""
    echo "🔍 TROUBLESHOOTING: VPN Connection Problems"
    echo "=========================================="
    echo ""
    
    # Check for VPN software
    local vpn_found=false
    
    # Check WireGuard
    if command -v wg &>/dev/null; then
        echo "🔍 WireGuard detected"
        vpn_found=true
        
        if wg show | grep -q interface; then
            echo "✅ WireGuard is active"
            wg show
        else
            echo "❌ WireGuard not connected"
            echo ""
            echo "💡 WireGuard troubleshooting:"
            echo "   • Check configuration file syntax"
            echo "   • Verify server endpoint is reachable"
            echo "   • Check if port is open in firewall"
            echo "   • Restart WireGuard: sudo systemctl restart wg-quick@<config>"
        fi
    fi
    
    # Check OpenVPN
    if command -v openvpn &>/dev/null || pgrep openvpn >/dev/null; then
        echo "🔍 OpenVPN detected"
        vpn_found=true
        
        if pgrep openvpn >/dev/null; then
            echo "✅ OpenVPN is running"
            local ovpn_config=$(ps aux | grep openvpn | grep -v grep | awk '{print $11}' | head -1)
            echo "   Config: ${ovpn_config:-Unknown}"
        else
            echo "❌ OpenVPN not running"
            echo ""
            echo "💡 OpenVPN troubleshooting:"
            echo "   • Check configuration file path"
            echo "   • Verify certificates are valid"
            echo "   • Check server address and port"
            echo "   • Review OpenVPN logs: journalctl -u openvpn"
        fi
    fi
    
    if [ "$vpn_found" = false ]; then
        echo "❌ No VPN software detected"
        echo ""
        echo "💡 VPN software options:"
        echo "   • Install WireGuard: sudo apt install wireguard"
        echo "   • Install OpenVPN: sudo apt install openvpn"
        echo "   • Use network manager VPN plugins"
        return 1
    fi
    
    # Test VPN connectivity
    echo ""
    echo "🔍 Testing VPN connectivity..."
    
    # Check if VPN interface exists
    local vpn_interfaces=$(ip link show | grep -E "(wg|tun|tap)" | cut -d: -f2 | xargs)
    
    if [ -n "$vpn_interfaces" ]; then
        echo "📡 VPN interfaces: $vpn_interfaces"
        
        for iface in $vpn_interfaces; do
            local vpn_ip=$(ip addr show "$iface" | grep 'inet ' | awk '{print $2}' | head -1)
            if [ -n "$vpn_ip" ]; then
                echo "   $iface: $vpn_ip"
            fi
        done
    else
        echo "❌ No VPN interfaces found"
        echo ""
        echo "💡 VPN interface issues:"
        echo "   • VPN may not be properly connected"
        echo "   • Check VPN service status"
        echo "   • Restart VPN connection"
    fi
    
    # Test external IP
    echo ""
    echo "🔍 Checking external IP address..."
    
    local external_ip=$(curl -s --connect-timeout 10 ifconfig.me 2>/dev/null || curl -s --connect-timeout 10 ipinfo.io/ip 2>/dev/null)
    
    if [ -n "$external_ip" ]; then
        echo "🌐 External IP: $external_ip"
        echo ""
        echo "💡 Verify this IP matches your VPN server location"
        echo "   Use https://whatismyipaddress.com to check location"
    else
        echo "❌ Cannot determine external IP"
        echo ""
        echo "💡 Connectivity issues:"
        echo "   • VPN may be blocking all traffic"
        echo "   • Check VPN kill switch settings"
        echo "   • Try disconnecting VPN temporarily"
    fi
    
    # Common VPN troubleshooting
    echo ""
    echo "💡 Common VPN troubleshooting steps:"
    echo "   • Restart VPN service/application"
    echo "   • Try different VPN server location"
    echo "   • Check firewall isn't blocking VPN"
    echo "   • Verify DNS is working through VPN"
    echo "   • Test without VPN to isolate issue"
    echo "   • Check VPN provider's status page"
}

security_audit() {
    print_header
    echo -e "\033[38;5;129m🛡️ SECURITY AUDIT CENTER\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🔒 Comprehensive network security assessment and vulnerability scanning"
    echo "• Network configuration security analysis"
    echo "• Firewall and access control audit"
    echo "• Open port detection and analysis"
    echo "• VPN and encryption status review"
    echo ""
    
    echo "📋 Security Audit Options:"
    echo "1) Quick security scan (recommended)"
    echo "2) Firewall configuration audit"
    echo "3) Network vulnerability scan"
    echo "4) Wi-Fi security assessment"
    echo "5) Comprehensive security report"
    echo ""
    
    read -p "Select audit type (1-5): " audit_choice
    
    case "$audit_choice" in
        1)
            echo "🔍 Quick Security Scan"
            echo "===================="
            echo ""
            
            # Check firewall status
            echo "🛡️  Firewall Status:"
            if command -v ufw &>/dev/null; then
                local ufw_status=$(sudo ufw status | head -1)
                echo "   UFW: $ufw_status"
                if [[ $ufw_status =~ inactive ]]; then
                    echo "   ⚠️ WARNING: Firewall is disabled"
                else
                    echo "   ✅ Firewall is active"
                fi
            else
                echo "   ⚠️ No firewall management tool found"
            fi
            
            # Check for open ports
            echo ""
            echo "🔌 Open Ports Scan:"
            if command -v ss &>/dev/null; then
                echo "   Listening services:"
                ss -tlnp | grep LISTEN | head -5 | while read -r line; do
                    local port=$(echo "$line" | awk '{print $4}' | cut -d: -f2)
                    local service=$(echo "$line" | awk '{print $6}' | cut -d'"' -f2 2>/dev/null || echo "unknown")
                    echo "   • Port $port: $service"
                done
            fi
            
            # Check VPN status
            echo ""
            echo "🔐 VPN Security:"
            if command -v wg &>/dev/null && wg show | grep -q interface; then
                echo "   ✅ WireGuard VPN active"
            elif pgrep openvpn >/dev/null; then
                echo "   ✅ OpenVPN active"
            else
                echo "   ⚠️ No VPN detected - consider using VPN for enhanced privacy"
            fi
            
            # Check SSH configuration
            echo ""
            echo "🔑 SSH Security:"
            if systemctl is-active ssh >/dev/null 2>&1; then
                echo "   🔍 SSH service is running"
                
                # Check for key-based authentication
                if grep -q "PasswordAuthentication no" /etc/ssh/sshd_config 2>/dev/null; then
                    echo "   ✅ Password authentication disabled (secure)"
                else
                    echo "   ⚠️ Password authentication enabled (less secure)"
                fi
                
                # Check SSH port
                local ssh_port=$(grep "^Port" /etc/ssh/sshd_config 2>/dev/null | awk '{print $2}')
                if [ -n "$ssh_port" ] && [ "$ssh_port" != "22" ]; then
                    echo "   ✅ SSH running on non-default port: $ssh_port"
                else
                    echo "   ⚠️ SSH running on default port 22"
                fi
            else
                echo "   ✅ SSH service not running"
            fi
            
            echo ""
            echo "📊 Security Score Summary:"
            echo "========================="
            
            local score=0
            local max_score=5
            
            # Score firewall
            if command -v ufw &>/dev/null && sudo ufw status | grep -q "Status: active"; then
                score=$((score + 1))
                echo "✅ Firewall active (+1 point)"
            else
                echo "❌ Firewall inactive (0 points)"
            fi
            
            # Score VPN
            if (command -v wg &>/dev/null && wg show | grep -q interface) || pgrep openvpn >/dev/null; then
                score=$((score + 1))
                echo "✅ VPN active (+1 point)"
            else
                echo "❌ No VPN detected (0 points)"
            fi
            
            # Score SSH security
            if ! systemctl is-active ssh >/dev/null 2>&1; then
                score=$((score + 1))
                echo "✅ SSH disabled (+1 point)"
            elif grep -q "PasswordAuthentication no" /etc/ssh/sshd_config 2>/dev/null; then
                score=$((score + 1))
                echo "✅ SSH password auth disabled (+1 point)"
            else
                echo "❌ SSH security could be improved (0 points)"
            fi
            
            # Score open ports (fewer is better)
            local open_ports=$(ss -tln | grep LISTEN | wc -l)
            if [ "$open_ports" -lt 5 ]; then
                score=$((score + 1))
                echo "✅ Limited open ports (+1 point)"
            else
                echo "⚠️ Many open ports detected (0 points)"
            fi
            
            # Score DNS over TLS
            if grep -q "DNSOverTLS=yes" /etc/systemd/resolved.conf 2>/dev/null; then
                score=$((score + 1))
                echo "✅ DNS over TLS enabled (+1 point)"
            else
                echo "❌ DNS over TLS not configured (0 points)"
            fi
            
            echo ""
            echo "🎯 Security Score: $score/$max_score"
            
            if [ $score -ge 4 ]; then
                echo "🎉 Excellent security posture!"
            elif [ $score -ge 3 ]; then
                echo "✅ Good security with room for improvement"
            elif [ $score -ge 2 ]; then
                echo "⚠️ Fair security - consider implementing more protections"
            else
                echo "❌ Poor security - immediate attention recommended"
            fi
            ;;
            
        2)
            echo "🔥 Firewall Configuration Audit"
            echo "==============================="
            echo ""
            
            run_firewall_audit
            ;;
            
        3)
            echo "🔍 Network Vulnerability Scan"
            echo "============================"
            echo ""
            
            run_vulnerability_scan
            ;;
            
        4)
            echo "📶 Wi-Fi Security Assessment"
            echo "==========================="
            echo ""
            
            run_wifi_security_audit
            ;;
            
        5)
            echo "📋 Comprehensive Security Report"
            echo "==============================="
            echo ""
            
            generate_security_report
            ;;
            
        *)
            echo "❌ Invalid selection"
            ;;
    esac
    
    collect_feedback "network_diagnostics" "security_audit"
}

run_firewall_audit() {
    echo "🔍 Analyzing firewall configuration..."
    
    if command -v ufw &>/dev/null; then
        echo "📋 UFW Firewall Analysis:"
        
        local ufw_status=$(sudo ufw status verbose)
        echo "$ufw_status"
        
        echo ""
        echo "🔍 Security Assessment:"
        
        if echo "$ufw_status" | grep -q "Status: active"; then
            echo "✅ Firewall is active"
            
            # Check default policies
            local default_incoming=$(echo "$ufw_status" | grep "Default:" | head -1 | awk '{print $3}')
            local default_outgoing=$(echo "$ufw_status" | grep "Default:" | head -1 | awk '{print $5}')
            
            if [ "$default_incoming" = "deny" ]; then
                echo "✅ Default incoming policy: deny (secure)"
            else
                echo "⚠️ Default incoming policy: $default_incoming (potentially insecure)"
            fi
            
            if [ "$default_outgoing" = "allow" ]; then
                echo "✅ Default outgoing policy: allow (normal)"
            else
                echo "ℹ️ Default outgoing policy: $default_outgoing"
            fi
            
            # Analyze rules
            local rule_count=$(sudo ufw status numbered | grep -c "^\[")
            echo "📊 Active rules: $rule_count"
            
            if [ $rule_count -eq 0 ]; then
                echo "⚠️ No custom rules configured - all traffic blocked by default"
            fi
        else
            echo "❌ Firewall is inactive - system is exposed"
            echo ""
            echo "💡 Recommendations:"
            echo "   • Enable firewall: sudo ufw enable"
            echo "   • Configure basic rules for SSH if needed"
            echo "   • Set restrictive default policies"
        fi
    else
        echo "❌ UFW not installed"
        echo ""
        echo "💡 Install UFW firewall:"
        echo "   sudo apt update && sudo apt install ufw"
    fi
}

run_vulnerability_scan() {
    echo "🔍 Scanning for network vulnerabilities..."
    echo ""
    
    # Check for common vulnerabilities
    echo "1. Checking for open ports..."
    if command -v nmap &>/dev/null; then
        local local_ip=$(ip addr show $(ip route | awk '/default/ { print $5 }' | head -1) | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
        echo "   Scanning local IP: $local_ip"
        nmap -sT -O "$local_ip" 2>/dev/null | grep -E "(open|filtered)"
    else
        echo "   Installing nmap for vulnerability scanning..."
        sudo apt update && sudo apt install -y nmap 2>/dev/null
    fi
    
    echo ""
    echo "2. Checking for weak SSH configuration..."
    if systemctl is-active ssh >/dev/null 2>&1; then
        echo "   SSH service detected"
        
        # Check SSH version
        local ssh_version=$(ssh -V 2>&1 | head -1)
        echo "   Version: $ssh_version"
        
        # Check for weak settings
        if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config 2>/dev/null; then
            echo "   ❌ Root login permitted (high risk)"
        else
            echo "   ✅ Root login restricted"
        fi
        
        if grep -q "PasswordAuthentication yes" /etc/ssh/sshd_config 2>/dev/null; then
            echo "   ⚠️ Password authentication enabled"
        else
            echo "   ✅ Password authentication disabled"
        fi
    fi
    
    echo ""
    echo "3. Checking for network information disclosure..."
    
    # Check if system responds to broadcast pings
    local broadcast_ip=$(ip route | grep 'scope link' | awk '{print $1}' | grep -v '169.254' | head -1 | sed 's/\/[0-9]*$/255/')
    if [ -n "$broadcast_ip" ]; then
        echo "   Testing broadcast ping response..."
        if ping -c 2 -W 1 "$broadcast_ip" >/dev/null 2>&1; then
            echo "   ⚠️ System responds to broadcast pings"
        else
            echo "   ✅ Broadcast ping ignored"
        fi
    fi
    
    echo ""
    echo "💡 Vulnerability scan complete"
    echo "   Review findings above and address any security issues"
}

run_wifi_security_audit() {
    local wifi_interface=$(iwconfig 2>/dev/null | grep -E '^wl|^wlan' | cut -d' ' -f1 | head -1)
    
    if [ -z "$wifi_interface" ]; then
        echo "❌ No Wi-Fi interface found"
        return 1
    fi
    
    echo "📡 Wi-Fi Security Assessment for: $wifi_interface"
    echo ""
    
    # Check current connection
    local current_ssid=$(iwconfig "$wifi_interface" 2>/dev/null | grep "ESSID" | cut -d'"' -f2)
    
    if [ -n "$current_ssid" ] && [ "$current_ssid" != "off/any" ]; then
        echo "🔍 Current Connection: $current_ssid"
        
        # Check encryption
        local encryption=$(iwconfig "$wifi_interface" 2>/dev/null | grep "Encryption key" | cut -d':' -f2)
        if [[ $encryption == *"off"* ]]; then
            echo "❌ CRITICAL: No encryption detected"
        else
            echo "✅ Encryption enabled"
        fi
        
        # Check signal strength
        local signal=$(iwconfig "$wifi_interface" 2>/dev/null | grep "Signal level" | awk -F'=' '{print $3}' | awk '{print $1}')
        echo "📶 Signal strength: ${signal:-Unknown}"
    else
        echo "❌ Not connected to any Wi-Fi network"
    fi
    
    echo ""
    echo "🔍 Scanning nearby networks for security analysis..."
    
    if command -v nmcli &>/dev/null; then
        nmcli device wifi list | while IFS= read -r line; do
            if [[ $line == *"WPA"* ]]; then
                local ssid=$(echo "$line" | awk '{print $2}')
                echo "✅ $ssid: WPA/WPA2 secured"
            elif [[ $line == *"WEP"* ]]; then
                local ssid=$(echo "$line" | awk '{print $2}')
                echo "⚠️ $ssid: WEP encryption (weak)"
            elif [[ $line == *"--"* ]] && [[ $line != *"SSID"* ]]; then
                local ssid=$(echo "$line" | awk '{print $2}')
                echo "❌ $ssid: Open network (no security)"
            fi
        done
    fi
    
    echo ""
    echo "💡 Wi-Fi Security Recommendations:"
    echo "   • Use WPA3 or WPA2 encryption only"
    echo "   • Avoid connecting to open networks"
    echo "   • Use VPN on public Wi-Fi"
    echo "   • Regularly update Wi-Fi passwords"
}

generate_security_report() {
    echo "📋 Generating comprehensive security report..."
    echo ""
    
    local report_file="$NETWORK_CONFIG_DIR/security_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "NETWORK SECURITY REPORT"
        echo "======================="
        echo "Generated: $(date)"
        echo ""
        
        echo "SYSTEM INFORMATION"
        echo "------------------"
        echo "Hostname: $(hostname)"
        echo "OS: $(lsb_release -d 2>/dev/null | cut -f2 || uname -s)"
        echo "Kernel: $(uname -r)"
        echo ""
        
        echo "NETWORK INTERFACES"
        echo "------------------"
        ip addr show | grep -E "^[0-9]+:|inet " | while read -r line; do
            if [[ $line =~ ^[0-9]+: ]]; then
                echo "$line"
            elif [[ $line =~ inet ]]; then
                echo "  $line"
            fi
        done
        echo ""
        
        echo "FIREWALL STATUS"
        echo "---------------"
        if command -v ufw &>/dev/null; then
            sudo ufw status verbose
        else
            echo "No UFW firewall detected"
        fi
        echo ""
        
        echo "OPEN PORTS"
        echo "----------"
        if command -v ss &>/dev/null; then
            ss -tlnp | grep LISTEN
        fi
        echo ""
        
        echo "VPN STATUS"
        echo "----------"
        if command -v wg &>/dev/null && wg show | grep -q interface; then
            echo "WireGuard VPN: Active"
            wg show
        elif pgrep openvpn >/dev/null; then
            echo "OpenVPN: Active"
        else
            echo "No VPN detected"
        fi
        echo ""
        
        echo "SSH CONFIGURATION"
        echo "-----------------"
        if systemctl is-active ssh >/dev/null 2>&1; then
            echo "SSH Status: Active"
            grep -E "^(Port|PermitRootLogin|PasswordAuthentication)" /etc/ssh/sshd_config 2>/dev/null || echo "Default settings"
        else
            echo "SSH Status: Inactive"
        fi
        
    } > "$report_file"
    
    echo "✅ Security report generated: $report_file"
    echo ""
    echo "📋 Report Summary:"
    echo "   • System and network configuration"
    echo "   • Firewall and security status"
    echo "   • Open ports and services"
    echo "   • VPN and encryption status"
    echo "   • SSH security configuration"
    
    echo ""
    if confirm "View the report now?"; then
        less "$report_file"
    fi
}

# Main menu loop
main() {
    while true; do
        show_menu
        read -p "🎯 Choose your diagnostic mission (0-4): " choice
        
        case $choice in
            1) run_comprehensive_analysis ;;
            2) network_repair_tools ;;
            3) connection_troubleshooter ;;
            4) security_audit ;;
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