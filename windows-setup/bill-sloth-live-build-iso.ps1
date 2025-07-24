# Bill Sloth Live-Build ISO Creator - Cyberpunk Edition
# Uses mature live-build technology for bulletproof custom Ubuntu ISO creation

param(
    [string]$OutputISO = "$env:USERPROFILE\Desktop\BillSloth-Cyberpunk-Ubuntu.iso",
    [string]$UbuntuVersion = "jammy", # Ubuntu 22.04 LTS
    [switch]$MaxCyberpunk,
    [switch]$FastMode
)

#Requires -RunAsAdministrator

Write-Host @"
████████████████████████████████████████████████████████████████████████████████
██                                                                            ██
██  ░▒▓█ BILL SLOTH LIVE-BUILD ISO CONSTRUCTOR v3.0 █▓▒░                      ██
██                                                                            ██
██  ████ MATURE LIVE-BUILD TECHNOLOGY + CYBERPUNK SLOTH ████                  ██
██  ▓▓▓▓ BULLETPROOF ISO CREATION WITH DEBIAN OFFICIAL TOOLS ▓▓▓▓              ██
██                                                                            ██
████████████████████████████████████████████████████████████████████████████████
"@ -ForegroundColor Magenta

Write-Host ""
Write-Host "▓▓▓ NEURAL MATRIX ONLINE ▓▓▓" -ForegroundColor Cyan
Write-Host "░░░ INITIALIZING LIVE-BUILD FRAMEWORK ░░░" -ForegroundColor Green
Write-Host "▒▒▒ LOADING CYBERPUNK SLOTH PROTOCOLS ▒▒▒" -ForegroundColor Yellow
Write-Host ""

# Create live-build project structure
function Initialize-LiveBuildProject {
    Write-Host "=== INITIALIZING CYBERPUNK ISO PROJECT ===" -ForegroundColor Cyan
    Write-Host ""
    
    $projectDir = "$env:TEMP\BillSloth-LiveBuild"
    
    if (Test-Path $projectDir) {
        Write-Host "Removing existing project..." -ForegroundColor Yellow
        Remove-Item -Path $projectDir -Recurse -Force
    }
    
    New-Item -ItemType Directory -Path $projectDir -Force | Out-Null
    Write-Host "▓▓▓ Project directory created: $projectDir" -ForegroundColor Green
    
    return $projectDir
}

# Create live-build configuration
function New-CyberpunkLiveBuildConfig {
    param([string]$ProjectDir)
    
    Write-Host "▒▒▒ CONFIGURING LIVE-BUILD MATRIX ▒▒▒" -ForegroundColor Cyan
    Write-Host ""
    
    # Create auto/config script
    $autoConfigDir = "$ProjectDir\auto"
    New-Item -ItemType Directory -Path $autoConfigDir -Force | Out-Null
    
    $autoConfig = @"
#!/bin/bash
# Bill Sloth Cyberpunk Live-Build Configuration

lb config noauto \
    --distribution jammy \
    --archive-areas "main restricted universe multiverse" \
    --linux-flavours generic \
    --linux-packages linux-image \
    --bootappend-live "boot=live components quiet splash cyberpunk billsloth.mode=neural" \
    --bootappend-install "file=/cdrom/preseed/billsloth.seed cyberpunk billsloth.autosetup=true" \
    --debian-installer live \
    --debian-installer-gui true \
    --win32-loader false \
    --iso-application "Bill Sloth Cyberpunk Ubuntu" \
    --iso-preparer "Bill Sloth Neural Interface" \
    --iso-publisher "Cyberpunk Sloth Automation Lab" \
    --iso-volume "BILLSLOTH-CYBER" \
    --memtest none \
    --apt-recommends true \
    --security true \
    --updates true \
    --backports false \
    --cache-packages true \
    --cache-stages "bootstrap rootfs" \
    --compression gzip \
    --zsync false \
    "\${@}"
"@
    
    $autoConfig | Out-File -FilePath "$autoConfigDir\config" -Encoding UTF8
    
    Write-Host "Live-build config created with cyberpunk parameters" -ForegroundColor Green
    return $ProjectDir
}

