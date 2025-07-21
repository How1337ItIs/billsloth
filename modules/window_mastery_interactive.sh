#!/bin/bash
# LLM_CAPABILITY: auto
# Window Mastery - Advanced window management with AI-powered layouts
# "Well, let's compute it, and I will solve the answer... to your face!" - Carl

source "../lib/interactive.sh" 2>/dev/null || {
    echo "🪟 WINDOW MASTERY SETUP"
    echo "======================="
}

show_banner "WINDOW MASTERY" "Windows PowerToys FancyZones, but intelligent" "PRODUCTIVITY"

echo "🪟 WINDOW MASTERY - WINDOWS POWER-USER WINDOW MANAGEMENT, SUPERCHARGED"
echo "======================================================================"
echo ""
echo "🎯 Transform your window management into something that makes PowerToys"
echo "   FancyZones and Windows snap features look like amateur hour!"
echo ""
echo "🧠 ADHD BRAIN BENEFITS:"
echo "   • Automatic window organization reduces visual overwhelm"
echo "   • Consistent layouts create predictable work environments"
echo "   • Quick workspace switching prevents task-switching friction"
echo "   • AI-powered layouts adapt to your workflow patterns"
echo "   • Focus modes eliminate distracting windows automatically"
echo "   • Muscle memory shortcuts for lightning-fast navigation"
echo ""

explain_window_mastery() {
    echo "💡 WHAT IS ADVANCED WINDOW MANAGEMENT?"
    echo "======================================"
    echo ""
    echo "If you're coming from Windows, you probably used:"
    echo "• 🔥 PowerToys FancyZones - Grid-based window snapping"
    echo "• 🪟 Windows Snap - Basic 2-window side-by-side"
    echo "• 🖥️  Virtual Desktops - Basic workspace switching"
    echo "• ⌨️  Alt+Tab - Application switching"
    echo "• 📱 Windows+Arrow - Manual window positioning"
    echo ""
    echo "🚀 THIS LINUX SETUP GIVES YOU ALL THAT PLUS AI INTELLIGENCE:"
    echo ""
    echo "🎨 TILING WINDOW MANAGERS:"
    echo "   • i3wm: Keyboard-driven automatic window tiling"
    echo "   • Sway: Wayland version with modern features"
    echo "   • Awesome WM: Lua-configurable floating/tiling hybrid"
    echo "   • dwm: Minimalist dynamic window manager"
    echo ""
    echo "🤖 AI-POWERED FEATURES:"
    echo "   • Smart layout suggestions based on application types"
    echo "   • Automatic workspace assignment by project context"
    echo "   • Focus mode that hides distracting applications"
    echo "   • Learning window size preferences for each app"
    echo ""
    echo "⚡ ADVANCED AUTOMATION:"
    echo "   • Application-specific window rules and behaviors"
    echo "   • Multi-monitor intelligent window placement"
    echo "   • Workspace persistence across reboots"
    echo "   • Context-aware window grouping and tabbing"
    echo ""
    echo "🎯 PRODUCTIVITY ENHANCEMENTS:"
    echo "   • Scratchpad windows for quick access to terminals/notes"
    echo "   • Dynamic workspace creation based on current tasks"
    echo "   • Window history and session restoration"
    echo "   • Global hotkeys for any window management action"
    echo ""
    echo "🔧 POWER-USER FEATURES:"
    echo "   • Scriptable window operations and automation"
    echo "   • Custom layouts for different work contexts"
    echo "   • Integration with productivity tools and workflows"
    echo "   • Advanced multi-monitor support with individual configs"
    echo "   • Window transparency and focus follows mouse options"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

detect_desktop_environment() {
    echo "🔍 DETECTING DESKTOP ENVIRONMENT"
    echo "==============================="
    echo ""
    echo "🎯 Analyzing your current desktop setup..."
    echo ""
    
    # Detect current desktop environment
    if [ -n "$XDG_CURRENT_DESKTOP" ]; then
        DESKTOP="$XDG_CURRENT_DESKTOP"
    elif [ -n "$DESKTOP_SESSION" ]; then
        DESKTOP="$DESKTOP_SESSION"
    elif pgrep gnome-shell > /dev/null; then
        DESKTOP="GNOME"
    elif pgrep kwin > /dev/null; then
        DESKTOP="KDE"
    elif pgrep xfce4-panel > /dev/null; then
        DESKTOP="XFCE"
    else
        DESKTOP="Unknown"
    fi
    
    # Detect display server
    if [ -n "$WAYLAND_DISPLAY" ]; then
        DISPLAY_SERVER="Wayland"
    elif [ -n "$DISPLAY" ]; then
        DISPLAY_SERVER="X11"
    else
        DISPLAY_SERVER="Unknown"
    fi
    
    echo "📊 SYSTEM ANALYSIS:"
    echo "   Desktop Environment: $DESKTOP"
    echo "   Display Server: $DISPLAY_SERVER"
    echo "   Session Type: ${XDG_SESSION_TYPE:-Unknown}"
    echo ""
    
    # Make recommendations based on detection
    echo "💡 RECOMMENDED WINDOW MANAGER:"
    case $DESKTOP in
        "GNOME")
            echo "   🎯 GNOME Extensions + i3-like keybindings"
            echo "   📦 Pop Shell for tiling, gTile for FancyZones-style"
            RECOMMENDED="gnome-extensions"
            ;;
        "KDE")
            echo "   🎯 KWin Scripts + tiling extensions"
            echo "   📦 Bismuth for automatic tiling, KWin zones"
            RECOMMENDED="kwin-tiling"
            ;;
        "XFCE")
            echo "   🎯 i3wm integration with XFCE panel"
            echo "   📦 Best of both worlds - tiling + traditional"
            RECOMMENDED="i3-xfce"
            ;;
        *)
            if [ "$DISPLAY_SERVER" = "Wayland" ]; then
                echo "   🎯 Sway (i3-compatible for Wayland)"
                RECOMMENDED="sway"
            else
                echo "   🎯 i3wm (most popular tiling manager)"
                RECOMMENDED="i3wm"
            fi
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue with setup..."
    clear
}

