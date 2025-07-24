#!/bin/bash
# LLM_CAPABILITY: local_ok
# Interactive Network Optimization - Performance tuning and enhancement
# Part of the Bill Sloth neurodivergent-optimized automation system

source "$(dirname "$0")/../lib/include_loader.sh"
load_includes "core" "notification" "adaptive_learning" "data_persistence" "error_handling" "system_info"

# Configuration and constants
NETWORK_CONFIG_DIR="$HOME/.config/network-optimization"
OPTIMIZATION_LOG="$NETWORK_CONFIG_DIR/optimization.log"

# Ensure directories exist
mkdir -p "$NETWORK_CONFIG_DIR"

show_ascii_header() {
    echo -e "\033[38;5;226m"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════════════════╗
    ║  ⚡ NETWORK OPTIMIZATION COMMAND CENTER ⚡                              ║  
    ║  ═══════════════════════════════════════════════════════════════════    ║
    ║  🚀 Maximize network performance and minimize latency                   ║
    ║  🔧 DNS optimization for faster web browsing                            ║
    ║  📈 TCP/IP tuning for better throughput                                 ║
    ║  🎮 Gaming and streaming optimization modes                             ║
    ╚══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "\033[0m"
}

print_header() {
    clear
    show_ascii_header
    echo -e "\033[38;5;51m💀 Master Shake: \"I'm optimizing the network with my mind!\" 🧠\033[0m"
    echo -e "\033[38;5;82m🧠 Frylock: \"That's not how networks work, Shake.\"\033[0m"
    echo ""
}

show_menu() {
    print_header
    echo -e "\033[38;5;46m🎯 SELECT YOUR OPTIMIZATION MISSION:\033[0m"
    echo ""
    echo -e "\033[38;5;51m1. 🌐 DNS Optimization\033[0m - Faster web browsing and name resolution"
    echo -e "\033[38;5;82m2. ⚡ Performance Tuning\033[0m - TCP/IP and system optimization"
    echo -e "\033[38;5;226m3. 🎮 Gaming Mode\033[0m - Low-latency optimization for gaming"
    echo -e "\033[38;5;129m4. 📊 Bandwidth Management\033[0m - QoS and traffic shaping"
    echo ""
    echo -e "\033[38;5;240m0. ← Return to Main Menu\033[0m"
    echo ""
    echo -e "\033[38;5;196m💀 Carl: \"I don't need no optimization, I got premium cable!\" 📺\033[0m"
    echo ""
}

optimize_dns() {
    print_header
    echo -e "\033[38;5;51m🌐 DNS OPTIMIZATION CENTER\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🚀 DNS Optimization - Faster web browsing and name resolution"
    echo "• Configure fast DNS servers (Cloudflare, Google, Quad9)"
    echo "• Enable DNS caching and DNSSEC validation"
    echo "• Set up DNS-over-TLS for security"
    echo "• Test and benchmark DNS performance"
    echo ""
    
    echo "📋 DNS Optimization Options:"
    echo "1) Quick setup with fast DNS servers"
    echo "2) Advanced DNS configuration"
    echo "3) Local DNS caching server"
    echo "4) DNS benchmark and testing"
    echo "5) Reset to default DNS"
    echo ""
    
    read -p "Select option (1-5): " dns_choice
    
    case "$dns_choice" in
        1)
            echo "🔄 Quick DNS Setup"
            echo "=================="
            echo ""
            
            # Backup current DNS settings
            local backup_dir="$NETWORK_CONFIG_DIR/backups/$(date +%Y%m%d-%H%M%S)"
            mkdir -p "$backup_dir"
            
            if [ -f /etc/resolv.conf ]; then
                sudo cp /etc/resolv.conf "$backup_dir/resolv.conf.backup"
            fi
            
            echo "📋 Configuring fast DNS servers:"
            echo "• Primary: 1.1.1.1 (Cloudflare)"
            echo "• Secondary: 8.8.8.8 (Google)"
            echo "• Tertiary: 9.9.9.9 (Quad9)"
            echo ""
            
            # Configure DNS based on system
            if command -v systemd-resolve &>/dev/null; then
                echo "🔧 Configuring systemd-resolved..."
                sudo tee /etc/systemd/resolved.conf > /dev/null <<EOF
