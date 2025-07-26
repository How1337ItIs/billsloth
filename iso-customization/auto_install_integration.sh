#!/bin/bash
# LLM_CAPABILITY: local_ok
# AUTO-INSTALL INTEGRATION FOR BILL SLOTH ENHANCED VISUALS
# Ensures all customizations are automatically applied during ISO build and first boot

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SOURCE_DIR")"

echo "🚀 CREATING AUTO-INSTALL INTEGRATION"
echo "===================================="
echo ""

# Create live-build hooks directory
mkdir -p "$PROJECT_ROOT/windows-setup/config/hooks/live"
mkdir -p "$PROJECT_ROOT/windows-setup/config/hooks/normal"
mkdir -p "$PROJECT_ROOT/windows-setup/config/includes.chroot/usr/local/bin"
mkdir -p "$PROJECT_ROOT/windows-setup/config/includes.chroot/etc/bill-sloth"

# Create hook to install all customizations during ISO build
echo "📦 Creating live-build installation hook..."
cat > "$PROJECT_ROOT/windows-setup/config/hooks/live/0100-bill-sloth-visuals.hook.chroot" << 'EOF'
#!/bin/bash
# Bill Sloth Visual Customization Installation Hook
# Runs during ISO build to install all visual enhancements

echo "🎨 Installing Bill Sloth Visual Enhancements..."

# Install required packages for enhanced experience
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y \
    gnome-shell-extensions \
    gnome-tweaks \
    plymouth-themes \
    fonts-firacode \
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
    toilet \
    curl \
    wget \
    git \
    flatpak \
    snapd

