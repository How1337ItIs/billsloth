# Enhancement for MATURE_CUSTOM_ISO_SYSTEM.ps1
# Add this to the existing ISO builder to include Bill Sloth visuals

# Add to the MATURE_CUSTOM_ISO_SYSTEM.ps1 after the tools are validated:

Write-Host "🎨 Integrating Bill Sloth Enhanced Visuals..." -ForegroundColor Magenta

# Prepare assets for integration
$AssetPrep = "$PSScriptRoot\..\iso-customization\prepare_assets_for_iso.ps1"
if (Test-Path $AssetPrep) {
    & $AssetPrep -BuildDir $OutputDir
} else {
    Write-Warning "Bill Sloth asset preparation script not found at: $AssetPrep"
}

# Add Bill Sloth packages to package list
$PackageList = "$OutputDir\config\package-lists\billsloth-enhanced.list.chroot"
$PackageContent = @"
# Bill Sloth Enhanced Visual Packages
gnome-shell-extensions
gnome-tweaks
plymouth-themes
papirus-icon-theme
arc-theme
numix-gtk-theme
plank
conky-all
lolcat
neofetch
htop
btop
cmatrix
figlet
toilet
curl
wget
git
flatpak
snapd
fonts-firacode
"@

Set-Content -Path $PackageList -Value $PackageContent -Encoding UTF8

Write-Host "✅ Bill Sloth enhanced visuals integrated into ISO build!" -ForegroundColor Green
Write-Host "🎯 The ISO will now include all customizations and auto-setup!" -ForegroundColor Cyan
