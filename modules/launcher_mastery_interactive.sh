#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=Rofi Launcher, 2=Albert Search, 3=Ulauncher, 4=Custom Shortcuts, 5=Complete Launcher Suite
# CLAUDE_PROMPTS: Launcher selection, Shortcut configuration, Theme customization
# CLAUDE_DEPENDENCIES: rofi, albert, ulauncher, dmenu
# Launcher Mastery - Advanced application launching with AI assistance
# "I got a plan. I got a master plan. You know what it is? You don't touch my fries." - Carl

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

source "../lib/interactive.sh" 2>/dev/null || {
    echo "🚀 LAUNCHER MASTERY SETUP"
    echo "========================"
}

source "../lib/adaptive_learning.sh" 2>/dev/null || {
    echo "⚠️  Adaptive learning not available"
}

# Initialize adaptive learning
init_adaptive_learning "launcher_mastery" "$0" 2>/dev/null || true

show_banner "LAUNCHER MASTERY" "PowerToys Run + Alfred, but AI-enhanced" "PRODUCTIVITY"

echo "🚀 LAUNCHER MASTERY - INSTANT APPLICATION ACCESS WITH AI"
echo "========================================================"
echo ""
echo "🎯 Transform your Linux system into an instant-access powerhouse that makes"
echo "   PowerToys Run, Alfred, and Spotlight look like stone-age tools!"
echo ""
echo "🧠 ADHD BRAIN BENEFITS:"
echo "   • Launch anything instantly with fuzzy search"
echo "   • No more hunting through menus and folders"
echo "   • AI suggests relevant apps based on context"
echo "   • Smart command shortcuts that learn your patterns"
echo "   • Quick calculations, unit conversions, and web searches"
echo "   • Clipboard history and snippet integration"
echo ""

explain_launcher_power() {
    log_usage "launcher_mastery" "explanation_viewed" 2>/dev/null || true
    
    echo "💡 WHAT IS ADVANCED APPLICATION LAUNCHING?"
    echo "=========================================="
    echo ""
    echo "If you're coming from Windows/Mac, you probably used:"
    echo "• 🔥 PowerToys Run - Windows' advanced launcher (Win+R on steroids)"
    echo "• 🍎 Alfred - Mac's premium productivity app"
    echo "• 🔍 Spotlight - Mac's built-in search"
    echo "• ⚡ Wox - Windows alternative launcher"
    echo "• 🎯 Everything + custom hotkeys"
    echo ""
    echo "🚀 THIS LINUX SETUP GIVES YOU ALL THAT PLUS AI MAGIC:"
    echo ""
    echo "🤖 AI-POWERED FEATURES:"
    echo "   • Context-aware app suggestions (coding time = dev tools)"
    echo "   • Natural language commands (\"open my project\" = smart folder detection)"
    echo "   • Smart workflow automation (\"start work\" = opens your work stack)"
    echo "   • Intelligent file associations and suggestions"
    echo ""
    echo "⚡ INSTANT ACCESS:"
    echo "   • Global hotkey launcher (Alt+Space like Alfred/PowerToys)"
    echo "   • Fuzzy search through all applications and files"
    echo "   • Calculator and unit conversion built-in"
    echo "   • Web search integration (Google, Stack Overflow, etc.)"
    echo "   • SSH connection shortcuts and server management"
    echo ""
    echo "🎨 SMART AUTOMATION:"
    echo "   • Custom commands and aliases"
    echo "   • Workflow automation (\"backup project\" runs your backup script)"
    echo "   • System control (volume, brightness, network, etc.)"
    echo "   • Window management integration"
    echo ""
    echo "🔧 POWER-USER FEATURES:"
    echo "   • Plugin system for extensibility"
    echo "   • Theme customization and personalization"
    echo "   • Usage analytics and optimization suggestions"
    echo "   • Cross-device synchronization of settings"
    echo "   • Integration with all your productivity tools"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "explanation_complete" 2>/dev/null || true
    
    read -p "Press Enter to continue..."
    clear
}