# Create package lists for Bill Sloth integration
function New-BillSlothPackageList {
    param([string]$ProjectDir)
    
    Write-Host "░░░ DEFINING NEURAL PACKAGE MATRIX ░░░" -ForegroundColor Cyan
    Write-Host ""
    
    $packageListDir = "$ProjectDir\config\package-lists"
    New-Item -ItemType Directory -Path $packageListDir -Force | Out-Null
    
    # Core Bill Sloth packages
    $billSlothPackages = @"
# Bill Sloth Cyberpunk OS Package List
# Core development and automation packages

# Essential development tools
curl
wget
git
vim
nano
htop
tree
jq
unzip
software-properties-common
apt-transport-https
ca-certificates
gnupg
lsb-release

# Python ecosystem for automation
python3
python3-pip
python3-venv
python3-dev
build-essential

# Node.js for Claude Code
nodejs
npm

# Audio system for voice control (PipeWire + JACK)
pipewire
pipewire-pulse
pipewire-jack
pipewire-alsa
pipewire-audio-client-libraries
wireplumber
qjackctl
pulseaudio-utils
alsa-utils
alsa-base
portaudio19-dev
python3-pyaudio

# Voice and audio tools
espeak
espeak-data
festival
festival-dev
sox
libsox-fmt-all

# Cyberpunk terminal aesthetics
cmatrix
figlet
lolcat
cowsay
neofetch
screenfetch

# Shell enhancement
zsh
fish
tmux
screen

# Network and system tools
net-tools
openssh-client
openssh-server
rsync
cron

# File system tools
fuse
ntfs-3g
exfat-fuse
exfat-utils

# Compression tools
zip
unzip
rar
unrar
p7zip-full

# Media and graphics
imagemagick
ffmpeg
vlc

# Text editors and IDEs
code
"@
    
    $billSlothPackages | Out-File -FilePath "$packageListDir\billsloth.list.chroot" -Encoding UTF8
    
    # Cyberpunk aesthetic packages
    $cyberpunkPackages = @"
# Cyberpunk Aesthetic Packages

# Terminal eye candy
hollywood
sl
fortune-mod
cowsay
lolcat
cmatrix
pipes.sh

# Custom fonts for cyberpunk look
fonts-firacode
fonts-hack
fonts-inconsolata
fonts-terminus

# Desktop environment enhancements  
plymouth
plymouth-themes
grub2-themes-ubuntu-mate
"@
    
    $cyberpunkPackages | Out-File -FilePath "$packageListDir\cyberpunk.list.chroot" -Encoding UTF8
    
    Write-Host "Package lists created: Core + Cyberpunk aesthetic packages" -ForegroundColor Green
}

