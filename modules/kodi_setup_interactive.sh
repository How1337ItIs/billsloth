#!/bin/bash
# LLM_CAPABILITY: local_ok
# Kodi Debrid Setup - Complete interactive installer and configuration guide
# "I got the eye of the tiger, a fighter!" - Master Shake

source "../lib/interactive.sh" 2>/dev/null || {
    echo "🎬 KODI DEBRID SETUP"
    echo "=================="
}

show_banner "KODI DEBRID SETUP" "Stream like a champion" "GAMING"

echo "🎬 Welcome to the Kodi Debrid Setup Guide!"
echo "This module will help you install Kodi with premium debrid services for high-quality streaming."
echo ""
echo "⚠️  IMPORTANT LEGAL NOTICE:"
echo "   - Always use a VPN when streaming"
echo "   - Only stream content you own or have legal access to"
echo "   - Debrid services are for personal backup and legal streaming only"
echo "   - Check your local laws regarding streaming"
echo ""

# What is Debrid explanation
explain_debrid() {
    echo "💡 WHAT IS DEBRID?"
    echo "=================="
    echo ""
    echo "Debrid services are premium link generators that provide:"
    echo "• 🎯 High-quality streaming links (1080p, 4K)"
    echo "• ⚡ Fast, reliable connections"
    echo "• 🔒 Secure downloads from file hosts"
    echo "• 📱 No ads or popups"
    echo "• 🌍 Global server network"
    echo ""
    echo "Think of it as Netflix for your own content collection!"
    echo ""
    echo "🏆 TOP DEBRID SERVICES:"
    echo "1. Real-Debrid (~$3/month) - Most popular, great compatibility"
    echo "2. AllDebrid (~$4/month) - Good alternative, similar features"  
    echo "3. Premiumize (~$7/month) - Premium option with VPN included"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

# Kodi installation
install_kodi() {
    echo "📦 INSTALLING KODI"
    echo "=================="
    echo ""
    
    if command -v kodi &> /dev/null; then
        echo "✅ Kodi is already installed!"
        KODI_VERSION=$(kodi --version 2>/dev/null | head -1 || echo "Unknown version")
        echo "   Version: $KODI_VERSION"
    else
        echo "Installing Kodi..."
        
        # Detect OS and install accordingly
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Ubuntu/Debian
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y software-properties-common
                sudo add-apt-repository -y ppa:team-xbmc/ppa
                sudo apt update
                sudo apt install -y kodi
            # Fedora/CentOS
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y kodi
            # Arch Linux
            elif command -v pacman &> /dev/null; then
                sudo pacman -S kodi
            fi
            
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install --cask kodi
            else
                echo "Please install Homebrew first, then run: brew install --cask kodi"
                return 1
            fi
            
        else
            echo "❌ Unsupported operating system"
            echo "Please manually download Kodi from: https://kodi.tv/download"
            return 1
        fi
        
        echo "✅ Kodi installation complete!"
    fi
    echo ""
    read -p "Press Enter to continue..."
    clear
}

# Build selection menu
choose_build() {
    echo "🏗️  CHOOSE YOUR KODI BUILD"
    echo "=========================="
    echo ""
    echo "Builds are pre-configured Kodi setups with addons and themes."
    echo "We recommend lightweight, debrid-compatible builds:"
    echo ""
    echo "🥇 RECOMMENDED BUILDS (2025):"
    echo ""
    echo "1) 🚀 Xenon Build - #1 Rated"
    echo "   • Size: ~200MB"
    echo "   • Features: Futuristic UI, Real-Debrid ready"
    echo "   • Best for: All devices, especially Fire TV"
    echo ""
    echo "2) ⚡ Atomic Build - Lightweight Champion"  
    echo "   • Size: ~150MB"
    echo "   • Features: Fast, works on low-spec devices"
    echo "   • Best for: Fire Stick, Android TV boxes"
    echo ""
    echo "3) 💎 HardNox Ultra - Beautiful & Powerful"
    echo "   • Size: ~180MB"
    echo "   • Features: Aeon Nox skin, premium addons"
    echo "   • Best for: Users who want style + performance"
    echo ""
    echo "4) 🟢 Green Monster - Versatile"
    echo "   • Size: ~170MB" 
    echo "   • Features: Great UI, frequently updated"
    echo "   • Best for: General purpose streaming"
    echo ""
    echo "5) 🔥 Nova TV - Ultra Light"
    echo "   • Size: ~120MB"
    echo "   • Features: Minimal but powerful"
    echo "   • Best for: Very low RAM devices"
    echo ""
    echo "6) ⚛️  Manual Setup - DIY Approach"
    echo "   • Install individual addons yourself"
    echo "   • Best for: Advanced users"
    echo ""
    
    read -p "Choose your build (1-6): " build_choice
    
    case $build_choice in
        1) install_xenon_build ;;
        2) install_atomic_build ;;
        3) install_hardnox_build ;;
        4) install_green_monster_build ;;
        5) install_nova_build ;;
        6) manual_setup ;;
        *) echo "Invalid choice. Please run the script again."; exit 1 ;;
    esac
}

