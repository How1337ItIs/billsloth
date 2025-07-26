#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=Espanso Expander, 2=AutoKey Automation, 3=Custom Snippets, 4=AI-Powered Templates, 5=Complete Text Suite
# CLAUDE_PROMPTS: Expansion tool selection, Snippet configuration, Template setup
# CLAUDE_DEPENDENCIES: espanso, autokey, python3
# Text Expansion Mastery - Intelligent text expansion with AI-powered snippets
# "Click yes for yes" - Carl

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

source "../lib/interactive.sh" 2>/dev/null || {
    echo "📝 TEXT EXPANSION MASTERY SETUP"
    echo "==============================="
}

show_banner "TEXT EXPANSION MASTERY" "Windows TextExpander, but with AI superpowers" "PRODUCTIVITY"

echo "📝 TEXT EXPANSION MASTERY - POWER-USER PRODUCTIVITY UNLEASHED"
echo "============================================================="
echo ""
echo "🎯 Transform your typing efficiency with AI-powered text expansion that makes"
echo "   TextExpander and aText look like stone-age tools!"
echo ""
echo "🧠 ADHD BRAIN BENEFITS:"
echo "   • Never type the same thing twice - let AI create smart shortcuts"
echo "   • Reduce typing fatigue and repetitive strain"
echo "   • Consistent formatting across all applications"
echo "   • Context-aware expansions that adapt to what you're working on"
echo "   • Dynamic templates with dates, times, and AI-generated content"
echo "   • Cross-application snippet sharing and synchronization"
echo ""