[Resolve]
DNS=1.1.1.1 8.8.8.8 9.9.9.9
FallbackDNS=208.67.222.222 208.67.220.220
Cache=yes
DNSSEC=yes
DNSOverTLS=yes
EOF
                sudo systemctl restart systemd-resolved
                
            elif command -v nmcli &>/dev/null; then
                echo "🔧 Configuring NetworkManager..."
                local connection=$(nmcli connection show --active | grep -v NAME | head -1 | awk '{print $1}')
                if [ -n "$connection" ]; then
                    nmcli connection modify "$connection" ipv4.dns "1.1.1.1 8.8.8.8"
                    nmcli connection modify "$connection" ipv6.dns "2606:4700:4700::1111 2001:4860:4860::8888"
                    nmcli connection up "$connection"
                fi
            else
                echo "🔧 Configuring /etc/resolv.conf..."
                echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf
                echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf
                echo "nameserver 9.9.9.9" | sudo tee -a /etc/resolv.conf
            fi
            
            echo ""
            echo "🔍 Testing DNS resolution speed:"
            test_dns_performance
            
            echo ""
            echo "✅ DNS optimization complete!"
            notify_success "DNS Optimization" "Fast DNS servers configured"
            ;;
            
        2)
            echo "🔧 Advanced DNS Configuration"
            echo "============================"
            echo ""
            
            echo "Select DNS provider:"
            echo "1) Cloudflare (1.1.1.1) - Fast & Privacy-focused"
            echo "2) Google (8.8.8.8) - Fast & Reliable"
            echo "3) Quad9 (9.9.9.9) - Security-focused"
            echo "4) OpenDNS (208.67.222.222) - Family-safe options"
            echo "5) Custom DNS servers"
            
            read -p "Select provider (1-5): " provider_choice
            
            case "$provider_choice" in
                1)
                    local primary="1.1.1.1"
                    local secondary="1.0.0.1"
                    local ipv6_primary="2606:4700:4700::1111"
                    local ipv6_secondary="2606:4700:4700::1001"
                    ;;
                2)
                    local primary="8.8.8.8"
                    local secondary="8.8.4.4"
                    local ipv6_primary="2001:4860:4860::8888"
                    local ipv6_secondary="2001:4860:4860::8844"
                    ;;
                3)
                    local primary="9.9.9.9"
                    local secondary="149.112.112.112"
                    local ipv6_primary="2620:fe::fe"
                    local ipv6_secondary="2620:fe::9"
                    ;;
                4)
                    local primary="208.67.222.222"
                    local secondary="208.67.220.220"
                    local ipv6_primary="2620:119:35::35"
                    local ipv6_secondary="2620:119:53::53"
                    ;;
                5)
                    read -p "Enter primary DNS server: " primary
                    read -p "Enter secondary DNS server: " secondary
                    read -p "Enter IPv6 primary (optional): " ipv6_primary
                    read -p "Enter IPv6 secondary (optional): " ipv6_secondary
                    ;;
            esac
            
            echo ""
            echo "Additional options:"
            read -p "Enable DNSSEC validation? (y/n): " enable_dnssec
            read -p "Enable DNS-over-TLS? (y/n): " enable_dot
            read -p "Enable DNS caching? (y/n): " enable_cache
            
            # Apply advanced configuration
            configure_advanced_dns "$primary" "$secondary" "$ipv6_primary" "$ipv6_secondary" "$enable_dnssec" "$enable_dot" "$enable_cache"
            
            echo ""
            echo "✅ Advanced DNS configuration applied!"
            ;;
            
        3)
            echo "🖥️ Local DNS Caching Server"
            echo "=========================="
            echo ""
            echo "Setting up local DNS cache for ultra-fast resolution..."
            
            echo "📥 Installing dnsmasq..."
            sudo apt update && sudo apt install -y dnsmasq
            
            # Configure dnsmasq
            sudo tee /etc/dnsmasq.d/cache.conf > /dev/null <<EOF
# DNS cache configuration
cache-size=1000
no-negcache
domain-needed
bogus-priv

# Upstream DNS servers
server=1.1.1.1
server=8.8.8.8
server=9.9.9.9

# Local network optimization
local-ttl=300
EOF
            
            # Restart dnsmasq
            sudo systemctl restart dnsmasq
            sudo systemctl enable dnsmasq
            
            # Point system to local DNS
            echo "nameserver 127.0.0.1" | sudo tee /etc/resolv.conf
            
            echo ""
            echo "✅ Local DNS cache configured!"
            echo "📊 Cache statistics available at: sudo systemctl status dnsmasq"
            ;;
            
        4)
            echo "📊 DNS Benchmark and Testing"
            echo "==========================="
            echo ""
            
            echo "🔍 Testing current DNS performance..."
            test_dns_performance
            
            echo ""
            echo "📊 Comparing DNS providers..."
            benchmark_dns_providers
            
            echo ""
            echo "💡 Recommendations based on your results:"
            analyze_dns_results
            ;;
            
        5)
            echo "🔄 Resetting DNS to Default"
            echo "=========================="
            echo ""
            
            if [ -f "$NETWORK_CONFIG_DIR/backups/*/resolv.conf.backup" ]; then
                local latest_backup=$(ls -t "$NETWORK_CONFIG_DIR/backups/*/resolv.conf.backup" | head -1)
                sudo cp "$latest_backup" /etc/resolv.conf
                echo "✅ DNS settings restored from backup"
            else
                # Reset to DHCP-provided DNS
                if command -v systemd-resolve &>/dev/null; then
                    sudo rm -f /etc/systemd/resolved.conf
                    sudo systemctl restart systemd-resolved
                elif command -v nmcli &>/dev/null; then
                    local connection=$(nmcli connection show --active | grep -v NAME | head -1 | awk '{print $1}')
                    nmcli connection modify "$connection" ipv4.dns ""
                    nmcli connection up "$connection"
                fi
                echo "✅ DNS reset to automatic configuration"
            fi
            ;;
    esac
    
    collect_feedback "network_optimization" "dns_optimization"
}

test_dns_performance() {
    local test_domains=("google.com" "cloudflare.com" "github.com" "amazon.com")
    local total_time=0
    local count=0
    
    for domain in "${test_domains[@]}"; do
        if command -v dig &>/dev/null; then
            local resolve_time=$(dig +noall +stats "$domain" | grep "Query time" | awk '{print $4}')
            if [ -n "$resolve_time" ]; then
                echo "• $domain: ${resolve_time}ms"
                total_time=$((total_time + resolve_time))
                count=$((count + 1))
            fi
        else
            # Fallback to nslookup with time
            local start_time=$(date +%s%N)
            nslookup "$domain" >/dev/null 2>&1
            local end_time=$(date +%s%N)
            local resolve_time=$(( (end_time - start_time) / 1000000 ))
            echo "• $domain: ${resolve_time}ms"
            total_time=$((total_time + resolve_time))
            count=$((count + 1))
        fi
    done
    
    if [ $count -gt 0 ]; then
        local avg_time=$((total_time / count))
        echo ""
        echo "📊 Average resolution time: ${avg_time}ms"
        
        if [ $avg_time -lt 20 ]; then
            echo "🚀 Excellent DNS performance!"
        elif [ $avg_time -lt 50 ]; then
            echo "✅ Good DNS performance"
        else
            echo "⚠️ DNS performance could be improved"
        fi
    fi
}

