# Token-Efficient Claude Code Integration for Bill Sloth Setup
# Optimized for Pro subscription token conservation

param(
    [string]$ClaudeBinary = "claude",
    [string]$SessionContext = "",
    [switch]$DryRun
)

# Token-efficient Claude prompt templates
$script:EfficientPrompts = @{
    "system_assessment" = @"
Analyze this Windows system data for Ubuntu dual-boot compatibility. Respond in JSON format only:

SYSTEM_DATA:
{system_json}

Required JSON response:
{
  "compatibility": "excellent|good|fair|poor",
  "critical_issues": ["issue1", "issue2"],
  "recommendations": ["rec1", "rec2"],
  "partition_strategy": "shrink|repartition|external",
  "estimated_time": "30-60min|1-2hrs|2-4hrs",
  "risk_level": "low|medium|high"
}
"@

    "hardware_specific" = @"
Quick hardware compatibility check for Ubuntu. System: {hardware_summary}
Respond format: COMPATIBLE:yes/no DRIVERS:good/missing/unknown NOTES:brief_notes
"@

    "partition_analysis" = @"
Partition analysis for dual-boot. Current: {disk_info}
Target Ubuntu size: {ubuntu_gb}GB
Respond: FEASIBLE:yes/no SHRINK_FROM:{drive} FREE_AFTER:{gb}GB WARNINGS:{brief}
"@

    "error_diagnosis" = @"
Quick diagnosis for error: {error_text}
Context: {context}
Respond: CAUSE:{brief} SOLUTION:{action} PRIORITY:{low/medium/high}
"@

    "final_validation" = @"
Pre-installation validation. Ready for Ubuntu dual-boot?
System: {validation_data}
Respond: READY:yes/no BLOCKERS:[list] NEXT_STEPS:[actions]
"@
}

# Token-efficient context building
function Build-CompactSystemData {
    param([hashtable]$FullSystemData)
    
    # Extract only essential data for Claude analysis
    $compact = @{
        cpu = $FullSystemData.cpu.name -replace "Intel\(R\)|AMD ", ""
        ram_gb = [math]::Round($FullSystemData.memory.total_gb, 0)
        disks = $FullSystemData.disks | ForEach-Object { 
            @{
                size_gb = [math]::Round($_.size_gb, 0)
                free_gb = [math]::Round($_.free_gb, 0)
                type = $_.type
                boot = $_.is_boot_disk
            }
        }
        gpu = $FullSystemData.gpu.name -replace "NVIDIA |AMD |Intel\(R\) ", ""
        uefi = $FullSystemData.boot.is_uefi
        secure_boot = $FullSystemData.boot.secure_boot_enabled
    }
    
    return $compact | ConvertTo-Json -Compress
}

# Smart Claude invocation with token tracking
function Invoke-EfficientClaude {
    param(
        [string]$PromptType,
        [hashtable]$Variables = @{},
        [int]$MaxTokens = 150,
        [switch]$CriticalOnly
    )
    
    if (-not $script:ClaudeAvailable) {
        Write-Host "⚠️  Claude not available - using fallback logic" -ForegroundColor Yellow
        return $null
    }
    
    # Skip non-critical prompts if user requests token conservation
    if ($CriticalOnly -and $PromptType -notin @("system_assessment", "error_diagnosis")) {
        Write-Host "🔋 Skipping $PromptType to conserve tokens" -ForegroundColor Cyan
        return $null
    }
    
    # Build efficient prompt
    $template = $script:EfficientPrompts[$PromptType]
    $prompt = $template
    
    foreach ($key in $Variables.Keys) {
        $prompt = $prompt -replace "{$key}", $Variables[$key]
    }
    
    # Estimate token usage (rough: 4 chars per token)
    $estimatedTokens = [math]::Ceiling($prompt.Length / 4)
    Write-Host "🔋 Estimated tokens: $estimatedTokens (max: $MaxTokens)" -ForegroundColor DarkCyan
    
    if ($DryRun) {
        Write-Host "DRY RUN - Would send to Claude:" -ForegroundColor Yellow
        Write-Host $prompt.Substring(0, [math]::Min(200, $prompt.Length)) + "..." -ForegroundColor Gray
        return @{ dry_run = $true; estimated_tokens = $estimatedTokens }
    }
    
    try {
        # Use Claude Code with token limit
        $response = & $ClaudeBinary --max-tokens $MaxTokens --prompt $prompt 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "🤖 Claude response received" -ForegroundColor Green
            return @{ 
                success = $true
                response = $response
                estimated_tokens = $estimatedTokens
            }
        } else {
            throw "Claude returned error code $LASTEXITCODE"
        }
    }
    catch {
        Write-Host "❌ Claude invocation failed: $($_.Exception.Message)" -ForegroundColor Red
        return @{ success = $false; error = $_.Exception.Message }
    }
}

