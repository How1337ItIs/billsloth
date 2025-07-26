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
