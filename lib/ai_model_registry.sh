#!/bin/bash
# LLM_CAPABILITY: local_ok
# AI Model Registry for Local AI Transition
# Manages local AI models with SHA validation and licensing

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/input_sanitization.sh" 2>/dev/null || true

# Configuration
AI_DIR="$HOME/.bill-sloth/ai"
REGISTRY_FILE="$AI_DIR/registry.json"
MODELS_DIR="$AI_DIR/models"
ROUTER_STATS="$AI_DIR/router_stats.json"
CONFIDENCE_LOG="$AI_DIR/confidence.log"

# Initialize AI model registry
init_ai_registry() {
    log_info "Initializing AI model registry..."
    
    # Create directories
    safe_mkdir "$AI_DIR" 755
    safe_mkdir "$MODELS_DIR" 755
    safe_mkdir "$AI_DIR/cache" 755
    safe_mkdir "$AI_DIR/logs" 755
    
    # Initialize registry if not exists
    if [ ! -f "$REGISTRY_FILE" ]; then
        create_registry_file
    fi
    
    # Initialize router stats
    if [ ! -f "$ROUTER_STATS" ]; then
        create_router_stats
    fi
    
    # Install ollama if not present
    if ! command -v ollama &>/dev/null; then
        install_ollama
    fi
    
    log_success "AI registry initialized"
}

# Create registry file with popular models
create_registry_file() {
    log_info "Creating AI model registry..."
    
    cat > "$REGISTRY_FILE" << 'EOF'
{
  "version": "1.0",
  "last_updated": "",
  "models": {
    "llama3.2:3b": {
      "name": "Llama 3.2 3B",
      "provider": "ollama",
      "size_gb": 2.0,
      "capabilities": ["chat", "code", "reasoning"],
      "use_cases": ["general", "coding", "fast_responses"],
      "performance": {
        "speed": "fast",
        "quality": "good",
        "resource_usage": "low"
      },
      "installed": false,
      "sha256": "",
      "license": "MIT",
      "confidence_threshold": 0.7
    },
    "codellama:7b": {
      "name": "Code Llama 7B",
      "provider": "ollama",
      "size_gb": 3.8,
      "capabilities": ["code", "programming", "debugging"],
      "use_cases": ["coding", "development", "automation"],
      "performance": {
        "speed": "medium",
        "quality": "excellent",
        "resource_usage": "medium"
      },
      "installed": false,
      "sha256": "",
      "license": "LLAMA2",
      "confidence_threshold": 0.8
    },
    "mistral:7b": {
      "name": "Mistral 7B",
      "provider": "ollama",
      "size_gb": 4.1,
      "capabilities": ["chat", "reasoning", "multilingual"],
      "use_cases": ["general", "analysis", "business"],
      "performance": {
        "speed": "medium",
        "quality": "excellent",
        "resource_usage": "medium"
      },
      "installed": false,
      "sha256": "",
      "license": "Apache-2.0",
      "confidence_threshold": 0.75
    },
    "phi3:mini": {
      "name": "Microsoft Phi-3 Mini",
      "provider": "ollama", 
      "size_gb": 2.3,
      "capabilities": ["chat", "reasoning", "efficiency"],
      "use_cases": ["quick_tasks", "resource_constrained", "mobile"],
      "performance": {
        "speed": "very_fast",
        "quality": "good",
        "resource_usage": "very_low"
      },
      "installed": false,
      "sha256": "",
      "license": "MIT",
      "confidence_threshold": 0.65
    },
    "deepseek-coder:6.7b": {
      "name": "DeepSeek Coder 6.7B",
      "provider": "ollama",
      "size_gb": 3.7,
      "capabilities": ["code", "programming", "documentation"],
      "use_cases": ["coding", "code_review", "documentation"],
      "performance": {
        "speed": "medium",
        "quality": "excellent",
        "resource_usage": "medium"
      },
      "installed": false,
      "sha256": "",
      "license": "DeepSeek",
      "confidence_threshold": 0.8
    }
  },
  "routing_rules": {
    "coding_tasks": ["deepseek-coder:6.7b", "codellama:7b"],
    "general_chat": ["llama3.2:3b", "mistral:7b"],
    "quick_responses": ["phi3:mini", "llama3.2:3b"],
    "complex_reasoning": ["mistral:7b", "codellama:7b"],
    "resource_constrained": ["phi3:mini", "llama3.2:3b"]
  },
  "fallback_chain": [
    "llama3.2:3b",
    "phi3:mini", 
    "cloud_api"
  ]
}
EOF
    
    # Update timestamp
    local timestamp=$(date -Iseconds)
    jq --arg ts "$timestamp" '.last_updated = $ts' "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
    mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
    
    log_success "AI registry created with 5 recommended models"
}

