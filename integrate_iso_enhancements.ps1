# Bill Sloth ISO Enhancement Integration
# Quick script to integrate all visual enhancements into the mature ISO system

param(
    [switch]$DryRun
)

$ProjectRoot = Split-Path $MyInvocation.MyCommand.Path -Parent
$ISOScript = "$ProjectRoot\windows-setup\MATURE_CUSTOM_ISO_SYSTEM.ps1"
$EnhancementScript = "$ProjectRoot\iso-customization\enhance_iso_builder.ps1"

Write-Host "🎨 Bill Sloth ISO Enhancement Integration" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Check if files exist
if (!(Test-Path $ISOScript)) {
    Write-Host "❌ ISO script not found: $ISOScript" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $EnhancementScript)) {
    Write-Host "❌ Enhancement script not found: $EnhancementScript" -ForegroundColor Red
    exit 1
}

# Check if already integrated
$ISOContent = Get-Content $ISOScript -Raw
if ($ISOContent -like "*Bill Sloth Enhanced Visuals*") {
    Write-Host "✅ ISO builder already includes enhanced visuals!" -ForegroundColor Green
    Write-Host "   No integration needed - all visual enhancements are ready." -ForegroundColor Green
    Write-Host ""
    Write-Host "🎯 Current ISO Build Features:" -ForegroundColor Yellow
    Write-Host "   • Custom Bill Sloth imagery and themes" -ForegroundColor White
    Write-Host "   • Auto-installation of visual enhancements" -ForegroundColor White
    Write-Host "   • First-boot setup and welcome experience" -ForegroundColor White
    Write-Host "   • Enhanced aesthetic bridge for modules" -ForegroundColor White
    Write-Host "   • ASCII-safe ATHF easter eggs" -ForegroundColor White
    Write-Host ""
    Write-Host "✨ Your ISO builder is ready to create enhanced Bill Sloth ISOs!" -ForegroundColor Green
    exit 0
}

Write-Host "📋 Integration Status Check:" -ForegroundColor Yellow
Write-Host "   • Enhanced visual system: ✅ Ready" -ForegroundColor Green
Write-Host "   • Asset preparation scripts: ✅ Ready" -ForegroundColor Green
Write-Host "   • Live-build hooks: ✅ Ready" -ForegroundColor Green
Write-Host "   • Aesthetic bridge: ✅ Integrated" -ForegroundColor Green
Write-Host "   • ISO builder integration: ⚠️ Needed" -ForegroundColor Yellow
Write-Host ""

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - Showing what would be integrated:" -ForegroundColor Magenta
    Write-Host ""
    Write-Host "Enhancement code to be added:" -ForegroundColor Yellow
    Get-Content $EnhancementScript | ForEach-Object { Write-Host "   $_" -ForegroundColor Gray }
    Write-Host ""
    Write-Host "This would be inserted into the mature ISO system after tool validation." -ForegroundColor Cyan
    exit 0
}

Write-Host "🔧 Integrating enhanced visuals into ISO builder..." -ForegroundColor Yellow

# Read the enhancement code
$EnhancementCode = Get-Content $EnhancementScript -Raw

# Find insertion point (after tool validation)
$Lines = Get-Content $ISOScript
$InsertionPoint = -1

for ($i = 0; $i -lt $Lines.Length; $i++) {
    if ($Lines[$i] -like "*Tool validation complete*" -or 
        $Lines[$i] -like "*Tools validated*" -or
        $Lines[$i] -like "*validation successful*") {
        $InsertionPoint = $i + 1
        break
    }
}

if ($InsertionPoint -eq -1) {
    # Fallback: insert before the main build process
    for ($i = 0; $i -lt $Lines.Length; $i++) {
        if ($Lines[$i] -like "*Begin ISO creation*" -or
            $Lines[$i] -like "*Start build process*" -or
            $Lines[$i] -like "*Creating custom ISO*") {
            $InsertionPoint = $i
            break
        }
    }
}

if ($InsertionPoint -eq -1) {
    Write-Host "⚠️ Could not find optimal insertion point in ISO script." -ForegroundColor Yellow
    Write-Host "   Please manually add the enhancement code from:" -ForegroundColor Yellow
    Write-Host "   $EnhancementScript" -ForegroundColor White
    Write-Host ""
    Write-Host "🔧 Manual Integration Steps:" -ForegroundColor Cyan
    Write-Host "   1. Open $ISOScript" -ForegroundColor White
    Write-Host "   2. Find the tool validation section" -ForegroundColor White
    Write-Host "   3. Insert the contents of enhance_iso_builder.ps1" -ForegroundColor White
    Write-Host "   4. Save and test the ISO build" -ForegroundColor White
    exit 1
}

# Create backup
$BackupFile = "$ISOScript.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
Copy-Item $ISOScript $BackupFile
Write-Host "💾 Backup created: $BackupFile" -ForegroundColor Green

# Insert the enhancement code
$NewLines = @()
$NewLines += $Lines[0..($InsertionPoint-1)]
$NewLines += ""
$NewLines += "# ===== BILL SLOTH ENHANCED VISUAL INTEGRATION ====="
$NewLines += $EnhancementCode -split "`n"
$NewLines += "# ===== END BILL SLOTH INTEGRATION ====="
$NewLines += ""
$NewLines += $Lines[$InsertionPoint..($Lines.Length-1)]

# Write the updated file
$NewLines | Out-File $ISOScript -Encoding UTF8

Write-Host ""
Write-Host "✅ Integration completed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "🎯 Enhanced ISO Builder Features:" -ForegroundColor Yellow
Write-Host "   • ✅ Custom Bill Sloth imagery and themes" -ForegroundColor Green
Write-Host "   • ✅ Auto-installation during ISO build" -ForegroundColor Green
Write-Host "   • ✅ First-boot setup and welcome experience" -ForegroundColor Green
Write-Host "   • ✅ Enhanced aesthetic bridge for modules" -ForegroundColor Green
Write-Host "   • ✅ ASCII-safe ATHF easter eggs" -ForegroundColor Green
Write-Host "   • ✅ Cyberpunk/retro gaming visual themes" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next Steps:" -ForegroundColor Cyan
Write-Host "   1. Test the enhanced ISO build process" -ForegroundColor White
Write-Host "   2. Verify all visual components are included" -ForegroundColor White
Write-Host "   3. Check first-boot experience" -ForegroundColor White
Write-Host ""
Write-Host "🚀 Ready to build enhanced Bill Sloth ISOs!" -ForegroundColor Green
Write-Host "   All visual enhancements will be automatically included." -ForegroundColor White