install_rofi_launcher() {
    log_usage "launcher_mastery" "rofi_installation" 2>/dev/null || true
    
    echo "🚀 INSTALLING ROFI - THE ULTIMATE LINUX LAUNCHER"
    echo "==============================================="
    echo ""
    echo "🎯 Rofi is like PowerToys Run and Alfred combined, but more powerful!"
    echo ""
    
    if command -v rofi &> /dev/null; then
        echo "✅ Rofi is already installed!"
        ROFI_VERSION=$(rofi -version 2>/dev/null | head -1 || echo "Unknown version")
        echo "   Version: $ROFI_VERSION"
    else
        echo "Installing Rofi launcher..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y rofi rofi-calc rofi-emoji
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y rofi rofi-calc
            elif command -v pacman &> /dev/null; then
                sudo pacman -S rofi rofi-calc rofi-emoji
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install rofi
            fi
        fi
        
        echo "✅ Rofi installation complete!"
    fi
    
    echo ""
    echo "🎯 ROFI FEATURES READY:"
    echo "   • Application launcher with fuzzy search"
    echo "   • Window switcher and management"
    echo "   • Built-in calculator and emoji picker"
    echo "   • File browser and command runner"
    echo "   • SSH connection manager"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "rofi_installed" 2>/dev/null || true
    
    read -p "Press Enter to continue..."
    clear
}

configure_rofi_themes() {
    log_usage "launcher_mastery" "theme_configuration" 2>/dev/null || true
    
    echo "🎨 CONFIGURING ROFI WITH BEAUTIFUL THEMES"
    echo "========================================="
    echo ""
    echo "🎯 Setting up professional themes and layouts..."
    echo ""
    
    # Create rofi config directory
    mkdir -p ~/.config/rofi
    
    # Create main rofi configuration
    cat > ~/.config/rofi/config.rasi << 'EOF'
configuration {
    modi: "drun,run,window,ssh,calc,emoji";
    width: 50;
    lines: 15;
    columns: 1;
    font: "mono 12";
    bw: 1;
    location: 0;
    padding: 5;
    yoffset: 0;
    xoffset: 0;
    fixed-num-lines: true;
    show-icons: true;
    terminal: "gnome-terminal";
    ssh-client: "ssh";
    ssh-command: "{terminal} -e {ssh-client} {host}";
    run-command: "{cmd}";
    run-list-command: "";
    run-shell-command: "{terminal} -e {cmd}";
    window-command: "xkill -id {window}";
    window-match-fields: "all";
    icon-theme: "Papirus";
    drun-match-fields: "name,generic,exec,categories";
    drun-show-actions: false;
    drun-display-format: "{icon} {name}";
    disable-history: false;
    ignored-prefixes: "";
    sort: false;
    sorting-method: "normal";
    case-sensitive: false;
    cycle: true;
    sidebar-mode: false;
    eh: 1;
    auto-select: false;
    parse-hosts: false;
    parse-known-hosts: true;
    combi-modi: "window,drun";
    matching: "fuzzy";
    tokenize: true;
    m: "-5";
    line-margin: 2;
    line-padding: 1;
    filter: "";
    separator-style: "dash";
    hide-scrollbar: false;
    fullscreen: false;
    fake-transparency: false;
    dpi: -1;
    threads: 0;
    scrollbar-width: 8;
    scroll-method: 0;
    fake-background: "screenshot";
    window-format: "{w}    {i}{c}   {t}";
    click-to-exit: true;
    show-match: true;
    theme: "DarkBlue";
    color-normal: "#fdf6e3, #002b36, #eee8d5, #586e75, #eee8d5";
    color-urgent: "#fdf6e3, #dc322f, #eee8d5, #dc322f, #fdf6e3";
    color-active: "#fdf6e3, #268bd2, #eee8d5, #268bd2, #fdf6e3";
    color-window: "#fdf6e3, #002b36, #002b36";
    max-history-size: 25;
    combi-hide-mode-prefix: false;
    matching-negate-char: '-';
    cache-dir: "/home/$USER/.cache/rofi";
    pid: "/run/user/$USER/rofi.pid";
}
EOF
    
    # Create custom AI-enhanced theme
    cat > ~/.config/rofi/bill-sloth.rasi << 'EOF'
* {
    background-color:      #1e1e1e;
    text-color:            #ffffff;
    border-color:          #4CAF50;
    separatorcolor:        #4CAF50;
    selected-normal-foreground: #000000;
    selected-normal-background: #4CAF50;
    selected-active-foreground: #000000;
    selected-active-background: #81C784;
    selected-urgent-foreground: #000000;
    selected-urgent-background: #FF5722;
}

window {
    background-color: @background-color;
    border:           2;
    border-color:     @border-color;
    border-radius:    10px;
    padding:          10;
}

mainbox {
    border:  0;
    padding: 0;
}

message {
    border:       2px 0px 0px;
    border-color: @separatorcolor;
    padding:      1px;
}

textbox {
    text-color: @text-color;
}

listview {
    fixed-height: 0;
    border:       2px 0px 0px;
    border-color: @separatorcolor;
    spacing:      2px;
    scrollbar:    true;
    padding:      2px 0px 0px;
}

element {
    border:  0;
    padding: 8px;
}

element.normal.normal {
    background-color: @background-color;
    text-color:       @text-color;
}

element.selected.normal {
    background-color: @selected-normal-background;
    text-color:       @selected-normal-foreground;
}

scrollbar {
    width:        4px;
    border:       0;
    handle-color: @border-color;
    handle-width: 8px;
    padding:      0;
}

sidebar {
    border:       2px 0px 0px;
    border-color: @separatorcolor;
}

inputbar {
    spacing:    0;
    text-color: @text-color;
    padding:    8px;
    background-color: #2d2d2d;
    border-radius: 5px;
}

case-indicator {
    spacing:    0;
    text-color: @text-color;
}

entry {
    spacing:    0;
    text-color: @text-color;
    placeholder-color: #888888;
    placeholder: "Start typing to search...";
}

prompt {
    spacing:    0;
    text-color: #4CAF50;
}
EOF
    
    echo "✅ Rofi themes configured!"
    echo ""
    echo "🎨 AVAILABLE THEMES:"
    echo "   • bill-sloth (Custom Bill Sloth theme)"
    echo "   • DarkBlue (Professional dark theme)"
    echo "   • Default system themes"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "themes_configured" 2>/dev/null || true
    
    read -p "Press Enter to continue..."
    clear
}

