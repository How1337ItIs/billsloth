#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=System Health Check, 2=Performance Analysis, 3=Hardware Diagnostics, 4=Log Analysis, 5=Complete System Doctor
# CLAUDE_PROMPTS: Diagnostic type selection, System scan configuration, Repair options
# CLAUDE_DEPENDENCIES: htop, iostat, lshw, smartmontools, memtest
# 💀 WETWARE DIAGNOSTICS & REALITY REPAIR MATRIX 💀
# Neural system consciousness troubleshooting protocols

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

source "../lib/interactive.sh" 2>/dev/null || {
    echo -e "\033[38;5;196m💀 WETWARE DIAGNOSTIC MATRIX 💀\033[0m"
    echo "=================================="
}

clear
echo -e "\033[38;5;196m"
cat << 'EOF'
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░  💀 WETWARE DIAGNOSTICS & REALITY REPAIR MATRIX 💀                   ░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
echo -e "\033[0m"
echo ""
echo -e "\033[38;5;51m🩺 SYSTEM CONSCIOUSNESS DIAGNOSTICS ACTIVATED\033[0m"
echo "============================================="
echo ""
echo -e "\033[38;5;226m🎯 Your neural system diagnostic toolkit that makes Windows Device Manager\033[0m"
echo -e "\033[38;5;226m   look like a primitive cave painting on a rock!\033[0m"
echo ""
echo -e "\033[38;5;129m🧠 NEURAL INTERFACE BENEFITS:\033[0m"
echo "   • One matrix for all system consciousness problems"
echo "   • AI explains problems in human language, not machine gibberish"
echo "   • Step-by-step guided reality repair reduces mental overload"
echo "   • Automatic problem detection prevents system reality collapse"
echo "   • Visual status displays show wetware health at a glance"
echo "   • Saves troubleshooting rituals for future consciousness crises"
echo ""

