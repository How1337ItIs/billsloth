# CURSOR AGENT ROBUST Bill Sloth Custom ISO Builder - Aggressive Cleanup
# By Cursor Agent - July 25, 2025
# Addresses persistent filesystem extraction issues with aggressive cleanup
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Custom-ROBUST.iso")

$LocalUbuntuISO = "C:\billsloth\ubuntu-22.04.5-desktop-amd64.iso"

Write-Host "================================================================================" -ForegroundColor Green
Write-Host "==  CURSOR AGENT ROBUST BILL SLOTH CUSTOM ISO BUILDER                      ==" -ForegroundColor Green  
Write-Host "==  By Cursor Agent - July 25, 2025                                        ==" -ForegroundColor Green
Write-Host "================================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "ROBUST FIXES:" -ForegroundColor Yellow
Write-Host "  - Aggressive cleanup of all previous artifacts" -ForegroundColor White
Write-Host "  - Force removal of leftover directories" -ForegroundColor White
Write-Host "  - Alternative filesystem extraction method" -ForegroundColor White
Write-Host "  - Enhanced error handling and recovery" -ForegroundColor White
Write-Host ""

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { Write-Host "WSL2 failed"; exit 1 }
Write-Host "WSL2 verified" -ForegroundColor Green

# AGGRESSIVE CLEANUP - Force remove everything
Write-Host "Step 0: Aggressive cleanup of all previous artifacts..." -ForegroundColor Red
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/squashfs-root 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/extract-cd 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth-* 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/ubuntu-* 2>/dev/null || true"

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

Write-Host "Step 2: Creating fresh build environment..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/billsloth-robust"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && mkdir -p extract-cd"

Write-Host "Step 3: Mounting Ubuntu ISO..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop '$wslISOPath' /mnt/ubuntu-iso"

Write-Host "Step 4: Extracting ISO contents..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo rsync -a /mnt/ubuntu-iso/ extract-cd/"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo chown -R `$USER:users extract-cd/"

Write-Host "Step 5: Extracting filesystem with robust method..." -ForegroundColor Cyan
# Use a different directory name to avoid conflicts
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo rm -rf squashfs-root-robust"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && mkdir -p squashfs-root-robust"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo unsquashfs -d squashfs-root-robust extract-cd/casper/filesystem.squashfs"

# Verify filesystem extraction was successful
Write-Host "Step 6: Verifying filesystem extraction..." -ForegroundColor Cyan
$fsSize = wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo du -sh squashfs-root-robust 2>/dev/null | cut -f1"
$fileCount = wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo find squashfs-root-robust -type f | wc -l"

Write-Host "Filesystem size: $fsSize" -ForegroundColor White
Write-Host "File count: $fileCount" -ForegroundColor White

if ($fileCount -lt 1000) {
    Write-Host "ERROR: Filesystem extraction failed - too few files!" -ForegroundColor Red
    Write-Host "Expected: 100,000+ files, Got: $fileCount" -ForegroundColor Red
    Write-Host "Trying alternative extraction method..." -ForegroundColor Yellow
    
    # Try alternative method - extract to different location
    wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo rm -rf squashfs-root-robust"
    wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo unsquashfs -f -d squashfs-root-robust extract-cd/casper/filesystem.squashfs"
    
    # Check again
    $fsSize = wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo du -sh squashfs-root-robust 2>/dev/null | cut -f1"
    $fileCount = wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo find squashfs-root-robust -type f | wc -l"
    
    Write-Host "After alternative method - Filesystem size: $fsSize" -ForegroundColor White
    Write-Host "After alternative method - File count: $fileCount" -ForegroundColor White
    
    if ($fileCount -lt 1000) {
        Write-Host "ERROR: All extraction methods failed!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "Step 7: Adding Bill Sloth integration..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /tmp/billsloth-robust/squashfs-root-robust/usr/local/bin"

# Create comprehensive first-boot script
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth-robust/squashfs-root-robust/usr/local/bin/billsloth-init << "INIT_EOF"
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

wsl -d Ubuntu-22.04 bash -c "sudo chmod +x /tmp/billsloth-robust/squashfs-root-robust/usr/local/bin/billsloth-init"

Write-Host "Step 8: Adding auto-startup..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /tmp/billsloth-robust/squashfs-root-robust/etc/skel"
wsl -d Ubuntu-22.04 bash -c "echo 'billsloth-init' | sudo tee /tmp/billsloth-robust/squashfs-root-robust/etc/skel/.bashrc"

Write-Host ""
Write-Host "Step 9: Rebuilding filesystem (this may take 10-15 minutes)..." -ForegroundColor Yellow
Write-Host "Building Ubuntu base system with Bill Sloth integration" -ForegroundColor Cyan

# Rebuild the filesystem
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo rm -f extract-cd/casper/filesystem.squashfs"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && sudo mksquashfs squashfs-root-robust extract-cd/casper/filesystem.squashfs -comp xz -noappend"

# Update filesystem size
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust && echo -n `$(sudo du -sx --block-size=1 squashfs-root-robust | cut -f1) | sudo tee extract-cd/casper/filesystem.size > /dev/null"

Write-Host "Step 10: Creating bootable ISO..." -ForegroundColor Cyan
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth-robust/extract-cd && sudo xorriso -as mkisofs -r -V 'BILLSLOTH' -o ../billsloth-custom-robust.iso -J -l -b boot/grub/i386-pc/eltorito.img -c boot.catalog -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e EFI/boot/bootx64.efi -no-emul-boot -isohybrid-gpt-basdat ."

# Cleanup
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"

if ($LASTEXITCODE -eq 0) {
    # Check for ISO file and verify size
    $isoCheck = wsl -d Ubuntu-22.04 bash -c "ls -la /tmp/billsloth-robust/billsloth-custom-robust.iso 2>/dev/null"
    
    if ($isoCheck) {
        $isoSize = wsl -d Ubuntu-22.04 bash -c "ls -lh /tmp/billsloth-robust/billsloth-custom-robust.iso | awk '{print `$5}'"
        Write-Host "Build completed successfully!" -ForegroundColor Green
        Write-Host "ISO size: $isoSize" -ForegroundColor White
        
        # Copy ISO to Windows
        $wslPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
        wsl -d Ubuntu-22.04 bash -c "cp /tmp/billsloth-robust/billsloth-custom-robust.iso '$wslPath'"
        
        if (Test-Path $OutputISO) {
            $size = (Get-Item $OutputISO).Length / 1GB
            Write-Host ""
            Write-Host "================================================================================" -ForegroundColor Green
            Write-Host "==  SUCCESS: CURSOR AGENT ROBUST BILL SLOTH CUSTOM ISO CREATED!              ==" -ForegroundColor Green
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