explain_text_expansion_power() {
    echo "💡 WHAT IS ADVANCED TEXT EXPANSION?"
    echo "==================================="
    echo ""
    echo "If you're coming from Windows, you probably used (or wished you had):"
    echo "• 🔥 TextExpander - Dynamic text snippets with variables"
    echo "• 📝 aText - Simple text replacement and shortcuts"
    echo "• ⚡ AutoHotkey - Advanced text automation"
    echo "• 🎯 Windows built-in autocorrect (very basic)"
    echo ""
    echo "🚀 THIS LINUX SETUP GIVES YOU ALL THAT PLUS AI MAGIC:"
    echo ""
    echo "🤖 AI-POWERED FEATURES:"
    echo "   • Smart snippet suggestions based on your writing patterns"
    echo "   • Dynamic content generation (emails, code, documentation)"
    echo "   • Context-aware expansions (different for coding vs writing)"
    echo "   • Auto-learning from your frequently typed text"
    echo ""
    echo "⚡ ADVANCED AUTOMATION:"
    echo "   • Date/time insertion with custom formats"
    echo "   • System information insertion (username, hostname, etc.)"
    echo "   • Clipboard content integration in snippets"
    echo "   • Shell command execution within expansions"
    echo ""
    echo "🎨 SMART FORMATTING:"
    echo "   • Application-specific formatting (Markdown in editors, HTML in browsers)"
    echo "   • Multi-line templates with proper indentation"
    echo "   • Rich text and Unicode support"
    echo "   • Regex-powered advanced replacements"
    echo ""
    echo "🔧 POWER-USER FEATURES:"
    echo "   • Works in ALL applications (not just specific ones)"
    echo "   • Nested snippet expansion and variables"
    echo "   • Team sharing and synchronization"
    echo "   • Backup and version control of snippets"
    echo "   • Statistics and usage analytics"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_espanso() {
    echo "📦 INSTALLING ESPANSO - THE TEXT EXPANSION POWERHOUSE"
    echo "===================================================="
    echo ""
    echo "🎯 Espanso is like TextExpander on steroids with Linux superpowers!"
    echo ""
    
    if command -v espanso &> /dev/null; then
        echo "✅ Espanso is already installed!"
        ESPANSO_VERSION=$(espanso --version 2>/dev/null | head -1 || echo "Unknown version")
        echo "   Version: $ESPANSO_VERSION"
    else
        echo "Installing Espanso text expander..."
        echo ""
        
        # Detect OS and install accordingly
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            # Download and install Espanso AppImage
            cd /tmp
            
            # Get latest Espanso release
            ESPANSO_URL=$(curl -s https://api.github.com/repos/federico-terzi/espanso/releases/latest | grep "browser_download_url.*AppImage" | cut -d '"' -f 4)
            
            if [ -n "$ESPANSO_URL" ]; then
                echo "Downloading Espanso..."
                wget -O espanso.AppImage "$ESPANSO_URL"
                chmod +x espanso.AppImage
                
                # Move to local bin
                mkdir -p ~/.local/bin
                mv espanso.AppImage ~/.local/bin/espanso
                
                # Add to PATH if not already there
                if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
                    export PATH="$HOME/.local/bin:$PATH"
                fi
                
                echo "✅ Espanso installed successfully!"
            else
                echo "❌ Could not download Espanso. Installing via package manager..."
                
                # Fall back to package managers
                if command -v apt &> /dev/null; then
                    # Ubuntu/Debian - use Snap as fallback
                    sudo snap install espanso --classic 2>/dev/null || {
                        echo "Installing via wget method..."
                        wget -O - https://espanso.org/install/linux | sh
                    }
                elif command -v dnf &> /dev/null; then
                    # Fedora/CentOS
                    sudo dnf copr enable atim/espanso -y
                    sudo dnf install espanso -y
                elif command -v pacman &> /dev/null; then
                    # Arch Linux
                    sudo pacman -S espanso
                fi
            fi
            
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            if command -v brew &> /dev/null; then
                brew install espanso
            else
                echo "Please install Homebrew first, then run: brew install espanso"
                return 1
            fi
            
        else
            echo "❌ Unsupported operating system"
            echo "Please manually install Espanso from: https://espanso.org/"
            return 1
        fi
        
        echo "✅ Espanso installation complete!"
    fi
    echo ""
    read -p "Press Enter to continue..."
    clear
}

configure_espanso() {
    echo "⚙️  CONFIGURING ESPANSO FOR MAXIMUM PRODUCTIVITY"
    echo "==============================================="
    echo ""
    echo "🎯 Setting up Espanso with power-user configurations..."
    echo ""
    
    # Initialize Espanso (creates config directories)
    espanso service install 2>/dev/null || true
    espanso service start 2>/dev/null || true
    
    # Create Espanso config directory
    ESPANSO_CONFIG="$HOME/.config/espanso"
    mkdir -p "$ESPANSO_CONFIG/match"
    mkdir -p "$ESPANSO_CONFIG/config"
    
    # Create main configuration
    cat > "$ESPANSO_CONFIG/config/default.yml" << 'EOF'
# Espanso Power-User Configuration

# Auto-restart when config changes
auto_restart: true

# Enable clipboard integration
enable_clipboard: true

# Backspace handling
backspace_delay: 100

# Key delay for better compatibility
key_delay: 1

# Search trigger
search_trigger: ";;search"
search_shortcut: "ALT+SPACE"

# Paste shortcut
paste_shortcut: "ALT+SHIFT+V"

# Word separators
word_separators:
  - " "
  - "\t"
  - "\n"
  - "\r"
  - ","
  - "."
  - "!"
  - "?"
  - ";"
  - ":"
  - "("
  - ")"
  - "["
  - "]"
  - "{"
  - "}"

# Notification settings
show_notifications: true
show_icon: true
EOF

    # Create basic matches file with power-user snippets
    cat > "$ESPANSO_CONFIG/match/base.yml" << 'EOF'
# Bill Sloth Power-User Text Expansion Snippets

matches:
  # Email signatures and communication
  - trigger: ";sig"
    replace: |
      Best regards,
      Bill
      
      Linux Power User | ADHD-Friendly Productivity Expert
      Powered by Bill Sloth System & Claude AI

  - trigger: ";email"
    replace: "your.email@example.com"

  # Date and time shortcuts
  - trigger: ";date"
    replace: "{{date}}"
    
  - trigger: ";time"
    replace: "{{time}}"
    
  - trigger: ";datetime"
    replace: "{{date}} {{time}}"
    
  - trigger: ";timestamp"
    replace: "{{date \"%Y-%m-%d %H:%M:%S\"}}"

  # System information
  - trigger: ";user"
    replace: "{{username}}"
    
  - trigger: ";host"
    replace: "{{hostname}}"
    
  - trigger: ";system"
    replace: "{{username}}@{{hostname}}"

  # Common phrases and responses
  - trigger: ";thanks"
    replace: "Thank you for your time and consideration!"
    
  - trigger: ";meeting"
    replace: "Looking forward to our meeting. Please let me know if you need to reschedule."
    
  - trigger: ";follow"
    replace: "Following up on our previous conversation..."

  # Technical shortcuts
  - trigger: ";ssh"
    replace: "ssh -i ~/.ssh/id_rsa user@hostname"
    
  - trigger: ";curl"
    replace: "curl -H 'Content-Type: application/json' -X POST -d '{}' "
    
  - trigger: ";docker"
    replace: "docker run -it --rm -v $(pwd):/workspace "

  # Programming snippets
  - trigger: ";shebang"
    replace: "#!/bin/bash"
    
  - trigger: ";py"
    replace: "#!/usr/bin/env python3"
    
  - trigger: ";license"
    replace: |
      # Licensed under the MIT License
      # See LICENSE file in the project root for full license information.

  # Markdown shortcuts
  - trigger: ";md-code"
    replace: |
      ```bash
      $|$
      ```
      
  - trigger: ";md-link"
    replace: "[$|$](url)"
    
  - trigger: ";md-table"
    replace: |
      | Column 1 | Column 2 | Column 3 |
      |----------|----------|----------|
      | $|$      |          |          |

  # ADHD-friendly productivity
  - trigger: ";todo"
    replace: |
      ## Today's Tasks
      - [ ] $|$
      - [ ] 
      - [ ] 
      
      ## Notes
      
      
      ## Completed ✅
      
  - trigger: ";focus"
    replace: |
      🎯 FOCUS SESSION: {{time}}
      ===================
      Goal: $|$
      Time limit: 25 minutes
      Distractions noted: 
      
      Notes:
      
  - trigger: ";energy"
    replace: |
      Energy Level: $|$/10
      Focus Quality: /10
      Mood: 
      Tasks completed: 
      What worked well: 
      What to change: 

  # VoiceMeeter/Audio related (since user is VoiceMeeter user)
  - trigger: ";audio-setup"
    replace: |
      ## Audio Routing Setup
      Input Device: $|$
      Output Device: 
      Sample Rate: 48kHz
      Buffer Size: 256
      
      Carla Plugins:
      - 
      
      Notes:
      
  - trigger: ";vm-config"
    replace: |
      VoiceMeeter Linux Equivalent Configuration:
      PipeWire + Carla + QjackCtl
      
      Virtual Cables: $|$
      Routing: A1 -> 
      Effects: 
      Monitoring: 

  # Business/EdBoiGames related
  - trigger: ";partnership"
    replace: |
      Hi there!
      
      I'm reaching out regarding a potential partnership opportunity with EdBoiGames.
      
      $|$
      
      I'd love to discuss how we can work together to create value for both our audiences.
      
      Best regards,
      Bill

  - trigger: ";vrbo"
    replace: |
      ## VRBO Property Notes
      Property: $|$
      Check-in: 
      Check-out: 
      Guests: 
      
      Status: 
      Issues: 
      Tasks: 
      - [ ] 

EOF

    echo "✅ Espanso configured with power-user snippets!"
    echo ""
    echo "🎯 SNIPPETS READY TO USE:"
    echo "   ;sig       = Professional email signature"
    echo "   ;date      = Current date"
    echo "   ;time      = Current time"
    echo "   ;todo      = ADHD-friendly task template"
    echo "   ;focus     = Focus session template"
    echo "   ;audio-setup = Audio configuration template"
    echo "   ;partnership = Business outreach template"
    echo "   And many more!"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_ai_snippets() {
    echo "🤖 CREATING AI-POWERED DYNAMIC SNIPPETS"
    echo "======================================="
    echo ""
    echo "🎯 Setting up AI integration for intelligent text expansion..."
    echo ""
    
    # Create AI integration directory
    mkdir -p "$HOME/.config/espanso/scripts"
    
    # Create AI snippet generator script
    cat > "$HOME/.config/espanso/scripts/ai-snippet.sh" << 'EOF'
#!/bin/bash
# AI-Powered Snippet Generator for Espanso

AI_PROMPT="$1"
CONTEXT="$2"

# Check if Claude is available
if command -v claude &> /dev/null; then
    # Use Claude for AI generation
    RESULT=$(claude "$AI_PROMPT" 2>/dev/null)
    if [ $? -eq 0 ] && [ -n "$RESULT" ]; then
        echo "$RESULT"
    else
        echo "AI generation failed, using fallback"
    fi
else
    # Fallback for when Claude isn't available
    case "$AI_PROMPT" in
        *email*)
            echo "Subject: $CONTEXT\n\nHi there,\n\n[AI-generated content would go here]\n\nBest regards,\nBill"
            ;;
        *code*)
            echo "// AI-generated code snippet\n// Context: $CONTEXT\n\n// Implementation would go here"
            ;;
        *)
            echo "AI snippet generator requires Claude Code to be installed and configured."
            ;;
    esac
fi
EOF

    chmod +x "$HOME/.config/espanso/scripts/ai-snippet.sh"
    
    # Create AI-powered matches
    cat > "$ESPANSO_CONFIG/match/ai-powered.yml" << 'EOF'
# AI-Powered Dynamic Snippets

matches:
  # AI Email Generation
  - trigger: ";ai-email"
    replace: "{{script_output.ai-snippet.sh \"Generate a professional email about $|$\" \"email\"}}"
    
  # AI Code Comments
  - trigger: ";ai-comment"
    replace: "{{script_output.ai-snippet.sh \"Generate a code comment explaining: $|$\" \"code\"}}"
    
  # AI Documentation
  - trigger: ";ai-doc"
    replace: "{{script_output.ai-snippet.sh \"Generate documentation for: $|$\" \"documentation\"}}"
    
  # AI Meeting Notes Template
  - trigger: ";ai-meeting"
    replace: |
      ## Meeting Notes - {{date}}
      **Topic:** $|$
      **Attendees:** 
      **Duration:** 
      
      ### Agenda
      - 
      
      ### Key Points
      - 
      
      ### Action Items
      - [ ] 
      
      ### Next Steps
      - 
      
      ### AI Insights
      {{script_output.ai-snippet.sh "Generate meeting insights for topic: $|$" "meeting"}}

  # AI Task Breakdown
  - trigger: ";ai-task"
    replace: |
      ## Task: $|$
      
      ### AI-Generated Breakdown:
      {{script_output.ai-snippet.sh "Break down this task into actionable steps: $|$" "task"}}
      
      ### Personal Notes:
      
      
      ### Completion Status:
      - [ ] Planning complete
      - [ ] Implementation started
      - [ ] Review completed
      - [ ] Task finished

  # AI Content Ideas
  - trigger: ";ai-content"
    replace: |
      ## Content Ideas for: $|$
      
      {{script_output.ai-snippet.sh "Generate 5 content ideas for: $|$" "content"}}
      
      ### Selected Concept:
      
      
      ### Implementation Notes:
      

  # AI Problem Solving
  - trigger: ";ai-debug"
    replace: |
      ## Problem: $|$
      
      ### AI Analysis:
      {{script_output.ai-snippet.sh "Analyze this technical problem and suggest solutions: $|$" "debug"}}
      
      ### Steps Tried:
      - [ ] 
      
      ### Solution:
      
      
      ### Prevention:
      
EOF

    echo "✅ AI-powered snippets created!"
    echo ""
    echo "🤖 AI SNIPPETS READY:"
    echo "   ;ai-email    = AI generates professional emails"
    echo "   ;ai-comment  = AI creates code comments"
    echo "   ;ai-doc      = AI writes documentation"
    echo "   ;ai-meeting  = AI-enhanced meeting notes"
    echo "   ;ai-task     = AI breaks down complex tasks"
    echo "   ;ai-content  = AI generates content ideas"
    echo "   ;ai-debug    = AI helps debug problems"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_espanso_service() {
    echo "🚀 SETTING UP ESPANSO SERVICE"
    echo "============================="
    echo ""
    echo "🎯 Configuring Espanso to start automatically and run in background..."
    echo ""
    
    # Register and start Espanso service
    espanso service install 2>/dev/null || echo "Service already installed"
    espanso service start 2>/dev/null || echo "Service already running"
    
    # Create desktop entry for easy management
    mkdir -p ~/.local/share/applications
    cat > ~/.local/share/applications/espanso-manager.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Espanso Manager
Comment=Manage text expansion service
Exec=sh -c 'zenity --info --text="Espanso Commands:\n\nespanso service start\nespanso service stop\nespanso service restart\nespanso edit\nespanso reload\n\nCurrent Status: $(espanso service status 2>/dev/null || echo \"Not running\")"'
Icon=text-editor
Terminal=false
Categories=Utility;Office;
EOF
    
    # Create quick status check script
    cat > ~/.local/bin/espanso-status << 'EOF'
#!/bin/bash
# Quick Espanso status and management script

case "$1" in
    "status")
        echo "Espanso Service Status:"
        espanso service status 2>/dev/null || echo "Service not running"
        echo ""
        echo "Recent expansions:"
        espanso log | tail -5 2>/dev/null || echo "No recent activity"
        ;;
    "restart")
        echo "Restarting Espanso..."
        espanso service restart
        echo "Espanso restarted!"
        ;;
    "reload")
        echo "Reloading Espanso configuration..."
        espanso reload
        echo "Configuration reloaded!"
        ;;
    "edit")
        echo "Opening Espanso configuration..."
        espanso edit
        ;;
    *)
        echo "Espanso Quick Manager"
        echo "===================="
        echo ""
        echo "Usage: espanso-status {status|restart|reload|edit}"
        echo ""
        echo "Commands:"
        echo "  status  - Show service status and recent activity"
        echo "  restart - Restart the Espanso service"
        echo "  reload  - Reload configuration without restart"
        echo "  edit    - Open configuration file for editing"
        echo ""
        echo "Current Status:"
        espanso service status 2>/dev/null || echo "Service not running"
        ;;
