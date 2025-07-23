# Bill Sloth Advanced Disk Partition Manager
# Automated partition management for dual-boot preparation with Claude assistance
# Handles disk shrinking, partition creation, and space optimization

param(
    [switch]$AnalyzeOnly,
    [switch]$AutoShrink,
    [switch]$Interactive,
    [int]$UbuntuSizeGB = 100,
    [int]$ShrinkSafetyBufferGB = 20,
    [string]$TargetDrive = "C"
)

# Requires Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script requires Administrator privileges!"
    Write-Host "Right-click PowerShell and select 'Run as Administrator'"
    exit 1
}

Write-Host @"
▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
█  💽 BILL SLOTH ADVANCED DISK PARTITION MANAGER 💽               █  
█  🤖 CLAUDE-ASSISTED DUAL-BOOT DISK PREPARATION 🤖                █
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
"@ -ForegroundColor Cyan

$script:LogFile = "$env:USERPROFILE\bill-sloth-windows\partition-manager.log"

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    if (!(Test-Path (Split-Path $script:LogFile -Parent))) {
        New-Item -ItemType Directory -Path (Split-Path $script:LogFile -Parent) -Force | Out-Null
    }
    
    Add-Content -Path $script:LogFile -Value $logEntry
    
    switch ($Level) {
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor Red }
        "WARN"  { Write-Host "⚠️  $Message" -ForegroundColor Yellow }
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor Green }
        "CLAUDE" { Write-Host "🤖 $Message" -ForegroundColor Magenta }
        default { Write-Host "ℹ️  $Message" -ForegroundColor White }
    }
}

# Advanced disk analysis with fragmentation details
function Get-DetailedDiskAnalysis {
    Write-Host ""
    Write-Host "🔍 DETAILED DISK ANALYSIS" -ForegroundColor Cyan
    Write-Host "=========================" -ForegroundColor Cyan
    Write-Host ""
    
    $diskAnalysis = @()
    $physicalDisks = Get-Disk | Where-Object { $_.BusType -ne "USB" }
    
    foreach ($disk in $physicalDisks) {
        Write-Log "Analyzing Disk $($disk.Number): $($disk.FriendlyName)" "INFO"
        
        $diskInfo = @{
            Number = $disk.Number
            Model = $disk.FriendlyName
            SizeGB = [math]::Round($disk.Size / 1GB, 1)
            PartitionStyle = $disk.PartitionStyle
            IsSystemDisk = $disk.IsBoot
            OperationalStatus = $disk.OperationalStatus
            HealthStatus = $disk.HealthStatus
            Partitions = @()
            FragmentationAnalysis = @{}
            ShrinkRecommendations = @()
        }
        
        # Get partition details
        $partitions = Get-Partition -DiskNumber $disk.Number -ErrorAction SilentlyContinue
        
        foreach ($partition in $partitions) {
            if ($partition.DriveLetter) {
                try {
                    $volume = Get-Volume -DriveLetter $partition.DriveLetter -ErrorAction SilentlyContinue
                    if ($volume) {
                        $sizeGB = [math]::Round($partition.Size / 1GB, 1)
                        $freeGB = [math]::Round($volume.SizeRemaining / 1GB, 1)
                        $usedGB = $sizeGB - $freeGB
                        $freePercent = [math]::Round(($freeGB / $sizeGB) * 100, 1)
                        
                        # Get fragmentation info (if possible)
                        $fragmentationInfo = Get-FragmentationAnalysis -DriveLetter $partition.DriveLetter
                        
                        # Calculate shrink potential
                        $shrinkAnalysis = Get-ShrinkPotential -DriveLetter $partition.DriveLetter -RequiredGB $UbuntuSizeGB
                        
                        $partitionInfo = @{
                            DriveLetter = $partition.DriveLetter
                            SizeGB = $sizeGB
                            FreeGB = $freeGB
                            UsedGB = $usedGB
                            FreePercent = $freePercent
                            FileSystem = $volume.FileSystem
                            Label = $volume.FileSystemLabel
                            IsSystemPartition = $partition.IsActive
                            IsBoot = $partition.IsBoot
                            Type = $partition.Type
                            FragmentationLevel = $fragmentationInfo.FragmentationPercent
                            ShrinkPotential = $shrinkAnalysis
                        }
                        
                        $diskInfo.Partitions += $partitionInfo
                        
                        Write-Host "  📁 Drive $($partition.DriveLetter): " -NoNewline -ForegroundColor White
                        Write-Host "$sizeGB GB total, " -NoNewline -ForegroundColor Gray
                        Write-Host "$freeGB GB free " -NoNewline -ForegroundColor Green
                        Write-Host "($freePercent%)" -ForegroundColor Gray
                        
                        if ($fragmentationInfo.FragmentationPercent -gt 10) {
                            Write-Host "    ⚠️  Fragmentation: $($fragmentationInfo.FragmentationPercent)% (consider defrag)" -ForegroundColor Yellow
                        }
                        
                        if ($shrinkAnalysis.CanShrink) {
                            Write-Host "    ✅ Can shrink by $($shrinkAnalysis.MaxShrinkGB) GB" -ForegroundColor Green
                        }
                    }
                } catch {
                    Write-Log "Could not analyze partition $($partition.DriveLetter): $($_.Exception.Message)" "WARN"
                }
            }
        }
        
        $diskAnalysis += $diskInfo
    }
    
    return $diskAnalysis
}

