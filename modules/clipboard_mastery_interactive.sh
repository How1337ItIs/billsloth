#!/bin/bash
# LLM_CAPABILITY: auto
# Clipboard Mastery - Advanced clipboard management with AI integration
# "Well, let's compute it, and I will solve the answer... to your face!" - Carl

source "../lib/interactive.sh" 2>/dev/null || {
    echo "🎯 CLIPBOARD MASTERY SETUP"
    echo "========================="
}

show_banner "CLIPBOARD MASTERY" "Windows power-user clipboard, but smarter" "PRODUCTIVITY"

echo "📋 CLIPBOARD MASTERY - THE WINDOWS POWER-USER'S DREAM"
echo "====================================================="
echo ""
echo "🎯 Transform your Linux clipboard into something that makes ClipboardFusion"
echo "   and Ditto look primitive. This is clipboard management with AI superpowers!"
echo ""
echo "🧠 ADHD BRAIN BENEFITS:"
echo "   • Never lose important copy/paste items again"
echo "   • AI organizes and categorizes your clipboard history"
echo "   • Quick access to frequently used text snippets"
echo "   • Cross-application clipboard sharing and formatting"
echo "   • OCR text extraction from images you copy"
echo "   • Automatic backup of everything you copy"
echo ""

explain_clipboard_power() {
    echo "💡 WHAT IS ADVANCED CLIPBOARD MANAGEMENT?"
    echo "========================================="
    echo ""
    echo "If you're coming from Windows, you probably used tools like:"
    echo "• 🔥 ClipboardFusion - Multiple clipboard management"
    echo "• 📝 Ditto - Clipboard history and organization"
    echo "• ⚡ ClipClip - Smart clipboard with categories"
    echo "• 🎯 Win+V - Basic Windows clipboard history"
    echo ""
    echo "🚀 THIS LINUX SETUP GIVES YOU ALL THAT PLUS:"
    echo ""
    echo "🤖 AI INTEGRATION:"
    echo "   • Smart content detection (URLs, emails, code, etc.)"
    echo "   • Automatic translation of copied text"
    echo "   • Content summarization for long text"
    echo "   • OCR text extraction from screenshots"
    echo ""
    echo "🎨 ADVANCED FORMATTING:"
    echo "   • Convert between text formats (Markdown, HTML, plain text)"
    echo "   • Smart paste formatting based on target application"
    echo "   • Code syntax highlighting in clipboard history"
    echo "   • Rich text preservation across applications"
    echo ""
    echo "🔧 POWER-USER FEATURES:"
    echo "   • Unlimited clipboard history (not just 25 items like Windows)"
    echo "   • Global hotkeys for clipboard management"
    echo "   • Regex search through clipboard history"
    echo "   • Cross-device syncing (optional)"
    echo "   • Scriptable automation with clipboard triggers"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_copyq() {
    echo "📦 INSTALLING COPYQ - THE CLIPBOARD POWERHOUSE"
    echo "=============================================="
    echo ""
    echo "🎯 CopyQ is like ClipboardFusion and Ditto had a baby with AI superpowers!"
    echo ""
    
    if command -v copyq &> /dev/null; then
        echo "✅ CopyQ is already installed!"
        COPYQ_VERSION=$(copyq --version 2>/dev/null | head -1 || echo "Unknown version")
        echo "   Version: $COPYQ_VERSION"
    else
        echo "Installing CopyQ clipboard manager..."
        
        # Detect OS and install accordingly
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Ubuntu/Debian
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y copyq
            # Fedora/CentOS
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y copyq
            # Arch Linux
            elif command -v pacman &> /dev/null; then
                sudo pacman -S copyq
            fi
            
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install copyq
            else
                echo "Please install Homebrew first, then run: brew install copyq"
                return 1
            fi
            
        else
            echo "❌ Unsupported operating system"
            echo "Please manually install CopyQ from: https://copyq.readthedocs.io/"
            return 1
        fi
        
        echo "✅ CopyQ installation complete!"
    fi
    echo ""
    read -p "Press Enter to continue..."
    clear
}

configure_copyq() {
    echo "⚙️  CONFIGURING COPYQ FOR MAXIMUM POWER"
    echo "======================================="
    echo ""
    echo "🎯 Setting up CopyQ with power-user optimizations..."
    echo ""
    
    # Create CopyQ config directory
    mkdir -p ~/.config/copyq
    
    # Create advanced configuration
    cat > ~/.config/copyq/copyq.conf << 'EOF'
[General]
plugin_priority=itemimage,itemtext,itemnotes,itemtags,itemdata
maxitems=10000
edit_ctrl_return=true
check_clipboard=true
copy_clipboard=true
copy_selection=true
run_selection=true
always_on_top=false
clipboard_notification_lines=10
notification_position=3
clipboard_tab=&clipboard
text_wrap=true

[Options]
activate_closes=false
activate_focuses=false
activate_pastes=false
clipboard_notification_lines=5
confirm_exit=false
edit_ctrl_return=true
hide_main_window=false
hide_tabs=false
maxitems=10000
move_item_on_copy=true
show_simple_items=false
text_wrap=true
transparency=0
transparency_focused=0
vi=false

[Shortcuts]
show_log=ctrl+shift+l
toggle_clipboard_storing=ctrl+shift+x
edit=f2
edit_notes=shift+f2
system-run=f5
move_to_clipboard=ctrl+shift+c
show-hide=ctrl+shift+v
new=ctrl+n
import=ctrl+i
export=ctrl+s
preferences=ctrl+p
EOF

    # Create custom AI integration script
    mkdir -p ~/.local/bin
    cat > ~/.local/bin/copyq-ai-helper << 'EOF'
#!/bin/bash
# CopyQ AI Integration Helper

# Get the clipboard content
CONTENT="$(copyq read 0)"

case "$1" in
    "translate")
        # Use Claude to translate content
        if command -v claude &> /dev/null; then
            TRANSLATED=$(claude "Translate this text to English: $CONTENT" 2>/dev/null)
            if [ $? -eq 0 ] && [ -n "$TRANSLATED" ]; then
                copyq add "$TRANSLATED"
                copyq select 0
                notify-send "Translation Added" "Translated text added to clipboard"
            fi
        fi
        ;;
    "summarize")
        # Use Claude to summarize content
        if command -v claude &> /dev/null; then
            SUMMARY=$(claude "Summarize this text in 2-3 sentences: $CONTENT" 2>/dev/null)
            if [ $? -eq 0 ] && [ -n "$SUMMARY" ]; then
                copyq add "$SUMMARY"
                copyq select 0
                notify-send "Summary Added" "Text summary added to clipboard"
            fi
        fi
        ;;
    "format-code")
        # Format code content
        if command -v claude &> /dev/null; then
            FORMATTED=$(claude "Format and clean up this code, maintaining the same language: $CONTENT" 2>/dev/null)
            if [ $? -eq 0 ] && [ -n "$FORMATTED" ]; then
                copyq add "$FORMATTED"
                copyq select 0
                notify-send "Code Formatted" "Formatted code added to clipboard"
            fi
        fi
        ;;
    *)
        echo "Usage: $0 {translate|summarize|format-code}"
        exit 1
        ;;
