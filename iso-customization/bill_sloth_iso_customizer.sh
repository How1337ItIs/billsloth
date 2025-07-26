#!/bin/bash
# LLM_CAPABILITY: local_ok
# BILL SLOTH ISO CUSTOMIZATION SYSTEM
# Integrates all custom imagery and branding into the ISO build process

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SOURCE_DIR")"

echo "🎨 BILL SLOTH ISO CUSTOMIZATION SYSTEM"
echo "======================================="
echo ""

# Create customization directories
mkdir -p "$PROJECT_ROOT/iso-customization/assets"
mkdir -p "$PROJECT_ROOT/iso-customization/themes"
mkdir -p "$PROJECT_ROOT/iso-customization/grub"
mkdir -p "$PROJECT_ROOT/iso-customization/plymouth"

# Copy and organize all Bill Sloth imagery
echo "📸 Organizing Bill Sloth imagery..."

# Main wallpaper
cp "$PROJECT_ROOT/slothpaper.png" "$PROJECT_ROOT/iso-customization/assets/wallpaper.png"

# Logo and branding
cp "$PROJECT_ROOT/billsloth_about_logo.png" "$PROJECT_ROOT/iso-customization/assets/logo.png"
cp "$PROJECT_ROOT/billsloth_folder_icon.png" "$PROJECT_ROOT/iso-customization/assets/folder_icon.png"
cp "$PROJECT_ROOT/billsloth_lock_bg.png" "$PROJECT_ROOT/iso-customization/assets/lock_background.png"
cp "$PROJECT_ROOT/billsloth_slideshow_slide5.png" "$PROJECT_ROOT/iso-customization/assets/slideshow_slide.png"
cp "$PROJECT_ROOT/bill-slothman.jpeg" "$PROJECT_ROOT/iso-customization/assets/character.jpeg"

# ChatGPT generated images
cp "$PROJECT_ROOT/ChatGPT Image Jul 26, 2025, 02_38_08 AM.png" "$PROJECT_ROOT/iso-customization/assets/splash_screen_1.png"
cp "$PROJECT_ROOT/ChatGPT Image Jul 26, 2025, 02_38_16 AM.png" "$PROJECT_ROOT/iso-customization/assets/splash_screen_2.png"
cp "$PROJECT_ROOT/ChatGPT Image Jul 26, 2025, 02_42_19 AM.png" "$PROJECT_ROOT/iso-customization/assets/boot_logo.png"

echo "✅ Imagery organized in iso-customization/assets/"
echo ""

# Create GRUB theme
echo "🔧 Creating GRUB boot theme..."
cat > "$PROJECT_ROOT/iso-customization/grub/theme.txt" << 'EOF'
# Bill Sloth GRUB Theme
desktop-image: "boot_logo.png"
title-color: "#00ff00"
title-font: "Unifont Regular 16"
terminal-font: "Unifont Regular 16"
terminal-box: "terminal_box_*.png"

+ boot_menu {
  left = 20%
  top = 30%
  width = 60%
  height = 40%
  item_font = "Unifont Regular 16"
  item_color = "#cccccc"
  selected_item_color = "#ffffff"
  selected_item_pixmap_style = "select_*.png"
  item_height = 25
  item_padding = 5
  item_spacing = 10
  icon_width = 24
  icon_height = 24
}

+ label {
  top = 82%
  left = 0
  width = 100%
  height = 20
  text = "Bill Sloth Linux - The Automation Powerhouse"
  color = "#00ff00"
  font = "Unifont Regular 14"
  align = "center"
}
EOF

# Create Plymouth boot animation theme
echo "🎬 Creating Plymouth boot animation..."
cat > "$PROJECT_ROOT/iso-customization/plymouth/bill-sloth.plymouth" << 'EOF'
[Plymouth Theme]
Name=Bill Sloth
Description=Bill Sloth custom boot theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/bill-sloth
ScriptFile=/usr/share/plymouth/themes/bill-sloth/bill-sloth.script
EOF