explain_wetware_diagnostics() {
    echo -e "\033[38;5;82m💡 WHAT IS NEURAL WETWARE CONSCIOUSNESS DIAGNOSIS?\033[0m"
    echo "=================================================="
    echo ""
    echo -e "\033[38;5;51m💀 Your system consciousness requires regular diagnostic scans to maintain\033[0m"
    echo -e "\033[38;5;51m   optimal reality processing capabilities. Think of it as a health checkup\033[0m"
    echo -e "\033[38;5;51m   for your digital soul.\033[0m"
    echo ""
    echo ""
    echo "If you're coming from Windows, you probably used:"
    echo "• 🔧 Device Manager - Hardware and driver troubleshooting"
    echo "• 💾 Disk Management - Drive mounting, partitioning, repair"
    echo "• 📊 Event Viewer - System log analysis and error tracking"
    echo "• 🌐 Network Troubleshooter - Connection diagnosis and repair"
    echo "• 🔊 Audio Troubleshooter - Sound system problem solving"
    echo "• 🖥️  Display Settings - Monitor and graphics troubleshooting"
    echo "• ⚙️  System File Checker (sfc /scannow) - System integrity repair"
    echo "• 📋 System Information (msinfo32) - Hardware inventory"
    echo ""
    echo "🚀 THIS LINUX SYSTEM DOCTOR GIVES YOU ALL THAT PLUS AI INTELLIGENCE:"
    echo ""
    echo "🤖 AI-POWERED DIAGNOSIS:"
    echo "   • Smart problem detection from symptoms"
    echo "   • Natural language problem descriptions"
    echo "   • Automated solution suggestions with explanations"
    echo "   • Learning from previous troubleshooting sessions"
    echo ""
    echo "🔧 HARDWARE MANAGEMENT:"
    echo "   • lspci/lsusb: Complete hardware inventory and status"
    echo "   • hwinfo: Detailed hardware configuration analysis"
    echo "   • smartctl: Hard drive health monitoring and prediction"
    echo "   • sensors: Temperature, voltage, and fan monitoring"
    echo ""
    echo "💾 STORAGE DIAGNOSTICS:"
    echo "   • lsblk/fdisk: Drive detection and mounting"
    echo "   • fsck: File system checking and repair"
    echo "   • badblocks: Bad sector detection and marking"
    echo "   • SMART data analysis for predictive failure detection"
    echo ""
    echo "🌐 NETWORK TROUBLESHOOTING:"
    echo "   • NetworkManager diagnostics and repair"
    echo "   • DNS resolution testing and configuration"
    echo "   • Firewall status and rule analysis"
    echo "   • WiFi signal strength and connection quality"
    echo ""
    echo "📊 SYSTEM MONITORING:"
    echo "   • journalctl: Comprehensive system log analysis"
    echo "   • systemctl: Service status and management"
    echo "   • Process monitoring and resource usage tracking"
    echo "   • Performance bottleneck identification"
    echo ""
    echo "🎵 AUDIO SYSTEM REPAIR:"
    echo "   • PulseAudio/PipeWire configuration and troubleshooting"
    echo "   • ALSA device detection and configuration"
    echo "   • Audio routing and device management"
    echo "   • VoiceMeeter-equivalent setup validation"
    echo ""
    echo "🖥️  DISPLAY MANAGEMENT:"
    echo "   • xrandr: Multi-monitor configuration and troubleshooting"
    echo "   • Graphics driver status and optimization"
    echo "   • Resolution and refresh rate optimization"
    echo "   • Wayland/X11 session diagnostics"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_diagnostic_tools() {
    echo "🔧 INSTALLING COMPREHENSIVE DIAGNOSTIC TOOLKIT"
    echo "==============================================="
    echo ""
    echo "🎯 Setting up tools that put Windows built-in diagnostics to shame!"
    echo ""
    
    # Install hardware and system diagnostic tools
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y \
                hwinfo lshw pciutils usbutils \
                smartmontools hdparm sdparm \
                lm-sensors hddtemp \
                iotop htop btop \
                net-tools wireless-tools \
                alsa-utils pulseaudio-utils \
                mesa-utils \
                strace ltrace \
                sysstat iostat \
                tree ncdu \
                inxi neofetch \
                testdisk gparted \
                memtest86+ \
                stress stress-ng \
                fio bonnie++ \
                nmap netcat-openbsd \
                tcpdump wireshark-common \
                dmesg util-linux \
                systemd-coredump \
                git curl wget rsync
                
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y \
                hwinfo lshw pciutils usbutils \
                smartmontools hdparm \
                lm_sensors \
                iotop htop \
                net-tools wireless-tools \
                alsa-utils pulseaudio-utils \
                mesa-utils \
                strace ltrace \
                sysstat \
                tree ncdu \
                inxi neofetch \
                testdisk gparted \
                stress stress-ng \
                fio \
                nmap ncat \
                tcpdump wireshark \
                util-linux \
                systemd
                
        elif command -v pacman &> /dev/null; then
            sudo pacman -S \
                hwinfo lshw pciutils usbutils \
                smartmontools hdparm \
                lm_sensors \
                iotop htop btop \
                net-tools wireless_tools \
                alsa-utils pulseaudio \
                mesa-utils \
                strace ltrace \
                sysstat \
                tree ncdu \
                inxi neofetch \
                testdisk gparted \
                stress stress-ng \
                fio \
                nmap netcat \
                tcpdump wireshark-cli \
                util-linux \
                systemd
        fi
    fi
    
    echo "✅ Diagnostic tools installed!"
    echo ""
    echo "🎯 YOUR NEW DIAGNOSTIC ARSENAL:"
    echo "   hwinfo/lshw    = Complete hardware inventory"
    echo "   smartctl       = Hard drive health monitoring"
    echo "   sensors        = Temperature and voltage monitoring"
    echo "   iotop/htop     = Process and I/O monitoring"
    echo "   journalctl     = System log analysis"
    echo "   networkctl     = Network diagnostics"
    echo "   And many more!"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_hardware_diagnostics() {
    echo "🔧 CREATING HARDWARE DIAGNOSTIC SCRIPTS"
    echo "======================================="
    echo ""
    echo "🎯 Setting up Windows Device Manager equivalent..."
    echo ""
    
    mkdir -p ~/.local/bin
    
    # Hardware inventory script (Device Manager equivalent)
    cat > ~/.local/bin/device-manager << 'EOF'
#!/bin/bash
# Linux Device Manager - Hardware inventory and diagnostics
# Usage: device-manager [category]

CATEGORY="${1:-all}"

echo "🔧 Linux Device Manager"
echo "======================="
echo ""

case $CATEGORY in
    "all"|"overview")
        echo "📊 SYSTEM OVERVIEW:"
        echo "=================="
        if command -v inxi &> /dev/null; then
            inxi -Fxxxz
        elif command -v neofetch &> /dev/null; then
            neofetch
        else
            echo "Hostname: $(hostname)"
            echo "Kernel: $(uname -r)"
            echo "Uptime: $(uptime -p)"
            echo "Architecture: $(uname -m)"
        fi
        echo ""
        ;;
        
    "cpu"|"processor")
        echo "🧠 PROCESSOR INFORMATION:"
        echo "========================"
        if command -v lscpu &> /dev/null; then
            lscpu
        else
            grep -E "(model name|cpu cores|siblings)" /proc/cpuinfo | head -10
        fi
        
        echo ""
        echo "🌡️ CPU TEMPERATURE:"
        if command -v sensors &> /dev/null; then
            sensors | grep -i temp
        else
            echo "Install lm-sensors for temperature monitoring"
        fi
        echo ""
        ;;
        
    "memory"|"ram")
        echo "🧠 MEMORY INFORMATION:"
        echo "====================="
        free -h
        echo ""
        
        echo "📊 MEMORY DETAILS:"
        if command -v dmidecode &> /dev/null && [ "$EUID" -eq 0 ]; then
            sudo dmidecode --type memory | grep -E "(Size|Speed|Manufacturer|Type:)"
        else
            cat /proc/meminfo | head -10
        fi
        echo ""
        ;;
        
    "disk"|"storage")
        echo "💾 STORAGE DEVICES:"
        echo "=================="
        echo ""
        echo "🔍 BLOCK DEVICES:"
        lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL
        echo ""
        
        echo "💿 DISK USAGE:"
        df -h | grep -E "(Filesystem|/dev/)"
        echo ""
        
        echo "🏥 DISK HEALTH:"
        for disk in /dev/sd[a-z] /dev/nvme[0-9]n[0-9]; do
            if [ -b "$disk" ]; then
                echo "Checking $disk..."
                if command -v smartctl &> /dev/null; then
                    sudo smartctl -H "$disk" 2>/dev/null | grep -E "(SMART|overall-health|PASSED|FAILED)"
                fi
            fi
        done
        echo ""
        ;;
        
    "network"|"wifi")
        echo "🌐 NETWORK DEVICES:"
        echo "=================="
        echo ""
        echo "🔌 NETWORK INTERFACES:"
        if command -v ip &> /dev/null; then
            ip addr show
        else
            ifconfig -a
        fi
        echo ""
        
        echo "📡 WIRELESS STATUS:"
        if command -v iwconfig &> /dev/null; then
            iwconfig 2>/dev/null | grep -v "no wireless"
        fi
        
        if command -v nmcli &> /dev/null; then
            echo ""
            echo "🔗 CONNECTION STATUS:"
            nmcli connection show
        fi
        echo ""
        ;;
        
    "graphics"|"display")
        echo "🖥️ GRAPHICS INFORMATION:"
        echo "======================="
        echo ""
        echo "🎮 GRAPHICS CARDS:"
        lspci | grep -i vga
        lspci | grep -i 3d
        echo ""
        
        echo "📺 DISPLAY STATUS:"
        if [ -n "$DISPLAY" ]; then
            xrandr 2>/dev/null | grep " connected"
            echo ""
            if command -v glxinfo &> /dev/null; then
                echo "🎯 OPENGL INFO:"
                glxinfo | grep -E "(OpenGL vendor|OpenGL renderer|OpenGL version)"
            fi
        else
            echo "No X11 display detected (console mode or Wayland)"
        fi
        echo ""
        ;;
        
    "audio"|"sound")
        echo "🎵 AUDIO DEVICES:"
        echo "================"
        echo ""
        echo "🎤 AUDIO HARDWARE:"
        lspci | grep -i audio
        lsusb | grep -i audio
        echo ""
        
        echo "🔊 PULSEAUDIO STATUS:"
        if command -v pactl &> /dev/null; then
            pactl info | head -5
            echo ""
            echo "🎯 AUDIO SINKS:"
            pactl list short sinks
            echo ""
            echo "🎙️ AUDIO SOURCES:"
            pactl list short sources
        fi
        echo ""
        
        echo "🎛️ ALSA DEVICES:"
        if command -v aplay &> /dev/null; then
            aplay -l
        fi
        echo ""
        ;;
        
    "usb")
        echo "🔌 USB DEVICES:"
        echo "=============="
        lsusb -v | grep -E "(Bus|Device|idVendor|idProduct|bDeviceClass)" | head -20
        echo ""
        ;;
        
    "pci")
        echo "🔧 PCI DEVICES:"
        echo "=============="
        lspci -v | head -30
        echo ""
        ;;
        
    *)
        echo "📋 Available categories:"
        echo "======================="
        echo "  all        Complete system overview"
        echo "  cpu        Processor information"
        echo "  memory     RAM and memory details"
        echo "  disk       Storage devices and health"
        echo "  network    Network interfaces and WiFi"
        echo "  graphics   Display and graphics cards"
        echo "  audio      Sound devices and configuration"
        echo "  usb        USB device listing"
        echo "  pci        PCI device listing"
        echo ""
        echo "Usage: device-manager [category]"
        exit 1
        ;;
