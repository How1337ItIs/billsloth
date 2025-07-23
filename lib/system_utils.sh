#!/bin/bash
# Bill Sloth System Utilities Library
# Centralized hardware detection, VRAM checking, and system information


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# System information cache
SYSTEM_INFO_CACHE="$HOME/.bill-sloth/cache/system_info.json"
CACHE_DURATION=3600  # 1 hour in seconds

# Ensure cache directory exists
create_directory "$(dirname "$SYSTEM_INFO_CACHE")"

# Check if cache is valid
is_cache_valid() {
    if [ ! -f "$SYSTEM_INFO_CACHE" ]; then
        return 1
    fi
    
    local cache_time
    cache_time=$(stat -c %Y "$SYSTEM_INFO_CACHE" 2>/dev/null || echo 0)
    local current_time
    current_time=$(date +%s)
    local age=$((current_time - cache_time))
    
    [ $age -lt $CACHE_DURATION ]
}

# Detect VRAM (Video RAM) - multiple methods for compatibility
detect_vram() {
    local vram_mb=0
    local gpu_info=""
    local detection_method=""
    
    # Method 1: nvidia-smi (NVIDIA GPUs)
    if command -v nvidia-smi &>/dev/null; then
        local nvidia_vram
        nvidia_vram=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | head -1)
        if [ -n "$nvidia_vram" ] && [ "$nvidia_vram" -gt 0 ]; then
            vram_mb="$nvidia_vram"
            gpu_info=$(nvidia-smi --query-gpu=name --format=csv,noheader 2>/dev/null | head -1)
            detection_method="nvidia-smi"
        fi
    fi
    
    # Method 2: lspci + grep (general detection)
    if [ $vram_mb -eq 0 ] && command -v lspci &>/dev/null; then
        # Look for VGA/3D controllers
        local gpu_line
        gpu_line=$(lspci | grep -E "(VGA|3D)" | head -1)
        
        if [ -n "$gpu_line" ]; then
            gpu_info=$(echo "$gpu_line" | cut -d: -f3- | sed 's/^ *//')
            detection_method="lspci"
            
            # Try to extract VRAM from common GPU names
            case "$gpu_info" in
                *"GeForce RTX 4090"*) vram_mb=24576 ;;
                *"GeForce RTX 4080"*) vram_mb=16384 ;;
                *"GeForce RTX 4070"*) vram_mb=12288 ;;
                *"GeForce RTX 3090"*) vram_mb=24576 ;;
                *"GeForce RTX 3080"*) vram_mb=10240 ;;
                *"GeForce RTX 3070"*) vram_mb=8192 ;;
                *"GeForce RTX 3060"*) vram_mb=12288 ;;
                *"GeForce GTX 1660"*) vram_mb=6144 ;;
                *"GeForce GTX 1650"*) vram_mb=4096 ;;
                *"Radeon RX 6900"*) vram_mb=16384 ;;
                *"Radeon RX 6800"*) vram_mb=16384 ;;
                *"Radeon RX 6700"*) vram_mb=12288 ;;
                *"Radeon RX 580"*) vram_mb=8192 ;;
                *"Intel UHD"*|*"Intel HD"*) vram_mb=0 ;;  # Integrated graphics
                *) vram_mb=0 ;;  # Unknown
            esac
        fi
    fi
    
    # Method 3: Check /proc/meminfo for dedicated graphics memory
    if [ $vram_mb -eq 0 ] && [ -f /proc/meminfo ]; then
        local dedicated_mem
        dedicated_mem=$(grep -i "dedicated.*memory" /proc/meminfo 2>/dev/null | awk '{print $2}')
        if [ -n "$dedicated_mem" ] && [ "$dedicated_mem" -gt 0 ]; then
            vram_mb=$((dedicated_mem / 1024))  # Convert KB to MB
            detection_method="proc/meminfo"
        fi
    fi
    
    # Method 4: glxinfo (if available)
    if [ $vram_mb -eq 0 ] && command -v glxinfo &>/dev/null; then
        local gl_renderer
        gl_renderer=$(glxinfo 2>/dev/null | grep "OpenGL renderer" | cut -d: -f2- | sed 's/^ *//')
        if [ -n "$gl_renderer" ]; then
            gpu_info="$gl_renderer"
            detection_method="glxinfo"
            
            # Estimate based on OpenGL renderer string
            case "$gl_renderer" in
                *"RTX 4090"*) vram_mb=24576 ;;
                *"RTX 4080"*) vram_mb=16384 ;;
                *"RTX 3090"*) vram_mb=24576 ;;
                *"RTX 3080"*) vram_mb=10240 ;;
                *"GTX"*) vram_mb=4096 ;;  # Conservative estimate
                *"Radeon"*) vram_mb=8192 ;;  # Conservative estimate
                *) vram_mb=0 ;;
            esac
        fi
    fi
    
    # Output results
    local vram_gb=$((vram_mb / 1024))
    
    echo "VRAM_MB=$vram_mb"
    echo "VRAM_GB=$vram_gb"
    echo "GPU_INFO=$gpu_info"
    echo "DETECTION_METHOD=$detection_method"
    
    # Log detection
    create_directory "$HOME/.bill-sloth/logs"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] VRAM Detection: ${vram_mb}MB via $detection_method | GPU: $gpu_info" >> "$HOME/.bill-sloth/logs/system_detection.log"
    
    return 0
}