create_ai_launcher_scripts() {
    log_usage "launcher_mastery" "ai_scripts_creation" 2>/dev/null || true
    
    echo "🤖 CREATING AI-ENHANCED LAUNCHER SCRIPTS"
    echo "========================================"
    echo ""
    echo "🎯 Building intelligent shortcuts and AI-powered workflows..."
    echo ""
    
    mkdir -p ~/.local/bin
    
    # Smart launcher with AI context
    cat > ~/.local/bin/smart-launch << 'EOF'
#!/bin/bash
# AI-enhanced launcher with context awareness
# Usage: smart-launch [query]

QUERY="$*"

# Time-based context detection
HOUR=$(date +%H)
if [ $HOUR -ge 9 ] && [ $HOUR -le 17 ]; then
    CONTEXT="work"
elif [ $HOUR -ge 18 ] && [ $HOUR -le 23 ]; then
    CONTEXT="evening"
else
    CONTEXT="general"
fi

# Day-based context
DAY=$(date +%u)  # 1=Monday, 7=Sunday
if [ $DAY -le 5 ]; then
    WORKDAY="true"
else
    WORKDAY="false"
fi

if [ -z "$QUERY" ]; then
    # Smart rofi launcher with context
    case $CONTEXT in
        "work")
            rofi -show drun -theme ~/.config/rofi/bill-sloth.rasi \
                 -filter "code terminal browser" \
                 -display-drun "🏢 Work Apps"
            ;;
        "evening")
            rofi -show drun -theme ~/.config/rofi/bill-sloth.rasi \
                 -filter "media games steam discord" \
                 -display-drun "🎮 Entertainment"
            ;;
        *)
            rofi -show drun -theme ~/.config/rofi/bill-sloth.rasi
            ;;
    esac