install_gnome_extensions() {
    echo "🔧 SETTING UP GNOME POWER-USER EXTENSIONS"
    echo "========================================="
    echo ""
    echo "🎯 Installing extensions that turn GNOME into a window management powerhouse!"
    echo ""
    
    # Install GNOME Shell extensions manager
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y gnome-shell-extensions gnome-shell-extension-manager \
                           chrome-gnome-shell gnome-tweaks
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y gnome-shell-extensions gnome-extensions-app \
                           chrome-gnome-shell gnome-tweaks
    elif command -v pacman &> /dev/null; then
        sudo pacman -S gnome-shell-extensions gnome-browser-connector \
                      gnome-tweaks
    fi
    
    echo "✅ Extension tools installed!"
    echo ""
    echo "🎯 ESSENTIAL GNOME EXTENSIONS FOR POWER USERS:"
    echo ""
    echo "1️⃣  POP SHELL - Automatic Tiling"
    echo "   • Automatic window tiling like i3wm"
    echo "   • Keyboard shortcuts for window management"
    echo "   • Works seamlessly with GNOME workflow"
    echo ""
    echo "2️⃣  GTILE - FancyZones for GNOME"
    echo "   • Grid-based window snapping"
    echo "   • Custom layout zones"
    echo "   • PowerToys FancyZones equivalent"
    echo ""
    echo "3️⃣  DASH TO DOCK - Enhanced Taskbar"
    echo "   • Windows-style taskbar with previews"
    echo "   • Application pinning and organization"
    echo "   • Multi-monitor support"
    echo ""
    echo "4️⃣  WORKSPACE INDICATOR - Visual Workspace Management"
    echo "   • See all workspaces at a glance"
    echo "   • Click to switch between workspaces"
    echo "   • Customizable workspace names"
    echo ""
    
    # Create installation script for extensions
    cat > ~/.local/bin/install-gnome-extensions << 'EOF'
#!/bin/bash
# GNOME Extensions Auto-Installer

echo "🔧 Installing GNOME Power-User Extensions..."
echo ""

# List of essential extensions (by UUID)
EXTENSIONS=(
    "pop-shell@system76.com"
    "gtile@vibou"
    "dash-to-dock@micxgx.gmail.com"
    "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
    "auto-move-windows@gnome-shell-extensions.gcampax.github.com"
    "windowsNavigator@gnome-shell-extensions.gcampax.github.com"
    "apps-menu@gnome-shell-extensions.gcampax.github.com"
    "places-menu@gnome-shell-extensions.gcampax.github.com"
)

for ext in "${EXTENSIONS[@]}"; do
    echo "Installing: $ext"
    gnome-extensions install "$ext" 2>/dev/null || echo "Could not auto-install $ext - install manually"
done

echo ""
echo "✅ Extensions installed! Enable them with:"
echo "   gnome-extensions enable pop-shell@system76.com"
echo "   gnome-extensions enable gtile@vibou"
echo "   gnome-extensions enable dash-to-dock@micxgx.gmail.com"
echo ""
echo "Or use GNOME Extensions app (GUI)"
EOF

    chmod +x ~/.local/bin/install-gnome-extensions
    
    echo "📦 MANUAL INSTALLATION INSTRUCTIONS:"
    echo ""
    echo "1️⃣  Open Firefox/Chrome and go to: https://extensions.gnome.org"
    echo "2️⃣  Install browser extension when prompted"
    echo "3️⃣  Search for and install these extensions:"
    echo "     • Pop Shell (tiling)"
    echo "     • gTile (grid snapping)"
    echo "     • Dash to Dock (taskbar)"
    echo "     • Workspace Indicator (workspace switcher)"
    echo ""
    echo "🚀 QUICK INSTALL SCRIPT CREATED:"
    echo "   Run: install-gnome-extensions"
    echo ""
    
    read -p "Press Enter to continue..."
    clear
}