# Get system RAM information
detect_ram() {
    local total_ram_kb=0
    local available_ram_kb=0
    local used_ram_kb=0
    
    if [ -f /proc/meminfo ]; then
        total_ram_kb=$(grep "MemTotal:" /proc/meminfo | awk '{print $2}')
        available_ram_kb=$(grep "MemAvailable:" /proc/meminfo | awk '{print $2}')
        used_ram_kb=$((total_ram_kb - available_ram_kb))
    fi
    
    local total_ram_gb=$((total_ram_kb / 1024 / 1024))
    local available_ram_gb=$((available_ram_kb / 1024 / 1024))
    local used_ram_gb=$((used_ram_kb / 1024 / 1024))
    local used_percentage=0
    
    if [ $total_ram_kb -gt 0 ]; then
        used_percentage=$((used_ram_kb * 100 / total_ram_kb))
    fi
    
    echo "TOTAL_RAM_KB=$total_ram_kb"
    echo "TOTAL_RAM_GB=$total_ram_gb"
    echo "AVAILABLE_RAM_KB=$available_ram_kb"
    echo "AVAILABLE_RAM_GB=$available_ram_gb"
    echo "USED_RAM_KB=$used_ram_kb"
    echo "USED_RAM_GB=$used_ram_gb"
    echo "USED_RAM_PERCENTAGE=$used_percentage"
}

# Detect CPU information
detect_cpu() {
    local cpu_model=""
    local cpu_cores=0
    local cpu_threads=0
    local cpu_freq=""
    
    if [ -f /proc/cpuinfo ]; then
        cpu_model=$(grep "model name" /proc/cpuinfo | head -1 | cut -d: -f2- | sed 's/^ *//' | sed 's/[()]/[]/g')
        cpu_cores=$(grep "cpu cores" /proc/cpuinfo | head -1 | awk '{print $4}' 2>/dev/null || echo "0")
        cpu_threads=$(grep "processor" /proc/cpuinfo | wc -l 2>/dev/null || echo "0")
        cpu_freq=$(grep "cpu MHz" /proc/cpuinfo | head -1 | awk '{print $4}' 2>/dev/null || echo "0")
    fi
    
    echo "CPU_MODEL=$cpu_model"
    echo "CPU_CORES=${cpu_cores:-0}"
    echo "CPU_THREADS=${cpu_threads:-0}"
    echo "CPU_FREQ_MHZ=${cpu_freq:-0}"
}

