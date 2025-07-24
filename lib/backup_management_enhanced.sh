#!/bin/bash
# LLM_CAPABILITY: local_ok
# Enhanced Backup Management Library with Scheduling and Validation
# Professional-grade backup system for Bill Sloth infrastructure

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/input_sanitization.sh" 2>/dev/null || true

# Global backup configuration
BACKUP_BASE_DIR="$HOME/.bill-sloth/backups"
BACKUP_CONFIG_DIR="$BACKUP_BASE_DIR/config"
BACKUP_LOGS_DIR="$BACKUP_BASE_DIR/logs"
BACKUP_SCHEDULES_DIR="$BACKUP_BASE_DIR/schedules"
BACKUP_METRICS_FILE="$BACKUP_CONFIG_DIR/backup_metrics.json"

# Initialize enhanced backup system
init_backup_system_enhanced() {
    log_info "Initializing enhanced backup management system..."
    
    # Create directory structure
    mkdir -p "$BACKUP_BASE_DIR"/{config,logs,schedules,local,cloud,archives,validation}
    mkdir -p "$BACKUP_BASE_DIR/local"/{full,incremental,differential,snapshots}
    mkdir -p "$BACKUP_BASE_DIR/cloud"/{sync,upload,download,pending}
    mkdir -p "$BACKUP_BASE_DIR/validation"/{checksums,manifests,reports}
    
    # Initialize backup database
    init_backup_database
    
    # Create enhanced backup configuration
    if [ ! -f "$BACKUP_CONFIG_DIR/backup_config.json" ]; then
        create_enhanced_backup_config
    fi
    
    # Initialize metrics tracking
    if [ ! -f "$BACKUP_METRICS_FILE" ]; then
        echo '{
            "total_backups": 0,
            "successful_backups": 0,
            "failed_backups": 0,
            "total_size_bytes": 0,
            "average_backup_time": 0,
            "last_successful_backup": null,
            "validation_success_rate": 100,
            "cloud_sync_success_rate": 100
        }' > "$BACKUP_METRICS_FILE"
    fi
    
    # Set up cron jobs for scheduled backups
    setup_backup_schedules
    
    log_success "Enhanced backup system initialized"
}

