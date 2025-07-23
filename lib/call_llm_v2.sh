#!/bin/bash
# Enhanced LLM Call Abstraction v2 - Smart dispatcher with timeouts, metrics, and sanitization
# Improvements: timeouts, retries, prompt sanitization, usage metrics, error codes


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Configuration
LLM_LOG="$HOME/.bill-sloth/ai.log"
LLM_METRICS="$HOME/.bill-sloth/metrics/llm_usage.json"
LLM_TIMEOUT="${LLM_TIMEOUT:-30}"  # Default 30 second timeout
LLM_MAX_RETRIES="${LLM_MAX_RETRIES:-3}"
LLM_RETRY_DELAY="${LLM_RETRY_DELAY:-2}"

# Ensure directories exist
create_directory "$(dirname "$LLM_LOG")"
create_directory "$(dirname "$LLM_METRICS")"

# Initialize metrics file if not exists
if [ ! -f "$LLM_METRICS" ]; then
    echo '{"local":0,"cloud":0,"manual":0,"failed":0,"total_tokens_saved":0}' > "$LLM_METRICS"
fi

# Sanitize prompt to remove sensitive data before logging
sanitize_prompt() {
    local prompt="$1"
    local sanitized="$prompt"
    
    # Remove email addresses
    sanitized=$(echo "$sanitized" | sed -E 's/[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/<EMAIL_REDACTED>/g')
    
    # Remove IP addresses
    sanitized=$(echo "$sanitized" | sed -E 's/\b([0-9]{1,3}\.){3}[0-9]{1,3}\b/<IP_REDACTED>/g')
    
    # Remove file paths with /home/username
    sanitized=$(echo "$sanitized" | sed -E 's|/home/[^/]+|/home/<USER>|g')
    
    # Remove potential API keys/tokens (long alphanumeric strings)
    sanitized=$(echo "$sanitized" | sed -E 's/\b[a-zA-Z0-9]{32,}\b/<TOKEN_REDACTED>/g')
    
    # Truncate to 500 chars for logging
    if [ ${#sanitized} -gt 500 ]; then
        sanitized="${sanitized:0:497}..."
    fi
    
    echo "$sanitized"
}

# Update metrics
update_metrics() {
    local metric_type="$1"
    local tokens_saved="${2:-0}"
    
    if [ -f "$LLM_METRICS" ]; then
        # Read current metrics
        local metrics
        metrics=$(cat "$LLM_METRICS")
        
        # Update the specific metric
        case "$metric_type" in
            "local"|"cloud"|"manual"|"failed")
                local current
                current=$(echo "$metrics" | jq -r ".$metric_type // 0")
                metrics=$(echo "$metrics" | jq ".$metric_type = $((current + 1))")
                ;;
        esac
        
        # Update tokens saved
        if [ "$tokens_saved" -gt 0 ]; then
            local current_tokens
            current_tokens=$(echo "$metrics" | jq -r ".total_tokens_saved // 0")
            metrics=$(echo "$metrics" | jq ".total_tokens_saved = $((current_tokens + tokens_saved))")
        fi
        
        # Add timestamp
        metrics=$(echo "$metrics" | jq ".last_updated = \"$(date -Iseconds)\"")
        
        # Write back
        echo "$metrics" | jq '.' > "$LLM_METRICS"
    fi
}

# Execute with timeout
execute_with_timeout() {
    local command="$1"
    local timeout="${2:-$LLM_TIMEOUT}"
    
    if command -v timeout &>/dev/null; then
        timeout "$timeout" bash -c "$command"
    else
        # Fallback for systems without timeout command
        bash -c "$command" &
        local pid=$!
        
        local count=0
        while kill -0 $pid 2>/dev/null && [ $count -lt $timeout ]; do
            sleep 1
            count=$((count + 1))
        done
        
        if kill -0 $pid 2>/dev/null; then
            kill -TERM $pid 2>/dev/null
            sleep 1
            kill -KILL $pid 2>/dev/null
            return 124  # timeout exit code
        fi
        
        wait $pid
    fi
}

# Local AI execution with timeout and retries
execute_local_ai() {
    local prompt="$1"
    local attempt=1
    
    while [ $attempt -le $LLM_MAX_RETRIES ]; do
        log_info "Local AI attempt $attempt of $LLM_MAX_RETRIES..."
        
        if execute_with_timeout "interpreter --no-gui \"$prompt\"" "$LLM_TIMEOUT"; then
            log_success "Local AI completed successfully"
            update_metrics "local" 100  # Estimate 100 tokens saved
            return 0
        else
            local exit_code=$?
            if [ $exit_code -eq 124 ]; then
                log_warning "Local AI timed out after ${LLM_TIMEOUT}s"
            else
                log_warning "Local AI failed with exit code: $exit_code"
            fi
            
            if [ $attempt -lt $LLM_MAX_RETRIES ]; then
                log_info "Retrying in ${LLM_RETRY_DELAY}s..."
                sleep $LLM_RETRY_DELAY
                LLM_RETRY_DELAY=$((LLM_RETRY_DELAY * 2))  # Exponential backoff
            fi
        fi
        
        attempt=$((attempt + 1))
    done
    
    log_error "Local AI failed after $LLM_MAX_RETRIES attempts"
    update_metrics "failed"
    return 1
}

# Claude API execution (when available)
execute_claude_api() {
    local prompt="$1"
    
    # Check if claude command exists
    if ! command -v claude &>/dev/null; then
        log_warning "Claude Code CLI not available"
        return 1
    fi
    
    log_info "Calling Claude Code API..."
    
    if execute_with_timeout "claude \"$prompt\"" "$LLM_TIMEOUT"; then
        log_success "Claude API call successful"
        update_metrics "cloud"
        return 0
    else
        local exit_code=$?
        if [ $exit_code -eq 124 ]; then
            log_error "Claude API timed out after ${LLM_TIMEOUT}s"
        else
            log_error "Claude API failed with exit code: $exit_code"
        fi
        update_metrics "failed"
        return 1
    fi
}

# Enhanced LLM dispatcher
llm_v2() {
    local prompt="$1"
    local module_file="${2:-auto}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Validate input
    if [ -z "$prompt" ]; then
        log_error "No prompt provided"
        return 1
    fi
    
    # Sanitize prompt for logging
    local sanitized_prompt
    sanitized_prompt=$(sanitize_prompt "$prompt")
    
    # Determine capability from module file
    local capability="auto"
    if [[ -f "$module_file" ]]; then
        capability=$(grep -m1 -E '^# LLM_CAPABILITY:' "$module_file" | awk '{print $3}' 2>/dev/null || echo "auto")
    fi
    
    # Global environment overrides
    [[ ${OFFLINE_MODE:-0} -eq 1 ]] && capability="local_ok"
    [[ ${FORCE_CLOUD:-0} -eq 1 ]] && capability="cloud_only"
    
    # Log the request with sanitized prompt
    echo "[$timestamp] MODULE: $module_file CAPABILITY: $capability PROMPT: $sanitized_prompt" >> "$LLM_LOG"
    
    # Set LLM_STATUS for caller to check
    export LLM_STATUS="PENDING"
    
    # Route to appropriate AI system
    case "$capability" in
        "local_ok")
            if command -v interpreter &> /dev/null && command -v ollama &> /dev/null; then
                log_progress "Using local AI (Open Interpreter + CodeLlama)..."
                echo "[$timestamp] ROUTING: Local AI" >> "$LLM_LOG"
                
                if execute_local_ai "$prompt"; then
                    export LLM_STATUS="SUCCESS"
                    return 0
                else
                    log_warning "Local AI failed, falling back to manual"
                    export LLM_STATUS="FALLBACK"
                    call_llm_manual_v2 "$prompt"
                    return 2  # Indicates fallback was used
                fi
            else
                log_warning "Local AI not available, falling back to manual"
                export LLM_STATUS="UNAVAILABLE"
                call_llm_manual_v2 "$prompt"
                return 2
            fi
            ;;
            
        "cloud_only")
            log_progress "Routing to Claude Code (cloud required)..."
            echo "[$timestamp] ROUTING: Cloud (Claude Code)" >> "$LLM_LOG"
            
            if execute_claude_api "$prompt"; then
                export LLM_STATUS="SUCCESS"
                return 0
            else
                log_warning "Claude API failed, falling back to manual"
                export LLM_STATUS="FALLBACK"
                call_llm_manual_v2 "$prompt"
                return 2
            fi
            ;;
            
        *)
            # Auto-detect: prefer local if available and in offline mode
            if [[ ${OFFLINE_MODE:-0} -eq 1 ]] && command -v interpreter &> /dev/null; then
                log_progress "Auto-routing to local AI (offline mode)..."
                echo "[$timestamp] ROUTING: Auto -> Local AI" >> "$LLM_LOG"
                
                if execute_local_ai "$prompt"; then
                    export LLM_STATUS="SUCCESS"
                    return 0
                else
                    export LLM_STATUS="FALLBACK"
                    call_llm_manual_v2 "$prompt"
                    return 2
                fi
            else
                log_progress "Auto-routing to Claude Code (cloud)..."
                echo "[$timestamp] ROUTING: Auto -> Cloud" >> "$LLM_LOG"
                
                if execute_claude_api "$prompt"; then
                    export LLM_STATUS="SUCCESS"
                    return 0
                else
                    export LLM_STATUS="FALLBACK"
                    call_llm_manual_v2 "$prompt"
                    return 2
                fi
            fi
            ;;
    esac
}