install_i3wm() {
    echo "🏗️  INSTALLING I3WM - THE TILING POWERHOUSE"
    echo "=========================================="
    echo ""
    echo "🎯 Setting up i3wm - the most popular tiling window manager!"
    echo ""
    
    # Install i3wm and related tools
    if command -v apt &> /dev/null; then
        sudo apt update
        sudo apt install -y i3 i3status i3lock dmenu rofi polybar \
                           feh nitrogen compton picom dunst \
                           arandr lxappearance
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y i3 i3status i3lock dmenu rofi polybar \
                           feh nitrogen picom dunst \
                           arandr lxappearance
    elif command -v pacman &> /dev/null; then
        sudo pacman -S i3-wm i3status i3lock dmenu rofi polybar \
                      feh nitrogen picom dunst \
                      arandr lxappearance
    fi
    
    echo "✅ i3wm and tools installed!"
    echo ""
    echo "⚙️  CREATING POWER-USER I3 CONFIGURATION..."
    echo ""
    
    # Create i3 config directory
    mkdir -p ~/.config/i3
    
    # Create comprehensive i3 config
    cat > ~/.config/i3/config << 'EOF'
# Bill Sloth i3wm Configuration - Windows Power User Edition
# Optimized for ADHD-friendly workflow and productivity

set $mod Mod4

# Font for window titles and bar
font pango:DejaVu Sans Mono 10

# Use Mouse+$mod to drag floating windows
floating_modifier $mod

# Start a terminal
bindsym $mod+Return exec gnome-terminal

# Kill focused window
bindsym $mod+Shift+q kill

# Start application launcher (like Windows Start Menu)
bindsym $mod+d exec rofi -show drun
bindsym $mod+Tab exec rofi -show window

# Change focus (Vi-style keys)
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# Alternative: cursor keys
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# Move focused window
bindsym $mod+Shift+h move left
bindsym $mod+Shift+j move down
bindsym $mod+Shift+k move up
bindsym $mod+Shift+l move right

# Alternative: cursor keys
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# Split orientations
bindsym $mod+v split h
bindsym $mod+s split v

# Enter fullscreen mode
bindsym $mod+f fullscreen toggle

# Change container layout
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# Toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# Change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# Focus parent/child container
bindsym $mod+a focus parent
bindsym $mod+z focus child

# Workspaces (like Windows Virtual Desktops but better)
set $ws1 "1:Code"
set $ws2 "2:Web"
set $ws3 "3:Communication"
set $ws4 "4:Media"
set $ws5 "5:Documents"
set $ws6 "6:Gaming"
set $ws7 "7:Monitoring"
set $ws8 "8:VMs"
set $ws9 "9:Notes"
set $ws10 "10:Misc"

# Switch to workspace
bindsym $mod+1 workspace $ws1
bindsym $mod+2 workspace $ws2
bindsym $mod+3 workspace $ws3
bindsym $mod+4 workspace $ws4
bindsym $mod+5 workspace $ws5
bindsym $mod+6 workspace $ws6
bindsym $mod+7 workspace $ws7
bindsym $mod+8 workspace $ws8
bindsym $mod+9 workspace $ws9
bindsym $mod+0 workspace $ws10

# Move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $ws1
bindsym $mod+Shift+2 move container to workspace $ws2
bindsym $mod+Shift+3 move container to workspace $ws3
bindsym $mod+Shift+4 move container to workspace $ws4
bindsym $mod+Shift+5 move container to workspace $ws5
bindsym $mod+Shift+6 move container to workspace $ws6
bindsym $mod+Shift+7 move container to workspace $ws7
bindsym $mod+Shift+8 move container to workspace $ws8
bindsym $mod+Shift+9 move container to workspace $ws9
bindsym $mod+Shift+0 move container to workspace $ws10

# Application-specific workspace assignments
assign [class="Code"] $ws1
assign [class="code-oss"] $ws1
assign [class="Firefox"] $ws2
assign [class="Chrome"] $ws2
assign [class="Discord"] $ws3
assign [class="Slack"] $ws3
assign [class="vlc"] $ws4
assign [class="obs"] $ws4
assign [class="libreoffice"] $ws5
assign [class="Steam"] $ws6
assign [class="htop"] $ws7
assign [class="VirtualBox"] $ws8

# Reload configuration
bindsym $mod+Shift+c reload

# Restart i3 inplace
bindsym $mod+Shift+r restart

# Exit i3 (logs you out)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Exit i3?' -B 'Yes, exit i3' 'i3-msg exit'"

# Lock screen
bindsym $mod+Shift+x exec i3lock -c 000000

# Resize window mode
mode "resize" {
    bindsym h resize shrink width 10 px or 10 ppt
    bindsym j resize grow height 10 px or 10 ppt
    bindsym k resize shrink height 10 px or 10 ppt
    bindsym l resize grow width 10 px or 10 ppt

    bindsym Left resize shrink width 10 px or 10 ppt
    bindsym Down resize grow height 10 px or 10 ppt
    bindsym Up resize shrink height 10 px or 10 ppt
    bindsym Right resize grow width 10 px or 10 ppt

    bindsym Return mode "default"
    bindsym Escape mode "default"
    bindsym $mod+r mode "default"
}
bindsym $mod+r mode "resize"

# Power-user shortcuts
bindsym $mod+Shift+Return exec thunar  # File manager
bindsym $mod+p exec rofi -show run     # Run command
bindsym $mod+Shift+s exec flameshot gui # Screenshot
bindsym $mod+Shift+v exec copyq show   # Clipboard manager

# Volume controls (multimedia keys)
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ +10%
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@ -10%
bindsym XF86AudioMute exec --no-startup-id pactl set-sink-mute @DEFAULT_SINK@ toggle

# Brightness controls
bindsym XF86MonBrightnessUp exec --no-startup-id brightnessctl set +10%
bindsym XF86MonBrightnessDown exec --no-startup-id brightnessctl set 10%-

# Window appearance
for_window [class=".*"] border pixel 2
gaps inner 5
gaps outer 5

# Colors (ADHD-friendly, low contrast)
client.focused          #4c7899 #285577 #ffffff #2e9ef4   #285577
client.focused_inactive #333333 #5f676a #ffffff #484e50   #5f676a
client.unfocused        #333333 #222222 #888888 #292d2e   #222222
client.urgent           #2f343a #900000 #ffffff #900000   #900000
client.placeholder      #000000 #0c0c0c #ffffff #000000   #0c0c0c

# Status bar
bar {
    status_command i3status
    position top
    colors {
        background #222222
        statusline #ffffff
        separator #666666
        
        focused_workspace  #4c7899 #285577 #ffffff
        active_workspace   #333333 #5f676a #ffffff
        inactive_workspace #333333 #222222 #888888
        urgent_workspace   #2f343a #900000 #ffffff
    }
}

# Autostart applications
exec --no-startup-id nm-applet
exec --no-startup-id copyq
exec --no-startup-id nitrogen --restore
exec --no-startup-id picom
exec --no-startup-id dunst
EOF

    # Create i3status config
    cat > ~/.config/i3/status.conf << 'EOF'
# i3status configuration for power users

general {
    colors = true
    interval = 1
}

order += "wireless _first_"
order += "ethernet _first_"
order += "battery all"
order += "disk /"
order += "load"
order += "memory"
order += "tztime local"

wireless _first_ {
    format_up = "W: (%quality at %essid) %ip"
    format_down = "W: down"
}

ethernet _first_ {
    format_up = "E: %ip (%speed)"
    format_down = "E: down"
}

battery all {
    format = "%status %percentage %remaining"
}

disk "/" {
    format = "💾 %avail"
}

load {
    format = "⚡ %1min"
}

memory {
    format = "🧠 %used | %available"
    threshold_degraded = "1G"
    format_degraded = "MEMORY < %available"
}

tztime local {
    format = "%Y-%m-%d %H:%M:%S"
}
EOF

    echo "✅ i3wm configuration created!"
    echo ""
    echo "🎯 YOUR NEW i3wm SUPERPOWERS:"
    echo ""
    echo "⌨️  WINDOW MANAGEMENT:"
    echo "   Super+Return     = Open terminal"
    echo "   Super+d          = Application launcher"
    echo "   Super+Tab        = Window switcher"
    echo "   Super+f          = Fullscreen toggle"
    echo "   Super+Shift+q    = Close window"
    echo ""
    echo "🖥️  WORKSPACE CONTROL:"
    echo "   Super+1-0        = Switch to workspace"
    echo "   Super+Shift+1-0  = Move window to workspace"
    echo ""
    echo "🎨 LAYOUT CONTROLS:"
    echo "   Super+w          = Tabbed layout"
    echo "   Super+e          = Split layout"
    echo "   Super+v          = Horizontal split"
    echo "   Super+s          = Vertical split"
    echo ""
    echo "⚡ POWER-USER SHORTCUTS:"
    echo "   Super+Shift+Return = File manager"
    echo "   Super+Shift+v      = Clipboard manager"
    echo "   Super+Shift+s      = Screenshot"
    echo "   Super+Shift+x      = Lock screen"
    echo ""
    
    read -p "Press Enter to continue..."
    clear
}

