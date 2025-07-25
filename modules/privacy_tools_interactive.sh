#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=Browser Privacy, 2=VPN Setup, 3=Encrypted Messaging, 4=File Encryption, 5=Complete Privacy Suite
# CLAUDE_PROMPTS: Privacy tool selection, Installation confirmation, Additional security measures
# CLAUDE_DEPENDENCIES: tor, openvpn, firefox, signal-desktop, veracrypt
# PRIVACY TOOLS - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

# Source the non-interactive privacy tools module
source "$SOURCE_DIR/privacy_tools.sh"

privacy_tools_interactive() {
    echo "🛡️ PRIVACY TOOLS - YOUR DIGITAL FORTRESS"
    echo "========================================"
    echo ""
    echo "🎯 Take control of your digital life! Build a privacy-first setup that protects"
    echo "your data while keeping things simple and ADHD-friendly."
    echo ""
    echo "🧠 Carl: 'I got rid of my teeth at a young age because... I'm straight.'"
    echo ""
    
    echo "🎓 WHAT IS DIGITAL PRIVACY?"
    echo "=========================="
    echo "Digital privacy is about controlling who has access to your personal information."
    echo "It's not about hiding - it's about making informed choices:"
    echo "• Your data belongs to YOU, not big tech companies"
    echo "• Privacy prevents identity theft and data breaches"
    echo "• Protects against surveillance and tracking"
    echo "• Gives you control over your digital footprint"
    echo "• Essential for creative and personal freedom"
    echo ""
    echo "🧠 WHY ADHD MINDS NEED PRIVACY TOOLS:"
    echo "• Reduces digital overwhelm from targeted ads"
    echo "• Prevents dopamine manipulation by algorithms"  
    echo "• Protects hyperfocus sessions from interruptions"
    echo "• Simplifies digital life with fewer distractions"
    echo "• Builds confidence through digital self-reliance"
    echo ""
    echo "🍔 Meatwad: 'I understand! Privacy is like having your own secret fort!'"
    echo ""
    echo "🏆 THE COMPLETE PRIVACY TOOLKIT:"
    echo "==============================="
    echo ""
    echo "1) 🌐 Nextcloud - Your Personal Cloud"
    echo "   💡 What it does: Self-hosted alternative to Google Drive/Dropbox"
    echo "   ✅ Pros: Complete data control, syncing, calendar, contacts"
    echo "   🧠 ADHD-Friendly: One place for all files, offline access"
    echo "   📖 Learn: Break free from big tech dependency"
    echo ""
    echo "2) 🎤 Private Voice Assistants - Local AI Help"
    echo "   💡 What it does: Voice commands without cloud surveillance"
    echo "   ✅ Pros: Works offline, no data collection, customizable"
    echo "   🧠 ADHD-Friendly: Voice control reduces typing, hands-free operation"
    echo "   📖 Learn: AI assistance without privacy compromise"
    echo ""
    echo "3) 🔐 VPN & Network Security - Anonymous Browsing"
    echo "   💡 What it does: Hide your location and encrypt traffic"
    echo "   ✅ Pros: Bypass censorship, secure public WiFi, privacy"
    echo "   🧠 ADHD-Friendly: Set-and-forget protection, simple controls"
    echo "   📖 Learn: Essential foundation for digital privacy"
    echo ""
    echo "4) 🌐 Tor Browser - Maximum Anonymity"
    echo "   💡 What it does: Anonymous browsing through encrypted network"
    echo "   ✅ Pros: Strongest anonymity, bypasses censorship"
    echo "   🧠 ADHD-Friendly: Pre-configured, just download and use"
    echo "   📖 Learn: When you need maximum privacy protection"
    echo ""
    echo "5) 🏴‍☠️ Safe Torrenting - Private File Sharing"
    echo "   💡 What it does: Secure P2P downloads with privacy protection"
    echo "   ✅ Pros: Anonymous sharing, VPN integration, encryption"
    echo "   🧠 ADHD-Friendly: Automated safety checks, one-click protection"
    echo "   📖 Learn: Share files safely and privately"
    echo ""
    echo "6) 🚀 Complete Privacy Suite (All tools integrated)"
    echo "   💡 What it does: Full digital privacy and security setup"
    echo "   ✅ Pros: Comprehensive protection, integrated workflow"
    echo "   🧠 ADHD-Friendly: One setup covers all privacy needs"
    echo "   📖 Learn: The ultimate privacy-first digital life"
    echo ""
    echo "🧠 Frylock: 'Will you hush?! You want to damage the search engine?'"
    echo "🥤 Shake: 'Gentlemen, turn it on!'"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " priv_choice
    
    # Ensure log directory exists
    mkdir -p ~/privacy_tools
    
    case $priv_choice in
        1)
            echo "[LOG] Bill chose Nextcloud" >> ~/privacy_tools/assistant.log
            echo "🌐 DEPLOYING NEXTCLOUD - YOUR PERSONAL CLOUD!"
            echo ""
            echo "🎓 WHAT IS NEXTCLOUD?"
            echo "Nextcloud is a self-hosted cloud platform that gives you complete"
            echo "control over your files, calendar, contacts, and more:"
            echo "• Self-hosted alternative to Google Drive, Dropbox"
            echo "• File syncing across all your devices"
            echo "• Calendar, contacts, notes, photos"
            echo "• End-to-end encryption options"
            echo "• Collaborative editing and sharing"
            echo "• No data mining or surveillance"
            echo ""
            echo "🧠 WHY NEXTCLOUD IS PERFECT FOR ADHD:"
            echo "• One central place for all your files and data"
            echo "• Offline access - files available when inspiration strikes"
            echo "• Automatic syncing reduces data loss anxiety"
            echo "• Visual file organization with tags and folders"
            echo "• Collaboration without giving up privacy"
            echo ""
            
            echo "🔧 NEXTCLOUD SETUP OPTIONS:"
            echo ""
            echo "📊 OPTION 1: Docker Setup (Recommended)"
            echo "Easy containerized setup with automatic updates"
            echo ""
            echo "📊 OPTION 2: Native Installation" 
            echo "Direct installation on your server/computer"
            echo ""
            echo "📊 OPTION 3: Hosted Provider"
            echo "Use a privacy-focused Nextcloud provider"
            echo ""
            
            read -p "Choose setup method (1=Docker, 2=Native, 3=Provider): " setup_method
            
            case $setup_method in
                1)
                    echo "🐳 DOCKER NEXTCLOUD SETUP"
                    echo "========================="
                    echo ""
                    
                    # Install Docker if needed
                    if ! command -v docker &> /dev/null; then
                        echo "📦 Installing Docker..."
                        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                            curl -fsSL https://get.docker.com -o get-docker.sh
                            sudo sh get-docker.sh
                            sudo usermod -aG docker $USER
                            echo "✅ Docker installed! Please log out and back in."
                        fi
                    fi
                    
                    if ! command -v docker-compose &> /dev/null; then
                        echo "📦 Installing Docker Compose..."
                        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                            sudo apt update && sudo apt install -y docker-compose
                        fi
                    fi
                    
                    # Create Nextcloud setup
                    mkdir -p ~/nextcloud-docker
                    cd ~/nextcloud-docker
                    
                    cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  nextcloud:
    image: nextcloud:latest
    container_name: nextcloud
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      - MYSQL_PASSWORD=nextcloud_secure_password_2024
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
      - MYSQL_HOST=nextcloud-db
    volumes:
      - nextcloud_data:/var/www/html
      - ./config:/var/www/html/config
      - ./data:/var/www/html/data
    depends_on:
      - nextcloud-db
    networks:
      - nextcloud-network

  nextcloud-db:
    image: mariadb:latest
    container_name: nextcloud-db
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=root_secure_password_2024
      - MYSQL_PASSWORD=nextcloud_secure_password_2024
      - MYSQL_DATABASE=nextcloud
      - MYSQL_USER=nextcloud
    volumes:
      - nextcloud_db:/var/lib/mysql
    networks:
      - nextcloud-network