# Create preseed configuration for automated installation
function New-BillSlothPreseed {
    param([string]$ProjectDir)
    
    Write-Host "▓▓▓ CREATING NEURAL INSTALLATION MATRIX ▓▓▓" -ForegroundColor Cyan
    Write-Host ""
    
    $preseedDir = "$ProjectDir\config\includes.installer\preseed"
    New-Item -ItemType Directory -Path $preseedDir -Force | Out-Null
    
    $preseedConfig = @"
# Bill Sloth Cyberpunk Ubuntu Preseed Configuration
# Automated installation with ADHD/dyslexia optimizations

# Localization
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us

# Network configuration
d-i netcfg/choose_interface select auto
d-i netcfg/get_hostname string billsloth-cyber
d-i netcfg/get_domain string neural.local

# Mirror settings
d-i mirror/country string manual
d-i mirror/http/hostname string archive.ubuntu.com
d-i mirror/http/directory string /ubuntu
d-i mirror/http/proxy string

# Clock and timezone
d-i clock-setup/utc boolean true
d-i time/zone string America/New_York
d-i clock-setup/ntp boolean true

# Partitioning - Use entire disk with LVM
d-i partman-auto/method string lvm
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-lvm/confirm boolean true
d-i partman-lvm/confirm_nooverwrite boolean true
d-i partman-auto-lvm/guided_size string max
d-i partman-auto/choose_recipe select atomic
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# Base system installation
d-i base-installer/install-recommends boolean true
d-i base-installer/kernel/image string linux-generic

# User account setup - Bill Sloth user
d-i passwd/user-fullname string Bill Sloth
d-i passwd/username string billsloth
d-i passwd/user-password password cyberpunk2077
d-i passwd/user-password-again password cyberpunk2077
d-i user-setup/allow-password-weak boolean true
d-i user-setup/encrypt-home boolean false
d-i passwd/user-default-groups string adm cdrom sudo dip plugdev lpadmin sambashare

# Package selection
tasksel tasksel/first multiselect ubuntu-desktop
d-i pkgsel/include string openssh-server curl wget git vim htop python3-pip nodejs npm
d-i pkgsel/upgrade select full-upgrade
d-i pkgsel/update-policy select unattended-upgrades

# GRUB installation
d-i grub-installer/only_debian boolean true
d-i grub-installer/with_other_os boolean true
d-i grub-installer/bootdev string default

# Finish installation
d-i finish-install/reboot_in_progress note

# Bill Sloth post-install automation
d-i preseed/late_command string \\
    in-target wget -O /tmp/billsloth-setup.sh https://raw.githubusercontent.com/How1337ItIs/billsloth/main/scripts/post-install-setup.sh; \\
    in-target chmod +x /tmp/billsloth-setup.sh; \\
    in-target /tmp/billsloth-setup.sh
"@
    
    $preseedConfig | Out-File -FilePath "$preseedDir\billsloth.seed" -Encoding UTF8
    
    Write-Host "Preseed configuration created with Bill Sloth automation" -ForegroundColor Green
}