# Initialize SQLite database for backup tracking
init_backup_database() {
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    
    sqlite3 "$db_file" << 'EOF'
CREATE TABLE IF NOT EXISTS backups (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_id TEXT UNIQUE NOT NULL,
    backup_set TEXT NOT NULL,
    backup_type TEXT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    status TEXT NOT NULL,
    size_bytes INTEGER,
    files_count INTEGER,
    source_paths TEXT,
    destination_path TEXT,
    checksum TEXT,
    validation_status TEXT,
    error_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS backup_files (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_id TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER,
    file_checksum TEXT,
    modification_time TIMESTAMP,
    FOREIGN KEY (backup_id) REFERENCES backups(backup_id)
);

CREATE TABLE IF NOT EXISTS backup_schedules (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    schedule_name TEXT UNIQUE NOT NULL,
    backup_set TEXT NOT NULL,
    backup_type TEXT NOT NULL,
    cron_expression TEXT NOT NULL,
    enabled BOOLEAN DEFAULT TRUE,
    last_run TIMESTAMP,
    next_run TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS backup_validations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    backup_id TEXT NOT NULL,
    validation_type TEXT NOT NULL,
    validation_time TIMESTAMP NOT NULL,
    result TEXT NOT NULL,
    details TEXT,
    FOREIGN KEY (backup_id) REFERENCES backups(backup_id)
);

CREATE INDEX IF NOT EXISTS idx_backups_status ON backups(status);
CREATE INDEX IF NOT EXISTS idx_backups_date ON backups(start_time);
CREATE INDEX IF NOT EXISTS idx_backup_files_backup ON backup_files(backup_id);
CREATE INDEX IF NOT EXISTS idx_validations_backup ON backup_validations(backup_id);
EOF
}

# Create enhanced backup configuration
create_enhanced_backup_config() {
    cat > "$BACKUP_CONFIG_DIR/backup_config.json" << 'EOF'
{
  "backup_sets": {
    "bill_critical": {
      "description": "Critical Bill Sloth system files",
      "sources": [
        "~/.bill-sloth/",
        "~/VacationRental/",
        "~/edboigames_business/",
        "~/.bill-sloth/automation/",
        "~/.bill-sloth/workflows/",
        "~/.bill-sloth/shared-data/"
      ],
      "exclude_patterns": [
        "*.tmp",
        "*.log",
        "*cache*",
        "*temp*",
        "*.swp",
        ".git/objects/*"
      ],
      "retention_policy": {
        "daily": 7,
        "weekly": 4,
        "monthly": 12,
        "yearly": 5
      },
      "compression": "gzip",
      "compression_level": 6,
      "encryption": {
        "enabled": true,
        "algorithm": "AES-256-CBC",
        "key_file": "~/.bill-sloth/backups/config/encryption.key"
      },
      "validation": {
        "checksum": true,
        "test_restore": "monthly",
        "verify_count": true
      },
      "priority": "high"
    },
    "vrbo_data": {
      "description": "VRBO property management data",
      "sources": [
        "~/VacationRental/",
        "~/.bill-sloth/vrbo/",
        "~/.bill-sloth/vrbo-automation/",
        "~/.bill-sloth/media-processing/vrbo/",
        "/var/lib/docker/volumes/postgres-data/"
      ],
      "exclude_patterns": [
        "*.tmp",
        "*cache*",
        "*.log"
      ],
      "retention_policy": {
        "daily": 14,
        "weekly": 8,
        "monthly": 24
      },
      "compression": "zstd",
      "compression_level": 3,
      "encryption": {
        "enabled": true,
        "algorithm": "AES-256-CBC"
      },
      "pre_backup_hooks": [
        "docker exec bill-postgres pg_dump -U bill bill_business > /tmp/vrbo_db_backup.sql"
      ],
      "post_backup_hooks": [
        "rm -f /tmp/vrbo_db_backup.sql"
      ],
      "priority": "high"
    },
    "edboigames_content": {
      "description": "EdBoiGames business and content data",
      "sources": [
        "~/edboigames_business/",
        "~/.bill-sloth/partnerships/",
        "~/.bill-sloth/media-processing/edboigames/"
      ],
      "exclude_patterns": [
        "*.tmp",
        "*processed*",
        "*.cache"
      ],
      "retention_policy": {
        "daily": 7,
        "weekly": 4,
        "monthly": 12
      },
      "compression": "gzip",
      "encryption": {
        "enabled": false
      },
      "priority": "medium"
    },
    "docker_volumes": {
      "description": "Docker volumes and configurations",
      "sources": [
        "/var/lib/docker/volumes/",
        "~/bill-sloth/docker/",
        "~/bill-sloth/config/"
      ],
      "exclude_patterns": [
        "*.log",
        "*tmp*"
      ],
      "retention_policy": {
        "daily": 3,
        "weekly": 2
      },
      "requires_sudo": true,
      "priority": "medium"
    }
  },
  "cloud_providers": {
    "dropbox": {
      "enabled": false,
      "remote_path": "dropbox:BillSlothBackups/",
      "sync_frequency": "daily",
      "retention_policy": {
        "weekly": 4,
        "monthly": 12
      }
    },
    "google_drive": {
      "enabled": false,
      "remote_path": "gdrive:BillSlothBackups/",
      "sync_frequency": "daily",
      "retention_policy": {
        "weekly": 4,
        "monthly": 12
      }
    },
    "aws_s3": {
      "enabled": false,
      "bucket": "bill-sloth-backups",
      "region": "us-east-1",
      "storage_class": "STANDARD_IA",
      "lifecycle_rules": true
    }
  },
  "schedules": {
    "critical_hourly": {
      "backup_set": "bill_critical",
      "type": "incremental",
      "cron": "0 * * * *",
      "enabled": false,
      "description": "Hourly incremental backup of critical files"
    },
    "daily_critical": {
      "backup_set": "bill_critical",
      "type": "incremental",
      "cron": "0 2 * * *",
      "enabled": true,
      "description": "Daily incremental backup at 2 AM"
    },
    "weekly_full": {
      "backup_set": "bill_critical",
      "type": "full",
      "cron": "0 1 * * 0",
      "enabled": true,
      "description": "Weekly full backup on Sunday at 1 AM"
    },
    "daily_vrbo": {
      "backup_set": "vrbo_data",
      "type": "incremental",
      "cron": "30 2 * * *",
      "enabled": true,
      "description": "Daily VRBO data backup at 2:30 AM"
    },
    "weekly_business": {
      "backup_set": "edboigames_content",
      "type": "full",
      "cron": "0 3 * * 0",
      "enabled": true,
      "description": "Weekly business content backup"
    }
  },
  "notification_settings": {
    "email_on_failure": true,
    "email_on_success": false,
    "slack_webhook": "",
    "summary_frequency": "weekly"
  },
  "performance_settings": {
    "parallel_compression": true,
    "compression_threads": 4,
    "bandwidth_limit": "10M",
    "nice_level": 10,
    "ionice_class": 3
  }
}
EOF
}

# Create enhanced backup with validation
create_backup_enhanced() {
    local backup_set="$1"
    local backup_type="${2:-incremental}"  # full, incremental, differential
    local destination="${3:-local}"
    
    log_info "Starting enhanced backup: $backup_set ($backup_type)"
    
    # Validate backup set
    if ! validate_backup_set "$backup_set"; then
        log_error "Invalid backup set: $backup_set"
        return 1
    fi
    
    local backup_id="backup_$(date +%Y%m%d_%H%M%S)_${backup_set}_${backup_type}"
    local start_time=$(date -Iseconds)
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    
    # Record backup start
    sqlite3 "$db_file" "INSERT INTO backups (backup_id, backup_set, backup_type, start_time, status) 
                        VALUES ('$backup_id', '$backup_set', '$backup_type', '$start_time', 'running');"
    
    # Load backup configuration
    local config_file="$BACKUP_CONFIG_DIR/backup_config.json"
    local sources=$(jq -r ".backup_sets.${backup_set}.sources[]" "$config_file")
    local exclude_patterns=$(jq -r ".backup_sets.${backup_set}.exclude_patterns[]?" "$config_file")
    local compression=$(jq -r ".backup_sets.${backup_set}.compression // \"gzip\"" "$config_file")
    local encryption_enabled=$(jq -r ".backup_sets.${backup_set}.encryption.enabled // false" "$config_file")
    
    # Run pre-backup hooks
    run_backup_hooks "$backup_set" "pre"
    
    # Determine backup destination
    local backup_dir="$BACKUP_BASE_DIR/local/$backup_type"
    local backup_file="$backup_dir/${backup_id}.tar.${compression}"
    
    # Create exclude file
    local exclude_file="/tmp/${backup_id}_exclude.txt"
    echo "$exclude_patterns" > "$exclude_file"
    
    # Build tar command
    local tar_cmd="tar"
    
    # Add compression
    case "$compression" in
        gzip) tar_cmd="$tar_cmd -czf" ;;
        bzip2) tar_cmd="$tar_cmd -cjf" ;;
        xz) tar_cmd="$tar_cmd -cJf" ;;
        zstd) tar_cmd="$tar_cmd --zstd -cf" ;;
        *) tar_cmd="$tar_cmd -cf" ;;
    esac
    
    # Add nice and ionice for performance
    tar_cmd="nice -n 10 ionice -c 3 $tar_cmd"
    
    # Create backup
    log_info "Creating backup archive..."
    
    # For incremental backups, use snapshot file
    local snapshot_file=""
    if [ "$backup_type" = "incremental" ]; then
        snapshot_file="$BACKUP_BASE_DIR/local/snapshots/${backup_set}.snar"
        mkdir -p "$(dirname "$snapshot_file")"
        tar_cmd="$tar_cmd $backup_file --listed-incremental=$snapshot_file"
    else
        tar_cmd="$tar_cmd $backup_file"
    fi
    
    # Add exclude patterns
    tar_cmd="$tar_cmd --exclude-from=$exclude_file"
    
    # Add sources (expanding home directory)
    local expanded_sources=""
    for source in $sources; do
        expanded_source=$(eval echo "$source")
        if [ -e "$expanded_source" ]; then
            expanded_sources="$expanded_sources $expanded_source"
        else
            log_warning "Source not found: $source"
        fi
    done
    
    # Execute backup
    if [ -n "$expanded_sources" ]; then
        # Create file list first for validation
        local file_list="/tmp/${backup_id}_files.txt"
        find $expanded_sources -type f > "$file_list" 2>/dev/null || true
        local file_count=$(wc -l < "$file_list")
        
        # Run tar command
        if eval "$tar_cmd $expanded_sources" 2>"$BACKUP_LOGS_DIR/${backup_id}.log"; then
            log_success "Backup archive created successfully"
            
            # Get backup size
            local backup_size=$(stat -c%s "$backup_file" 2>/dev/null || stat -f%z "$backup_file" 2>/dev/null || echo 0)
            
            # Calculate checksum
            local checksum=$(sha256sum "$backup_file" | cut -d' ' -f1)
            
            # Encrypt if enabled
            if [ "$encryption_enabled" = "true" ]; then
                if encrypt_backup "$backup_file" "$backup_set"; then
                    backup_file="${backup_file}.enc"
                    backup_size=$(stat -c%s "$backup_file" 2>/dev/null || stat -f%z "$backup_file" 2>/dev/null || echo 0)
                    checksum=$(sha256sum "$backup_file" | cut -d' ' -f1)
                fi
            fi
            
            # Update database
            local end_time=$(date -Iseconds)
            sqlite3 "$db_file" "UPDATE backups SET 
                              end_time = '$end_time',
                              status = 'completed',
                              size_bytes = $backup_size,
                              files_count = $file_count,
                              destination_path = '$backup_file',
                              checksum = '$checksum'
                              WHERE backup_id = '$backup_id';"
            
            # Validate backup
            if validate_backup "$backup_id" "$backup_file" "$checksum"; then
                log_success "Backup validation passed"
                
                # Update metrics
                update_backup_metrics "success" "$backup_size" "$start_time" "$end_time"
                
                # Cloud sync if configured
                if [ "$destination" = "cloud" ] || should_sync_to_cloud "$backup_set"; then
                    sync_to_cloud "$backup_id" "$backup_file" "$backup_set"
                fi
                
                # Clean up old backups
                cleanup_old_backups "$backup_set"
                
                # Send success notification if configured
                notify_backup_success "$backup_id" "$backup_set" "$backup_size"
            else
                log_error "Backup validation failed"
                sqlite3 "$db_file" "UPDATE backups SET validation_status = 'failed' WHERE backup_id = '$backup_id';"
                update_backup_metrics "validation_failed" 0 "$start_time" "$end_time"
            fi
            
        else
            log_error "Backup creation failed"
            local error_msg=$(tail -n 10 "$BACKUP_LOGS_DIR/${backup_id}.log" | tr '\n' ' ')
            sqlite3 "$db_file" "UPDATE backups SET 
                              status = 'failed',
                              error_message = '$error_msg'
                              WHERE backup_id = '$backup_id';"
            
            update_backup_metrics "failed" 0 "$start_time" "$(date -Iseconds)"
            notify_backup_failure "$backup_id" "$backup_set" "$error_msg"
            return 1
        fi
        
        # Cleanup
        rm -f "$exclude_file" "$file_list"
    else
        log_error "No valid sources found for backup"
        return 1
    fi
    
    # Run post-backup hooks
    run_backup_hooks "$backup_set" "post"
    
    log_success "Enhanced backup completed: $backup_id"
    return 0
}

