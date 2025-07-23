#!/bin/bash
# LLM_CAPABILITY: local_ok
# Enhanced LLM Router v2 with Confidence-Based Routing
# Routes requests between local and cloud AI based on confidence levels

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/input_sanitization.sh" 2>/dev/null || true
source "$SCRIPT_DIR/ai_model_registry.sh" 2>/dev/null || true

# Configuration
AI_DIR="$HOME/.bill-sloth/ai"
ROUTER_CONFIG="$AI_DIR/router_config.json"
CONFIDENCE_THRESHOLD=0.7
MAX_LOCAL_RETRIES=2
REQUEST_TIMEOUT=30

# Initialize router
init_llm_router() {
    log_info "Initializing LLM Router v2..."
    
    # Create router config if not exists
    if [ ! -f "$ROUTER_CONFIG" ]; then
        create_router_config
    fi
    
    # Ensure AI registry is initialized
    init_ai_registry
    
    log_success "LLM Router v2 initialized"
}

# Create router configuration
create_router_config() {
    cat > "$ROUTER_CONFIG" << 'EOF'
{
  "version": "2.0",
  "routing_strategy": "confidence_based",
  "confidence_threshold": 0.7,
  "timeout_seconds": 30,
  "max_retries": 2,
  "task_routing": {
    "coding": {
      "preferred_local": ["deepseek-coder:6.7b", "codellama:7b"],
      "confidence_boost": 0.1,
      "timeout_seconds": 45
    },
    "general": {
      "preferred_local": ["llama3.2:3b", "mistral:7b"],
      "confidence_boost": 0.0,
      "timeout_seconds": 30
    },
    "quick": {
      "preferred_local": ["phi3:mini", "llama3.2:3b"],
      "confidence_boost": -0.1,
      "timeout_seconds": 15
    },
    "complex": {
      "preferred_local": ["mistral:7b"],
      "confidence_boost": 0.2,
      "timeout_seconds": 60
    }
  },
  "fallback_chain": [
    "local_best",
    "local_fastest", 
    "cloud_api"
  ],
  "resource_limits": {
    "max_concurrent_local": 2,
    "memory_threshold_mb": 1024,
    "cpu_threshold_percent": 80
  }
}
EOF
}