# Xenon Build installation
install_xenon_build() {
    echo "🚀 INSTALLING XENON BUILD"
    echo "========================"
    echo ""
    echo "This will install the Xenon build - rated #1 for 2025!"
    echo ""
    
    cat << 'EOF'
📋 INSTALLATION STEPS:

1. Open Kodi
2. Go to Settings (gear icon) > System > Add-ons
3. Enable "Unknown sources" - click YES when prompted
4. Go back to Settings > File manager
5. Click "Add source"
6. Click "<None>"
7. Enter this URL: http://repo.appwizards.org/
8. Name it: "appwizards"
9. Click OK twice
10. Go to Add-ons from home screen
11. Click "Install from zip file"
12. Select "appwizards"
13. Install: plugin.program.appwizards-x.x.x.zip
14. Go to Add-ons > Program add-ons > App Wizards
15. Select "Xenon" 
16. Choose "Fresh Install"
17. Wait for installation to complete (5-10 minutes)
18. Force close Kodi and reopen

🎯 The Xenon interface will load with all addons ready!
EOF
    
    echo ""
    read -p "Ready to install? Press Enter to continue or Ctrl+C to cancel..."
    
    echo "🚀 Starting Kodi for you to follow the steps above..."
    nohup kodi > /dev/null 2>&1 &
    
    echo ""
    echo "✅ Follow the installation steps shown above"
    echo "💡 After installation, come back here to set up Real-Debrid"
    echo ""
    read -p "Press Enter when Xenon build installation is complete..."
    clear
}

# Atomic Build installation  
install_atomic_build() {
    echo "⚡ INSTALLING ATOMIC BUILD"
    echo "========================="
    echo ""
    echo "This will install the Atomic build - perfect for low-spec devices!"
    echo ""
    
    cat << 'EOF'
📋 INSTALLATION STEPS:

1. Open Kodi
2. Go to Settings > System > Add-ons
3. Enable "Unknown sources"
4. Go to Settings > File manager > Add source
5. Enter URL: http://misfitrepo.com/
6. Name it: "misfit"
7. Go to Add-ons > Install from zip file
8. Select "misfit"
9. Install: repository.misfitmods-x.x.x.zip
10. Go to Add-ons > Install from repository
11. Select "Misfit Mods Repository"
12. Go to Program add-ons
13. Find and install "Atomic"
14. Go to Add-ons > Program add-ons > Atomic
15. Select your preferred version
16. Choose "Fresh Install" 
17. Wait for completion
18. Restart Kodi

⚡ Atomic build will be ready with optimized performance!
EOF
    
    echo ""
    read -p "Ready to install? Press Enter to continue..."
    
    echo "⚡ Starting Kodi..."
    nohup kodi > /dev/null 2>&1 &
    
    echo ""
    echo "✅ Follow the installation steps above"
    echo "💡 After installation, return here for debrid setup"
    echo ""
    read -p "Press Enter when Atomic build installation is complete..."
    clear
}

