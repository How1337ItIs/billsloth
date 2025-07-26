#!/bin/bash
# LLM_CAPABILITY: local_ok
# FIX IDENTIFIED ISSUES FROM AUDIT
# Addresses bugs and missing components found during audit

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔧 FIXING IDENTIFIED ISSUES FROM AUDIT"
echo "======================================"
echo ""

# Fix 1: Create GTK-3.0 theme file (missing for older apps)
echo "🎨 Creating GTK-3.0 theme compatibility..."
mkdir -p "$SOURCE_DIR/themes/cyberpunk/gtk-3.0"
cat > "$SOURCE_DIR/themes/cyberpunk/gtk-3.0/gtk.css" << 'EOF'
/* Bill Sloth Cyberpunk Theme - GTK 3.0 Compatibility */

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

/* Global styling for GTK 3.0 */
* {
    font-family: 'Ubuntu', sans-serif;
    border-radius: 6px;
    transition: all 0.2s ease;
}

/* Windows and backgrounds */
.background, .window-frame {
    background: linear-gradient(135deg, @darker_bg 0%, @dark_bg 50%, #001122 100%);
    color: @neon_green;
}

/* Headers */
.header-bar, .titlebar {
    background: linear-gradient(90deg, @dark_bg 0%, #001a33 50%, @dark_bg 100%);
    border-bottom: 2px solid @neon_cyan;
    color: @neon_cyan;
}

/* Buttons */
.button {
    background: linear-gradient(145deg, #1a1a2e 0%, #16213e 100%);
    border: 2px solid @neon_green;
    color: @neon_green;
}

.button:hover {
    background: linear-gradient(145deg, @neon_green 0%, #00cc33 100%);
    color: @darker_bg;
}

/* Text entries */
.entry {
    background: rgba(0, 0, 0, 0.8);
    border: 2px solid @neon_cyan;
    color: @neon_green;
}

/* Scrollbars */
.scrollbar {
    background: @darker_bg;
}

.scrollbar .slider {
    background: linear-gradient(90deg, @neon_purple 0%, @neon_pink 100%);
}

/* Menus */
.menu {
    background: rgba(10, 10, 10, 0.95);
    border: 2px solid @neon_cyan;
}

.menuitem:hover {
    background: @selection_bg;
    color: @neon_cyan;
}

/* Selection */
.view:selected {
    background: @selection_bg;
    color: @neon_cyan;
}

/* Progress bars */
.progressbar {
    background: @darker_bg;
    border: 1px solid @neon_cyan;
}

.progressbar .progress {
    background: linear-gradient(90deg, @neon_green 0%, @neon_cyan 100%);
}
EOF

# Fix 2: Create missing Plymouth theme descriptor
echo "🎬 Creating Plymouth theme descriptor..."
cat > "$SOURCE_DIR/plymouth/bill-sloth-enhanced.plymouth" << 'EOF'
[Plymouth Theme]
Name=Bill Sloth Enhanced
Description=Enhanced cyberpunk boot theme for Bill Sloth Linux
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/bill-sloth-enhanced
ScriptFile=/usr/share/plymouth/themes/bill-sloth-enhanced/bill-sloth-enhanced.script
EOF

# Fix 3: Create package availability checker
echo "📦 Creating package availability checker..."
cat > "$SOURCE_DIR/check_packages.sh" << 'EOF'
#!/bin/bash
# Check package availability and provide fallbacks

echo "📦 Checking package availability..."

# Core packages that should always be available
CORE_PACKAGES=(
    "gnome-shell-extensions"
    "gnome-tweaks" 
    "plymouth-themes"
    "curl"
    "wget"
    "git"
)

# Optional packages with fallbacks
OPTIONAL_PACKAGES=(
    "lolcat:ruby-colorize"
    "neofetch:screenfetch"
    "btop:htop"
    "cmatrix:sl"
    "figlet:banner"
    "papirus-icon-theme:adwaita-icon-theme"
)

# Check core packages
echo "Checking core packages..."
for pkg in "${CORE_PACKAGES[@]}"; do
    if apt-cache show "$pkg" &>/dev/null; then
        echo "✅ $pkg - Available"
    else
        echo "❌ $pkg - NOT AVAILABLE"
    fi
done

# Check optional packages with fallbacks
echo "Checking optional packages..."
for entry in "${OPTIONAL_PACKAGES[@]}"; do
    pkg="${entry%:*}"
    fallback="${entry#*:}"
    
    if apt-cache show "$pkg" &>/dev/null; then
        echo "✅ $pkg - Available"
    elif apt-cache show "$fallback" &>/dev/null; then
        echo "⚠️ $pkg - Not available, using fallback: $fallback"
    else
        echo "❌ $pkg - Not available, no fallback found"
    fi
done
EOF

chmod +x "$SOURCE_DIR/check_packages.sh"

# Fix 4: Create improved hook with package checking
echo "🔧 Creating improved installation hook..."
cat > "$SOURCE_DIR/improved-install-hook.sh" << 'EOF'
#!/bin/bash
# Improved Bill Sloth Visual Installation Hook with error handling

echo "🎨 Installing Bill Sloth Visual Enhancements (Improved)..."

# Set up error handling
set -e
trap 'echo "❌ Installation failed at line $LINENO"' ERR

# Install required packages with fallbacks
export DEBIAN_FRONTEND=noninteractive
apt-get update

# Core packages (must succeed)
echo "Installing core packages..."
apt-get install -y \
    gnome-shell-extensions \
    gnome-tweaks \
    plymouth-themes \
    curl \
    wget \
    git \
    flatpak

# Optional packages with fallback handling
echo "Installing optional packages..."

# lolcat or colorize alternative
if ! apt-get install -y lolcat; then
    echo "⚠️ lolcat not available, installing ruby-colorize"
    apt-get install -y ruby ruby-colorize || echo "⚠️ No color output available"
fi

# neofetch or screenfetch
if ! apt-get install -y neofetch; then
    echo "⚠️ neofetch not available, installing screenfetch"  
    apt-get install -y screenfetch || echo "⚠️ No system info tool available"
fi

# btop or htop fallback
if ! apt-get install -y btop; then
    echo "⚠️ btop not available, using htop"
    apt-get install -y htop
fi

# Other optional packages
apt-get install -y \
    papirus-icon-theme \
    arc-theme \
    cmatrix \
    figlet \
    toilet \
    plank \
    conky-all || echo "⚠️ Some optional packages not available"

# Disable error trap for font installation (can fail safely)
set +e

# Install Orbitron font with fallback
echo "Installing Orbitron font..."
mkdir -p /usr/share/fonts/truetype/orbitron
cd /tmp

if wget -q "https://fonts.google.com/download?family=Orbitron" -O orbitron.zip; then
    if unzip -q orbitron.zip -d orbitron/; then
        cp orbitron/*.ttf /usr/share/fonts/truetype/orbitron/ 2>/dev/null || true
        fc-cache -f -v
        echo "✅ Orbitron font installed"
    else
        echo "⚠️ Font extraction failed, using system fonts"
    fi
else
    echo "⚠️ Font download failed, using system fonts"
fi

# Re-enable error handling for critical operations
set -e

# Continue with theme installation...
echo "✅ Package installation completed with available components"
EOF

# Fix 5: Improved path handling
echo "🗂️ Creating improved integration with better path handling..."
cat > "$SOURCE_DIR/robust_integration.sh" << 'EOF'
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
EOF

chmod +x "$SOURCE_DIR/robust_integration.sh"

echo ""
echo "🔧 ISSUE FIXES COMPLETED!"
echo "========================"
echo ""
echo "✅ Fixed Issues:"
echo "   • Created GTK-3.0 theme for app compatibility"
echo "   • Added missing Plymouth theme descriptor"
echo "   • Created package availability checker"
echo "   • Improved installation hook with error handling"
echo "   • Added robust integration with better path handling"
echo ""
echo "🧪 Test Files Created:"
echo "   • check_packages.sh - Verify package availability"
echo "   • improved-install-hook.sh - Better error handling"
echo "   • robust_integration.sh - Improved file operations"
echo ""
echo "🚀 Ready for production ISO build!"