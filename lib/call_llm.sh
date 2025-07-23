#!/bin/bash
# LLM Call Abstraction - Smart dispatcher between Claude Code (cloud) and local models
# Automatically chooses based on capability tags and environment flags

LLM_LOG="$HOME/.bill-sloth/ai.log"

set -euo pipefail
mkdir -p "$(dirname "$LLM_LOG")"

# Smart LLM dispatcher
llm() {
    local prompt="$1"
    local module_file="${2:-auto}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Determine capability from module file
    local capability="auto"
    if [[ -f "$module_file" ]]; then
        capability=$(grep -m1 -E '^# LLM_CAPABILITY:' "$module_file" | awk '{print $3}' 2>/dev/null || echo "auto")
    fi
    
    # Global environment overrides
    [[ ${OFFLINE_MODE:-0} -eq 1 ]] && capability="local_ok"
    [[ ${FORCE_CLOUD:-0} -eq 1 ]] && capability="cloud_only"
    
    # Log the request
    echo "[$timestamp] MODULE: $module_file CAPABILITY: $capability PROMPT: ${prompt:0:100}..." >> "$LLM_LOG"
    
    # Route to appropriate AI system
    case "$capability" in
        "local_ok")
            if command -v interpreter &> /dev/null && command -v ollama &> /dev/null; then
                echo "🤖 Using local AI (Open Interpreter + CodeLlama)..."
                echo "[$timestamp] ROUTING: Local AI" >> "$LLM_LOG"
                interpreter --no-gui "$prompt" 2>/dev/null || {
                    echo "⚠️ Local AI failed, falling back to manual processing"
                    call_llm_manual "$prompt"
                }
            else
                echo "⚠️ Local AI not available, falling back to manual processing"
                call_llm_manual "$prompt"
            fi
            ;;
        "cloud_only")
            echo "☁️ Routing to Claude Code (cloud required)..."
            echo "[$timestamp] ROUTING: Cloud (Claude Code)" >> "$LLM_LOG"
            call_llm_manual "$prompt"
            ;;
        *)
            # Auto-detect: prefer local if available and in offline mode
            if [[ ${OFFLINE_MODE:-0} -eq 1 ]] && command -v interpreter &> /dev/null; then
                echo "🤖 Auto-routing to local AI (offline mode)..."
                echo "[$timestamp] ROUTING: Auto -> Local AI" >> "$LLM_LOG"
                interpreter --no-gui "$prompt" 2>/dev/null || call_llm_manual "$prompt"
            else
                echo "☁️ Auto-routing to Claude Code (cloud)..."
                echo "[$timestamp] ROUTING: Auto -> Cloud" >> "$LLM_LOG"
                call_llm_manual "$prompt"
            fi
            ;;
    esac
}

# Legacy function name for backward compatibility
call_llm() {
    llm "$@"
}

# Manual processing fallback (original behavior)
call_llm_manual() {
    local prompt="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "🤖 LLM CALL ABSTRACTION - Manual Processing"
    echo "=========================================="
    echo "Prompt: $prompt"
    echo ""
    echo "📝 This prompt has been logged to: $LLM_LOG"
    echo "🧠 Copy this prompt to Claude Code for processing"
    echo ""
    if [[ ${OFFLINE_MODE:-0} -eq 1 ]]; then
        echo "💡 You're in offline mode. Install local AI with: modules/local_llm_setup.sh"
    else
        echo "☁️ For automatic cloud processing, ensure Claude Code API is configured"
    fi
    
    # Log manual processing
    echo "[$timestamp] RESULT: Manual processing requested" >> "$LLM_LOG"
}

# Export functions for use in other scripts
export -f llm call_llm call_llm_manual