cat > "$PROJECT_ROOT/iso-customization/plymouth/bill-sloth.script" << 'EOF'
# Bill Sloth Plymouth Script
Window.SetBackgroundTopColor(0, 0, 0);
Window.SetBackgroundBottomColor(0, 0, 0);

logo.image = Image("splash_screen_1.png");
logo.sprite = Sprite(logo.image);
logo.opacity_angle = 0;

fun refresh_callback ()
{
    # Fade in/out animation
    logo.opacity_angle += 0.1;
    opacity = Math.Sin(logo.opacity_angle) * 0.5 + 0.5;
    logo.sprite.SetOpacity(opacity);
    
    # Center the logo
    logo.sprite.SetPosition(Window.GetWidth() / 2 - logo.image.GetWidth() / 2,
                           Window.GetHeight() / 2 - logo.image.GetHeight() / 2);
}

Plymouth.SetRefreshFunction (refresh_callback);
EOF

# Create GTK theme customization
echo "🎨 Creating GTK theme customization..."
cat > "$PROJECT_ROOT/iso-customization/themes/bill-sloth-theme.css" << 'EOF'
/* Bill Sloth GTK Theme */
@define-color bg_color #1a1a1a;
@define-color fg_color #00ff00;
@define-color base_color #2a2a2a;
@define-color text_color #ffffff;
@define-color selected_bg_color #00aa00;
@define-color selected_fg_color #ffffff;
@define-color tooltip_bg_color #333333;
@define-color tooltip_fg_color #ffffff;

/* Window styling */
.window {
    background-color: @bg_color;
    color: @fg_color;
}

