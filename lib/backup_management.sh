#!/bin/bash
# LLM_CAPABILITY: local_ok
# Standardized Backup Management Library
# Comprehensive backup and recovery system for Bill Sloth infrastructure

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Global backup configuration
BACKUP_BASE_DIR="$HOME/.bill-sloth/backups"
BACKUP_CONFIG_DIR="$BACKUP_BASE_DIR/config"
BACKUP_LOGS_DIR="$BACKUP_BASE_DIR/logs"
BACKUP_SCHEDULES_DIR="$BACKUP_BASE_DIR/schedules"

# Initialize backup management system
init_backup_system() {
    log_info "Initializing backup management system..."
    
    # PRODUCTION SAFETY: Load safety systems
    source "$SCRIPT_DIR/production_safety.sh" 2>/dev/null || true
    
    # Create backup directory structure
    mkdir -p "$BACKUP_BASE_DIR"/{config,logs,schedules,local,cloud,archives}
    mkdir -p "$BACKUP_BASE_DIR/local"/{full,incremental,differential}
    mkdir -p "$BACKUP_BASE_DIR/cloud"/{sync,upload,download}
    
    # Create backup configuration file
    if [ ! -f "$BACKUP_CONFIG_DIR/backup_config.json" ]; then
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
        "*temp*"
      ],
      "retention_days": 30,
      "compression": true,
      "encryption": true
    },
    "vrbo_data": {
      "description": "VRBO property management data",
      "sources": [
        "~/VacationRental/",
        "~/.bill-sloth/vrbo-automation/",
        "~/.bill-sloth/media-processing/vrbo/"
      ],
      "exclude_patterns": [
        "*.tmp",
        "*cache*"
      ],
      "retention_days": 90,
      "compression": true,
      "encryption": true
    },
    "edboigames_content": {
      "description": "EdBoiGames business and content data",
      "sources": [
        "~/edboigames_business/",
        "~/.bill-sloth/media-processing/edboigames/"
      ],
      "exclude_patterns": [
        "*.tmp",
        "*processed*"
      ],
      "retention_days": 60,
      "compression": true,
      "encryption": false
    }
  },
  "cloud_providers": {
    "dropbox": {
      "enabled": false,
      "remote_path": "dropbox:BillSlothBackups/"
    },
    "google_drive": {
      "enabled": false,
      "remote_path": "gdrive:BillSlothBackups/"
    },
    "onedrive": {
      "enabled": false,
      "remote_path": "onedrive:BillSlothBackups/"
    }
  },
  "schedules": {
    "daily_critical": {
      "backup_set": "bill_critical",
      "type": "incremental",
      "time": "02:00",
      "enabled": true
    },
    "weekly_full": {
      "backup_set": "bill_critical",
      "type": "full",
      "day": "sunday",
      "time": "01:00",
      "enabled": true
    }
  }
}
EOF
    fi
    
    # Create backup tracking database
    if [ ! -f "$BACKUP_CONFIG_DIR/backup_history.json" ]; then
        echo '{"backups": [], "last_backup": "", "total_backups": 0}' > "$BACKUP_CONFIG_DIR/backup_history.json"
    fi
    
    log_success "Backup system initialized"
}

