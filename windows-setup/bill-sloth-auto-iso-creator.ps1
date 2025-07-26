# Bill Sloth Automated Custom ISO Creator
# Fully automated custom Ubuntu ISO with Bill Sloth pre-installed
# Requires one reboot after WSL2 setup, then runs completely automated

param(
    [string]$UbuntuIsoPath = "C:\Users\Sloth\Downloads\Ubuntu.iso",
    [string]$OutputPath = "$env:USERPROFILE\Desktop\BillSloth-Ubuntu-Custom.iso"
)

Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host "  BILL SLOTH AUTOMATED CUSTOM ISO CREATOR" -ForegroundColor Cyan
Write-Host "  Fully Automated - Minimal User Input Required" -ForegroundColor Magenta
Write-Host "=============================================================" -ForegroundColor Cyan
Write-Host ""

# Check if WSL2 is ready
try {
    $wslList = wsl --list --quiet 2>$null
    if ($wslList -match "Ubuntu") {
        Write-Host "[OK] WSL2 Ubuntu detected and ready" -ForegroundColor Green
        $wslReady = $true
    } else {
        $wslReady = $false
    }
} catch {
    $wslReady = $false
}

if (-not $wslReady) {
    Write-Host "[INFO] WSL2 setup completed but requires reboot" -ForegroundColor Yellow
    Write-Host "After reboot, run this script again to continue" -ForegroundColor White
    Write-Host ""
    Write-Host "The script will then run completely automated to create:" -ForegroundColor Green
    Write-Host "- Custom Ubuntu ISO with Bill Sloth pre-installed" -ForegroundColor Cyan
    Write-Host "- Auto-launching onboarding system" -ForegroundColor Cyan
    Write-Host "- Complete automation ready on first boot" -ForegroundColor Cyan
    Write-Host ""
    $reboot = Read-Host "Reboot now to continue? (y/N)"
    if ($reboot -eq 'y' -or $reboot -eq 'Y') {
        Write-Host "Rebooting system..." -ForegroundColor Green
        Restart-Computer -Force
    }
    exit 0
}

Write-Host "[INFO] Starting fully automated Bill Sloth custom ISO creation..." -ForegroundColor Green
Write-Host ""

# Verify Ubuntu ISO exists
if (-not (Test-Path $UbuntuIsoPath)) {
    Write-Host "[ERROR] Ubuntu ISO not found: $UbuntuIsoPath" -ForegroundColor Red
    $UbuntuIsoPath = Read-Host "Enter path to Ubuntu ISO file"
    
    if (-not (Test-Path $UbuntuIsoPath)) {
        Write-Host "[ERROR] ISO file not found. Exiting." -ForegroundColor Red
        exit 1
    }
}

$isoSize = [math]::Round((Get-Item $UbuntuIsoPath).Length / 1GB, 2)
Write-Host "[OK] Ubuntu ISO found: $UbuntuIsoPath ($isoSize GB)" -ForegroundColor Green

# Create automated setup script for WSL2
$wslSetupScript = @'
#!/bin/bash
set -e

echo "============================================="
echo "  BILL SLOTH CUSTOM ISO CREATION - WSL2"
echo "  Automated Ubuntu Customization Process"
echo "============================================="
echo ""

# Update system
echo "[INFO] Updating Ubuntu system..."
sudo apt update && sudo apt upgrade -y

# Install Cubic and dependencies
echo "[INFO] Installing Cubic (Custom Ubuntu ISO Creator)..."
sudo apt install -y software-properties-common
sudo add-apt-repository -y universe
sudo add-apt-repository -y ppa:cubic-wizard/release
sudo apt update
sudo apt install -y cubic

# Install additional tools
echo "[INFO] Installing development tools..."
sudo apt install -y git curl wget python3 python3-pip nodejs npm
sudo apt install -y build-essential squashfs-tools genisoimage

# Create working directory
WORK_DIR="/mnt/c/Users/Sloth/BillSloth-ISO-Build"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Clone Bill Sloth repository
echo "[INFO] Cloning Bill Sloth automation system..."
if [ -d "billsloth" ]; then
    rm -rf billsloth
fi
git clone https://github.com/How1337ItIs/billsloth.git

# Create Cubic project directory
PROJECT_DIR="$WORK_DIR/cubic-project"
mkdir -p "$PROJECT_DIR"

echo "[INFO] Setting up custom ISO project..."

# Copy Ubuntu ISO to working directory
ISO_SOURCE="/mnt/c/Users/Sloth/Downloads/Ubuntu.iso"
ISO_WORK="$WORK_DIR/ubuntu-base.iso"
cp "$ISO_SOURCE" "$ISO_WORK"