# Enhanced manual processing with better UX
call_llm_manual_v2() {
    local prompt="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    print_separator
    echo -e "${CYAN}🤖 LLM Manual Processing Required${NC}"
    print_separator
    
    echo -e "${YELLOW}The AI system needs manual intervention.${NC}"
    echo ""
    echo -e "${BLUE}Prompt to process:${NC}"
    echo "$prompt" | fold -s -w 80
    echo ""
    
    # Provide copy-friendly format
    echo -e "${GREEN}📋 Copy this prompt to Claude Code:${NC}"
    echo "----------------------------------------"
    echo "$prompt"
    echo "----------------------------------------"
    echo ""
    
    # Helpful instructions based on mode
    if [[ ${OFFLINE_MODE:-0} -eq 1 ]]; then
        log_info "You're in offline mode. To enable local AI:"
        echo "  1. Run: modules/local_llm_setup.sh"
        echo "  2. Install Ollama and a code model"
    else
        log_info "For automatic processing:"
        echo "  1. Ensure Claude Code CLI is installed"
        echo "  2. Run: claude (to authenticate if needed)"
    fi
    
    # Log manual processing
    echo "[$timestamp] RESULT: Manual processing requested" >> "$LLM_LOG"
    update_metrics "manual"
    
    # Wait for user acknowledgment
    echo ""
    read -n 1 -s -r -p "Press any key to continue..."
    echo ""
}

