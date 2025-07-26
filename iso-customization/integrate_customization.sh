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