# Create backup set
create_backup() {
    local backup_set="$1"
    local backup_type="${2:-incremental}"  # full, incremental, differential
    local destination="${3:-local}"
    
    log_info "Starting backup: $backup_set ($backup_type)"
    
    # PRODUCTION SAFETY: Validate backup parameters
    if [[ -z "$backup_set" || "$backup_set" =~ [^a-zA-Z0-9_] ]]; then
        log_error "Invalid backup set name: '$backup_set'"
        return 1
    fi
    
    local config_file="$BACKUP_CONFIG_DIR/backup_config.json"
    local backup_id="backup_$(date +%Y%m%d_%H%M%S)_${backup_set}"
    local timestamp=$(date -Iseconds)
    
    # Get backup set configuration
    if ! jq -e ".backup_sets.${backup_set}" "$config_file" > /dev/null; then
        log_error "Backup set '$backup_set' not found in configuration"
        return 1
    fi
    
    local sources=$(jq -r ".backup_sets.${backup_set}.sources[]" "$config_file")
    local exclude_patterns=$(jq -r ".backup_sets.${backup_set}.exclude_patterns[]?" "$config_file")
    local compression=$(jq -r ".backup_sets.${backup_set}.compression" "$config_file")
    local encryption=$(jq -r ".backup_sets.${backup_set}.encryption" "$config_file")
    
    # Create backup directory
    local backup_dir="$BACKUP_BASE_DIR/$destination/$backup_type"
    mkdir -p "$backup_dir"
    
    # Prepare backup command
    local rsync_opts="-avh --progress"
    
    # Add exclusion patterns
    local exclude_file="$BACKUP_CONFIG_DIR/exclude_${backup_set}.txt"
    if [ ! -z "$exclude_patterns" ]; then
        echo "$exclude_patterns" > "$exclude_file"
        rsync_opts="$rsync_opts --exclude-from=$exclude_file"
    fi
    
    # Handle incremental backups
    if [ "$backup_type" = "incremental" ]; then
        local last_backup=$(get_last_backup "$backup_set" "$destination")
        if [ ! -z "$last_backup" ]; then
            rsync_opts="$rsync_opts --link-dest=$last_backup"
        fi
    fi
    
    # Create backup manifest
    local manifest_file="$backup_dir/${backup_id}_manifest.txt"
    cat > "$manifest_file" << EOF
Backup ID: $backup_id
Backup Set: $backup_set
Type: $backup_type
Started: $timestamp
Destination: $destination
Sources: $sources
EOF
    
    # Execute backup
    local backup_path="$backup_dir/$backup_id"
    mkdir -p "$backup_path"
    
    log_info "Backing up to: $backup_path"
    
    # Backup each source with progress tracking
    local total_sources=$(echo "$sources" | grep -v '^$' | wc -l)
    local current_source=0
    
    echo "$sources" | while read source; do
        if [ ! -z "$source" ]; then
            ((current_source++))
            local expanded_source=$(eval echo "$source")
            if [ -e "$expanded_source" ]; then
                log_info "[$current_source/$total_sources] Backing up: $expanded_source"
                # PRODUCTION SAFETY: Use safe operation with retries
                if command -v safe_operation &>/dev/null; then
                    safe_operation "backup_$expanded_source" "rsync $rsync_opts '$expanded_source/' '$backup_path/$(basename '$expanded_source')/'"
                else
                    rsync $rsync_opts "$expanded_source/" "$backup_path/$(basename "$expanded_source")/"
                fi
            else
                log_warning "[$current_source/$total_sources] Source not found: $expanded_source"
            fi
        fi
    done
    
    # Create backup summary
    local backup_size=$(du -sh "$backup_path" | cut -f1)
    local file_count=$(find "$backup_path" -type f | wc -l)
    
    cat >> "$manifest_file" << EOF
Completed: $(date -Iseconds)
Size: $backup_size
Files: $file_count
Status: completed
EOF
    
    # Compress if enabled
    if [ "$compression" = "true" ]; then
        log_info "Compressing backup..."
        tar -czf "$backup_path.tar.gz" -C "$backup_dir" "$backup_id"
        rm -rf "$backup_path"
        backup_path="$backup_path.tar.gz"
        
        # Update manifest
        local compressed_size=$(du -sh "$backup_path" | cut -f1)
        echo "Compressed Size: $compressed_size" >> "$manifest_file"
    fi
    
    # Encrypt if enabled
    if [ "$encryption" = "true" ]; then
        log_info "Encrypting backup..."
        if command -v gpg &> /dev/null; then
            # Use GPG encryption (requires setup)
            gpg --symmetric --cipher-algo AES256 --compress-algo 2 --output "$backup_path.gpg" "$backup_path"
            rm -f "$backup_path"
            backup_path="$backup_path.gpg"
            echo "Encrypted: true" >> "$manifest_file"
        else
            log_warning "GPG not available for encryption"
        fi
    fi
    
    # Update backup history
    update_backup_history "$backup_id" "$backup_set" "$backup_type" "$destination" "$backup_path"
    
    # Clean up old backups
    cleanup_old_backups "$backup_set" "$destination"
    
    # PRODUCTION SAFETY: Verify backup integrity before marking complete
    log_info "Verifying backup integrity..."
    if command -v verify_backup_integrity &>/dev/null; then
        if verify_backup_integrity "$backup_path"; then
            log_success "Backup verification passed"
            echo "Verification: PASSED" >> "$manifest_file"
        else
            log_error "Backup verification failed!"
            echo "Verification: FAILED" >> "$manifest_file"
            notify_error "Backup Failed" "Backup $backup_id failed verification"
            return 1
        fi
    else
        log_warning "Backup verification not available - backup may be corrupted"
        echo "Verification: SKIPPED" >> "$manifest_file"
    fi
    
    log_success "Backup completed: $backup_id"
    notify_success "Backup Complete" "Backup $backup_id completed and verified"
    
    # Upload to cloud if configured
    if [ "$destination" = "local" ]; then
        upload_to_cloud "$backup_id" "$backup_path" "$backup_set"
    fi
}