# Validate backup set exists
validate_backup_set() {
    local backup_set="$1"
    jq -e ".backup_sets.$backup_set" "$BACKUP_CONFIG_DIR/backup_config.json" >/dev/null 2>&1
}

# Run backup hooks
run_backup_hooks() {
    local backup_set="$1"
    local hook_type="$2"  # pre or post
    
    local hooks=$(jq -r ".backup_sets.${backup_set}.${hook_type}_backup_hooks[]?" "$BACKUP_CONFIG_DIR/backup_config.json" 2>/dev/null)
    
    if [ -n "$hooks" ]; then
        log_info "Running $hook_type-backup hooks for $backup_set"
        echo "$hooks" | while read -r hook_cmd; do
            if [ -n "$hook_cmd" ]; then
                log_debug "Executing: $hook_cmd"
                eval "$hook_cmd" || log_warning "Hook failed: $hook_cmd"
            fi
        done
    fi
}

# Encrypt backup file
encrypt_backup() {
    local backup_file="$1"
    local backup_set="$2"
    
    local key_file=$(jq -r ".backup_sets.${backup_set}.encryption.key_file // \"~/.bill-sloth/backups/config/encryption.key\"" "$BACKUP_CONFIG_DIR/backup_config.json")
    key_file=$(eval echo "$key_file")
    
    # Generate key if not exists
    if [ ! -f "$key_file" ]; then
        log_info "Generating encryption key..."
        mkdir -p "$(dirname "$key_file")"
        openssl rand -base64 32 > "$key_file"
        chmod 600 "$key_file"
    fi
    
    # Encrypt file
    log_info "Encrypting backup..."
    if openssl enc -aes-256-cbc -salt -pbkdf2 -in "$backup_file" -out "${backup_file}.enc" -pass file:"$key_file"; then
        rm -f "$backup_file"  # Remove unencrypted file
        return 0
    else
        log_error "Encryption failed"
        return 1
    fi
}

