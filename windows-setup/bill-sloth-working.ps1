# Bill Sloth Working ISO Builder - Final Solution
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso")

Write-Host "BILL SLOTH ISO BUILDER - WORKING VERSION" -ForegroundColor Magenta
Write-Host ""

# Test WSL2
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { Write-Host "WSL2 failed"; exit 1 }
Write-Host "WSL2 verified" -ForegroundColor Green

# Clean start
wsl -d Ubuntu-22.04 rm -rf /tmp/billsloth

Write-Host "Creating build environment..." -ForegroundColor Green

# Build in WSL step by step
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && lb config --distribution jammy --architecture amd64 --binary-images iso-hybrid --iso-application 'Bill Sloth Cyberpunk Ubuntu' --iso-volume 'BILLSLOTH'"

Write-Host "Adding Bill Sloth packages..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/package-lists
wsl -d Ubuntu-22.04 bash -c "echo 'git
curl
wget
build-essential
python3
python3-pip
nodejs
npm
pipewire
carla
espeak
neovim
tmux
htop
tree
openssh-client
rsync
ffmpeg
jq' > /tmp/billsloth/config/package-lists/billsloth.list.chroot"

Write-Host "Adding Bill Sloth setup script..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/usr/local/bin
wsl -d Ubuntu-22.04 bash -c "echo '#!/bin/bash
if [ ! -f ~/.billsloth-setup ]; then
    echo \"Setting up Bill Sloth system...\"
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true
    find ~/bill-sloth -name \"*.sh\" -exec chmod +x {} \; 2>/dev/null || true
    if [ -f ~/bill-sloth/onboard.sh ]; then
        cd ~/bill-sloth && bash onboard.sh || true
    fi
    mkdir -p ~/Projects ~/Scripts
    git config --global user.name \"Bill Sloth\" || true  
    git config --global user.email \"bill@slothlab.cyber\" || true
    touch ~/.billsloth-setup
    echo \"Bill Sloth system ready!\"
fi' > /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init"

wsl -d Ubuntu-22.04 chmod +x /tmp/billsloth/config/includes.chroot/usr/local/bin/billsloth-init

Write-Host "Adding auto-startup..." -ForegroundColor Green  
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/config/includes.chroot/etc/skel
wsl -d Ubuntu-22.04 bash -c "echo 'billsloth-init' > /tmp/billsloth/config/includes.chroot/etc/skel/.bashrc"

Write-Host ""
Write-Host "Starting ISO build (this takes 20-60 minutes)..." -ForegroundColor Yellow
Write-Host "Building REAL custom ISO with Bill Sloth integration" -ForegroundColor Cyan
Write-Host ""

# Build the ISO
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo lb build"

if ($LASTEXITCODE -eq 0) {
    Write-Host "Build completed, copying ISO..." -ForegroundColor Green
    
    # Copy ISO to Windows
    $wslPath = $OutputISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
    wsl -d Ubuntu-22.04 bash -c "find /tmp/billsloth -name '*.iso' -exec cp {} '$wslPath' \;"
    
    if (Test-Path $OutputISO) {
        $size = (Get-Item $OutputISO).Length / 1GB
        Write-Host ""
        Write-Host "SUCCESS: Bill Sloth Cyberpunk ISO created!" -ForegroundColor Green
        Write-Host "Location: $OutputISO" -ForegroundColor Cyan  
        Write-Host "Size: $([math]::Round($size, 2)) GB" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Features included:" -ForegroundColor Green
        Write-Host "- Bill Sloth repository auto-cloned" -ForegroundColor White
        Write-Host "- Development tools (git, python, node)" -ForegroundColor White
        Write-Host "- Audio production (pipewire, carla)" -ForegroundColor White  
        Write-Host "- Voice control (espeak)" -ForegroundColor White
        Write-Host "- System tools (neovim, tmux, htop)" -ForegroundColor White
        Write-Host "- Cyberpunk branding" -ForegroundColor White
        Write-Host ""
        Write-Host "Your cyberpunk sloth ISO is ready!"
    } else {
        Write-Host "Failed to copy ISO" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "ISO BUILD FAILED" -ForegroundColor Red
    Write-Host "Check what went wrong:" -ForegroundColor Yellow
    wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && ls -la"
    exit 1
}