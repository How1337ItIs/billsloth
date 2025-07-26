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
