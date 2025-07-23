#!/bin/bash
# LLM_CAPABILITY: local_ok
# Restic Backup Wrapper for Bill Sloth
# Simplified backup management with pre-configured repositories

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Backup configuration
BACKUP_BASE_DIR="$HOME/.bill-sloth/backups/restic"
BACKUP_CONFIG_FILE="$HOME/.bill-sloth/backups/config/backup_sets.json"
BACKUP_LOG_DIR="$HOME/.bill-sloth/backups/logs"

# Pre-defined backup sets for Bill
declare -A BACKUP_SETS=(
    ["bill_critical"]="$HOME/.bill-sloth|$HOME/Documents|$HOME/.bashrc|$HOME/.config"
    ["vrbo_data"]="$HOME/.bill-sloth/vrbo-automation|$HOME/Documents/VRBO|$HOME/Pictures/Properties"
    ["edboigames_content"]="$HOME/Videos/EdBoiGames|$HOME/Documents/EdBoiGames|$HOME/edboigames_business"
    ["development"]="$HOME/bill*sloth|$HOME/Projects|$HOME/.ssh"
    ["media_archive"]="$HOME/Pictures|$HOME/Videos|$HOME/Music"
)

# Initialize backup system
init_restic_backup() {
    log_info "Initializing restic backup system..."
    
    # Create directories
    mkdir -p "$BACKUP_BASE_DIR" "$BACKUP_LOG_DIR"
    mkdir -p "$HOME/.bill-sloth/backups/config"
    
    # Check if restic is installed
    if ! command -v restic &> /dev/null; then
        log_warning "Restic not installed. Installing..."
        "$SCRIPT_DIR/../setup-scripts/install_restic.sh" || {
            log_error "Failed to install restic"
            return 1
        }
    fi
    
    # Create backup configuration if missing
    if [ ! -f "$BACKUP_CONFIG_FILE" ]; then
        cat > "$BACKUP_CONFIG_FILE" << 'EOF'
{
  "backup_sets": {
    "bill_critical": {
      "description": "Essential Bill Sloth config and documents",
      "paths": ["~/.bill-sloth", "~/Documents", "~/.bashrc", "~/.config"],
      "schedule": "daily",
      "retention": "7d"
    },
    "vrbo_data": {
      "description": "VRBO automation data and property info",
      "paths": ["~/.bill-sloth/vrbo-automation", "~/Documents/VRBO", "~/Pictures/Properties"],
      "schedule": "daily",
      "retention": "30d"
    },
    "edboigames_content": {
      "description": "EdBoiGames videos and business files",
      "paths": ["~/Videos/EdBoiGames", "~/Documents/EdBoiGames", "~/edboigames_business"],
      "schedule": "weekly",
      "retention": "90d"
    }
  },
  "global_excludes": [
    "*.tmp",
    "*.cache",
    "node_modules",
    "__pycache__",
    ".git/objects"
  ]
}
EOF
    fi
    
    log_success "Restic backup system initialized"
}

# Initialize a backup repository
init_backup_repo() {
    local set_name="$1"
    local repo_path="$BACKUP_BASE_DIR/$set_name"
    
    if [ -z "$set_name" ]; then
        log_error "Backup set name required"
        return 1
    fi
    
    # Check if repo already exists
    if [ -d "$repo_path/data" ]; then
        log_info "Repository already initialized: $set_name"
        return 0
    fi
    
    log_info "Initializing backup repository: $set_name"
    
    # Create repo directory
    mkdir -p "$repo_path"
    
    # Generate or retrieve secure password
    local password_file="$HOME/.bill-sloth/backups/.passwords/$set_name.key"
    mkdir -p "$(dirname "$password_file")"
    
    if [ ! -f "$password_file" ]; then
        # Generate secure random password
        openssl rand -base64 32 > "$password_file"
        chmod 600 "$password_file"
        log_info "Generated secure password for backup set: $set_name"
    fi
    
    # Initialize restic repo with secure password
    RESTIC_PASSWORD_FILE="$password_file" restic init --repo "$repo_path" || {
        log_error "Failed to initialize repository"
        return 1
    }
    
    # Create secure hint without exposing actual password
    echo "Password stored securely in: ~/.bill-sloth/backups/.passwords/$set_name.key" > "$repo_path/PASSWORD_HINT.txt"
    chmod 600 "$repo_path/PASSWORD_HINT.txt"
    
    log_success "Repository initialized: $set_name"
}

