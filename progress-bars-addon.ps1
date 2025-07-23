# Bill Sloth Progress Bar Enhancement for Claude Code Integration
# Adds visual progress tracking for all major operations

# Enhanced progress bar function with Claude Code status reporting
function Show-ProgressWithStatus {
    param(
        [string]$Activity,
        [string]$Status,
        [int]$PercentComplete,
        [string]$CurrentOperation = "",
        [string]$ClaudeMessage = "",
        [switch]$WriteToFile
    )
    
    # Standard PowerShell progress bar
    Write-Progress -Activity $Activity -Status $Status -PercentComplete $PercentComplete -CurrentOperation $CurrentOperation
    
    # Claude Code status output
    if ($ClaudeMessage) {
        Write-Host "CLAUDE_STATUS: $ClaudeMessage" -ForegroundColor Magenta
    }
    
    # Write status to temp file for Claude Code monitoring
    if ($WriteToFile) {
        $statusFile = "$env:TEMP\bill-sloth-status.json"
        $statusData = @{
            timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            activity = $Activity
            status = $Status
            percent = $PercentComplete
            operation = $CurrentOperation
            claude_message = $ClaudeMessage
        }
        
        $statusData | ConvertTo-Json | Set-Content -Path $statusFile -Encoding UTF8
    }
}

# Enhanced download function with progress tracking
function Download-WithProgress {
    param([string]$Url, [string]$OutputPath, [string]$Description)
    
    try {
        $webClient = New-Object System.Net.WebClient
        
        # Register progress event
        $webClient.add_DownloadProgressChanged({
            param($sender, $e)
            $percent = $e.ProgressPercentage
            $received = [math]::Round($e.BytesReceived / 1MB, 1)
            $total = [math]::Round($e.TotalBytesToReceive / 1MB, 1)
            
            Show-ProgressWithStatus -Activity "Downloading $Description" -Status "Progress: $percent%" -PercentComplete $percent -CurrentOperation "$received MB of $total MB" -ClaudeMessage "I'm downloading $Description... $percent% complete ($received MB / $total MB)" -WriteToFile
        })
        
        # Start download
        Show-ProgressWithStatus -Activity "Downloading $Description" -Status "Starting download..." -PercentComplete 0 -ClaudeMessage "I'm starting to download $Description from the repository..." -WriteToFile
        
        $downloadTask = $webClient.DownloadFileTaskAsync($Url, $OutputPath)
        
        while (-not $downloadTask.IsCompleted) {
            Start-Sleep -Milliseconds 100
        }
        
        if ($downloadTask.Exception) {
            throw $downloadTask.Exception.InnerException
        }
        
        Show-ProgressWithStatus -Activity "Downloading $Description" -Status "Complete" -PercentComplete 100 -ClaudeMessage "✅ Successfully downloaded $Description!" -WriteToFile
        
        return $true
    }
    catch {
        Show-ProgressWithStatus -Activity "Downloading $Description" -Status "Failed" -PercentComplete 0 -ClaudeMessage "❌ Failed to download $Description: $($_.Exception.Message)" -WriteToFile
        return $false
    }
    finally {
        if ($webClient) { $webClient.Dispose() }
        Write-Progress -Activity "Downloading $Description" -Completed
    }
}

# Disk operation progress tracker
function Show-DiskProgress {
    param([string]$Operation, [string]$Drive, [int]$PercentComplete)
    
    $claudeMessage = switch ($Operation) {
        "Defragment" { "I'm defragmenting your $Drive drive to optimize it for partitioning... $PercentComplete% complete" }
        "ShrinkPartition" { "I'm safely shrinking your $Drive partition to make room for Ubuntu... $PercentComplete% complete" }
        "CheckDisk" { "I'm checking your $Drive drive for errors before partitioning... $PercentComplete% complete" }
        "CreatePartition" { "I'm creating the Ubuntu partition on $Drive... $PercentComplete% complete" }
        default { "Working on $Operation for $Drive... $PercentComplete% complete" }
    }
    
    Show-ProgressWithStatus -Activity "Disk Management" -Status "$Operation on $Drive" -PercentComplete $PercentComplete -ClaudeMessage $claudeMessage -WriteToFile
}