benchmark_dns_providers() {
    local dns_servers=(
        "1.1.1.1:Cloudflare"
        "8.8.8.8:Google"
        "9.9.9.9:Quad9"
        "208.67.222.222:OpenDNS"
    )
    
    echo "Testing multiple DNS providers..."
    echo "================================="
    
    for server_info in "${dns_servers[@]}"; do
        local server=$(echo "$server_info" | cut -d: -f1)
        local name=$(echo "$server_info" | cut -d: -f2)
        
        echo ""
        echo "Testing $name ($server):"
        
        if command -v dig &>/dev/null; then
            local total_time=0
            local test_count=3
            
            for i in $(seq 1 $test_count); do
                local time=$(dig @"$server" google.com +noall +stats | grep "Query time" | awk '{print $4}')
                if [ -n "$time" ]; then
                    total_time=$((total_time + time))
                fi
            done
            
            if [ $total_time -gt 0 ]; then
                local avg_time=$((total_time / test_count))
                echo "Average query time: ${avg_time}ms"
            fi
        fi
    done
}

configure_advanced_dns() {
    local primary="$1"
    local secondary="$2"
    local ipv6_primary="$3"
    local ipv6_secondary="$4"
    local enable_dnssec="$5"
    local enable_dot="$6"
    local enable_cache="$7"
    
    if command -v systemd-resolve &>/dev/null; then
        # Create systemd-resolved configuration
        {
            echo "[Resolve]"
            echo "DNS=$primary $secondary"
            [ -n "$ipv6_primary" ] && echo "DNS=$ipv6_primary $ipv6_secondary"
            echo "FallbackDNS=1.1.1.1 8.8.8.8"
            
            [ "$enable_cache" = "y" ] && echo "Cache=yes" || echo "Cache=no"
            [ "$enable_dnssec" = "y" ] && echo "DNSSEC=yes" || echo "DNSSEC=no"
            [ "$enable_dot" = "y" ] && echo "DNSOverTLS=yes" || echo "DNSOverTLS=no"
        } | sudo tee /etc/systemd/resolved.conf > /dev/null
        
        sudo systemctl restart systemd-resolved
    fi
}

analyze_dns_results() {
    # Analyze DNS performance and provide recommendations
    local current_dns=$(grep nameserver /etc/resolv.conf 2>/dev/null | head -1 | awk '{print $2}')
    
    echo "Current DNS server: $current_dns"
    echo ""
    echo "Recommendations:"
    echo "• For privacy: Use Cloudflare (1.1.1.1) or Quad9 (9.9.9.9)"
    echo "• For speed: Use Cloudflare (1.1.1.1) or Google (8.8.8.8)"
    echo "• For family safety: Use OpenDNS Family Shield"
    echo "• For maximum speed: Set up local DNS caching"
}

optimize_performance() {
    print_header
    echo -e "\033[38;5;82m⚡ PERFORMANCE TUNING CENTER\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🚀 System Performance Optimization"
    echo "• TCP/IP stack tuning for better throughput"
    echo "• Network buffer optimization"
    echo "• Interface-specific enhancements"
    echo "• Congestion control improvements"
    echo ""
    
    echo "📋 Performance Options:"
    echo "1) Quick performance boost (recommended)"
    echo "2) TCP/IP advanced tuning"
    echo "3) Network interface optimization"
    echo "4) System-wide network tuning"
    echo "5) Restore default settings"
    echo ""
    
    read -p "Select option (1-5): " perf_choice
    
    case "$perf_choice" in
        1)
            echo "🚀 Quick Performance Boost"
            echo "========================="
            echo ""
            
            # Backup current settings
            local backup_file="$NETWORK_CONFIG_DIR/sysctl-backup-$(date +%Y%m%d-%H%M%S).conf"
            sysctl -a 2>/dev/null | grep -E "net\.|vm\." > "$backup_file"
            
            echo "🔧 Applying performance optimizations..."
            
            # Create optimized configuration
            sudo tee /etc/sysctl.d/99-network-performance.conf > /dev/null <<'EOF'
# Network Performance Quick Boost
# TCP Optimizations
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq
net.ipv4.tcp_notsent_lowat = 16384

# Buffer sizes
net.core.rmem_default = 262144
net.core.rmem_max = 16777216
net.core.wmem_default = 262144
net.core.wmem_max = 16777216

# TCP memory
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# Enable TCP optimizations
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_fastopen = 3

