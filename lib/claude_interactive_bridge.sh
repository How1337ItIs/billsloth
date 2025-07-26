#!/bin/bash
# LLM_CAPABILITY: local_ok
# Claude Interactive Bridge - Hybrid AI/Human Interactive System
# Preserves full aesthetic experience while enabling Claude Code intelligence

# Detect execution context - SAFE DETECTION METHOD
is_claude_execution() {
    # Primary detection: explicit Claude Code environment variables
    [[ -n "${CLAUDE_CODE:-}" ]] && return 0
    [[ -n "${AI_EXECUTION:-}" ]] && return 0
    
    # Secondary detection: stdin characteristics (safer than blind detection)
    if [[ ! -t 0 ]] && [[ "${FORCE_INTERACTIVE:-}" != "1" ]]; then
        return 0
    fi
    
    # Terminal characteristics (most conservative)
    [[ "${TERM:-}" == "dumb" ]] && [[ "${FORCE_INTERACTIVE:-}" != "1" ]] && return 0
    
    # Default to human interaction for safety
    return 1
}

# Parse script metadata for Claude analysis
parse_script_metadata() {
    local script_file="$1"
    
    # Extract metadata from script comments
    local options=$(grep "# CLAUDE_OPTIONS:" "$script_file" 2>/dev/null | sed 's/# CLAUDE_OPTIONS://')
    local prompts=$(grep "# CLAUDE_PROMPTS:" "$script_file" 2>/dev/null | sed 's/# CLAUDE_PROMPTS://')
    local dependencies=$(grep "# CLAUDE_DEPENDENCIES:" "$script_file" 2>/dev/null | sed 's/# CLAUDE_DEPENDENCIES://')
    
    echo "OPTIONS: $options"
    echo "PROMPTS: $prompts"  
    echo "DEPENDENCIES: $dependencies"
}

# Claude Code pre-flight analysis
claude_preflight_analysis() {
    local script_name="$1"
    local script_file="$2"
    
    echo "🧠 CLAUDE CODE ANALYSIS: $script_name"
    echo "========================================"
    echo ""
    
    # Parse script for decision points
    local menu_options=$(grep -E "^[[:space:]]*[0-9]+\)" "$script_file" | head -10)
    local read_prompts=$(grep -E "read -p|Your choice:" "$script_file" | wc -l)
    
    echo "📊 SCRIPT OVERVIEW:"
    echo "• Found $read_prompts interactive decision points"
    echo "• Detected menu-driven interface"
    echo "• Full ASCII art and educational content preserved"
    echo ""
    
    echo "🎯 AVAILABLE OPTIONS:"
    if [[ -n "$menu_options" ]]; then
        echo "$menu_options" | sed 's/^/  /'
    fi
    echo ""
    
    echo "🚀 EXECUTION PLAN:"
    echo "• I'll present the full visual experience"
    echo "• Auto-handle menu selections intelligently"  
    echo "• Preserve all ASCII art and educational content"
    echo "• Use context clues for optimal choices"
    echo ""
    
    echo "Ready to launch full aesthetic experience with Claude intelligence!"
    echo "================================================================="
    echo ""
}

# Intelligent menu selection for Claude Code
claude_smart_select() {
    local prompt="$1"
    local context="$2"
    
    # Context-aware selection logic
    case "$context" in
        "productivity_suite")
            case "$prompt" in
                *"choice"*|*"Your choice"*)
                    # Default to Super Productivity (ADHD-optimized)
                    echo "2"
                    ;;
                *"continue"*|*"confirm"*)
                    echo "y"
                    ;;
                *)
                    echo "1"
                    ;;
            esac
            ;;
        "data_hoarding")
            echo "1" # Safe default for data operations
            ;;
        *)
            echo "1" # Universal safe default
            ;;
    esac
}

# Enhanced read function with Claude intelligence
claude_enhanced_read() {
    local prompt="$1"
    local default="$2"
    local context="$3"
    
    if is_claude_execution; then
        # Pre-populate with intelligent choice
        local choice=$(claude_smart_select "$prompt" "$context")
        echo "🤖 Claude Code selecting: $choice"
        echo "$choice"
    else
        # Normal interactive read
        echo -n "$prompt"
        read -r user_input
        echo "${user_input:-$default}"
    fi
}

# Main bridge wrapper function
run_with_claude_bridge() {
    local script_path="$1"
    local script_name=$(basename "$script_path" .sh)
    
    if is_claude_execution; then
        echo "🧠 CLAUDE CODE BRIDGE ACTIVATED"  
        echo "================================"
        echo ""
        
        # Pre-flight analysis
        claude_preflight_analysis "$script_name" "$script_path"
        
        # Set context for intelligent selections
        export CLAUDE_SCRIPT_CONTEXT="$script_name"
        export CLAUDE_EXECUTION="true"
        
        # SAFETY: Enable bridge system explicitly and temporarily
        export BILL_SLOTH_BRIDGE_ENABLED="1"
        
        # Load universal bridge to override read/select functions
        source "$(dirname "${BASH_SOURCE[0]}")/universal_interactive_bridge.sh"
        
        # Run script with ALL interactive elements auto-handled
        bash "$script_path"
    else
        # Direct human execution - full interactive experience
        bash "$script_path"
    fi
}

# Export functions for script integration
export -f is_claude_execution
export -f claude_enhanced_read  
export -f claude_smart_select
export -f parse_script_metadata
export -f claude_preflight_analysis
export -f run_with_claude_bridge