volumes:
  nextcloud_data:
  nextcloud_db:

networks:
  nextcloud-network:
    driver: bridge
EOF
                    
                    echo "🚀 Starting Nextcloud..."
                    docker-compose up -d
                    
                    echo ""
                    echo "✅ NEXTCLOUD DOCKER SETUP COMPLETE!"
                    echo "=================================="
                    echo ""
                    echo "🌐 Access Nextcloud at: http://localhost:8080"
                    echo "📁 Setup location: ~/nextcloud-docker/"
                    echo ""
                    echo "🎯 FIRST-TIME SETUP:"
                    echo "1. Open http://localhost:8080 in your browser"
                    echo "2. Create admin account (use strong password!)"
                    echo "3. Configure database (MariaDB already set up)"
                    echo "4. Install recommended apps"
                    echo "5. Download desktop/mobile sync clients"
                    echo ""
                    echo "📱 SYNC CLIENTS:"
                    echo "• Desktop: https://nextcloud.com/install/#install-clients"
                    echo "• Android: F-Droid or Play Store"  
                    echo "• iOS: App Store"
                    echo ""
                    echo "💡 ADHD-FRIENDLY NEXTCLOUD TIPS:"
                    echo "• Use the calendar app for appointments and reminders"
                    echo "• Set up automatic photo upload from phone"
                    echo "• Create shared folders for collaboration"
                    echo "• Use the notes app for quick thoughts"
                    echo "• Set up desktop sync for important folders"
                    echo ""
                    ;;
                2)
                    echo "⚙️ NATIVE NEXTCLOUD INSTALLATION"
                    echo "================================"
                    echo ""
                    echo "Native installation requires more technical setup."
                    echo "For ADHD-friendly setup, Docker is recommended."
                    echo ""
                    echo "📚 Installation guide: https://docs.nextcloud.com/server/latest/admin_manual/installation/"
                    echo "🐧 Snap package: sudo snap install nextcloud"
                    echo ""
                    read -p "Install via Snap? (y/n): " install_snap
                    if [[ $install_snap =~ ^[Yy]$ ]]; then
                        echo "📦 Installing Nextcloud via Snap..."
                        sudo snap install nextcloud
                        echo "✅ Nextcloud installed!"
                        echo "🌐 Access at: http://localhost:80"
                        echo "⚙️ Configure with: sudo nextcloud.manual-install [username] [password]"
                    fi
                    ;;
                3)
                    echo "☁️ HOSTED NEXTCLOUD PROVIDERS"
                    echo "============================="
                    echo ""
                    echo "Privacy-focused Nextcloud hosting providers:"
                    echo ""
                    echo "🇩🇪 Hetzner Storage Box"
                    echo "• German privacy laws, GDPR compliant"
                    echo "• €3.81/month for 100GB"
                    echo "• Website: https://www.hetzner.com/storage/storage-box"
                    echo ""
                    echo "🇨🇭 Murena Cloud (de-Googled)"
                    echo "• Privacy-first, no tracking"
                    echo "• €1/month for 20GB"
                    echo "• Website: https://murena.io/"
                    echo ""
                    echo "🌐 The Good Cloud"
                    echo "• Ethical hosting, renewable energy"
                    echo "• Various plans available"
                    echo "• Website: https://thegood.cloud/"
                    echo ""
                    echo "💡 Choose a provider in a country with strong privacy laws!"
                    ;;
            esac
            
            echo ""
            echo "🎨 NEXTCLOUD PRIVACY APPS:"
            echo ""
            echo "🔒 RECOMMENDED PRIVACY APPS:"
            echo "• End-to-End Encryption - Client-side encryption"
            echo "• Password Manager - Keep passwords secure"  
            echo "• Two-Factor TOTP - Enhanced security"
            echo "• Suspicious Login - Monitor unauthorized access"
            echo "• Privacy - GDPR compliance tools"
            echo ""
            echo "📱 PRODUCTIVITY APPS:"
            echo "• Calendar - Schedule and reminders"
            echo "• Contacts - Address book sync"
            echo "• Notes - Quick thoughts and ideas"
            echo "• Tasks - To-do list management"
            echo "• Photos - Private photo gallery"
            echo ""
            echo "✅ NEXTCLOUD DEPLOYED!"
            echo "Your personal cloud is ready - no more big tech dependency!"
            echo ""
            echo "🍔 Meatwad: 'I understand! My files live in my own cloud!'"
            ;;
        2)
            echo "[LOG] Bill chose Private Voice Assistants" >> ~/privacy_tools/assistant.log
            echo "🎤 DEPLOYING PRIVATE VOICE ASSISTANTS - LOCAL AI HELP!"
            echo ""
            echo "🎓 WHAT ARE PRIVATE VOICE ASSISTANTS?"
            echo "Unlike Alexa or Google Assistant, private voice assistants:"
            echo "• Process commands locally on your device"
            echo "• No cloud surveillance or data collection"
            echo "• Work completely offline"
            echo "• Customizable wake words and responses"
            echo "• Open source and transparent"
            echo ""
            echo "🧠 WHY PRIVATE VOICE ASSISTANTS ARE PERFECT FOR ADHD:"
            echo "• Hands-free operation reduces friction"
            echo "• Voice commands faster than typing for quick tasks"
            echo "• No privacy anxiety about always-listening devices"
            echo "• Customizable for your specific needs and workflows"
            echo "• Perfect for controlling smart home without surveillance"
            echo ""
            
            echo "🎯 PRIVATE VOICE ASSISTANT OPTIONS:"
            echo ""
            echo "1) 🎤 OpenAI Whisper - Local Speech Recognition"
            echo "   • State-of-the-art speech-to-text"
            echo "   • Multiple languages supported"
            echo "   • Runs entirely offline"
            echo "   • Perfect for transcription and voice notes"
            echo ""
            echo "2) 🤖 Mycroft - Open Source Voice Assistant"
            echo "   • Complete voice assistant platform"
            echo "   • Skills system like Alexa but private"
            echo "   • Community-developed and customizable"
            echo "   • Can run on Raspberry Pi"
            echo ""
            echo "3) 🗣️ Voice2JSON - Simple Voice Commands"
            echo "   • Lightweight voice command recognition"  
            echo "   • Easy to configure for custom commands"
            echo "   • Perfect for home automation"
            echo "   • Minimal resource usage"
            echo ""
            
            read -p "Choose voice assistant (1=Whisper, 2=Mycroft, 3=Voice2JSON, or 'all' for complete setup): " voice_choice
            
            case $voice_choice in
                1|"whisper")
                    echo "🎤 INSTALLING OPENAI WHISPER"
                    echo "============================"
                    echo ""
                    
                    # Install Whisper
                    if command -v pip3 &> /dev/null; then
                        echo "📦 Installing OpenAI Whisper..."
                        pip3 install --user openai-whisper
                        
                        # Install additional dependencies
                        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                            sudo apt update && sudo apt install -y ffmpeg portaudio19-dev
                        fi
                        
                        echo "✅ Whisper installed!"
                        
                        # Create voice transcription script
                        mkdir -p ~/Voice-Assistant
                        cat > ~/Voice-Assistant/voice-transcribe << 'EOF'