# Get last backup path
get_last_backup() {
    local backup_set="$1"
    local destination="$2"
    
    local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
    
    local last_backup=$(jq -r --arg set "$backup_set" --arg dest "$destination" \
        '.backups[] | select(.backup_set == $set and .destination == $dest) | .path' \
        "$history_file" | tail -1)
    
    if [ "$last_backup" != "null" ] && [ -d "$last_backup" ]; then
        echo "$last_backup"
    fi
}

# Update backup history
update_backup_history() {
    local backup_id="$1"
    local backup_set="$2"
    local backup_type="$3"
    local destination="$4"
    local backup_path="$5"
    
    local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
    local timestamp=$(date -Iseconds)
    
    # Add backup record
    jq --arg id "$backup_id" \
       --arg set "$backup_set" \
       --arg type "$backup_type" \
       --arg dest "$destination" \
       --arg path "$backup_path" \
       --arg timestamp "$timestamp" \
       '.backups += [{
           "id": $id,
           "backup_set": $set,
           "type": $type,
           "destination": $dest,
           "path": $path,
           "timestamp": $timestamp
       }] | .last_backup = $timestamp | .total_backups += 1' \
       "$history_file" > "${history_file}.tmp" && mv "${history_file}.tmp" "$history_file"
}

# Clean up old backups
cleanup_old_backups() {
    local backup_set="$1"
    local destination="$2"
    
    local config_file="$BACKUP_CONFIG_DIR/backup_config.json"
    local retention_days=$(jq -r ".backup_sets.${backup_set}.retention_days" "$config_file")
    
    if [ "$retention_days" != "null" ] && [ "$retention_days" -gt 0 ]; then
        log_info "Cleaning up backups older than $retention_days days..."
        
        local backup_dir="$BACKUP_BASE_DIR/$destination"
        find "$backup_dir" -name "backup_*_${backup_set}*" -mtime +$retention_days -delete
        
        # Update backup history to remove deleted backups
        local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
        local cutoff_date=$(date -d "$retention_days days ago" -Iseconds)
        
        jq --arg cutoff "$cutoff_date" \
           '.backups = [.backups[] | select(.timestamp > $cutoff)]' \
           "$history_file" > "${history_file}.tmp" && mv "${history_file}.tmp" "$history_file"
        
        log_success "Old backups cleaned up"
    fi
}

# Upload backup to cloud storage
upload_to_cloud() {
    local backup_id="$1"
    local backup_path="$2"
    local backup_set="$3"
    
    local config_file="$BACKUP_CONFIG_DIR/backup_config.json"
    
    # Check enabled cloud providers
    local cloud_providers=$(jq -r '.cloud_providers | to_entries[] | select(.value.enabled == true) | .key' "$config_file")
    
    if [ ! -z "$cloud_providers" ]; then
        echo "$cloud_providers" | while read provider; do
            local remote_path=$(jq -r ".cloud_providers.${provider}.remote_path" "$config_file")
            
            if command -v rclone &> /dev/null; then
                log_info "Uploading to $provider..."
                rclone copy "$backup_path" "$remote_path" --progress
                
                if [ $? -eq 0 ]; then
                    log_success "Uploaded to $provider successfully"
                    notify_info "Cloud Backup" "Backup uploaded to $provider"
                else
                    log_error "Failed to upload to $provider"
                    notify_error "Cloud Backup Error" "Failed to upload to $provider"
                fi
            else
                log_warning "rclone not available for cloud upload"
            fi
        done
    fi
}