echo "[OK] Ubuntu ISO copied to working directory"

# Create Cubic automation script
cat > "$WORK_DIR/cubic-automation.sh" << 'EOF'
#!/bin/bash
# Cubic automation script for Bill Sloth integration

echo "Starting Cubic customization process..."

# Extract ISO
mkdir -p /tmp/iso-extract
sudo mount -o loop ubuntu-base.iso /mnt
sudo cp -r /mnt/* /tmp/iso-extract/
sudo umount /mnt

# Create chroot environment
sudo mkdir -p /tmp/chroot
cd /tmp/iso-extract
sudo unsquashfs -d /tmp/chroot filesystem.squashfs

# Mount necessary filesystems for chroot
sudo mount --bind /dev /tmp/chroot/dev
sudo mount --bind /dev/pts /tmp/chroot/dev/pts
sudo mount --bind /proc /tmp/chroot/proc
sudo mount --bind /sys /tmp/chroot/sys

# Copy Bill Sloth into chroot
sudo cp -r billsloth /tmp/chroot/opt/

# Create chroot customization script
sudo tee /tmp/chroot/customize.sh << 'CHROOT_EOF'
#!/bin/bash
export HOME=/root
export LC_ALL=C

# Update system in chroot
apt update
apt install -y git curl wget python3 python3-pip nodejs npm sqlite3 espeak-ng

# Set up Bill Sloth in system
cd /opt/billsloth
chmod +x bill_command_center.sh onboard.sh
chmod +x lib/*.sh modules/*.sh scripts/*.sh

# Create auto-launch on first login
cat > /etc/profile.d/bill-sloth-welcome.sh << 'PROFILE_EOF'
#!/bin/bash
if [ ! -f "$HOME/.bill-sloth-initialized" ]; then
    echo ""
    echo "============================================="
    echo "  BILL SLOTH AUTOMATION SYSTEM"
    echo "  Welcome to your personal Linux assistant!"
    echo "============================================="
    echo ""
    echo "Initializing Bill Sloth system..."
    /opt/billsloth/onboard.sh
    touch "$HOME/.bill-sloth-initialized"
fi
PROFILE_EOF

chmod +x /etc/profile.d/bill-sloth-welcome.sh

# Create desktop application
cat > /usr/share/applications/bill-sloth.desktop << 'DESKTOP_EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Bill Sloth Command Center
Comment=Personal Linux automation system - Self-building Jarvis
Exec=/opt/billsloth/bill_command_center.sh
Icon=utilities-terminal
Terminal=true
Categories=System;Utility;Development;
Keywords=automation;productivity;assistant;jarvis;
DESKTOP_EOF

# Create systemd user service
mkdir -p /etc/systemd/user
cat > /etc/systemd/user/bill-sloth.service << 'SERVICE_EOF'
[Unit]
Description=Bill Sloth Automation System
After=graphical-session.target

[Service]
Type=oneshot
ExecStart=/opt/billsloth/bill_command_center.sh --background-check
RemainAfterExit=yes
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
SERVICE_EOF

# Enable the service for all users
systemctl --global enable bill-sloth.service

# Install additional useful packages
apt install -y vim htop tree git-extras
apt install -y firefox-esr libreoffice-writer
apt install -y python3-venv python3-dev

# Clean up
apt autoremove -y
apt autoclean

echo "Bill Sloth customization complete!"
CHROOT_EOF

# Execute customization in chroot
sudo chmod +x /tmp/chroot/customize.sh
sudo chroot /tmp/chroot ./customize.sh

# Clean up chroot
sudo rm /tmp/chroot/customize.sh

# Unmount chroot filesystems
sudo umount /tmp/chroot/sys
sudo umount /tmp/chroot/proc
sudo umount /tmp/chroot/dev/pts
sudo umount /tmp/chroot/dev

# Recreate filesystem.squashfs
cd /tmp/iso-extract
sudo rm filesystem.squashfs
sudo mksquashfs /tmp/chroot filesystem.squashfs -comp xz

# Update file sizes
sudo du -sx --block-size=1 /tmp/chroot | cut -f1 > filesystem.size
sudo printf $(sudo du -sxb /tmp/chroot | cut -f1) > filesystem.size

# Create new ISO
ISO_OUTPUT="/mnt/c/Users/Sloth/Desktop/BillSloth-Ubuntu-Custom.iso"
sudo genisoimage -r -V "BillSloth Ubuntu" -o "$ISO_OUTPUT" \
    -b isolinux/isolinux.bin -c isolinux/boot.cat \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
    -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot \
    /tmp/iso-extract

echo ""
echo "============================================="
echo "  BILL SLOTH CUSTOM ISO CREATED!"
echo "============================================="
echo ""
echo "Custom ISO location: $ISO_OUTPUT"
echo ""
echo "This ISO contains:"
echo "- Ubuntu with Bill Sloth pre-installed"
echo "- Auto-launching onboarding system"
echo "- Complete automation ready on first boot"
echo "- Self-building Jarvis system"
echo ""
echo "Boot from this ISO to install your personal automation OS!"

# Cleanup
sudo rm -rf /tmp/chroot /tmp/iso-extract

EOF

chmod +x "$WORK_DIR/cubic-automation.sh"

echo ""
echo "[INFO] Running automated ISO customization..."
cd "$WORK_DIR"
./cubic-automation.sh

echo ""
echo "============================================="
echo "  AUTOMATION COMPLETE!"
echo "============================================="
echo ""
echo "Your custom Bill Sloth Ubuntu ISO has been created!"
echo "Location: /mnt/c/Users/Sloth/Desktop/BillSloth-Ubuntu-Custom.iso"
echo ""
echo "This is a complete Bill Sloth Linux distribution with:"
echo "- Pre-installed automation system"
echo "- Auto-launching onboarding"
echo "- Command center ready on first boot"
echo "- No manual setup required"
echo ""
echo "Your self-building Jarvis OS is ready!"
'@

# Save WSL setup script
$wslSetupScript | Out-File -FilePath "C:\Users\Sloth\bill-sloth-wsl-setup.sh" -Encoding UTF8

Write-Host "[INFO] Transferring automation script to WSL2..." -ForegroundColor White

# Copy setup script to WSL2 and execute
try {
    # Copy files to WSL2
    wsl -- mkdir -p /tmp/bill-sloth-setup
    wsl -- cp /mnt/c/Users/Sloth/bill-sloth-wsl-setup.sh /tmp/bill-sloth-setup/
    wsl -- chmod +x /tmp/bill-sloth-setup/bill-sloth-wsl-setup.sh
    
    Write-Host "[INFO] Starting automated custom ISO creation in WSL2..." -ForegroundColor Green
    Write-Host "This process will:" -ForegroundColor White
    Write-Host "1. Install Cubic and tools" -ForegroundColor Cyan
    Write-Host "2. Extract and customize Ubuntu ISO" -ForegroundColor Cyan
    Write-Host "3. Install Bill Sloth into the OS" -ForegroundColor Cyan
    Write-Host "4. Create auto-launch system" -ForegroundColor Cyan
    Write-Host "5. Generate custom ISO file" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Estimated time: 15-30 minutes" -ForegroundColor Yellow
    Write-Host ""
    
    # Execute the full automation
    wsl -- bash /tmp/bill-sloth-setup/bill-sloth-wsl-setup.sh
    
    Write-Host ""
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host "  BILL SLOTH CUSTOM ISO CREATION COMPLETE!" -ForegroundColor Green
    Write-Host "=============================================" -ForegroundColor Green
    Write-Host ""
    
    if (Test-Path $OutputPath) {
        $customIsoSize = [math]::Round((Get-Item $OutputPath).Length / 1GB, 2)
        Write-Host "[SUCCESS] Custom ISO created: $OutputPath" -ForegroundColor Green
        Write-Host "          Size: $customIsoSize GB" -ForegroundColor White
        Write-Host ""
        Write-Host "Your Bill Sloth Ubuntu distribution is ready!" -ForegroundColor Magenta
        Write-Host "This ISO includes:" -ForegroundColor Cyan
        Write-Host "- Complete Bill Sloth automation system" -ForegroundColor White
        Write-Host "- Auto-launching onboarding on first boot" -ForegroundColor White
        Write-Host "- Command center ready immediately" -ForegroundColor White
        Write-Host "- No manual setup required after install" -ForegroundColor White
        Write-Host ""
        Write-Host "Boot from this ISO to install your personal automation OS!" -ForegroundColor Green
    } else {
        Write-Host "[WARNING] Custom ISO not found at expected location" -ForegroundColor Yellow
        Write-Host "Check WSL2 output above for any errors" -ForegroundColor White
    }
    
} catch {
    Write-Host "[ERROR] Failed to execute WSL2 automation: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Manual execution option:" -ForegroundColor Yellow
    Write-Host "1. Open WSL2: wsl" -ForegroundColor White
    Write-Host "2. Run: bash /tmp/bill-sloth-setup/bill-sloth-wsl-setup.sh" -ForegroundColor White
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")