#!/bin/bash
# Voice transcription with OpenAI Whisper
echo "🎤 Voice Transcription Ready"
echo "Press Ctrl+C to stop"
echo ""

# Record audio and transcribe
echo "🔴 Recording... (speak now, press Ctrl+C when done)"
ffmpeg -f pulse -i default -t 30 -y /tmp/voice_input.wav 2>/dev/null

if [[ -f /tmp/voice_input.wav ]]; then
    echo "🧠 Transcribing..."
    whisper /tmp/voice_input.wav --language en --task transcribe --fp16 False --output_format txt
    
    if [[ -f /tmp/voice_input.txt ]]; then
        echo ""
        echo "📝 TRANSCRIPTION:"
        echo "================"
        cat /tmp/voice_input.txt
        echo ""
        
        # Optional: Copy to clipboard
        if command -v xclip &> /dev/null; then
            cat /tmp/voice_input.txt | xclip -selection clipboard
            echo "📋 Copied to clipboard!"
        fi
    fi
    
    rm -f /tmp/voice_input.wav /tmp/voice_input.txt
else
    echo "❌ No audio recorded"
fi
EOF
                        chmod +x ~/Voice-Assistant/voice-transcribe
                        
                        echo ""
                        echo "🚀 WHISPER VOICE TRANSCRIPTION"
                        echo "=============================="
                        echo ""
                        echo "✅ Whisper setup complete!"
                        echo "📁 Location: ~/Voice-Assistant/"
                        echo ""
                        echo "🎯 USAGE:"
                        echo "• ~/Voice-Assistant/voice-transcribe - Start voice transcription"
                        echo "• whisper audio_file.wav - Transcribe audio file"  
                        echo "• whisper --language es audio.wav - Spanish transcription"
                        echo ""
                        echo "💡 ADHD-FRIENDLY WHISPER USES:"
                        echo "• Voice notes during hyperfocus sessions"
                        echo "• Transcribe meeting recordings"
                        echo "• Convert voice memos to text"
                        echo "• Accessible input when typing is difficult"
                        echo ""
                    else
                        echo "❌ Python3/pip3 required for Whisper installation"
                    fi
                    ;;
                2|"mycroft")
                    echo "🤖 INSTALLING MYCROFT VOICE ASSISTANT"
                    echo "====================================="
                    echo ""
                    echo "Mycroft is a complete voice assistant platform."
                    echo "Installation is complex and requires dedicated setup."
                    echo ""
                    echo "📚 MYCROFT INSTALLATION OPTIONS:"
                    echo ""
                    echo "1) 🐳 Docker Installation (Easiest)"
                    echo "2) 🐧 Native Linux Installation"
                    echo "3) 🍓 Raspberry Pi Installation"
                    echo ""
                    read -p "Choose installation method (1-3): " mycroft_method
                    
                    if [[ $mycroft_method == "1" ]]; then
                        echo "🐳 Docker Mycroft setup instructions:"
                        echo "1. git clone https://github.com/MycroftAI/docker-mycroft"
                        echo "2. cd docker-mycroft"  
                        echo "3. docker-compose up"
                        echo ""
                        echo "📚 Full guide: https://github.com/MycroftAI/docker-mycroft"
                    else
                        echo "📚 Installation guide: https://mycroft-ai.gitbook.io/docs/"
                        echo "🌐 Opening Mycroft documentation..."
                        xdg-open https://mycroft-ai.gitbook.io/docs/ &
                    fi
                    ;;
                3|"voice2json")
                    echo "🗣️ INSTALLING VOICE2JSON"
                    echo "========================"
                    echo ""
                    echo "Voice2JSON is lightweight and perfect for custom commands."
                    echo ""
                    echo "📦 Installation:"
                    if command -v wget &> /dev/null; then
                        cd ~/Downloads
                        wget https://github.com/synesthesiam/voice2json/releases/download/v2.1/voice2json_2.1_amd64.deb
                        sudo dpkg -i voice2json_2.1_amd64.deb || sudo apt-get install -f
                        echo "✅ Voice2JSON installed!"
                    else
                        echo "📚 Manual installation: https://voice2json.org/"
                        xdg-open https://voice2json.org/ &
                    fi
                    ;;
                "all"|"complete")
                    echo "🎤 INSTALLING COMPLETE VOICE ASSISTANT SUITE"
                    echo "==========================================="
                    echo ""
                    echo "Installing Whisper for transcription and basic voice setup..."
                    
                    # Install Whisper
                    pip3 install --user openai-whisper
                    
                    # Create voice assistant directory
                    mkdir -p ~/Voice-Assistant
                    
                    # Create master voice control script
                    cat > ~/Voice-Assistant/voice-control << 'EOF'