# Validate backup integrity
validate_backup() {
    local backup_id="$1"
    local backup_file="$2"
    local expected_checksum="$3"
    
    log_info "Validating backup: $backup_id"
    
    # Verify file exists
    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        return 1
    fi
    
    # Verify checksum
    local actual_checksum=$(sha256sum "$backup_file" | cut -d' ' -f1)
    if [ "$actual_checksum" != "$expected_checksum" ]; then
        log_error "Checksum mismatch! Expected: $expected_checksum, Actual: $actual_checksum"
        record_validation_result "$backup_id" "checksum" "failed" "Checksum mismatch"
        return 1
    fi
    
    log_debug "Checksum validation passed"
    record_validation_result "$backup_id" "checksum" "passed" "Checksum match"
    
    # Test archive integrity
    local test_cmd=""
    if [[ "$backup_file" =~ \.enc$ ]]; then
        log_debug "Skipping archive test for encrypted backup"
        record_validation_result "$backup_id" "archive" "skipped" "Encrypted file"
    else
        case "$backup_file" in
            *.tar.gz|*.tgz) test_cmd="tar -tzf" ;;
            *.tar.bz2) test_cmd="tar -tjf" ;;
            *.tar.xz) test_cmd="tar -tJf" ;;
            *.tar.zst) test_cmd="tar --zstd -tf" ;;
            *.tar) test_cmd="tar -tf" ;;
        esac
        
        if [ -n "$test_cmd" ]; then
            if $test_cmd "$backup_file" >/dev/null 2>&1; then
                log_debug "Archive integrity test passed"
                record_validation_result "$backup_id" "archive" "passed" "Archive valid"
            else
                log_error "Archive integrity test failed"
                record_validation_result "$backup_id" "archive" "failed" "Archive corrupted"
                return 1
            fi
        fi
    fi
    
    # Record successful validation
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    sqlite3 "$db_file" "UPDATE backups SET validation_status = 'passed' WHERE backup_id = '$backup_id';"
    
    return 0
}

