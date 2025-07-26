# Prepare Bill Sloth Assets for ISO Integration
param(
    [Parameter(Mandatory=$true)]
    [string]$BuildDir
)

$AssetSource = Split-Path $MyInvocation.MyCommand.Path -Parent
$AssetTarget = "$BuildDir\config\includes.chroot\tmp\bill-sloth-assets"

Write-Host "📦 Preparing Bill Sloth assets for ISO integration..." -ForegroundColor Green

# Create asset directories in build
New-Item -ItemType Directory -Path "$AssetTarget\backgrounds" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-4.0" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-3.0" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\icons" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\sounds" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\plymouth" -Force | Out-Null
New-Item -ItemType Directory -Path "$AssetTarget\grub" -Force | Out-Null

# Copy all assets
Copy-Item "$AssetSource\assets\*" "$AssetTarget\backgrounds\" -Force
Copy-Item "$AssetSource\themes\cyberpunk\*" "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-4.0\" -Force
Copy-Item "$AssetSource\themes\cyberpunk\*" "$AssetTarget\themes\Bill-Sloth-Cyberpunk\gtk-3.0\" -Force
Copy-Item "$AssetSource\icons\*" "$AssetTarget\icons\" -Force
Copy-Item "$AssetSource\sounds\*" "$AssetTarget\sounds\" -Force
Copy-Item "$AssetSource\animations\*" "$AssetTarget\plymouth\" -Force
Copy-Item "$AssetSource\grub\*" "$AssetTarget\grub\" -Force

# Copy Bill Sloth system files
$ProjectRoot = Split-Path $AssetSource -Parent
Copy-Item "$ProjectRoot\bill_command_center.sh" "$AssetTarget\" -Force
Copy-Item "$ProjectRoot\lib" "$AssetTarget\" -Recurse -Force
Copy-Item "$ProjectRoot\modules" "$AssetTarget\" -Recurse -Force

Write-Host "✅ Assets prepared for ISO integration!" -ForegroundColor Green
Write-Host "📁 Assets location: $AssetTarget" -ForegroundColor Cyan