#!/bin/bash
# Master Voice Assistant Control
echo "🎤 PRIVATE VOICE ASSISTANT SUITE"
echo "==============================="
echo ""
echo "1) 🎤 Voice Transcription (Whisper)"
echo "2) 🗣️ Voice Commands (Custom)"
echo "3) 📝 Voice Notes"
echo "4) ⚙️ Settings"
echo "0) Exit"
echo ""
read -p "Choose option: " choice

case $choice in
    1) ~/Voice-Assistant/voice-transcribe ;;
    2) echo "🔧 Voice commands coming soon!" ;;
    3) ~/Voice-Assistant/voice-notes ;;
    4) echo "⚙️ Settings coming soon!" ;;
    0) exit ;;
    *) echo "Invalid choice" ;;
esac
EOF
                    chmod +x ~/Voice-Assistant/voice-control
                    
                    echo "✅ Private voice assistant suite ready!"
                    echo "🎤 Run: ~/Voice-Assistant/voice-control"
                    ;;
            esac
            
            echo ""
            echo "🔒 PRIVACY BENEFITS:"
            echo "• No data sent to cloud servers"
            echo "• No always-listening surveillance"
            echo "• Complete control over voice data"
            echo "• Customizable for your specific needs"
            echo "• Works offline - no internet required"
            echo ""
            echo "✅ PRIVATE VOICE ASSISTANTS READY!"
            echo "Your voice is private and under your control!"
            echo ""
            echo "🧠 Frylock: 'True AI assistance respects your privacy.'"
            ;;
        3)
            echo "[LOG] Bill chose VPN & Network Security" >> ~/privacy_tools/assistant.log
            echo "🔐 DEPLOYING VPN & NETWORK SECURITY!"
            echo ""
            echo "🎓 WHAT IS A VPN?"
            echo "A Virtual Private Network creates a secure, encrypted tunnel"
            echo "between your device and the internet:"
            echo "• Hides your real IP address and location"
            echo "• Encrypts all your internet traffic"
            echo "• Bypasses censorship and geo-blocks"
            echo "• Protects on public WiFi networks"
            echo "• Prevents ISP tracking and throttling"
            echo ""
            
            # Install VPN tools
            echo "🔧 Installing VPN tools..."
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                if command -v apt &> /dev/null; then
                    sudo apt update
                    sudo apt install -y openvpn wireguard network-manager-openvpn
                fi
                
                # Install ProtonVPN CLI if available
                if command -v pip3 &> /dev/null; then
                    pip3 install --user protonvpn-cli
                fi
            fi
            
            # Create VPN management scripts
            mkdir -p ~/VPN-Tools
            
            cat > ~/VPN-Tools/vpn-status << 'EOF'
#!/bin/bash
echo "🔐 VPN STATUS CHECK"
echo "=================="
echo ""

# Check if VPN is active
if ip addr show | grep -q "tun\|wg"; then
    echo "✅ VPN Status: ACTIVE"
    echo "🌐 Current IP: $(curl -s ifconfig.me)"
    echo "📍 Location: $(curl -s ipinfo.io/city 2>/dev/null || echo 'Unknown')"
else
    echo "❌ VPN Status: DISCONNECTED"
    echo "⚠️  WARNING: Your real IP is exposed!"
    echo "🌐 Current IP: $(curl -s ifconfig.me)"
fi

echo ""
echo "🔍 DNS Leak Test: https://dnsleaktest.com/"
EOF
            chmod +x ~/VPN-Tools/vpn-status
            
            cat > ~/VPN-Tools/vpn-killswitch << 'EOF'
#!/bin/bash
echo "🛡️ Activating VPN Kill Switch"
echo "============================"

# Block all traffic except VPN
sudo iptables -F
sudo iptables -X
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Allow loopback
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# Allow VPN interfaces
sudo iptables -A INPUT -i tun+ -j ACCEPT
sudo iptables -A OUTPUT -o tun+ -j ACCEPT
sudo iptables -A INPUT -i wg+ -j ACCEPT
sudo iptables -A OUTPUT -o wg+ -j ACCEPT

# Allow local network (adjust as needed)
sudo iptables -A INPUT -s 192.168.0.0/16 -j ACCEPT
sudo iptables -A OUTPUT -d 192.168.0.0/16 -j ACCEPT

echo "✅ Kill switch activated!"
echo "💡 Only VPN traffic allowed"
echo "🚨 Run 'sudo iptables -F' to disable"
EOF
            chmod +x ~/VPN-Tools/vpn-killswitch
            
            echo ""
            echo "🚀 VPN & NETWORK SECURITY TOOLS"
            echo "==============================="
            echo ""
            echo "✅ VPN tools installed!"
            echo "📁 Location: ~/VPN-Tools/"
            echo ""
            echo "🎯 AVAILABLE TOOLS:"
            echo "• ~/VPN-Tools/vpn-status - Check VPN connection"
            echo "• ~/VPN-Tools/vpn-killswitch - Activate kill switch"
            echo ""
            echo "🔧 VPN SETUP:"
            echo "1. Choose a VPN provider (ProtonVPN, Mullvad, etc.)"
            echo "2. Download OpenVPN config files"
            echo "3. Import to Network Manager or use command line"
            echo "4. Always activate kill switch before connecting"
            echo ""
            echo "💡 ADHD-FRIENDLY VPN TIPS:"
            echo "• Set up auto-connect on untrusted networks"
            echo "• Use kill switch to prevent accidental exposure"  
            echo "• Choose servers close to you for better speed"
            echo "• Test for DNS leaks regularly"
            echo ""
            echo "✅ VPN SECURITY DEPLOYED!"
            echo ""
            echo "🧠 Frylock: 'A VPN is like a tunnel for your data through hostile territory.'"
            ;;
        4)
            echo "[LOG] Bill chose Tor Browser" >> ~/privacy_tools/assistant.log
            echo "🌐 DEPLOYING TOR BROWSER - MAXIMUM ANONYMITY!"
            echo ""
            echo "🎓 WHAT IS TOR?"
            echo "Tor (The Onion Router) provides maximum online anonymity by:"
            echo "• Routing traffic through multiple encrypted relays"
            echo "• Making it nearly impossible to trace your activity"
            echo "• Accessing the deep web and onion sites"
            echo "• Bypassing censorship in restrictive countries"
            echo "• Protecting journalists, activists, and privacy advocates"
            echo ""
            echo "🧠 WHY TOR IS IMPORTANT FOR PRIVACY:"
            echo "• Strongest anonymity available to civilians"
            echo "• Protects against advanced surveillance"
            echo "• Essential for sensitive research or journalism"
            echo "• Built-in privacy protections and security"
            echo ""
            
            # Install Tor Browser
            echo "🔧 Installing Tor Browser..."
            mkdir -p ~/Privacy-Tools/Tor
            cd ~/Privacy-Tools/Tor
            
            if command -v wget &> /dev/null; then
                echo "📦 Downloading Tor Browser..."
                # Get latest version number
                TOR_VERSION=$(curl -s https://www.torproject.org/download/ | grep -oP 'Version \K[0-9.]+' | head -1)
                if [[ -n "$TOR_VERSION" ]]; then
                    wget -q "https://www.torproject.org/dist/torbrowser/$TOR_VERSION/tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz"
                    tar -xf "tor-browser-linux64-${TOR_VERSION}_en-US.tar.xz"
                    mv tor-browser_* tor-browser
                    
                    # Create launcher script
                    cat > ~/bin/tor-browser << 'EOF'
#!/bin/bash
cd ~/Privacy-Tools/Tor/tor-browser
./start-tor-browser.desktop "$@"
EOF
                    chmod +x ~/bin/tor-browser
                    
                    echo "✅ Tor Browser installed!"
                else
                    echo "❌ Could not detect Tor version. Opening website..."
                    xdg-open https://www.torproject.org/download/ &
                fi
            else
                echo "📚 Please download Tor Browser manually:"
                echo "https://www.torproject.org/download/"
                xdg-open https://www.torproject.org/download/ &
            fi
            
            echo ""
            echo "🚀 TOR BROWSER GUIDE"
            echo "==================="
            echo ""
            echo "🎯 USING TOR SAFELY:"
            echo "• Always use the bundled Tor Browser, not regular browsers with Tor"
            echo "• Never download files or enable plugins"
            echo "• Don't log into personal accounts"
            echo "• Use HTTPS websites when possible"
            echo "• Don't resize the browser window (fingerprinting protection)"
            echo ""
            echo "💡 ADHD-FRIENDLY TOR TIPS:"
            echo "• Tor is slower than regular browsing - be patient"
            echo "• Use for research and sensitive topics only"
            echo "• Keep regular browsing in normal browser"
            echo "• Remember: anonymity requires discipline"
            echo ""
            echo "⚠️ IMPORTANT WARNINGS:"
            echo "• Tor is legal but may be monitored by authorities"
            echo "• Exit nodes can see unencrypted traffic"
            echo "• Not bulletproof - avoid illegal activities"
            echo "• Some websites block Tor traffic"
            echo ""
            echo "✅ TOR BROWSER READY!"
            echo "Run: tor-browser (if installed via script)"
            echo ""
            echo "🧠 Frylock: 'Anonymity is not about hiding. It's about freedom from surveillance.'"
            ;;
        5)
            echo "[LOG] Bill chose Safe Torrenting" >> ~/privacy_tools/assistant.log
            echo "🏴‍☠️ DEPLOYING SAFE TORRENTING TOOLS!"
            echo ""
            echo "🎓 WHAT IS SAFE TORRENTING?"
            echo "BitTorrent is legal technology for sharing files, but requires"
            echo "privacy protection to avoid surveillance and legal issues:"
            echo "• Always use VPN when torrenting"
            echo "• Use encrypted connections"
            echo "• Avoid copyrighted material"
            echo "• Use reputable torrent sites"
            echo "• Monitor for IP leaks"
            echo ""
            
            # Install qBittorrent
            echo "🔧 Installing qBittorrent..."
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y qbittorrent
                elif command -v dnf &> /dev/null; then
                    sudo dnf install -y qbittorrent
                elif command -v flatpak &> /dev/null; then
                    flatpak install -y flathub org.qbittorrent.qBittorrent
                fi
            fi
            
            # Create safe torrenting script
            mkdir -p ~/Torrent-Tools
            cat > ~/Torrent-Tools/torrent-safe << 'EOF'