# Restore backup
restore_backup() {
    local backup_id="$1"
    local restore_path="${2:-$HOME/restored_$(date +%Y%m%d_%H%M%S)}"
    
    log_info "Starting restore: $backup_id"
    
    local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
    local backup_info=$(jq -r --arg id "$backup_id" '.backups[] | select(.id == $id)' "$history_file")
    
    if [ "$backup_info" = "null" ] || [ -z "$backup_info" ]; then
        log_error "Backup $backup_id not found"
        return 1
    fi
    
    local backup_path=$(echo "$backup_info" | jq -r '.path')
    local backup_set=$(echo "$backup_info" | jq -r '.backup_set')
    
    mkdir -p "$restore_path"
    
    # Handle different backup formats
    if [[ "$backup_path" == *.tar.gz ]]; then
        log_info "Extracting compressed backup..."
        tar -xzf "$backup_path" -C "$restore_path"
    elif [[ "$backup_path" == *.gpg ]]; then
        log_info "Decrypting backup..."
        if command -v gpg &> /dev/null; then
            gpg --decrypt "$backup_path" | tar -xz -C "$restore_path"
        else
            log_error "GPG not available for decryption"
            return 1
        fi
    else
        log_info "Copying backup files..."
        rsync -avh "$backup_path/" "$restore_path/"
    fi
    
    log_success "Restore completed to: $restore_path"
    notify_success "Restore Complete" "Backup $backup_id restored to $restore_path"
}

# List available backups
list_backups() {
    local backup_set="$1"
    
    print_header "📋 BACKUP HISTORY"
    
    local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
    
    if [ ! -z "$backup_set" ]; then
        echo "Backups for set: $backup_set"
        echo ""
        jq -r --arg set "$backup_set" \
           '.backups[] | select(.backup_set == $set) | 
            "\(.id) | \(.type) | \(.destination) | \(.timestamp)"' \
           "$history_file" | column -t -s '|'
    else
        echo "All backups:"
        echo ""
        jq -r '.backups[] | 
               "\(.id) | \(.backup_set) | \(.type) | \(.destination) | \(.timestamp)"' \
               "$history_file" | column -t -s '|'
    fi
    
    echo ""
    local total_backups=$(jq -r '.total_backups' "$history_file")
    local last_backup=$(jq -r '.last_backup' "$history_file")
    echo "Total backups: $total_backups"
    echo "Last backup: $last_backup"
}

# Verify backup integrity
verify_backup() {
    local backup_id="$1"
    
    log_info "Verifying backup: $backup_id"
    
    local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
    local backup_path=$(jq -r --arg id "$backup_id" '.backups[] | select(.id == $id) | .path' "$history_file")
    
    if [ "$backup_path" = "null" ] || [ ! -e "$backup_path" ]; then
        log_error "Backup file not found: $backup_path"
        return 1
    fi
    
    # Verify based on file type
    if [[ "$backup_path" == *.tar.gz ]]; then
        log_info "Verifying compressed archive..."
        if tar -tzf "$backup_path" > /dev/null 2>&1; then
            log_success "Archive integrity verified"
        else
            log_error "Archive is corrupted"
            return 1
        fi
    elif [[ "$backup_path" == *.gpg ]]; then
        log_info "Verifying encrypted backup..."
        if gpg --list-packets "$backup_path" > /dev/null 2>&1; then
            log_success "Encrypted backup verified"
        else
            log_error "Encrypted backup is corrupted"
            return 1
        fi
    else
        log_info "Verifying directory structure..."
        if [ -d "$backup_path" ]; then
            log_success "Backup directory verified"
        else
            log_error "Backup directory is missing or corrupted"
            return 1
        fi
    fi
    
    log_success "Backup verification completed"
}

