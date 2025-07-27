#!/bin/bash
# LLM_CAPABILITY: local_ok
# Bill Sloth AI Assistant - Unix/Linux Wrapper
# Phase 1 - Cross-platform detection and launcher execution

set -euo pipefail

# Detect environment
detect_environment() {
    if [[ -n "${WSL_DISTRO_NAME:-}" ]] || [[ -n "${WSL_INTEROP:-}" ]]; then
        echo "wsl"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    else
        echo "unknown"
    fi
}

# Main execution
main() {
    local env
    env=$(detect_environment)
    
    echo "Bill Sloth AI Assistant - Detected environment: $env"
    
    case "$env" in
        "wsl"|"linux"|"macos")
            # Check if we're in the right directory
            if [[ ! -f "bin/bill-sloth-claude-launcher.sh" ]]; then
                echo "Error: Please run from Bill Sloth project root directory"
                echo "Current directory: $(pwd)"
                exit 1
            fi
            
            # Check prerequisites
            if ! command -v tmux &>/dev/null; then
                echo "Error: tmux not installed"
                echo "Install with:"
                case "$env" in
                    "wsl")
                        echo "  wsl: sudo apt update && sudo apt install tmux"
                        ;;
                    "linux")
                        echo "  Ubuntu/Debian: sudo apt install tmux"
                        echo "  RedHat/CentOS: sudo yum install tmux"
                        echo "  Arch: sudo pacman -S tmux"
                        ;;
                    "macos")
                        echo "  macOS: brew install tmux"
                        ;;
                esac
                exit 1
            fi
            
            # Execute launcher
            exec bash bin/bill-sloth-claude-launcher.sh "$@"
            ;;
        "unknown")
            echo "Error: Unsupported environment"
            echo "Supported platforms:"
            echo "  - Linux (native)"
            echo "  - WSL2 (Windows Subsystem for Linux)"
            echo "  - macOS (with tmux)"
            echo ""
            echo "For Windows PowerShell, use: bsai.ps1"
            exit 1
            ;;
    esac
}

# Show usage if no arguments
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <module_name> [args...]"
    echo ""
    echo "Examples:"
    echo "  $0 data_hoarding_interactive"
    echo "  $0 gaming_boost_interactive --quick-setup"
    echo ""
    echo "Available modules:"
    if [[ -d "modules" ]]; then
        ls modules/*.sh 2>/dev/null | sed 's/modules\//  /' | sed 's/\.sh$//' | head -10
        count=$(ls modules/*.sh 2>/dev/null | wc -l)
        if [[ $count -gt 10 ]]; then
            echo "  ... and $((count - 10)) more"
        fi
    else
        echo "  (run from Bill Sloth project directory)"
    fi
    exit 1
fi

main "$@"