# Reduce latency
net.ipv4.tcp_low_latency = 1
EOF
            
            # Apply settings
            sudo sysctl -p /etc/sysctl.d/99-network-performance.conf
            
            echo ""
            echo "✅ Performance optimizations applied!"
            echo "📊 Key improvements:"
            echo "• BBR congestion control enabled"
            echo "• Buffer sizes optimized"
            echo "• TCP Fast Open enabled"
            echo "• Low latency mode activated"
            
            notify_success "Performance" "Network performance optimized"
            ;;
            
        2)
            echo "🔧 TCP/IP Advanced Tuning"
            echo "========================"
            echo ""
            
            echo "Select optimization profile:"
            echo "1) High bandwidth (downloads/streaming)"
            echo "2) Low latency (gaming/video calls)"
            echo "3) Balanced (general use)"
            echo "4) Custom tuning"
            
            read -p "Select profile (1-4): " profile_choice
            
            case "$profile_choice" in
                1) apply_high_bandwidth_profile ;;
                2) apply_low_latency_profile ;;
                3) apply_balanced_profile ;;
                4) custom_tcp_tuning ;;
            esac
            ;;
            
        3)
            echo "🔧 Network Interface Optimization"
            echo "================================"
            echo ""
            
            # Get primary interface
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            echo "Primary interface: $interface"
            echo ""
            
            # Check if ethtool is installed
            if ! command -v ethtool &>/dev/null; then
                echo "📥 Installing ethtool..."
                sudo apt update && sudo apt install -y ethtool
            fi
            
            echo "📊 Current interface settings:"
            sudo ethtool "$interface" 2>/dev/null | grep -E "(Speed|Duplex|Auto-negotiation)" || echo "Unable to read settings"
            echo ""
            
            echo "Optimization options:"
            echo "1) Enable hardware offloading"
            echo "2) Optimize interrupt handling"
            echo "3) Adjust ring buffer sizes"
            echo "4) Auto-optimize all settings"
            
            read -p "Select option (1-4): " iface_choice
            
            case "$iface_choice" in
                1) optimize_hardware_offloading "$interface" ;;
                2) optimize_interrupt_handling "$interface" ;;
                3) optimize_ring_buffers "$interface" ;;
                4) auto_optimize_interface "$interface" ;;
            esac
            ;;
            
        4)
            echo "🌐 System-wide Network Tuning"
            echo "============================"
            echo ""
            
            echo "This will apply comprehensive network optimizations."
            echo "A full backup will be created before changes."
            echo ""
            
            if confirm "Proceed with system-wide optimization?"; then
                apply_comprehensive_optimization
            fi
            ;;
            
        5)
            echo "🔄 Restoring Default Settings"
            echo "============================"
            echo ""
            
            if [ -f /etc/sysctl.d/99-network-performance.conf ]; then
                sudo rm -f /etc/sysctl.d/99-network-performance.conf
                echo "✅ Custom network settings removed"
            fi
            
            # Find most recent backup
            local latest_backup=$(ls -t "$NETWORK_CONFIG_DIR"/sysctl-backup-*.conf 2>/dev/null | head -1)
            if [ -n "$latest_backup" ]; then
                echo "📋 Found backup: $latest_backup"
                echo "Restoring default kernel parameters..."
                sudo sysctl -p /etc/sysctl.conf
                echo "✅ Default settings restored"
            else
                echo "⚠️ No backup found. Running system defaults."
                sudo sysctl -p /etc/sysctl.conf
            fi
            ;;
    esac
    
    collect_feedback "network_optimization" "performance_tuning"
}

apply_high_bandwidth_profile() {
    echo "📈 Applying High Bandwidth Profile..."
    
    sudo tee /etc/sysctl.d/99-high-bandwidth.conf > /dev/null <<'EOF'
# High Bandwidth Profile
# Maximize throughput for downloads and streaming

# Large buffer sizes
net.core.rmem_max = 134217728
net.core.wmem_max = 134217728
net.ipv4.tcp_rmem = 4096 87380 134217728
net.ipv4.tcp_wmem = 4096 65536 134217728

# BBR congestion control
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# Increase netdev budget for high throughput
net.core.netdev_budget = 600
net.core.netdev_max_backlog = 5000

# Enable window scaling
net.ipv4.tcp_window_scaling = 1

# TCP memory settings
net.ipv4.tcp_mem = 786432 1048576 26777216

# Enable SACK
net.ipv4.tcp_sack = 1
net.ipv4.tcp_dsack = 1
net.ipv4.tcp_fack = 1
EOF
    
    sudo sysctl -p /etc/sysctl.d/99-high-bandwidth.conf
    echo "✅ High bandwidth profile applied!"
}

apply_low_latency_profile() {
    echo "⚡ Applying Low Latency Profile..."
    
    sudo tee /etc/sysctl.d/99-low-latency.conf > /dev/null <<'EOF'
# Low Latency Profile
# Minimize latency for gaming and real-time applications

# Smaller buffers for lower latency
net.core.rmem_default = 131072
net.core.rmem_max = 6291456
net.core.wmem_default = 131072
net.core.wmem_max = 4194304

# TCP low latency mode
net.ipv4.tcp_low_latency = 1

# Fast retransmission
net.ipv4.tcp_frto = 2
net.ipv4.tcp_frto_response = 2

# Reduce queue lengths
net.core.netdev_max_backlog = 1000

# Use fq_codel for low latency
net.core.default_qdisc = fq_codel

# Disable slow start after idle
net.ipv4.tcp_slow_start_after_idle = 0

# Enable TCP no delay
net.ipv4.tcp_nodelay = 1
EOF
    
    sudo sysctl -p /etc/sysctl.d/99-low-latency.conf
    echo "✅ Low latency profile applied!"
}

apply_balanced_profile() {
    echo "⚖️ Applying Balanced Profile..."
    
    sudo tee /etc/sysctl.d/99-balanced.conf > /dev/null <<'EOF'
# Balanced Network Profile
# Good performance for general use

# Moderate buffer sizes
net.core.rmem_default = 262144
net.core.rmem_max = 16777216
net.core.wmem_default = 262144
net.core.wmem_max = 16777216

# TCP settings
net.ipv4.tcp_rmem = 4096 87380 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216

# BBR with moderate settings
net.ipv4.tcp_congestion_control = bbr
net.core.default_qdisc = fq

# Balanced queue settings
net.core.netdev_max_backlog = 2000
net.core.netdev_budget = 300

# Standard optimizations
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_timestamps = 1
EOF
    
    sudo sysctl -p /etc/sysctl.d/99-balanced.conf
    echo "✅ Balanced profile applied!"
}