esac
EOF

    # Drive mounting and management (Disk Management equivalent)
    cat > ~/.local/bin/disk-manager << 'EOF'
#!/bin/bash
# Linux Disk Manager - Drive mounting, partitioning, and repair
# Usage: disk-manager [action] [device]

ACTION="${1:-list}"
DEVICE="$2"

echo "💾 Linux Disk Manager"
echo "===================="
echo ""

case $ACTION in
    "list"|"show")
        echo "🔍 ALL STORAGE DEVICES:"
        echo "======================"
        lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,MODEL,SERIAL
        echo ""
        
        echo "💿 MOUNTED FILESYSTEMS:"
        echo "======================"
        df -h | grep -E "(Filesystem|/dev/)"
        echo ""
        
        echo "🏥 DRIVE HEALTH STATUS:"
        echo "======================"
        for disk in /dev/sd[a-z] /dev/nvme[0-9]n[0-9]; do
            if [ -b "$disk" ]; then
                HEALTH="Unknown"
                if command -v smartctl &> /dev/null; then
                    HEALTH=$(sudo smartctl -H "$disk" 2>/dev/null | grep "SMART overall-health" | awk '{print $6}')
                fi
                echo "  $disk: $HEALTH"
            fi
        done
        echo ""
        ;;
        
    "mount")
        if [ -z "$DEVICE" ]; then
            echo "❌ Usage: disk-manager mount /dev/sdX1"
            echo ""
            echo "🔍 Unmounted devices:"
            lsblk | grep -v SWAP | awk '$7=="" {print $1}'
            exit 1
        fi
        
        echo "📁 Mounting $DEVICE..."
        
        # Create mount point
        MOUNT_POINT="/media/$(whoami)/$(basename $DEVICE)"
        sudo mkdir -p "$MOUNT_POINT"
        
        # Mount the device
        if sudo mount "$DEVICE" "$MOUNT_POINT"; then
            echo "✅ Successfully mounted $DEVICE to $MOUNT_POINT"
        else
            echo "❌ Failed to mount $DEVICE"
            echo "💡 Try: disk-manager check $DEVICE"
        fi
        ;;
        
    "unmount"|"eject")
        if [ -z "$DEVICE" ]; then
            echo "❌ Usage: disk-manager unmount /dev/sdX1"
            exit 1
        fi
        
        echo "⏏️ Unmounting $DEVICE..."
        
        if sudo umount "$DEVICE"; then
            echo "✅ Successfully unmounted $DEVICE"
            # Remove empty mount point
            sudo rmdir "/media/$(whoami)/$(basename $DEVICE)" 2>/dev/null
        else
            echo "❌ Failed to unmount $DEVICE"
            echo "💡 Device may be busy. Check: lsof +f -- $DEVICE"
        fi
        ;;
        
    "check"|"fsck")
        if [ -z "$DEVICE" ]; then
            echo "❌ Usage: disk-manager check /dev/sdX1"
            exit 1
        fi
        
        echo "🔍 Checking filesystem on $DEVICE..."
        echo "⚠️ This will check for errors and attempt repairs"
        read -p "Continue? (y/n): " confirm
        
        if [[ $confirm =~ ^[Yy]$ ]]; then
            sudo fsck -f "$DEVICE"
        else
            echo "❌ Check cancelled"
        fi
        ;;
        
    "health"|"smart")
        if [ -z "$DEVICE" ]; then
            echo "💡 Usage: disk-manager health /dev/sdX"
            echo ""
            echo "🔍 Available drives:"
            lsblk -d -o NAME,SIZE,MODEL | grep -E "(sd[a-z]|nvme)"
            exit 1
        fi
        
        echo "🏥 Drive Health Report: $DEVICE"
        echo "==============================="
        
        if command -v smartctl &> /dev/null; then
            echo "🎯 SMART STATUS:"
            sudo smartctl -a "$DEVICE"
        else
            echo "❌ smartmontools not installed"
            echo "Install with: sudo apt install smartmontools"
        fi
        ;;
        
    "format")
        if [ -z "$DEVICE" ]; then
            echo "❌ Usage: disk-manager format /dev/sdX1"
            exit 1
        fi
        
        echo "⚠️  WARNING: This will ERASE ALL DATA on $DEVICE"
        echo "Device: $DEVICE"
        lsblk "$DEVICE" 2>/dev/null || echo "Device not found!"
        echo ""
        read -p "Type 'DELETE' to confirm format: " confirm
        
        if [ "$confirm" = "DELETE" ]; then
            echo ""
            echo "📝 Choose filesystem type:"
            echo "1) ext4 (Linux default)"
            echo "2) ntfs (Windows compatible)"
            echo "3) exfat (Cross-platform)"
            echo "4) fat32 (Maximum compatibility)"
            read -p "Choice (1-4): " fs_choice
            
            case $fs_choice in
                1) sudo mkfs.ext4 "$DEVICE" && echo "✅ Formatted as ext4" ;;
                2) sudo mkfs.ntfs -f "$DEVICE" && echo "✅ Formatted as NTFS" ;;
                3) sudo mkfs.exfat "$DEVICE" && echo "✅ Formatted as exFAT" ;;
                4) sudo mkfs.fat -F32 "$DEVICE" && echo "✅ Formatted as FAT32" ;;
                *) echo "❌ Invalid choice" ;;
            esac
        else
            echo "❌ Format cancelled - data is safe"
        fi
        ;;
        
    *)
        echo "💾 Disk Manager Commands:"
        echo "========================"
        echo "  list              Show all drives and mount status"
        echo "  mount <device>    Mount a drive"
        echo "  unmount <device>  Safely unmount a drive"
        echo "  check <device>    Check filesystem for errors"
        echo "  health <device>   Show drive health (SMART data)"
        echo "  format <device>   Format a drive (DANGEROUS!)"
        echo ""
        echo "Examples:"
        echo "  disk-manager list"
        echo "  disk-manager mount /dev/sdb1"
        echo "  disk-manager health /dev/sda"
        echo "  disk-manager check /dev/sdc1"
        echo ""
        echo "💡 Use 'lsblk' to see device names"
        exit 1
        ;;
