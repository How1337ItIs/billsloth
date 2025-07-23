#!/bin/bash
# LLM_CAPABILITY: local_ok
# Input Sanitization Library for Bill Sloth
# Prevents command injection and ensures safe user input handling

set -euo pipefail

# Sanitize user input by removing dangerous characters
sanitize_input() {
    local input="$1"
    local allow_spaces="${2:-false}"
    
    # Remove null bytes and control characters
    input=$(echo "$input" | tr -d '\0')
    input=$(echo "$input" | tr -d '\001-\010\013\014\016-\037\177')
    
    # Remove shell metacharacters
    input=$(echo "$input" | sed 's/[;&|`$(){}[\]<>*?!]/\\\&/g')
    
    # Handle quotes carefully
    input=$(echo "$input" | sed "s/'/'\\\\''/g")
    
    # Remove spaces if not allowed
    if [ "$allow_spaces" != "true" ]; then
        input=$(echo "$input" | tr -d ' ')
    fi
    
    echo "$input"
}

# Sanitize file paths
sanitize_path() {
    local path="$1"
    
    # Remove dangerous path components
    path=$(echo "$path" | sed 's/\.\.\///g')  # Remove ../
    path=$(echo "$path" | sed 's/^\///g')     # Remove leading /
    path=$(echo "$path" | sed 's/[;&|`$(){}[\]<>*?!]/\\\&/g')
    
    # Ensure path doesn't contain null bytes
    path=$(echo "$path" | tr -d '\0')
    
    echo "$path"
}

# Sanitize filenames
sanitize_filename() {
    local filename="$1"
    
    # Remove path separators and dangerous characters
    filename=$(echo "$filename" | tr -d '/')
    filename=$(echo "$filename" | tr -d '\\')
    filename=$(echo "$filename" | sed 's/[;&|`$(){}[\]<>*?!]/\\\&/g')
    filename=$(echo "$filename" | tr -d '\0\001-\037\177')
    
    # Remove leading dots and dashes
    filename=$(echo "$filename" | sed 's/^[.-]*//')
    
    # Limit length
    if [ ${#filename} -gt 255 ]; then
        filename="${filename:0:255}"
    fi
    
    echo "$filename"
}

# Validate email addresses
validate_email() {
    local email="$1"
    
    if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        echo "$email"
        return 0
    else
        return 1
    fi
}

# Validate URLs
validate_url() {
    local url="$1"
    
    if [[ "$url" =~ ^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$ ]]; then
        echo "$url"
        return 0
    else
        return 1
    fi
}

# Sanitize numbers (integers only)
sanitize_number() {
    local number="$1"
    local min="${2:-0}"
    local max="${3:-999999}"
    
    # Remove non-digits
    number=$(echo "$number" | sed 's/[^0-9]//g')
    
    # Default to 0 if empty
    if [ -z "$number" ]; then
        number="0"
    fi
    
    # Check bounds
    if [ "$number" -lt "$min" ]; then
        number="$min"
    elif [ "$number" -gt "$max" ]; then
        number="$max"
    fi
    
    echo "$number"
}

# Safe command execution with input validation
safe_execute() {
    local command="$1"
    shift
    local args=("$@")
    
    # Whitelist of allowed commands
    local allowed_commands=(
        "ls" "cat" "grep" "find" "mkdir" "rm" "cp" "mv"
        "git" "npm" "node" "python3" "pip3"
        "curl" "wget" "restic" "sqlite3" "jq"
        "systemctl" "service" "ufw"
    )
    
    # Check if command is allowed
    local command_allowed=false
    for allowed in "${allowed_commands[@]}"; do
        if [ "$command" = "$allowed" ]; then
            command_allowed=true
            break
        fi
    done
    
    if [ "$command_allowed" != "true" ]; then
        echo "ERROR: Command not allowed: $command" >&2
        return 1
    fi
    
    # Sanitize arguments
    local safe_args=()
    for arg in "${args[@]}"; do
        safe_args+=("$(sanitize_input "$arg" true)")
    done
    
    # Execute with timeout
    timeout 30 "$command" "${safe_args[@]}"
}

# Prompt user with input sanitization
safe_prompt() {
    local prompt="$1"
    local default="${2:-}"
    local max_length="${3:-255}"
    local allow_spaces="${4:-true}"
    
    local input
    read -p "$prompt" input
    
    # Use default if empty
    if [ -z "$input" ] && [ -n "$default" ]; then
        input="$default"
    fi
    
    # Sanitize input
    input=$(sanitize_input "$input" "$allow_spaces")
    
    # Limit length
    if [ ${#input} -gt "$max_length" ]; then
        input="${input:0:$max_length}"
    fi
    
    echo "$input"
}

# Validate directory path and create if needed
safe_mkdir() {
    local dir_path="$1"
    local permissions="${2:-755}"
    
    # Sanitize path
    dir_path=$(sanitize_path "$dir_path")
    
    # Ensure path is within allowed directories
    case "$dir_path" in
        "$HOME"*|"/tmp"*|"/var/tmp"*)
            mkdir -p "$dir_path" && chmod "$permissions" "$dir_path"
            ;;
        *)
            echo "ERROR: Directory path not allowed: $dir_path" >&2
            return 1
            ;;
    esac
}

# Safe file writing with permission control
safe_write_file() {
    local file_path="$1"
    local content="$2"
    local permissions="${3:-644}"
    
    # Sanitize file path
    file_path=$(sanitize_path "$file_path")
    
    # Ensure path is within allowed directories
    case "$file_path" in
        "$HOME"*|"/tmp"*|"/var/tmp"*)
            echo "$content" > "$file_path" && chmod "$permissions" "$file_path"
            ;;
        *)
            echo "ERROR: File path not allowed: $file_path" >&2
            return 1
            ;;
    esac
}

# Log security events
log_security_event() {
    local event="$1"
    local details="$2"
    local log_file="$HOME/.bill-sloth/security.log"
    
    # Create log directory if needed
    mkdir -p "$(dirname "$log_file")"
    
    # Log with timestamp
    echo "$(date '+%Y-%m-%d %H:%M:%S') SECURITY: $event - $details" >> "$log_file"
    chmod 600 "$log_file"
}

# Check for suspicious patterns in input
detect_malicious_input() {
    local input="$1"
    
    # Patterns that might indicate malicious intent
    local suspicious_patterns=(
        '\$\('          # Command substitution
        '`'             # Backticks
        '\|\|'          # OR operator
        '&&'            # AND operator
        ';'             # Command separator
        '\.\./\.\.'     # Path traversal
        '/etc/passwd'   # System files
        '/proc/'        # Process info
        'rm -rf'        # Dangerous deletion
        'curl.*\|.*sh'  # Pipe to shell
        'wget.*\|.*sh'  # Pipe to shell
    )
    
    for pattern in "${suspicious_patterns[@]}"; do
        if echo "$input" | grep -qE "$pattern"; then
            log_security_event "SUSPICIOUS_INPUT" "Pattern detected: $pattern in input: $input"
            return 0  # Suspicious
        fi
    done
    
    return 1  # Clean
}

# Export functions for use in other scripts
export -f sanitize_input sanitize_path sanitize_filename
export -f validate_email validate_url sanitize_number
export -f safe_execute safe_prompt safe_mkdir safe_write_file
export -f log_security_event detect_malicious_input