# Create custom files and scripts for the live system
function New-CyberpunkCustomization {
    param([string]$ProjectDir)
    
    Write-Host "▒▒▒ INJECTING CYBERPUNK NEURAL INTERFACE ▒▒▒" -ForegroundColor Cyan
    Write-Host ""
    
    # Create includes.chroot directory for files to be added to the live system
    $chrootDir = "$ProjectDir\config\includes.chroot"
    New-Item -ItemType Directory -Path $chrootDir -Force | Out-Null
    
    # Create Bill Sloth directory structure
    $billSlothDir = "$chrootDir\usr\local\share\billsloth"
    New-Item -ItemType Directory -Path $billSlothDir -Force | Out-Null
    
    # Clone Bill Sloth repository into the chroot
    try {
        Write-Host "Downloading Bill Sloth automation system..." -ForegroundColor Yellow
        $tempClone = "$env:TEMP\billsloth-live-build"
        if (Test-Path $tempClone) {
            Remove-Item -Path $tempClone -Recurse -Force
        }
        git clone --depth 1 https://github.com/How1337ItIs/billsloth.git $tempClone
        Copy-Item -Path "$tempClone\*" -Destination $billSlothDir -Recurse -Force
        Remove-Item -Path $tempClone -Recurse -Force
        Write-Host "Bill Sloth system integrated into live system" -ForegroundColor Green
    }
    catch {
        Write-Host "Warning: Could not clone Bill Sloth repository: $($_.Exception.Message)" -ForegroundColor Yellow
    }
    
    # Create cyberpunk boot splash
    $splashDir = "$chrootDir\usr\share\plymouth\themes\billsloth-cyber"
    New-Item -ItemType Directory -Path $splashDir -Force | Out-Null
    
    $plymouthTheme = @"
[Plymouth Theme]
Name=Bill Sloth Cyberpunk
Description=Cyberpunk sloth neural interface boot theme
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/billsloth-cyber
ScriptFile=/usr/share/plymouth/themes/billsloth-cyber/billsloth-cyber.script
"@
    
    $plymouthTheme | Out-File -FilePath "$splashDir\billsloth-cyber.plymouth" -Encoding UTF8
    
    # Create boot script with ASCII sloth and cyberpunk effects
    $bootScript = @"
# Bill Sloth Cyberpunk Boot Script
Window.SetBackgroundTopColor(0.0, 0.0, 0.0);
Window.SetBackgroundBottomColor(0.1, 0.0, 0.2);

# Cyberpunk Sloth ASCII Art
sloth_ascii = [
"████████████████████████████████████████████████████████████████████████████████",
"██  ░▒▓█ BILL SLOTH NEURAL INTERFACE INITIALIZING █▓▒░                         ██", 
"██  ████ CYBERPUNK AUTOMATION MATRIX LOADING ████                             ██",
"████████████████████████████████████████████████████████████████████████████████",
"",
"    ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⠤⠖⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠒⠚⠛⠒⠒⠤⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀",
"    ⠀⠀⠀⠀⠀⢀⡠⠖⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⢄⠀⠀⠀⠀⠀⠀⠀",
"    ⠀⠀⠀⢀⠔⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀",
"    ⠀⠀⡰⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢆⠀⠀⠀⠀",
"",
"▓▓▓ NEURAL MATRIX SYNCHRONIZATION: 95% COMPLETE ▓▓▓"
];

# Display cyberpunk sloth art
for (i = 0; i < sloth_ascii.GetLength(); i++) {
    text = Image.Text(sloth_ascii[i], 0.0, 1.0, 0.0);
    text.SetPosition(Window.GetWidth()/2 - text.GetWidth()/2, 50 + i * 15);
}

# Matrix-style progress bar
progress_messages = [
    "░░░ INFILTRATING CORPORATE MAINFRAMES ░░░",
    "▒▒▒ BYPASSING NEURAL FIREWALLS ▒▒▒", 
    "▓▓▓ DOWNLOADING CONSCIOUSNESS UPGRADES ▓▓▓",
    "███ ACTIVATING SLOTH PROTOCOLS ███",
    "▓▓▓ CYBERPUNK ENHANCEMENT COMPLETE ▓▓▓"
];

fun progress_callback(duration, progress) {
    message_index = Math.Int(progress * progress_messages.GetLength());
    if (message_index < progress_messages.GetLength()) {
        message = Image.Text(progress_messages[message_index], 0.0, 1.0, 0.0);
        message.SetPosition(Window.GetWidth()/2 - message.GetWidth()/2, 400);
    }
}

Plymouth.SetBootProgressFunction(progress_callback);
"@
    
    $bootScript | Out-File -FilePath "$splashDir\billsloth-cyber.script" -Encoding UTF8
    
    # Create desktop background
    $wallpaperDir = "$chrootDir\usr\share\backgrounds"
    New-Item -ItemType Directory -Path $wallpaperDir -Force | Out-Null
    
    # Create cyberpunk MOTD
    $motdScript = @"
#!/bin/bash
# Bill Sloth Cyberpunk MOTD

echo -e "\033[95m"
cat << 'EOF'
████████████████████████████████████████████████████████████████████████████████
██                                                                            ██
██  ░▒▓█ WELCOME TO BILL SLOTH CYBERPUNK UBUNTU █▓▒░                           ██
██                                                                            ██
██  ████ NEURAL INTERFACE ACTIVATED ████                                      ██
██  ▓▓▓▓ AUTOMATION PROTOCOLS ONLINE ▓▓▓▓                                      ██
██                                                                            ██
████████████████████████████████████████████████████████████████████████████████
EOF
echo -e "\033[0m"

echo ""
echo -e "\033[96m▓▓▓ SYSTEM STATUS ▓▓▓\033[0m"
echo -e "\033[92m  • Bill Sloth Automation: ONLINE"
echo -e "  • Voice Control: READY"  
echo -e "  • Neural Interface: SYNCHRONIZED"
echo -e "  • Cyber Enhancements: LOADED\033[0m"
echo ""
echo -e "\033[93m░░░ QUICK START ░░░\033[0m"
echo -e "\033[97m  Run: cd /usr/local/share/billsloth && ./onboard.sh --cyberpunk\033[0m"
echo ""
"@
    
    $motdScript | Out-File -FilePath "$chrootDir\etc\update-motd.d\01-billsloth-cyber" -Encoding UTF8
    
    Write-Host "Cyberpunk customization files created" -ForegroundColor Green
}