# HardNox build installation
install_hardnox_build() {
    echo "💎 INSTALLING HARDNOX ULTRA BUILD"
    echo "================================="
    echo ""
    echo "Beautiful Aeon Nox interface with premium addons!"
    echo ""
    
    cat << 'EOF'
📋 INSTALLATION STEPS:

1. Open Kodi
2. Settings > System > Add-ons > Enable "Unknown sources"
3. Settings > File manager > Add source
4. URL: http://hardnox.appboxes.co/
5. Name: "hardnox"  
6. Add-ons > Install from zip file > hardnox
7. Install: repository.hardnox-x.x.x.zip
8. Add-ons > Install from repository > HardNox Repository
9. Program add-ons > HardNox Ultra
10. Select "Fresh Install"
11. Wait for installation
12. Restart Kodi

💎 Enjoy the beautiful Aeon Nox interface!
EOF
    
    echo ""
    read -p "Ready to install? Press Enter to continue..."
    
    nohup kodi > /dev/null 2>&1 &
    
    echo ""
    echo "✅ Follow the steps above for HardNox Ultra installation"
    echo ""
    read -p "Press Enter when installation is complete..."
    clear
}

# Green Monster installation
install_green_monster_build() {
    echo "🟢 INSTALLING GREEN MONSTER BUILD"
    echo "================================="
    echo ""
    
    cat << 'EOF'
📋 INSTALLATION STEPS:

1. Open Kodi
2. Settings > System > Add-ons > Enable "Unknown sources"
3. Settings > File manager > Add source  
4. URL: http://greenmonster.xyz/repo/
5. Name: "greenmonster"
6. Add-ons > Install from zip file > greenmonster
7. Install repository zip file
8. Add-ons > Install from repository > Green Monster Repository
9. Program add-ons > Green Monster Build
10. Choose "Fresh Install"
11. Wait for completion
12. Restart Kodi

🟢 Green Monster build ready with versatile addons!
EOF
    
    read -p "Ready to install? Press Enter to continue..."
    nohup kodi > /dev/null 2>&1 &
    echo "✅ Follow the installation steps above"
    read -p "Press Enter when complete..."
    clear
}

# Nova TV installation
install_nova_build() {
    echo "🔥 INSTALLING NOVA TV BUILD"  
    echo "==========================="
    echo ""
    echo "Ultra-lightweight build perfect for low RAM devices!"
    echo ""
    
    cat << 'EOF'
📋 INSTALLATION STEPS:

1. Open Kodi
2. Settings > System > Add-ons > Enable "Unknown sources"
3. Settings > File manager > Add source
4. URL: http://nova.appboxes.co/
5. Name: "nova"
6. Add-ons > Install from zip file > nova  
7. Install repository zip file
8. Add-ons > Install from repository > Nova Repository
9. Program add-ons > Nova TV
10. Select "Fresh Install"
11. Wait for installation
12. Restart Kodi

🔥 Nova TV build ready - optimized for speed!
EOF
    
    read -p "Ready to install? Press Enter to continue..."
    nohup kodi > /dev/null 2>&1 &
    echo "✅ Follow the installation steps above"
    read -p "Press Enter when complete..."
    clear
}

# Manual setup for advanced users
manual_setup() {
    echo "⚛️  MANUAL ADDON SETUP"
    echo "====================="
    echo ""
    echo "Installing individual addons instead of a full build."
    echo "This gives you more control but requires more setup."
    echo ""
    echo "🎯 RECOMMENDED ADDONS FOR DEBRID:"
    echo ""
    echo "1. The Crew - Most popular, excellent debrid support"
    echo "2. Seren - Premium addon, requires Real-Debrid/Trakt"
    echo "3. Umbrella - Great alternative to The Crew"  
    echo "4. Asgard - Reliable with good debrid integration"
    echo "5. Magic Dragon - Large content library"
    echo ""
    
    echo "📋 MANUAL INSTALLATION PROCESS:"
    echo ""
    echo "For The Crew addon (most recommended):"
    echo "1. Add source: https://team-crew.github.io/"
    echo "2. Install The Crew Repository"
    echo "3. Install The Crew addon"
    echo "4. Configure with your debrid service"
    echo ""
    
    read -p "Continue with manual setup? (y/n): " manual_choice
    if [[ $manual_choice =~ ^[Yy]$ ]]; then
        nohup kodi > /dev/null 2>&1 &
        echo "✅ Kodi started - follow manual installation process"
        echo "💡 Refer to online guides for specific addon installation steps"
    fi
    
    read -p "Press Enter to continue to debrid setup..."
    clear
}

