# CLI Pane Bridge - Phase 1 Documentation

## Overview
The CLI Pane Bridge enables Claude Code CLI integration with Bill Sloth modules while preserving the full visual experience including ASCII art, colors, and animations. Instead of Claude running modules "from outside" with tiny output previews, Claude is positioned "inside" the terminal experience as an AI assistant.

## Problem Statement
- **Claude Code Limitation**: Bash tool only shows tiny output snippets (2-3 lines)
- **Lost Visual Experience**: Bill Sloth's ASCII art, ANSI colors, and animations are truncated
- **Broken Interactivity**: Menu-driven interfaces don't work well in Claude's execution model
- **Missing Context**: Claude can't see the full terminal state to provide relevant help

## Solution Architecture

### Core Concept
Split-pane architecture where:
- **Left Pane**: Bill Sloth module running with full visual fidelity
- **Right Pane**: Claude Code CLI with contextual awareness
- **Communication**: Key bindings to capture and share terminal content

### Platform-Specific Implementations

#### Linux/WSL2: tmux-based
```bash
# Creates tmux session with split panes
tmux new-session -d -s "bill-sloth-module"
tmux split-window -h  # Split horizontally
tmux send-keys -t 0 "bash modules/module.sh"  # Left: module
tmux send-keys -t 1 "claude --dangerously-skip-permissions"  # Right: Claude
```

#### Windows: Windows Terminal + PowerShell
```powershell
# Launch Windows Terminal with split panes
wt --title "Bill Sloth" powershell -Command "module.sh" `
   split-pane --horizontal powershell -Command "claude ..."
```

#### Fallback: Separate Windows
When advanced terminal features aren't available, launches module and Claude in separate windows.

## Installation

### Prerequisites
1. **Claude Code CLI**: Install from https://claude.ai/code
2. **Terminal Multiplexer**:
   - Linux/WSL2: `sudo apt install tmux`
   - Windows: Windows Terminal (recommended) or fallback method
3. **Bill Sloth Project**: Clone and navigate to project root

### Quick Setup
```bash
# Check prerequisites
bash windows-bootstrap.ps1  # Windows
# or verify manually: claude --version, tmux --version

# Make scripts executable
chmod +x bin/bsai.sh bin/bill-sloth-claude-launcher.sh
```

## Usage

### Basic Usage
```bash
# Linux/WSL2
bash bin/bsai.sh <module_name> [args...]

# Windows PowerShell
bin/bsai.ps1 <module_name> [args...]
```

### Examples
```bash
# Launch data hoarding module with Claude assistance
bash bin/bsai.sh data_hoarding_interactive

# Launch gaming optimization with arguments
bash bin/bsai.sh gaming_boost_interactive --quick-setup

# Windows equivalent
bin/bsai.ps1 data_hoarding_interactive
```

### Key Bindings (tmux)
- **Ctrl-b a**: Capture left pane (last 100 lines) and send to Claude
- **Ctrl-b q**: Quit entire session
- **Ctrl-b [**: Enter copy mode (navigate with arrows, q to exit)
- **Ctrl-b %**: Split pane vertically (if needed)
- **Ctrl-b "**: Split pane horizontally (if needed)

### Workflow
1. **Launch**: Run `bsai.sh` or `bsai.ps1` with module name
2. **Experience**: See full Bill Sloth module with ASCII art and colors
3. **Assistance**: Claude CLI ready in right pane with module context
4. **Interaction**: Ask Claude questions, get help with decisions
5. **Automation**: Use Ctrl-b a to share current screen with Claude

## Cross-Platform Support

### Linux (Native)
- **Method**: tmux split-pane
- **Features**: Full feature set, optimal experience
- **Requirements**: tmux, Claude CLI

### WSL2 (Windows Subsystem for Linux)
- **Method**: tmux split-pane (same as Linux)
- **Features**: Full feature set
- **Requirements**: WSL2, tmux, Claude CLI
- **Launch**: Use `bsai.sh` from within WSL2

### Windows (Native)
- **Method**: Windows Terminal split-pane OR fallback
- **Features**: Visual preservation, separate Claude pane
- **Requirements**: Claude CLI, optionally Windows Terminal
- **Launch**: Use `bsai.ps1` from PowerShell

### macOS
- **Method**: tmux split-pane (same as Linux)
- **Features**: Full feature set
- **Requirements**: tmux (via brew), Claude CLI

## Architecture Details

### Session Management
- **Unique Sessions**: Each module gets its own tmux session
- **Session Names**: `bill-sloth-{module_name}`
- **Cleanup**: Existing sessions are killed before creating new ones
- **Persistence**: Sessions survive terminal disconnection

### Claude Integration
- **Context Prompt**: Claude receives module name and assistance instructions
- **Dangerous Mode**: Uses `--dangerously-skip-permissions` for seamless operation
- **Communication**: Screen capture via tmux for context sharing

### Error Handling
- **Prerequisites**: Clear error messages with remediation steps
- **Module Validation**: Checks module exists before launching
- **Graceful Degradation**: Fallback methods when advanced features unavailable

## Troubleshooting

### Common Issues

#### "tmux not found"
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install tmux

# RedHat/CentOS
sudo yum install tmux

# macOS
brew install tmux
```

#### "claude not found"
1. Install Claude CLI from https://claude.ai/code
2. Ensure it's in your PATH
3. Test with: `claude --version`

#### "Module not found"
- Ensure you're in the Bill Sloth project root directory
- Check available modules: `ls modules/*.sh`
- Use exact module name without `.sh` extension

#### Windows Terminal not working
- Install from Microsoft Store or GitHub releases
- Falls back to separate windows automatically
- Both methods preserve functionality

### Debug Mode
Set environment variable for verbose output:
```bash
export BILL_SLOTH_DEBUG=1
bash bin/bsai.sh module_name
```

## API Reference

### bsai.sh (Linux/WSL2/macOS)
```bash
Usage: bsai.sh <module_name> [args...]

Environment Variables:
  BILL_SLOTH_DEBUG=1    Enable verbose logging
  
Exit Codes:
  0    Success
  1    Missing module or prerequisites
  2    Environment not supported
```

### bsai.ps1 (Windows PowerShell)
```powershell
Usage: bsai.ps1 <module_name> [args...]

Parameters:
  -ModuleName    Required. Name of Bill Sloth module
  [ModuleArgs]   Optional. Arguments to pass to module
  
Examples:
  bsai.ps1 data_hoarding_interactive
  bsai.ps1 gaming_boost_interactive -QuickSetup
```

### bill-sloth-claude-launcher.sh (Core Engine)
```bash
Usage: bill-sloth-claude-launcher.sh <module_name> [args...]

Features:
  - Creates tmux session with split panes
  - Configures Claude CLI with module context
  - Sets up key bindings for screen sharing
  - Handles session cleanup and management
```

## Phase 1 Limitations
- **No automatic error detection**: Claude doesn't automatically detect and respond to errors
- **Basic context sharing**: Manual screen capture (Ctrl-b a) required
- **No persistent memory**: Claude doesn't remember previous sessions
- **Limited hotkeys**: Basic tmux bindings only

## Next Phases
- **Phase 2**: Enhanced context awareness, automatic error detection
- **Phase 3**: Persistent session memory, advanced hotkeys
- **Phase 4**: Full integration with all 30+ Bill Sloth modules

---
*CLI Pane Bridge Phase 1 - Working prototype ready for testing*