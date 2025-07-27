# Windows Parity Implementation Plan

## Overview
This plan outlines the implementation of complete Windows parity for Bill Sloth, ensuring identical functionality across PowerShell 7, WSL2/bash, and native Ubuntu environments.

## Phase 0: Scaffold & Inventory
- [x] Integration analysis (Enhanced bridge selected as default)
- [ ] Task graph creation (this document)
- [ ] Module matrix documentation
- [ ] Windows-native stub creation
- [ ] Code stub generation
- [ ] Bootstrap enhancement
- [ ] Initial commit and draft PR

## Phase 1: Interactive Bridge MVP
- [ ] Implement claude_interactive_bridge.ps1
- [ ] Test tmux split-pane functionality in WSL2
- [ ] Test Windows Terminal split-pane functionality
- [ ] Verify ANSI color preservation across platforms
- [ ] Create cross-platform launcher scripts
- [ ] Test Claude CLI integration in split-pane setup
- [ ] Validate hotkey preservation

## Phase 2: Bootstrap & Environment Setup
- [ ] Enhance windows-bootstrap.ps1 with dependency detection
- [ ] Add Claude CLI installation verification
- [ ] Implement Windows Terminal / tmux prerequisite checks
- [ ] Add BL_LLM_MODE environment variable setup
- [ ] Create WSL2 distro import automation
- [ ] Add Windows-specific dependency installation (winget, Chocolatey)
- [ ] Test bootstrap on clean Windows system

## Phase 3: Module Port Sweep
- [ ] Port core interactive modules to PowerShell
- [ ] Create WSL2 shim modules for complex bash functionality
- [ ] Implement cross-platform modules for simple operations
- [ ] Test all modules for feature parity
- [ ] Verify ASCII art and color preservation
- [ ] Update module documentation
- [ ] Create Windows-specific installation scripts

## Phase 4: Local LLM Optional Integration
- [ ] Integrate Ollama service detection
- [ ] Add RAM requirement validation (≥8GB for local mode)
- [ ] Implement BL_LLM_MODE=local auto-enablement
- [ ] Create fallback mechanisms for insufficient resources
- [ ] Test local LLM functionality in split-pane setup
- [ ] Add local model performance monitoring
- [ ] Document local LLM setup requirements

## Environment Detection Strategy

### OS Detection Patterns
```powershell
# PowerShell Detection
$InWSL = (wsl -l -q) -match "bill-ubuntu"
if ($InWSL) { "Running in WSL context" } else { "Native Windows" }
```

```bash
# Bash Detection
if grep -qi microsoft /proc/version; then
    echo "Running in WSL"
else
    echo "Native Linux"
fi
```

### Path Translation Strategy
```powershell
# Windows → WSL path conversion
wslpath -a "C:\Users\Me\file.txt"  # → /mnt/c/Users/Me/file.txt

# WSL → Windows path conversion
wslpath -w "/home/me/file"         # → C:\Users\Me\file
```

### Split-Pane Launch Patterns
```bash
# WSL (tmux) Pattern
tmux new -s bl-$MODULE -d "bash modules/$MODULE.sh" \; \
split-window -h "claude chat --dangerously-skip-permissions -p 'Assist $MODULE'" \; \
select-pane -L \; attach
```

```powershell
# Native Windows Terminal Pattern
wt.exe new-tab pwsh -NoExit "-Command .\modules\windows_native\$MODULE.ps1" `; \
split-pane -H pwsh -NoExit "-Command claude chat --dangerously-skip-permissions -p 'Assist $MODULE'"
```

## Non-Negotiable Requirements
1. **Zero Regressions**: No loss of functionality from Linux version
2. **Visual Fidelity**: Identical ANSI colors, ASCII art, and layout
3. **Claude CLI First**: Never call Anthropic HTTP APIs directly
4. **Dual Environment**: Must work in both PowerShell 7 and WSL2/bash
5. **Mature Tooling**: Prefer established Windows tools over custom solutions

## Success Criteria
- All modules launch with identical visual presentation
- Claude CLI integration works in split-pane setup
- ANSI colors render correctly in Windows Terminal
- Hotkeys function identically across platforms
- Bootstrap script successfully prepares clean Windows system
- BL_LLM_MODE switches between cloud and local seamlessly

## Risk Mitigation
- **tmux Missing**: Install via WSL2 package manager with clear instructions
- **Windows Terminal Absent**: Fallback to `start cmd /k` with deprecation warning
- **Feature Impossibility**: Label PR "needs-discussion" and escalate to team
- **Performance Issues**: Monitor and optimize split-pane launch times
- **Path Translation**: Comprehensive testing of Windows/WSL path handling

## Documentation Standards
- All PowerShell scripts include `-WhatIf` parameter support
- WSL2 integration scripts handle mount point failures gracefully
- Error messages provide clear resolution steps
- ASCII art preserved exactly across all terminal environments
- Module help maintains Bill Sloth's ADHD-friendly tone