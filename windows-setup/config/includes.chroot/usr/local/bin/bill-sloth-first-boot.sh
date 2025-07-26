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