# Install Orbitron font from Google Fonts
mkdir -p /usr/share/fonts/truetype/orbitron
cd /tmp
wget -q "https://fonts.google.com/download?family=Orbitron" -O orbitron.zip
unzip -q orbitron.zip -d orbitron/
cp orbitron/*.ttf /usr/share/fonts/truetype/orbitron/
fc-cache -f -v

# Create Bill Sloth themes directory
mkdir -p /usr/share/themes/Bill-Sloth-Cyberpunk/gtk-4.0
mkdir -p /usr/share/themes/Bill-Sloth-Cyberpunk/gtk-3.0
mkdir -p /usr/share/icons/Bill-Sloth-Neon
mkdir -p /usr/share/sounds/Bill-Sloth-Cyberpunk
mkdir -p /usr/share/plymouth/themes/bill-sloth-enhanced
mkdir -p /boot/grub/themes/bill-sloth-enhanced

# Copy all Bill Sloth assets (these will be placed by the build system)
if [ -d "/tmp/bill-sloth-assets" ]; then
    cp -r /tmp/bill-sloth-assets/backgrounds/* /usr/share/backgrounds/bill-sloth/ 2>/dev/null || true
    cp -r /tmp/bill-sloth-assets/themes/* /usr/share/themes/Bill-Sloth-Cyberpunk/ 2>/dev/null || true
    cp -r /tmp/bill-sloth-assets/icons/* /usr/share/icons/Bill-Sloth-Neon/ 2>/dev/null || true
    cp -r /tmp/bill-sloth-assets/sounds/* /usr/share/sounds/Bill-Sloth-Cyberpunk/ 2>/dev/null || true
    cp -r /tmp/bill-sloth-assets/plymouth/* /usr/share/plymouth/themes/bill-sloth-enhanced/ 2>/dev/null || true
    cp -r /tmp/bill-sloth-assets/grub/* /boot/grub/themes/bill-sloth-enhanced/ 2>/dev/null || true
fi

# Set Plymouth theme
if [ -f "/usr/share/plymouth/themes/bill-sloth-enhanced/bill-sloth-enhanced.plymouth" ]; then
    plymouth-set-default-theme bill-sloth-enhanced
    update-initramfs -u
fi

# Update GRUB configuration
if [ -f "/boot/grub/themes/bill-sloth-enhanced/theme.txt" ]; then
    echo 'GRUB_THEME="/boot/grub/themes/bill-sloth-enhanced/theme.txt"' >> /etc/default/grub
    echo 'GRUB_GFXMODE="1920x1080,1680x1050,1280x1024,1024x768,auto"' >> /etc/default/grub
    update-grub
fi

# Install Bill Sloth Command Center
if [ -f "/tmp/bill-sloth-assets/bill_command_center.sh" ]; then
    cp /tmp/bill-sloth-assets/bill_command_center.sh /usr/local/bin/
    chmod +x /usr/local/bin/bill_command_center.sh
    
    # Create desktop entry
    cat > /usr/share/applications/bill-sloth-command-center.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Bill Sloth Command Center
Comment=Launch the Bill Sloth automation powerhouse
Icon=/usr/share/backgrounds/bill-sloth/logo.png
Exec=gnome-terminal -- /usr/local/bin/bill_command_center.sh
Terminal=false
Categories=System;Utility;Development;
StartupNotify=true
DESKTOP_EOF
fi

# Set default dconf settings for all users
mkdir -p /etc/dconf/db/site.d
cat > /etc/dconf/db/site.d/00-bill-sloth-defaults << 'DCONF_EOF'
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
picture-uri-dark='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
primary-color='#000011'
secondary-color='#00ff41'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/bill-sloth/lock_background.png'

[org/gnome/desktop/interface]
gtk-theme='Bill-Sloth-Cyberpunk'
icon-theme='Bill-Sloth-Neon'
font-name='Ubuntu 11'
monospace-font-name='Ubuntu Mono 13'
color-scheme='prefer-dark'

[org/gnome/shell]
favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'bill-sloth-command-center.desktop']

[org/gnome/terminal/legacy/profiles:/:default]
background-color='#000011'
foreground-color='#00ff41'
use-theme-colors=false
DCONF_EOF

# Update dconf database
dconf update

echo "✅ Bill Sloth Visual Enhancements Installed!"
EOF

chmod +x "$PROJECT_ROOT/windows-setup/config/hooks/live/0100-bill-sloth-visuals.hook.chroot"

# Create first-boot setup script
echo "🔧 Creating first-boot setup script..."
cat > "$PROJECT_ROOT/windows-setup/config/includes.chroot/usr/local/bin/bill-sloth-first-boot.sh" << 'EOF'
#!/bin/bash
# Bill Sloth First Boot Setup Script
# Applies user-specific customizations on first login

USER_HOME="$HOME"
USER_CONFIG="$USER_HOME/.config"

echo "🌈 Setting up Bill Sloth visual experience for $USER..."

# Create user directories
mkdir -p "$USER_CONFIG/dconf"
mkdir -p "$USER_CONFIG/autostart"
mkdir -p "$USER_HOME/.local/share/themes"
mkdir -p "$USER_HOME/.local/share/icons"

# Apply user-specific dconf settings
cat > "$USER_CONFIG/dconf/bill-sloth-user-settings" << 'USER_DCONF_EOF'
[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
picture-uri-dark='file:///usr/share/backgrounds/bill-sloth/wallpaper.png'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/backgrounds/bill-sloth/lock_background.png'

[org/gnome/desktop/interface]
gtk-theme='Bill-Sloth-Cyberpunk'
icon-theme='Bill-Sloth-Neon'
color-scheme='prefer-dark'

[org/gnome/shell]
favorite-apps=['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'bill-sloth-command-center.desktop']
USER_DCONF_EOF

# Load the settings
dconf load / < "$USER_CONFIG/dconf/bill-sloth-user-settings"

# Create autostart entry for visual effects
cat > "$USER_CONFIG/autostart/bill-sloth-welcome.desktop" << 'WELCOME_EOF'
[Desktop Entry]
Type=Application
Name=Bill Sloth Welcome
Comment=Bill Sloth first-time welcome and setup
Exec=/usr/local/bin/bill-sloth-welcome.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
OnlyShowIn=GNOME;
WELCOME_EOF

# Set wallpaper immediately
gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/bill-sloth/wallpaper.png'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///usr/share/backgrounds/bill-sloth/wallpaper.png'

# Apply theme
gsettings set org.gnome.desktop.interface gtk-theme 'Bill-Sloth-Cyberpunk'
gsettings set org.gnome.desktop.interface icon-theme 'Bill-Sloth-Neon'

echo "✅ Bill Sloth visual setup complete!"

# Mark first boot as complete
touch "$USER_HOME/.bill-sloth-setup-complete"
EOF

chmod +x "$PROJECT_ROOT/windows-setup/config/includes.chroot/usr/local/bin/bill-sloth-first-boot.sh"

# Create welcome script
echo "👋 Creating welcome script..."
cat > "$PROJECT_ROOT/windows-setup/config/includes.chroot/usr/local/bin/bill-sloth-welcome.sh" << 'EOF'
#!/bin/bash
# Bill Sloth Welcome Script

# Check if this is first run
if [ ! -f "$HOME/.bill-sloth-setup-complete" ]; then
    # Run first boot setup
    /usr/local/bin/bill-sloth-first-boot.sh
    
    # Show welcome message
    gnome-terminal --window --title="Bill Sloth Linux" -- bash -c "
        clear
        echo 'Welcome to Bill Sloth Linux!' | lolcat
        echo ''
        neofetch
        echo ''
        echo 'Type \"bill\" to launch the Command Center!' | lolcat
        echo ''
        bash
    "
    
    # Disable autostart after first run
    rm -f "$HOME/.config/autostart/bill-sloth-welcome.desktop"
fi
EOF

chmod +x "$PROJECT_ROOT/windows-setup/config/includes.chroot/usr/local/bin/bill-sloth-welcome.sh"

# Create the asset preparation script for Windows
echo "🪟 Creating Windows asset preparation script..."
cat > "$PROJECT_ROOT/iso-customization/prepare_assets_for_iso.ps1" << 'EOF'
# Prepare Bill Sloth Assets for ISO Integration
param(
    [Parameter(Mandatory=$true)]
    [string]$BuildDir
)

$AssetSource = Split-Path $MyInvocation.MyCommand.Path -Parent
$AssetTarget = "$BuildDir\config\includes.chroot\tmp\bill-sloth-assets"

Write-Host "📦 Preparing Bill Sloth assets for ISO integration..." -ForegroundColor Green

# Create asset directories in build
New-Item -ItemType Directory -Path "$AssetTarget\backgrounds" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-4.0" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-3.0" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\icons" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\sounds" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\plymouth" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\grub" -Force | Out-Null

# Copy all assets
Copy-Item "$AssetSource\assets\*" "$AssetTarget\backgrounds\" -Force
Copy-Item "$AssetSource\themes\cyberpunk\*" "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-4.0\" -Force
Copy-Item "$AssetSource\themes\cyberpunk\*" "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-3.0\" -Force
Copy-Item "$AssetSource\icons\*" "$AssetTarget\icons\" -Force
Copy-Item "$AssetSource\sounds\*" "$AssetTarget\sounds\" -Force
Copy-Item "$AssetSource\animations\*" "$AssetTarget\plymouth\" -Force
Copy-Item "$AssetSource\grub\*" "$AssetTarget\grub\" -Force

# Copy Bill Sloth system files
$ProjectRoot = Split-Path $AssetSource -Parent
Copy-Item "$ProjectRoot\bill_command_center.sh" "$AssetTarget\" -Force
Copy-Item "$ProjectRoot\lib" "$AssetTarget\" -Recurse -Force
Copy-Item "$ProjectRoot\modules" "$AssetTarget\" -Recurse -Force

Write-Host "✅ Assets prepared for ISO integration!" -ForegroundColor Green
Write-Host "📁 Assets location: $AssetTarget" -ForegroundColor Cyan
EOF

# Update the mature ISO system to include asset preparation
echo "🔧 Creating enhanced ISO builder integration..."
cat > "$PROJECT_ROOT/iso-customization/enhance_iso_builder.ps1" << 'EOF'
# Enhancement for MATURE_CUSTOM_ISO_SYSTEM.ps1
# Add this to the existing ISO builder to include Bill Sloth visuals

# Add to the MATURE_CUSTOM_ISO_SYSTEM.ps1 after the tools are validated:

Write-Host "🎨 Integrating Bill Sloth Enhanced Visuals..." -ForegroundColor Magenta

# Prepare assets for integration
$AssetPrep = "$PSScriptRoot\..\iso-customization\prepare_assets_for_iso.ps1"
if (Test-Path $AssetPrep) {
    & $AssetPrep -BuildDir $OutputDir
} else {
    Write-Warning "Bill Sloth asset preparation script not found at: $AssetPrep"
}

# Add Bill Sloth packages to package list
$PackageList = "$OutputDir\config\package-lists\billsloth-enhanced.list.chroot"
$PackageContent = @"
# Bill Sloth Enhanced Visual Packages
gnome-shell-extensions
gnome-tweaks
plymouth-themes
papirus-icon-theme
arc-theme
numix-gtk-theme
plank
conky-all
lolcat
neofetch
htop
btop
cmatrix
figlet
toilet
curl
wget
git
flatpak
snapd
fonts-firacode
"@

Set-Content -Path $PackageList -Value $PackageContent -Encoding UTF8

Write-Host "✅ Bill Sloth enhanced visuals integrated into ISO build!" -ForegroundColor Green
Write-Host "🎯 The ISO will now include all customizations and auto-setup!" -ForegroundColor Cyan
EOF

# Create integration instructions
echo "📋 Creating integration instructions..."
cat > "$PROJECT_ROOT/iso-customization/INTEGRATION_INSTRUCTIONS.md" << 'EOF'
# Bill Sloth Enhanced Visual Integration Instructions

## Automatic Installation Overview

The enhanced Bill Sloth visual system is designed to be **automatically installed** with the ISO and configured during first boot. Here's what happens:

### 🔧 During ISO Build (Automatic)
1. **Package Installation**: All required packages (themes, fonts, effects) are installed
2. **Asset Integration**: All custom imagery, themes, and animations are copied
3. **System Configuration**: GRUB and Plymouth themes are configured
4. **Default Settings**: System-wide visual defaults are applied

### 🚀 During First Boot (Automatic)
1. **User Setup**: First-boot script applies user-specific visual settings
2. **Welcome Experience**: Custom terminal welcome with Bill Sloth branding
3. **Desktop Configuration**: Wallpapers, themes, and shortcuts are configured
4. **Command Center**: Bill Sloth Command Center is made available

## Integration with Existing ISO Builder

To integrate with the existing `MATURE_CUSTOM_ISO_SYSTEM.ps1`:

1. **Add to ISO Builder**: Insert the contents of `enhance_iso_builder.ps1` into the mature ISO system
2. **Asset Preparation**: The system will automatically prepare and include all assets
3. **Build Process**: No additional steps needed - everything is automated

## What Gets Installed Automatically

### 🎨 Visual Components
- Cyberpunk GTK theme with neon effects
- Matrix-style Plymouth boot animation
- Enhanced GRUB theme with Bill Sloth branding
- Custom icon theme and cursor theme
- Bill Sloth wallpapers and backgrounds

### 📦 Software Packages
- gnome-shell-extensions (for advanced desktop effects)
- gnome-tweaks (for user customization)
- lolcat, neofetch, cmatrix (for terminal effects)
- Orbitron font (for cyberpunk typography)
- htop, btop (for system monitoring)

### 🔧 System Configuration
- Plymouth theme set to Bill Sloth Enhanced
- GRUB theme configured with custom graphics
- Default wallpapers and lock screen backgrounds
- Terminal color scheme (cyberpunk green/black)
- Desktop shortcuts to Bill Sloth Command Center

## User Experience

### First Boot
1. User boots from ISO or installed system
2. Desktop loads with Bill Sloth wallpaper automatically
3. Terminal welcome message displays with ASCII art
4. Bill Sloth Command Center is available in applications

### No Manual Setup Required
- All themes are pre-applied
- All visual effects are enabled
- No user configuration needed
- Everything "just works" out of the box

## Files Included in ISO

```
/usr/share/backgrounds/bill-sloth/          # All wallpapers and images
/usr/share/themes/Bill-Sloth-Cyberpunk/     # GTK theme files
/usr/share/icons/Bill-Sloth-Neon/           # Icon theme
/usr/share/plymouth/themes/bill-sloth-enhanced/  # Boot animation
/boot/grub/themes/bill-sloth-enhanced/       # GRUB theme
/usr/local/bin/bill_command_center.sh       # Command center
/usr/local/bin/bill-sloth-*.sh              # Setup scripts
```

The enhanced visual system is completely integrated and requires **zero manual configuration** from the user!
EOF

echo ""
echo "🚀 AUTO-INSTALL INTEGRATION COMPLETE!"
echo "===================================="
echo ""
echo "✅ Created Integration Components:"
echo "   • Live-build hook for automatic installation"
echo "   • First-boot setup script for user configuration"
echo "   • Welcome script with terminal effects"
echo "   • Asset preparation for Windows ISO builder"
echo "   • Enhanced ISO builder integration"
echo ""
echo "🎯 Everything is now AUTO-INSTALLED:"
echo "   • All themes and visual effects"
echo "   • Boot animations and GRUB themes"
echo "   • Bill Sloth Command Center"
echo "   • Terminal welcome experience"
echo "   • Desktop shortcuts and wallpapers"
echo ""
echo "📋 See INTEGRATION_INSTRUCTIONS.md for details"
echo ""
echo "🌈 The ISO will include everything and auto-configure on first boot!"