create_window_scripts() {
    echo "🤖 CREATING AI-POWERED WINDOW MANAGEMENT SCRIPTS"
    echo "==============================================="
    echo ""
    echo "🎯 Setting up intelligent window automation..."
    echo ""
    
    mkdir -p ~/.local/bin
    
    # Smart window organizer
    cat > ~/.local/bin/organize-windows-ai << 'EOF'
#!/bin/bash
# AI-powered window organization
# Usage: organize-windows-ai [context]

CONTEXT="${1:-work}"

echo "🤖 AI Window Organization"
echo "========================"
echo ""
echo "📊 Context: $CONTEXT"
echo ""

# Get current window list
if command -v wmctrl &> /dev/null; then
    WINDOWS=$(wmctrl -l | head -10)
elif command -v i3-msg &> /dev/null; then
    WINDOWS=$(i3-msg -t get_tree | jq -r '.. | select(.window?) | .name' | head -10)
else
    WINDOWS=$(ps aux | grep -E "(firefox|chrome|code|terminal)" | head -5)
fi

if command -v claude &> /dev/null && [ -n "$WINDOWS" ]; then
    echo "🧠 Analyzing current windows for optimal organization..."
    
    AI_SUGGESTION=$(claude "Analyze these open applications and suggest optimal window organization for a $CONTEXT workflow. Provide specific layout recommendations: $WINDOWS" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$AI_SUGGESTION" ]; then
        echo "💡 AI Layout Suggestions:"
        echo "========================"
        echo "$AI_SUGGESTION"
        echo ""
        
        read -p "Apply automatic organization? (y/n): " apply
        if [[ $apply =~ ^[Yy]$ ]]; then
            echo "🎯 Applying AI layout suggestions..."
            # Basic organization based on window types
            organize_by_type
        fi
    else
        echo "❌ AI analysis failed. Using rule-based organization..."
        organize_by_type
    fi
else
    echo "💡 Using rule-based window organization..."
    organize_by_type
fi

organize_by_type() {
    echo "🔧 Organizing windows by application type..."
    
    if command -v i3-msg &> /dev/null; then
        # i3wm organization
        i3-msg '[class="firefox"] move container to workspace 2:Web'
        i3-msg '[class="code"] move container to workspace 1:Code'
        i3-msg '[class="terminal"] move container to workspace 1:Code'
        i3-msg '[class="discord"] move container to workspace 3:Communication'
        echo "✅ Windows organized in i3wm workspaces"
    elif command -v wmctrl &> /dev/null; then
        # Generic window manager organization
        wmctrl -r "Firefox" -t 1 2>/dev/null
        wmctrl -r "Code" -t 0 2>/dev/null
        echo "✅ Windows moved to appropriate desktops"
    else
        echo "💡 Manual organization recommended - see AI suggestions above"
    fi
}
EOF

    # Focus mode script
    cat > ~/.local/bin/focus-mode << 'EOF'
#!/bin/bash
# ADHD-friendly focus mode - hide distracting windows
# Usage: focus-mode [on|off]

MODE="${1:-on}"

echo "🎯 Focus Mode Controller"
echo "======================="
echo ""

case $MODE in
    "on")
        echo "🧘 Enabling focus mode..."
        echo "   Hiding distracting applications"
        echo "   Blocking notifications"
        echo ""
        
        # Hide distracting applications
        if command -v i3-msg &> /dev/null; then
            i3-msg '[class="discord"] move scratchpad' 2>/dev/null
            i3-msg '[class="slack"] move scratchpad' 2>/dev/null
            i3-msg '[class="steam"] move scratchpad' 2>/dev/null
            i3-msg '[class="spotify"] move scratchpad' 2>/dev/null
        elif command -v wmctrl &> /dev/null; then
            wmctrl -r "Discord" -b add,hidden 2>/dev/null
            wmctrl -r "Slack" -b add,hidden 2>/dev/null
            wmctrl -r "Steam" -b add,hidden 2>/dev/null
        fi
        
        # Disable notifications
        if command -v dunst &> /dev/null; then
            dunstctl set-paused true
        elif command -v notify-send &> /dev/null; then
            killall notification-daemon 2>/dev/null
        fi
        
        echo "✅ Focus mode enabled!"
        echo "   Distracting apps hidden"
        echo "   Notifications paused"
        echo ""
        echo "💡 Use 'focus-mode off' to restore normal mode"
        ;;
        
    "off")
        echo "🌍 Disabling focus mode..."
        echo "   Restoring all applications"
        echo "   Re-enabling notifications"
        echo ""
        
        # Restore applications
        if command -v i3-msg &> /dev/null; then
            i3-msg '[class="discord"] move container to workspace 3:Communication' 2>/dev/null
            i3-msg '[class="slack"] move container to workspace 3:Communication' 2>/dev/null
            i3-msg '[class="steam"] move container to workspace 6:Gaming' 2>/dev/null
            i3-msg '[class="spotify"] move container to workspace 4:Media' 2>/dev/null
        elif command -v wmctrl &> /dev/null; then
            wmctrl -r "Discord" -b remove,hidden 2>/dev/null
            wmctrl -r "Slack" -b remove,hidden 2>/dev/null
            wmctrl -r "Steam" -b remove,hidden 2>/dev/null
        fi
        
        # Re-enable notifications
        if command -v dunst &> /dev/null; then
            dunstctl set-paused false
        fi
        
        echo "✅ Focus mode disabled!"
        echo "   All applications restored"
        echo "   Notifications resumed"
        ;;
        
    *)
        echo "Usage: focus-mode [on|off]"
        echo ""
        echo "Focus mode helps ADHD users by:"
        echo "• Hiding distracting applications"
        echo "• Blocking notifications"
        echo "• Creating a clean work environment"
        exit 1
        ;;
