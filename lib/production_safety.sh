#!/bin/bash
# LLM_CAPABILITY: local_ok
# Production Safety Library - Critical error handling and data protection
# Prevents system hangs, data loss, and silent failures


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Safety configuration
SAFETY_TIMEOUT=300  # 5 minute timeout for interactive operations
MAX_RETRIES=3
BACKUP_VERIFICATION_ENABLED=true

# Initialize production safety systems
init_production_safety() {
    log_info "Initializing production safety systems..."
    
    # Set up signal handlers
    trap 'handle_emergency_exit "SIGINT"' INT
    trap 'handle_emergency_exit "SIGTERM"' TERM
    trap 'handle_timeout' ALRM
    
    # Create safety directories
    mkdir -p ~/.bill-sloth/{safety,recovery,lockfiles}
    
    log_success "Production safety systems initialized"
}

# Database integrity checking and recovery
check_database_integrity() {
    local db_file="$1"
    local backup_file="${db_file}.backup"
    
    if [ ! -f "$db_file" ]; then
        log_warning "Database not found: $db_file"
        return 1
    fi
    
    log_info "Checking database integrity: $db_file"
    
    # Check SQLite integrity
    local integrity_result=$(sqlite3 "$db_file" "PRAGMA integrity_check;" 2>/dev/null)
    
    if [ "$integrity_result" != "ok" ]; then
        log_error "DATABASE CORRUPTION DETECTED!"
        notify_error "Database Corruption" "Critical: Database corruption found in $db_file"
        
        # Attempt recovery from backup
        if [ -f "$backup_file" ]; then
            log_info "Attempting recovery from backup..."
            cp "$backup_file" "${db_file}.corrupted.$(date +%s)"
            cp "$backup_file" "$db_file"
            
            # Verify backup integrity
            local backup_integrity=$(sqlite3 "$db_file" "PRAGMA integrity_check;" 2>/dev/null)
            if [ "$backup_integrity" = "ok" ]; then
                log_success "Database recovered from backup"
                notify_success "Recovery Complete" "Database restored from backup successfully"
                return 0
            else
                log_error "Backup is also corrupted!"
                # Recreate empty database with schema
                rm -f "$db_file"
                source "$SCRIPT_DIR/data_persistence.sh" && create_database_schema
                log_warning "Created new empty database - data may be lost"
                return 2
            fi
        else
            log_error "No backup available for recovery!"
            # Create new database
            source "$SCRIPT_DIR/data_persistence.sh" && create_database_schema
            log_warning "Created new empty database - all data lost"
            return 3
        fi
    else
        log_success "Database integrity check passed"
        return 0
    fi
}

# Create automatic database backup before critical operations
create_safety_backup() {
    local db_file="$1"
    local operation="$2"
    
    if [ -f "$db_file" ]; then
        local backup_file="${db_file}.backup"
        local timestamped_backup="${db_file}.pre_${operation}_$(date +%s)"
        
        cp "$db_file" "$backup_file"
        cp "$db_file" "$timestamped_backup"
        
        log_info "Safety backup created for operation: $operation"
    fi
}

# Safe user input with timeout and validation
safe_read() {
    local prompt="$1"
    local timeout="${2:-$SAFETY_TIMEOUT}"
    local validation_pattern="$3"
    local response=""
    
    # Use timeout to prevent hanging
    if command -v timeout &> /dev/null; then
        if ! response=$(timeout "$timeout" bash -c "read -p '$prompt' response && echo \$response"); then
            log_warning "Input timeout after ${timeout}s - using default"
            return 1
        fi
    else
        # Fallback for systems without timeout command
        read -t "$timeout" -p "$prompt" response || {
            log_warning "Input timeout - using default"
            return 1
        }
    fi
    
    # Validate input if pattern provided
    if [ -n "$validation_pattern" ] && [[ ! "$response" =~ $validation_pattern ]]; then
        log_error "Invalid input format: $response"
        return 2
    fi
    
    echo "$response"
    return 0
}

