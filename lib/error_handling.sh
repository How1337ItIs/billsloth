#!/bin/bash
# Bill Sloth Standardized Error Handling Library
# Provides consistent error messaging across all modules
# Part of Phase 1 Implementation Plan - Core Stabilization

# Colors for consistent output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Log levels
ERROR_LEVEL=1
WARNING_LEVEL=2
INFO_LEVEL=3
SUCCESS_LEVEL=4
DEBUG_LEVEL=5

# Current log level (can be overridden by modules)
LOG_LEVEL=${LOG_LEVEL:-$INFO_LEVEL}

# Log file location (optional)
LOG_FILE="${LOG_FILE:-}"

# Function to write to log file if enabled
write_to_log() {
    local level="$1"
    local message="$2"
    
    if [ -n "$LOG_FILE" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $message" >> "$LOG_FILE"
    fi
}

# Error logging - Always shown
log_error() {
    local message="$1"
    echo -e "${RED}❌ ERROR: $message${NC}" >&2
    write_to_log "ERROR" "$message"
    return 1
}

# Warning logging - Shown at warning level and above
log_warning() {
    local message="$1"
    if [ "$LOG_LEVEL" -ge "$WARNING_LEVEL" ]; then
        echo -e "${YELLOW}⚠️  WARNING: $message${NC}" >&2
    fi
    write_to_log "WARNING" "$message"
    return 0
}

# Info logging - Shown at info level and above
log_info() {
    local message="$1"
    if [ "$LOG_LEVEL" -ge "$INFO_LEVEL" ]; then
        echo -e "${BLUE}ℹ️  INFO: $message${NC}"
    fi
    write_to_log "INFO" "$message"
    return 0
}

# Success logging - Always shown for positive feedback
log_success() {
    local message="$1"
    echo -e "${GREEN}✅ SUCCESS: $message${NC}"
    write_to_log "SUCCESS" "$message"
    return 0
}

# Debug logging - Only shown at debug level
log_debug() {
    local message="$1"
    if [ "$LOG_LEVEL" -ge "$DEBUG_LEVEL" ]; then
        echo -e "${PURPLE}🔍 DEBUG: $message${NC}"
    fi
    write_to_log "DEBUG" "$message"
    return 0
}

# Progress logging - For ADHD-friendly progress indicators
log_progress() {
    local message="$1"
    echo -e "${CYAN}⏳ PROGRESS: $message${NC}"
    write_to_log "PROGRESS" "$message"
    return 0
}

# Step logging - For multi-step processes
log_step() {
    local step_num="$1"
    local total_steps="$2"
    local message="$3"
    echo -e "${CYAN}📍 STEP [$step_num/$total_steps]: $message${NC}"
    write_to_log "STEP" "[$step_num/$total_steps] $message"
    return 0
}

# Fatal error - Logs error and exits
log_fatal() {
    local message="$1"
    local exit_code="${2:-1}"
    echo -e "${RED}💀 FATAL ERROR: $message${NC}" >&2
    write_to_log "FATAL" "$message (exit code: $exit_code)"
    exit "$exit_code"
}

# Check command success with custom error message
check_success() {
    local exit_code="$1"
    local success_msg="$2"
    local error_msg="$3"
    
    if [ "$exit_code" -eq 0 ]; then
        log_success "$success_msg"
        return 0
    else
        log_error "$error_msg"
        return "$exit_code"
    fi
}

# Execute command with error handling
run_with_error_handling() {
    local command="$1"
    local success_msg="${2:-Command completed successfully}"
    local error_msg="${3:-Command failed}"
    
    log_debug "Executing: $command"
    
    if eval "$command"; then
        log_success "$success_msg"
        return 0
    else
        local exit_code=$?
        log_error "$error_msg (exit code: $exit_code)"
        return $exit_code
    fi
}

# Retry mechanism with exponential backoff
retry_with_backoff() {
    local max_attempts="${1:-3}"
    local initial_delay="${2:-1}"
    local command="${3}"
    local attempt=1
    local delay="$initial_delay"
    
    while [ "$attempt" -le "$max_attempts" ]; do
        log_info "Attempt $attempt of $max_attempts..."
        
        if eval "$command"; then
            log_success "Command succeeded on attempt $attempt"
            return 0
        else
            local exit_code=$?
            if [ "$attempt" -lt "$max_attempts" ]; then
                log_warning "Attempt $attempt failed, retrying in ${delay}s..."
                sleep "$delay"
                delay=$((delay * 2))  # Exponential backoff
                attempt=$((attempt + 1))
            else
                log_error "All $max_attempts attempts failed"
                return $exit_code
            fi
        fi
    done
}

# Validate required commands exist
check_required_commands() {
    local missing_commands=()
    
    for cmd in "$@"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_commands+=("$cmd")
        fi
    done
    
    if [ ${#missing_commands[@]} -gt 0 ]; then
        log_error "Missing required commands: ${missing_commands[*]}"
        return 1
    else
        log_debug "All required commands available: $*"
        return 0
    fi
}

# Create directory with error handling
create_directory() {
    local dir="$1"
    local mode="${2:-755}"
    
    if [ -d "$dir" ]; then
        log_debug "Directory already exists: $dir"
        return 0
    fi
    
    if mkdir -p -m "$mode" "$dir" 2>/dev/null; then
        log_success "Created directory: $dir"
        return 0
    else
        log_error "Failed to create directory: $dir"
        return 1
    fi
}

# Safe file backup
backup_file() {
    local file="$1"
    local backup_dir="${2:-$HOME/.bill-sloth/backups}"
    
    if [ ! -f "$file" ]; then
        log_warning "File does not exist, nothing to backup: $file"
        return 0
    fi
    
    create_directory "$backup_dir" || return 1
    
    local backup_name="$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
    local backup_path="$backup_dir/$backup_name"
    
    if cp "$file" "$backup_path" 2>/dev/null; then
        log_success "Backed up $file to $backup_path"
        return 0
    else
        log_error "Failed to backup $file"
        return 1
    fi
}

# Prompt user with timeout
prompt_with_timeout() {
    local prompt="$1"
    local timeout="${2:-30}"
    local default="${3:-}"
    
    echo -en "${CYAN}❓ $prompt${NC}"
    
    if [ -n "$default" ]; then
        echo -n " (default: $default)"
    fi
    echo -n ": "
    
    if read -t "$timeout" response; then
        echo "${response:-$default}"
    else
        echo ""
        log_warning "Prompt timed out after ${timeout}s, using default: $default"
        echo "$default"
    fi
}

# Confirmation prompt
confirm() {
    local prompt="$1"
    local default="${2:-n}"  # Default to 'no' for safety
    
    local response
    response=$(prompt_with_timeout "$prompt [y/N]" 30 "$default")
    
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Display separator for visual clarity
print_separator() {
    local char="${1:-=}"
    local width="${2:-50}"
    printf '%*s\n' "$width" '' | tr ' ' "$char"
}

# Header for sections
print_header() {
    local title="$1"
    local width="${2:-50}"
    
    echo ""
    print_separator "=" "$width"
    echo -e "${CYAN}$title${NC}"
    print_separator "=" "$width"
    echo ""
}

# Export all functions for use in other scripts
export -f log_error log_warning log_info log_success log_debug log_progress log_step log_fatal
export -f check_success run_with_error_handling retry_with_backoff
export -f check_required_commands create_directory backup_file
export -f prompt_with_timeout confirm print_separator print_header

# Set error handling defaults if sourcing script doesn't set them
if [ -z "$ERROR_HANDLING_LOADED" ]; then
    export ERROR_HANDLING_LOADED=1
    
    # Enable strict error handling by default
    set -euo pipefail
    
    # Set default IFS to handle spaces properly
    IFS=$'\n\t'
fi

# Self-test function
test_error_handling() {
    print_header "Testing Error Handling Library"
    
    log_info "Testing info message"
    log_warning "Testing warning message"
    log_success "Testing success message"
    log_error "Testing error message" || true
    log_debug "Testing debug message (may not show)"
    log_progress "Testing progress message"
    log_step 1 3 "Testing step message"
    
    print_separator
    
    check_required_commands bash ls echo || true
    check_required_commands nonexistent_command || true
    
    print_separator
    
    if confirm "Test confirmation prompt?"; then
        log_success "Confirmation accepted"
    else
        log_info "Confirmation declined"
    fi
    
    print_separator
    log_success "Error handling library test complete!"
}

# Run self-test if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    test_error_handling
fi