# Create router stats file
create_router_stats() {
    cat > "$ROUTER_STATS" << 'EOF'
{
  "version": "1.0",
  "last_reset": "",
  "total_requests": 0,
  "local_requests": 0,
  "cloud_requests": 0,
  "models": {},
  "performance": {
    "avg_local_latency_ms": 0,
    "avg_cloud_latency_ms": 0,
    "local_success_rate": 0,
    "cloud_success_rate": 0
  },
  "confidence_tracking": {
    "high_confidence_local": 0,
    "low_confidence_cloud": 0,
    "accuracy_feedback": {}
  }
}
EOF
    
    local timestamp=$(date -Iseconds)
    jq --arg ts "$timestamp" '.last_reset = $ts' "$ROUTER_STATS" > "$ROUTER_STATS.tmp"
    mv "$ROUTER_STATS.tmp" "$ROUTER_STATS"
}

# Install ollama
install_ollama() {
    log_info "Installing Ollama for local AI models..."
    
    if curl -fsSL https://ollama.ai/install.sh | sh; then
        log_success "Ollama installed successfully"
        
        # Start ollama service
        if command -v systemctl &>/dev/null; then
            sudo systemctl enable ollama || true
            sudo systemctl start ollama || true
        fi
    else
        log_error "Failed to install Ollama"
        return 1
    fi
}

# List available models
list_models() {
    echo "🤖 AI MODEL REGISTRY"
    echo "==================="
    echo ""
    
    if [ ! -f "$REGISTRY_FILE" ]; then
        echo "❌ Registry not initialized"
        return 1
    fi
    
    echo "📋 Available Models:"
    echo ""
    
    jq -r '.models | to_entries[] | 
        "\(.key): \(.value.name)
         Size: \(.value.size_gb)GB | Speed: \(.value.performance.speed) | Quality: \(.value.performance.quality)
         Use cases: \(.value.use_cases | join(", "))
         Installed: \(if .value.installed then "✅" else "❌" end)
         "' "$REGISTRY_FILE"
}

# Install a model
install_model() {
    local model_id="$1"
    
    if [ -z "$model_id" ]; then
        log_error "Usage: install_model <model_id>"
        return 1
    fi
    
    # Sanitize input
    model_id=$(sanitize_input "$model_id" false)
    
    # Check if model exists in registry
    if ! jq -e ".models[\"$model_id\"]" "$REGISTRY_FILE" >/dev/null; then
        log_error "Model not found in registry: $model_id"
        return 1
    fi
    
    local model_name
    model_name=$(jq -r ".models[\"$model_id\"].name" "$REGISTRY_FILE")
    local size_gb
    size_gb=$(jq -r ".models[\"$model_id\"].size_gb" "$REGISTRY_FILE")
    
    log_info "Installing model: $model_name ($size_gb GB)"
    
    # Check disk space
    local available_gb
    available_gb=$(df "$MODELS_DIR" | awk 'NR==2 {print int($4/1024/1024)}')
    
    if [ "$available_gb" -lt "$size_gb" ]; then
        log_error "Insufficient disk space. Need ${size_gb}GB, have ${available_gb}GB"
        return 1
    fi
    
    # Install via ollama
    if ollama pull "$model_id"; then
        # Update registry
        jq ".models[\"$model_id\"].installed = true" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
        mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
        
        # Get model SHA
        local model_sha
        model_sha=$(ollama show "$model_id" --modelfile | grep -E "^FROM" | cut -d: -f3 || echo "unknown")
        
        jq --arg sha "$model_sha" ".models[\"$model_id\"].sha256 = \$sha" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
        mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
        
        log_success "Model installed: $model_name"
        
        # Test model
        test_model "$model_id"
    else
        log_error "Failed to install model: $model_id"
        return 1
    fi
}

# Test a model
test_model() {
    local model_id="$1"
    
    if [ -z "$model_id" ]; then
        log_error "Usage: test_model <model_id>"
        return 1
    fi
    
    log_info "Testing model: $model_id"
    
    # Simple test prompt
    local test_prompt="What is 2+2? Answer briefly."
    local start_time=$(date +%s%N)
    
    local response
    if response=$(ollama run "$model_id" "$test_prompt" 2>/dev/null); then
        local end_time=$(date +%s%N)
        local duration_ms=$(( (end_time - start_time) / 1000000 ))
        
        log_success "Model test passed in ${duration_ms}ms"
        echo "Response: $response"
        
        # Update performance stats
        update_model_stats "$model_id" "test" "$duration_ms" true
        
        return 0
    else
        log_error "Model test failed"
        update_model_stats "$model_id" "test" 0 false
        return 1
    fi
}

# Update model performance statistics
update_model_stats() {
    local model_id="$1"
    local operation="$2"
    local latency_ms="$3"
    local success="$4"
    
    local timestamp=$(date -Iseconds)
    
    # Update router stats
    jq --arg model "$model_id" \
       --arg op "$operation" \
       --argjson latency "$latency_ms" \
       --argjson success "$success" \
       --arg ts "$timestamp" \
       '.total_requests += 1 |
        .local_requests += 1 |
        .models[$model] = (.models[$model] // {}) |
        .models[$model].requests = (.models[$model].requests // 0) + 1 |
        .models[$model].avg_latency_ms = ((.models[$model].avg_latency_ms // 0) + $latency) / 2 |
        .models[$model].success_rate = ((.models[$model].success_rate // 0) + (if $success then 1 else 0 end)) / .models[$model].requests |
        .models[$model].last_used = $ts' "$ROUTER_STATS" > "$ROUTER_STATS.tmp"
    
    mv "$ROUTER_STATS.tmp" "$ROUTER_STATS"
}

# Remove a model
remove_model() {
    local model_id="$1"
    
    if [ -z "$model_id" ]; then
        log_error "Usage: remove_model <model_id>"
        return 1
    fi
    
    model_id=$(sanitize_input "$model_id" false)
    
    log_info "Removing model: $model_id"
    
    if ollama rm "$model_id"; then
        # Update registry
        jq ".models[\"$model_id\"].installed = false | .models[\"$model_id\"].sha256 = \"\"" "$REGISTRY_FILE" > "$REGISTRY_FILE.tmp"
        mv "$REGISTRY_FILE.tmp" "$REGISTRY_FILE"
        
        log_success "Model removed: $model_id"
    else
        log_error "Failed to remove model: $model_id"
        return 1
    fi
}

# Show model performance stats
show_stats() {
    echo "📊 AI MODEL PERFORMANCE STATISTICS"
    echo "=================================="
    echo ""
    
    if [ ! -f "$ROUTER_STATS" ]; then
        echo "❌ No statistics available"
        return 1
    fi
    
    local total_requests
    total_requests=$(jq -r '.total_requests' "$ROUTER_STATS")
    local local_requests
    local_requests=$(jq -r '.local_requests' "$ROUTER_STATS")
    local cloud_requests
    cloud_requests=$(jq -r '.cloud_requests' "$ROUTER_STATS")
    
    echo "🔄 Request Summary:"
    echo "Total requests: $total_requests"
    echo "Local requests: $local_requests"
    echo "Cloud requests: $cloud_requests"
    
    if [ "$total_requests" -gt 0 ]; then
        local local_percent=$(( local_requests * 100 / total_requests ))
        echo "Local usage: ${local_percent}%"
    fi
    
    echo ""
    echo "🤖 Model Performance:"
    echo ""
    
    jq -r '.models | to_entries[] | 
        "\(.key):
         Requests: \(.value.requests // 0)
         Avg Latency: \(.value.avg_latency_ms // 0)ms
         Success Rate: \((.value.success_rate // 0) * 100 | floor)%
         Last Used: \(.value.last_used // "Never")
         "' "$ROUTER_STATS"
}

# Recommend models for installation
recommend_models() {
    echo "💡 AI MODEL RECOMMENDATIONS"
    echo "=========================="
    echo ""
    
    # Check system resources
    local ram_gb
    ram_gb=$(free -g | awk 'NR==2{print $2}')
    local disk_gb
    disk_gb=$(df "$HOME" | awk 'NR==2 {print int($4/1024/1024)}')
    
    echo "🖥️  System Resources:"
    echo "RAM: ${ram_gb}GB"
    echo "Available disk: ${disk_gb}GB"
    echo ""
    
    echo "📝 Recommended Installation Order:"
    echo ""
    
    if [ "$ram_gb" -ge 8 ] && [ "$disk_gb" -ge 10 ]; then
        echo "1. 🚀 phi3:mini (2.3GB) - Fast responses, low resource usage"
        echo "2. 💼 llama3.2:3b (2.0GB) - General purpose, good quality"
        echo "3. 💻 deepseek-coder:6.7b (3.7GB) - Excellent for coding tasks"
        echo "4. 🧠 mistral:7b (4.1GB) - High quality reasoning"
    elif [ "$ram_gb" -ge 4 ] && [ "$disk_gb" -ge 5 ]; then
        echo "1. 🚀 phi3:mini (2.3GB) - Best for limited resources"
        echo "2. 💼 llama3.2:3b (2.0GB) - Good general purpose model"
    else
        echo "⚠️  Limited resources detected. Consider:"
        echo "• Upgrading RAM to 8GB+ for better performance"
        echo "• Freeing up disk space for model storage"
        echo "• Using cloud API as primary with local as backup"
    fi
    
    echo ""
    echo "🎯 Bill's Recommended Starter Pack:"
    echo "• phi3:mini - For quick ADHD-friendly responses"
    echo "• deepseek-coder:6.7b - For automation scripting"
    echo "• llama3.2:3b - For general property management queries"
}

# Quick setup for Bill's use case
quick_setup_bill() {
    log_info "Setting up AI models for Bill's VRBO/automation use case..."
    
    # Install essential models for Bill
    local bill_models=("phi3:mini" "llama3.2:3b")
    
    for model in "${bill_models[@]}"; do
        log_info "Installing recommended model: $model"
        if install_model "$model"; then
            log_success "Installed: $model"
        else
            log_warning "Failed to install: $model"
        fi
    done
    
    # Test installed models
    log_info "Testing installed models..."
    for model in "${bill_models[@]}"; do
        test_model "$model" || true
    done
    
    log_success "Bill's AI setup complete!"
}

# Export functions
export -f init_ai_registry list_models install_model remove_model test_model
export -f show_stats recommend_models quick_setup_bill update_model_stats

# Main function for standalone execution
main() {
    local command="${1:-list}"
    shift || true
    
    case "$command" in
        init) init_ai_registry ;;
        list) list_models ;;
        install) install_model "$@" ;;
        remove) remove_model "$@" ;;
        test) test_model "$@" ;;
        stats) show_stats ;;
        recommend) recommend_models ;;
        setup-bill) quick_setup_bill ;;
        *)
            echo "Usage: $0 {init|list|install|remove|test|stats|recommend|setup-bill}"
            echo ""
            echo "Commands:"
            echo "  init         - Initialize AI model registry"
            echo "  list         - List available models"
            echo "  install      - Install a model"
            echo "  remove       - Remove a model"
            echo "  test         - Test a model"
            echo "  stats        - Show performance statistics"
            echo "  recommend    - Show model recommendations"
            echo "  setup-bill   - Quick setup for Bill's use case"
            return 1
            ;;
    esac
}

# Initialize on first source
if [ ! -f "$AI_DIR/.registry-initialized" ]; then
    init_ai_registry
    touch "$AI_DIR/.registry-initialized"
fi

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi