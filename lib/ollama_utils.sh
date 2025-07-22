#!/bin/bash
# Bill Sloth Centralized Ollama Utilities Library
# Consolidates Ollama installation, model management, and health checking

# Source error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Ollama configuration
OLLAMA_API_URL="${OLLAMA_API_URL:-http://localhost:11434}"
OLLAMA_MODELS_DIR="$HOME/.ollama/models"
OLLAMA_LOG="$HOME/.bill-sloth/logs/ollama.log"
OLLAMA_CONFIG="$HOME/.bill-sloth/ollama_config.json"

# Recommended models for different use cases
declare -A RECOMMENDED_MODELS=(
    ["code"]="codellama:7b-instruct"
    ["general"]="llama2:7b-chat"
    ["fast"]="phi:latest"
    ["large"]="llama2:13b-chat"
    ["coding"]="deepseek-coder:6.7b-instruct"
    ["small"]="tinyllama:latest"
)

# Model requirements (approximate)
declare -A MODEL_REQUIREMENTS=(
    ["codellama:7b-instruct"]="8GB_RAM,4GB_VRAM"
    ["llama2:7b-chat"]="8GB_RAM,4GB_VRAM"
    ["phi:latest"]="4GB_RAM,2GB_VRAM"
    ["llama2:13b-chat"]="16GB_RAM,8GB_VRAM"
    ["deepseek-coder:6.7b-instruct"]="8GB_RAM,4GB_VRAM"
    ["tinyllama:latest"]="2GB_RAM,1GB_VRAM"
)

# Ensure directories exist
create_ollama_directories() {
    create_directory "$(dirname "$OLLAMA_LOG")"
    create_directory "$(dirname "$OLLAMA_CONFIG")"
    
    # Initialize config if not exists
    if [ ! -f "$OLLAMA_CONFIG" ]; then
        cat > "$OLLAMA_CONFIG" << 'EOF'
{
    "api_url": "http://localhost:11434",
    "default_model": "",
    "auto_start": true,
    "gpu_enabled": true,
    "max_models": 3
}
EOF
    fi
}

# Check if Ollama is installed
is_ollama_installed() {
    command -v ollama &>/dev/null
}

# Check if Ollama service is running
is_ollama_running() {
    if ! is_ollama_installed; then
        return 1
    fi
    
    # Try to ping the API
    if command -v curl &>/dev/null; then
        curl -s "$OLLAMA_API_URL/api/version" >/dev/null 2>&1
    else
        # Fallback: check if process is running
        pgrep -f "ollama" >/dev/null 2>&1
    fi
}

# Start Ollama service
start_ollama() {
    log_info "Starting Ollama service..."
    
    if is_ollama_running; then
        log_success "Ollama is already running"
        return 0
    fi
    
    if ! is_ollama_installed; then
        log_error "Ollama is not installed"
        return 1
    fi
    
    # Start Ollama in background
    ollama serve >/dev/null 2>&1 &
    local pid=$!
    
    if [ $pid -gt 0 ]; then
        log_info "Started Ollama service (PID: $pid)"
        
        # Wait for service to be ready
        local attempts=0
        local max_attempts=30
        
        while [ $attempts -lt $max_attempts ]; do
            if is_ollama_running; then
                log_success "Ollama service is ready"
                return 0
            fi
            
            sleep 1
            attempts=$((attempts + 1))
        done
        
        log_error "Ollama service failed to start within 30 seconds"
        return 1
    else
        log_error "Failed to start Ollama service"
        return 1
    fi
}

# Stop Ollama service
stop_ollama() {
    log_info "Stopping Ollama service..."
    
    if ! is_ollama_running; then
        log_warning "Ollama is not running"
        return 0
    fi
    
    # Try graceful shutdown first
    if pkill -TERM -f "ollama serve"; then
        sleep 3
        
        if ! is_ollama_running; then
            log_success "Ollama service stopped gracefully"
            return 0
        fi
    fi
    
    # Force kill if still running
    if pkill -KILL -f "ollama serve"; then
        log_success "Ollama service force stopped"
        return 0
    else
        log_error "Failed to stop Ollama service"
        return 1
    fi
}

# Install Ollama
install_ollama() {
    log_info "Installing Ollama..."
    
    if is_ollama_installed; then
        log_warning "Ollama is already installed"
        ollama_status
        return 0
    fi
    
    # Check system requirements
    if ! check_system_requirements; then
        log_error "System does not meet minimum requirements for Ollama"
        return 1
    fi
    
    # Download and install Ollama
    log_progress "Downloading Ollama installer..."
    
    if command -v curl &>/dev/null; then
        if curl -fsSL https://ollama.ai/install.sh | sh; then
            log_success "Ollama installed successfully"
            
            # Start the service
            start_ollama
            
            # Install a default model
            log_info "Installing default model for quick start..."
            install_model "phi:latest"
            
            return 0
        else
            log_error "Failed to install Ollama"
            return 1
        fi
    else
        log_error "curl is required to install Ollama"
        log_info "Install curl: sudo apt install curl"
        return 1
    fi
}

# Check system requirements for Ollama
check_system_requirements() {
    local total_ram_kb
    local available_space_gb
    
    # Check RAM (minimum 4GB)
    if [ -f /proc/meminfo ]; then
        total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local total_ram_gb=$((total_ram_kb / 1024 / 1024))
        
        if [ $total_ram_gb -lt 4 ]; then
            log_error "Insufficient RAM: ${total_ram_gb}GB available, 4GB minimum required"
            return 1
        else
            log_info "RAM check passed: ${total_ram_gb}GB available"
        fi
    fi
    
    # Check disk space (minimum 10GB)
    available_space_gb=$(df -BG "$HOME" | tail -1 | awk '{print $4}' | sed 's/G//')
    if [ "$available_space_gb" -lt 10 ]; then
        log_error "Insufficient disk space: ${available_space_gb}GB available, 10GB minimum required"
        return 1
    else
        log_info "Disk space check passed: ${available_space_gb}GB available"
    fi
    
    return 0
}

# List available models
list_models() {
    if ! is_ollama_running; then
        log_error "Ollama is not running"
        return 1
    fi
    
    log_info "Installed Ollama models:"
    ollama list 2>/dev/null || {
        log_warning "Failed to list models - Ollama may not be responding"
        return 1
    }
}

# List recommended models
list_recommended_models() {
    print_header "Recommended Ollama Models"
    
    echo "Available models for different use cases:"
    echo ""
    
    for use_case in "${!RECOMMENDED_MODELS[@]}"; do
        local model="${RECOMMENDED_MODELS[$use_case]}"
        local requirements="${MODEL_REQUIREMENTS[$model]:-Unknown}"
        
        printf "%-10s: %-25s (%s)\n" "$use_case" "$model" "$requirements"
    done
    
    echo ""
    echo "To install a model: ollama_install_model <model_name>"
    echo "Example: ollama_install_model codellama:7b-instruct"
}

# Install a specific model
install_model() {
    local model="$1"
    
    if [ -z "$model" ]; then
        log_error "No model specified"
        log_info "Usage: install_model <model_name>"
        list_recommended_models
        return 1
    fi
    
    if ! is_ollama_running; then
        log_info "Starting Ollama service..."
        start_ollama || return 1
    fi
    
    # Check if model is already installed
    if ollama list | grep -q "^$model"; then
        log_warning "Model $model is already installed"
        return 0
    fi
    
    # Check system requirements for this model
    local requirements="${MODEL_REQUIREMENTS[$model]}"
    if [ -n "$requirements" ]; then
        log_info "Model requirements: $requirements"
        
        if ! confirm "Continue with installation of $model?"; then
            log_info "Installation cancelled"
            return 0
        fi
    fi
    
    log_progress "Installing model: $model (this may take several minutes)..."
    
    # Install with progress
    if run_with_error_handling "ollama pull \"$model\"" \
        "Model $model installed successfully" \
        "Failed to install model $model"; then
        
        # Update default model if none set
        local current_default
        current_default=$(jq -r '.default_model // ""' "$OLLAMA_CONFIG" 2>/dev/null)
        
        if [ -z "$current_default" ]; then
            set_default_model "$model"
        fi
        
        return 0
    else
        return 1
    fi
}

# Remove a model
remove_model() {
    local model="$1"
    
    if [ -z "$model" ]; then
        log_error "No model specified"
        log_info "Usage: remove_model <model_name>"
        list_models
        return 1
    fi
    
    if ! is_ollama_running; then
        log_error "Ollama is not running"
        return 1
    fi
    
    # Check if model exists
    if ! ollama list | grep -q "^$model"; then
        log_warning "Model $model is not installed"
        return 0
    fi
    
    if confirm "Remove model $model? This cannot be undone."; then
        if run_with_error_handling "ollama rm \"$model\"" \
            "Model $model removed successfully" \
            "Failed to remove model $model"; then
            return 0
        else
            return 1
        fi
    else
        log_info "Model removal cancelled"
        return 0
    fi
}

# Set default model
set_default_model() {
    local model="$1"
    
    if [ -z "$model" ]; then
        log_error "No model specified"
        return 1
    fi
    
    # Update config
    local config
    config=$(cat "$OLLAMA_CONFIG")
    config=$(echo "$config" | jq ".default_model = \"$model\"")
    echo "$config" > "$OLLAMA_CONFIG"
    
    log_success "Default model set to: $model"
}

# Get default model
get_default_model() {
    if [ -f "$OLLAMA_CONFIG" ]; then
        jq -r '.default_model // ""' "$OLLAMA_CONFIG" 2>/dev/null
    fi
}

# Test model with a simple prompt
test_model() {
    local model="${1:-$(get_default_model)}"
    
    if [ -z "$model" ]; then
        log_error "No model specified and no default model set"
        return 1
    fi
    
    if ! is_ollama_running; then
        start_ollama || return 1
    fi
    
    log_info "Testing model: $model"
    log_progress "Sending test prompt..."
    
    local test_prompt="Respond with just 'OK' if you are working correctly."
    local start_time=$(date +%s)
    
    local response
    if response=$(echo "$test_prompt" | ollama run "$model" 2>/dev/null); then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        
        log_success "Model responded in ${duration}s"
        echo "Response: $response"
        
        if echo "$response" | grep -iq "ok"; then
            log_success "Model test PASSED"
            return 0
        else
            log_warning "Model test unclear - unexpected response"
            return 1
        fi
    else
        log_error "Model test FAILED - no response"
        return 1
    fi
}

# Get Ollama status and information
ollama_status() {
    print_header "Ollama Status Report"
    
    # Installation status
    if is_ollama_installed; then
        log_success "Ollama is installed"
        
        # Version info
        local version
        version=$(ollama --version 2>/dev/null | head -1)
        echo "Version: $version"
    else
        log_error "Ollama is not installed"
        log_info "Run: install_ollama"
        return 1
    fi
    
    # Service status
    if is_ollama_running; then
        log_success "Ollama service is running"
        echo "API URL: $OLLAMA_API_URL"
    else
        log_warning "Ollama service is not running"
        log_info "Run: start_ollama"
    fi
    
    # Models status
    echo ""
    echo "Installed models:"
    if is_ollama_running; then
        ollama list 2>/dev/null || log_warning "Could not list models"
    else
        log_warning "Cannot list models - service not running"
    fi
    
    # Default model
    local default_model
    default_model=$(get_default_model)
    if [ -n "$default_model" ]; then
        echo ""
        echo "Default model: $default_model"
    fi
    
    # System resources
    echo ""
    echo "System resources:"
    
    if [ -f /proc/meminfo ]; then
        local total_ram_kb
        total_ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local total_ram_gb=$((total_ram_kb / 1024 / 1024))
        echo "Total RAM: ${total_ram_gb}GB"
    fi
    
    local disk_space
    disk_space=$(df -BG "$HOME" | tail -1 | awk '{print $4}' | sed 's/G//')
    echo "Available disk space: ${disk_space}GB"
}

# Quick setup for new users
ollama_quick_setup() {
    print_header "Ollama Quick Setup"
    
    log_info "Setting up Ollama for Bill Sloth..."
    
    # Step 1: Install if needed
    if ! is_ollama_installed; then
        log_step 1 4 "Installing Ollama"
        install_ollama || return 1
    else
        log_success "Ollama already installed"
    fi
    
    # Step 2: Start service
    log_step 2 4 "Starting Ollama service"
    start_ollama || return 1
    
    # Step 3: Install recommended model
    log_step 3 4 "Installing recommended model"
    
    local recommended_model="phi:latest"  # Fast, small model for quick start
    log_info "Installing $recommended_model (good balance of speed and capability)"
    
    install_model "$recommended_model" || {
        log_warning "Failed to install recommended model, trying smaller model..."
        install_model "tinyllama:latest" || return 1
    }
    
    # Step 4: Test setup
    log_step 4 4 "Testing installation"
    
    if test_model; then
        log_success "Ollama setup complete and working!"
        
        print_separator
        echo "Next steps:"
        echo "• Test with: echo 'Hello' | ollama run $(get_default_model)"
        echo "• Install more models: install_model codellama:7b-instruct"
        echo "• Check status: ollama_status"
        
        return 0
    else
        log_error "Setup completed but test failed"
        return 1
    fi
}

# Export all functions
export -f is_ollama_installed is_ollama_running start_ollama stop_ollama
export -f install_ollama check_system_requirements
export -f list_models list_recommended_models install_model remove_model
export -f set_default_model get_default_model test_model
export -f ollama_status ollama_quick_setup

# Main function for standalone execution
ollama_main() {
    local command="${1:-status}"
    shift || true
    
    # Ensure directories exist
    create_ollama_directories
    
    case "$command" in
        install)
            install_ollama
            ;;
        start)
            start_ollama
            ;;
        stop)
            stop_ollama
            ;;
        status)
            ollama_status
            ;;
        list)
            list_models
            ;;
        recommended)
            list_recommended_models
            ;;
        install-model)
            install_model "$1"
            ;;
        remove-model)
            remove_model "$1"
            ;;
        test)
            test_model "$1"
            ;;
        setup)
            ollama_quick_setup
            ;;
        default)
            if [ -n "$1" ]; then
                set_default_model "$1"
            else
                local default
                default=$(get_default_model)
                if [ -n "$default" ]; then
                    echo "Default model: $default"
                else
                    echo "No default model set"
                fi
            fi
            ;;
        *)
            echo "Usage: $0 {install|start|stop|status|list|recommended|install-model|remove-model|test|setup|default}"
            echo ""
            echo "Commands:"
            echo "  install              - Install Ollama"
            echo "  start               - Start Ollama service"
            echo "  stop                - Stop Ollama service"
            echo "  status              - Show Ollama status"
            echo "  list                - List installed models"
            echo "  recommended         - Show recommended models"
            echo "  install-model MODEL - Install a specific model"
            echo "  remove-model MODEL  - Remove a model"
            echo "  test [MODEL]        - Test a model"
            echo "  setup               - Quick setup for new users"
            echo "  default [MODEL]     - Get/set default model"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    ollama_main "$@"
fi