# Detect storage information
detect_storage() {
    local total_storage_gb=0
    local available_storage_gb=0
    local used_storage_gb=0
    local used_percentage=0
    
    # Get home directory storage info
    if command -v df &>/dev/null; then
        local df_output
        df_output=$(df -BG "$HOME" | tail -1)
        
        total_storage_gb=$(echo "$df_output" | awk '{print $2}' | sed 's/G//')
        used_storage_gb=$(echo "$df_output" | awk '{print $3}' | sed 's/G//')
        available_storage_gb=$(echo "$df_output" | awk '{print $4}' | sed 's/G//')
        
        if [ $total_storage_gb -gt 0 ]; then
            used_percentage=$((used_storage_gb * 100 / total_storage_gb))
        fi
    fi
    
    echo "TOTAL_STORAGE_GB=$total_storage_gb"
    echo "USED_STORAGE_GB=$used_storage_gb"
    echo "AVAILABLE_STORAGE_GB=$available_storage_gb"
    echo "USED_STORAGE_PERCENTAGE=$used_percentage"
}

# Detect operating system information
detect_os() {
    local os_name=""
    local os_version=""
    local kernel_version=""
    local architecture=""
    
    # OS information
    if [ -f /etc/os-release ]; then
        os_name=$(grep "^NAME=" /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/[()]/[]/g')
        os_version=$(grep "^VERSION=" /etc/os-release | cut -d= -f2 | tr -d '"' | sed 's/[()]/[]/g')
    elif [ -f /etc/issue ]; then
        os_name=$(head -1 /etc/issue | awk '{print $1}' | sed 's/[()]/[]/g')
    fi
    
    # Kernel and architecture
    kernel_version=$(uname -r 2>/dev/null)
    architecture=$(uname -m 2>/dev/null)
    
    echo "OS_NAME=$os_name"
    echo "OS_VERSION=$os_version"
    echo "KERNEL_VERSION=$kernel_version"
    echo "ARCHITECTURE=$architecture"
}

# Check if system meets requirements for specific tasks
check_requirements() {
    local task="$1"
    local requirements_met=1
    
    # Get system info safely
    local vram_info ram_info storage_info
    vram_info=$(detect_vram)
    ram_info=$(detect_ram)
    storage_info=$(detect_storage)
    
    # Parse values
    local VRAM_GB TOTAL_RAM_GB AVAILABLE_STORAGE_GB
    VRAM_GB=$(echo "$vram_info" | grep "^VRAM_GB=" | cut -d= -f2 || echo "0")
    TOTAL_RAM_GB=$(echo "$ram_info" | grep "^TOTAL_RAM_GB=" | cut -d= -f2 || echo "0")
    AVAILABLE_STORAGE_GB=$(echo "$storage_info" | grep "^AVAILABLE_STORAGE_GB=" | cut -d= -f2 || echo "0")
    
    case "$task" in
        "ollama_large")
            log_info "Checking requirements for large Ollama models..."
            
            if [ $TOTAL_RAM_GB -lt 16 ]; then
                log_error "Insufficient RAM: ${TOTAL_RAM_GB}GB (16GB required for large models)"
                requirements_met=0
            fi
            
            if [ $AVAILABLE_STORAGE_GB -lt 20 ]; then
                log_error "Insufficient storage: ${AVAILABLE_STORAGE_GB}GB (20GB required for large models)"
                requirements_met=0
            fi
            ;;
            
        "ollama_medium")
            log_info "Checking requirements for medium Ollama models..."
            
            if [ $TOTAL_RAM_GB -lt 8 ]; then
                log_error "Insufficient RAM: ${TOTAL_RAM_GB}GB (8GB required for medium models)"
                requirements_met=0
            fi
            
            if [ $AVAILABLE_STORAGE_GB -lt 10 ]; then
                log_error "Insufficient storage: ${AVAILABLE_STORAGE_GB}GB (10GB required for medium models)"
                requirements_met=0
            fi
            ;;
            
        "ollama_small")
            log_info "Checking requirements for small Ollama models..."
            
            if [ $TOTAL_RAM_GB -lt 4 ]; then
                log_error "Insufficient RAM: ${TOTAL_RAM_GB}GB (4GB required for small models)"
                requirements_met=0
            fi
            
            if [ $AVAILABLE_STORAGE_GB -lt 5 ]; then
                log_error "Insufficient storage: ${AVAILABLE_STORAGE_GB}GB (5GB required for small models)"
                requirements_met=0
            fi
            ;;
            
        "gaming")
            log_info "Checking requirements for gaming performance..."
            
            if [ $VRAM_GB -lt 4 ]; then
                log_warning "Low VRAM: ${VRAM_GB}GB (4GB+ recommended for gaming)"
                requirements_met=0
            fi
            
            if [ $TOTAL_RAM_GB -lt 16 ]; then
                log_warning "Low RAM: ${TOTAL_RAM_GB}GB (16GB+ recommended for gaming)"
            fi
            ;;
            
        "video_editing")
            log_info "Checking requirements for video editing..."
            
            if [ $TOTAL_RAM_GB -lt 16 ]; then
                log_error "Insufficient RAM: ${TOTAL_RAM_GB}GB (16GB required for video editing)"
                requirements_met=0
            fi
            
            if [ $AVAILABLE_STORAGE_GB -lt 100 ]; then
                log_warning "Low storage: ${AVAILABLE_STORAGE_GB}GB (100GB+ recommended for video editing)"
            fi
            ;;
            
        *)
            log_error "Unknown requirement check: $task"
            return 1
            ;;
    esac
    
    if [ $requirements_met -eq 1 ]; then
        log_success "System meets requirements for $task"
        return 0
    else
        log_error "System does not meet requirements for $task"
        return 1
    fi
}

# Generate comprehensive system report
generate_system_report() {
    local output_file="${1:-$HOME/.bill-sloth/system_report.json}"
    local timestamp=$(date -Iseconds)
    
    log_info "Generating comprehensive system report..."
    
    # Gather all system information
    local vram_info cpu_info ram_info storage_info os_info
    vram_info=$(detect_vram)
    cpu_info=$(detect_cpu)
    ram_info=$(detect_ram)
    storage_info=$(detect_storage)
    os_info=$(detect_os)
    
    # Parse into variables safely
    local VRAM_MB VRAM_GB GPU_INFO DETECTION_METHOD
    local CPU_MODEL CPU_CORES CPU_THREADS CPU_FREQ_MHZ
    local TOTAL_RAM_KB TOTAL_RAM_GB AVAILABLE_RAM_GB USED_RAM_GB USED_RAM_PERCENTAGE
    local TOTAL_STORAGE_GB USED_STORAGE_GB AVAILABLE_STORAGE_GB USED_STORAGE_PERCENTAGE
    local OS_NAME OS_VERSION KERNEL_VERSION ARCHITECTURE
    
    # Parse VRAM info
    VRAM_MB=$(echo "$vram_info" | grep "^VRAM_MB=" | cut -d= -f2 || echo "0")
    VRAM_GB=$(echo "$vram_info" | grep "^VRAM_GB=" | cut -d= -f2 || echo "0")
    GPU_INFO=$(echo "$vram_info" | grep "^GPU_INFO=" | cut -d= -f2- || echo "Unknown")
    DETECTION_METHOD=$(echo "$vram_info" | grep "^DETECTION_METHOD=" | cut -d= -f2- || echo "Unknown")
    
    # Parse CPU info
    CPU_MODEL=$(echo "$cpu_info" | grep "^CPU_MODEL=" | cut -d= -f2- || echo "Unknown")
    CPU_CORES=$(echo "$cpu_info" | grep "^CPU_CORES=" | cut -d= -f2 || echo "0")
    CPU_THREADS=$(echo "$cpu_info" | grep "^CPU_THREADS=" | cut -d= -f2 || echo "0")
    CPU_FREQ_MHZ=$(echo "$cpu_info" | grep "^CPU_FREQ_MHZ=" | cut -d= -f2 || echo "0")
    
    # Parse RAM info
    TOTAL_RAM_GB=$(echo "$ram_info" | grep "^TOTAL_RAM_GB=" | cut -d= -f2 || echo "0")
    AVAILABLE_RAM_GB=$(echo "$ram_info" | grep "^AVAILABLE_RAM_GB=" | cut -d= -f2 || echo "0")
    USED_RAM_GB=$(echo "$ram_info" | grep "^USED_RAM_GB=" | cut -d= -f2 || echo "0")
    USED_RAM_PERCENTAGE=$(echo "$ram_info" | grep "^USED_RAM_PERCENTAGE=" | cut -d= -f2 || echo "0")
    
    # Parse storage info
    TOTAL_STORAGE_GB=$(echo "$storage_info" | grep "^TOTAL_STORAGE_GB=" | cut -d= -f2 || echo "0")
    USED_STORAGE_GB=$(echo "$storage_info" | grep "^USED_STORAGE_GB=" | cut -d= -f2 || echo "0")
    AVAILABLE_STORAGE_GB=$(echo "$storage_info" | grep "^AVAILABLE_STORAGE_GB=" | cut -d= -f2 || echo "0")
    USED_STORAGE_PERCENTAGE=$(echo "$storage_info" | grep "^USED_STORAGE_PERCENTAGE=" | cut -d= -f2 || echo "0")
    
    # Parse OS info
    OS_NAME=$(echo "$os_info" | grep "^OS_NAME=" | cut -d= -f2- || echo "Unknown")
    OS_VERSION=$(echo "$os_info" | grep "^OS_VERSION=" | cut -d= -f2- || echo "Unknown")
    KERNEL_VERSION=$(echo "$os_info" | grep "^KERNEL_VERSION=" | cut -d= -f2- || echo "Unknown")
    ARCHITECTURE=$(echo "$os_info" | grep "^ARCHITECTURE=" | cut -d= -f2- || echo "Unknown")
    
    # Create JSON report
    cat > "$output_file" << EOF
{
    "timestamp": "$timestamp",
    "version": "1.0",
    "system": {
        "os": {
            "name": "$OS_NAME",
            "version": "$OS_VERSION",
            "kernel": "$KERNEL_VERSION",
            "architecture": "$ARCHITECTURE"
        },
        "cpu": {
            "model": "$CPU_MODEL",
            "cores": $CPU_CORES,
            "threads": $CPU_THREADS,
            "frequency_mhz": ${CPU_FREQ_MHZ:-0}
        },
        "memory": {
            "total_gb": $TOTAL_RAM_GB,
            "available_gb": $AVAILABLE_RAM_GB,
            "used_gb": $USED_RAM_GB,
            "used_percentage": $USED_RAM_PERCENTAGE
        },
        "graphics": {
            "vram_mb": $VRAM_MB,
            "vram_gb": $VRAM_GB,
            "gpu_info": "$GPU_INFO",
            "detection_method": "$DETECTION_METHOD"
        },
        "storage": {
            "total_gb": $TOTAL_STORAGE_GB,
            "used_gb": $USED_STORAGE_GB,
            "available_gb": $AVAILABLE_STORAGE_GB,
            "used_percentage": $USED_STORAGE_PERCENTAGE
        }
    },
    "capabilities": {
        "ollama_small": $(check_requirements "ollama_small" >/dev/null 2>&1 && echo "true" || echo "false"),
        "ollama_medium": $(check_requirements "ollama_medium" >/dev/null 2>&1 && echo "true" || echo "false"),
        "ollama_large": $(check_requirements "ollama_large" >/dev/null 2>&1 && echo "true" || echo "false"),
        "gaming": $(check_requirements "gaming" >/dev/null 2>&1 && echo "true" || echo "false"),
        "video_editing": $(check_requirements "video_editing" >/dev/null 2>&1 && echo "true" || echo "false")
    }
}
EOF

    log_success "System report saved to: $output_file"
    
    # Update cache
    cp "$output_file" "$SYSTEM_INFO_CACHE"
}