# Debrid service setup
setup_debrid() {
    echo "💳 DEBRID SERVICE SETUP"
    echo "======================="
    echo ""
    echo "Now let's set up your debrid service for premium streaming links!"
    echo ""
    echo "🔑 CHOOSE YOUR DEBRID SERVICE:"
    echo ""
    echo "1) 🥇 Real-Debrid (~$3.33/month)"
    echo "   • Most popular and compatible"
    echo "   • Works with all major addons"  
    echo "   • Great value for money"
    echo "   • 30+ file hosts supported"
    echo ""
    echo "2) 🥈 AllDebrid (~$4.17/month)" 
    echo "   • Good Real-Debrid alternative"
    echo "   • Similar features and compatibility"
    echo "   • Reliable service"
    echo ""
    echo "3) 🥉 Premiumize (~$7.50/month)"
    echo "   • Premium option with VPN included"
    echo "   • Built-in download manager"
    echo "   • Higher price but more features"
    echo ""
    echo "4) ⏩ Skip debrid setup for now"
    echo ""
    
    read -p "Choose your debrid service (1-4): " debrid_choice
    
    case $debrid_choice in
        1) setup_real_debrid ;;
        2) setup_alldebrid ;;  
        3) setup_premiumize ;;
        4) echo "Skipping debrid setup - you can set it up later"; return ;;
        *) echo "Invalid choice"; setup_debrid ;;
    esac
}

# Real-Debrid setup
setup_real_debrid() {
    echo "🥇 REAL-DEBRID SETUP"
    echo "===================="
    echo ""
    echo "Real-Debrid is the most popular debrid service!"
    echo ""
    echo "💳 ACCOUNT CREATION:"
    echo "1. Go to: https://real-debrid.com/signup"
    echo "2. Create account (email + password)"
    echo "3. Purchase premium subscription:"
    echo "   • 15 days: €3.00"
    echo "   • 30 days: €4.00" 
    echo "   • 90 days: €10.00"
    echo "   • 180 days: €18.00"
    echo ""
    echo "💡 TIP: Start with 30 days to test it out!"
    echo ""
    
    read -p "Have you created your Real-Debrid account? (y/n): " rd_account
    
    if [[ ! $rd_account =~ ^[Yy]$ ]]; then
        echo "Please create your Real-Debrid account first:"
        echo "https://real-debrid.com/signup"
        echo ""
        echo "Come back to this script after creating your account!"
        return
    fi
    
    echo ""
    echo "🔗 KODI CONFIGURATION:"
    echo "======================"
    echo ""
    echo "Now we'll connect Real-Debrid to your Kodi addons:"
    echo ""
    echo "📋 CONFIGURATION STEPS:"
    echo ""
    echo "METHOD 1 - Using The Crew addon:"
    echo "1. Open Kodi and go to Add-ons"
    echo "2. Open The Crew addon"  
    echo "3. Go to Tools/Settings menu"
    echo "4. Find 'Accounts' or 'Resolvers' section"
    echo "5. Select 'Real-Debrid'"
    echo "6. Click 'Authorize'"
    echo "7. You'll get a device code"
    echo "8. Go to: https://real-debrid.com/device"
    echo "9. Enter the device code"
    echo "10. Return to Kodi - authorization complete!"
    echo ""
    echo "METHOD 2 - Universal (works with any addon):"
    echo "1. Go to Kodi Settings > System > Add-ons"
    echo "2. Click 'My add-ons' > Video add-ons"
    echo "3. Find 'ResolveURL' and open it"
    echo "4. Go to Universal Resolvers > Real-Debrid"
    echo "5. Click 'Authorize My Account'"
    echo "6. Follow device authorization steps above"
    echo ""
    
    read -p "Ready to configure Real-Debrid in Kodi? Press Enter to start Kodi..."
    
    nohup kodi > /dev/null 2>&1 &
    
    echo ""
    echo "🎯 Kodi is starting..."
    echo "✅ Follow the configuration steps above"
    echo "🌐 Remember: Go to https://real-debrid.com/device to authorize"
    echo ""
    
    read -p "Press Enter when Real-Debrid setup is complete..."
    
    echo ""
    echo "🎉 REAL-DEBRID SETUP COMPLETE!"
    echo "==============================="
    echo ""
    echo "✅ Your Kodi is now configured with Real-Debrid!"
    echo "🎯 You should now see high-quality streaming links"
    echo "⚡ Links will be faster and more reliable"
    echo "🔒 Always use a VPN when streaming"
    echo ""
    clear
}