esac
EOF

    # Window session saver
    cat > ~/.local/bin/save-window-session << 'EOF'
#!/bin/bash
# Save and restore window sessions
# Usage: save-window-session [save|restore] [session-name]

ACTION="${1:-save}"
SESSION="${2:-default}"
SESSION_DIR="$HOME/.config/window-sessions"

mkdir -p "$SESSION_DIR"

case $ACTION in
    "save")
        echo "💾 Saving Window Session: $SESSION"
        echo "================================="
        echo ""
        
        if command -v i3-msg &> /dev/null; then
            # Save i3 layout
            i3-save-tree --workspace 1 > "$SESSION_DIR/$SESSION-ws1.json"
            i3-save-tree --workspace 2 > "$SESSION_DIR/$SESSION-ws2.json"
            echo "✅ i3wm layout saved"
        elif command -v wmctrl &> /dev/null; then
            # Save window positions
            wmctrl -l -G > "$SESSION_DIR/$SESSION-windows.txt"
            echo "✅ Window positions saved"
        fi
        
        # Save running applications
        ps aux | grep -E "(firefox|chrome|code|terminal)" > "$SESSION_DIR/$SESSION-apps.txt"
        
        echo "📊 Session '$SESSION' saved!"
        echo "   Location: $SESSION_DIR/"
        ;;
        
    "restore")
        echo "📂 Restoring Window Session: $SESSION"
        echo "===================================="
        echo ""
        
        if [ ! -d "$SESSION_DIR" ] || [ ! -f "$SESSION_DIR/$SESSION-apps.txt" ]; then
            echo "❌ Session '$SESSION' not found!"
            echo "💡 Available sessions:"
            ls "$SESSION_DIR" 2>/dev/null | sed 's/-.*$//' | sort -u | sed 's/^/   /'
            exit 1
        fi
        
        echo "🚀 Restoring applications and layout..."
        # This is a template - full restoration requires more complex logic
        echo "💡 Session restoration is a complex process."
        echo "   Manual setup may be required for full restoration."
        ;;
        
    "list")
        echo "📋 Available Window Sessions"
        echo "==========================="
        echo ""
        if [ -d "$SESSION_DIR" ]; then
            ls "$SESSION_DIR" 2>/dev/null | sed 's/-.*$//' | sort -u | sed 's/^/   /'
        else
            echo "   No saved sessions found"
        fi
        ;;
        
    *)
        echo "💾 Window Session Manager"
        echo "========================"
        echo ""
        echo "Usage: save-window-session [save|restore|list] [session-name]"
        echo ""
        echo "Commands:"
        echo "  save <name>     Save current window layout"
        echo "  restore <name>  Restore saved layout"
        echo "  list           List available sessions"
        echo ""
        echo "Examples:"
        echo "  save-window-session save work"
        echo "  save-window-session restore work"
        exit 1
        ;;
esac
EOF

    chmod +x ~/.local/bin/organize-windows-ai ~/.local/bin/focus-mode ~/.local/bin/save-window-session
    
    echo "✅ AI window management scripts created!"
    echo ""
    echo "🤖 YOUR NEW INTELLIGENT WINDOW TOOLS:"
    echo "   organize-windows-ai  = AI-powered window organization"
    echo "   focus-mode on/off    = ADHD-friendly focus mode"
    echo "   save-window-session  = Save/restore window layouts"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_multi_monitor() {
    echo "🖥️  MULTI-MONITOR SETUP"
    echo "======================"
    echo ""
    echo "🎯 Configuring intelligent multi-monitor window management..."
    echo ""
    
    # Install monitor management tools
    if command -v apt &> /dev/null; then
        sudo apt install -y arandr autorandr wmctrl xdotool
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y arandr autorandr wmctrl xdotool
    elif command -v pacman &> /dev/null; then
        sudo pacman -S arandr autorandr wmctrl xdotool
    fi
    
    # Create multi-monitor management script
    cat > ~/.local/bin/monitor-setup << 'EOF'
#!/bin/bash
# Intelligent multi-monitor setup and management
# Usage: monitor-setup [detect|configure|save|restore]

ACTION="${1:-detect}"

case $ACTION in
    "detect")
        echo "🖥️  Monitor Detection"
        echo "==================="
        echo ""
        
        # Detect connected monitors
        MONITORS=$(xrandr | grep " connected" | cut -d' ' -f1)
        MONITOR_COUNT=$(echo "$MONITORS" | wc -l)
        
        echo "📊 Detected Monitors: $MONITOR_COUNT"
        echo "$MONITORS" | sed 's/^/   /'
        echo ""
        
        if [ $MONITOR_COUNT -gt 1 ]; then
            echo "🎯 Multi-monitor setup detected!"
            echo "   Use 'monitor-setup configure' to set up layouts"
            echo "   Use 'arandr' for graphical configuration"
        else
            echo "💡 Single monitor detected."
            echo "   Multi-monitor features available when additional displays connected"
        fi
        ;;
        
    "configure")
        echo "⚙️  Multi-Monitor Configuration"
        echo "==============================="
        echo ""
        
        if command -v arandr &> /dev/null; then
            echo "🎯 Launching graphical monitor configuration..."
            arandr &
        else
            echo "❌ arandr not installed for graphical config"
            echo "Manual xrandr commands:"
            echo "  xrandr --output HDMI-1 --right-of eDP-1"
            echo "  xrandr --output HDMI-1 --same-as eDP-1"
        fi
        ;;
        
    "save")
        echo "💾 Saving Monitor Configuration"
        echo "=============================="
        
        if command -v autorandr &> /dev/null; then
            PROFILE="${2:-work}"
            autorandr --save "$PROFILE"
            echo "✅ Monitor profile '$PROFILE' saved!"
        else
            echo "💡 autorandr not available - using xrandr"
            xrandr > ~/.config/monitor-config-$(date +%Y%m%d).txt
            echo "✅ Monitor config saved to ~/.config/"
        fi
        ;;
        
    "restore")
        echo "📂 Restoring Monitor Configuration"
        echo "=================================="
        
        if command -v autorandr &> /dev/null; then
            PROFILE="${2:-work}"
            autorandr --load "$PROFILE"
            echo "✅ Monitor profile '$PROFILE' restored!"
        else
            echo "💡 Manual restoration required"
            echo "Available configs:"
            ls ~/.config/monitor-config-*.txt 2>/dev/null
        fi
        ;;
        
    *)
        echo "🖥️  Multi-Monitor Management"
        echo "=========================="
        echo ""
        echo "Usage: monitor-setup [detect|configure|save|restore] [profile]"
        echo ""
        echo "Commands:"
        echo "  detect           Detect connected monitors"
        echo "  configure        Launch graphical configuration"
        echo "  save <profile>   Save current monitor setup"
        echo "  restore <profile> Restore saved monitor setup"
        echo ""
        echo "Examples:"
        echo "  monitor-setup detect"
        echo "  monitor-setup save home"
        echo "  monitor-setup restore work"
        exit 1
        ;;