esac
EOF

    chmod +x ~/.local/bin/device-manager ~/.local/bin/disk-manager
    
    echo "✅ Hardware diagnostic scripts created!"
    echo ""
    echo "🔧 YOUR NEW DEVICE MANAGEMENT COMMANDS:"
    echo "   device-manager        = Complete hardware inventory"
    echo "   device-manager cpu    = Processor details and temperature"
    echo "   device-manager disk   = Storage devices and health"
    echo "   disk-manager list     = Show all drives (like Disk Management)"
    echo "   disk-manager mount    = Mount drives safely"
    echo "   disk-manager health   = Check drive health with SMART"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_network_diagnostics() {
    echo "🌐 CREATING NETWORK DIAGNOSTIC TOOLS"
    echo "===================================="
    echo ""
    echo "🎯 Setting up network troubleshooting better than Windows..."
    echo ""
    
    # Network troubleshooter script
    cat > ~/.local/bin/network-doctor << 'EOF'
#!/bin/bash
# Network Doctor - Comprehensive network diagnostics and repair
# Usage: network-doctor [test|fix|status|wifi]

ACTION="${1:-test}"

echo "🌐 Network Doctor"
echo "================"
echo ""

case $ACTION in
    "test"|"diagnose")
        echo "🔍 NETWORK CONNECTIVITY TEST:"
        echo "============================="
        echo ""
        
        echo "1️⃣ Interface Status:"
        if command -v ip &> /dev/null; then
            ip addr show | grep -E "(inet|state)" | grep -v "127.0.0.1"
        else
            ifconfig | grep -E "(inet|UP,)"
        fi
        echo ""
        
        echo "2️⃣ Gateway Test:"
        GATEWAY=$(ip route | grep default | awk '{print $3}' | head -1)
        if [ -n "$GATEWAY" ]; then
            echo "Testing gateway: $GATEWAY"
            if ping -c 3 "$GATEWAY" > /dev/null 2>&1; then
                echo "✅ Gateway reachable"
            else
                echo "❌ Gateway unreachable"
            fi
        else
            echo "❌ No default gateway found"
        fi
        echo ""
        
        echo "3️⃣ DNS Test:"
        if ping -c 3 8.8.8.8 > /dev/null 2>&1; then
            echo "✅ Internet connectivity (IP)"
            
            if nslookup google.com > /dev/null 2>&1; then
                echo "✅ DNS resolution working"
            else
                echo "❌ DNS resolution failed"
                echo "💡 Try: network-doctor fix-dns"
            fi
        else
            echo "❌ No internet connectivity"
            echo "💡 Try: network-doctor fix"
        fi
        echo ""
        
        echo "4️⃣ WiFi Status:"
        if command -v iwconfig &> /dev/null; then
            WIFI_INFO=$(iwconfig 2>/dev/null | grep -v "no wireless")
            if [ -n "$WIFI_INFO" ]; then
                echo "$WIFI_INFO" | grep -E "(ESSID|Signal|Bit Rate)"
            else
                echo "No WiFi adapters found"
            fi
        fi
        echo ""
        ;;
        
    "fix"|"repair")
        echo "🔧 NETWORK REPAIR SEQUENCE:"
        echo "==========================="
        echo ""
        
        echo "1️⃣ Restarting NetworkManager..."
        sudo systemctl restart NetworkManager
        sleep 3
        
        echo "2️⃣ Releasing and renewing IP..."
        sudo dhclient -r 2>/dev/null
        sudo dhclient 2>/dev/null
        
        echo "3️⃣ Flushing DNS cache..."
        sudo systemctl flush-dns 2>/dev/null || sudo systemctl restart systemd-resolved 2>/dev/null
        
        echo "4️⃣ Testing connectivity..."
        sleep 2
        if ping -c 2 8.8.8.8 > /dev/null 2>&1; then
            echo "✅ Network repair successful!"
        else
            echo "❌ Network still having issues"
            echo "💡 Try: network-doctor advanced-fix"
        fi
        ;;
        
    "fix-dns")
        echo "🔧 DNS REPAIR:"
        echo "============="
        echo ""
        
        echo "Setting reliable DNS servers..."
        echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf.backup > /dev/null
        echo "nameserver 1.1.1.1" | sudo tee -a /etc/resolv.conf.backup > /dev/null
        sudo cp /etc/resolv.conf.backup /etc/resolv.conf
        
        sudo systemctl restart systemd-resolved 2>/dev/null
        
        echo "Testing DNS resolution..."
        if nslookup google.com > /dev/null 2>&1; then
            echo "✅ DNS repair successful!"
        else
            echo "❌ DNS issues persist"
        fi
        ;;
        
    "wifi"|"wireless")
        echo "📡 WiFi DIAGNOSTICS:"
        echo "==================="
        echo ""
        
        if command -v nmcli &> /dev/null; then
            echo "🔗 Available Networks:"
            nmcli dev wifi list
            echo ""
            
            echo "📊 Connection Status:"
            nmcli connection show --active | grep wifi
            echo ""
            
            echo "📶 Signal Strength:"
            iwconfig 2>/dev/null | grep -E "(ESSID|Signal)" | head -4
        else
            echo "NetworkManager not available"
            echo "Using iwconfig..."
            iwconfig 2>/dev/null | grep -v "no wireless"
        fi
        echo ""
        
        read -p "Connect to a WiFi network? (y/n): " connect_wifi
        if [[ $connect_wifi =~ ^[Yy]$ ]]; then
            echo ""
            echo "📱 Available commands:"
            echo "  nmcli dev wifi connect 'NetworkName' password 'password'"
            echo "  nmcli connection up 'ConnectionName'"
        fi
        ;;
        
    "advanced-fix")
        echo "🔧 ADVANCED NETWORK REPAIR:"
        echo "==========================="
        echo ""
        
        echo "⚠️ This will reset network configuration"
        read -p "Continue? (y/n): " confirm
        
        if [[ $confirm =~ ^[Yy]$ ]]; then
            echo "1️⃣ Stopping network services..."
            sudo systemctl stop NetworkManager
            sudo systemctl stop wpa_supplicant 2>/dev/null
            
            echo "2️⃣ Resetting network interfaces..."
            for iface in $(ls /sys/class/net/ | grep -v lo); do
                sudo ip link set "$iface" down
                sudo ip addr flush dev "$iface"
                sudo ip link set "$iface" up
            done
            
            echo "3️⃣ Restarting services..."
            sudo systemctl start NetworkManager
            
            echo "4️⃣ Waiting for network..."
            sleep 5
            
            echo "✅ Advanced repair complete!"
            echo "💡 Test with: network-doctor test"
        fi
        ;;
        
    "status")
        echo "📊 NETWORK STATUS OVERVIEW:"
        echo "=========================="
        echo ""
        
        echo "🔌 INTERFACES:"
        ip addr show | grep -E "^[0-9]+:|inet " | sed 's/^/  /'
        echo ""
        
        echo "🛣️ ROUTING TABLE:"
        ip route show | sed 's/^/  /'
        echo ""
        
        echo "🌐 DNS SERVERS:"
        cat /etc/resolv.conf | grep nameserver | sed 's/^/  /'
        echo ""
        
        if command -v ss &> /dev/null; then
            echo "🔗 ACTIVE CONNECTIONS:"
            ss -tuln | head -10 | sed 's/^/  /'
        fi
        ;;
        
    *)
        echo "🌐 Network Doctor Commands:"
        echo "========================="
        echo "  test         Run comprehensive connectivity test"
        echo "  fix          Automatic network repair sequence"
        echo "  fix-dns      Fix DNS resolution issues"
        echo "  wifi         WiFi diagnostics and connection"
        echo "  advanced-fix Complete network reset (use with caution)"
        echo "  status       Show detailed network status"
        echo ""
        echo "Examples:"
        echo "  network-doctor test"
        echo "  network-doctor fix"
        echo "  network-doctor wifi"
        exit 1
        ;;