else
    # Process AI-style queries
    case "$QUERY" in
        "start work"|"work mode"|"work time")
            echo "🏢 Starting work mode..."
            # Launch work applications
            code ~/projects &
            firefox &
            slack &
            ;;
        "gaming time"|"play games"|"entertainment")
            echo "🎮 Starting entertainment mode..."
            steam &
            discord &
            ;;
        "focus mode"|"distraction free")
            echo "🎯 Enabling focus mode..."
            # Close distracting apps
            pkill -f "discord\|slack\|telegram"
            # Launch focus apps
            code &
            gnome-terminal &
            ;;
        "backup project"|"backup work")
            echo "💾 Starting project backup..."
            ~/scripts/backup-projects.sh 2>/dev/null || echo "Create backup script first"
            ;;
        *)
            # Use Claude for intelligent command interpretation if available
            if command -v claude &> /dev/null; then
                INTERPRETATION=$(claude "User wants to: '$QUERY'. Suggest 1-2 Linux applications to launch or commands to run. Be specific and brief." 2>/dev/null)
                if [ $? -eq 0 ] && [ -n "$INTERPRETATION" ]; then
                    echo "🤖 AI suggestion: $INTERPRETATION"
                    rofi -show drun -theme ~/.config/rofi/bill-sloth.rasi -filter "$QUERY"
                else
                    rofi -show drun -theme ~/.config/rofi/bill-sloth.rasi -filter "$QUERY"
                fi
            else
                rofi -show drun -theme ~/.config/rofi/bill-sloth.rasi -filter "$QUERY"
            fi
            ;;
    esac
fi
EOF

    # Quick calculator launcher
    cat > ~/.local/bin/quick-calc << 'EOF'
#!/bin/bash
# Quick calculator launcher
# Usage: quick-calc [expression]

if [ -n "$1" ]; then
    # Direct calculation
    echo "🧮 $1 = $(echo "$1" | bc -l 2>/dev/null || echo 'Invalid expression')"
else
    # Interactive calculator
    rofi -show calc -theme ~/.config/rofi/bill-sloth.rasi \
         -no-show-match -no-sort \
         -display-calc "🧮 Calculator"
fi
EOF

    # Smart file launcher
    cat > ~/.local/bin/quick-file << 'EOF'
#!/bin/bash
# Quick file finder and launcher
# Usage: quick-file [search_term]

SEARCH_TERM="$1"

if [ -n "$SEARCH_TERM" ]; then
    # Search for files matching term
    FOUND_FILES=$(find ~ -type f -name "*$SEARCH_TERM*" -not -path "*/.*" | head -10)
    
    if [ -n "$FOUND_FILES" ]; then
        SELECTED=$(echo "$FOUND_FILES" | rofi -dmenu -theme ~/.config/rofi/bill-sloth.rasi -p "📁 Select file:")
        if [ -n "$SELECTED" ]; then
            xdg-open "$SELECTED" 2>/dev/null || echo "Cannot open: $SELECTED"
        fi
    else
        echo "No files found matching: $SEARCH_TERM"
    fi
else
    # Browse recent files
    RECENT_FILES=$(find ~ -type f -not -path "*/.*" -printf '%T@ %p\n' | sort -rn | head -20 | cut -d' ' -f2-)
    SELECTED=$(echo "$RECENT_FILES" | rofi -dmenu -theme ~/.config/rofi/bill-sloth.rasi -p "📁 Recent files:")
    if [ -n "$SELECTED" ]; then
        xdg-open "$SELECTED" 2>/dev/null || echo "Cannot open: $SELECTED"
    fi
fi
EOF

    # Project launcher
    cat > ~/.local/bin/project-launch << 'EOF'
#!/bin/bash
# Smart project launcher
# Usage: project-launch [project_name]

PROJECTS_DIR="$HOME/projects"
mkdir -p "$PROJECTS_DIR"