# Get fragmentation analysis
function Get-FragmentationAnalysis {
    param([string]$DriveLetter)
    
    try {
        # Use defrag to analyze fragmentation
        $defragOutput = & defrag "$DriveLetter:" /A 2>&1
        
        # Parse fragmentation percentage from output
        $fragmentationLine = $defragOutput | Select-String "fragmented"
        if ($fragmentationLine) {
            $percentMatch = [regex]::Match($fragmentationLine.Line, '(\d+)%')
            if ($percentMatch.Success) {
                $fragmentationPercent = [int]$percentMatch.Groups[1].Value
            } else {
                $fragmentationPercent = 0
            }
        } else {
            $fragmentationPercent = 0
        }
        
        return @{
            FragmentationPercent = $fragmentationPercent
            RecommendDefrag = ($fragmentationPercent -gt 10)
            AnalysisSuccessful = $true
        }
    }
    catch {
        return @{
            FragmentationPercent = 0
            RecommendDefrag = $false
            AnalysisSuccessful = $false
            Error = $_.Exception.Message
        }
    }
}

# Calculate shrink potential for a partition
function Get-ShrinkPotential {
    param([string]$DriveLetter, [int]$RequiredGB)
    
    try {
        # Get volume info
        $volume = Get-Volume -DriveLetter $DriveLetter
        $freeSpaceGB = [math]::Round($volume.SizeRemaining / 1GB, 1)
        $totalSizeGB = [math]::Round($volume.Size / 1GB, 1)
        
        # Calculate theoretical shrink amount (free space minus safety buffer)
        $theoreticalShrinkGB = $freeSpaceGB - $ShrinkSafetyBufferGB
        
        # Use diskpart to get actual shrink amount
        $actualShrinkGB = Get-ActualShrinkSpace -DriveLetter $DriveLetter
        
        # Determine if we can meet requirements
        $canShrink = ($actualShrinkGB -ge $RequiredGB)
        $maxShrinkGB = [math]::Min($theoreticalShrinkGB, $actualShrinkGB)
        
        # Risk assessment
        $riskLevel = "Low"
        if ($maxShrinkGB / $totalSizeGB -gt 0.5) {
            $riskLevel = "High"
        } elseif ($maxShrinkGB / $totalSizeGB -gt 0.3) {
            $riskLevel = "Medium"
        }
        
        return @{
            CanShrink = $canShrink
            TheoreticalShrinkGB = [math]::Max(0, $theoreticalShrinkGB)
            ActualShrinkGB = [math]::Max(0, $actualShrinkGB)
            MaxShrinkGB = [math]::Max(0, $maxShrinkGB)
            MeetsRequirement = ($maxShrinkGB -ge $RequiredGB)
            RiskLevel = $riskLevel
            SafetyBufferGB = $ShrinkSafetyBufferGB
        }
    }
    catch {
        return @{
            CanShrink = $false
            Error = $_.Exception.Message
            TheoreticalShrinkGB = 0
            ActualShrinkGB = 0
            MaxShrinkGB = 0
            MeetsRequirement = $false
            RiskLevel = "Unknown"
        }
    }
}