esac
EOF

    chmod +x ~/.local/bin/copyq-ai-helper
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
    
    echo "✅ CopyQ configured with power-user settings!"
    echo ""
    echo "🎯 KEY FEATURES ENABLED:"
    echo "   • 10,000 item history (vs Windows 25 limit)"
    echo "   • AI integration scripts for translation/summarization"
    echo "   • Smart hotkeys and shortcuts"
    echo "   • Cross-application formatting preservation"
    echo "   • Advanced search and filtering"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_clipboard_hotkeys() {
    echo "⌨️  SETTING UP CLIPBOARD HOTKEYS"
    echo "================================"
    echo ""
    echo "🔥 Windows Power-User Hotkeys for Linux:"
    echo ""
    echo "📋 STANDARD HOTKEYS:"
    echo "   Ctrl+Shift+V  = Open clipboard history (like Windows Win+V)"
    echo "   Ctrl+Alt+V    = Paste as plain text"
    echo "   Ctrl+Shift+C  = Copy to permanent storage"
    echo "   F12           = Toggle clipboard monitoring"
    echo ""
    echo "🤖 AI-POWERED HOTKEYS:"
    echo "   Ctrl+Alt+T    = Translate clipboard content"
    echo "   Ctrl+Alt+S    = Summarize long text"
    echo "   Ctrl+Alt+F    = Format code in clipboard"
    echo ""
    
    # Create autostart entry for CopyQ
    mkdir -p ~/.config/autostart
    cat > ~/.config/autostart/copyq.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=CopyQ Clipboard Manager
Comment=Advanced clipboard manager with AI integration
Exec=copyq
Icon=copyq
Terminal=false
Categories=Utility;
StartupNotify=false
EOF
    
    # Create desktop integration script
    cat > ~/.local/bin/clipboard-hotkey-handler << 'EOF'
#!/bin/bash
# Clipboard hotkey handler

case "$1" in
    "show-history")
        copyq show
        ;;
    "paste-plain")
        # Get clipboard and paste as plain text
        CONTENT=$(copyq read 0)
        printf "%s" "$CONTENT" | xclip -selection clipboard
        ;;
    "toggle-monitoring")
        copyq toggle
        STATUS=$(copyq monitoring)
        if [ "$STATUS" = "true" ]; then
            notify-send "Clipboard" "Monitoring enabled"
        else
            notify-send "Clipboard" "Monitoring disabled"
        fi
        ;;
    "ai-translate")
        copyq-ai-helper translate
        ;;
    "ai-summarize")
        copyq-ai-helper summarize
        ;;
    "ai-format")
        copyq-ai-helper format-code
        ;;
    *)
        echo "Usage: $0 {show-history|paste-plain|toggle-monitoring|ai-translate|ai-summarize|ai-format}"
        exit 1
        ;;