# Show LLM usage statistics
llm_stats() {
    print_header "LLM Usage Statistics"
    
    if [ -f "$LLM_METRICS" ]; then
        local metrics
        metrics=$(cat "$LLM_METRICS")
        
        local local_calls=$(echo "$metrics" | jq -r '.local // 0')
        local cloud_calls=$(echo "$metrics" | jq -r '.cloud // 0')
        local manual_calls=$(echo "$metrics" | jq -r '.manual // 0')
        local failed_calls=$(echo "$metrics" | jq -r '.failed // 0')
        local tokens_saved=$(echo "$metrics" | jq -r '.total_tokens_saved // 0')
        local total_calls=$((local_calls + cloud_calls + manual_calls))
        
        echo -e "${BLUE}Total LLM Calls:${NC} $total_calls"
        echo ""
        
        if [ $total_calls -gt 0 ]; then
            local local_pct=$((local_calls * 100 / total_calls))
            local cloud_pct=$((cloud_calls * 100 / total_calls))
            local manual_pct=$((manual_calls * 100 / total_calls))
            
            echo -e "${GREEN}Local AI:${NC} $local_calls calls ($local_pct%)"
            echo -e "${CYAN}Cloud AI:${NC} $cloud_calls calls ($cloud_pct%)"
            echo -e "${YELLOW}Manual:${NC} $manual_calls calls ($manual_pct%)"
            
            if [ $failed_calls -gt 0 ]; then
                echo -e "${RED}Failed:${NC} $failed_calls calls"
            fi
            
            echo ""
            echo -e "${GREEN}Estimated tokens saved:${NC} ~$tokens_saved"
            
            # Show token efficiency
            if [ $cloud_calls -gt 0 ] && [ $local_calls -gt 0 ]; then
                local efficiency=$((local_calls * 100 / (local_calls + cloud_calls)))
                echo -e "${PURPLE}Token efficiency:${NC} $efficiency% (local vs cloud)"
            fi
        else
            echo "No LLM calls recorded yet."
        fi
        
        # Show last update
        local last_updated=$(echo "$metrics" | jq -r '.last_updated // "never"')
        echo ""
        echo -e "${BLUE}Last updated:${NC} $last_updated"
    else
        log_warning "No metrics file found. Metrics will be created on first LLM call."
    fi
}

# Export enhanced functions
export -f llm_v2 call_llm_manual_v2 execute_local_ai execute_claude_api
export -f sanitize_prompt update_metrics llm_stats

# Backward compatibility wrapper
llm() {
    llm_v2 "$@"
}
call_llm() {
    llm_v2 "$@"
}
call_llm_manual() {
    call_llm_manual_v2 "$@"
}

export -f llm call_llm call_llm_manual

# Test function
test_llm_v2() {
    print_header "Testing Enhanced LLM Router"
    
    # Test sanitization
    echo "Testing prompt sanitization..."
    local test_prompt="Process user@example.com at 192.168.1.1 with token abc123def456ghi789jkl012mno345pqr678"
    local sanitized
    sanitized=$(sanitize_prompt "$test_prompt")
    echo "Original: $test_prompt"
    echo "Sanitized: $sanitized"
    echo ""
    
    # Test metrics
    echo "Testing metrics update..."
    update_metrics "local" 50
    update_metrics "cloud" 0
    
    # Show stats
    llm_stats
}

# Run test if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    test_llm_v2
fi