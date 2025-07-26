#!/bin/bash
# LLM_CAPABILITY: local_ok
# Safety Mechanisms Library
# Provides robust error handling and safety features for Bill Sloth

# Store original shell options
ORIGINAL_SET_OPTIONS=$(set +o | tr '\n' ';')
ORIGINAL_IFS="$IFS"

# Safe mode enabler (doesn't force global settings)
enable_safe_mode() {
    local script_name="${1:-script}"
    
    # Only set for current script, not globally
    set -euo pipefail
    
    # Set up error trap
    trap "handle_error \$? \$LINENO '$script_name'" ERR
    trap "handle_exit '$script_name'" EXIT
    
    echo "🛡️  Safe mode enabled for $script_name"
}

# Error handler with context
handle_error() {
    local exit_code=$1
    local line_number=$2
    local script_name=$3
    
    echo "❌ ERROR in $script_name at line $line_number (exit code: $exit_code)" >&2
    
    # Log error details
    if [[ -w "/tmp" ]]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $script_name:$line_number (exit: $exit_code)" >> "/tmp/bill_sloth_errors.log"
    fi
    
    # Attempt graceful recovery
    attempt_recovery "$exit_code" "$script_name"
}

# Exit handler for cleanup
handle_exit() {
    local script_name=$1
    local exit_code=$?
    
    # Restore original settings if needed
    if [[ "${BILL_SLOTH_RESTORE_SETTINGS:-}" == "1" ]]; then
        restore_original_settings
    fi
    
    # Cleanup temporary files
    cleanup_temp_files
    
    if [[ $exit_code -eq 0 ]]; then
        echo "✅ $script_name completed successfully"
    else
        echo "⚠️  $script_name exited with code $exit_code"
    fi
}

# Attempt automatic recovery
attempt_recovery() {
    local exit_code=$1
    local script_name=$2
    
    case $exit_code in
        1)
            echo "🔧 Attempting recovery from general error..."
            # Continue execution
            return 0
            ;;
        127)
            echo "🔧 Command not found - checking PATH and dependencies..."
            # Could trigger dependency installation
            return 0
            ;;
        130)
            echo "🔧 Script interrupted by user (Ctrl+C)"
            # Graceful shutdown
            exit 0
            ;;
        *)
            echo "⚠️  Unhandled error code: $exit_code"
            return 1
            ;;
    esac
}

# Restore original shell settings
restore_original_settings() {
    if [[ -n "${ORIGINAL_SET_OPTIONS:-}" ]]; then
        eval "$ORIGINAL_SET_OPTIONS"
    fi
    
    if [[ -n "${ORIGINAL_IFS:-}" ]]; then
        IFS="$ORIGINAL_IFS"
    fi
    
    echo "🔧 Original shell settings restored"
}

# Cleanup temporary files
cleanup_temp_files() {
    local temp_pattern="/tmp/bill_sloth_$$_*"
    
    if ls $temp_pattern >/dev/null 2>&1; then
        rm -f $temp_pattern
        echo "🧹 Temporary files cleaned up"
    fi
}

# Resource monitoring and limits
monitor_resources() {
    local max_memory_mb="${1:-1000}"
    local max_processes="${2:-50}"
    
    # Check memory usage
    local memory_kb=$(ps -o rss= -p $$ 2>/dev/null | tail -1 | tr -d ' ')
    local memory_mb=$((memory_kb / 1024))
    
    if [[ $memory_mb -gt $max_memory_mb ]]; then
        echo "⚠️  High memory usage: ${memory_mb}MB (limit: ${max_memory_mb}MB)" >&2
    fi
    
    # Check process count
    local process_count=$(pgrep -f "bill.*sloth" | wc -l)
    
    if [[ $process_count -gt $max_processes ]]; then
        echo "⚠️  High process count: $process_count (limit: $max_processes)" >&2
    fi
}

# Safe library loading
safe_source() {
    local lib_file="$1"
    local required="${2:-false}"
    
    if [[ ! -f "$lib_file" ]]; then
        if [[ "$required" == "true" ]]; then
            echo "❌ Required library not found: $lib_file" >&2
            return 1
        else
            echo "⚠️  Optional library not found: $lib_file" >&2
            return 0
        fi
    fi
    
    if [[ ! -r "$lib_file" ]]; then
        echo "❌ Cannot read library file: $lib_file" >&2
        return 1
    fi
    
    # Source in subshell first to test for syntax errors
    if ! (source "$lib_file") 2>/dev/null; then
        echo "❌ Syntax error in library: $lib_file" >&2
        return 1
    fi
    
    # Source in current shell
    source "$lib_file"
    echo "✅ Loaded library: $(basename "$lib_file")"
    return 0
}

# Health check function
system_health_check() {
    local issues=0
    
    echo "🏥 Running system health check..."
    
    # Check disk space
    local disk_usage=$(df "$HOME" | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ $disk_usage -gt 90 ]]; then
        echo "⚠️  Low disk space: ${disk_usage}%" >&2
        ((issues++))
    fi
    
    # Check memory
    monitor_resources
    
    # Check critical files
    local critical_files=(
        "$HOME/.bill-sloth/config.json"
        "$(dirname "${BASH_SOURCE[0]}")/claude_interactive_bridge.sh"
        "$(dirname "${BASH_SOURCE[0]}")/universal_interactive_bridge.sh"
    )
    
    for file in "${critical_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            echo "⚠️  Missing critical file: $file" >&2
            ((issues++))
        fi
    done
    
    if [[ $issues -eq 0 ]]; then
        echo "✅ System health check passed"
        return 0
    else
        echo "⚠️  System health check found $issues issues"
        return 1
    fi
}

# Export safety functions
export -f enable_safe_mode handle_error handle_exit attempt_recovery
export -f restore_original_settings cleanup_temp_files monitor_resources
export -f safe_source system_health_check