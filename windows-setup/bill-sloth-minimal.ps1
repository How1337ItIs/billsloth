# Bill Sloth Minimal ISO Builder - Installs packages on first boot
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso")

Write-Host "BILL SLOTH MINIMAL ISO BUILDER" -ForegroundColor Magenta
Write-Host "Installs packages on first boot for reliability" -ForegroundColor Cyan
Write-Host ""

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { Write-Host "WSL2 failed"; exit 1 }
Write-Host "WSL2 verified" -ForegroundColor Green

# Clean start
wsl -d Ubuntu-22.04 rm -rf /tmp/billsloth

Write-Host "Creating minimal build environment..." -ForegroundColor Green

# Build minimal Ubuntu ISO with Bill Sloth integration
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && lb config --distribution jammy --architecture amd64 --binary-images iso-hybrid --archive-areas 'main restricted universe multiverse' --iso-application 'Bill Sloth Cyberpunk Ubuntu' --iso-volume 'BILLSLOTH'"

Write-Host "Adding Bill Sloth first-boot installer..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/usr/local/bin

# Create comprehensive first-boot script that installs everything
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init << "INIT_EOF"
#!/bin/bash

if [ ! -f ~/.billsloth-setup-complete ]; then
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo "██  INITIALIZING BILL SLOTH CYBERPUNK SYSTEM                                   ██"
    echo "████████████████████████████████████████████████████████████████████████████████"
    echo ""
    
    echo "This will install development tools and set up the Bill Sloth automation system."
    echo "Press Enter to continue or Ctrl+C to skip..."
    read -p ""
    
    echo "Updating package lists..."
    sudo apt update
    
    echo "Installing Bill Sloth development packages..."
    sudo apt install -y \
        git curl wget build-essential \
        python3 python3-pip python3-venv \
        nodejs npm \
        vim neovim tmux htop tree \
        openssh-client rsync \
        ffmpeg imagemagick \
        jq sqlite3 \
        pipewire-pulse pulseaudio-utils alsa-utils
    
    echo "Cloning Bill Sloth repository..."
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true
    
    if [ -d ~/bill-sloth ]; then
        echo "Making Bill Sloth scripts executable..."
        find ~/bill-sloth -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
        
        echo "Running Bill Sloth onboarding..."
        if [ -f ~/bill-sloth/onboard.sh ]; then
            cd ~/bill-sloth && bash onboard.sh || true
        fi
        
        echo "export PATH=\"\$HOME/bill-sloth:\$PATH\"" >> ~/.bashrc
        
        echo "Setting up directories..."
        mkdir -p ~/Projects ~/Scripts
        
        echo "Configuring git..."
        git config --global user.name "Bill Sloth" || true  
        git config --global user.email "bill@slothlab.cyber" || true
        
        touch ~/.billsloth-setup-complete
        
        echo ""
        echo "████████████████████████████████████████████████████████████████████████████████"
        echo "██  ✅ BILL SLOTH CYBERPUNK SYSTEM READY!                                     ██"
        echo "████████████████████████████████████████████████████████████████████████████████"
        echo ""
        echo "🦥⚡ Your cyberpunk sloth system is ready!"
        echo ""
        echo "Quick start:"
        echo "  cd ~/bill-sloth && ./bill_command_center.sh"
        echo ""
        echo "Features installed:"
        echo "  - Development tools (git, python, node, build tools)"
        echo "  - System tools (vim, tmux, htop, tree)"  
        echo "  - Audio tools (pipewire, pulseaudio)"
        echo "  - Media tools (ffmpeg, imagemagick)"
        echo "  - Network tools (openssh, rsync)"
        echo "  - Utilities (jq, sqlite3)"
        echo ""
    else
        echo "❌ Failed to clone Bill Sloth repository"
        echo "Check your internet connection and try again"
    fi
else
    echo "Bill Sloth system already initialized"
    echo "Run: cd ~/bill-sloth && ./bill_command_center.sh"
fi
INIT_EOF'

wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init

Write-Host "Adding auto-startup..." -ForegroundColor Green  
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/etc/skel
wsl -d Ubuntu-22.04 bash -c "echo 'billsloth-init' > /tmp/billsloth/config/includes.chroot/etc/skel/.bashrc"

Write-Host ""
Write-Host "Starting minimal ISO build (faster without packages)..." -ForegroundColor Yellow
Write-Host "Building Ubuntu base system with Bill Sloth integration" -ForegroundColor Cyan
Write-Host "Packages will be installed on first boot for reliability" -ForegroundColor Cyan
Write-Host ""

# Build the minimal ISO
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo lb build"

if ($LASTEXITCODE -eq 0) {
    # Check for ISO file
    $isoCheck = wsl -d Ubuntu-22.04 bash -c "find /tmp/billsloth -name '*.iso' -type f"
    
    if ($isoCheck) {
        Write-Host "Build completed successfully!" -ForegroundColor Green
        
        # Copy ISO to Windows
        $wslPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
        wsl -d Ubuntu-22.04 bash -c "find /tmp/billsloth -name '*.iso' -exec cp {} '$wslPath' \;"
        
        if (Test-Path $OutputISO) {
            $size = (Get-Item $OutputISO).Length / 1GB
            Write-Host ""
            Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
            Write-Host "██  ✅ BILL SLOTH CYBERPUNK ISO CREATED SUCCESSFULLY!                         ██" -ForegroundColor Green
            Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
            Write-Host ""
            Write-Host "Location: $OutputISO" -ForegroundColor Cyan  
            Write-Host "Size: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "WORKING CUSTOM ISO FEATURES:" -ForegroundColor Green
            Write-Host ""
            Write-Host "FIRST BOOT SETUP:" -ForegroundColor Yellow
            Write-Host "  - Automatic Bill Sloth installation script" -ForegroundColor White
            Write-Host "  - Full development environment setup" -ForegroundColor White
            Write-Host "  - Audio and media tools installation" -ForegroundColor White
            Write-Host "  - Repository cloning and configuration" -ForegroundColor White
            Write-Host ""
            Write-Host "ISO FEATURES:" -ForegroundColor Yellow  
            Write-Host "  - Custom 'Bill Sloth Cyberpunk Ubuntu' branding" -ForegroundColor White
            Write-Host "  - BILLSLOTH volume label" -ForegroundColor White
            Write-Host "  - No fallback to standard Ubuntu" -ForegroundColor White
            Write-Host "  - Real custom ISO (not just copied file)" -ForegroundColor White
            Write-Host ""
            Write-Host "ON FIRST BOOT WILL INSTALL:" -ForegroundColor Yellow
            Write-Host "  - git, curl, wget, build-essential" -ForegroundColor White
            Write-Host "  - python3, pip, nodejs, npm" -ForegroundColor White
            Write-Host "  - vim, neovim, tmux, htop, tree" -ForegroundColor White
            Write-Host "  - openssh-client, rsync" -ForegroundColor White
            Write-Host "  - ffmpeg, imagemagick, jq, sqlite3" -ForegroundColor White
            Write-Host "  - Audio tools (pipewire, pulseaudio)" -ForegroundColor White
            Write-Host ""
            Write-Host "Your cyberpunk sloth ISO is ready for dual-boot installation!" -ForegroundColor Magenta
            Write-Host ""
            Write-Host "The system will automatically set itself up on first login." -ForegroundColor Cyan
        } else {
            Write-Host "Failed to copy ISO to Windows" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "No ISO file was generated" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "ISO BUILD FAILED" -ForegroundColor Red
    exit 1
}