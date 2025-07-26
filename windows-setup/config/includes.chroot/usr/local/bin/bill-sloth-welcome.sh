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