# Create hooks for additional customization during build
function New-LiveBuildHooks {
    param([string]$ProjectDir)
    
    Write-Host "███ CREATING NEURAL BUILD HOOKS ███" -ForegroundColor Cyan
    Write-Host ""
    
    $hooksDir = "$ProjectDir\config\hooks\live"
    New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
    
    # Hook to install Claude Code and additional setup
    $claudeHook = @"
#!/bin/bash
# Bill Sloth Claude Code Installation Hook

echo "▓▓▓ Installing Claude Code Neural Interface ▓▓▓"

# Install Node.js LTS if not present
if ! command -v node &> /dev/null; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs
fi

# Install Claude Code globally
npm install -g @anthropic-ai/claude-code

# Install Oh My Zsh for cyberpunk shell
if [ ! -d /root/.oh-my-zsh ]; then
    sh -c "`$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k

# Set up Bill Sloth automation permissions
chmod +x /usr/local/share/billsloth/*.sh
chmod +x /usr/local/share/billsloth/*/*.sh

# Configure Plymouth theme
update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/billsloth-cyber/billsloth-cyber.plymouth 100
update-alternatives --set default.plymouth /usr/share/plymouth/themes/billsloth-cyber/billsloth-cyber.plymouth

# Update initramfs
update-initramfs -u

echo "░░░ Claude Code and Bill Sloth integration complete ░░░"
"@
    
    $claudeHook | Out-File -FilePath "$hooksDir\9999-billsloth-setup.hook.chroot" -Encoding UTF8
    
    Write-Host "Live-build hooks created for advanced setup" -ForegroundColor Green
}