# Validate VRBO booking data
validate_vrbo_booking() {
    local guest_name="$1"
    local property="$2"
    local checkin_date="$3"
    local checkout_date="$4"
    
    # Validate guest name (no empty, no special chars that could break SQL)
    if [[ -z "$guest_name" || "$guest_name" =~ [\'\"\\] ]]; then
        log_error "Invalid guest name: '$guest_name'"
        return 1
    fi
    
    # Validate property (must be non-empty)
    if [[ -z "$property" ]]; then
        log_error "Property name cannot be empty"
        return 1
    fi
    
    # Validate check-in date format (YYYY-MM-DD)
    if ! [[ "$checkin_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        log_error "Invalid check-in date format: '$checkin_date' (use YYYY-MM-DD)"
        return 1
    fi
    
    # Validate that check-in date is valid
    if ! date -d "$checkin_date" >/dev/null 2>&1; then
        log_error "Invalid check-in date: '$checkin_date'"
        return 1
    fi
    
    # Validate check-out date if provided
    if [ -n "$checkout_date" ]; then
        if ! [[ "$checkout_date" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
            log_error "Invalid check-out date format: '$checkout_date' (use YYYY-MM-DD)"
            return 1
        fi
        
        if ! date -d "$checkout_date" >/dev/null 2>&1; then
            log_error "Invalid check-out date: '$checkout_date'"
            return 1
        fi
        
        # Check that checkout is after checkin
        if [[ "$checkout_date" < "$checkin_date" ]]; then
            log_error "Check-out date must be after check-in date"
            return 1
        fi
    fi
    
    # Check for duplicate bookings
    if command -v sqlite3 &> /dev/null; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        if [ -f "$db_file" ]; then
            local existing=$(sqlite3 "$db_file" "SELECT COUNT(*) FROM vrbo_bookings WHERE guest_name='$guest_name' AND property='$property' AND checkin_date='$checkin_date';" 2>/dev/null)
            if [ "$existing" -gt 0 ]; then
                log_warning "Duplicate booking detected: $guest_name at $property on $checkin_date"
                return 2  # Warning, not error
            fi
        fi
    fi
    
    log_success "VRBO booking validation passed"
    return 0
}

# Safe SQLite operation with locking
safe_sqlite_operation() {
    local db_file="$1"
    local sql_command="$2"
    local operation_name="$3"
    local lockfile="$HOME/.bill-sloth/lockfiles/$(basename "$db_file").lock"
    
    # Wait for lock with timeout
    local lock_timeout=30
    local lock_acquired=false
    
    for ((i=0; i<lock_timeout; i++)); do
        if (set -C; echo $$ > "$lockfile") 2>/dev/null; then
            lock_acquired=true
            break
        fi
        sleep 1
    done
    
    if [ "$lock_acquired" = false ]; then
        log_error "Could not acquire database lock after ${lock_timeout}s"
        return 1
    fi
    
    # Ensure lock is released on exit
    trap "rm -f '$lockfile'" EXIT
    
    # Check database integrity before operation
    check_database_integrity "$db_file"
    local integrity_status=$?
    
    if [ $integrity_status -gt 1 ]; then
        log_error "Database integrity check failed - aborting operation"
        rm -f "$lockfile"
        return 1
    fi
    
    # Create safety backup
    create_safety_backup "$db_file" "$operation_name"
    
    # Execute SQLite operation
    local result
    if result=$(sqlite3 "$db_file" "$sql_command" 2>&1); then
        log_success "SQLite operation completed: $operation_name"
        rm -f "$lockfile"
        echo "$result"
        return 0
    else
        log_error "SQLite operation failed: $result"
        rm -f "$lockfile"
        return 1
    fi
}

# Verify backup integrity
verify_backup_integrity() {
    local backup_path="$1"
    local verification_file="${backup_path}.verified"
    
    if [ ! -f "$backup_path" ]; then
        log_error "Backup file not found: $backup_path"
        return 1
    fi
    
    log_info "Verifying backup integrity: $backup_path"
    
    # Check file is not empty
    if [ ! -s "$backup_path" ]; then
        log_error "Backup file is empty: $backup_path"
        return 1
    fi
    
    # For SQLite backups, check database integrity
    if [[ "$backup_path" == *.db ]] || [[ "$backup_path" == *.sqlite* ]]; then
        local integrity_check=$(sqlite3 "$backup_path" "PRAGMA integrity_check;" 2>/dev/null)
        if [ "$integrity_check" != "ok" ]; then
            log_error "Backup database integrity check failed: $backup_path"
            return 1
        fi
    fi
    
    # For compressed backups, test extraction
    if [[ "$backup_path" == *.tar.gz ]] || [[ "$backup_path" == *.tgz ]]; then
        if ! tar -tzf "$backup_path" >/dev/null 2>&1; then
            log_error "Backup archive is corrupted: $backup_path"
            return 1
        fi
    fi
    
    # Create verification marker
    echo "Verified: $(date)" > "$verification_file"
    log_success "Backup verification passed: $backup_path"
    return 0
}

# Safe operation wrapper with retries and error handling
safe_operation() {
    local operation_name="$1"
    local operation_command="$2"
    local max_retries="${3:-$MAX_RETRIES}"
    local retry_delay="${4:-2}"
    
    log_info "Starting safe operation: $operation_name"
    
    for ((attempt=1; attempt<=max_retries; attempt++)); do
        log_info "Attempt $attempt/$max_retries for: $operation_name"
        
        if eval "$operation_command"; then
            log_success "Operation completed successfully: $operation_name"
            return 0
        else
            local exit_code=$?
            log_warning "Operation failed (attempt $attempt/$max_retries): $operation_name"
            
            if [ $attempt -lt $max_retries ]; then
                log_info "Retrying in ${retry_delay}s..."
                sleep "$retry_delay"
            else
                log_error "Operation failed after $max_retries attempts: $operation_name"
                notify_error "Operation Failed" "$operation_name failed after $max_retries attempts"
                return $exit_code
            fi
        fi
    done
}

# Emergency exit handler
handle_emergency_exit() {
    local signal="$1"
    log_warning "Emergency exit triggered by signal: $signal"
    
    # Clean up lock files
    rm -f ~/.bill-sloth/lockfiles/*.lock
    
    # Save current state if possible
    if command -v sqlite3 &> /dev/null; then
        local db_file="$HOME/.bill-sloth/data/bill_sloth.db"
        if [ -f "$db_file" ]; then
            cp "$db_file" "${db_file}.emergency_backup_$(date +%s)"
        fi
    fi
    
    notify_warning "Emergency Exit" "Bill Sloth was interrupted but state was saved"
    exit 1
}

# Timeout handler
handle_timeout() {
    log_warning "Operation timed out"
    notify_warning "Operation Timeout" "Long-running operation was cancelled"
}

# Dependency check with user-friendly messages
check_critical_dependencies() {
    local missing_deps=()
    local warnings=()
    
    # Critical dependencies
    if ! command -v sqlite3 &> /dev/null; then
        missing_deps+=("sqlite3")
    fi
    
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    # Optional but important dependencies
    if ! command -v filebot &> /dev/null; then
        warnings+=("FileBot (advanced media processing will be limited)")
    fi
    
    if ! command -v restic &> /dev/null; then
        warnings+=("restic (backup system will use basic file copy)")
    fi
    
    # Report results
    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_error "CRITICAL: Missing required dependencies: ${missing_deps[*]}"
        echo ""
        echo "🔧 To install missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "sqlite3")
                    echo "   Ubuntu/Debian: sudo apt install sqlite3"
                    echo "   CentOS/RHEL: sudo yum install sqlite"
                    ;;
                "jq")
                    echo "   Ubuntu/Debian: sudo apt install jq"
                    echo "   CentOS/RHEL: sudo yum install jq"
                    ;;
            esac
        done
        return 1
    fi
    
    if [ ${#warnings[@]} -gt 0 ]; then
        log_warning "Optional dependencies missing (reduced functionality):"
        for warning in "${warnings[@]}"; do
            echo "   ⚠️  $warning"
        done
    fi
    
    log_success "All critical dependencies available"
    return 0
}

# Export functions
export -f init_production_safety check_database_integrity create_safety_backup
export -f safe_read validate_vrbo_booking safe_sqlite_operation verify_backup_integrity
export -f safe_operation handle_emergency_exit check_critical_dependencies

# Initialize safety on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_production_safety 2>/dev/null || true
fi