optimize_hardware_offloading() {
    local interface="$1"
    echo "🔧 Enabling hardware offloading for $interface..."
    
    # Try to enable various offloading features
    local features=(
        "rx-checksumming:rx"
        "tx-checksumming:tx"
        "scatter-gather:sg"
        "tcp-segmentation-offload:tso"
        "generic-segmentation-offload:gso"
        "generic-receive-offload:gro"
        "large-receive-offload:lro"
    )
    
    for feature in "${features[@]}"; do
        local name=$(echo "$feature" | cut -d: -f1)
        local flag=$(echo "$feature" | cut -d: -f2)
        
        echo -n "Enabling $name... "
        if sudo ethtool -K "$interface" "$flag" on 2>/dev/null; then
            echo "✅"
        else
            echo "❌ (not supported)"
        fi
    done
    
    echo ""
    echo "✅ Hardware offloading configuration complete!"
}

optimize_ring_buffers() {
    local interface="$1"
    echo "🔧 Optimizing ring buffers for $interface..."
    
    # Get current ring buffer settings
    echo "Current ring buffer settings:"
    sudo ethtool -g "$interface" 2>/dev/null || {
        echo "❌ Unable to read ring buffer settings"
        return 1
    }
    
    echo ""
    read -p "Increase ring buffers to maximum? (y/n): " increase_rings
    
    if [[ "$increase_rings" == "y" ]]; then
        # Get maximum values
        local max_rx=$(sudo ethtool -g "$interface" 2>/dev/null | grep "^RX:" | head -1 | awk '{print $2}')
        local max_tx=$(sudo ethtool -g "$interface" 2>/dev/null | grep "^TX:" | head -1 | awk '{print $2}')
        
        if [ -n "$max_rx" ] && [ -n "$max_tx" ]; then
            echo "Setting RX to $max_rx and TX to $max_tx..."
            sudo ethtool -G "$interface" rx "$max_rx" tx "$max_tx" 2>/dev/null && echo "✅ Ring buffers optimized!" || echo "❌ Failed to set ring buffers"
        fi
    fi
}

auto_optimize_interface() {
    local interface="$1"
    echo "🤖 Auto-optimizing $interface..."
    echo ""
    
    # Enable all beneficial features
    optimize_hardware_offloading "$interface"
    echo ""
    
    # Set ring buffers to maximum
    local max_rx=$(sudo ethtool -g "$interface" 2>/dev/null | grep "^RX:" | head -1 | awk '{print $2}')
    local max_tx=$(sudo ethtool -g "$interface" 2>/dev/null | grep "^TX:" | head -1 | awk '{print $2}')
    
    if [ -n "$max_rx" ] && [ -n "$max_tx" ]; then
        echo "Setting optimal ring buffer sizes..."
        sudo ethtool -G "$interface" rx "$max_rx" tx "$max_tx" 2>/dev/null
    fi
    
    # Set interrupt coalescing for balanced performance
    echo "Configuring interrupt coalescing..."
    sudo ethtool -C "$interface" adaptive-rx on adaptive-tx on 2>/dev/null
    
    echo ""
    echo "✅ Interface auto-optimization complete!"
}

gaming_mode() {
    print_header
    echo -e "\033[38;5;226m🎮 GAMING MODE OPTIMIZATION\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🎮 Gaming Mode - Ultra-low latency configuration"
    echo "• Minimize network latency and jitter"
    echo "• Optimize for real-time packet delivery"
    echo "• Reduce bufferbloat and queue delays"
    echo "• Priority routing for gaming traffic"
    echo ""
    
    echo "📋 Gaming Optimization Options:"
    echo "1) Quick gaming mode (one-click)"
    echo "2) Advanced gaming setup"
    echo "3) Game-specific optimization"
    echo "4) Network priority configuration"
    echo "5) Disable gaming mode"
    echo ""
    
    read -p "Select option (1-5): " gaming_choice
    
    case "$gaming_choice" in
        1)
            echo "🎮 Enabling Quick Gaming Mode..."
            echo "=============================="
            echo ""
            
            # Apply low-latency network settings
            sudo tee /etc/sysctl.d/99-gaming-mode.conf > /dev/null <<'EOF'
# Gaming Mode - Ultra Low Latency
# Minimize latency at all costs

# TCP optimizations for gaming
net.ipv4.tcp_low_latency = 1
net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_fastopen = 3

# Reduce buffer sizes for lower latency
net.core.rmem_default = 131072
net.core.rmem_max = 4194304
net.core.wmem_default = 131072
net.core.wmem_max = 4194304

# Small TCP buffers
net.ipv4.tcp_rmem = 4096 65536 4194304
net.ipv4.tcp_wmem = 4096 32768 4194304

# Fast retransmission
net.ipv4.tcp_frto = 2
net.ipv4.tcp_frto_response = 2

# No slow start after idle
net.ipv4.tcp_slow_start_after_idle = 0

# Reduce queues
net.core.netdev_max_backlog = 500
net.core.netdev_budget = 100

# Use fq_codel for anti-bufferbloat
net.core.default_qdisc = fq_codel