# Execute the live-build process via WSL2
function Invoke-LiveBuildProcess {
    param([string]$ProjectDir, [string]$OutputPath)
    
    Write-Host "▓▓▓ INITIATING LIVE-BUILD NEURAL CONSTRUCTION ▓▓▓" -ForegroundColor Cyan
    Write-Host ""
    
    # Check if WSL2 is available
    try {
        $wslCheck = wsl --list --verbose 2>&1
        if ($LASTEXITCODE -ne 0) {
            throw "WSL2 not available"
        }
    }
    catch {
        Write-Host "ERROR: WSL2 required for live-build process" -ForegroundColor Red
        Write-Host "Please install WSL2 with Ubuntu and retry" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "WSL2 detected - preparing live-build environment..." -ForegroundColor Green
    
    # Convert Windows path to WSL path
    $wslProjectPath = $ProjectDir -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
    
    # Create build script for WSL2
    $buildScript = @"
#!/bin/bash
# Bill Sloth Live-Build Execution Script

set -e

echo "▓▓▓ PREPARING CYBERPUNK BUILD ENVIRONMENT ▓▓▓"

# Install live-build if not present
if ! command -v lb &> /dev/null; then
    echo "Installing live-build framework..."
    sudo apt update
    sudo apt install -y live-build git curl
fi

# Navigate to project directory
cd "$wslProjectPath"

echo "░░░ EXECUTING NEURAL MATRIX CONSTRUCTION ░░░"

# Make auto/config executable
chmod +x auto/config

# Initialize live-build configuration
./auto/config

echo "▒▒▒ BUILDING CYBERPUNK SLOTH ISO ▒▒▒"

# Build the ISO (this takes a while)
sudo lb build

echo "███ ISO CONSTRUCTION COMPLETE ███"

# Find the generated ISO
ISO_FILE=`$(find . -name "*.iso" -type f | head -1)
if [ -n "`$ISO_FILE" ]; then
    echo "✅ Generated ISO: `$ISO_FILE"
    ls -lh "`$ISO_FILE"
else
    echo "❌ No ISO file generated"
    exit 1
fi
"@
    
    $buildScriptPath = "$ProjectDir\build-iso.sh"
    $buildScript | Out-File -FilePath $buildScriptPath -Encoding UTF8
    
    # Execute build in WSL2
    Write-Host "Launching live-build process in WSL2..." -ForegroundColor Magenta
    Write-Host "This may take 20-60 minutes depending on system performance..." -ForegroundColor Yellow
    Write-Host ""
    
    try {
        $wslBuildPath = $buildScriptPath -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }
        
        # Make script executable and run
        wsl chmod +x $wslBuildPath
        wsl bash $wslBuildPath
        
        # Copy ISO back to Windows
        $generatedISO = Get-ChildItem -Path $ProjectDir -Filter "*.iso" | Select-Object -First 1
        if ($generatedISO) {
            Copy-Item -Path $generatedISO.FullName -Destination $OutputPath -Force
            Write-Host "✅ ISO copied to: $OutputPath" -ForegroundColor Green
            return $true
        } else {
            throw "No ISO file found after build"
        }
    }
    catch {
        Write-Host "❌ Live-build process failed: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# Main execution function
function New-CyberpunkSlothISO {
    Write-Host "🚀 Starting cyberpunk sloth ISO construction..." -ForegroundColor Magenta
    Write-Host ""
    
    try {
        # Initialize project
        $projectDir = Initialize-LiveBuildProject
        
        # Configure live-build
        New-CyberpunkLiveBuildConfig $projectDir
        
        # Create package lists
        New-BillSlothPackageList $projectDir
        
        # Create preseed
        New-BillSlothPreseed $projectDir
        
        # Add customizations
        New-CyberpunkCustomization $projectDir
        
        # Create hooks
        New-LiveBuildHooks $projectDir
        
        # Build ISO
        $success = Invoke-LiveBuildProcess $projectDir $OutputISO
        
        if ($success) {
            Write-Host ""
            Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
            Write-Host "██  ░▒▓█ CYBERPUNK SLOTH ISO CONSTRUCTION COMPLETE █▓▒░                        ██" -ForegroundColor Magenta  
            Write-Host "████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Magenta
            Write-Host ""
            Write-Host "🦥 BADASS CYBERPUNK SLOTH UBUNTU READY!" -ForegroundColor Green
            Write-Host "📁 Location: $OutputISO" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "✨ Features included:" -ForegroundColor Yellow
            Write-Host "   ▓▓▓ Complete Bill Sloth automation system" -ForegroundColor White
            Write-Host "   ▓▓▓ Claude Code pre-installed and configured" -ForegroundColor White
            Write-Host "   ▓▓▓ Voice control and audio tools" -ForegroundColor White
            Write-Host "   ▓▓▓ Cyberpunk boot animations and themes" -ForegroundColor White
            Write-Host "   ▓▓▓ ADHD/dyslexia optimized interface" -ForegroundColor White
            Write-Host "   ▓▓▓ Automated installation with preseed" -ForegroundColor White
            Write-Host ""
            Write-Host "🔥 Your cyberpunk sloth OS is ready to boot and automate!" -ForegroundColor Magenta
            
            return $true
        } else {
            throw "ISO construction failed"
        }
    }
    catch {
        Write-Host ""
        Write-Host "❌ CYBERPUNK ISO CONSTRUCTION FAILED ❌" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        # Cleanup temp directory
        if ($projectDir -and (Test-Path $projectDir)) {
            Write-Host "Cleaning up temporary files..." -ForegroundColor Gray
            Remove-Item -Path $projectDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

# Execute the cyberpunk sloth ISO creation
$success = New-CyberpunkSlothISO

if ($success) {
    Write-Host "🎯 Ready to create bootable USB and install your cyberpunk sloth system!" -ForegroundColor Green
    exit 0
} else {
    Write-Host "💥 ISO creation failed - check error messages above" -ForegroundColor Red
    exit 1
}