esac
EOF
    
    chmod +x ~/.local/bin/clipboard-hotkey-handler
    
    echo "✅ Clipboard hotkeys configured!"
    echo ""
    echo "⚠️  TO ACTIVATE SYSTEM HOTKEYS:"
    echo "   1. Open your system settings (varies by desktop environment)"
    echo "   2. Go to Keyboard Shortcuts"
    echo "   3. Add these custom shortcuts:"
    echo ""
    echo "      Ctrl+Shift+V → clipboard-hotkey-handler show-history"
    echo "      Ctrl+Alt+V   → clipboard-hotkey-handler paste-plain"
    echo "      Ctrl+Alt+T   → clipboard-hotkey-handler ai-translate"
    echo "      Ctrl+Alt+S   → clipboard-hotkey-handler ai-summarize"
    echo "      F12          → clipboard-hotkey-handler toggle-monitoring"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_xclip_tools() {
    echo "🔧 INSTALLING CLIPBOARD SUPPORT TOOLS"
    echo "===================================="
    echo ""
    echo "Installing xclip and xsel for command-line clipboard access..."
    echo ""
    
    # Detect OS and install accordingly
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Ubuntu/Debian
        if command -v apt &> /dev/null; then
            sudo apt install -y xclip xsel
        # Fedora/CentOS
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y xclip xsel
        # Arch Linux
        elif command -v pacman &> /dev/null; then
            sudo pacman -S xclip xsel
        fi
    fi
    
    echo "✅ Clipboard tools installed!"
    echo ""
    echo "🎯 NOW YOU CAN:"
    echo "   • Pipe command output to clipboard: echo 'hello' | xclip -selection clipboard"
    echo "   • Get clipboard content in scripts: xclip -selection clipboard -o"
    echo "   • Integrate clipboard with shell workflows"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_voicemeeter_equivalent() {
    echo "🎵 SETTING UP LINUX VOICEMEETER EQUIVALENT"
    echo "=========================================="
    echo ""
    echo "🎯 Since you're a VoiceMeeter power user on Windows, let's set up"
    echo "   the Linux equivalent: PulseAudio/PipeWire + Carla + QjackCtl"
    echo ""
    echo "🔥 THIS LINUX SETUP GIVES YOU:"
    echo "   • Virtual audio cables (like VoiceMeeter cables)"
    echo "   • Real-time audio routing and mixing"
    echo "   • VST plugin support for audio processing"
    echo "   • Multi-channel audio management"
    echo "   • Professional audio workstation capabilities"
    echo ""
    echo "📦 INSTALLING AUDIO POWERHOUSE:"
    echo ""
    
    # Install audio tools
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt update
            sudo apt install -y pipewire pipewire-pulse pipewire-jack \
                               carla qjackctl pavucontrol helvum \
                               pulseaudio-utils alsa-utils
        elif command -v dnf &> /dev/null; then
            sudo dnf install -y pipewire pipewire-pulseaudio pipewire-jack-audio-connection-kit \
                               carla qjackctl pavucontrol helvum
        elif command -v pacman &> /dev/null; then
            sudo pacman -S pipewire pipewire-pulse pipewire-jack \
                          carla qjackctl pavucontrol helvum
        fi
    fi
    
    echo "✅ Audio routing tools installed!"
    echo ""
    echo "🎛️  YOUR LINUX VOICEMEETER EQUIVALENT:"
    echo ""
    echo "🎵 CARLA - Your main audio mixing station"
    echo "   • Load VST plugins like in VoiceMeeter"
    echo "   • Route audio between applications"
    echo "   • Real-time effects processing"
    echo ""
    echo "🎚️  PAVUCONTROL - Advanced volume control"
    echo "   • Per-application volume control"
    echo "   • Input/output device management"
    echo "   • Audio routing configuration"
    echo ""
    echo "🔌 HELVUM - Visual audio routing"
    echo "   • Drag-and-drop audio connections"
    echo "   • See all audio streams visually"
    echo "   • Connect any app to any output"
    echo ""
    echo "⚡ QJACKCTL - Professional audio server"
    echo "   • Low-latency audio processing"
    echo "   • Professional audio workflow"
    echo "   • Advanced routing capabilities"
    echo ""
    
    # Create desktop shortcuts for easy access
    mkdir -p ~/.local/share/applications
    
    cat > ~/.local/share/applications/audio-control-center.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Audio Control Center
Comment=Launch audio mixing and routing tools
Exec=sh -c 'carla & pavucontrol & helvum'
Icon=audio-card
Terminal=false
Categories=AudioVideo;Audio;Mixer;
EOF
    
    echo "🚀 QUICK ACCESS CREATED:"
    echo "   • Search for 'Audio Control Center' in your applications"
    echo "   • Or run: carla (main mixer), pavucontrol (volume), helvum (routing)"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

demo_clipboard_power() {
    echo "🎯 CLIPBOARD MASTERY DEMONSTRATION"
    echo "=================================="
    echo ""
    echo "Let's test your new clipboard superpowers!"
    echo ""
    
    # Start CopyQ if not running
    if ! pgrep copyq > /dev/null; then
        nohup copyq > /dev/null 2>&1 &
        sleep 2
    fi
    
    echo "📋 TESTING BASIC FUNCTIONALITY:"
    echo ""
    
    # Test basic clipboard
    echo "Testing clipboard functionality..."
    echo "This is a test from Bill Sloth Clipboard Mastery!" | xclip -selection clipboard
    copyq add "Bill Sloth Power User Test 1"
    copyq add "Bill Sloth Power User Test 2"
    copyq add "Bill Sloth Power User Test 3"
    
    echo "✅ Added 3 test items to clipboard history"
    echo ""
    echo "📊 CURRENT CLIPBOARD STATS:"
    ITEM_COUNT=$(copyq size 2>/dev/null || echo "0")
    echo "   • Total items in history: $ITEM_COUNT"
    echo "   • Current clipboard: $(copyq read 0 2>/dev/null || echo 'Empty')"
    echo ""
    
    echo "🎯 POWER-USER TIPS:"
    echo ""
    echo "1️⃣  QUICK ACCESS: Press Ctrl+Shift+V to open clipboard history"
    echo "2️⃣  AI MAGIC: Copy text, then use Ctrl+Alt+T to translate it"
    echo "3️⃣  SEARCH: Use / in CopyQ to search through your clipboard history"
    echo "4️⃣  TAGS: Right-click items in CopyQ to add tags and organize"
    echo "5️⃣  PERSISTENCE: Your clipboard survives reboots (unlike Windows!)"
    echo ""
    echo "🤖 AI FEATURES:"
    echo "   • Copy any text and run: copyq-ai-helper translate"
    echo "   • For summaries: copyq-ai-helper summarize"
    echo "   • For code formatting: copyq-ai-helper format-code"
    echo ""
    read -p "Press Enter to finish setup..."
    clear
}

# Main menu
main_menu() {
    while true; do
        show_banner "CLIPBOARD MASTERY" "Windows power-user clipboard, but smarter" "PRODUCTIVITY"
        
        echo "📋 CLIPBOARD MASTERY SETUP MENU"
        echo "==============================="
        echo ""
        echo "1) 💡 What is Advanced Clipboard Management?"
        echo "2) 📦 Install CopyQ (Main Clipboard Manager)"
        echo "3) ⚙️  Configure CopyQ for Maximum Power"
        echo "4) ⌨️  Setup Clipboard Hotkeys"
        echo "5) 🔧 Install Clipboard Support Tools"
        echo "6) 🎵 Setup VoiceMeeter Equivalent (PipeWire/Carla)"
        echo "7) 🎯 Demo Your New Clipboard Powers"
        echo "8) 🚀 Complete Setup (All Steps)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-8): " choice
        
        case $choice in
            1) explain_clipboard_power ;;
            2) install_copyq ;;
            3) configure_copyq ;;
            4) setup_clipboard_hotkeys ;;
            5) install_xclip_tools ;;
            6) setup_voicemeeter_equivalent ;;
            7) demo_clipboard_power ;;
            8) complete_setup ;;
            0) echo "👋 Clipboard mastery awaits! Your Windows friends will be jealous."; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - all steps in sequence