# Disable Nagle's algorithm
net.ipv4.tcp_nodelay = 1
EOF
            
            sudo sysctl -p /etc/sysctl.d/99-gaming-mode.conf
            
            # Configure network interface for low latency
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            
            echo "🔧 Optimizing network interface..."
            # Disable interrupt coalescing
            sudo ethtool -C "$interface" rx-usecs 0 tx-usecs 0 2>/dev/null
            
            # Set txqueuelen to small value
            sudo ip link set dev "$interface" txqueuelen 100
            
            echo ""
            echo "✅ Gaming mode enabled!"
            echo "🎮 Optimizations applied:"
            echo "• TCP low latency mode active"
            echo "• Buffer sizes minimized"
            echo "• Anti-bufferbloat enabled"
            echo "• Interrupt coalescing disabled"
            
            notify_success "Gaming Mode" "Low latency configuration active"
            ;;
            
        2)
            echo "🎮 Advanced Gaming Setup"
            echo "======================="
            echo ""
            
            echo "Select your connection type:"
            echo "1) Ethernet (wired) - Best for gaming"
            echo "2) Wi-Fi 5GHz - Good for gaming"
            echo "3) Wi-Fi 2.4GHz - Needs optimization"
            
            read -p "Connection type (1-3): " conn_type
            
            echo ""
            echo "Select your game type:"
            echo "1) FPS games (CS:GO, Valorant, etc)"
            echo "2) MOBA games (LoL, Dota 2, etc)"
            echo "3) Fighting games (Street Fighter, etc)"
            echo "4) MMO games (WoW, FF14, etc)"
            
            read -p "Game type (1-4): " game_type
            
            # Apply specific optimizations based on selections
            apply_advanced_gaming_setup "$conn_type" "$game_type"
            ;;
            
        3)
            echo "🎯 Game-Specific Optimization"
            echo "============================"
            echo ""
            
            echo "Popular game optimizations:"
            echo "1) Counter-Strike / Valorant"
            echo "2) League of Legends / Dota 2"
            echo "3) Fortnite / Apex Legends"
            echo "4) Call of Duty / Battlefield"
            echo "5) Custom game port configuration"
            
            read -p "Select game (1-5): " game_choice
            
            case "$game_choice" in
                1) optimize_for_csgo ;;
                2) optimize_for_moba ;;
                3) optimize_for_battle_royale ;;
                4) optimize_for_cod ;;
                5) custom_game_ports ;;
            esac
            ;;
            
        4)
            echo "🚦 Network Priority Configuration"
            echo "================================"
            echo ""
            
            echo "This will set up QoS rules to prioritize gaming traffic."
            echo ""
            
            # Install tc if not available
            if ! command -v tc &>/dev/null; then
                echo "📥 Installing traffic control tools..."
                sudo apt update && sudo apt install -y iproute2
            fi
            
            setup_gaming_qos
            ;;
            
        5)
            echo "🔄 Disabling Gaming Mode"
            echo "======================="
            echo ""
            
            if [ -f /etc/sysctl.d/99-gaming-mode.conf ]; then
                sudo rm -f /etc/sysctl.d/99-gaming-mode.conf
                echo "✅ Gaming mode configuration removed"
            fi
            
            # Reset to balanced settings
            apply_balanced_profile
            
            echo "✅ Gaming mode disabled"
            echo "📊 Network settings restored to balanced profile"
            ;;
    esac
    
    collect_feedback "network_optimization" "gaming_mode"
}

apply_advanced_gaming_setup() {
    local conn_type="$1"
    local game_type="$2"
    
    echo "🔧 Applying advanced gaming optimizations..."
    echo ""
    
    # Connection-specific optimizations
    case "$conn_type" in
        1) # Ethernet
            echo "📡 Optimizing wired connection..."
            local interface=$(ip link | grep -E "^[0-9]+: (en|eth)" | head -1 | cut -d: -f2 | xargs)
            if [ -n "$interface" ]; then
                sudo ethtool -C "$interface" rx-usecs 0 tx-usecs 0 2>/dev/null
                sudo ip link set dev "$interface" txqueuelen 50
            fi
            ;;
        2|3) # Wi-Fi
            echo "📶 Optimizing wireless connection..."
            # Disable power saving
            local wifi_interface=$(ip link | grep -E "^[0-9]+: wl" | head -1 | cut -d: -f2 | xargs)
            if [ -n "$wifi_interface" ]; then
                sudo iw dev "$wifi_interface" set power_save off 2>/dev/null
            fi
            ;;
    esac
    
    # Game-type specific optimizations
    case "$game_type" in
        1) # FPS
            echo "🎯 FPS optimization: Ultra-low latency"
            echo "net.ipv4.tcp_nodelay = 1" | sudo tee -a /etc/sysctl.d/99-gaming-mode.conf
            ;;
        2) # MOBA
            echo "⚔️ MOBA optimization: Stable low latency"
            echo "net.ipv4.tcp_keepalive_time = 600" | sudo tee -a /etc/sysctl.d/99-gaming-mode.conf
            ;;
        3) # Fighting
            echo "🥊 Fighting game optimization: Frame-perfect timing"
            echo "net.core.busy_poll = 50" | sudo tee -a /etc/sysctl.d/99-gaming-mode.conf
            ;;
        4) # MMO
            echo "🌍 MMO optimization: Stable connection"
            echo "net.ipv4.tcp_keepalive_intvl = 30" | sudo tee -a /etc/sysctl.d/99-gaming-mode.conf
            ;;
    esac
    
    sudo sysctl -p /etc/sysctl.d/99-gaming-mode.conf 2>/dev/null
    
    echo ""
    echo "✅ Advanced gaming setup complete!"
}