# Progressive enhancement strategy
function Get-ClaudeAssessmentLevel {
    param([string]$UserPreference = "auto")
    
    switch ($UserPreference.ToLower()) {
        "minimal" { return @{ level = "minimal"; prompts = @("error_diagnosis") } }
        "standard" { return @{ level = "standard"; prompts = @("system_assessment", "error_diagnosis") } }
        "comprehensive" { return @{ level = "comprehensive"; prompts = @("system_assessment", "hardware_specific", "partition_analysis", "final_validation", "error_diagnosis") } }
        "auto" {
            # Auto-detect based on system complexity
            $systemData = Get-SystemData
            $complexity = Get-SystemComplexity $systemData
            
            if ($complexity -eq "simple") {
                return @{ level = "minimal"; prompts = @("system_assessment") }
            } elseif ($complexity -eq "complex") {
                return @{ level = "comprehensive"; prompts = @("system_assessment", "hardware_specific", "partition_analysis", "final_validation") }
            } else {
                return @{ level = "standard"; prompts = @("system_assessment", "partition_analysis") }
            }
        }
        default { return @{ level = "standard"; prompts = @("system_assessment", "error_diagnosis") } }
    }
}

# Smart fallback when Claude isn't available
function Get-FallbackRecommendation {
    param([string]$AnalysisType, [hashtable]$SystemData)
    
    switch ($AnalysisType) {
        "system_assessment" {
            $ram = $SystemData.memory.total_gb
            $disk = $SystemData.disks[0].free_gb
            
            if ($ram -ge 8 -and $disk -ge 120) {
                return @{
                    compatibility = "good"
                    recommendations = @("Sufficient resources for Ubuntu dual-boot")
                    risk_level = "low"
                }
            } else {
                return @{
                    compatibility = "fair"
                    recommendations = @("Consider freeing up disk space", "Verify 8GB+ RAM available")
                    risk_level = "medium"
                }
            }
        }
        
        "partition_analysis" {
            $freespace = $SystemData.disks[0].free_gb
            $ubuntu_size = 100
            
            if ($freespace -gt ($ubuntu_size + 50)) {
                return "FEASIBLE:yes SHRINK_FROM:C: FREE_AFTER:$($freespace - $ubuntu_size)GB WARNINGS:none"
            } else {
                return "FEASIBLE:no SHRINK_FROM:C: FREE_AFTER:insufficient WARNINGS:need_more_space"
            }
        }
        
        default {
            return @{ fallback = $true; message = "Standard setup recommended" }
        }
    }
}

# Main token-efficient assessment function
function Start-EfficientClaudeAssessment {
    param(
        [hashtable]$SystemData,
        [string]$AssessmentLevel = "auto",
        [switch]$ConserveTokens
    )
    
    Write-Host ""
    Write-Host "🤖 Starting Claude Code assessment (token-efficient mode)" -ForegroundColor Magenta
    Write-Host ""
    
    # Get assessment level
    $config = Get-ClaudeAssessmentLevel $AssessmentLevel
    Write-Host "📊 Assessment level: $($config.level)" -ForegroundColor Cyan
    
    $results = @{}
    $totalTokens = 0
    
    foreach ($promptType in $config.prompts) {
        Write-Host "🔍 Running $promptType analysis..." -ForegroundColor Yellow
        
        $variables = @{}
        $maxTokens = 100  # Conservative token limit
        
        # Prepare variables based on prompt type
        switch ($promptType) {
            "system_assessment" {
                $variables["system_json"] = Build-CompactSystemData $SystemData
                $maxTokens = 150
            }
            "hardware_specific" {
                $variables["hardware_summary"] = "$($SystemData.cpu.name), $($SystemData.gpu.name), $([math]::Round($SystemData.memory.total_gb, 0))GB"
                $maxTokens = 80
            }
            "partition_analysis" {
                $variables["disk_info"] = "C: $([math]::Round($SystemData.disks[0].size_gb, 0))GB total, $([math]::Round($SystemData.disks[0].free_gb, 0))GB free"
                $variables["ubuntu_gb"] = "100"
                $maxTokens = 60
            }
        }
        
        # Invoke Claude or use fallback
        if ($script:ClaudeAvailable) {
            $result = Invoke-EfficientClaude -PromptType $promptType -Variables $variables -MaxTokens $maxTokens -CriticalOnly:$ConserveTokens
            
            if ($result.success) {
                $results[$promptType] = $result.response
                $totalTokens += $result.estimated_tokens
            } else {
                Write-Host "⚠️  Claude failed for $promptType, using fallback" -ForegroundColor Yellow
                $results[$promptType] = Get-FallbackRecommendation $promptType $SystemData
            }
        } else {
            $results[$promptType] = Get-FallbackRecommendation $promptType $SystemData
        }
        
        Start-Sleep 1  # Brief pause between requests
    }
    
    Write-Host ""
    Write-Host "🔋 Total estimated tokens used: $totalTokens" -ForegroundColor DarkCyan
    Write-Host "✅ Assessment complete" -ForegroundColor Green
    Write-Host ""
    
    return $results
}

# Export functions for use in main setup script
Export-ModuleMember -Function @(
    "Start-EfficientClaudeAssessment",
    "Invoke-EfficientClaude", 
    "Build-CompactSystemData",
    "Get-ClaudeAssessmentLevel"
)