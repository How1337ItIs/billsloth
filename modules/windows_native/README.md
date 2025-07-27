# Windows Native Modules

This directory contains PowerShell implementations of Bill Sloth modules designed specifically for native Windows environments.

## Implementation Strategy

These modules follow the **native-PS** strategy from the Windows Module Parity Matrix, providing:

- Pure PowerShell implementations
- Windows-specific API integration
- Native Windows service management
- Optimal performance on Windows systems

## Module Categories

### System Management (native-PS)
- **system_ops_interactive.ps1** - Windows system operations
- **file_mastery_interactive.ps1** - Advanced Windows file operations
- **window_mastery_interactive.ps1** - Windows window management

### Business & Productivity (native-PS)
- **business_partnerships_interactive.ps1** - Business process automation
- **finance_management_interactive.ps1** - Financial tracking with Excel integration
- **productivity_suite_interactive.ps1** - Windows productivity tools
- **data_automation_interactive.ps1** - Data processing workflows

### Gaming & Entertainment (native-PS)
- **gaming_boost_interactive.ps1** - Windows gaming optimization
- **streaming_setup_interactive.ps1** - OBS and streaming configuration

### Network & Security (native-PS)
- **network_management_interactive.ps1** - Windows network configuration
- **network_diagnostics_interactive.ps1** - Windows network troubleshooting
- **vpn_security_interactive.ps1** - Windows VPN management

## Design Principles

1. **Windows-First Design**: Leverage Windows-specific APIs and capabilities
2. **PowerShell Best Practices**: Follow PowerShell coding standards and conventions
3. **Visual Fidelity**: Maintain exact ANSI color and ASCII art presentation
4. **Claude Integration**: Support split-pane Claude CLI assistance
5. **ADHD-Friendly UX**: Preserve Bill Sloth's supportive interface design

## Development Standards

### PowerShell Script Template
```powershell
#Requires -Version 7.0
# LLM_CAPABILITY: local_ok

<#
.SYNOPSIS
    [Module Description]

.DESCRIPTION
    [Detailed Description]

.PARAMETER WhatIf
    Show what would be done without making changes

.EXAMPLE
    .\module_name.ps1
#>

[CmdletBinding(SupportsShouldProcess)]
param(
    [switch]$WhatIf
)

# Import Bill Sloth core functions
$ErrorActionPreference = "Stop"
$PSNativeCommandUseErrorActionPreference = $true

# TODO: Implement module functionality
Write-Host "TODO: Implement $($MyInvocation.MyCommand.Name)" -ForegroundColor Yellow
```

### Required Features
- **-WhatIf parameter support** for safe testing
- **Error handling** with helpful messages
- **ANSI color preservation** in Windows Terminal
- **ASCII art consistency** with Linux versions
- **Claude CLI integration** points
- **Windows-specific optimizations**

## Testing Requirements

Each module must pass:
1. **Syntax validation** in PowerShell 7+
2. **Visual fidelity test** in Windows Terminal
3. **Split-pane integration** with Claude CLI
4. **Feature parity verification** against Linux version
5. **ADHD-friendly UX validation**

## Status

All modules in this directory are currently **TODO stubs** pending Phase 3 implementation.