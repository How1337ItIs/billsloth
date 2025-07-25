#!/bin/bash
# LLM_CAPABILITY: local_ok
# Claude Code Interactive Bridge - Makes interactive scripts work with AI
# Detects Claude Code execution and provides non-interactive mode

# Detect if running under Claude Code or AI automation
is_claude_execution() {
    # Check for Claude Code environment indicators
    [[ -n "$CLAUDE_CODE" ]] || [[ -n "$AI_EXECUTION" ]] || [[ ! -t 0 ]] || [[ -z "$TERM" ]]
}

# Smart input function - works interactively OR with Claude Code
smart_read() {
    local prompt="$1"
    local default="$2"
    local variable_name="$3"
    
    if is_claude_execution; then
        # Non-interactive mode - use defaults or environment variables
        if [[ -n "${!variable_name}" ]]; then
            echo "${!variable_name}"
        elif [[ -n "$default" ]]; then
            echo "$default"
        else
            echo "1"  # Safe default
        fi
    else
        # Interactive mode - normal read
        echo -n "$prompt"
        read -r input
        echo "${input:-$default}"
    fi
}

# Menu selection with Claude Code compatibility
smart_menu_select() {
    local options=("$@")
    local selection
    
    if is_claude_execution; then
        # Auto-select based on context or use first option
        echo "1"
    else
        # Interactive selection
        select selection in "${options[@]}"; do
            [[ -n "$selection" ]] && break
        done
        echo "$REPLY"
    fi
}

# Replace all read commands in scripts
read() {
    if is_claude_execution; then
        # Non-interactive - return reasonable defaults
        case "$*" in
            *"-p"*) # read -p "prompt" var
                local prompt=$(echo "$*" | sed 's/.*-p "\([^"]*\)".*/\1/')
                echo "1" # Default choice
                ;;
            *) 
                echo "1" # Safe default
                ;;
        esac
    else
        # Normal interactive read
        command read "$@"
    fi
}

# Export functions for use in scripts
export -f is_claude_execution
export -f smart_read
export -f smart_menu_select