# Perform backup
bill_backup() {
    local set_name="${1:-bill_critical}"
    local repo_path="$BACKUP_BASE_DIR/$set_name"
    
    # Initialize if needed
    init_restic_backup
    
    # Check if backup set exists
    if [ -z "${BACKUP_SETS[$set_name]}" ] && [ ! -f "$BACKUP_CONFIG_FILE" ]; then
        log_error "Unknown backup set: $set_name"
        echo "Available sets: ${!BACKUP_SETS[@]}"
        return 1
    fi
    
    # Initialize repo if needed
    if [ ! -d "$repo_path/data" ]; then
        init_backup_repo "$set_name" || return 1
    fi
    
    # Get paths to backup
    local paths="${BACKUP_SETS[$set_name]}"
    if [ -z "$paths" ]; then
        # Try loading from JSON config
        paths=$(jq -r ".backup_sets.\"$set_name\".paths[]?" "$BACKUP_CONFIG_FILE" 2>/dev/null | tr '\n' ' ')
    fi
    
    if [ -z "$paths" ]; then
        log_error "No paths defined for backup set: $set_name"
        return 1
    fi
    
    # Convert paths to array
    IFS='|' read -ra PATHS <<< "$paths"
    
    # Expand paths
    local expanded_paths=()
    for path in "${PATHS[@]}"; do
        # Expand tilde and trim whitespace
        expanded_path=$(eval echo "$path" | xargs)
        if [ -e "$expanded_path" ]; then
            expanded_paths+=("$expanded_path")
        else
            log_warning "Path not found: $expanded_path"
        fi
    done
    
    if [ ${#expanded_paths[@]} -eq 0 ]; then
        log_error "No valid paths to backup"
        return 1
    fi
    
    log_info "Starting backup: $set_name"
    log_info "Backing up: ${expanded_paths[*]}"
    
    # Run backup with progress
    RESTIC_PASSWORD="bill-sloth-backup-$set_name" restic backup \
        --repo "$repo_path" \
        --tag "$set_name" \
        --exclude="*.tmp" \
        --exclude="*.cache" \
        --exclude="node_modules" \
        --exclude="__pycache__" \
        --exclude=".git/objects" \
        "${expanded_paths[@]}" 2>&1 | tee "$BACKUP_LOG_DIR/${set_name}_$(date +%Y%m%d_%H%M%S).log"
    
    if [ ${PIPESTATUS[0]} -eq 0 ]; then
        log_success "Backup completed: $set_name"
        notify_success "Backup Complete" "Successfully backed up $set_name"
        
        # Show snapshot info
        RESTIC_PASSWORD="bill-sloth-backup-$set_name" restic snapshots \
            --repo "$repo_path" \
            --latest 1
            
        # Clean up old snapshots based on retention
        bill_backup_cleanup "$set_name"
    else
        log_error "Backup failed: $set_name"
        notify_error "Backup Failed" "Failed to backup $set_name"
        return 1
    fi
}

# List backups
bill_backup_list() {
    local set_name="${1:-all}"
    
    if [ "$set_name" = "all" ]; then
        echo "📦 Available Backup Sets:"
        echo "========================"
        for set in "${!BACKUP_SETS[@]}"; do
            echo ""
            echo "🔹 $set:"
            bill_backup_list "$set"
        done
    else
        local repo_path="$BACKUP_BASE_DIR/$set_name"
        
        if [ ! -d "$repo_path/data" ]; then
            echo "   ❌ Not initialized"
            return
        fi
        
        echo "   Recent snapshots:"
        RESTIC_PASSWORD="bill-sloth-backup-$set_name" restic snapshots \
            --repo "$repo_path" \
            --latest 5 2>/dev/null | grep -E "^[0-9a-f]{8}" | while read -r line; do
            echo "   $line"
        done
    fi
}

# Restore backup
bill_restore() {
    local set_name="$1"
    local snapshot_id="${2:-latest}"
    local restore_path="${3:-$HOME/restored_$set_name}"
    
    if [ -z "$set_name" ]; then
        log_error "Usage: bill_restore <set_name> [snapshot_id] [restore_path]"
        return 1
    fi
    
    local repo_path="$BACKUP_BASE_DIR/$set_name"
    
    if [ ! -d "$repo_path/data" ]; then
        log_error "Backup set not found: $set_name"
        return 1
    fi
    
    log_info "Restoring $set_name (snapshot: $snapshot_id) to $restore_path"
    
    # Create restore directory
    mkdir -p "$restore_path"
    
    # Restore files
    RESTIC_PASSWORD="bill-sloth-backup-$set_name" restic restore \
        --repo "$repo_path" \
        --target "$restore_path" \
        "$snapshot_id"
    
    if [ $? -eq 0 ]; then
        log_success "Restore completed to: $restore_path"
        echo ""
        echo "📁 Files restored to: $restore_path"
        echo "💡 Review the files and copy what you need back to original locations"
    else
        log_error "Restore failed"
        return 1
    fi
}

# Cleanup old snapshots
bill_backup_cleanup() {
    local set_name="${1:-all}"
    
    if [ "$set_name" = "all" ]; then
        for set in "${!BACKUP_SETS[@]}"; do
            bill_backup_cleanup "$set"
        done
        return
    fi
    
    local repo_path="$BACKUP_BASE_DIR/$set_name"
    
    if [ ! -d "$repo_path/data" ]; then
        return
    fi
    
    log_info "Cleaning up old snapshots: $set_name"
    
    # Keep 7 daily, 4 weekly, 12 monthly snapshots by default
    RESTIC_PASSWORD="bill-sloth-backup-$set_name" restic forget \
        --repo "$repo_path" \
        --keep-daily 7 \
        --keep-weekly 4 \
        --keep-monthly 12 \
        --prune
}

# Quick backup status
bill_backup_status() {
    echo "🔄 BILL SLOTH BACKUP STATUS"
    echo "==========================="
    echo ""
    
    for set in "${!BACKUP_SETS[@]}"; do
        local repo_path="$BACKUP_BASE_DIR/$set"
        
        echo "📦 $set:"
        
        if [ ! -d "$repo_path/data" ]; then
            echo "   ❌ Not initialized"
            continue
        fi
        
        # Get latest snapshot
        local latest=$(RESTIC_PASSWORD="bill-sloth-backup-$set_name" restic snapshots \
            --repo "$repo_path" \
            --latest 1 --json 2>/dev/null | jq -r '.[0].time' 2>/dev/null)
        
        if [ ! -z "$latest" ]; then
            echo "   ✅ Last backup: $latest"
        else
            echo "   ⚠️  No backups found"
        fi
    done
    
    echo ""
    echo "💡 Run 'bill_backup <set_name>' to create a backup"
}

# Initialize on source
init_restic_backup

# Export functions
export -f bill_backup bill_backup_list bill_restore bill_backup_cleanup bill_backup_status