optimize_for_csgo() {
    echo "🎯 Optimizing for Counter-Strike / Valorant..."
    echo ""
    
    # CS:GO and Valorant specific settings
    echo "Recommended in-game settings:"
    echo "• Rate: 786432"
    echo "• cl_interp: 0"
    echo "• cl_interp_ratio: 1"
    echo "• cl_updaterate: 128"
    echo "• cl_cmdrate: 128"
    echo ""
    
    # Network optimizations
    echo "Applying network optimizations..."
    echo "net.ipv4.tcp_nodelay = 1" | sudo tee -a /etc/sysctl.d/99-gaming-mode.conf
    echo "net.ipv4.tcp_quickack = 1" | sudo tee -a /etc/sysctl.d/99-gaming-mode.conf
    sudo sysctl -p /etc/sysctl.d/99-gaming-mode.conf 2>/dev/null
    
    echo "✅ CS:GO/Valorant optimizations applied!"
}

setup_gaming_qos() {
    echo "🚦 Setting up Gaming QoS..."
    echo ""
    
    local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
    
    echo "This will prioritize gaming traffic on interface: $interface"
    echo ""
    
    # Get bandwidth information
    read -p "Enter your download speed in Mbps: " download_speed
    read -p "Enter your upload speed in Mbps: " upload_speed
    
    # Calculate 90% of bandwidth for QoS
    local download_limit=$(( download_speed * 900 ))
    local upload_limit=$(( upload_speed * 900 ))
    
    echo ""
    echo "🔧 Configuring QoS with HTB..."
    
    # Clear existing qdiscs
    sudo tc qdisc del dev "$interface" root 2>/dev/null
    
    # Create HTB qdisc
    sudo tc qdisc add dev "$interface" root handle 1: htb default 30
    
    # Create classes
    sudo tc class add dev "$interface" parent 1: classid 1:1 htb rate "${upload_limit}kbit"
    sudo tc class add dev "$interface" parent 1:1 classid 1:10 htb rate "${upload_limit}kbit" prio 1  # Gaming
    sudo tc class add dev "$interface" parent 1:1 classid 1:20 htb rate "$((upload_limit/2))kbit" prio 2  # Normal
    sudo tc class add dev "$interface" parent 1:1 classid 1:30 htb rate "$((upload_limit/4))kbit" prio 3  # Bulk
    
    # Add fq_codel to each class
    sudo tc qdisc add dev "$interface" parent 1:10 fq_codel
    sudo tc qdisc add dev "$interface" parent 1:20 fq_codel
    sudo tc qdisc add dev "$interface" parent 1:30 fq_codel
    
    echo ""
    echo "Enter gaming device IP (or press Enter to use this device):"
    read -p "Gaming device IP: " gaming_ip
    
    if [ -z "$gaming_ip" ]; then
        gaming_ip=$(ip addr show "$interface" | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)
    fi
    
    # Create filters for gaming traffic
    if [ -n "$gaming_ip" ]; then
        # Prioritize all traffic from gaming device
        sudo tc filter add dev "$interface" parent 1: protocol ip prio 1 u32 match ip src "$gaming_ip" flowid 1:10
        
        # Common game ports
        local game_ports="27015 3074 3478 3479 3658 5060 5062 5222 6672 9306 9307"
        
        for port in $game_ports; do
            sudo tc filter add dev "$interface" parent 1: protocol ip prio 1 u32 match ip sport "$port" 0xffff flowid 1:10
            sudo tc filter add dev "$interface" parent 1: protocol ip prio 1 u32 match ip dport "$port" 0xffff flowid 1:10
        done
    fi
    
    echo ""
    echo "✅ Gaming QoS configured!"
    echo "🎮 Gaming traffic will be prioritized"
    echo "📊 Bandwidth limits: ${download_speed}/${upload_speed} Mbps"
}

bandwidth_management() {
    print_header
    echo -e "\033[38;5;129m📊 BANDWIDTH MANAGEMENT CENTER\033[0m"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "📊 Bandwidth Management and QoS"
    echo "• Traffic shaping and prioritization"
    echo "• Application-based bandwidth limits"
    echo "• Fair queuing for multiple users"
    echo "• Bufferbloat prevention"
    echo ""
    
    echo "📋 Management Options:"
    echo "1) Simple bandwidth limiting"
    echo "2) Application-based QoS"
    echo "3) Multi-user fair sharing"
    echo "4) Advanced traffic shaping"
    echo "5) Remove all limits"
    echo ""
    
    read -p "Select option (1-5): " bw_choice
    
    case "$bw_choice" in
        1)
            echo "📊 Simple Bandwidth Limiting"
            echo "=========================="
            echo ""
            
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            
            echo "This will set bandwidth limits for interface: $interface"
            echo ""
            
            read -p "Enter download limit in Mbps (0 for unlimited): " dl_limit
            read -p "Enter upload limit in Mbps (0 for unlimited): " ul_limit
            
            if [ "$dl_limit" -gt 0 ] || [ "$ul_limit" -gt 0 ]; then
                setup_simple_bandwidth_limit "$interface" "$dl_limit" "$ul_limit"
            else
                echo "No limits set."
            fi
            ;;
            
        2)
            echo "🎯 Application-based QoS"
            echo "======================="
            echo ""
            
            echo "Select priority scheme:"
            echo "1) Video conferencing priority (Zoom, Teams, etc)"
            echo "2) Streaming priority (Netflix, YouTube, etc)"
            echo "3) Work priority (SSH, RDP, VPN)"
            echo "4) Custom application rules"
            
            read -p "Select scheme (1-4): " app_choice
            
            case "$app_choice" in
                1) setup_video_conf_priority ;;
                2) setup_streaming_priority ;;
                3) setup_work_priority ;;
                4) setup_custom_app_rules ;;
            esac
            ;;
            
        3)
            echo "👥 Multi-user Fair Sharing"
            echo "========================="
            echo ""
            
            setup_fair_queuing
            ;;
            
        4)
            echo "🔧 Advanced Traffic Shaping"
            echo "=========================="
            echo ""
            
            advanced_traffic_shaping_menu
            ;;
            
        5)
            echo "🗑️ Removing All Bandwidth Limits"
            echo "================================"
            echo ""
            
            local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
            
            # Remove all qdiscs
            sudo tc qdisc del dev "$interface" root 2>/dev/null
            sudo tc qdisc del dev "$interface" ingress 2>/dev/null
            
            echo "✅ All bandwidth limits removed"
            echo "📊 Network traffic is now unrestricted"
            ;;
    esac
    
    collect_feedback "network_optimization" "bandwidth_management"
}