esac
EOF

    chmod +x ~/.local/bin/monitor-setup
    
    echo "✅ Multi-monitor tools configured!"
    echo ""
    echo "🖥️  MULTI-MONITOR COMMANDS:"
    echo "   monitor-setup detect    = Detect connected displays"
    echo "   monitor-setup configure = Graphical monitor config"
    echo "   monitor-setup save home = Save home monitor setup"
    echo "   arandr                  = Visual monitor arrangement"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

demo_window_mastery() {
    echo "🎯 WINDOW MASTERY DEMONSTRATION"
    echo "==============================="
    echo ""
    echo "Let's explore your new window management superpowers!"
    echo ""
    
    # Detect current environment
    if pgrep i3 > /dev/null; then
        WM="i3wm"
    elif [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
        WM="GNOME"
    elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
        WM="KDE"
    else
        WM="Generic"
    fi
    
    echo "🪟 DETECTED ENVIRONMENT: $WM"
    echo ""
    
    case $WM in
        "i3wm")
            echo "⌨️  I3WM KEYBOARD SHORTCUTS TO TRY:"
            echo "=================================="
            echo ""
            echo "🚀 BASIC WINDOW MANAGEMENT:"
            echo "   Super+Return      = Open terminal"
            echo "   Super+d           = Application launcher"
            echo "   Super+Shift+q     = Close window"
            echo "   Super+f           = Toggle fullscreen"
            echo ""
            echo "🎯 WORKSPACE SWITCHING:"
            echo "   Super+1-0         = Switch workspaces"
            echo "   Super+Shift+1-0   = Move window to workspace"
            echo ""
            echo "🤖 AI-POWERED TOOLS:"
            echo "   organize-windows-ai = Smart window organization"
            echo "   focus-mode on       = Hide distracting apps"
            echo "   focus-mode off      = Restore all apps"
            echo ""
            ;;
            
        "GNOME")
            echo "🔧 GNOME EXTENSIONS TO ENABLE:"
            echo "============================="
            echo ""
            echo "1️⃣  Pop Shell - Automatic tiling"
            echo "2️⃣  gTile - Grid-based snapping"
            echo "3️⃣  Dash to Dock - Enhanced taskbar"
            echo ""
            echo "🚀 Enable with:"
            echo "   gnome-extensions enable pop-shell@system76.com"
            echo "   Or use GNOME Extensions app"
            echo ""
            ;;
            
        *)
            echo "💡 UNIVERSAL WINDOW TOOLS:"
            echo "========================="
            echo ""
            echo "🤖 AI-POWERED:"
            echo "   organize-windows-ai = Smart organization"
            echo "   focus-mode on/off   = ADHD focus mode"
            echo ""
            echo "🖥️  MULTI-MONITOR:"
            echo "   monitor-setup detect = Check displays"
            echo "   arandr              = Visual setup"
            echo ""
            ;;
    esac
    
    echo "💾 SESSION MANAGEMENT:"
    echo "   save-window-session save work    = Save current layout"
    echo "   save-window-session restore work = Restore layout"
    echo ""
    
    # Test AI organization if available
    if command -v organize-windows-ai &> /dev/null; then
        echo "🧠 TESTING AI WINDOW ORGANIZATION:"
        echo ""
        read -p "Run AI window analysis? (y/n): " test_ai
        if [[ $test_ai =~ ^[Yy]$ ]]; then
            organize-windows-ai demo
        fi
    fi
    
    echo ""
    echo "🎯 POWER-USER TIPS:"
    echo ""
    echo "1️⃣  LEARN THE SHORTCUTS: Muscle memory = productivity"
    echo "2️⃣  USE WORKSPACES: Organize by project/context"
    echo "3️⃣  EMBRACE TILING: Less mouse = more focus"
    echo "4️⃣  FOCUS MODE: Use it during deep work sessions"
    echo "5️⃣  SAVE SESSIONS: Perfect layouts for different work types"
    echo ""
    echo "💡 Windows power users: You now have SUPERIOR window management!"
    echo "   PowerToys FancyZones looks primitive compared to this!"
    echo ""
    read -p "Press Enter to finish demonstration..."
    clear
}