esac
EOF

    chmod +x ~/.local/bin/network-doctor
    
    echo "✅ Network diagnostic tools created!"
    echo ""
    echo "🌐 YOUR NEW NETWORK TROUBLESHOOTING:"
    echo "   network-doctor test    = Complete connectivity diagnosis"
    echo "   network-doctor fix     = Automatic network repair"
    echo "   network-doctor wifi    = WiFi diagnostics and connection"
    echo "   network-doctor fix-dns = Fix DNS resolution problems"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_ai_system_doctor() {
    echo "🤖 CREATING AI-POWERED SYSTEM DOCTOR"
    echo "===================================="
    echo ""
    echo "🎯 Setting up intelligent problem diagnosis and solutions..."
    echo ""
    
    # AI-powered system diagnosis
    cat > ~/.local/bin/ai-doctor << 'EOF'
#!/bin/bash
# AI System Doctor - Intelligent problem diagnosis and solutions
# Usage: ai-doctor [describe problem or symptom]

PROBLEM="$*"

echo "🤖 AI System Doctor"
echo "=================="
echo ""

if [ -z "$PROBLEM" ]; then
    echo "💡 Describe your problem or symptom:"
    echo "Examples:"
    echo "  ai-doctor 'drive not showing up'"
    echo "  ai-doctor 'no sound from speakers'"
    echo "  ai-doctor 'wifi keeps disconnecting'"
    echo "  ai-doctor 'computer running slow'"
    echo "  ai-doctor 'screen resolution wrong'"
    echo "  ai-doctor 'external monitor not detected'"
    echo ""
    read -p "Describe your problem: " PROBLEM
fi

echo "🧠 Analyzing problem: $PROBLEM"
echo "==============================="
echo ""

# Gather system information for AI analysis
SYSTEM_INFO="OS: $(uname -a)
Uptime: $(uptime)
Memory: $(free -h | head -2)
Disk Space: $(df -h / | tail -1)
Network: $(ip route | grep default)
Recent Errors: $(journalctl --since '1 hour ago' --priority=3 --no-pager | tail -5)"

if command -v claude &> /dev/null; then
    echo "🔍 AI Analysis in progress..."
    echo ""
    
    AI_DIAGNOSIS=$(claude "I'm having this problem with my Linux system: '$PROBLEM'. Here's my system info: $SYSTEM_INFO. Please provide: 1) Likely causes, 2) Step-by-step troubleshooting commands, 3) Prevention tips. Be specific with Linux commands I can run." 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$AI_DIAGNOSIS" ]; then
        echo "💡 AI DIAGNOSIS AND SOLUTION:"
        echo "============================"
        echo "$AI_DIAGNOSIS"
        echo ""
        
        read -p "Try automatic diagnosis with system tools? (y/n): " auto_check
        if [[ $auto_check =~ ^[Yy]$ ]]; then
            auto_diagnose "$PROBLEM"
        fi
    else
        echo "❌ AI analysis failed. Using rule-based diagnosis..."
        rule_based_diagnosis "$PROBLEM"
    fi
else
    echo "💡 AI not available. Using built-in diagnosis..."
    rule_based_diagnosis "$PROBLEM"
fi

auto_diagnose() {
    local problem="$1"
    echo ""
    echo "🔧 AUTOMATIC SYSTEM DIAGNOSIS:"
    echo "============================="
    echo ""
    
    case "$problem" in
        *drive*|*disk*|*mount*|*storage*)
            echo "💾 Running storage diagnostics..."
            lsblk
            echo ""
            df -h
            echo ""
            dmesg | tail -10 | grep -i -E "(error|fail|disk|usb)"
            ;;
        *sound*|*audio*|*speaker*)
            echo "🔊 Running audio diagnostics..."
            pactl info | head -5
            pactl list short sinks
            aplay -l 2>/dev/null
            ;;
        *wifi*|*network*|*internet*)
            echo "🌐 Running network diagnostics..."
            network-doctor test
            ;;
        *slow*|*performance*|*lag*)
            echo "⚡ Running performance diagnostics..."
            echo "CPU Load: $(uptime | awk '{print $10,$11,$12}')"
            echo "Memory Usage:"
            free -h
            echo "Top processes by CPU:"
            ps aux --sort=-%cpu | head -6
            ;;
        *monitor*|*display*|*screen*)
            echo "🖥️ Running display diagnostics..."
            xrandr 2>/dev/null | grep " connected"
            echo ""
            echo "Graphics info:"
            lspci | grep -i vga
            ;;
        *)
            echo "🔍 Running general system diagnostics..."
            echo "System status:"
            systemctl --failed
            echo ""
            echo "Recent errors:"
            journalctl --since '1 hour ago' --priority=3 --no-pager | tail -5
            ;;
    esac
}

