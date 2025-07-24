#!/bin/bash
# LLM_CAPABILITY: local_ok
# Local LLM Integration Library
# Provides local AI capabilities for Bill Sloth system independence

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Source required libraries
source "$(dirname "${BASH_SOURCE[0]}")/error_handling.sh"
source "$(dirname "${BASH_SOURCE[0]}")/notification.sh"
source "$(dirname "${BASH_SOURCE[0]}")/data_persistence.sh"

# Configuration
LOCAL_LLM_DIR="$HOME/.local/share/bill-sloth/llm"
OLLAMA_DIR="$HOME/.ollama"
LLM_CONFIG_FILE="$LOCAL_LLM_DIR/config.json"
LLM_MODELS_DIR="$LOCAL_LLM_DIR/models"
WHISPER_MODELS_DIR="$LOCAL_LLM_DIR/whisper"

# Default models for different use cases
DEFAULT_CHAT_MODEL="llama3.2:3b"
DEFAULT_CODE_MODEL="deepseek-coder:6.7b"
DEFAULT_BUSINESS_MODEL="phi3:medium"
DEFAULT_WHISPER_MODEL="whisper:medium"

create_llm_directories() {
    log_info "Creating local LLM directories"
    
    mkdir -p "$LOCAL_LLM_DIR"
    mkdir -p "$LLM_MODELS_DIR"
    mkdir -p "$WHISPER_MODELS_DIR"
    mkdir -p "$OLLAMA_DIR"
    
    log_success "LLM directories created"
}

check_ollama_installation() {
    log_info "Checking Ollama installation"
    
    if command -v ollama >/dev/null 2>&1; then
        log_success "Ollama is installed"
        return 0
    else
        log_warning "Ollama not found - will install"
        return 1
    fi
}

install_ollama() {
    log_info "Installing Ollama for local LLM management"
    
    # Check if running on Linux
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Install Ollama
        curl -fsSL https://ollama.ai/install.sh | sh
        
        # Start Ollama service
        systemctl --user enable ollama
        systemctl --user start ollama
        
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS installation
        if command -v brew >/dev/null 2>&1; then
            brew install ollama
        else
            log_error "Homebrew required for macOS installation"
            return 1
        fi
    else
        log_warning "Manual Ollama installation required for this OS"
        log_info "Visit: https://ollama.ai/download"
        return 1
    fi
    
    log_success "Ollama installation completed"
}

download_recommended_models() {
    log_info "Downloading recommended models for Bill Sloth workflows"
    
    # Check available disk space (need at least 10GB)
    local available_space=$(df "$HOME" | awk 'NR==2 {print $4}')
    local required_space=10485760  # 10GB in KB
    
    if [ "$available_space" -lt "$required_space" ]; then
        log_warning "Insufficient disk space for all models. Downloading minimal set."
        
        # Download only essential lightweight models
        ollama pull "$DEFAULT_CHAT_MODEL"
        
    else
        log_info "Sufficient space available. Downloading full model suite."
        
        # Download recommended models
        ollama pull "$DEFAULT_CHAT_MODEL"     # General chat - 2GB
        ollama pull "$DEFAULT_CODE_MODEL"     # Code assistance - 4GB  
        ollama pull "$DEFAULT_BUSINESS_MODEL" # Business tasks - 2.5GB
        
        # Additional specialized models
        ollama pull "mistral:7b"              # Alternative chat model
        ollama pull "codellama:7b"            # Code generation
    fi
    
    log_success "Model downloads completed"
}

create_llm_config() {
    log_info "Creating LLM configuration"
    
    cat > "$LLM_CONFIG_FILE" << 'EOF'
{
  "local_llm": {
    "enabled": true,
    "primary_backend": "ollama",
    "fallback_enabled": true,
    "models": {
      "chat": "llama3.2:3b",
      "code": "deepseek-coder:6.7b", 
      "business": "phi3:medium",
      "whisper": "whisper:medium"
    },
    "performance": {
      "max_tokens": 2048,
      "temperature": 0.7,
      "context_window": 4096,
      "gpu_acceleration": true,
      "cpu_threads": 4
    },
    "privacy": {
      "local_only": true,
      "log_conversations": false,
      "encrypt_storage": true
    }
  },
  "integration_points": {
    "voice_control": {
      "enabled": true,
      "wake_word_model": "whisper:medium",
      "response_model": "llama3.2:3b"
    },
    "business_automation": {
      "enabled": true,
      "email_generation": "phi3:medium",
      "data_analysis": "phi3:medium"
    },
    "code_assistance": {
      "enabled": true,
      "completion_model": "deepseek-coder:6.7b",
      "review_model": "codellama:7b"
    }
  }
}
EOF
    
    log_success "LLM configuration created"
}