# Analyze task type from prompt
analyze_task_type() {
    local prompt="$1"
    local prompt_lower
    prompt_lower=$(echo "$prompt" | tr '[:upper:]' '[:lower:]')
    
    # Coding task detection
    if echo "$prompt_lower" | grep -E "(code|script|function|debug|programming|bash|python|javascript|automat)" >/dev/null; then
        echo "coding"
        return 0
    fi
    
    # Quick task detection (short prompts, simple questions)
    if [ ${#prompt} -lt 100 ] && echo "$prompt_lower" | grep -E "(what|how|quick|fast|simple|yes|no)" >/dev/null; then
        echo "quick"
        return 0
    fi
    
    # Complex task detection
    if [ ${#prompt} -gt 500 ] || echo "$prompt_lower" | grep -E "(analyze|complex|detailed|comprehensive|strategy|plan)" >/dev/null; then
        echo "complex"
        return 0
    fi
    
    # Default to general
    echo "general"
}

# Calculate confidence score for local processing
calculate_confidence() {
    local task_type="$1"
    local prompt_length="$2"
    local available_models="$3"
    
    local base_confidence=0.5
    local confidence=$base_confidence
    
    # Task type boost
    local task_boost
    task_boost=$(jq -r ".task_routing[\"$task_type\"].confidence_boost // 0" "$ROUTER_CONFIG")
    confidence=$(echo "$confidence + $task_boost" | bc -l)
    
    # Model availability boost
    if [ -n "$available_models" ]; then
        local model_count
        model_count=$(echo "$available_models" | wc -w)
        local model_boost=$(echo "scale=2; $model_count * 0.1" | bc)
        confidence=$(echo "$confidence + $model_boost" | bc -l)
    fi
    
    # Prompt length penalty for very long prompts
    if [ "$prompt_length" -gt 1000 ]; then
        local length_penalty=$(echo "scale=2; ($prompt_length - 1000) / 10000" | bc)
        confidence=$(echo "$confidence - $length_penalty" | bc -l)
    fi
    
    # Resource availability check
    local memory_usage
    memory_usage=$(free | awk 'NR==2{printf "%.1f", $3*100/$2}')
    if [ "$(echo "$memory_usage > 80" | bc)" -eq 1 ]; then
        confidence=$(echo "$confidence - 0.2" | bc -l)
    fi
    
    # Clamp between 0 and 1
    confidence=$(echo "if ($confidence < 0) 0 else if ($confidence > 1) 1 else $confidence" | bc -l)
    
    echo "$confidence"
}

# Get available local models for task type
get_available_models() {
    local task_type="$1"
    
    # Get preferred models for task type
    local preferred_models
    preferred_models=$(jq -r ".task_routing[\"$task_type\"].preferred_local[]?" "$ROUTER_CONFIG" 2>/dev/null || echo "")
    
    local available=""
    
    # Check which preferred models are installed
    for model in $preferred_models; do
        if jq -e ".models[\"$model\"].installed == true" "$REGISTRY_FILE" >/dev/null 2>&1; then
            available="$available $model"
        fi
    done
    
    # If no preferred models available, get any installed model
    if [ -z "$available" ]; then
        available=$(jq -r '.models | to_entries[] | select(.value.installed == true) | .key' "$REGISTRY_FILE" 2>/dev/null | head -3 | tr '\n' ' ')
    fi
    
    echo "$available" | xargs
}

# Route LLM request with confidence-based decision
route_llm_request() {
    local prompt="$1"
    local task_type="${2:-auto}"
    local force_local="${3:-false}"
    local force_cloud="${4:-false}"
    
    # Sanitize inputs
    prompt=$(sanitize_input "$prompt" true)
    task_type=$(sanitize_input "$task_type" false)
    
    # Auto-detect task type if needed
    if [ "$task_type" = "auto" ]; then
        task_type=$(analyze_task_type "$prompt")
    fi
    
    log_debug "Task type: $task_type"
    
    # Get available models
    local available_models
    available_models=$(get_available_models "$task_type")
    
    log_debug "Available models: $available_models"
    
    # Calculate confidence for local processing
    local confidence
    confidence=$(calculate_confidence "$task_type" "${#prompt}" "$available_models")
    
    log_debug "Local confidence: $confidence"
    
    # Get threshold
    local threshold
    threshold=$(jq -r '.confidence_threshold' "$ROUTER_CONFIG")
    
    # Routing decision
    local use_local=false
    local routing_reason=""
    
    if [ "$force_cloud" = "true" ]; then
        use_local=false
        routing_reason="forced_cloud"
    elif [ "$force_local" = "true" ]; then
        use_local=true
        routing_reason="forced_local"
    elif [ -z "$available_models" ]; then
        use_local=false
        routing_reason="no_local_models"
    elif [ "$(echo "$confidence >= $threshold" | bc)" -eq 1 ]; then
        use_local=true
        routing_reason="high_confidence"
    else
        use_local=false
        routing_reason="low_confidence"
    fi
    
    log_info "Routing decision: $([ "$use_local" = "true" ] && echo "LOCAL" || echo "CLOUD") ($routing_reason)"
    
    # Log routing decision
    log_routing_decision "$task_type" "$confidence" "$use_local" "$routing_reason"
    
    # Execute request
    if [ "$use_local" = "true" ]; then
        execute_local_request "$prompt" "$task_type" "$available_models"
    else
        execute_cloud_request "$prompt" "$task_type"
    fi
}

# Execute local LLM request
execute_local_request() {
    local prompt="$1"
    local task_type="$2"
    local available_models="$3"
    
    local best_model
    best_model=$(echo "$available_models" | cut -d' ' -f1)
    
    if [ -z "$best_model" ]; then
        log_error "No local models available"
        return 1
    fi
    
    log_info "Using local model: $best_model"
    
    local start_time=$(date +%s%N)
    local response=""
    local success=false
    
    # Get timeout for task type
    local timeout
    timeout=$(jq -r ".task_routing[\"$task_type\"].timeout_seconds // 30" "$ROUTER_CONFIG")
    
    # Execute with timeout
    if response=$(timeout "$timeout" ollama run "$best_model" "$prompt" 2>/dev/null); then
        success=true
        local end_time=$(date +%s%N)
        local latency_ms=$(( (end_time - start_time) / 1000000 ))
        
        log_success "Local request completed in ${latency_ms}ms"
        
        # Update stats
        update_model_stats "$best_model" "$task_type" "$latency_ms" true
        
        echo "$response"
    else
        log_error "Local request failed"
        update_model_stats "$best_model" "$task_type" 0 false
        
        # Fallback to cloud
        log_info "Falling back to cloud API"
        execute_cloud_request "$prompt" "$task_type"
    fi
}

# Execute cloud API request
execute_cloud_request() {
    local prompt="$1"
    local task_type="$2"
    
    log_info "Using cloud API"
    
    local start_time=$(date +%s%N)
    
    # This would integrate with actual cloud API
    # For now, simulate cloud response
    local response="[CLOUD API RESPONSE] This would be processed by Claude/GPT API: $prompt"
    
    local end_time=$(date +%s%N)
    local latency_ms=$(( (end_time - start_time) / 1000000 ))
    
    log_info "Cloud request completed in ${latency_ms}ms"
    
    # Update cloud stats
    jq --argjson latency "$latency_ms" \
       '.cloud_requests += 1 |
        .performance.avg_cloud_latency_ms = ((.performance.avg_cloud_latency_ms + $latency) / 2)' \
       "$ROUTER_STATS" > "$ROUTER_STATS.tmp"
    mv "$ROUTER_STATS.tmp" "$ROUTER_STATS"
    
    echo "$response"
}

# Log routing decision for analysis
log_routing_decision() {
    local task_type="$1"
    local confidence="$2"
    local used_local="$3"
    local reason="$4"
    
    local timestamp=$(date -Iseconds)
    local log_entry="$timestamp,$task_type,$confidence,$used_local,$reason"
    
    echo "$log_entry" >> "$CONFIDENCE_LOG"
    
    # Keep log file manageable (last 1000 entries)
    if [ -f "$CONFIDENCE_LOG" ] && [ "$(wc -l < "$CONFIDENCE_LOG")" -gt 1000 ]; then
        tail -1000 "$CONFIDENCE_LOG" > "$CONFIDENCE_LOG.tmp"
        mv "$CONFIDENCE_LOG.tmp" "$CONFIDENCE_LOG"
    fi
}

# Show router performance analytics
show_router_analytics() {
    echo "📊 LLM ROUTER PERFORMANCE ANALYTICS"
    echo "==================================="
    echo ""
    
    if [ ! -f "$CONFIDENCE_LOG" ]; then
        echo "❌ No routing data available"
        return 1
    fi
    
    local total_requests
    total_requests=$(wc -l < "$CONFIDENCE_LOG")
    
    local local_requests
    local_requests=$(grep ",true," "$CONFIDENCE_LOG" | wc -l)
    
    local cloud_requests
    cloud_requests=$(grep ",false," "$CONFIDENCE_LOG" | wc -l)
    
    echo "🔄 Routing Summary:"
    echo "Total requests: $total_requests"
    echo "Local requests: $local_requests ($(( local_requests * 100 / total_requests ))%)"
    echo "Cloud requests: $cloud_requests ($(( cloud_requests * 100 / total_requests ))%)"
    echo ""
    
    echo "📋 Task Type Breakdown:"
    for task_type in coding general quick complex; do
        local task_count
        task_count=$(grep ",$task_type," "$CONFIDENCE_LOG" | wc -l)
        if [ "$task_count" -gt 0 ]; then
            local task_local
            task_local=$(grep ",$task_type," "$CONFIDENCE_LOG" | grep ",true," | wc -l)
            echo "$task_type: $task_count requests ($(( task_local * 100 / task_count ))% local)"
        fi
    done
    
    echo ""
    echo "🎯 Confidence Distribution:"
    echo "High confidence (>0.7): $(awk -F, '$3 > 0.7' "$CONFIDENCE_LOG" | wc -l)"
    echo "Medium confidence (0.4-0.7): $(awk -F, '$3 >= 0.4 && $3 <= 0.7' "$CONFIDENCE_LOG" | wc -l)"
    echo "Low confidence (<0.4): $(awk -F, '$3 < 0.4' "$CONFIDENCE_LOG" | wc -l)"
}

# Interactive router testing
test_router() {
    echo "🧪 LLM ROUTER TESTING"
    echo "====================="
    echo ""
    
    while true; do
        echo "Enter test prompt (or 'quit' to exit):"
        local prompt
        prompt=$(safe_prompt "Prompt")
        
        if [ "$prompt" = "quit" ]; then
            break
        fi
        
        echo ""
        echo "🔄 Routing prompt..."
        echo ""
        
        local response
        response=$(route_llm_request "$prompt")
        
        echo ""
        echo "📝 Response:"
        echo "$response"
        echo ""
        echo "---"
        echo ""
    done
}

# Export functions
export -f init_llm_router route_llm_request execute_local_request execute_cloud_request
export -f analyze_task_type calculate_confidence get_available_models
export -f show_router_analytics test_router

# Main function for standalone execution
main() {
    local command="${1:-route}"
    shift || true
    
    case "$command" in
        init) init_llm_router ;;
        route) route_llm_request "$@" ;;
        analytics) show_router_analytics ;;
        test) test_router ;;
        *)
            echo "Usage: $0 {init|route|analytics|test}"
            echo ""
            echo "Commands:"
            echo "  init       - Initialize LLM router"
            echo "  route      - Route a prompt to local/cloud"
            echo "  analytics  - Show routing performance"
            echo "  test       - Interactive router testing"
            return 1
            ;;
    esac
}

# Initialize on first source
if [ ! -f "$AI_DIR/.router-initialized" ]; then
    init_llm_router
    touch "$AI_DIR/.router-initialized"
fi

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi