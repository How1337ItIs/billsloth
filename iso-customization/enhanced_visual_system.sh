#!/bin/bash
# LLM_CAPABILITY: local_ok
# ENHANCED BILL SLOTH VISUAL SYSTEM
# Creating a comprehensive cyberpunk/retro gaming aesthetic

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🌈 ENHANCING BILL SLOTH VISUAL SYSTEM"
echo "===================================="
echo ""

# Create advanced theme directories
mkdir -p "$SOURCE_DIR/themes/cyberpunk"
mkdir -p "$SOURCE_DIR/themes/retro-gaming"
mkdir -p "$SOURCE_DIR/animations"
mkdir -p "$SOURCE_DIR/sounds"
mkdir -p "$SOURCE_DIR/fonts"
mkdir -p "$SOURCE_DIR/icons"
mkdir -p "$SOURCE_DIR/cursors"

# Enhanced GTK4 Cyberpunk Theme
echo "🎮 Creating enhanced cyberpunk GTK theme..."
cat > "$SOURCE_DIR/themes/cyberpunk/gtk.css" << 'EOF'
/* Bill Sloth Cyberpunk Theme - Enhanced */
@import url('https://fonts.googleapis.com/css2?family=Orbitron:wght@400;700;900&display=swap');

/* Color Palette */
@define-color bg_color #0a0a0a;
@define-color fg_color #00ff41;
@define-color neon_green #00ff41;
@define-color neon_pink #ff0080;
@define-color neon_cyan #00ffff;
@define-color neon_purple #8000ff;
@define-color dark_bg #0d1117;
@define-color darker_bg #010409;
@define-color selection_bg #003d1a;
@define-color warning_color #ff6600;
@define-color error_color #ff0040;

/* Global styling */
* {
    font-family: 'Orbitron', 'Ubuntu Mono', monospace;
    border-radius: 8px;
    transition: all 0.3s cubic-bezier(0.4, 0.0, 0.2, 1);
}

