#!/bin/bash
# LLM_CAPABILITY: local_ok
# Input Validation and Sanitization Library
# Provides safe input handling for Bill Sloth system

# Safe read function with validation and timeout
safe_read() {
    local prompt="${1:-Enter input: }"
    local timeout="${2:-30}"
    local max_length="${3:-1000}"
    local allowed_chars="${4:-[[:alnum:][:space:][:punct:]]}"
    
    local input=""
    local sanitized=""
    
    # Read with timeout
    if ! read -t "$timeout" -p "$prompt" input; then
        echo "⏰ Input timeout after ${timeout}s" >&2
        return 1
    fi
    
    # Length validation
    if [[ ${#input} -gt $max_length ]]; then
        echo "❌ Input too long (max: $max_length characters)" >&2
        return 1
    fi
    
    # Character validation and sanitization
    sanitized=$(echo "$input" | sed "s/[^$allowed_chars]//g")
    
    if [[ "$input" != "$sanitized" ]]; then
        echo "⚠️  Input contained invalid characters - sanitized" >&2
    fi
    
    echo "$sanitized"
    return 0
}

# Validate menu choice
validate_menu_choice() {
    local choice="$1"
    local valid_options="$2"  # e.g., "0-9" or "1,2,3,a,b,c"
    
    # Empty input
    if [[ -z "$choice" ]]; then
        return 1
    fi
    
    # Range validation (e.g., "0-9")
    if [[ "$valid_options" =~ ^[0-9]-[0-9]$ ]]; then
        local min="${valid_options%-*}"
        local max="${valid_options#*-}"
        if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= min && choice <= max )); then
            return 0
        fi
    fi
    
    # List validation (e.g., "1,2,3,a,b,c")
    if [[ ",$valid_options," == *",$choice,"* ]]; then
        return 0
    fi
    
    return 1
}

# Sanitize file path
sanitize_path() {
    local path="$1"
    local base_dir="${2:-$HOME}"
    
    # Remove dangerous characters
    path=$(echo "$path" | sed 's/[;&|`$(){}[]\\]//g')
    
    # Resolve relative paths safely
    path=$(realpath -m "$path" 2>/dev/null) || {
        echo "❌ Invalid path: $1" >&2
        return 1
    }
    
    # Ensure path is within base directory
    if [[ "$path" != "$base_dir"* ]]; then
        echo "❌ Path outside allowed directory: $path" >&2
        return 1
    fi
    
    echo "$path"
    return 0
}

# Validate command before execution
validate_command() {
    local cmd="$1"
    local allowed_commands="${2:-bash,sh,python3,node,git}"
    
    # Extract base command
    local base_cmd="${cmd%% *}"
    base_cmd="${base_cmd##*/}"  # Remove path
    
    # Check against allowed commands
    if [[ ",$allowed_commands," == *",$base_cmd,"* ]]; then
        return 0
    fi
    
    echo "❌ Command not allowed: $base_cmd" >&2
    return 1
}

# Safe execution with logging
safe_execute() {
    local cmd="$1"
    local log_file="${2:-/tmp/bill_sloth_commands.log}"
    
    # Validate command
    if ! validate_command "$cmd"; then
        return 1
    fi
    
    # Log command execution
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Executing: $cmd" >> "$log_file"
    
    # Execute with timeout
    timeout 300 bash -c "$cmd" || {
        local exit_code=$?
        echo "❌ Command failed or timed out: $cmd" >&2
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] FAILED: $cmd (exit: $exit_code)" >> "$log_file"
        return $exit_code
    }
    
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] SUCCESS: $cmd" >> "$log_file"
    return 0
}

# Export functions for use in other scripts
export -f safe_read validate_menu_choice sanitize_path validate_command safe_execute