# Record validation result
record_validation_result() {
    local backup_id="$1"
    local validation_type="$2"
    local result="$3"
    local details="$4"
    
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    sqlite3 "$db_file" "INSERT INTO backup_validations (backup_id, validation_type, validation_time, result, details)
                        VALUES ('$backup_id', '$validation_type', '$(date -Iseconds)', '$result', '$details');"
}

# Check if should sync to cloud
should_sync_to_cloud() {
    local backup_set="$1"
    
    # Check if any cloud provider is enabled
    local cloud_providers=$(jq -r '.cloud_providers | to_entries[] | select(.value.enabled == true) | .key' "$BACKUP_CONFIG_DIR/backup_config.json")
    
    [ -n "$cloud_providers" ]
}

# Sync backup to cloud
sync_to_cloud() {
    local backup_id="$1"
    local backup_file="$2"
    local backup_set="$3"
    
    log_info "Syncing backup to cloud: $backup_id"
    
    local cloud_providers=$(jq -r '.cloud_providers | to_entries[] | select(.value.enabled == true) | .key' "$BACKUP_CONFIG_DIR/backup_config.json")
    
    for provider in $cloud_providers; do
        log_info "Syncing to $provider..."
        
        case "$provider" in
            dropbox|google_drive)
                local remote_path=$(jq -r ".cloud_providers.$provider.remote_path" "$BACKUP_CONFIG_DIR/backup_config.json")
                local remote_file="${remote_path}${backup_set}/$(basename "$backup_file")"
                
                if command -v rclone >/dev/null 2>&1; then
                    if rclone copy "$backup_file" "$remote_path${backup_set}/" --progress; then
                        log_success "Synced to $provider"
                        record_cloud_sync "$backup_id" "$provider" "success"
                    else
                        log_error "Failed to sync to $provider"
                        record_cloud_sync "$backup_id" "$provider" "failed"
                    fi
                else
                    log_warning "rclone not installed - skipping cloud sync"
                fi
                ;;
                
            aws_s3)
                local bucket=$(jq -r ".cloud_providers.aws_s3.bucket" "$BACKUP_CONFIG_DIR/backup_config.json")
                local storage_class=$(jq -r ".cloud_providers.aws_s3.storage_class" "$BACKUP_CONFIG_DIR/backup_config.json")
                
                if command -v aws >/dev/null 2>&1; then
                    if aws s3 cp "$backup_file" "s3://$bucket/$backup_set/" --storage-class "$storage_class"; then
                        log_success "Synced to AWS S3"
                        record_cloud_sync "$backup_id" "aws_s3" "success"
                    else
                        log_error "Failed to sync to AWS S3"
                        record_cloud_sync "$backup_id" "aws_s3" "failed"
                    fi
                else
                    log_warning "AWS CLI not installed - skipping S3 sync"
                fi
                ;;
        esac
    done
}

# Record cloud sync result
record_cloud_sync() {
    local backup_id="$1"
    local provider="$2"
    local status="$3"
    
    # This would be recorded in database
    log_debug "Cloud sync: $backup_id -> $provider: $status"
}

# Clean up old backups based on retention policy
cleanup_old_backups() {
    local backup_set="$1"
    
    log_info "Cleaning up old backups for: $backup_set"
    
    # Load retention policy
    local retention_daily=$(jq -r ".backup_sets.$backup_set.retention_policy.daily // 7" "$BACKUP_CONFIG_DIR/backup_config.json")
    local retention_weekly=$(jq -r ".backup_sets.$backup_set.retention_policy.weekly // 4" "$BACKUP_CONFIG_DIR/backup_config.json")
    local retention_monthly=$(jq -r ".backup_sets.$backup_set.retention_policy.monthly // 12" "$BACKUP_CONFIG_DIR/backup_config.json")
    
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    
    # Get backups to delete based on retention policy
    local backups_to_delete=$(sqlite3 "$db_file" << EOF
WITH ranked_backups AS (
    SELECT 
        backup_id,
        destination_path,
        start_time,
        ROW_NUMBER() OVER (
            PARTITION BY DATE(start_time)
            ORDER BY start_time DESC
        ) as daily_rank,
        ROW_NUMBER() OVER (
            PARTITION BY strftime('%Y-%W', start_time)
            ORDER BY start_time DESC
        ) as weekly_rank,
        ROW_NUMBER() OVER (
            PARTITION BY strftime('%Y-%m', start_time)
            ORDER BY start_time DESC
        ) as monthly_rank
    FROM backups
    WHERE backup_set = '$backup_set'
    AND status = 'completed'
)
SELECT backup_id, destination_path
FROM ranked_backups
WHERE NOT (
    (daily_rank = 1 AND julianday('now') - julianday(start_time) <= $retention_daily)
    OR (weekly_rank = 1 AND julianday('now') - julianday(start_time) <= $retention_weekly * 7)
    OR (monthly_rank = 1 AND julianday('now') - julianday(start_time) <= $retention_monthly * 30)
)
AND julianday('now') - julianday(start_time) > $retention_daily;
EOF
)
    
    # Delete old backups
    echo "$backups_to_delete" | while IFS='|' read -r backup_id backup_path; do
        if [ -n "$backup_id" ] && [ -n "$backup_path" ]; then
            log_info "Deleting old backup: $backup_id"
            
            # Remove file
            if [ -f "$backup_path" ]; then
                rm -f "$backup_path"
            fi
            
            # Mark as deleted in database
            sqlite3 "$db_file" "UPDATE backups SET status = 'deleted' WHERE backup_id = '$backup_id';"
        fi
    done
    
    log_success "Cleanup completed for $backup_set"
}

# Update backup metrics
update_backup_metrics() {
    local status="$1"
    local size="$2"
    local start_time="$3"
    local end_time="$4"
    
    # Load current metrics
    local metrics=$(cat "$BACKUP_METRICS_FILE")
    
    # Update counters
    metrics=$(echo "$metrics" | jq ".total_backups += 1")
    
    if [ "$status" = "success" ]; then
        metrics=$(echo "$metrics" | jq ".successful_backups += 1")
        metrics=$(echo "$metrics" | jq ".last_successful_backup = \"$(date -Iseconds)\"")
        metrics=$(echo "$metrics" | jq ".total_size_bytes += $size")
        
        # Calculate backup duration
        local duration=$(( $(date -d "$end_time" +%s) - $(date -d "$start_time" +%s) ))
        local total_backups=$(echo "$metrics" | jq -r '.total_backups')
        local avg_time=$(echo "$metrics" | jq -r '.average_backup_time')
        local new_avg=$(( (avg_time * (total_backups - 1) + duration) / total_backups ))
        metrics=$(echo "$metrics" | jq ".average_backup_time = $new_avg")
    else
        metrics=$(echo "$metrics" | jq ".failed_backups += 1")
    fi
    
    # Calculate success rates
    local successful=$(echo "$metrics" | jq -r '.successful_backups')
    local total=$(echo "$metrics" | jq -r '.total_backups')
    if [ "$total" -gt 0 ]; then
        local success_rate=$(( (successful * 100) / total ))
        metrics=$(echo "$metrics" | jq ".validation_success_rate = $success_rate")
    fi
    
    # Save updated metrics
    echo "$metrics" > "$BACKUP_METRICS_FILE"
}

# Set up backup schedules in cron
setup_backup_schedules() {
    log_info "Setting up backup schedules..."
    
    local schedules=$(jq -r '.schedules | to_entries[] | select(.value.enabled == true) | .key' "$BACKUP_CONFIG_DIR/backup_config.json")
    
    # Create cron entries
    local cron_file="/tmp/bill_sloth_backup_cron"
    crontab -l 2>/dev/null | grep -v "bill-sloth.*backup" > "$cron_file" || true
    
    for schedule in $schedules; do
        local backup_set=$(jq -r ".schedules.$schedule.backup_set" "$BACKUP_CONFIG_DIR/backup_config.json")
        local backup_type=$(jq -r ".schedules.$schedule.type" "$BACKUP_CONFIG_DIR/backup_config.json")
        local cron_expr=$(jq -r ".schedules.$schedule.cron" "$BACKUP_CONFIG_DIR/backup_config.json")
        local description=$(jq -r ".schedules.$schedule.description" "$BACKUP_CONFIG_DIR/backup_config.json")
        
        # Add cron entry
        echo "# $description" >> "$cron_file"
        echo "$cron_expr $SCRIPT_DIR/backup_management_enhanced.sh scheduled_backup '$schedule' >> $BACKUP_LOGS_DIR/cron.log 2>&1" >> "$cron_file"
        
        log_info "Scheduled: $schedule - $description"
    done
    
    # Install new crontab
    crontab "$cron_file"
    rm -f "$cron_file"
    
    log_success "Backup schedules configured"
}