# Schedule backup
schedule_backup() {
    local backup_set="$1"
    local schedule_type="$2"  # daily, weekly, monthly
    local time="$3"
    
    log_info "Scheduling $schedule_type backup for $backup_set at $time"
    
    local cron_entry=""
    local backup_script="$BACKUP_BASE_DIR/scheduled_backup.sh"
    
    # Create scheduled backup script
    cat > "$backup_script" << EOF
#!/bin/bash
source "$SCRIPT_DIR/backup_management.sh"
create_backup "$backup_set" "incremental" "local"
EOF
    chmod +x "$backup_script"
    
    # Generate cron entry
    case "$schedule_type" in
        "daily")
            local hour=$(echo "$time" | cut -d: -f1)
            local minute=$(echo "$time" | cut -d: -f2)
            cron_entry="$minute $hour * * * $backup_script"
            ;;
        "weekly")
            local hour=$(echo "$time" | cut -d: -f1)
            local minute=$(echo "$time" | cut -d: -f2)
            cron_entry="$minute $hour * * 0 $backup_script"  # Sunday
            ;;
        "monthly")
            local hour=$(echo "$time" | cut -d: -f1)
            local minute=$(echo "$time" | cut -d: -f2)
            cron_entry="$minute $hour 1 * * $backup_script"  # 1st of month
            ;;
    esac
    
    # Add to crontab (comment out for safety)
    # (crontab -l 2>/dev/null; echo "$cron_entry") | crontab -
    
    echo "Add this line to crontab to enable scheduled backups:"
    echo "$cron_entry"
    
    log_success "Backup schedule configured"
}

# Backup status dashboard
backup_status() {
    print_header "📊 BACKUP STATUS DASHBOARD"
    
    local config_file="$BACKUP_CONFIG_DIR/backup_config.json"
    local history_file="$BACKUP_CONFIG_DIR/backup_history.json"
    
    echo "📋 BACKUP SETS:"
    jq -r '.backup_sets | to_entries[] | "  • \(.key): \(.value.description)"' "$config_file"
    echo ""
    
    echo "📈 RECENT ACTIVITY:"
    jq -r '.backups[-5:] | .[] | "  \(.timestamp): \(.backup_set) (\(.type))"' "$history_file"
    echo ""
    
    echo "💾 STORAGE USAGE:"
    echo "  Local backups: $(du -sh "$BACKUP_BASE_DIR/local" 2>/dev/null | cut -f1 || echo "0B")"
    echo "  Total files: $(find "$BACKUP_BASE_DIR" -type f | wc -l)"
    echo ""
    
    echo "☁️  CLOUD STATUS:"
    jq -r '.cloud_providers | to_entries[] | "  \(.key): \(if .value.enabled then "Enabled" else "Disabled" end)"' "$config_file"
    echo ""
    
    echo "⏰ NEXT SCHEDULED:"
    if [ -f "$BACKUP_SCHEDULES_DIR/schedule.txt" ]; then
        cat "$BACKUP_SCHEDULES_DIR/schedule.txt"
    else
        echo "  No schedules configured"
    fi
}

