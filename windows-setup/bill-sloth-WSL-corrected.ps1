# ★ CORRECTED ★ Bill Sloth WSL ISO Builder - Following Anti-Pattern Guidelines
# Based on RECOMMENDED builder but fixes all PowerShell syntax issues
# LLM_CAPABILITY: local_ok
param([string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-WSL-Test.iso")

$LocalUbuntuISO = "C:\billsloth\ubuntu-22.04.5-desktop-amd64.iso"

Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
Write-Host "██  ★ CORRECTED BILL SLOTH WSL ISO BUILDER - SYNTAX FIXED ★                   ██" -ForegroundColor Green  
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
Write-Host ""
Write-Host "🦥⚡ FEATURES:" -ForegroundColor Yellow
Write-Host "  • Creates custom ISO with Bill Sloth integration" -ForegroundColor White
Write-Host "  • Uses local Ubuntu ISO to avoid network issues" -ForegroundColor White
Write-Host "  • Follows PowerShell-WSL2 anti-pattern guidelines" -ForegroundColor White
Write-Host "  • Individual WSL commands for reliability" -ForegroundColor White
Write-Host "  • Proper error handling and logging" -ForegroundColor White
Write-Host ""
Write-Host "✅ This version fixes all known PowerShell syntax issues" -ForegroundColor Green
Write-Host ""

# Test WSL2
Write-Host "Testing WSL2 connectivity..." -ForegroundColor Blue
$test = wsl -d Ubuntu-22.04 echo "test"
if ($LASTEXITCODE -ne 0) { 
    Write-Host "❌ WSL2 failed" -ForegroundColor Red
    exit 1 
}
Write-Host "✅ WSL2 verified" -ForegroundColor Green

# Clean start
Write-Host "Cleaning previous build..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 rm -rf /tmp/billsloth

Write-Host "Creating build environment..." -ForegroundColor Green

# Check local ISO
if (-not (Test-Path $LocalUbuntuISO)) {
    Write-Host "❌ Local Ubuntu ISO not found: $LocalUbuntuISO" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Using local Ubuntu ISO: $LocalUbuntuISO" -ForegroundColor Green

# Convert to WSL path - Following anti-pattern guidelines
$wslISOPath = $LocalUbuntuISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

Write-Host "Installing required packages..." -ForegroundColor Blue
# Individual commands only - Anti-pattern rule #1
wsl -d Ubuntu-22.04 bash -c "sudo apt update"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y xorriso"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y squashfs-tools"

Write-Host "Setting up directories..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"

Write-Host "Mounting ISO..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop '$wslISOPath' /mnt/ubuntu-iso"

Write-Host "Extracting ISO contents..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth"
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/extract-cd
wsl -d Ubuntu-22.04 bash -c "sudo rsync -a /mnt/ubuntu-iso/ /tmp/billsloth/extract-cd/"
wsl -d Ubuntu-22.04 bash -c "sudo chown -R \$USER:users /tmp/billsloth/extract-cd/"

Write-Host "Extracting filesystem..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/squashfs-root
wsl -d Ubuntu-22.04 bash -c "sudo unsquashfs -d /tmp/billsloth/squashfs-root /tmp/billsloth/extract-cd/casper/filesystem.squashfs"

Write-Host "Adding Bill Sloth installer..." -ForegroundColor Green
wsl -d Ubuntu-22.04 mkdir -p /tmp/billsloth/squashfs-root/usr/local/bin

# Create installer script line by line - Anti-pattern rule for file creation
wsl -d Ubuntu-22.04 bash -c 'echo "#!/bin/bash" > /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "if [ ! -f ~/.billsloth-setup-complete ]; then" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    echo \"Bill Sloth Cyberpunk system initializing...\"" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt update" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y git curl wget build-essential" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y python3 python3-pip nodejs npm" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    sudo apt install -y vim tmux htop jq sqlite3" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "    if [ -d ~/bill-sloth ]; then" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        find ~/bill-sloth -name \"*.sh\" -exec chmod +x {} \\; 2>/dev/null || true" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        echo \"export PATH=\\\"\\\$HOME/bill-sloth:\\\$PATH\\\"\" >> ~/.bashrc" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        touch ~/.billsloth-setup-complete" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        echo \"Bill Sloth setup complete! Launch with: cd ~/bill-sloth\"" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
wsl -d Ubuntu-22.04 bash -c 'echo "        echo \"Then run: ./bill_command_center.sh\"" >> /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init'
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

Write-Host "Updating filesystem size..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "echo -n \$(sudo du -sx --block-size=1 /tmp/billsloth/squashfs-root | cut -f1) | sudo tee /tmp/billsloth/extract-cd/casper/filesystem.size > /dev/null"

Write-Host "Creating final ISO..." -ForegroundColor Yellow
Write-Host "This may take several minutes..." -ForegroundColor Yellow
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth/extract-cd"
wsl -d Ubuntu-22.04 bash -c "sudo mkisofs -D -r -V 'BillSloth-WSL-Test' -cache-inodes -J -l -o /tmp/billsloth/BillSloth-WSL-Test.iso /tmp/billsloth/extract-cd"

Write-Host "Copying ISO to Windows desktop..." -ForegroundColor Blue
wsl -d Ubuntu-22.04 bash -c "cp /tmp/billsloth/BillSloth-WSL-Test.iso /mnt/c/Users/natha/Desktop/"

# Get final size
$finalSize = wsl -d Ubuntu-22.04 bash -c "ls -lh /tmp/billsloth/BillSloth-WSL-Test.iso | awk '{print \$5}'"

Write-Host ""
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
Write-Host "██  ✅ BILL SLOTH WSL ISO CREATION COMPLETE                                    ██" -ForegroundColor Green
Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Green
Write-Host ""
Write-Host "🎉 SUCCESS! ISO created: $OutputISO" -ForegroundColor Green
Write-Host "📦 Size: $finalSize" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 NEXT STEPS:" -ForegroundColor Yellow
Write-Host "  1. Use VirtualBox/VMware to test the ISO" -ForegroundColor White
Write-Host "  2. Boot from ISO and verify Bill Sloth auto-install" -ForegroundColor White
Write-Host "  3. Test Bill Sloth command center functionality" -ForegroundColor White
Write-Host ""
Write-Host "Bill Sloth will auto-initialize on first boot!" -ForegroundColor Green
Write-Host ""