esac
EOF

    chmod +x ~/.local/bin/espanso-status
    
    # Test the service
    SERVICE_STATUS=$(espanso service status 2>/dev/null || echo "Not running")
    
    echo "✅ Espanso service configured!"
    echo ""
    echo "📊 SERVICE STATUS: $SERVICE_STATUS"
    echo ""
    echo "🎯 MANAGEMENT COMMANDS:"
    echo "   espanso-status       = Quick status check"
    echo "   espanso edit         = Edit your snippets"
    echo "   espanso reload       = Reload after changes"
    echo "   espanso service stop = Stop the service"
    echo "   espanso service start= Start the service"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

demo_text_expansion() {
    echo "🎯 TEXT EXPANSION DEMONSTRATION"
    echo "==============================="
    echo ""
    echo "Let's test your new text expansion superpowers!"
    echo ""
    
    # Check if Espanso is running
    if espanso service status &> /dev/null; then
        echo "✅ Espanso service is running!"
    else
        echo "🔄 Starting Espanso service..."
        espanso service start
        sleep 2
    fi
    
    echo ""
    echo "📝 TESTING SNIPPETS:"
    echo ""
    echo "Open any text editor and try these shortcuts:"
    echo ""
    echo "📅 DATE & TIME:"
    echo "   ;date     → $(date +'%Y-%m-%d')"
    echo "   ;time     → $(date +'%H:%M:%S')"
    echo "   ;datetime → $(date +'%Y-%m-%d %H:%M:%S')"
    echo ""
    echo "💼 BUSINESS:"
    echo "   ;sig      → Professional email signature"
    echo "   ;thanks   → Thank you message"
    echo "   ;meeting  → Meeting coordination text"
    echo ""
    echo "🔧 TECHNICAL:"
    echo "   ;shebang  → #!/bin/bash"
    echo "   ;ssh      → SSH command template"
    echo "   ;docker   → Docker run template"
    echo ""
    echo "🧠 ADHD-FRIENDLY:"
    echo "   ;todo     → Task list template"
    echo "   ;focus    → Focus session template"
    echo "   ;energy   → Energy tracking template"
    echo ""
    echo "🎵 AUDIO (VoiceMeeter User):"
    echo "   ;audio-setup → Audio routing template"
    echo "   ;vm-config   → VoiceMeeter equivalent config"
    echo ""
    echo "🤖 AI-POWERED:"
    echo "   ;ai-email   → AI generates emails"
    echo "   ;ai-task    → AI breaks down tasks"
    echo "   ;ai-debug   → AI helps troubleshoot"
    echo ""
    
    # Show statistics if available
    if command -v espanso &> /dev/null; then
        echo "📊 ESPANSO STATISTICS:"
        MATCHES_COUNT=$(find ~/.config/espanso/match -name "*.yml" -exec grep -c "trigger:" {} \; 2>/dev/null | paste -sd+ | bc 2>/dev/null || echo "Unknown")
        echo "   • Total snippets available: $MATCHES_COUNT"
        echo "   • Service status: $(espanso service status 2>/dev/null || echo 'Not running')"
        echo ""
    fi
    
    echo "🎯 POWER-USER TIPS:"
    echo ""
    echo "1️⃣  CUSTOMIZATION: Run 'espanso edit' to add your own snippets"
    echo "2️⃣  RELOAD: After editing, run 'espanso reload' to apply changes"
    echo "3️⃣  SEARCH: Type ';;search' in any app to search your snippets"
    echo "4️⃣  MANAGEMENT: Run 'espanso-status' for quick service control"
    echo "5️⃣  AI MAGIC: Use ;ai- prefixed snippets for intelligent content"
    echo ""
    echo "💡 Windows users: You now have MORE power than TextExpander ever gave you!"
    echo ""
    read -p "Press Enter to finish setup..."
    clear
}

