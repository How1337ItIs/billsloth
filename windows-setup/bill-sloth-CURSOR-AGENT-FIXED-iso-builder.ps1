# CURSOR AGENT FIXED Bill Sloth Custom ISO Builder - Proper Filesystem Extraction
# By Cursor Agent - July 25, 2025
# Addresses the filesystem extraction issues that caused tiny ISOs
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Custom-FIXED.iso")

$LocalUbuntuISO = "C:\billsloth\ubuntu-22.04.5-desktop-amd64.iso"

Write-Host "================================================================================" -ForegroundColor Green
Write-Host "==  CURSOR AGENT FIXED BILL SLOTH CUSTOM ISO BUILDER                        ==" -ForegroundColor Green  
Write-Host "==  By Cursor Agent - July 25, 2025                                        ==" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "FIXES:" -ForegroundColor Yellow
Write-Host "  - Proper filesystem extraction with cleanup" -ForegroundColor White
Write-Host "  - Verification of filesystem size" -ForegroundColor White
Write-Host "  - Full Ubuntu system preservation" -ForegroundColor White
Write-Host "  - Correct ISO size (should be ~4-5GB)" -ForegroundColor White
Write-Host ""

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { Write-Host "WSL2 failed"; exit 1 }
Write-Host "WSL2 verified" -ForegroundColor Green

# Clean start - IMPORTANT: Remove any leftover directories
Write-Host "Cleaning previous build artifacts..." -ForegroundColor Yellow
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth"
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"

# Check local ISO
if (-not (Test-Path $LocalUbuntuISO)) {
    Write-Host "ERROR: Local Ubuntu ISO not found: $LocalUbuntuISO" -ForegroundColor Red
    exit 1
}

Write-Host "SUCCESS: Using local Ubuntu ISO: $LocalUbuntuISO" -ForegroundColor Green

# Convert to WSL path
$wslISOPath = $LocalUbuntuISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

Write-Host "Step 1: Installing required tools..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo apt update -qq"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y xorriso squashfs-tools rsync"

Write-Host "Step 2: Creating build environment..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/billsloth"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && mkdir -p extract-cd"

Write-Host "Step 3: Mounting Ubuntu ISO..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop '$wslISOPath' /mnt/ubuntu-iso"

Write-Host "Step 4: Extracting ISO contents..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo rsync -a /mnt/ubuntu-iso/ extract-cd/"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo chown -R `$USER:users extract-cd/"

Write-Host "Step 5: Extracting filesystem (this may take 5-10 minutes)..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo rm -rf squashfs-root"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && mkdir -p squashfs-root"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo unsquashfs -d squashfs-root extract-cd/casper/filesystem.squashfs"

# Verify filesystem extraction was successful
Write-Host "Step 6: Verifying filesystem extraction..." -ForegroundColor Cyan
$fsSize = wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo du -sh squashfs-root 2>/dev/null | cut -f1"
$fileCount = wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo find squashfs-root -type f | wc -l"

Write-Host "Filesystem size: $fsSize" -ForegroundColor White
Write-Host "File count: $fileCount" -ForegroundColor White

if ($fileCount -lt 1000) {
    Write-Host "ERROR: Filesystem extraction failed - too few files!" -ForegroundColor Red
    Write-Host "Expected: 100,000+ files, Got: $fileCount" -ForegroundColor Red
    exit 1
}

Write-Host "Step 7: Adding Bill Sloth integration..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /tmp/billsloth/squashfs-root/usr/local/bin"

# Create comprehensive first-boot script
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init << "INIT_EOF"
#!/bin/bash

if [ ! -f ~/.billsloth-setup-complete ]; then
    echo "================================================================================"
    echo "==  INITIALIZING BILL SLOTH CYBERPUNK SYSTEM                                 =="
    echo "================================================================================"
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
        echo "================================================================================"
        echo "==  SUCCESS: BILL SLOTH CYBERPUNK SYSTEM READY!                             =="
        echo "================================================================================"
        echo ""
        echo "Your cyberpunk sloth system is ready!"
        echo ""
        echo "Quick start:"
        echo "  cd ~/bill-sloth && ./bill_command_center.sh"
        echo ""
    else
        echo "ERROR: Failed to clone Bill Sloth repository"
        echo "Check your internet connection and try again"
    fi
else
    echo "Bill Sloth system already initialized"
    echo "Run: cd ~/bill-sloth && ./bill_command_center.sh"
fi
INIT_EOF'

wsl -d Ubuntu-22.04 bash -c "sudo chmod +x /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init"

Write-Host "Step 8: Adding auto-startup..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /tmp/billsloth/squashfs-root/etc/skel"
wsl -d Ubuntu-22.04 bash -c "echo 'billsloth-init' | sudo tee /tmp/billsloth/squashfs-root/etc/skel/.bashrc"

Write-Host ""
Write-Host "Step 9: Rebuilding filesystem (this may take 10-15 minutes)..." -ForegroundColor Yellow
Write-Host "Building Ubuntu base system with Bill Sloth integration" -ForegroundColor Cyan

# Rebuild the filesystem
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo rm -f extract-cd/casper/filesystem.squashfs"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo mksquashfs squashfs-root extract-cd/casper/filesystem.squashfs -comp xz -noappend"

# Update filesystem size
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && echo -n `$(sudo du -sx --block-size=1 squashfs-root | cut -f1) | sudo tee extract-cd/casper/filesystem.size > /dev/null"

Write-Host "Step 10: Creating bootable ISO..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth/extract-cd && sudo xorriso -as mkisofs -r -V 'BILLSLOTH' -o ../billsloth-custom-fixed.iso -J -l -b boot/grub/i386-pc/eltorito.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e EFI/boot/bootx64.efi -no-emul-boot -isohybrid-gpt-basdat ."

# Cleanup
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"

if ($LASTEXITCODE -eq 0) {
    # Check for ISO file and verify size
    $isoCheck = wsl -d Ubuntu-22.04 bash -c "ls -la /tmp/billsloth/billsloth-custom-fixed.iso 2>/dev/null"
    
    if ($isoCheck) {
        $isoSize = wsl -d Ubuntu-22.04 bash -c "ls -lh /tmp/billsloth/billsloth-custom-fixed.iso | awk '{print `$5}'"
        Write-Host "Build completed successfully!" -ForegroundColor Green
        Write-Host "ISO size: $isoSize" -ForegroundColor White
        
        # Copy ISO to Windows
        $wslPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
        wsl -d Ubuntu-22.04 bash -c "cp /tmp/billsloth/billsloth-custom-fixed.iso '$wslPath'"
        
        if (Test-Path $OutputISO) {
            $size = (Get-Item $OutputISO).Length / 1GB
            Write-Host ""
            Write-Host "================================================================================" -ForegroundColor Green
            Write-Host "==  SUCCESS: CURSOR AGENT FIXED BILL SLOTH CUSTOM ISO CREATED!              ==" -ForegroundColor Green
            Write-Host "================================================================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "Location: $OutputISO" -ForegroundColor Cyan  
            Write-Host "Size: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
            Write-Host ""
            
            if ($size -gt 3) {
                Write-Host "✅ CORRECT SIZE: ISO is properly sized (>3GB)" -ForegroundColor Green
            } else {
                Write-Host "⚠️  WARNING: ISO size seems small ($size GB)" -ForegroundColor Yellow
            }
            
            Write-Host ""
            Write-Host "Your cyberpunk sloth ISO is ready for dual-boot installation!" -ForegroundColor Magenta
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