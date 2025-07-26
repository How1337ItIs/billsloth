# Bill Sloth WSL ISO Builder - Clean Version
# Based on RECOMMENDED builder but fixes all PowerShell syntax issues
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-WSL-Test.iso")

$LocalUbuntuISO = "C:\billsloth\ubuntu-22.04.5-desktop-amd64.iso"

Write-Host "CORRECTED BILL SLOTH WSL ISO BUILDER - SYNTAX FIXED" -ForegroundColor Green
Write-Host ""
Write-Host "FEATURES:" -ForegroundColor Yellow
Write-Host "  - Creates custom ISO with Bill Sloth integration" -ForegroundColor White
Write-Host "  - Uses local Ubuntu ISO to avoid network issues" -ForegroundColor White
Write-Host "  - Follows PowerShell-WSL2 anti-pattern guidelines" -ForegroundColor White
Write-Host "  - Individual WSL commands for reliability" -ForegroundColor White
Write-Host ""

# Test WSL2
Write-Host "Testing WSL2 connectivity..." -ForegroundColor Blue
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "WSL2 failed" -ForegroundColor Red
    exit 1 
}
Write-Host "WSL2 verified" -ForegroundColor Green

# Check local ISO
if (-not (Test-Path $LocalUbuntuISO)) {
    Write-Host "Local Ubuntu ISO not found: $LocalUbuntuISO" -ForegroundColor Red
    exit 1
}

Write-Host "Using local Ubuntu ISO: $LocalUbuntuISO" -ForegroundColor Green

# Convert to WSL path
$wslISOPath = $LocalUbuntuISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

# Clean start
Write-Host "Cleaning previous build..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 rm -rf /tmp/billsloth

Write-Host "Installing required packages..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "sudo apt update"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y xorriso"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y squashfs-tools"

Write-Host "Setting up directories..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"

Write-Host "Mounting ISO..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop '$wslISOPath' /mnt/ubuntu-iso"

Write-Host "Extracting ISO contents..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/extract-cd
wsl -d Ubuntu-22.04 bash -c "sudo rsync -a /mnt/ubuntu-iso/ /tmp/billsloth/extract-cd/"
wsl -d Ubuntu-22.04 bash -c "sudo chown -R \$USER:users /tmp/billsloth/extract-cd/"

Write-Host "Extracting filesystem..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/squashfs-root
wsl -d Ubuntu-22.04 bash -c "sudo unsquashfs -d /tmp/billsloth/squashfs-root /tmp/billsloth/extract-cd/casper/filesystem.squashfs"

Write-Host "Adding Bill Sloth installer..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/squashfs-root/usr/local/bin

# Create installer script - line by line to avoid PowerShell parsing issues
wsl -d Ubuntu-22.04 bash -c 'echo "#!/bin/bash" > /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "if [ ! -f ~/.billsloth-setup-complete ]; then" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    echo \"Bill Sloth Cyberpunk system initializing...\"" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt update" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y git curl wget build-essential" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y python3 python3-pip nodejs npm" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y vim tmux htop jq sqlite3" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    # Bill Sloth bridge system dependencies" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y ripgrep fd-find" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    if [ -d ~/bill-sloth ]; then" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        find ~/bill-sloth -name \"*.sh\" -exec chmod +x {} \\; 2>/dev/null || true" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        echo \"export PATH=\\\"\\\$HOME/bill-sloth:\\\$PATH\\\"\" >> ~/.bashrc" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        touch ~/.billsloth-setup-complete" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        echo \"Bill Sloth setup complete!\"" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    fi" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "fi" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'

# Make executable
wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init

Write-Host "Setting up auto-startup..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/squashfs-root/etc/skel
wsl -d Ubuntu-22.04 bash -c 'echo "billsloth-init" > /tmp/billsloth/squashfs-root/etc/skel/.bashrc'

Write-Host "Rebuilding filesystem..." -ForegroundColor Green
wsl -d Ubuntu-22.04 bash -c "sudo rm -f /tmp/billsloth/extract-cd/casper/filesystem.squashfs"
wsl -d Ubuntu-22.04 bash -c "sudo mksquashfs /tmp/billsloth/squashfs-root /tmp/billsloth/extract-cd/casper/filesystem.squashfs -comp xz -noappend"

Write-Host "Creating final ISO..." -ForegroundColor Yellow
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth/extract-cd"
wsl -d Ubuntu-22.04 bash -c "sudo mkisofs -D -r -V 'BillSloth-WSL-Test' -cache-inodes -J -l -o /tmp/billsloth/BillSloth-WSL-Test.iso /tmp/billsloth/extract-cd"

Write-Host "Copying ISO to Windows desktop..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "cp /tmp/billsloth/BillSloth-WSL-Test.iso /mnt/c/Users/natha/Desktop/"

Write-Host ""
Write-Host "SUCCESS! Bill Sloth WSL ISO created successfully" -ForegroundColor Green
Write-Host "Location: Desktop/BillSloth-WSL-Test.iso" -ForegroundColor Cyan
Write-Host ""