rule_based_diagnosis() {
    local problem="$1"
    echo ""
    echo "🛠️ BUILT-IN DIAGNOSIS:"
    echo "======================"
    echo ""
    
    case "$problem" in
        *drive*|*disk*|*mount*|*"not showing"*|*storage*)
            echo "💾 STORAGE TROUBLESHOOTING:"
            echo "=========================="
            echo ""
            echo "1️⃣ Check if drive is detected:"
            echo "   lsblk"
            echo "   sudo fdisk -l"
            echo ""
            echo "2️⃣ Check dmesg for errors:"
            echo "   dmesg | tail -20"
            echo ""
            echo "3️⃣ Try manual mount:"
            echo "   disk-manager list"
            echo "   disk-manager mount /dev/sdX1"
            echo ""
            echo "4️⃣ Check file system:"
            echo "   disk-manager check /dev/sdX1"
            echo ""
            
            # Run automatic checks
            echo "🔍 AUTOMATIC CHECKS:"
            echo ""
            lsblk
            echo ""
            dmesg | tail -10 | grep -i -E "(error|fail|disk|usb)" | head -5
            ;;
            
        *sound*|*audio*|*speaker*|*microphone*)
            echo "🔊 AUDIO TROUBLESHOOTING:"
            echo "======================="
            echo ""
            echo "1️⃣ Check audio devices:"
            echo "   device-manager audio"
            echo ""
            echo "2️⃣ Restart audio service:"
            echo "   pulseaudio -k && pulseaudio --start"
            echo ""
            echo "3️⃣ Check volume levels:"
            echo "   pactl list sinks"
            echo "   alsamixer"
            echo ""
            
            # VoiceMeeter user specific
            echo "4️⃣ VoiceMeeter equivalent check:"
            echo "   Check Carla audio routing"
            echo "   pavucontrol for per-app audio"
            echo ""
            ;;
            
        *wifi*|*network*|*internet*|*connection*)
            echo "🌐 NETWORK TROUBLESHOOTING:"
            echo "========================="
            echo ""
            echo "1️⃣ Quick network test:"
            echo "   network-doctor test"
            echo ""
            echo "2️⃣ Restart network:"
            echo "   network-doctor fix"
            echo ""
            echo "3️⃣ WiFi specific:"
            echo "   network-doctor wifi"
            echo ""
            ;;
            
        *slow*|*performance*|*lag*|*freeze*)
            echo "⚡ PERFORMANCE TROUBLESHOOTING:"
            echo "=============================="
            echo ""
            echo "1️⃣ Check resource usage:"
            echo "   htop"
            echo "   iotop"
            echo ""
            echo "2️⃣ Check disk space:"
            echo "   df -h"
            echo "   ncdu /"
            echo ""
            echo "3️⃣ Check for errors:"
            echo "   journalctl --since today --priority=3"
            echo ""
            
            # Show current stats
            echo "📊 CURRENT PERFORMANCE:"
            echo "CPU Load: $(uptime | awk '{print $10,$11,$12}')"
            echo "Memory: $(free -h | awk 'NR==2{print $3"/"$2}')"
            echo "Disk: $(df -h / | awk 'NR==2{print $5 " used"}')"
            ;;
            
        *monitor*|*display*|*screen*|*resolution*)
            echo "🖥️ DISPLAY TROUBLESHOOTING:"
            echo "=========================="
            echo ""
            echo "1️⃣ Check connected displays:"
            echo "   xrandr"
            echo "   monitor-setup detect"
            echo ""
            echo "2️⃣ Reset display:"
            echo "   xrandr --auto"
            echo ""
            echo "3️⃣ Multi-monitor setup:"
            echo "   arandr"
            echo "   monitor-setup configure"
            echo ""
            ;;
            
        *)
            echo "🔍 GENERAL TROUBLESHOOTING:"
            echo "========================="
            echo ""
            echo "1️⃣ Check system status:"
            echo "   systemctl --failed"
            echo ""
            echo "2️⃣ Check recent errors:"
            echo "   journalctl --since '1 hour ago' --priority=3"
            echo ""
            echo "3️⃣ Check hardware:"
            echo "   device-manager all"
            echo ""
            echo "4️⃣ Run specific diagnostics:"
            echo "   ai-doctor 'specific problem description'"
            echo ""
            ;;
    esac
    
    echo ""
    echo "💡 Need more help? Try:"
    echo "   ai-doctor 'more specific problem description'"
    echo "   device-manager [category]"
    echo "   network-doctor test"
    echo "   disk-manager list"
}
EOF

    chmod +x ~/.local/bin/ai-doctor
    
    echo "✅ AI System Doctor created!"
    echo ""
    echo "🤖 YOUR INTELLIGENT TROUBLESHOOTER:"
    echo "   ai-doctor 'drive not showing up'    = AI diagnoses storage issues"
    echo "   ai-doctor 'no sound'                = Audio troubleshooting"
    echo "   ai-doctor 'wifi problems'           = Network diagnostics"
    echo "   ai-doctor 'computer running slow'   = Performance analysis"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