# AllDebrid setup  
setup_alldebrid() {
    echo "🥈 ALLDEBRID SETUP"
    echo "=================="
    echo ""
    echo "AllDebrid is a great Real-Debrid alternative!"
    echo ""
    echo "💳 ACCOUNT CREATION:"
    echo "1. Go to: https://alldebrid.com/register/"
    echo "2. Create account"
    echo "3. Purchase premium:"
    echo "   • 30 days: €3.00"
    echo "   • 90 days: €8.00"
    echo "   • 365 days: €25.00"
    echo ""
    
    read -p "Have you created your AllDebrid account? (y/n): " ad_account
    
    if [[ ! $ad_account =~ ^[Yy]$ ]]; then
        echo "Please create your AllDebrid account first:"
        echo "https://alldebrid.com/register/"
        return
    fi
    
    echo ""
    echo "🔗 KODI CONFIGURATION:"
    echo "======================"
    echo ""
    echo "📋 CONFIGURATION STEPS:"
    echo "1. Open Kodi and your addon (The Crew, Seren, etc.)"
    echo "2. Go to addon settings/tools"
    echo "3. Find 'AllDebrid' in resolvers/accounts"
    echo "4. Enter your AllDebrid username and password"
    echo "   OR use API key method if available"
    echo "5. Test the connection"
    echo ""
    
    read -p "Ready to configure? Press Enter to start Kodi..."
    nohup kodi > /dev/null 2>&1 &
    
    echo "✅ Follow the configuration steps above"
    read -p "Press Enter when AllDebrid setup is complete..."
    clear
}

# Premiumize setup
setup_premiumize() {
    echo "🥉 PREMIUMIZE SETUP"
    echo "==================="
    echo ""
    echo "Premiumize includes VPN and premium features!"
    echo ""
    echo "💳 ACCOUNT CREATION:"
    echo "1. Go to: https://www.premiumize.me/accounts/register"
    echo "2. Create account"
    echo "3. Purchase premium (~€7.50/month)"
    echo ""
    
    read -p "Have you created your Premiumize account? (y/n): " pm_account
    
    if [[ ! $pm_account =~ ^[Yy]$ ]]; then
        echo "Create your Premiumize account first"
        return
    fi
    
    echo "🔗 Kodi Configuration:"
    echo "1. Open addon settings"
    echo "2. Find Premiumize in resolvers"
    echo "3. Enter API key from Premiumize account"
    echo "4. Test connection"
    echo ""
    
    read -p "Ready to configure? Press Enter..."
    nohup kodi > /dev/null 2>&1 &
    read -p "Press Enter when complete..."
    clear
}

# VPN recommendation
recommend_vpn() {
    echo "🔒 VPN RECOMMENDATION"
    echo "===================="
    echo ""
    echo "⚠️  IMPORTANT: Always use a VPN when streaming!"
    echo ""
    echo "🥇 RECOMMENDED VPNS FOR KODI:"
    echo ""
    echo "1) 🚀 NordVPN"
    echo "   • P2P optimized servers"
    echo "   • Great for streaming"
    echo "   • Easy Kodi integration"
    echo ""
    echo "2) 🛡️  ExpressVPN"
    echo "   • Fast speeds"
    echo "   • Reliable connections"
    echo "   • Works everywhere"
    echo ""
    echo "3) 💎 Surfshark"  
    echo "   • Unlimited devices"
    echo "   • Good value"
    echo "   • Streaming optimized"
    echo ""
    echo "💡 SETUP TIPS:"
    echo "• Connect to VPN BEFORE opening Kodi"
    echo "• Choose P2P/streaming optimized servers"
    echo "• Test different server locations for best speeds"
    echo ""
    
    read -p "Do you have a VPN already? (y/n): " has_vpn
    
    if [[ ! $has_vpn =~ ^[Yy]$ ]]; then
        echo ""
        echo "🚨 HIGHLY RECOMMENDED: Get a VPN before streaming"
        echo "Your ISP can see all your streaming activity without one!"
        echo ""
        echo "Consider getting NordVPN or ExpressVPN for best results."
    fi
    
    echo ""
    read -p "Press Enter to continue..."
    clear
}