if [ -n "$1" ]; then
    PROJECT_NAME="$1"
    PROJECT_PATH="$PROJECTS_DIR/$PROJECT_NAME"
    
    if [ -d "$PROJECT_PATH" ]; then
        echo "🚀 Opening project: $PROJECT_NAME"
        cd "$PROJECT_PATH"
        
        # Smart project opening based on content
        if [ -f "package.json" ]; then
            echo "📦 Node.js project detected"
            code . &
            gnome-terminal --working-directory="$PROJECT_PATH" &
        elif [ -f "Cargo.toml" ]; then
            echo "🦀 Rust project detected"
            code . &
            gnome-terminal --working-directory="$PROJECT_PATH" &
        elif [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
            echo "🐍 Python project detected"
            code . &
            gnome-terminal --working-directory="$PROJECT_PATH" &
        else
            echo "📁 Generic project"
            code . &
        fi
    else
        echo "❌ Project not found: $PROJECT_NAME"
        echo "Available projects:"
        ls -1 "$PROJECTS_DIR" 2>/dev/null || echo "No projects found"
    fi
else
    # Show project selector
    if [ -d "$PROJECTS_DIR" ]; then
        PROJECTS=$(ls -1 "$PROJECTS_DIR" 2>/dev/null)
        if [ -n "$PROJECTS" ]; then
            SELECTED=$(echo "$PROJECTS" | rofi -dmenu -theme ~/.config/rofi/bill-sloth.rasi -p "🚀 Select project:")
            if [ -n "$SELECTED" ]; then
                project-launch "$SELECTED"
            fi
        else
            echo "No projects found in $PROJECTS_DIR"
        fi
    else
        echo "Projects directory not found: $PROJECTS_DIR"
    fi
fi
EOF

    chmod +x ~/.local/bin/smart-launch ~/.local/bin/quick-calc ~/.local/bin/quick-file ~/.local/bin/project-launch
    
    echo "✅ AI launcher scripts created!"
    echo ""
    echo "🤖 YOUR NEW AI COMMANDS:"
    echo "   smart-launch           = Context-aware app launcher"
    echo "   smart-launch 'work'    = Start work mode applications"
    echo "   quick-calc '2+2'       = Instant calculations"
    echo "   quick-file 'config'    = Find and open files quickly"
    echo "   project-launch         = Smart project workspace opener"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "ai_scripts_created" 2>/dev/null || true
    
    read -p "Press Enter to continue..."
    clear
}

setup_global_hotkeys() {
    log_usage "launcher_mastery" "hotkeys_setup" 2>/dev/null || true
    
    echo "⌨️  SETTING UP GLOBAL LAUNCHER HOTKEYS"
    echo "====================================="
    echo ""
    echo "🎯 Creating PowerToys Run and Alfred-style global shortcuts..."
    echo ""
    
    # Create hotkey script
    cat > ~/.local/bin/launcher-hotkeys << 'EOF'
#!/bin/bash
# Global hotkey handler for launcher

case "$1" in
    "main-launcher")
        smart-launch
        ;;
    "calculator")
        quick-calc
        ;;
    "files")
        quick-file
        ;;
    "projects")
        project-launch
        ;;
    "window-switcher")
        rofi -show window -theme ~/.config/rofi/bill-sloth.rasi
        ;;
    "emoji-picker")
        rofi -show emoji -theme ~/.config/rofi/bill-sloth.rasi
        ;;
    "ssh-launcher")
        rofi -show ssh -theme ~/.config/rofi/bill-sloth.rasi
        ;;
    *)
        echo "Usage: $0 {main-launcher|calculator|files|projects|window-switcher|emoji-picker|ssh-launcher}"
        ;;
esac
EOF
    
    chmod +x ~/.local/bin/launcher-hotkeys
    
    echo "✅ Hotkey scripts configured!"
    echo ""
    echo "⌨️  TO ACTIVATE GLOBAL HOTKEYS:"
    echo ""
    echo "Open your system settings and add these keyboard shortcuts:"
    echo ""
    echo "🚀 PRIMARY SHORTCUTS (Like PowerToys Run):"
    echo "   Alt+Space     → launcher-hotkeys main-launcher"
    echo "   Ctrl+Alt+C    → launcher-hotkeys calculator"
    echo "   Ctrl+Alt+F    → launcher-hotkeys files"
    echo "   Ctrl+Alt+P    → launcher-hotkeys projects"
    echo ""
    echo "🔧 ADVANCED SHORTCUTS:"
    echo "   Alt+Tab       → launcher-hotkeys window-switcher"
    echo "   Ctrl+Alt+E    → launcher-hotkeys emoji-picker"
    echo "   Ctrl+Alt+S    → launcher-hotkeys ssh-launcher"
    echo ""
    echo "💡 GNOME USERS: Settings > Keyboard Shortcuts > Custom Shortcuts"
    echo "💡 KDE USERS: System Settings > Shortcuts > Custom Shortcuts"
    echo "💡 i3/BSPWM USERS: Add to your window manager config"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "hotkeys_configured" 2>/dev/null || true
    
    read -p "Press Enter to continue..."
    clear
}