# Run scheduled backup
scheduled_backup() {
    local schedule_name="$1"
    
    log_info "Running scheduled backup: $schedule_name"
    
    # Load schedule configuration
    local backup_set=$(jq -r ".schedules.$schedule_name.backup_set" "$BACKUP_CONFIG_DIR/backup_config.json")
    local backup_type=$(jq -r ".schedules.$schedule_name.type" "$BACKUP_CONFIG_DIR/backup_config.json")
    
    # Update last run time
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    sqlite3 "$db_file" "INSERT OR REPLACE INTO backup_schedules 
                        (schedule_name, backup_set, backup_type, cron_expression, last_run)
                        VALUES ('$schedule_name', '$backup_set', '$backup_type', 
                                '$(jq -r ".schedules.$schedule_name.cron" "$BACKUP_CONFIG_DIR/backup_config.json")',
                                '$(date -Iseconds)');"
    
    # Run backup
    create_backup_enhanced "$backup_set" "$backup_type"
}

# Restore backup
restore_backup_enhanced() {
    local backup_id="$1"
    local restore_path="${2:-/tmp/restore_$$}"
    
    log_info "Restoring backup: $backup_id"
    
    local db_file="$BACKUP_CONFIG_DIR/backup_history.db"
    
    # Get backup information
    local backup_info=$(sqlite3 "$db_file" -json "SELECT * FROM backups WHERE backup_id = '$backup_id' LIMIT 1;" | jq -r '.[0]')
    
    if [ -z "$backup_info" ] || [ "$backup_info" = "null" ]; then
        log_error "Backup not found: $backup_id"
        return 1
    fi
    
    local backup_file=$(echo "$backup_info" | jq -r '.destination_path')
    local backup_set=$(echo "$backup_info" | jq -r '.backup_set')
    local checksum=$(echo "$backup_info" | jq -r '.checksum')
    
    # Verify backup file exists
    if [ ! -f "$backup_file" ]; then
        log_error "Backup file not found: $backup_file"
        return 1
    fi
    
    # Validate checksum
    log_info "Validating backup integrity..."
    local actual_checksum=$(sha256sum "$backup_file" | cut -d' ' -f1)
    if [ "$actual_checksum" != "$checksum" ]; then
        log_error "Checksum validation failed!"
        return 1
    fi
    
    # Create restore directory
    mkdir -p "$restore_path"
    
    # Decrypt if needed
    local working_file="$backup_file"
    if [[ "$backup_file" =~ \.enc$ ]]; then
        log_info "Decrypting backup..."
        local decrypted_file="/tmp/restore_${backup_id}.tar"
        local key_file=$(jq -r ".backup_sets.${backup_set}.encryption.key_file // \"~/.bill-sloth/backups/config/encryption.key\"" "$BACKUP_CONFIG_DIR/backup_config.json")
        key_file=$(eval echo "$key_file")
        
        if openssl enc -aes-256-cbc -d -pbkdf2 -in "$backup_file" -out "$decrypted_file" -pass file:"$key_file"; then
            working_file="$decrypted_file"
        else
            log_error "Decryption failed"
            return 1
        fi
    fi
    
    # Extract backup
    log_info "Extracting backup to: $restore_path"
    
    local extract_cmd="tar"
    case "$working_file" in
        *.tar.gz|*.tgz) extract_cmd="$extract_cmd -xzf" ;;
        *.tar.bz2) extract_cmd="$extract_cmd -xjf" ;;
        *.tar.xz) extract_cmd="$extract_cmd -xJf" ;;
        *.tar.zst) extract_cmd="$extract_cmd --zstd -xf" ;;
        *.tar) extract_cmd="$extract_cmd -xf" ;;
    esac
    
    if $extract_cmd "$working_file" -C "$restore_path"; then
        log_success "Backup restored successfully to: $restore_path"
        
        # Clean up temporary files
        if [ "$working_file" != "$backup_file" ]; then
            rm -f "$working_file"
        fi
        
        # Log restore operation
        sqlite3 "$db_file" "INSERT INTO backup_validations 
                           (backup_id, validation_type, validation_time, result, details)
                           VALUES ('$backup_id', 'restore', '$(date -Iseconds)', 'success', 
                                   'Restored to $restore_path');"
        
        return 0
    else
        log_error "Extraction failed"
        return 1
    fi
}