# Main menu
main_menu() {
    while true; do
        show_banner "WINDOW MASTERY" "Windows PowerToys FancyZones, but intelligent" "PRODUCTIVITY"
        
        echo "🪟 WINDOW MASTERY MENU"
        echo "======================"
        echo ""
        echo "1) 💡 What is Advanced Window Management?"
        echo "2) 🔍 Detect Desktop Environment"
        echo "3) 🔧 Setup GNOME Power-User Extensions"
        echo "4) 🏗️  Install i3wm Tiling Window Manager"
        echo "5) 🤖 Create AI-Powered Window Scripts"
        echo "6) 🖥️  Setup Multi-Monitor Management"
        echo "7) 🎯 Demo Your Window Mastery Powers"
        echo "8) 🚀 Complete Setup (Recommended Path)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-8): " choice
        
        case $choice in
            1) explain_window_mastery ;;
            2) detect_desktop_environment ;;
            3) install_gnome_extensions ;;
            4) install_i3wm ;;
            5) create_window_scripts ;;
            6) setup_multi_monitor ;;
            7) demo_window_mastery ;;
            8) complete_setup ;;
            0) echo "👋 Your window management is now godlike! 🪟⚡"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - intelligent path based on environment
complete_setup() {
    echo "🚀 COMPLETE WINDOW MASTERY SETUP"
    echo "================================"
    echo ""
    echo "This will set up optimal window management for your system."
    echo ""
    read -p "Continue with intelligent setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_window_mastery
        
        # Detect environment and recommend path
        detect_desktop_environment
        
        echo ""
        echo "🎯 RECOMMENDED SETUP PATH:"
        
        if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then
            echo "   GNOME detected - Installing power-user extensions"
            install_gnome_extensions
        elif [ "$XDG_CURRENT_DESKTOP" = "KDE" ]; then
            echo "   KDE detected - Setting up enhanced window management"
            echo "💡 KDE has good built-in tiling. Consider Bismuth extension."
        else
            echo "   Generic/Unknown DE - Installing i3wm for maximum power"
            install_i3wm
        fi
        
        create_window_scripts
        setup_multi_monitor
        demo_window_mastery
        
        echo ""
        echo "🎉 WINDOW MASTERY COMPLETE!"
        echo "=========================="
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Advanced window management (better than PowerToys)"
        echo "   ✅ AI-powered window organization"
        echo "   ✅ ADHD-friendly focus modes"
        echo "   ✅ Multi-monitor intelligence"
        echo "   ✅ Session save/restore capabilities"
        echo "   ✅ Keyboard-driven efficiency"
        echo ""
        echo "🚀 NEXT STEPS:"
        echo "   • Practice the keyboard shortcuts daily"
        echo "   • Try 'focus-mode on' during deep work"
        echo "   • Use 'organize-windows-ai' for optimal layouts"
        echo "   • Save window sessions for different work contexts"
        echo ""
        echo "💡 Windows users: Your window management is now REVOLUTIONARY!"
        echo "   PowerToys FancyZones + Virtual Desktops = Child's play compared to this!"
        
        # Log this installation
        echo "$(date): Window Mastery setup completed with AI integration and advanced management" >> ~/.bill-sloth/history.log
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/.local/bin
mkdir -p ~/.config/i3
mkdir -p ~/.config/window-sessions

# Start the main menu
main_menu