# USB creation progress tracker
function Show-USBProgress {
    param([string]$Stage, [int]$PercentComplete, [string]$Details = "")
    
    $stageMessages = @{
        "Format" = "I'm formatting the USB drive to prepare it for Ubuntu..."
        "CopyFiles" = "I'm copying Ubuntu files to the USB drive..."
        "MakeBootable" = "I'm making the USB drive bootable..."
        "AddBillSloth" = "I'm adding Bill Sloth integration files to the USB..."
        "Verify" = "I'm verifying the bootable USB was created correctly..."
    }
    
    $claudeMessage = "$($stageMessages[$Stage]) $PercentComplete% complete"
    if ($Details) { $claudeMessage += " ($Details)" }
    
    Show-ProgressWithStatus -Activity "Creating Ubuntu USB" -Status "$Stage" -PercentComplete $PercentComplete -ClaudeMessage $claudeMessage -WriteToFile
}

# System analysis progress tracker  
function Show-AnalysisProgress {
    param([string]$Component, [int]$PercentComplete)
    
    $componentMessages = @{
        "Hardware" = "I'm analyzing your computer's hardware configuration..."
        "Disks" = "I'm examining your disk drives and partitions..."
        "UEFI" = "I'm checking your system's firmware type (UEFI vs BIOS)..."
        "Space" = "I'm calculating available space for Ubuntu installation..."
        "Compatibility" = "I'm verifying dual-boot compatibility..."
        "Recommendations" = "I'm generating personalized setup recommendations..."
    }
    
    $claudeMessage = "$($componentMessages[$Component]) $PercentComplete% complete"
    
    Show-ProgressWithStatus -Activity "System Analysis" -Status "Analyzing $Component" -PercentComplete $PercentComplete -ClaudeMessage $claudeMessage -WriteToFile
}

# Installation stage tracker
function Show-InstallationStage {
    param([string]$Stage, [string]$Description, [int]$StageNumber, [int]$TotalStages)
    
    $overallPercent = [math]::Round(($StageNumber / $TotalStages) * 100, 0)
    
    $stageDescriptions = @{
        "SystemPrep" = "I'm preparing your Windows system for dual-boot setup..."
        "PartitionPrep" = "I'm preparing disk partitions for Ubuntu installation..."
        "ISODownload" = "I'm downloading the Ubuntu installation files..."
        "USBCreation" = "I'm creating your bootable Ubuntu USB drive..."
        "Documentation" = "I'm generating your personalized installation guide..."
        "Recovery" = "I'm creating emergency recovery tools..."
        "Completion" = "I'm finalizing the setup and preparing next steps..."
    }
    
    $claudeMessage = $stageDescriptions[$Stage]
    if ($Description) { $claudeMessage += " $Description" }
    
    Show-ProgressWithStatus -Activity "Bill Sloth Dual-Boot Setup" -Status "Stage $StageNumber of $TotalStages: $Stage" -PercentComplete $overallPercent -CurrentOperation $Description -ClaudeMessage $claudeMessage -WriteToFile
}

# Error reporting with Claude integration
function Report-ErrorToClaude {
    param([string]$Operation, [string]$ErrorMessage, [string]$Suggestion = "")
    
    $claudeMessage = "❌ I encountered an error during $Operation`: $ErrorMessage"
    if ($Suggestion) {
        $claudeMessage += " 💡 Suggestion: $Suggestion"
    }
    
    Show-ProgressWithStatus -Activity "Error Recovery" -Status "Error in $Operation" -PercentComplete 0 -ClaudeMessage $claudeMessage -WriteToFile
    
    # Write detailed error to log
    $errorFile = "$env:TEMP\bill-sloth-errors.log"
    $errorEntry = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        operation = $Operation
        error = $ErrorMessage
        suggestion = $Suggestion
    }
    
    Add-Content -Path $errorFile -Value ($errorEntry | ConvertTo-Json)
}

# Success reporting
function Report-SuccessToClaude {
    param([string]$Operation, [string]$Details = "", [string]$NextStep = "")
    
    $claudeMessage = "✅ Successfully completed $Operation"
    if ($Details) { $claudeMessage += ": $Details" }
    if ($NextStep) { $claudeMessage += " 🎯 Next: $NextStep" }
    
    Show-ProgressWithStatus -Activity "Success" -Status "$Operation Complete" -PercentComplete 100 -ClaudeMessage $claudeMessage -WriteToFile
}

# Export functions for use in other scripts
Export-ModuleMember -Function Show-ProgressWithStatus, Download-WithProgress, Show-DiskProgress, Show-USBProgress, Show-AnalysisProgress, Show-InstallationStage, Report-ErrorToClaude, Report-SuccessToClaude