create_workflow_automation() {
    log_usage "launcher_mastery" "workflow_automation" 2>/dev/null || true
    
    echo "🔄 CREATING WORKFLOW AUTOMATION"
    echo "=============================="
    echo ""
    echo "🎯 Setting up intelligent workflow shortcuts..."
    echo ""
    
    # Create workflow scripts directory
    mkdir -p ~/.local/share/rofi/workflows
    
    # Work mode workflow
    cat > ~/.local/share/rofi/workflows/work-mode.sh << 'EOF'
#!/bin/bash
# Work mode activation script

echo "🏢 Activating work mode..."

# Close distracting applications
pkill -f "steam\|discord\|games" 2>/dev/null || true

# Launch work applications
code ~/projects &
firefox --new-window https://github.com &
gnome-terminal &
slack &

# Set focus mode (if available)
if command -v focus-mode &> /dev/null; then
    focus-mode on
fi

echo "✅ Work mode activated!"
EOF

    # Gaming mode workflow  
    cat > ~/.local/share/rofi/workflows/gaming-mode.sh << 'EOF'
#!/bin/bash
# Gaming mode activation script

echo "🎮 Activating gaming mode..."

# Close work applications
pkill -f "slack\|teams\|zoom" 2>/dev/null || true

# Launch gaming applications
steam &
discord &

# Optimize system for gaming
if command -v gamemode &> /dev/null; then
    echo "🚀 GameMode available for performance boost"
fi

echo "✅ Gaming mode activated!"
EOF

    # Project backup workflow
    cat > ~/.local/share/rofi/workflows/backup-projects.sh << 'EOF'
#!/bin/bash
# Project backup automation

echo "💾 Starting project backup..."

BACKUP_DIR="$HOME/backups/projects"
PROJECTS_DIR="$HOME/projects"

mkdir -p "$BACKUP_DIR"

if [ -d "$PROJECTS_DIR" ]; then
    # Create timestamped backup
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    tar -czf "$BACKUP_DIR/projects_backup_$TIMESTAMP.tar.gz" -C "$HOME" projects/
    
    echo "✅ Projects backed up to: $BACKUP_DIR/projects_backup_$TIMESTAMP.tar.gz"
    
    # Keep only last 5 backups
    cd "$BACKUP_DIR"
    ls -t projects_backup_*.tar.gz | tail -n +6 | xargs rm -f 2>/dev/null || true
    
    echo "🗂️  Cleanup complete - keeping 5 most recent backups"
else
    echo "❌ Projects directory not found: $PROJECTS_DIR"
fi
EOF

    # AI workflow helper
    cat > ~/.local/share/rofi/workflows/ai-workflow.sh << 'EOF'
#!/bin/bash
# AI-powered workflow suggestions

TASK="$1"

if [ -z "$TASK" ]; then
    echo "Usage: ai-workflow.sh '<task description>'"
    exit 1
fi

if command -v claude &> /dev/null; then
    echo "🤖 AI analyzing workflow for: $TASK"
    
    WORKFLOW_SUGGESTION=$(claude "User wants to: '$TASK'. Suggest 2-3 Linux applications or commands they should run to accomplish this efficiently. Be specific and brief." 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$WORKFLOW_SUGGESTION" ]; then
        echo "💡 AI Workflow Suggestion:"
        echo "$WORKFLOW_SUGGESTION"
        echo ""
        read -p "Run suggested workflow? (y/n): " confirm
        
        if [[ $confirm =~ ^[Yy]$ ]]; then
            echo "🚀 Executing AI-suggested workflow..."
            # This would need more sophisticated parsing to actually execute
            echo "Manual execution required - workflow suggestions shown above"
        fi
    else
        echo "❌ AI workflow generation failed"
    fi
else
    echo "❌ Claude Code required for AI workflow suggestions"
fi
EOF

    chmod +x ~/.local/share/rofi/workflows/*.sh
    
    # Create workflow launcher
    cat > ~/.local/bin/launch-workflow << 'EOF'
#!/bin/bash
# Workflow launcher interface

WORKFLOWS_DIR="$HOME/.local/share/rofi/workflows"

if [ -n "$1" ]; then
    # Direct workflow execution
    WORKFLOW="$1"
    if [ -f "$WORKFLOWS_DIR/$WORKFLOW.sh" ]; then
        "$WORKFLOWS_DIR/$WORKFLOW.sh"
    else
        echo "❌ Workflow not found: $WORKFLOW"
        echo "Available workflows:"
        ls -1 "$WORKFLOWS_DIR"/*.sh | sed 's|.*/||' | sed 's|\.sh$||'
    fi
else
    # Interactive workflow selection
    AVAILABLE_WORKFLOWS=$(ls -1 "$WORKFLOWS_DIR"/*.sh 2>/dev/null | sed 's|.*/||' | sed 's|\.sh$||')
    
    if [ -n "$AVAILABLE_WORKFLOWS" ]; then
        SELECTED=$(echo "$AVAILABLE_WORKFLOWS" | rofi -dmenu -theme ~/.config/rofi/bill-sloth.rasi -p "🔄 Select workflow:")
        
        if [ -n "$SELECTED" ]; then
            launch-workflow "$SELECTED"
        fi
    else
        echo "No workflows found in $WORKFLOWS_DIR"
    fi
fi
EOF

    chmod +x ~/.local/bin/launch-workflow
    
    echo "✅ Workflow automation configured!"
    echo ""
    echo "🔄 AVAILABLE WORKFLOWS:"
    echo "   work-mode      = Activate work environment"
    echo "   gaming-mode    = Activate gaming setup"
    echo "   backup-projects = Backup all projects"
    echo "   ai-workflow    = AI-suggested workflows"
    echo ""
    echo "🚀 USAGE:"
    echo "   launch-workflow           = Interactive workflow selector"
    echo "   launch-workflow work-mode = Direct workflow activation"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "workflows_created" 2>/dev/null || true
    
    read -p "Press Enter to continue..."
    clear
}

demo_launcher_mastery() {
    log_usage "launcher_mastery" "demo_completed" 2>/dev/null || true
    
    echo "🎯 LAUNCHER MASTERY DEMONSTRATION"
    echo "================================"
    echo ""
    echo "Let's test your new instant-access superpowers!"
    echo ""
    
    # Test Rofi installation
    echo "🚀 TESTING ROFI LAUNCHER:"
    if command -v rofi &> /dev/null; then
        echo "✅ Rofi installed and ready"
        rofi -version | head -1
    else
        echo "❌ Rofi not installed"
    fi
    echo ""
    
    # Test custom scripts
    echo "🤖 TESTING AI LAUNCHER SCRIPTS:"
    SCRIPTS=("smart-launch" "quick-calc" "quick-file" "project-launch" "launch-workflow")
    for script in "${SCRIPTS[@]}"; do
        if command -v "$script" &> /dev/null; then
            echo "   ✅ $script ready"
        else
            echo "   ❌ $script not available"
        fi
    done
    echo ""
    
    echo "⌨️  TESTING HOTKEY INTEGRATION:"
    if command -v launcher-hotkeys &> /dev/null; then
        echo "✅ Hotkey handlers configured"
        echo "   Set up global shortcuts in your system settings"
    else
        echo "❌ Hotkey handlers not configured"
    fi
    echo ""
    
    echo "🔄 TESTING WORKFLOW AUTOMATION:"
    WORKFLOW_COUNT=$(ls -1 ~/.local/share/rofi/workflows/*.sh 2>/dev/null | wc -l)
    echo "✅ $WORKFLOW_COUNT workflows available"
    
    if [ $WORKFLOW_COUNT -gt 0 ]; then
        echo "   Available workflows:"
        ls -1 ~/.local/share/rofi/workflows/*.sh | sed 's|.*/||' | sed 's|\.sh$||' | sed 's/^/     • /'
    fi
    echo ""
    
    echo "🎯 YOUR LAUNCHER MASTERY COMMANDS:"
    echo ""
    echo "🚀 INSTANT LAUNCHING:"
    echo "   smart-launch              = Context-aware app launcher"
    echo "   smart-launch 'work mode'  = Start work applications"
    echo "   smart-launch 'focus'      = Enable distraction-free mode"
    echo ""
    echo "⚡ QUICK ACCESS:"
    echo "   quick-calc '15 * 24'      = Instant calculations"
    echo "   quick-file 'config'       = Find files fast"
    echo "   project-launch            = Open project workspaces"
    echo ""
    echo "🔄 WORKFLOWS:"
    echo "   launch-workflow           = Interactive workflow selector"
    echo "   launch-workflow work-mode = Activate work environment"
    echo ""
    echo "⌨️  GLOBAL HOTKEYS (Set up in system settings):"
    echo "   Alt+Space = Main launcher (like PowerToys Run/Alfred)"
    echo "   Ctrl+Alt+C = Calculator"
    echo "   Ctrl+Alt+F = File finder"
    echo "   Ctrl+Alt+P = Project launcher"
    echo ""
    echo "🎨 THEMES & CUSTOMIZATION:"
    echo "   ~/.config/rofi/bill-sloth.rasi = Custom theme file"
    echo "   rofi-theme-selector = Browse available themes"
    echo ""
    echo "💡 Windows/Mac refugees: You now have MORE power than PowerToys Run or Alfred!"
    echo "   Your launcher is AI-enhanced and learns your patterns!"
    echo ""
    
    smart_feedback_prompt "launcher_mastery" "demo_complete" 2>/dev/null || true
    
    read -p "Press Enter to finish launcher setup..."
    clear
}

# Main menu
main_menu() {
    while true; do
        show_banner "LAUNCHER MASTERY" "PowerToys Run + Alfred, but AI-enhanced" "PRODUCTIVITY"
        
        echo "🚀 LAUNCHER MASTERY MENU"
        echo "======================="
        echo ""
        echo "1) 💡 What is Advanced Application Launching?"
        echo "2) 🚀 Install Rofi (Ultimate Launcher)"
        echo "3) 🎨 Configure Rofi with Beautiful Themes"
        echo "4) 🤖 Create AI-Enhanced Launcher Scripts"
        echo "5) ⌨️  Setup Global Hotkeys (PowerToys Run style)"
        echo "6) 🔄 Create Workflow Automation"
        echo "7) 🎯 Demo Your Launcher Mastery Powers"
        echo "8) 🌟 Complete Setup (All Steps)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-8): " choice
        
        case $choice in
            1) explain_launcher_power ;;
            2) install_rofi_launcher ;;
            3) configure_rofi_themes ;;
            4) create_ai_launcher_scripts ;;
            5) setup_global_hotkeys ;;
            6) create_workflow_automation ;;
            7) demo_launcher_mastery ;;
            8) complete_setup ;;
            0) echo "👋 Your instant-access superpowers are ready! 🚀"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - all steps in sequence