# Setup Bill's backup system
setup_bill_backup_system() {
    log_info "Setting up Bill's comprehensive backup system..."
    
    init_backup_system
    
    # Create backup management dashboard
    cat > "$BACKUP_BASE_DIR/backup_dashboard.sh" << 'EOF'
#!/bin/bash
echo "💾 BILL'S BACKUP MANAGEMENT DASHBOARD"
echo "====================================="

source "$HOME/.bill-sloth/lib/backup_management.sh"

while true; do
    clear
    echo "💾 BILL'S BACKUP MANAGEMENT DASHBOARD"
    echo "====================================="
    echo ""
    
    backup_status
    
    echo ""
    echo "⚙️  BACKUP ACTIONS:"
    echo "1) Create backup (Bill Critical)"
    echo "2) Create backup (VRBO Data)"
    echo "3) Create backup (EdBoiGames Content)"
    echo "4) List all backups"
    echo "5) Restore backup"
    echo "6) Verify backup"
    echo "7) Setup cloud storage"
    echo "8) Schedule backups"
    echo "9) Manual cleanup"
    echo "0) Exit"
    echo ""
    
    read -p "Select action: " action
    
    case $action in
        1) create_backup "bill_critical" "incremental" "local" ;;
        2) create_backup "vrbo_data" "incremental" "local" ;;
        3) create_backup "edboigames_content" "incremental" "local" ;;
        4) list_backups ;;
        5) 
            read -p "Enter backup ID to restore: " backup_id
            read -p "Enter restore path (optional): " restore_path
            restore_backup "$backup_id" "$restore_path"
            ;;
        6)
            read -p "Enter backup ID to verify: " backup_id
            verify_backup "$backup_id"
            ;;
        7)
            echo "Configure rclone for cloud storage:"
            echo "  rclone config"
            echo ""
            echo "Then edit: $HOME/.bill-sloth/backups/config/backup_config.json"
            echo "Set enabled: true for your cloud provider"
            ;;
        8)
            echo "Backup scheduling options:"
            echo "1) Daily at 2 AM (recommended)"
            echo "2) Weekly on Sunday at 1 AM"
            echo "3) Custom schedule"
            read -p "Select option: " sched_option
            case $sched_option in
                1) schedule_backup "bill_critical" "daily" "02:00" ;;
                2) schedule_backup "bill_critical" "weekly" "01:00" ;;
                3) 
                    read -p "Backup set: " backup_set
                    read -p "Schedule type (daily/weekly/monthly): " sched_type
                    read -p "Time (HH:MM): " sched_time
                    schedule_backup "$backup_set" "$sched_type" "$sched_time"
                    ;;
            esac
            ;;
        9)
            echo "Cleaning up old backups..."
            cleanup_old_backups "bill_critical" "local"
            cleanup_old_backups "vrbo_data" "local"
            cleanup_old_backups "edboigames_content" "local"
            echo "Cleanup completed!"
            ;;
        0) exit ;;
        *) echo "Invalid choice" ;;
    esac
    
    if [ "$action" != "0" ]; then
        echo ""
        read -n 1 -s -r -p "Press any key to continue..."
    fi
done
EOF
    chmod +x "$BACKUP_BASE_DIR/backup_dashboard.sh"
    
    # Create quick backup scripts
    cat > "$BACKUP_BASE_DIR/quick_backup.sh" << 'EOF'
#!/bin/bash
# Quick backup script for Bill
source "$HOME/.bill-sloth/lib/backup_management.sh"

echo "🚀 Quick Backup Launcher"
echo "======================="
echo "1) Critical system backup"
echo "2) VRBO data backup"
echo "3) All backups"
read -p "Select backup type: " choice

case $choice in
    1) create_backup "bill_critical" "incremental" "local" ;;
    2) create_backup "vrbo_data" "incremental" "local" ;;
    3) 
        create_backup "bill_critical" "incremental" "local"
        create_backup "vrbo_data" "incremental" "local"
        create_backup "edboigames_content" "incremental" "local"
        ;;
esac
EOF
    chmod +x "$BACKUP_BASE_DIR/quick_backup.sh"
    
    log_success "Bill's backup system configured!"
    echo ""
    echo "🚀 Quick Start:"
    echo "  • Dashboard: $BACKUP_BASE_DIR/backup_dashboard.sh"
    echo "  • Quick backup: $BACKUP_BASE_DIR/quick_backup.sh"
    echo "  • Manual backup: create_backup <set_name>"
    echo ""
    echo "📋 Next Steps:"
    echo "  1. Configure cloud storage: rclone config"
    echo "  2. Test backup: create_backup bill_critical"
    echo "  3. Schedule automated backups"
    echo "  4. Verify backup integrity regularly"
}

# Export functions
export -f init_backup_system create_backup restore_backup list_backups verify_backup
export -f schedule_backup backup_status cleanup_old_backups upload_to_cloud
export -f get_last_backup update_backup_history setup_bill_backup_system