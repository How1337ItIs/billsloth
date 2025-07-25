#!/bin/bash
# LLM_CAPABILITY: local_ok
# Universal Interactive Bridge - Auto-patches ANY interactive script for Claude Code
# Preserves 100% aesthetics while enabling AI execution

# Override read function globally for ALL scripts
read() {
    if [[ -n "$CLAUDE_EXECUTION" ]] || [[ ! -t 0 ]] || [[ "$TERM" == "dumb" ]]; then
        # Claude Code execution - intelligent defaults
        local prompt=""
        local default_value="1"
        
        # Parse read arguments for context
        while [[ $# -gt 0 ]]; do
            case "$1" in
                -p)
                    prompt="$2"
                    shift 2
                    ;;
                *)
                    # Variable name or other args
                    shift
                    ;;
            esac
        done
        
        # Context-aware intelligent selection
        case "$prompt" in
            *"choice"*|*"Choice"*|*"select"*)
                case "$CLAUDE_SCRIPT_CONTEXT" in
                    *"productivity"*)
                        echo "🤖 Claude Code selecting: Super Productivity (ADHD-optimized)" >&2
                        echo "2"
                        ;;
                    *"data"*)
                        echo "🤖 Claude Code selecting: Option 1 (safe default)" >&2
                        echo "1"
                        ;;
                    *)
                        echo "🤖 Claude Code selecting: Option 1 (default)" >&2
                        echo "1"
                        ;;
                esac
                ;;
            *"continue"*|*"confirm"*|*"proceed"*)
                echo "🤖 Claude Code confirming: Yes" >&2
                echo "y"
                ;;
            *"install"*|*"setup"*)
                echo "🤖 Claude Code confirming: Yes" >&2
                echo "y"
                ;;
            *)
                echo "🤖 Claude Code using default" >&2
                echo "$default_value"
                ;;
        esac
    else
        # Human execution - use normal read
        command read "$@"
    fi
}

# Override select function for menu systems  
select_override() {
    if [[ -n "$CLAUDE_EXECUTION" ]] || [[ ! -t 0 ]] || [[ "$TERM" == "dumb" ]]; then
        # Claude Code execution - auto-select first option
        local var_name="$1"
        shift
        echo "🤖 Claude Code auto-selecting from menu" >&2
        eval "$var_name=\"\$1\""
        export REPLY="1"
    else
        # Human execution - normal select
        command select "$@"
    fi
}

# Export the overridden functions
export -f read
export -f select_override

# Set Claude execution flag if detected
if [[ ! -t 0 ]] || [[ "$TERM" == "dumb" ]] || [[ -n "$CLAUDE_CODE" ]]; then
    export CLAUDE_EXECUTION="true"
fi