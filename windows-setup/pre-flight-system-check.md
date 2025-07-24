# Bill Sloth Pre-Flight System Check
**Claude Code Prompt for Bill's Environment Assessment**

Copy and paste this prompt into your Claude Code instance to gather essential system information for optimized dual-boot setup:

---

## **CLAUDE CODE PROMPT:**

```
I need you to analyze my Windows system for Ubuntu dual-boot compatibility and gather information to optimize the Bill Sloth setup wizard. Please run these PowerShell commands and analyze the results:

**System Analysis Commands:**

```powershell
# System specifications
Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, BiosFirmwareType, TotalPhysicalMemory, CsProcessors

# CPU and architecture
Get-CimInstance -ClassName Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, Architecture, MaxClockSpeed

# Memory configuration
Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | ForEach-Object { "Total RAM: " + [math]::Round($_.Sum / 1GB, 2) + " GB" }

# Disk configuration and free space
Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 3 } | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}, @{Name="UsedPercent";Expression={[math]::Round((($_.Size-$_.FreeSpace)/$_.Size)*100,1)}}, FileSystem

# GPU information
Get-CimInstance -ClassName Win32_VideoController | Where-Object { $_.Name -notlike "*Basic*" } | Select-Object Name, DriverVersion, @{Name="VRAM(MB)";Expression={if($_.AdapterRAM){[math]::Round($_.AdapterRAM/1MB,0)}else{"Unknown"}}}

# Boot configuration
$secureBootEnabled = try { (Get-SecureBootUEFI -Name SetupMode -ErrorAction SilentlyContinue).Bytes[0] -eq 0 } catch { "Unknown" }
"UEFI: $((Get-ComputerInfo).BiosFirmwareType)"
"Secure Boot: $secureBootEnabled"
"TPM Available: $((Get-CimInstance -Namespace 'Root\CIMv2\Security\MicrosoftTpm' -ClassName Win32_Tpm -ErrorAction SilentlyContinue) -ne $null)"

# USB drives available
Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object { $_.DriveType -eq 2 } | Select-Object DeviceID, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}, VolumeName, @{Name="FreeSpace(GB)";Expression={[math]::Round($_.FreeSpace/1GB,2)}}

# Network connectivity
Test-Connection -ComputerName "8.8.8.8" -Count 1 -Quiet

# PowerShell execution policy
Get-ExecutionPolicy

# Check for existing Ubuntu ISOs
Get-ChildItem -Path "$env:USERPROFILE\Downloads\ubuntu*.iso", "$env:USERPROFILE\Desktop\ubuntu*.iso" -ErrorAction SilentlyContinue | Select-Object Name, @{Name="Size(GB)";Expression={[math]::Round($_.Length/1GB,2)}}, LastWriteTime

# Check if Claude Code is available
try { & claude --version } catch { "Claude Code not installed" }

# Check if Git is available
try { & git --version } catch { "Git not installed" }

# Check if Node.js is available  
try { & node --version } catch { "Node.js not installed" }

# Administrator check
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
```

**Analysis Request:**

Based on the command outputs above, please provide a JSON response with your assessment:

```json
{
  "system_profile": {
    "complexity": "simple|moderate|complex",
    "ubuntu_compatibility": "excellent|good|fair|poor", 
    "dual_boot_feasibility": "high|medium|low",
    "estimated_setup_time": "30-60min|1-2hrs|2-4hrs|4+hrs"
  },
  "optimization_recommendations": {
    "claude_assistance_level": "minimal|standard|comprehensive",
    "skip_claude_recommended": false,
    "wizard_mode": "express|guided|comprehensive"
  },
  "resource_status": {
    "disk_space_adequate": true,
    "usb_drive_available": true,
    "ubuntu_iso_found": false,
    "dependencies_installed": ["git", "node", "claude"]
  },
  "critical_actions_needed": [
    "install_prerequisites",
    "free_disk_space", 
    "insert_usb_drive",
    "disable_secure_boot"
  ],
  "hardware_considerations": [
    "nvidia_gpu_detected",
    "uefi_boot_available",
    "sufficient_ram"
  ],
  "wizard_parameters": {
    "recommended_command": ".\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel minimal -ConserveTokens",
    "ubuntu_partition_size": 100,
    "estimated_token_usage": 50
  }
}
```

This analysis will help optimize your Bill Sloth dual-boot setup by:
1. **Minimizing token usage** by pre-identifying your system profile
2. **Skipping unnecessary checks** during setup
3. **Providing targeted guidance** based on your specific hardware
4. **Estimating setup time** accurately
5. **Identifying potential issues** before they occur

Please run these commands and provide the assessment - this will make your setup experience much smoother and more efficient!
```

---

## **How Bill Should Use This:**

1. **Copy the entire prompt above** into Claude Code
2. **Claude will run the PowerShell commands** and analyze his system
3. **Claude will provide optimized recommendations** in JSON format
4. **Use the recommended wizard command** from the JSON response
5. **Setup will be pre-optimized** for his specific system

## **Benefits for Bill:**

✅ **Massive Token Savings:** Pre-analysis means the wizard can skip redundant system checks  
✅ **Faster Setup:** Knows exactly what to do based on his hardware  
✅ **Prevents Issues:** Identifies problems before setup starts  
✅ **Optimized Experience:** Wizard runs in the most efficient mode for his system  
✅ **Accurate Time Estimates:** Knows how long setup will actually take

## **Example Optimized Commands Bill Might Get:**

```powershell
# For simple system with good compatibility
.\fine-tuned-dual-boot-wizard.ps1 -SkipClaude -UbuntuSizeGB 120

# For complex system needing guidance  
.\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel minimal -ConserveTokens

# For system with issues detected
.\troubleshoot-setup-failure.ps1 -AutoFix
# Then: .\fine-tuned-dual-boot-wizard.ps1 -ClaudeLevel standard
```

This pre-flight check can save Bill **hundreds of tokens** and **significant time** by having Claude analyze his system once upfront, then running the wizard with optimal settings.

## **ALTERNATIVE: Automated Launcher**

For maximum convenience, Bill can use the automated launcher that does basic pre-flight analysis without using Claude tokens:

```powershell
# Automated pre-flight + optimized wizard (RECOMMENDED)
.\optimized-setup-launcher.ps1

# Skip pre-flight analysis entirely
.\optimized-setup-launcher.ps1 -SkipPreFlight

# Manual pre-flight mode (shows Claude prompt)
.\optimized-setup-launcher.ps1 -ManualPreFlight

# Use existing pre-flight analysis
.\optimized-setup-launcher.ps1 -PreFlightFile "analysis.json"
```

**The automated launcher:**
- ✅ **Zero tokens used** for basic system analysis
- ✅ **Automatically optimizes** wizard settings based on system
- ✅ **Detects common issues** before setup starts  
- ✅ **Provides fallback recommendations** if system is complex
- ✅ **Shows estimated setup time** and token usage

This gives Bill the optimization benefits without requiring Claude token usage for simple systems!