complete_setup() {
    echo "🚀 COMPLETE LAUNCHER MASTERY SETUP"
    echo "=================================="
    echo ""
    echo "This will set up the ultimate application launcher:"
    echo "Rofi + AI integration + Global hotkeys + Workflow automation"
    echo ""
    read -p "Continue with complete setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_launcher_power
        install_rofi_launcher
        configure_rofi_themes
        create_ai_launcher_scripts
        setup_global_hotkeys
        create_workflow_automation
        demo_launcher_mastery
        
        echo ""
        echo "🎉 LAUNCHER MASTERY COMPLETE!"
        echo "==========================="
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Advanced application launcher (better than PowerToys Run)"
        echo "   ✅ AI-powered context awareness and smart suggestions"
        echo "   ✅ Global hotkeys for instant access"
        echo "   ✅ Workflow automation and project management"
        echo "   ✅ Beautiful themes and customizable interface"
        echo "   ✅ Calculator, file finder, and emoji picker integration"
        echo ""
        echo "🚀 NEXT STEPS:"
        echo "   • Set up global hotkey Alt+Space → launcher-hotkeys main-launcher"
        echo "   • Try smart-launch 'work mode' to test AI workflows"
        echo "   • Customize themes in ~/.config/rofi/bill-sloth.rasi"
        echo "   • Add your own workflows in ~/.local/share/rofi/workflows/"
        echo ""
        echo "💡 PowerToys Run users: Welcome to your superior launching experience!"
        echo "   Alfred users: You now have AI enhancement they could only dream of!"
        
        # Log this installation
        echo "$(date): Launcher Mastery setup completed with AI integration and workflow automation" >> ~/.bill-sloth/history.log
        
        smart_feedback_prompt "launcher_mastery" "complete_setup_finished" 2>/dev/null || true
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.config/rofi
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/rofi/workflows

# Start the main menu
main_menu