# Get backup status report
get_backup_status() {
    echo "📊 BACKUP SYSTEM STATUS"
    echo "======================"
    echo ""
    
    # Load metrics
    local metrics=$(cat "$BACKUP_METRICS_FILE")
    
    echo "📈 Overall Statistics:"
    echo "Total Backups: $(echo "$metrics" | jq -r '.total_backups')"
    echo "Successful: $(echo "$metrics" | jq -r '.successful_backups')"
    echo "Failed: $(echo "$metrics" | jq -r '.failed_backups')"
    echo "Success Rate: $(echo "$metrics" | jq -r '.validation_success_rate')%"
    echo "Total Size: $(echo "$metrics" | jq -r '.total_size_bytes' | numfmt --to=iec-i --suffix=B)"
    echo "Avg Backup Time: $(echo "$metrics" | jq -r '.average_backup_time')s"
    echo "Last Success: $(echo "$metrics" | jq -r '.last_successful_backup // "Never"')"
    echo ""
    
    # Recent backups
    echo "📅 Recent Backups:"
    sqlite3 "$BACKUP_CONFIG_DIR/backup_history.db" -column -header << 'EOF'
SELECT 
    backup_id,
    backup_set,
    backup_type,
    status,
    printf("%.2f MB", size_bytes / 1024.0 / 1024.0) as size,
    datetime(start_time) as started
FROM backups
ORDER BY start_time DESC
LIMIT 10;
EOF
    echo ""
    
    # Active schedules
    echo "⏰ Active Schedules:"
    local schedules=$(jq -r '.schedules | to_entries[] | select(.value.enabled == true) | 
                             "\(.key): \(.value.description) [\(.value.cron)]"' "$BACKUP_CONFIG_DIR/backup_config.json")
    echo "$schedules"
    echo ""
    
    # Storage usage
    echo "💾 Storage Usage:"
    du -sh "$BACKUP_BASE_DIR/local"/* 2>/dev/null | sort -hr | head -5
}

# Notification functions
notify_backup_success() {
    local backup_id="$1"
    local backup_set="$2"
    local size="$3"
    
    local email_on_success=$(jq -r '.notification_settings.email_on_success // false' "$BACKUP_CONFIG_DIR/backup_config.json")
    
    if [ "$email_on_success" = "true" ]; then
        notify_info "Backup Success" "Backup completed: $backup_id ($backup_set, $(numfmt --to=iec-i --suffix=B $size))"
    fi
}

notify_backup_failure() {
    local backup_id="$1"
    local backup_set="$2"
    local error="$3"
    
    local email_on_failure=$(jq -r '.notification_settings.email_on_failure // true' "$BACKUP_CONFIG_DIR/backup_config.json")
    
    if [ "$email_on_failure" = "true" ]; then
        notify_error "Backup Failed" "Backup failed: $backup_id ($backup_set)\nError: $error"
    fi
}

# Export functions
export -f create_backup_enhanced restore_backup_enhanced get_backup_status
export -f validate_backup cleanup_old_backups scheduled_backup
export -f init_backup_system_enhanced setup_backup_schedules

# Initialize on first source
if [ ! -f "$BACKUP_CONFIG_DIR/.backup-enhanced-initialized" ]; then
    init_backup_system_enhanced
    touch "$BACKUP_CONFIG_DIR/.backup-enhanced-initialized"
fi

# Main function for testing
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    case "${1:-}" in
        create) create_backup_enhanced "${2:-bill_critical}" "${3:-incremental}" ;;
        restore) restore_backup_enhanced "$2" "${3:-}" ;;
        status) get_backup_status ;;
        scheduled_backup) scheduled_backup "$2" ;;
        setup-schedules) setup_backup_schedules ;;
        validate) validate_backup "$2" "$3" "$4" ;;
        *) 
            echo "Usage: $0 {create|restore|status|scheduled_backup|setup-schedules|validate}"
            echo ""
            echo "Commands:"
            echo "  create <backup_set> [type]  - Create a backup"
            echo "  restore <backup_id> [path]  - Restore a backup"
            echo "  status                      - Show backup status"
            echo "  scheduled_backup <name>     - Run scheduled backup"
            echo "  setup-schedules            - Configure cron schedules"
            echo "  validate <id> <file> <sum> - Validate backup"
            ;;
    esac
fi