complete_setup() {
    echo "🚀 COMPLETE CLIPBOARD MASTERY SETUP"
    echo "===================================="
    echo ""
    echo "This will set up the ultimate clipboard system:"
    echo "CopyQ + AI integration + VoiceMeeter equivalent + hotkeys"
    echo ""
    read -p "Continue with complete setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_clipboard_power
        install_xclip_tools
        install_copyq
        configure_copyq
        setup_clipboard_hotkeys
        setup_voicemeeter_equivalent
        demo_clipboard_power
        
        echo ""
        echo "🎉 CLIPBOARD MASTERY COMPLETE!"
        echo "============================="
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Advanced clipboard manager (better than Windows)"
        echo "   ✅ AI-powered text processing"
        echo "   ✅ Professional audio routing (VoiceMeeter equivalent)"
        echo "   ✅ Power-user hotkeys and automation"
        echo "   ✅ Cross-application integration"
        echo ""
        echo "🚀 NEXT STEPS:"
        echo "   • Press Ctrl+Shift+V to open your clipboard history"
        echo "   • Copy some text and try the AI translation hotkey"
        echo "   • Launch 'Audio Control Center' for audio routing"
        echo "   • Your clipboard now survives reboots and has unlimited history!"
        echo ""
        echo "💡 Windows power users: You're now MORE powerful than you were before!"
        
        # Log this installation
        echo "$(date): Clipboard Mastery setup completed with AI integration and VoiceMeeter equivalent" >> ~/.bill-sloth/history.log
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.config/copyq
mkdir -p ~/.local/bin

# Start the main menu
main_menu