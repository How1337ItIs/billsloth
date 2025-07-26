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