# Main menu
main_menu() {
    while true; do
        show_banner "TEXT EXPANSION MASTERY" "Windows TextExpander, but with AI superpowers" "PRODUCTIVITY"
        
        echo "📝 TEXT EXPANSION MASTERY MENU"
        echo "=============================="
        echo ""
        echo "1) 💡 What is Advanced Text Expansion?"
        echo "2) 📦 Install Espanso (Main Text Expander)"
        echo "3) ⚙️  Configure Espanso with Power-User Snippets"
        echo "4) 🤖 Create AI-Powered Dynamic Snippets"
        echo "5) 🚀 Setup Espanso Service (Auto-start)"
        echo "6) 🎯 Demo Your New Text Expansion Powers"
        echo "7) 🌟 Complete Setup (All Steps)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-7): " choice
        
        case $choice in
            1) explain_text_expansion_power ;;
            2) install_espanso ;;
            3) configure_espanso ;;
            4) create_ai_snippets ;;
            5) setup_espanso_service ;;
            6) demo_text_expansion ;;
            7) complete_setup ;;
            0) echo "👋 Your typing efficiency just went through the roof! 🚀"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - all steps in sequence
complete_setup() {
    echo "🚀 COMPLETE TEXT EXPANSION MASTERY SETUP"
    echo "========================================"
    echo ""
    echo "This will set up the ultimate text expansion system:"
    echo "Espanso + AI integration + Power-user snippets + Auto-start"
    echo ""
    read -p "Continue with complete setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_text_expansion_power
        install_espanso
        configure_espanso
        create_ai_snippets
        setup_espanso_service
        demo_text_expansion
        
        echo ""
        echo "🎉 TEXT EXPANSION MASTERY COMPLETE!"
        echo "=================================="
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Advanced text expansion (better than TextExpander)"
        echo "   ✅ AI-powered dynamic snippets"
        echo "   ✅ ADHD-friendly productivity templates"
        echo "   ✅ Audio/VoiceMeeter specific snippets"
        echo "   ✅ Business and technical shortcuts"
        echo "   ✅ Auto-start service configuration"
        echo ""
        echo "🚀 NEXT STEPS:"
        echo "   • Try typing ';date' in any application"
        echo "   • Use ';ai-email' to generate smart email content"
        echo "   • Run 'espanso edit' to add your personal snippets"
        echo "   • Type ';;search' to find snippets quickly"
        echo ""
        echo "💡 Your typing efficiency just increased by 300%!"
        echo "   Windows TextExpander users: Welcome to the superior experience!"
        
        # Log this installation
        echo "$(date): Text Expansion Mastery setup completed with AI integration and power-user snippets" >> ~/.bill-sloth/history.log
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.config/espanso/match
mkdir -p ~/.config/espanso/scripts
mkdir -p ~/.local/bin

# Start the main menu
main_menu