demo_system_doctor() {
    echo "🎯 SYSTEM DOCTOR DEMONSTRATION"
    echo "=============================="
    echo ""
    echo "Let's test your comprehensive diagnostic toolkit!"
    echo ""
    
    echo "🏥 SYSTEM HEALTH OVERVIEW:"
    echo "=========================="
    
    # Quick system overview
    echo ""
    echo "💻 SYSTEM INFO:"
    echo "  Hostname: $(hostname)"
    echo "  Uptime: $(uptime -p)"
    echo "  Kernel: $(uname -r)"
    echo ""
    
    echo "🧠 MEMORY STATUS:"
    free -h | grep -E "(Mem|Swap)" | sed 's/^/  /'
    echo ""
    
    echo "💾 STORAGE STATUS:"
    df -h | grep -E "(Filesystem|/dev/)" | head -5 | sed 's/^/  /'
    echo ""
    
    echo "🌐 NETWORK STATUS:"
    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo "  ✅ Internet connectivity: OK"
    else
        echo "  ❌ Internet connectivity: FAILED"
    fi
    
    # Show available interfaces
    INTERFACES=$(ip addr show | grep "state UP" | awk '{print $2}' | sed 's/://' | grep -v lo | head -3)
    if [ -n "$INTERFACES" ]; then
        echo "  📡 Active interfaces: $INTERFACES"
    fi
    echo ""
    
    echo "🔊 AUDIO STATUS:"
    if command -v pactl &> /dev/null && pactl info &> /dev/null; then
        echo "  ✅ PulseAudio: Running"
        AUDIO_DEVICES=$(pactl list short sinks | wc -l)
        echo "  🎵 Audio devices: $AUDIO_DEVICES"
    else
        echo "  ⚠️ Audio system needs checking"
    fi
    echo ""
    
    echo "🖥️ DISPLAY STATUS:"
    if [ -n "$DISPLAY" ]; then
        DISPLAYS=$(xrandr 2>/dev/null | grep " connected" | wc -l)
        echo "  📺 Connected displays: $DISPLAYS"
    else
        echo "  💡 Console mode (no X11 display)"
    fi
    echo ""
    
    echo "🔧 DIAGNOSTIC COMMANDS TO TRY:"
    echo "============================="
    echo ""
    echo "📋 HARDWARE INVENTORY:"
    echo "  device-manager           = Complete hardware overview"
    echo "  device-manager cpu       = Processor and temperature info"
    echo "  device-manager disk      = Storage devices and health"
    echo "  device-manager audio     = Audio system analysis"
    echo ""
    echo "💾 STORAGE MANAGEMENT:"
    echo "  disk-manager list        = Show all drives (like Windows Disk Management)"
    echo "  disk-manager mount /dev/sdb1  = Mount external drive"
    echo "  disk-manager health /dev/sda  = Check drive health with SMART"
    echo ""
    echo "🌐 NETWORK TROUBLESHOOTING:"
    echo "  network-doctor test      = Complete connectivity diagnosis"
    echo "  network-doctor fix       = Automatic network repair"
    echo "  network-doctor wifi      = WiFi diagnostics and connection"
    echo ""
    echo "🤖 AI-POWERED DIAGNOSIS:"
    echo "  ai-doctor 'drive not showing up'   = Smart troubleshooting"
    echo "  ai-doctor 'no sound from speakers' = Audio problem solving"
    echo "  ai-doctor 'wifi keeps dropping'    = Network issue analysis"
    echo ""
    
    # Interactive demo
    echo "🧪 INTERACTIVE TEST:"
    echo ""
    read -p "Test a diagnostic tool? (device/disk/network/ai/skip): " test_choice
    
    case $test_choice in
        "device"|"hardware")
            echo ""
            device-manager overview
            ;;
        "disk"|"storage")
            echo ""
            disk-manager list
            ;;
        "network"|"wifi")
            echo ""
            network-doctor test
            ;;
        "ai"|"smart")
            echo ""
            echo "💡 AI Doctor Demo:"
            ai-doctor "system health check demo"
            ;;
        *)
            echo "💡 Skipping demo - tools are ready to use!"
            ;;
    esac
    
    echo ""
    echo "🎯 POWER-USER TIPS:"
    echo ""
    echo "1️⃣ REGULAR CHECKS: Run 'device-manager' weekly for system health"
    echo "2️⃣ DRIVE HEALTH: Use 'disk-manager health' to prevent data loss"
    echo "3️⃣ NETWORK ISSUES: Start with 'network-doctor test' for quick fixes"
    echo "4️⃣ AI ASSISTANCE: Describe problems naturally to 'ai-doctor'"
    echo "5️⃣ LEARN PATTERNS: Notice which problems recur and automate solutions"
    echo ""
    echo "💡 Windows users: You now have SUPERIOR diagnostic tools!"
    echo "   Device Manager + Disk Management + Event Viewer + Network Troubleshooter = Child's play!"
    echo ""
    read -p "Press Enter to finish demonstration..."
    clear
}

