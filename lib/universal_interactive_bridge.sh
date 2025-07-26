#!/bin/bash
# LLM_CAPABILITY: local_ok
# Universal Interactive Bridge - Auto-patches ANY interactive script for Claude Code
# Preserves 100% aesthetics while enabling AI execution

# SAFETY: Store original read function before override
if [[ "$(type -t read)" == "builtin" ]]; then
    # Save reference to original read
    eval "original_read() { builtin read \"\$@\"; }"
fi

# SAFETY: Only override if explicitly enabled
if [[ "${BILL_SLOTH_BRIDGE_ENABLED:-}" != "1" ]]; then
    return 0
fi

# Override read function globally for ALL scripts - SAFE VERSION
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
        
        # Context-aware intelligent selection with comprehensive pattern matching
        case "$prompt" in
            # Numbered choices (1-4), (1-5), etc.
            *"(1-"*|*"[1-"*|*"choice"*|*"Choice"*|*"select"*)
                case "$CLAUDE_SCRIPT_CONTEXT" in
                    *"productivity"*)
                        echo "🤖 Claude Code selecting: Super Productivity (ADHD-optimized)" >&2
                        echo "2"
                        ;;
                    *"ai"*|*"AI"*)
                        echo "🤖 Claude Code selecting: Intermediate level (good balance)" >&2
                        echo "3"
                        ;;
                    *"gaming"*)
                        echo "🤖 Claude Code selecting: Performance optimization" >&2
                        echo "1"
                        ;;
                    *"privacy"*)
                        echo "🤖 Claude Code selecting: Privacy-focused option" >&2
                        echo "1"
                        ;;
                    *)
                        echo "🤖 Claude Code selecting: Option 2 (balanced default)" >&2
                        echo "2"
                        ;;
                esac
                ;;
            # Yes/No questions - Enhanced patterns
            *"(y/n)"*|*"[y/n]"*|*"yes/no"*|*"continue"*|*"confirm"*|*"proceed"*|*"> "*|*"privacy"*|*"cloud"*|*"automation"*|*"development"*)
                echo "🤖 Claude Code confirming: Yes" >&2
                echo "y"
                ;;
            # Installation and setup prompts
            *"install"*|*"setup"*|*"configure"*)
                echo "🤖 Claude Code confirming: Yes" >&2
                echo "y"
                ;;
            # Experience level prompts
            *"experience"*|*"level"*|*"skill"*)
                echo "🤖 Claude Code selecting: Intermediate (balanced)" >&2
                echo "3"
                ;;
            # Goal/preference prompts
            *"goal"*|*"prefer"*|*"want"*|*"interest"*)
                echo "🤖 Claude Code selecting: Yes (comprehensive)" >&2
                echo "y"
                ;;
            # Default fallback with smarter defaults
            *)
                echo "🤖 Claude Code using intelligent default" >&2
                echo "2"
                ;;
        esac
    else
        # Human execution - use normal read (fall back to original)
        if [[ "$(type -t original_read)" == "function" ]]; then
            original_read "$@"
        else
            builtin read "$@"
        fi
    fi
}

# SAFETY: Function to restore original read behavior
restore_original_read() {
    if [[ "$(type -t original_read)" == "function" ]]; then
        eval "read() { original_read \"\$@\"; }"
        echo "🔧 Original read function restored"
    else
        unset -f read
        echo "🔧 Read function override removed"
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
if [[ ! -t 0 ]] || [[ "$TERM" == "dumb" ]] || [[ -n "${CLAUDE_CODE:-}" ]]; then
    export CLAUDE_EXECUTION="true"
fi