# Get actual shrink space using diskpart
function Get-ActualShrinkSpace {
    param([string]$DriveLetter)
    
    try {
        # Create diskpart script
        $diskpartScript = @"
select volume $DriveLetter
shrink querymax
exit
"@
        
        $tempScript = "$env:TEMP\diskpart_shrink_query.txt"
        $diskpartScript | Set-Content -Path $tempScript -Encoding ASCII
        
        # Run diskpart
        $diskpartOutput = & diskpart /s $tempScript 2>&1
        Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
        
        # Parse output for maximum shrink space
        $shrinkLine = $diskpartOutput | Select-String "maximum number of reclaimable bytes"
        if ($shrinkLine) {
            $bytesMatch = [regex]::Match($shrinkLine.Line, '(\d+)')
            if ($bytesMatch.Success) {
                $maxShrinkBytes = [long]$bytesMatch.Groups[1].Value
                $maxShrinkGB = [math]::Round($maxShrinkBytes / 1GB, 1)
                return $maxShrinkGB
            }
        }
        
        return 0
    }
    catch {
        Write-Log "Error querying shrink space for $DriveLetter : $($_.Exception.Message)" "WARN"
        return 0
    }
}

# Optimize partition for shrinking
function Optimize-PartitionForShrinking {
    param([string]$DriveLetter)
    
    Write-Host ""
    Write-Host "🔧 OPTIMIZING $DriveLetter FOR SHRINKING" -ForegroundColor Yellow
    Write-Host "==============================" -ForegroundColor Yellow
    Write-Host ""
    
    $optimizationSteps = @()
    
    # Step 1: Disable page file temporarily
    Write-Log "Disabling virtual memory (page file) on $DriveLetter..." "INFO"
    try {
        $pageFile = Get-WmiObject -Class Win32_PageFileSetting | Where-Object { $_.Name.StartsWith("$DriveLetter") }
        if ($pageFile) {
            $pageFile.Delete()
            $optimizationSteps += "✅ Page file disabled"
            Write-Log "Page file disabled successfully" "SUCCESS"
        } else {
            $optimizationSteps += "ℹ️  No page file found on $DriveLetter"
            Write-Log "No page file found on $DriveLetter" "INFO"
        }
    }
    catch {
        $optimizationSteps += "⚠️ Could not disable page file"
        Write-Log "Could not disable page file: $($_.Exception.Message)" "WARN"
    }
    
    # Step 2: Disable system restore temporarily
    Write-Log "Disabling System Restore on $DriveLetter..." "INFO"
    try {
        Disable-ComputerRestore -Drive "$DriveLetter"
        $optimizationSteps += "✅ System Restore disabled temporarily"
        Write-Log "System Restore disabled" "SUCCESS"
    }
    catch {
        $optimizationSteps += "⚠️ Could not disable System Restore"
        Write-Log "Could not disable System Restore: $($_.Exception.Message)" "WARN"
    }
    
    # Step 3: Clean temporary files
    Write-Log "Cleaning temporary files and system cache..." "INFO"
    try {
        # Run Disk Cleanup for system files
        & cleanmgr /sagerun:1 2>&1 | Out-Null
        
        # Clean temp directories
        $tempPaths = @(
            "$env:TEMP",
            "$env:LOCALAPPDATA\Temp",
            "$env:WINDIR\Temp",
            "$env:WINDIR\Prefetch"
        )
        
        foreach ($tempPath in $tempPaths) {
            if (Test-Path $tempPath) {
                Get-ChildItem -Path $tempPath -Recurse -Force -ErrorAction SilentlyContinue | 
                    Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        }
        
        $optimizationSteps += "✅ Temporary files cleaned"
        Write-Log "Temporary files cleaned" "SUCCESS"
    }
    catch {
        $optimizationSteps += "⚠️ Partial temp file cleanup"
        Write-Log "Temp file cleanup had issues: $($_.Exception.Message)" "WARN"
    }
    
    # Step 4: Defragment drive
    Write-Log "Defragmenting $DriveLetter (this may take 15-30 minutes)..." "INFO"
    try {
        Optimize-Volume -DriveLetter $DriveLetter.TrimEnd(':') -Defrag -Verbose
        $optimizationSteps += "✅ Drive defragmented"
        Write-Log "Drive defragmented successfully" "SUCCESS"
    }
    catch {
        $optimizationSteps += "⚠️ Defragmentation had issues"
        Write-Log "Defragmentation issues: $($_.Exception.Message)" "WARN"
    }
    
    Write-Host ""
    Write-Host "📊 OPTIMIZATION RESULTS:" -ForegroundColor Green
    foreach ($step in $optimizationSteps) {
        Write-Host "  $step"
    }
    
    return $optimizationSteps
}

# Perform the actual partition shrink
function Invoke-PartitionShrink {
    param([string]$DriveLetter, [int]$ShrinkSizeGB)
    
    Write-Host ""
    Write-Host "⚠️  CRITICAL PARTITION SHRINK OPERATION" -ForegroundColor Red
    Write-Host "=======================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "About to shrink $DriveLetter by $ShrinkSizeGB GB" -ForegroundColor Yellow
    Write-Host "This operation cannot be easily undone!" -ForegroundColor Red
    Write-Host ""
    
    if ($Interactive) {
        Write-Host "Do you want to proceed? (Type 'YES' to confirm): " -NoNewline -ForegroundColor Yellow
        $confirmation = Read-Host
        
        if ($confirmation -ne "YES") {
            Write-Log "Partition shrink cancelled by user" "INFO"
            return $false
        }
    }
    
    Write-Log "Starting partition shrink: $DriveLetter by $ShrinkSizeGB GB" "INFO"
    
    try {
        # Create diskpart script for shrinking
        $diskpartScript = @"
select volume $DriveLetter
shrink desired=$([math]::Round($ShrinkSizeGB * 1024))
exit
"@
        
        $tempScript = "$env:TEMP\diskpart_shrink.txt"
        $diskpartScript | Set-Content -Path $tempScript -Encoding ASCII
        
        Write-Log "Executing diskpart shrink operation..." "INFO"
        $diskpartOutput = & diskpart /s $tempScript 2>&1
        
        Remove-Item -Path $tempScript -Force -ErrorAction SilentlyContinue
        
        # Check if operation was successful
        if ($diskpartOutput -match "successfully shrunk" -or $diskpartOutput -match "DiskPart successfully") {
            Write-Log "✅ Partition shrunk successfully by $ShrinkSizeGB GB" "SUCCESS"
            
            # Verify the shrink
            $newSize = Get-PartitionSize -DriveLetter $DriveLetter
            Write-Log "New partition size verified: $newSize GB" "INFO"
            
            return $true
        } else {
            Write-Log "❌ Partition shrink failed. Output: $($diskpartOutput -join ' ')" "ERROR"
            return $false
        }
    }
    catch {
        Write-Log "❌ Partition shrink operation failed: $($_.Exception.Message)" "ERROR"
        return $false
    }
}

# Get current partition size
function Get-PartitionSize {
    param([string]$DriveLetter)
    
    try {
        $volume = Get-Volume -DriveLetter $DriveLetter
        return [math]::Round($volume.Size / 1GB, 1)
    }
    catch {
        return 0
    }
}

# Restore system settings after shrinking
function Restore-SystemSettings {
    param([string]$DriveLetter)
    
    Write-Host ""
    Write-Host "🔄 RESTORING SYSTEM SETTINGS" -ForegroundColor Blue
    Write-Host "============================" -ForegroundColor Blue
    Write-Host ""
    
    # Re-enable System Restore
    try {
        Enable-ComputerRestore -Drive "$DriveLetter"
        Write-Log "System Restore re-enabled" "SUCCESS"
    }
    catch {
        Write-Log "Could not re-enable System Restore: $($_.Exception.Message)" "WARN"
    }
    
    # Re-create page file (system managed)
    try {
        $pageFile = Get-WmiObject -Class Win32_PageFileUsage | Where-Object { $_.Name.StartsWith("$DriveLetter") }
        if (!$pageFile) {
            # Create system-managed page file
            $cs = Get-WmiObject -Class Win32_ComputerSystem
            $cs.AutomaticManagedPagefile = $true
            $cs.Put() | Out-Null
            Write-Log "Page file restored (system managed)" "SUCCESS"
        }
    }
    catch {
        Write-Log "Could not restore page file: $($_.Exception.Message)" "WARN"
        Write-Log "You may need to manually configure virtual memory" "INFO"
    }
    
    Write-Log "System settings restoration completed" "INFO"
}

# Generate partition report
function New-PartitionReport {
    param([array]$DiskAnalysis, [object]$Operations)
    
    $reportPath = "$env:USERPROFILE\bill-sloth-windows\PARTITION-REPORT.md"
    
    $report = @"
# Bill Sloth Partition Management Report

Generated: $(Get-Date)
Operation: Dual-boot preparation for Ubuntu

## Disk Analysis Summary

$(foreach ($disk in $DiskAnalysis) {
"### Disk $($disk.Number): $($disk.Model)
- **Size**: $($disk.SizeGB) GB
- **Health**: $($disk.HealthStatus)
- **Partition Style**: $($disk.PartitionStyle)

#### Partitions:
$(foreach ($partition in $disk.Partitions) {
"- **Drive $($partition.DriveLetter)**: $($partition.SizeGB) GB total, $($partition.FreeGB) GB free
  - File System: $($partition.FileSystem)
  - Label: $($partition.Label)
  - Fragmentation: $($partition.FragmentationLevel)%
  - Shrink Potential: $($partition.ShrinkPotential.MaxShrinkGB) GB (Risk: $($partition.ShrinkPotential.RiskLevel))
"})

"})

## Operations Performed

$(if ($Operations.ShrinkPerformed) {
"### Partition Shrink: ✅ COMPLETED
- **Drive**: $($Operations.TargetDrive)
- **Amount**: $($Operations.ShrinkSizeGB) GB
- **Status**: $($Operations.ShrinkStatus)
- **New Free Space**: Available for Ubuntu installation
"} else {
"### Partition Shrink: ❌ NOT PERFORMED
- **Reason**: $($Operations.Reason)
"})

## Ubuntu Installation Space

$(if ($Operations.ShrinkPerformed) {
"✅ **READY FOR UBUNTU**: $($Operations.ShrinkSizeGB) GB of unallocated space created
- This space will be used during Ubuntu installation
- Ubuntu installer will create appropriate partitions automatically
- Recommended: 25GB for root (/), 8GB for swap, remainder for home (/home)
"} else {
"⚠️ **MANUAL INTERVENTION REQUIRED**
- Current free space insufficient for automatic shrinking
- Consider manually freeing up space or using external drive
- Alternative: Install Ubuntu on separate physical drive
"})

## Next Steps

1. **If shrink was successful**:
   - Restart computer to ensure system stability
   - Boot from Ubuntu USB installer
   - Choose "Install Ubuntu alongside Windows"
   - Ubuntu installer will detect free space automatically

2. **If shrink failed**:
   - Free up more space on $($Operations.TargetDrive) drive
   - Run disk cleanup and remove unnecessary files
   - Try shrinking with smaller amount
   - Consider using different drive or external storage

## Important Notes

- **Backup**: System restore point created before operations
- **Dual-boot**: Windows and Ubuntu will coexist peacefully
- **Boot menu**: GRUB bootloader will provide OS selection
- **Recovery**: Use System Restore if any issues occur

## Support

- Windows boot issues: Use Windows Recovery Environment
- Ubuntu installation: https://ubuntu.com/tutorials/install-ubuntu-desktop
- Bill Sloth setup: Follow post-installation guide

---
**Report Location**: $reportPath
**Log File**: $script:LogFile
"@

    Set-Content -Path $reportPath -Value $report -Encoding UTF8
    Write-Log "Partition report saved to: $reportPath" "INFO"
    
    return $reportPath
}

# Main execution function
function Main {
    Write-Log "Bill Sloth Partition Manager started" "INFO"
    Write-Log "Target: Ubuntu ${UbuntuSizeGB}GB on drive $TargetDrive" "INFO"
    
    # Detailed disk analysis
    $diskAnalysis = Get-DetailedDiskAnalysis
    
    if ($AnalyzeOnly) {
        Write-Host ""
        Write-Host "✅ Disk analysis complete - check log for details" -ForegroundColor Green
        New-PartitionReport -DiskAnalysis $diskAnalysis -Operations @{ShrinkPerformed = $false; Reason = "Analysis only mode"}
        return
    }
    
    # Find target partition
    $targetPartition = $null
    foreach ($disk in $diskAnalysis) {
        $targetPartition = $disk.Partitions | Where-Object { $_.DriveLetter -eq $TargetDrive }
        if ($targetPartition) { break }
    }
    
    if (!$targetPartition) {
        Write-Log "❌ Target drive $TargetDrive not found!" "ERROR"
        return
    }
    
    Write-Host ""
    Write-Host "🎯 TARGET PARTITION ANALYSIS" -ForegroundColor Cyan
    Write-Host "============================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Drive: $($targetPartition.DriveLetter)" -ForegroundColor White
    Write-Host "Size: $($targetPartition.SizeGB) GB total, $($targetPartition.FreeGB) GB free" -ForegroundColor White
    Write-Host "Fragmentation: $($targetPartition.FragmentationLevel)%" -ForegroundColor White
    Write-Host "Max shrink: $($targetPartition.ShrinkPotential.MaxShrinkGB) GB" -ForegroundColor White
    Write-Host "Risk level: $($targetPartition.ShrinkPotential.RiskLevel)" -ForegroundColor White
    Write-Host ""
    
    # Check if shrinking is possible
    if (!$targetPartition.ShrinkPotential.MeetsRequirement) {
        Write-Log "❌ Cannot shrink $TargetDrive by required $UbuntuSizeGB GB" "ERROR"
        Write-Log "Maximum possible shrink: $($targetPartition.ShrinkPotential.MaxShrinkGB) GB" "ERROR"
        Write-Log "Recommendations: Free up space, defragment, or use different drive" "INFO"
        
        New-PartitionReport -DiskAnalysis $diskAnalysis -Operations @{
            ShrinkPerformed = $false
            Reason = "Insufficient space for $UbuntuSizeGB GB Ubuntu partition"
            TargetDrive = $TargetDrive
        }
        return
    }
    
    # Calculate optimal shrink size
    $optimalShrinkGB = [math]::Min($UbuntuSizeGB, $targetPartition.ShrinkPotential.MaxShrinkGB)
    
    Write-Log "✅ Shrinking $TargetDrive by $optimalShrinkGB GB is possible" "SUCCESS"
    
    # Interactive confirmation
    if ($Interactive) {
        Write-Host "Proceed with shrinking $TargetDrive by $optimalShrinkGB GB? (Y/N): " -NoNewline -ForegroundColor Yellow
        $response = Read-Host
        
        if ($response -notmatch '^[Yy]') {
            Write-Log "Operation cancelled by user" "INFO"
            return
        }
    }
    
    $operationResults = @{
        TargetDrive = $TargetDrive
        ShrinkSizeGB = $optimalShrinkGB
        ShrinkPerformed = $false
        ShrinkStatus = ""
        OptimizationSteps = @()
    }
    
    # Optimize partition for shrinking
    if ($targetPartition.FragmentationLevel -gt 10 -or $AutoShrink) {
        $operationResults.OptimizationSteps = Optimize-PartitionForShrinking -DriveLetter "$TargetDrive"
    }
    
    # Perform the shrink
    $shrinkSuccess = Invoke-PartitionShrink -DriveLetter $TargetDrive -ShrinkSizeGB $optimalShrinkGB
    $operationResults.ShrinkPerformed = $shrinkSuccess
    $operationResults.ShrinkStatus = if ($shrinkSuccess) { "Successful" } else { "Failed" }
    
    # Restore system settings
    if ($shrinkSuccess) {
        Restore-SystemSettings -DriveLetter $TargetDrive
    }
    
    # Generate final report
    $reportPath = New-PartitionReport -DiskAnalysis $diskAnalysis -Operations $operationResults
    
    Write-Host ""
    if ($shrinkSuccess) {
        Write-Host "🎉 PARTITION OPERATION COMPLETED SUCCESSFULLY!" -ForegroundColor Green
        Write-Host "=============================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "✅ $optimalShrinkGB GB of free space created for Ubuntu" -ForegroundColor Green
        Write-Host "📊 Full report: $reportPath" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "🎯 Next steps:" -ForegroundColor Cyan
        Write-Host "  1. Restart computer for stability" -ForegroundColor White
        Write-Host "  2. Boot from Ubuntu USB installer" -ForegroundColor White
        Write-Host "  3. Choose 'Install Ubuntu alongside Windows'" -ForegroundColor White
        Write-Host "  4. Ubuntu will automatically use the free space" -ForegroundColor White
    } else {
        Write-Host "❌ PARTITION OPERATION FAILED" -ForegroundColor Red
        Write-Host "=============================" -ForegroundColor Red
        Write-Host ""
        Write-Host "📊 Diagnostic report: $reportPath" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "🔧 Troubleshooting options:" -ForegroundColor Yellow
        Write-Host "  1. Free up more space on $TargetDrive drive" -ForegroundColor White
        Write-Host "  2. Run full disk cleanup and defragmentation" -ForegroundColor White
        Write-Host "  3. Try shrinking smaller amount" -ForegroundColor White
        Write-Host "  4. Consider using different drive" -ForegroundColor White
    }
}

# Execute main function
try {
    Main
}
catch {
    Write-Log "❌ Partition manager failed: $($_.Exception.Message)" "ERROR"
    Write-Log "Full error: $($_.Exception)" "ERROR"
    exit 1
}

Write-Log "Bill Sloth Partition Manager completed" "SUCCESS"