/* Button styling */
.button {
    background: linear-gradient(to bottom, #333333, #222222);
    border: 1px solid #00ff00;
    border-radius: 3px;
    color: @fg_color;
}

.button:hover {
    background: linear-gradient(to bottom, #00aa00, #008800);
    color: #ffffff;
}

/* Menu styling */
.menu {
    background-color: @bg_color;
    border: 1px solid #00ff00;
}

.menuitem:hover {
    background-color: @selected_bg_color;
    color: @selected_fg_color;
}
EOF

# Create desktop configuration
echo "🖥️ Creating desktop configuration..."
cat > "$PROJECT_ROOT/iso-customization/bill-sloth-desktop.conf" << 'EOF'
# Bill Sloth Desktop Configuration

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
picture-uri-dark='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
primary-color='#000000'
secondary-color='#00ff00'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/bill-sloth/lock_background.png'
primary-color='#000000'
secondary-color='#00ff00'

[org/gnome/desktop/interface]
gtk-theme='Bill-Sloth'
icon-theme='Bill-Sloth-Icons'
cursor-theme='DMZ-White'
font-name='Ubuntu 11'
document-font-name='Ubuntu 11'
monospace-font-name='Ubuntu Mono 13'

[org/gnome/shell]
favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'bill-sloth-command-center.desktop']

[org/gnome/desktop/wm/preferences]
titlebar-font='Ubuntu Bold 11'
theme='Bill-Sloth'
EOF

# Create live-build integration script
echo "🔗 Creating live-build integration..."
cat > "$PROJECT_ROOT/iso-customization/integrate_customization.sh" << 'EOF'
#!/bin/bash
# Integrate Bill Sloth customization into live-build

CHROOT_DIR="$1"
ASSETS_DIR="$(dirname "$0")/assets"

if [ ! -d "$CHROOT_DIR" ]; then
    echo "❌ Chroot directory not found: $CHROOT_DIR"
    exit 1
fi

echo "🎨 Integrating Bill Sloth customization into live system..."

# Create directories
mkdir -p "$CHROOT_DIR/usr/share/backgrounds/bill-sloth"
mkdir -p "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth"
mkdir -p "$CHROOT_DIR/boot/grub/themes/bill-sloth"
mkdir -p "$CHROOT_DIR/usr/share/icons/bill-sloth"
mkdir -p "$CHROOT_DIR/etc/skel/.config/dconf"

# Copy wallpapers and backgrounds
cp "$ASSETS_DIR"/*.png "$CHROOT_DIR/usr/share/backgrounds/bill-sloth/"
cp "$ASSETS_DIR"/*.jpeg "$CHROOT_DIR/usr/share/backgrounds/bill-sloth/"

# Copy Plymouth theme
cp "$(dirname "$0")/plymouth/bill-sloth.plymouth" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth/"
cp "$(dirname "$0")/plymouth/bill-sloth.script" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth/"
cp "$ASSETS_DIR/splash_screen_1.png" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth/"

# Copy GRUB theme
cp "$(dirname "$0")/grub/theme.txt" "$CHROOT_DIR/boot/grub/themes/bill-sloth/"
cp "$ASSETS_DIR/boot_logo.png" "$CHROOT_DIR/boot/grub/themes/bill-sloth/"

# Copy desktop configuration
cp "$(dirname "$0")/bill-sloth-desktop.conf" "$CHROOT_DIR/etc/skel/.config/dconf/bill-sloth-settings"

# Set default Plymouth theme
echo "bill-sloth" > "$CHROOT_DIR/etc/plymouth/plymouthd.conf.d/bill-sloth.conf"

# Create desktop entry for Bill Sloth Command Center
cat > "$CHROOT_DIR/usr/share/applications/bill-sloth-command-center.desktop" << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Bill Sloth Command Center
Comment=Launch the Bill Sloth automation system
Icon=/usr/share/backgrounds/bill-sloth/logo.png
Exec=/usr/local/bin/bill_command_center.sh
Terminal=true
Categories=System;Utility;
StartupNotify=true
DESKTOP_EOF

echo "✅ Bill Sloth customization integrated!"
EOF

chmod +x "$PROJECT_ROOT/iso-customization/integrate_customization.sh"

# Create Windows integration script for live-build
echo "🪟 Creating Windows live-build integration..."
cat > "$PROJECT_ROOT/iso-customization/windows_integration.ps1" << 'EOF'
# Windows Integration for Bill Sloth ISO Customization
param(
    [Parameter(Mandatory=$true)]
    [string]$ChRootPath
)

Write-Host "🎨 Integrating Bill Sloth customization via WSL..." -ForegroundColor Green

$AssetsPath = Split-Path $MyInvocation.MyCommand.Path -Parent | Join-Path -ChildPath "assets"
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path -Parent | Join-Path -ChildPath "integrate_customization.sh"

# Convert Windows path to WSL path
$WSLChRootPath = $ChRootPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
$WSLScriptPath = $ScriptPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

# Run integration script in WSL
wsl -d Ubuntu-22.04 bash -c "chmod +x '$WSLScriptPath' && '$WSLScriptPath' '$WSLChRootPath'"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Bill Sloth customization integrated successfully!" -ForegroundColor Green
} else {
    Write-Host "❌ Integration failed with exit code: $LASTEXITCODE" -ForegroundColor Red
}
EOF

echo ""
echo "🎉 BILL SLOTH ISO CUSTOMIZATION COMPLETE!"
echo "========================================"
echo ""
echo "📁 Assets organized in: iso-customization/assets/"
echo "🔧 GRUB theme: iso-customization/grub/"
echo "🎬 Plymouth theme: iso-customization/plymouth/"
echo "🎨 GTK theme: iso-customization/themes/"
echo ""
echo "🔗 Integration scripts created:"
echo "   • integrate_customization.sh (Linux)"
echo "   • windows_integration.ps1 (Windows)"
echo ""
echo "📝 To integrate into live-build:"
echo "   Linux: ./iso-customization/integrate_customization.sh /path/to/chroot"
echo "   Windows: powershell ./iso-customization/windows_integration.ps1 -ChRootPath 'C:\\path\\to\\chroot'"
echo ""
echo "🎯 All Bill Sloth imagery is now ready for ISO integration!"