test_local_llm() {
    local model="${1:-$DEFAULT_CHAT_MODEL}"
    
    log_info "Testing local LLM: $model"
    
    # Simple test query
    local test_response=$(ollama run "$model" "Hello! Please respond with exactly: LLM_TEST_SUCCESS")
    
    if echo "$test_response" | grep -q "LLM_TEST_SUCCESS"; then
        log_success "Local LLM test passed"
        return 0
    else
        log_error "Local LLM test failed"
        return 1
    fi
}

query_local_llm() {
    local prompt="$1"
    local model="${2:-$DEFAULT_CHAT_MODEL}"
    local max_tokens="${3:-1024}"
    
    if ! check_ollama_installation; then
        log_error "Ollama not available for local LLM query"
        return 1
    fi
    
    # Execute query with timeout (use command -v to check if timeout exists)
    if command -v timeout >/dev/null 2>&1; then
        timeout 30s ollama run "$model" "$prompt" 2>/dev/null || {
            log_error "Local LLM query timed out or failed"
            return 1
        }
    else
        # Fallback without timeout command
        ollama run "$model" "$prompt" 2>/dev/null || {
            log_error "Local LLM query failed"
            return 1
        }
    fi
}

generate_business_email() {
    local email_type="$1"
    local context="$2"
    
    local prompt="Generate a professional $email_type email. Context: $context. 
    Requirements:
    - Professional tone
    - Clear and concise  
    - Include proper greeting and closing
    - Maximum 200 words
    
    Email:"
    
    query_local_llm "$prompt" "$DEFAULT_BUSINESS_MODEL"
}

analyze_business_data() {
    local data_file="$1"
    local analysis_type="$2"
    
    local prompt="Analyze this business data for $analysis_type insights. 
    Data: $(head -20 "$data_file" 2>/dev/null)
    
    Provide:
    - Key metrics summary
    - Trends and patterns
    - Actionable recommendations
    - Risk factors to monitor
    
    Analysis:"
    
    query_local_llm "$prompt" "$DEFAULT_BUSINESS_MODEL"
}

code_completion() {
    local code_context="$1"
    local completion_request="$2"
    
    local prompt="Complete this code:
    
    Context: $code_context
    Request: $completion_request
    
    Provide only the completed code, no explanations:
    "
    
    query_local_llm "$prompt" "$DEFAULT_CODE_MODEL"
}