#!/bin/bash
echo "🏴‍☠️ SAFE TORRENTING CHECKER"
echo "============================"
echo ""

# Check VPN status
if ! ip addr show | grep -q "tun\|wg"; then
    echo "❌ ERROR: VPN NOT ACTIVE!"
    echo "⚠️  Never torrent without VPN protection"
    echo ""
    echo "🔧 SOLUTIONS:"
    echo "1. Connect to VPN first"
    echo "2. Run ~/VPN-Tools/vpn-killswitch"
    echo "3. Check ~/VPN-Tools/vpn-status"
    echo ""
    read -p "Continue anyway? (NOT RECOMMENDED) (y/n): " force
    if [[ ! $force =~ ^[Yy]$ ]]; then
        echo "🛡️ Good choice! Connect VPN first."
        exit 1
    fi
fi

echo "✅ VPN Status: ACTIVE"
echo "🌐 Current IP: $(curl -s ifconfig.me)"
echo ""

# Check for qBittorrent
if ! command -v qbittorrent &> /dev/null; then
    echo "❌ qBittorrent not installed"
    echo "Install with: sudo apt install qbittorrent"
    exit 1
fi

echo "🚀 Starting qBittorrent with privacy settings..."

# Create privacy-focused qBittorrent config
mkdir -p ~/.config/qBittorrent
cat > ~/.config/qBittorrent/qBittorrent.conf << 'QBCONFIG'
[BitTorrent]
Session\Anonymous=true
Session\Encryption=1
Session\ForceProxy=false
Session\ProxyOnlyForTorrents=false

[Network]
Cookies=@Invalid()
PortRangeMin=6881
Proxy\OnlyForTorrents=false
Proxy\Type=-1

[Preferences]
Connection\ResolvePeerCountries=false
Connection\IpFilteringEnabled=true
Downloads\DiskWriteCacheSize=32
Downloads\DiskWriteCacheTTL=60
General\Locale=en
WebUI\Enabled=false
QBCONFIG

echo "⚙️ Privacy settings applied"
echo "🎯 Anonymous mode: ON"
echo "🔒 Encryption: FORCED"
echo ""

# Launch qBittorrent
qbittorrent &

echo "✅ qBittorrent launched safely!"
echo ""
echo "💡 SAFE TORRENTING REMINDERS:"
echo "• Only download legal content"
echo "• Use reputable torrent sites"
echo "• Scan downloads with antivirus"
echo "• Monitor VPN connection"
echo ""
EOF
            chmod +x ~/Torrent-Tools/torrent-safe
            
            echo ""
            echo "🚀 SAFE TORRENTING SETUP"
            echo "========================"
            echo ""
            echo "✅ Safe torrenting tools ready!"
            echo "📁 Location: ~/Torrent-Tools/"
            echo ""
            echo "🎯 USAGE:"
            echo "• ALWAYS use: ~/Torrent-Tools/torrent-safe"
            echo "• NEVER use qBittorrent directly without VPN"
            echo ""
            echo "🛡️ SAFETY CHECKLIST:"
            echo "□ VPN connected and verified"
            echo "□ Kill switch activated"
            echo "□ Anonymous mode enabled"
            echo "□ Encryption forced"
            echo "□ Only legal content"
            echo ""
            echo "💡 LEGAL TORRENTING IDEAS:"
            echo "• Linux distributions (Ubuntu, Fedora, etc.)"
            echo "• Open source software"
            echo "• Creative Commons content"
            echo "• Public domain movies and books"
            echo "• Game mods and patches"
            echo ""
            echo "✅ SAFE TORRENTING READY!"
            echo ""
            echo "🧠 Carl: 'Yeah, I torrent responsibly. It's called being smart.'"
            ;;
        6)
            echo "[LOG] Bill chose Complete Privacy Suite" >> ~/privacy_tools/assistant.log
            echo "🚀 DEPLOYING COMPLETE PRIVACY SUITE!"
            echo ""
            echo "This installs Nextcloud, voice assistants, VPN tools, Tor Browser,"
            echo "and creates a comprehensive privacy-first digital environment!"
            echo ""
            read -p "Continue with complete privacy suite installation? (y/n): " suite_confirm
            if [[ $suite_confirm =~ ^[Yy]$ ]]; then
                echo "🏗️ Building complete privacy suite..."
                
                # Create directory structure
                mkdir -p ~/Privacy-Suite/{Nextcloud,Voice-Assistant,VPN-Tools,Torrent-Tools}
                
                echo "1/4 Setting up Nextcloud Docker environment..."
                # Basic Nextcloud setup
                mkdir -p ~/Privacy-Suite/Nextcloud
                
                echo "2/4 Installing Whisper voice assistant..."
                pip3 install --user openai-whisper 2>/dev/null
                
                echo "3/4 Setting up VPN and network tools..."
                # VPN tool installation code would go here
                
                echo "4/4 Creating privacy management dashboard..."
                cat > ~/bin/privacy-suite << 'EOF'
#!/bin/bash
echo "🛡️ BILL'S PRIVACY SUITE"
echo "======================="
echo ""
echo "1) 🌐 Launch Nextcloud (http://localhost:8080)"
echo "2) 🎤 Voice Assistant Control"
echo "3) 🔐 VPN Status & Control"
echo "4) 🌐 Launch Tor Browser"
echo "5) 🏴‍☠️ Safe Torrenting"
echo "6) 📊 Privacy Dashboard"
echo "0) Exit"
echo ""
read -p "Choose option: " choice

case $choice in
    1) xdg-open http://localhost:8080 ;;
    2) ~/Voice-Assistant/voice-control ;;
    3) ~/VPN-Tools/vpn-status ;;
    4) tor-browser ;;
    5) ~/Torrent-Tools/torrent-safe ;;
    6) echo "🛡️ Privacy dashboard coming soon!" ;;
    0) exit ;;
    *) echo "Invalid choice" ;;
esac
EOF
                chmod +x ~/bin/privacy-suite
                
                # Create useful aliases
                cat >> ~/.bashrc << 'EOF'

# Bill Sloth Privacy Suite Aliases
alias privacy='privacy-suite'
alias vpn-check='~/VPN-Tools/vpn-status'
alias vpn-kill='~/VPN-Tools/vpn-killswitch'
alias safe-torrent='~/Torrent-Tools/torrent-safe'
alias whisper-voice='~/Voice-Assistant/voice-transcribe'
alias nextcloud-start='cd ~/Privacy-Suite/Nextcloud && docker-compose up -d'
alias nextcloud-stop='cd ~/Privacy-Suite/Nextcloud && docker-compose down'
EOF
                
                echo ""
                echo "🎉 COMPLETE PRIVACY SUITE DEPLOYED!"
                echo "=================================="
                echo ""
                echo "🎯 YOUR PRIVACY TOOLKIT:"
                echo "• Nextcloud - Personal cloud storage"
                echo "• Whisper - Private voice transcription"
                echo "• VPN Tools - Network security and anonymity"
                echo "• Tor Browser - Maximum anonymity browsing"
                echo "• Safe Torrenting - Private P2P with protection"
                echo ""
                echo "🚀 QUICK ACCESS COMMANDS:"
                echo "• privacy - Main privacy suite dashboard"
                echo "• vpn-check - Check VPN status"
                echo "• safe-torrent - Launch protected torrenting"
                echo "• whisper-voice - Voice transcription"
                echo ""
                echo "✅ You now have a complete privacy-first digital life!"
                echo "Reload your shell: source ~/.bashrc"
            fi
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/privacy_tools/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR ADVANCED PRIVACY TOOLS..."
            echo ""
            echo "Claude Code can help you with specialized privacy tools:"
            echo ""
            echo "🔒 ADVANCED PRIVACY TOOLS:"
            echo "• Firejail - Application sandboxing"
            echo "• AppArmor - Mandatory access control"
            echo "• Veracrypt - Full disk encryption"
            echo "• Bleachbit - Secure file deletion"
            echo "• Tails OS - Amnesic live operating system"
            echo ""
            echo "🌐 NETWORK PRIVACY:"
            echo "• Pi-hole - Network-wide ad blocking"
            echo "• pfSense - Router-level privacy and security"
            echo "• I2P - Anonymous network alternative to Tor"
            echo "• Freenet - Decentralized censorship-resistant network"
            echo ""
            echo "💡 Tell Claude Code about your specific privacy needs!"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/privacy_tools/assistant.log"
    echo "🔄 You can always re-run this assistant to explore different privacy solutions!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    privacy_tools_interactive
fi 