# Display system summary
system_summary() {
    print_header "System Summary"
    
    # Use cached data if available
    if is_cache_valid; then
        log_info "Using cached system information ($(date -r "$SYSTEM_INFO_CACHE" '+%Y-%m-%d %H:%M:%S'))"
        
        if command -v jq &>/dev/null && [ -f "$SYSTEM_INFO_CACHE" ]; then
            # Parse from JSON cache
            local os_name cpu_model total_ram vram_gb total_storage
            os_name=$(jq -r '.system.os.name // "Unknown"' "$SYSTEM_INFO_CACHE")
            cpu_model=$(jq -r '.system.cpu.model // "Unknown"' "$SYSTEM_INFO_CACHE")
            total_ram=$(jq -r '.system.memory.total_gb // 0' "$SYSTEM_INFO_CACHE")
            vram_gb=$(jq -r '.system.graphics.vram_gb // 0' "$SYSTEM_INFO_CACHE")
            total_storage=$(jq -r '.system.storage.total_gb // 0' "$SYSTEM_INFO_CACHE")
            
            echo "OS: $os_name"
            echo "CPU: $cpu_model"
            echo "RAM: ${total_ram}GB"
            echo "VRAM: ${vram_gb}GB"
            echo "Storage: ${total_storage}GB"
        fi
    else
        # Generate fresh data
        log_info "Gathering fresh system information..."
        
        # Get system info without eval to avoid issues with special characters
        local os_info cpu_info ram_info vram_info storage_info
        os_info=$(detect_os)
        cpu_info=$(detect_cpu)
        ram_info=$(detect_ram)
        vram_info=$(detect_vram)
        storage_info=$(detect_storage)
        
        # Parse values safely
        OS_NAME=$(echo "$os_info" | grep "^OS_NAME=" | cut -d= -f2- || echo "Unknown")
        OS_VERSION=$(echo "$os_info" | grep "^OS_VERSION=" | cut -d= -f2- || echo "Unknown")
        CPU_MODEL=$(echo "$cpu_info" | grep "^CPU_MODEL=" | cut -d= -f2- || echo "Unknown")
        TOTAL_RAM_GB=$(echo "$ram_info" | grep "^TOTAL_RAM_GB=" | cut -d= -f2 || echo "0")
        AVAILABLE_RAM_GB=$(echo "$ram_info" | grep "^AVAILABLE_RAM_GB=" | cut -d= -f2 || echo "0")
        VRAM_GB=$(echo "$vram_info" | grep "^VRAM_GB=" | cut -d= -f2 || echo "0")
        GPU_INFO=$(echo "$vram_info" | grep "^GPU_INFO=" | cut -d= -f2- || echo "Unknown")
        AVAILABLE_STORAGE_GB=$(echo "$storage_info" | grep "^AVAILABLE_STORAGE_GB=" | cut -d= -f2 || echo "0")
        TOTAL_STORAGE_GB=$(echo "$storage_info" | grep "^TOTAL_STORAGE_GB=" | cut -d= -f2 || echo "0")
        
        echo "OS: $OS_NAME $OS_VERSION"
        echo "CPU: $CPU_MODEL"
        echo "RAM: ${TOTAL_RAM_GB}GB total, ${AVAILABLE_RAM_GB}GB available"
        echo "VRAM: ${VRAM_GB}GB ($GPU_INFO)"
        echo "Storage: ${AVAILABLE_STORAGE_GB}GB available of ${TOTAL_STORAGE_GB}GB total"
        
        # Update cache
        generate_system_report "$SYSTEM_INFO_CACHE" >/dev/null 2>&1
    fi
}

# Export all functions
export -f detect_vram detect_ram detect_cpu detect_storage detect_os
export -f check_requirements generate_system_report system_summary
export -f is_cache_valid

# Main function for standalone execution
system_utils_main() {
    local command="${1:-summary}"
    shift || true
    
    case "$command" in
        vram)
            detect_vram
            ;;
        ram)
            detect_ram
            ;;
        cpu)
            detect_cpu
            ;;
        storage)
            detect_storage
            ;;
        os)
            detect_os
            ;;
        check)
            check_requirements "$1"
            ;;
        report)
            generate_system_report "$1"
            ;;
        summary)
            system_summary
            ;;
        *)
            echo "Usage: $0 {vram|ram|cpu|storage|os|check|report|summary}"
            echo ""
            echo "Commands:"
            echo "  vram                 - Detect VRAM information"
            echo "  ram                  - Detect RAM information"
            echo "  cpu                  - Detect CPU information"
            echo "  storage              - Detect storage information"
            echo "  os                   - Detect OS information"
            echo "  check TASK           - Check requirements for task"
            echo "  report [FILE]        - Generate full system report"
            echo "  summary              - Show system summary"
            echo ""
            echo "Check tasks: ollama_small, ollama_medium, ollama_large, gaming, video_editing"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    system_utils_main "$@"
fi