create_llm_api_wrapper() {
    log_info "Creating local LLM API wrapper"
    
    cat > "$LOCAL_LLM_DIR/api_server.py" << 'EOF'
#!/usr/bin/env python3
"""
Local LLM API Wrapper
Provides OpenAI-compatible API for Bill Sloth local models
"""

import json
import subprocess
import time
from datetime import datetime
from flask import Flask, request, jsonify
from threading import Lock

app = Flask(__name__)
query_lock = Lock()

CONFIG_FILE = "/home/$USER/.local/share/bill-sloth/llm/config.json"

def load_config():
    try:
        with open(CONFIG_FILE, 'r') as f:
            return json.load(f)
    except:
        return {"local_llm": {"models": {"chat": "llama3.2:3b"}}}

def query_ollama(prompt, model="llama3.2:3b", max_tokens=1024):
    """Query Ollama with thread safety"""
    with query_lock:
        try:
            cmd = ["ollama", "run", model, prompt]
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
            
            if result.returncode == 0:
                return {"success": True, "response": result.stdout.strip()}
            else:
                return {"success": False, "error": result.stderr}
                
        except subprocess.TimeoutExpired:
            return {"success": False, "error": "Query timeout"}
        except Exception as e:
            return {"success": False, "error": str(e)}

@app.route('/v1/chat/completions', methods=['POST'])
def chat_completions():
    """OpenAI-compatible chat completions endpoint"""
    data = request.get_json()
    
    # Extract prompt from messages
    messages = data.get('messages', [])
    prompt = messages[-1].get('content', '') if messages else ''
    
    model = data.get('model', 'llama3.2:3b')
    max_tokens = data.get('max_tokens', 1024)
    
    # Query local model
    result = query_ollama(prompt, model, max_tokens)
    
    if result['success']:
        response = {
            "id": f"local-{int(time.time())}",
            "object": "chat.completion",
            "created": int(time.time()),
            "model": model,
            "choices": [{
                "index": 0,
                "message": {
                    "role": "assistant",
                    "content": result['response']
                },
                "finish_reason": "stop"
            }],
            "usage": {
                "prompt_tokens": len(prompt.split()),
                "completion_tokens": len(result['response'].split()),
                "total_tokens": len(prompt.split()) + len(result['response'].split())
            }
        }
        return jsonify(response)
    else:
        return jsonify({"error": result['error']}), 500

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "timestamp": datetime.now().isoformat()})

@app.route('/models', methods=['GET']) 
def list_models():
    """List available models"""
    try:
        result = subprocess.run(["ollama", "list"], capture_output=True, text=True)
        models = []
        for line in result.stdout.split('\n')[1:]:  # Skip header
            if line.strip():
                model_name = line.split()[0]
                models.append({
                    "id": model_name,
                    "object": "model",
                    "created": int(time.time()),
                    "owned_by": "local"
                })
        
        return jsonify({"object": "list", "data": models})
    except:
        return jsonify({"error": "Failed to list models"}), 500

if __name__ == '__main__':
    print("Starting Bill Sloth Local LLM API Server...")
    app.run(host='127.0.0.1', port=8899, debug=False)
EOF
    
    chmod +x "$LOCAL_LLM_DIR/api_server.py"
    log_success "Local LLM API wrapper created"
}

start_llm_api_server() {
    log_info "Starting local LLM API server"
    
    # Check if server is already running
    if pgrep -f "api_server.py" >/dev/null; then
        log_info "LLM API server already running"
        return 0
    fi
    
    # Start server in background
    cd "$LOCAL_LLM_DIR"
    nohup python3 api_server.py > api_server.log 2>&1 &
    
    # Wait for server to start
    sleep 3
    
    # Test server
    if curl -s http://127.0.0.1:8899/health >/dev/null; then
        log_success "Local LLM API server started successfully"
        return 0
    else
        log_error "Failed to start LLM API server"
        return 1
    fi
}

create_llm_integration_scripts() {
    log_info "Creating LLM integration helper scripts"
    
    # Chat interface script
    cat > "$LOCAL_LLM_DIR/chat" << 'EOF'
#!/bin/bash
# Quick chat interface for local LLM

source ~/.local/share/bill-sloth/llm/../lib/local_llm_integration.sh

if [ $# -eq 0 ]; then
    echo "Usage: $0 'your question here'"
    echo "Example: $0 'Help me write a professional email'"
    exit 1
fi

query_local_llm "$*"
EOF
    
    # Business assistant script
    cat > "$LOCAL_LLM_DIR/business-assist" << 'EOF'
#!/bin/bash
# Business-focused LLM assistant

source ~/.local/share/bill-sloth/llm/../lib/local_llm_integration.sh

case "$1" in
    "email")
        generate_business_email "$2" "$3"
        ;;
    "analyze")
        analyze_business_data "$2" "$3"
        ;;
    *)
        echo "Usage: $0 {email|analyze} [type] [context]"
        echo "Examples:"
        echo "  $0 email partnership 'Follow up on EdBoiGames collaboration'"
        echo "  $0 analyze revenue.csv 'monthly trends'"
        ;;
esac
EOF
    
    # Code assistant script
    cat > "$LOCAL_LLM_DIR/code-assist" << 'EOF'
#!/bin/bash
# Code assistance with local LLM

source ~/.local/share/bill-sloth/llm/../lib/local_llm_integration.sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 'code context' 'completion request'"
    echo "Example: $0 'bash function to backup files' 'add error handling'"
    exit 1
fi

code_completion "$1" "$2"
EOF
    
    chmod +x "$LOCAL_LLM_DIR"/{chat,business-assist,code-assist}
    
    # Add to PATH
    echo "export PATH=\"\$PATH:$LOCAL_LLM_DIR\"" >> ~/.bashrc
    
    log_success "LLM integration scripts created"
}

optimize_llm_performance() {
    log_info "Optimizing local LLM performance"
    
    # GPU detection and configuration
    if command -v nvidia-smi >/dev/null 2>&1; then
        log_info "NVIDIA GPU detected - enabling GPU acceleration"
        export OLLAMA_GPU_ENABLE=1
        
        # Optimize GPU memory usage
        cat > "$OLLAMA_DIR/gpu_config.json" << 'EOF'
{
  "gpu_memory_fraction": 0.8,
  "allow_memory_growth": true,
  "gpu_layers": 35
}
EOF
    fi
    
    # CPU optimization
    local cpu_cores=$(nproc)
    local optimal_threads=$((cpu_cores - 1))
    
    export OLLAMA_NUM_PARALLEL="$optimal_threads"
    export OLLAMA_MAX_LOADED_MODELS=2
    
    # Memory optimization
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1
    
    log_success "LLM performance optimization completed"
}

setup_local_llm_complete() {
    log_info "Setting up complete local LLM integration for Bill Sloth"
    
    create_llm_directories
    
    if ! check_ollama_installation; then
        install_ollama
    fi
    
    download_recommended_models
    create_llm_config
    create_llm_api_wrapper
    create_llm_integration_scripts
    optimize_llm_performance
    
    # Test the setup
    if test_local_llm; then
        start_llm_api_server
        
        log_success "Local LLM integration setup completed successfully!"
        log_info "Available commands:"
        log_info "  - chat 'your question'"
        log_info "  - business-assist email partnership 'context'"
        log_info "  - code-assist 'context' 'request'"
        log_info "  - API server: http://127.0.0.1:8899"
        
        # Save integration status
        save_state "local_llm_enabled" "true"
        save_state "local_llm_setup_date" "$(date)"
        
        return 0
    else
        log_error "Local LLM setup failed verification"
        return 1
    fi
}

# Integration with existing Bill Sloth systems
integrate_with_voice_control() {
    log_info "Integrating local LLM with voice control"
    
    # Update voice control to use local LLM for processing
    if [ -f "$(dirname "${BASH_SOURCE[0]}")/voice_control.sh" ]; then
        echo "
# Local LLM Integration for Voice Control
use_local_llm_for_voice() {
    local voice_command=\"\$1\"
    local llm_response=\$(query_local_llm \"Process this voice command and provide a brief response: \$voice_command\" \"$DEFAULT_CHAT_MODEL\")
    echo \"\$llm_response\"
}

# Override default voice processing
process_voice_command() {
    local command=\"\$1\"
    use_local_llm_for_voice \"\$command\"
}
" >> "$(dirname "${BASH_SOURCE[0]}")/voice_control.sh"
        
        log_success "Voice control integration completed"
    fi
}

integrate_with_business_automation() {
    log_info "Integrating local LLM with business automation"
    
    # Update email automation to use local LLM
    if [ -f "$(dirname "${BASH_SOURCE[0]}")/advanced_email_automation.sh" ]; then
        echo "
# Local LLM Integration for Email Generation
generate_email_with_local_llm() {
    local email_type=\"\$1\"
    local context=\"\$2\"
    generate_business_email \"\$email_type\" \"\$context\"
}

# Override default email generation
enhance_email_content() {
    local template=\"\$1\"
    local context=\"\$2\"
    generate_email_with_local_llm \"\$template\" \"\$context\"
}
" >> "$(dirname "${BASH_SOURCE[0]}")/advanced_email_automation.sh"
        
        log_success "Business automation integration completed"
    fi
}

# Export functions for use by other scripts
export -f query_local_llm
export -f generate_business_email
export -f analyze_business_data
export -f code_completion
export -f test_local_llm