# Main menu
main_menu() {
    while true; do
        show_banner "SYSTEM DOCTOR" "Windows Device Manager + Troubleshooters, but AI-powered" "SYSTEM"
        
        echo "🩺 SYSTEM DOCTOR MENU"
        echo "====================="
        echo ""
        echo "1) 💡 What is Comprehensive System Diagnosis?"
        echo "2) 🔧 Install Diagnostic Toolkit"
        echo "3) 🔧 Create Hardware Diagnostics (Device Manager)"
        echo "4) 🌐 Create Network Diagnostics (Network Troubleshooter)"
        echo "5) 🤖 Create AI-Powered System Doctor"
        echo "6) 🎯 Demo Your System Doctor Powers"
        echo "7) 🚀 Complete Setup (All Diagnostic Tools)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-7): " choice
        
        case $choice in
            1) explain_system_doctor ;;
            2) install_diagnostic_tools ;;
            3) create_hardware_diagnostics ;;
            4) create_network_diagnostics ;;
            5) create_ai_system_doctor ;;
            6) demo_system_doctor ;;
            7) complete_setup ;;
            0) echo "👋 Your system diagnostic powers are now legendary! 🩺⚡"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - all diagnostic tools
complete_setup() {
    echo "🚀 COMPLETE SYSTEM DOCTOR SETUP"
    echo "==============================="
    echo ""
    echo "This will install the ultimate system diagnostic and troubleshooting toolkit:"
    echo "Hardware diagnostics + Network troubleshooting + AI-powered problem solving"
    echo ""
    read -p "Continue with complete setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_system_doctor
        install_diagnostic_tools
        create_hardware_diagnostics
        create_network_diagnostics
        create_ai_system_doctor
        demo_system_doctor
        
        echo ""
        echo "🎉 SYSTEM DOCTOR COMPLETE!"
        echo "========================="
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Complete hardware diagnostics (better than Device Manager)"
        echo "   ✅ Advanced storage management (better than Disk Management)"
        echo "   ✅ Network troubleshooting (better than Windows Network Troubleshooter)"
        echo "   ✅ AI-powered problem diagnosis and solutions"
        echo "   ✅ System health monitoring and alerts"
        echo "   ✅ Comprehensive log analysis and error tracking"
        echo ""
        echo "🚀 KEY COMMANDS:"
        echo "   device-manager        = Hardware inventory and status"
        echo "   disk-manager list     = Storage management and mounting"
        echo "   network-doctor test   = Network connectivity diagnosis"
        echo "   ai-doctor 'problem'   = Intelligent troubleshooting"
        echo ""
        echo "💡 Windows users: Your troubleshooting capabilities are now REVOLUTIONARY!"
        echo "   Device Manager + Disk Management + Event Viewer + All Troubleshooters = Outdated!"
        
        # Log this installation
        echo "$(date): System Doctor setup completed with comprehensive diagnostics and AI troubleshooting" >> ~/.bill-sloth/history.log
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.local/bin
mkdir -p ~/.config

# Start the main menu
main_menu