setup_simple_bandwidth_limit() {
    local interface="$1"
    local download_mbps="$2"
    local upload_mbps="$3"
    
    echo "🔧 Setting up bandwidth limits..."
    echo ""
    
    # Clear existing rules
    sudo tc qdisc del dev "$interface" root 2>/dev/null
    sudo tc qdisc del dev "$interface" ingress 2>/dev/null
    
    # Upload limiting (egress)
    if [ "$upload_mbps" -gt 0 ]; then
        local upload_kbps=$((upload_mbps * 1000))
        
        echo "Setting upload limit to ${upload_mbps} Mbps..."
        sudo tc qdisc add dev "$interface" root handle 1: htb default 10
        sudo tc class add dev "$interface" parent 1: classid 1:1 htb rate "${upload_kbps}kbit"
        sudo tc class add dev "$interface" parent 1:1 classid 1:10 htb rate "${upload_kbps}kbit"
        sudo tc qdisc add dev "$interface" parent 1:10 fq_codel
    fi
    
    # Download limiting (ingress)
    if [ "$download_mbps" -gt 0 ]; then
        local download_kbps=$((download_mbps * 1000))
        
        echo "Setting download limit to ${download_mbps} Mbps..."
        sudo tc qdisc add dev "$interface" ingress
        sudo tc filter add dev "$interface" parent ffff: protocol ip u32 match u32 0 0 police rate "${download_kbps}kbit" burst 100k drop
    fi
    
    echo ""
    echo "✅ Bandwidth limits configured!"
    echo "📊 Upload: ${upload_mbps} Mbps | Download: ${download_mbps} Mbps"
}

setup_video_conf_priority() {
    echo "📹 Setting up video conferencing priority..."
    echo ""
    
    local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
    
    # Common video conferencing ports
    local zoom_ports="8801 8802 3478 3479"
    local teams_ports="3478 3479 3480 3481"
    local webrtc_ports="19302 19303 19304 19305"
    
    # Set up priority queuing
    sudo tc qdisc del dev "$interface" root 2>/dev/null
    sudo tc qdisc add dev "$interface" root handle 1: htb default 30
    
    # Get total bandwidth
    read -p "Enter your total upload bandwidth in Mbps: " total_bw
    local total_kbps=$((total_bw * 1000))
    
    # Create classes with priority
    sudo tc class add dev "$interface" parent 1: classid 1:1 htb rate "${total_kbps}kbit"
    sudo tc class add dev "$interface" parent 1:1 classid 1:10 htb rate "$((total_kbps * 6 / 10))kbit" prio 1  # Video conf
    sudo tc class add dev "$interface" parent 1:1 classid 1:20 htb rate "$((total_kbps * 3 / 10))kbit" prio 2  # Normal
    sudo tc class add dev "$interface" parent 1:1 classid 1:30 htb rate "$((total_kbps * 1 / 10))kbit" prio 3  # Bulk
    
    # Add fq_codel
    sudo tc qdisc add dev "$interface" parent 1:10 fq_codel
    sudo tc qdisc add dev "$interface" parent 1:20 fq_codel
    sudo tc qdisc add dev "$interface" parent 1:30 fq_codel
    
    # Add filters for video conf traffic
    for port in $zoom_ports $teams_ports $webrtc_ports; do
        sudo tc filter add dev "$interface" parent 1: protocol ip prio 1 u32 match ip dport "$port" 0xffff flowid 1:10
        sudo tc filter add dev "$interface" parent 1: protocol ip prio 1 u32 match ip sport "$port" 0xffff flowid 1:10
    done
    
    echo "✅ Video conferencing priority configured!"
    echo "📹 Zoom, Teams, and WebRTC traffic will be prioritized"
}

setup_fair_queuing() {
    echo "👥 Setting up fair bandwidth sharing..."
    echo ""
    
    local interface=$(ip route | awk '/default/ { print $5 }' | head -1)
    
    # Use CAKE qdisc for fair queuing
    if ! tc qdisc show | grep -q cake; then
        echo "📥 CAKE qdisc not available, using FQ_CoDel..."
        
        # Set up FQ_CoDel with host fairness
        sudo tc qdisc del dev "$interface" root 2>/dev/null
        sudo tc qdisc add dev "$interface" root fq_codel flows 1024 quantum 1514 target 5ms interval 100ms
    else
        echo "🍰 Setting up CAKE qdisc for ultimate fairness..."
        
        read -p "Enter your total bandwidth in Mbps (down/up): " total_down total_up
        
        sudo tc qdisc del dev "$interface" root 2>/dev/null
        sudo tc qdisc add dev "$interface" root cake bandwidth "${total_up}mbit" besteffort flows
    fi
    
    echo ""
    echo "✅ Fair queuing enabled!"
    echo "👥 All users/devices will get fair share of bandwidth"
}

# Main menu loop
main() {
    while true; do
        show_menu
        read -p "🎯 Choose your optimization mission (0-4): " choice
        
        case $choice in
            1) optimize_dns ;;
            2) optimize_performance ;;
            3) gaming_mode ;;
            4) bandwidth_management ;;
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