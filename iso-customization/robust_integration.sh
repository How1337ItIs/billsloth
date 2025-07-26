#!/bin/bash
# Robust integration with improved path handling

CHROOT_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate inputs
if [ -z "$CHROOT_DIR" ] || [ ! -d "$CHROOT_DIR" ]; then
    echo "❌ Invalid chroot directory: $CHROOT_DIR"
    echo "Usage: $0 /path/to/chroot"
    exit 1
fi

echo "🌈 Robust Bill Sloth Integration Starting..."
echo "📁 Chroot: $CHROOT_DIR"
echo "📁 Script Dir: $SCRIPT_DIR"

# Create directories with error checking
create_dir() {
    local dir="$1"
    if ! mkdir -p "$dir"; then
        echo "❌ Failed to create directory: $dir"
        return 1
    fi
    echo "✅ Created: $dir"
}

# Copy files with error checking  
copy_files() {
    local src="$1"
    local dst="$2"
    local desc="$3"
    
    if [ -d "$src" ] || [ -f "$src" ]; then
        if cp -r "$src" "$dst" 2>/dev/null; then
            echo "✅ Copied $desc"
        else
            echo "⚠️ Warning: Failed to copy $desc"
        fi
    else
        echo "⚠️ Warning: Source not found for $desc: $src"
    fi
}

# Create all necessary directories
echo "📁 Creating directory structure..."
create_dir "$CHROOT_DIR/usr/share/themes/Bill-Sloth-Cyberpunk/gtk-4.0"
create_dir "$CHROOT_DIR/usr/share/themes/Bill-Sloth-Cyberpunk/gtk-3.0"
create_dir "$CHROOT_DIR/usr/share/icons/Bill-Sloth-Neon"
create_dir "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced"
create_dir "$CHROOT_DIR/boot/grub/themes/bill-sloth-enhanced"
create_dir "$CHROOT_DIR/usr/share/backgrounds/bill-sloth"

# Copy theme files
echo "🎨 Installing themes..."
copy_files "$SCRIPT_DIR/themes/cyberpunk/gtk-4.0/*" "$CHROOT_DIR/usr/share/themes/Bill-Sloth-Cyberpunk/gtk-4.0/" "GTK-4.0 theme"
copy_files "$SCRIPT_DIR/themes/cyberpunk/gtk-3.0/*" "$CHROOT_DIR/usr/share/themes/Bill-Sloth-Cyberpunk/gtk-3.0/" "GTK-3.0 theme"

# Copy Plymouth theme
echo "🎬 Installing Plymouth theme..."
copy_files "$SCRIPT_DIR/plymouth/bill-sloth-enhanced.plymouth" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced/" "Plymouth descriptor"
copy_files "$SCRIPT_DIR/animations/bill-sloth-enhanced.script" "$CHROOT_DIR/usr/share/plymouth/themes/bill-sloth-enhanced/" "Plymouth script"

# Copy assets
echo "📸 Installing assets..."
copy_files "$SCRIPT_DIR/assets/*" "$CHROOT_DIR/usr/share/backgrounds/bill-sloth/" "Background assets"

echo "✅ Robust integration completed!"