/* Windows and containers */
.window, .background {
    background: linear-gradient(135deg, @darker_bg 0%, @dark_bg 50%, #001122 100%);
    color: @neon_green;
    box-shadow: 0 0 20px rgba(0, 255, 65, 0.1);
}

/* Headers and titlebars */
.titlebar, headerbar {
    background: linear-gradient(90deg, @dark_bg 0%, #001a33 50%, @dark_bg 100%);
    border-bottom: 2px solid @neon_cyan;
    box-shadow: 0 0 10px rgba(0, 255, 255, 0.3);
}

.titlebar .title {
    color: @neon_cyan;
    font-weight: 900;
    text-shadow: 0 0 10px currentColor;
}

/* Buttons with neon effects */
.button {
    background: linear-gradient(145deg, #1a1a2e 0%, #16213e 100%);
    border: 2px solid @neon_green;
    color: @neon_green;
    font-weight: 700;
    text-shadow: 0 0 5px currentColor;
    box-shadow: 
        0 0 10px rgba(0, 255, 65, 0.3),
        inset 0 1px 0 rgba(255, 255, 255, 0.1);
}

.button:hover {
    background: linear-gradient(145deg, @neon_green 0%, #00cc33 100%);
    color: @darker_bg;
    box-shadow: 
        0 0 20px rgba(0, 255, 65, 0.8),
        0 0 40px rgba(0, 255, 65, 0.4);
    transform: translateY(-2px);
}

.button:active {
    transform: translateY(0);
    box-shadow: 
        0 0 15px rgba(0, 255, 65, 0.6),
        inset 0 2px 4px rgba(0, 0, 0, 0.3);
}

/* Destructive buttons */
.button.destructive-action {
    border-color: @neon_pink;
    color: @neon_pink;
}

.button.destructive-action:hover {
    background: linear-gradient(145deg, @neon_pink 0%, #cc0066 100%);
    box-shadow: 
        0 0 20px rgba(255, 0, 128, 0.8),
        0 0 40px rgba(255, 0, 128, 0.4);
}

/* Text entries with glow */
.entry {
    background: rgba(0, 0, 0, 0.8);
    border: 2px solid @neon_cyan;
    color: @neon_green;
    box-shadow: 
        inset 0 0 10px rgba(0, 255, 255, 0.2),
        0 0 5px rgba(0, 255, 255, 0.3);
}

.entry:focus {
    border-color: @neon_green;
    box-shadow: 
        inset 0 0 15px rgba(0, 255, 65, 0.3),
        0 0 15px rgba(0, 255, 65, 0.5);
}

/* Scrollbars with neon styling */
scrollbar {
    background: @darker_bg;
    border-radius: 10px;
}

scrollbar slider {
    background: linear-gradient(90deg, @neon_purple 0%, @neon_pink 100%);
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(128, 0, 255, 0.5);
}

scrollbar slider:hover {
    box-shadow: 0 0 20px rgba(128, 0, 255, 0.8);
}

/* Menu styling */
.menu, .popup {
    background: rgba(10, 10, 10, 0.95);
    border: 2px solid @neon_cyan;
    box-shadow: 
        0 10px 30px rgba(0, 0, 0, 0.8),
        0 0 20px rgba(0, 255, 255, 0.3);
}

.menuitem {
    color: @neon_green;
    transition: all 0.2s ease;
}

.menuitem:hover {
    background: linear-gradient(90deg, @selection_bg 0%, rgba(0, 255, 65, 0.2) 100%);
    color: @neon_cyan;
    box-shadow: inset 0 0 10px rgba(0, 255, 65, 0.3);
}

/* Progress bars with animation */
.progressbar {
    background: @darker_bg;
    border: 1px solid @neon_cyan;
    border-radius: 15px;
}

.progressbar progress {
    background: linear-gradient(90deg, @neon_green 0%, @neon_cyan 50%, @neon_purple 100%);
    background-size: 200% 100%;
    animation: progress-glow 2s linear infinite;
    border-radius: 15px;
    box-shadow: 0 0 15px rgba(0, 255, 65, 0.6);
}

@keyframes progress-glow {
    0% { background-position: 200% 0; }
    100% { background-position: -200% 0; }
}

/* Notebook tabs */
.notebook tab {
    background: @dark_bg;
    border: 1px solid @neon_purple;
    color: @neon_green;
}

.notebook tab:checked {
    background: linear-gradient(180deg, @neon_purple 0%, @dark_bg 100%);
    color: @neon_cyan;
    box-shadow: 0 -3px 10px rgba(128, 0, 255, 0.5);
}

/* Tooltips */
.tooltip {
    background: rgba(0, 0, 0, 0.9);
    border: 1px solid @neon_green;
    color: @neon_cyan;
    box-shadow: 0 0 15px rgba(0, 255, 65, 0.4);
}

/* Selection highlighting */
:selected {
    background: linear-gradient(90deg, @selection_bg 0%, rgba(0, 255, 65, 0.3) 100%);
    color: @neon_cyan;
}

/* Links */
.link {
    color: @neon_cyan;
    text-decoration: none;
}

.link:hover {
    color: @neon_pink;
    text-shadow: 0 0 8px currentColor;
}

/* Switch controls */
.switch {
    border: 2px solid @neon_purple;
    background: @darker_bg;
}

.switch:checked {
    background: @neon_green;
    box-shadow: 0 0 15px rgba(0, 255, 65, 0.6);
}

.switch slider {
    background: @neon_cyan;
    box-shadow: 0 0 8px rgba(0, 255, 255, 0.5);
}
EOF

# Enhanced Plymouth Theme with Animation
echo "🎬 Creating enhanced Plymouth boot animation..."
cat > "$SOURCE_DIR/animations/bill-sloth-enhanced.script" << 'EOF'
# Enhanced Bill Sloth Plymouth Script with Matrix-style effects

# Set up the display
Window.SetBackgroundTopColor(0, 0, 0);
Window.SetBackgroundBottomColor(0.05, 0.05, 0.1);

# Matrix rain effect
for (i = 0; i < 50; i++) {
    rain[i].image = Image.Text("0123456789ABCDEF", 0, 1, 0, 1);
    rain[i].sprite = Sprite(rain[i].image);
    rain[i].x = Math.Random() * Window.GetWidth();
    rain[i].y = Math.Random() * Window.GetHeight() - Window.GetHeight();
    rain[i].speed = Math.Random() * 5 + 2;
}

# Main logo with glow effect
logo.image = Image("boot_logo.png");
logo.sprite = Sprite(logo.image);
logo.glow_image = Image("splash_screen_1.png");
logo.glow_sprite = Sprite(logo.glow_image);

# Text elements with cyberpunk styling
text.image = Image.Text("BILL SLOTH LINUX", 0, 1, 0, 1, "Orbitron");
text.sprite = Sprite(text.image);

subtext.image = Image.Text("AUTOMATION POWERHOUSE", 0, 0.8, 1, 1, "Ubuntu Mono");
subtext.sprite = Sprite(subtext.image);

# Animation variables
logo.pulse_angle = 0;
logo.float_angle = 0;
text.glow_angle = 0;
matrix.time = 0;

fun refresh_callback() {
    # Matrix rain animation
    matrix.time += 0.1;
    for (i = 0; i < 50; i++) {
        rain[i].y += rain[i].speed;
        if (rain[i].y > Window.GetHeight()) {
            rain[i].y = -20;
            rain[i].x = Math.Random() * Window.GetWidth();
        }
        
        # Fade effect based on position
        opacity = 1 - (rain[i].y / Window.GetHeight()) * 0.7;
        rain[i].sprite.SetOpacity(opacity * 0.3);
        rain[i].sprite.SetPosition(rain[i].x, rain[i].y);
    }
    
    # Logo pulsing and floating
    logo.pulse_angle += 0.08;
    logo.float_angle += 0.05;
    
    pulse_scale = 0.9 + Math.Sin(logo.pulse_angle) * 0.1;
    float_offset = Math.Sin(logo.float_angle) * 10;
    
    logo_x = Window.GetWidth() / 2 - logo.image.GetWidth() / 2;
    logo_y = Window.GetHeight() / 2 - logo.image.GetHeight() / 2 + float_offset;
    
    # Glow effect
    glow_opacity = 0.3 + Math.Sin(logo.pulse_angle * 2) * 0.2;
    logo.glow_sprite.SetOpacity(glow_opacity);
    logo.glow_sprite.SetPosition(logo_x - 10, logo_y - 10);
    
    # Main logo
    logo.sprite.SetPosition(logo_x, logo_y);
    
    # Text glow effect
    text.glow_angle += 0.1;
    text_glow = 0.7 + Math.Sin(text.glow_angle) * 0.3;
    text.sprite.SetOpacity(text_glow);
    text.sprite.SetPosition(Window.GetWidth() / 2 - text.image.GetWidth() / 2, 
                           logo_y + logo.image.GetHeight() + 40);
    
    # Subtext
    subtext.sprite.SetOpacity(0.8);
    subtext.sprite.SetPosition(Window.GetWidth() / 2 - subtext.image.GetWidth() / 2,
                              logo_y + logo.image.GetHeight() + 80);
}

Plymouth.SetRefreshFunction(refresh_callback);

# Password prompt styling
fun DisplayPasswordPrompt(prompt, bullets) {
    prompt_sprite = Sprite();
    prompt_sprite.SetPosition(Window.GetWidth() / 2 - 200, Window.GetHeight() * 0.75);
    
    password_image = Image.Text(prompt + ": " + bullets, 0, 1, 0, 1);
    prompt_sprite.SetImage(password_image);
}

Plymouth.SetDisplayPasswordFunction(DisplayPasswordPrompt);
EOF

# Enhanced GRUB theme with animations
echo "🔧 Creating enhanced GRUB theme..."
cat > "$SOURCE_DIR/grub/enhanced-theme.txt" << 'EOF'
# Enhanced Bill Sloth GRUB Theme

# Background and layout
desktop-image: "boot_logo.png"
desktop-color: "#000011"
title-text: "BILL SLOTH LINUX"
title-font: "Orbitron Bold 24"
title-color: "#00ff41"

# Boot menu styling
+ boot_menu {
    left = 15%
    top = 35%
    width = 70%
    height = 45%
    item_font = "Ubuntu Mono Bold 18"
    item_color = "#00ffff"
    selected_item_font = "Ubuntu Mono Bold 18"
    selected_item_color = "#000000"
    selected_item_pixmap_style = "menu_select_*.png"
    item_height = 35
    item_padding = 10
    item_spacing = 5
    item_icon_space = 2
    icon_width = 32
    icon_height = 32
    scrollbar = true
    scrollbar_width = 20
    scrollbar_thumb = "scrollbar_thumb_*.png"
}

# Progress bar for timeout
+ progress_bar {
    id = "__timeout__"
    left = 20%
    top = 85%
    width = 60%
    height = 20
    text = "@TIMEOUT_NOTIFICATION_LONG@"
    font = "Ubuntu Mono 14"
    text_color = "#00ff41"
    fg_color = "#00ffff"
    bg_color = "#001122"
    border_color = "#00ff41"
    highlight_style = "progress_highlight_*.png"
}

# Status text
+ label {
    top = 90%
    left = 0
    width = 100%
    height = 30
    text = "Bill Sloth Linux - Where Automation Meets Artistry"
    color = "#ff0080"
    font = "Ubuntu 16"
    align = "center"
}

# System info display
+ label {
    id = "__version__"
    top = 5%
    right = 5%
    color = "#00ffff"
    font = "Ubuntu Mono 12"
    align = "right"
}
EOF

# Enhanced desktop configuration with advanced effects
echo "🖥️ Creating enhanced desktop configuration..."
cat > "$SOURCE_DIR/enhanced-desktop.conf" << 'EOF'
# Enhanced Bill Sloth Desktop Configuration

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
picture-uri-dark='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
primary-color='#000011'
secondary-color='#00ff41'
picture-options='zoom'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/bill-sloth/lock_background.png'
primary-color='#000011'
secondary-color='#00ffff'
lock-delay=300

[org/gnome/desktop/interface]
gtk-theme='Bill-Sloth-Cyberpunk'
icon-theme='Bill-Sloth-Neon'
cursor-theme='Bill-Sloth-Glow'
font-name='Orbitron 11'
document-font-name='Ubuntu 11'
monospace-font-name='Ubuntu Mono 13'
color-scheme='prefer-dark'
enable-animations=true

[org/gnome/desktop/wm/preferences]
titlebar-font='Orbitron Bold 11'
theme='Bill-Sloth-Cyberpunk'
button-layout='close,minimize,maximize:'
action-double-click-titlebar='toggle-maximize'

[org/gnome/shell]
favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'bill-sloth-command-center.desktop', 'code.desktop']
enable-extensions=['dash-to-dock@micxgx.gmail.com', 'blur-my-shell@aunetx']

[org/gnome/shell/extensions/dash-to-dock]
dock-position='BOTTOM'
transparency-mode='DYNAMIC'
custom-background-color=true
background-color='#000011'
border-color='#00ff41'
dash-max-icon-size=48
show-apps-at-top=false

[org/gnome/terminal/legacy/profiles:/:default]
background-color='#000011'
foreground-color='#00ff41'
palette=['#000000:#ff0040:#00ff41:#ffff00:#0080ff:#ff0080:#00ffff:#ffffff:#808080:#ff0040:#00ff41:#ffff00:#0080ff:#ff0080:#00ffff:#ffffff']
use-theme-colors=false
use-transparent-background=true
background-transparency-percent=10

[org/gnome/nautilus/preferences]
default-folder-viewer='list-view'
show-hidden-files=true

[org/gnome/settings-daemon/plugins/color]
night-light-enabled=false

[org/gnome/desktop/notifications]
show-in-lock-screen=false

[org/gnome/desktop/privacy]
disable-microphone=false
disable-camera=false
remember-recent-files=true

[org/gnome/mutter]
dynamic-workspaces=true
workspaces-only-on-primary=false
edge-tiling=true
attach-modal-dialogs=false
EOF

# Create icon theme metadata
echo "🎨 Creating enhanced icon theme..."
cat > "$SOURCE_DIR/icons/bill-sloth-neon.theme" << 'EOF'
[Icon Theme]
Name=Bill Sloth Neon
Comment=Cyberpunk neon icon theme for Bill Sloth Linux
Inherits=Papirus-Dark,Adwaita
Example=folder
Directories=16x16/apps,22x22/apps,24x24/apps,32x32/apps,48x48/apps,64x64/apps

[16x16/apps]
Size=16
Context=Applications
Type=Fixed

[22x22/apps]
Size=22
Context=Applications
Type=Fixed

[24x24/apps]
Size=24
Context=Applications
Type=Fixed

[32x32/apps]
Size=32
Context=Applications
Type=Fixed

[48x48/apps]
Size=48
Context=Applications
Type=Fixed

[64x64/apps]
Size=64
Context=Applications
Type=Fixed
EOF

# Create sound theme
echo "🎵 Creating enhanced sound theme..."
cat > "$SOURCE_DIR/sounds/bill-sloth-cyberpunk.xml" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE sound_theme PUBLIC "-//freedesktop//DTD sound theme//EN" "sound-theme.dtd">
<sound_theme>
  <_name>Bill Sloth Cyberpunk</_name>
  <_description>Cyberpunk sound theme for Bill Sloth Linux</_description>
  <inherits>freedesktop</inherits>
  <directory>.</directory>
  
  <sound id="desktop-login" type="notification">
    <_description>Login sound</_description>
    <filename>login-cyberpunk.ogg</filename>
  </sound>
  
  <sound id="desktop-logout" type="notification">
    <_description>Logout sound</_description>
    <filename>logout-cyberpunk.ogg</filename>
  </sound>
  
  <sound id="bell-terminal" type="notification">
    <_description>Terminal bell</_description>
    <filename>terminal-bell-neon.ogg</filename>
  </sound>
</sound_theme>
EOF

# Enhanced integration script
echo "🔗 Creating enhanced integration script..."
cat > "$SOURCE_DIR/integrate_enhanced_customization.sh" << 'EOF'
#!/bin/bash
# Enhanced Bill Sloth Customization Integration

CHROOT_DIR="$1"
CUSTOM_DIR="$(dirname "$0")"

if [ ! -d "$CHROOT_DIR" ]; then
    echo "❌ Chroot directory not found: $CHROOT_DIR"
    exit 1
fi

echo "🌈 Integrating Enhanced Bill Sloth Visual System..."

# Create all necessary directories
mkdir -p "$CHROOT_DIR/usr/share/themes/Bill-Sloth-Cyberpunk/gtk-4.0"
mkdir -p "$CHROOT_DIR/usr/share/icons/Bill-Sloth-Neon"
mkdir -p "$CHROOT_DIR/usr/share/sounds/Bill-Sloth-Cyberpunk"
mkdir -p "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced"
mkdir -p "$CHROOT_DIR/boot/grub/themes/bill-sloth-enhanced"
mkdir -p "$CHROOT_DIR/usr/share/backgrounds/bill-sloth"
mkdir -p "$CHROOT_DIR/usr/share/fonts/truetype/orbitron"
mkdir -p "$CHROOT_DIR/etc/skel/.config/dconf"
mkdir -p "$CHROOT_DIR/etc/skel/.local/share/themes"

# Copy enhanced themes
cp "$CUSTOM_DIR/themes/cyberpunk/gtk.css" "$CHROOT_DIR/usr/share/themes/Bill-Sloth-Cyberpunk/gtk-4.0/"
cp "$CUSTOM_DIR/icons/bill-sloth-neon.theme" "$CHROOT_DIR/usr/share/icons/Bill-Sloth-Neon/index.theme"
cp "$CUSTOM_DIR/sounds/bill-sloth-cyberpunk.xml" "$CHROOT_DIR/usr/share/sounds/Bill-Sloth-Cyberpunk/index.theme"

# Copy enhanced Plymouth theme
cp "$CUSTOM_DIR/animations/bill-sloth-enhanced.script" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced/"
cp "$CUSTOM_DIR/assets/boot_logo.png" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced/"
cp "$CUSTOM_DIR/assets/splash_screen_1.png" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced/"

# Copy enhanced GRUB theme
cp "$CUSTOM_DIR/grub/enhanced-theme.txt" "$CHROOT_DIR/boot/grub/themes/bill-sloth-enhanced/theme.txt"
cp "$CUSTOM_DIR/assets/boot_logo.png" "$CHROOT_DIR/boot/grub/themes/bill-sloth-enhanced/"

# Copy all backgrounds and assets
cp "$CUSTOM_DIR/assets"/*.png "$CHROOT_DIR/usr/share/backgrounds/bill-sloth/" 2>/dev/null || true
cp "$CUSTOM_DIR/assets"/*.jpeg "$CHROOT_DIR/usr/share/backgrounds/bill-sloth/" 2>/dev/null || true

# Set enhanced desktop configuration
cp "$CUSTOM_DIR/enhanced-desktop.conf" "$CHROOT_DIR/etc/skel/.config/dconf/bill-sloth-enhanced-settings"

# Install additional packages for enhanced experience
cat >> "$CHROOT_DIR/tmp/enhanced-packages.sh" << 'ENHANCED_EOF'
#!/bin/bash
# Enhanced packages installation
apt update
apt install -y \
    gnome-shell-extensions \
    gnome-tweaks \
    plymouth-themes \
    fonts-orbitron \
    papirus-icon-theme \
    arc-theme \
    numix-gtk-theme \
    plank \
    conky-all \
    lolcat \
    neofetch \
    htop \
    btop \
    cmatrix \
    figlet \
    toilet

# Enable Plymouth theme
plymouth-set-default-theme bill-sloth-enhanced
update-initramfs -u

# Set GRUB theme
echo 'GRUB_THEME="/boot/grub/themes/bill-sloth-enhanced/theme.txt"' >> /etc/default/grub
update-grub
ENHANCED_EOF

chmod +x "$CHROOT_DIR/tmp/enhanced-packages.sh"

# Create startup script for enhanced effects
cat > "$CHROOT_DIR/etc/skel/.config/autostart/bill-sloth-effects.desktop" << 'DESKTOP_EOF'
[Desktop Entry]
Type=Application
Name=Bill Sloth Visual Effects
Comment=Start Bill Sloth visual enhancements
Exec=/usr/local/bin/bill-sloth-startup-effects.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
DESKTOP_EOF

cat > "$CHROOT_DIR/usr/local/bin/bill-sloth-startup-effects.sh" << 'EFFECTS_EOF'
#!/bin/bash
# Bill Sloth Startup Visual Effects

# Set wallpaper with smooth transition
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/bill-sloth/wallpaper.png'

# Apply enhanced theme
gsettings set org.gnome.desktop.interface gtk-theme 'Bill-Sloth-Cyberpunk'
gsettings set org.gnome.desktop.interface icon-theme 'Bill-Sloth-Neon'

# Terminal welcome message
echo "Welcome to Bill Sloth Linux!" | lolcat

# Show system info with style
neofetch --ascii_distro bill_sloth
EFFECTS_EOF

chmod +x "$CHROOT_DIR/usr/local/bin/bill-sloth-startup-effects.sh"

echo "✅ Enhanced Bill Sloth visual system integrated!"
echo "🎨 Cyberpunk theme applied"
echo "🌈 Visual effects enabled"
echo "🎬 Enhanced boot animation configured"
echo "🔧 Advanced GRUB theme installed"
EOF

chmod +x "$SOURCE_DIR/integrate_enhanced_customization.sh"

echo ""
echo "🌈 ENHANCED VISUAL SYSTEM COMPLETE!"
echo "=================================="
echo ""
echo "🎮 Enhanced Features Added:"
echo "   • Cyberpunk GTK4 theme with neon effects"
echo "   • Matrix-style Plymouth boot animation"
echo "   • Advanced GRUB theme with progress bars"
echo "   • Neon icon theme"
echo "   • Cyberpunk sound theme"
echo "   • Visual effects startup script"
echo "   • Enhanced desktop configuration"
echo ""
echo "🔧 Integration: ./integrate_enhanced_customization.sh /path/to/chroot"
echo ""
echo "✨ The aesthetic is now fully cyberpunk/retro gaming enhanced!"