# Final setup verification
verify_setup() {
    echo "🎯 SETUP VERIFICATION"
    echo "====================="
    echo ""
    echo "Let's verify everything is working correctly!"
    echo ""
    
    echo "✅ CHECKLIST:"
    echo ""
    echo "[ ] Kodi installed and running"
    echo "[ ] Build installed (Xenon, Atomic, etc.)"
    echo "[ ] Debrid service account created"
    echo "[ ] Debrid service configured in Kodi"
    echo "[ ] VPN installed and connected"
    echo "[ ] Streaming addons working"
    echo ""
    
    echo "🧪 TESTING YOUR SETUP:"
    echo "======================"
    echo ""
    echo "1. Connect your VPN first"
    echo "2. Open Kodi"
    echo "3. Go to Movies or TV Shows in your addon"
    echo "4. Pick a popular title"
    echo "5. Look for HIGH QUALITY links (1080p, 4K)"
    echo "6. Links should load quickly and play smoothly"
    echo ""
    echo "🎉 If you see quality links, your setup is complete!"
    echo ""
    echo "🚨 TROUBLESHOOTING:"
    echo "• No quality links = Check debrid authorization"
    echo "• Slow loading = Try different VPN server"
    echo "• Buffering issues = Check internet speed"
    echo "• Addon errors = Update or reinstall addon"
    echo ""
    
    read -p "Press Enter to finish..."
    clear
}

# Final tips and resources
final_tips() {
    echo "🎓 FINAL TIPS & RESOURCES"
    echo "========================="
    echo ""
    echo "🎯 BEST PRACTICES:"
    echo "• Always connect VPN before streaming"
    echo "• Keep your build/addons updated"
    echo "• Clear cache regularly (Tools > Clear Cache)"
    echo "• Restart Kodi if you experience issues"
    echo "• Only stream content you have legal access to"
    echo ""
    echo "📚 HELPFUL RESOURCES:"
    echo "• r/Addons4Kodi - Reddit community"  
    echo "• Kodi forums - Official support"
    echo "• Build-specific guides online"
    echo "• Debrid service support pages"
    echo ""
    echo "🔧 MAINTENANCE:"
    echo "• Update builds monthly"
    echo "• Clear cache weekly"  
    echo "• Check debrid account status"
    echo "• Backup your settings"
    echo ""
    echo "⚠️  REMEMBER:"
    echo "• Use responsibly and legally"
    echo "• Keep VPN active when streaming"
    echo "• Support content creators when possible"
    echo ""
    echo "🎉 CONGRATULATIONS!"
    echo "Your Kodi debrid setup is complete!"
    echo "Enjoy your high-quality streaming experience!"
    echo ""
    
    # Log this installation
    echo "$(date): Kodi debrid setup completed" >> ~/.bill-sloth/history.log
    
    echo "🦥 Bill Sloth helper complete - now go stream like a champion! 🏆"
}

# Main menu
main_menu() {
    while true; do
        show_banner "KODI DEBRID SETUP" "Stream like a champion" "GAMING"
        
        echo "🎬 KODI DEBRID SETUP MENU"
        echo "========================="
        echo ""
        echo "1) 💡 What is Debrid? (Start here!)"
        echo "2) 📦 Install Kodi"
        echo "3) 🏗️  Choose & Install Build"
        echo "4) 💳 Setup Debrid Service" 
        echo "5) 🔒 VPN Recommendations"
        echo "6) 🎯 Verify Setup"
        echo "7) 🎓 Final Tips & Resources"
        echo "8) 🚀 Quick Setup (All steps)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-8): " choice
        
        case $choice in
            1) explain_debrid ;;
            2) install_kodi ;;
            3) choose_build ;;
            4) setup_debrid ;;
            5) recommend_vpn ;;
            6) verify_setup ;;
            7) final_tips ;;
            8) quick_setup ;;
            0) echo "👋 Goodbye! Enjoy your streaming setup!"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Quick setup - all steps in sequence
quick_setup() {
    echo "🚀 QUICK SETUP MODE"
    echo "==================="
    echo ""
    echo "This will guide you through the complete setup process:"
    echo "1. Install Kodi → 2. Choose build → 3. Setup debrid → 4. VPN info → 5. Verify"
    echo ""
    read -p "Continue with quick setup? (y/n): " quick_confirm
    
    if [[ $quick_confirm =~ ^[Yy]$ ]]; then
        explain_debrid
        install_kodi
        choose_build  
        setup_debrid
        recommend_vpn
        verify_setup
        final_tips
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth

# Start the main menu
main_menu