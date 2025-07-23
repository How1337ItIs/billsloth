#!/bin/bash
# LLM_CAPABILITY: local_ok
# Cross-Module Data Sharing Library
# Centralized data management and sharing between Bill Sloth modules


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true

# Global data sharing configuration
SHARED_DATA_DIR="$HOME/.bill-sloth/shared-data"
CACHE_DIR="$SHARED_DATA_DIR/cache"
SYNC_DIR="$SHARED_DATA_DIR/sync"
REGISTRY_DIR="$SHARED_DATA_DIR/registry"

# Initialize data sharing system
init_data_sharing() {
    log_info "Initializing cross-module data sharing system..."
    
    # Create data sharing directories
    mkdir -p "$SHARED_DATA_DIR"/{cache,sync,registry,exports,imports}
    mkdir -p "$CACHE_DIR"/{vrbo,partnerships,tasks,revenue}
    mkdir -p "$SYNC_DIR"/{incoming,outgoing,processed}
    
    # Create data registry
    touch "$REGISTRY_DIR/data_registry.json"
    if [ ! -s "$REGISTRY_DIR/data_registry.json" ]; then
        echo '{"modules": {}, "data_sources": {}, "last_updated": ""}' > "$REGISTRY_DIR/data_registry.json"
    fi
    
    # Create sync status tracking
    touch "$REGISTRY_DIR/sync_status.json"
    if [ ! -s "$REGISTRY_DIR/sync_status.json" ]; then
        echo '{"last_sync": "", "sync_count": 0, "errors": []}' > "$REGISTRY_DIR/sync_status.json"
    fi
    
    log_success "Data sharing system initialized"
}

# Register data source
register_data_source() {
    local module="$1"
    local data_type="$2"
    local source_path="$3"
    local description="$4"
    
    local registry_file="$REGISTRY_DIR/data_registry.json"
    local timestamp=$(date -Iseconds)
    
    # Update registry with new data source
    jq --arg module "$module" \
       --arg data_type "$data_type" \
       --arg source_path "$source_path" \
       --arg description "$description" \
       --arg timestamp "$timestamp" \
       '.modules[$module].data_sources[$data_type] = {
           "path": $source_path,
           "description": $description,
           "registered": $timestamp,
           "last_accessed": "",
           "access_count": 0
       } | .last_updated = $timestamp' \
       "$registry_file" > "${registry_file}.tmp" && mv "${registry_file}.tmp" "$registry_file"
    
    log_success "Registered data source: $module/$data_type"
}

# Cache data for cross-module access
cache_data() {
    local module="$1"
    local data_type="$2"
    local data="$3"
    local ttl="${4:-3600}"  # Time to live in seconds (default 1 hour)
    
    local cache_file="$CACHE_DIR/$module/${data_type}.json"
    local timestamp=$(date +%s)
    local expires=$((timestamp + ttl))
    
    mkdir -p "$(dirname "$cache_file")"
    
    # Create cache entry
    cat > "$cache_file" << EOF
{
  "module": "$module",
  "data_type": "$data_type",
  "timestamp": $timestamp,
  "expires": $expires,
  "data": $data
}
EOF
    
    log_success "Cached data: $module/$data_type (expires in ${ttl}s)"
}

# Retrieve cached data
get_cached_data() {
    local module="$1"
    local data_type="$2"
    
    local cache_file="$CACHE_DIR/$module/${data_type}.json"
    local current_time=$(date +%s)
    
    if [ ! -f "$cache_file" ]; then
        log_warning "No cached data found: $module/$data_type"
        return 1
    fi
    
    local expires=$(jq -r '.expires' "$cache_file")
    
    if [ "$current_time" -gt "$expires" ]; then
        log_warning "Cached data expired: $module/$data_type"
        rm -f "$cache_file"
        return 1
    fi
    
    # Update access tracking
    local registry_file="$REGISTRY_DIR/data_registry.json"
    jq --arg module "$module" \
       --arg data_type "$data_type" \
       --arg timestamp "$(date -Iseconds)" \
       '.modules[$module].data_sources[$data_type].last_accessed = $timestamp |
        .modules[$module].data_sources[$data_type].access_count += 1' \
       "$registry_file" > "${registry_file}.tmp" && mv "${registry_file}.tmp" "$registry_file"
    
    # Return cached data
    jq -r '.data' "$cache_file"
}

# Share data between modules
share_data() {
    local source_module="$1"
    local target_module="$2"
    local data_type="$3"
    local data="$4"
    
    local sync_file="$SYNC_DIR/outgoing/${source_module}_to_${target_module}_${data_type}_$(date +%s).json"
    
    # Create sync package
    cat > "$sync_file" << EOF
{
  "source_module": "$source_module",
  "target_module": "$target_module",
  "data_type": "$data_type",
  "timestamp": "$(date -Iseconds)",
  "data": $data,
  "status": "pending"
}
EOF
    
    log_info "Data shared: $source_module -> $target_module ($data_type)"
    
    # Immediately process if target module is active
    process_incoming_data "$target_module"
}

# Process incoming data for a module
process_incoming_data() {
    local target_module="$1"
    
    for sync_file in "$SYNC_DIR/outgoing"/*_to_${target_module}_*.json; do
        if [ -f "$sync_file" ]; then
            local data_type=$(jq -r '.data_type' "$sync_file")
            local data=$(jq -r '.data' "$sync_file")
            local source_module=$(jq -r '.source_module' "$sync_file")
            
            # Cache the shared data
            cache_data "$target_module" "${source_module}_${data_type}" "$data" 7200
            
            # Move to processed
            mv "$sync_file" "$SYNC_DIR/processed/"
            
            log_success "Processed data for $target_module: $data_type"
        fi
    done
}

# === BILL-SPECIFIC DATA SHARING FUNCTIONS ===

# Share VRBO booking data
share_vrbo_booking() {
    local booking_data="$1"
    
    # Cache booking data
    cache_data "vrbo_automation" "latest_booking" "$booking_data"
    
    # Share with Google Tasks for task creation
    share_data "vrbo_automation" "google_tasks" "new_booking" "$booking_data"
    
    # Share with revenue tracking
    share_data "vrbo_automation" "data_automation" "booking_revenue" "$booking_data"
    
    # Share with ChatGPT for welcome message generation
    share_data "vrbo_automation" "chatgpt_integration" "guest_info" "$booking_data"
    
    log_success "VRBO booking data shared across modules"
}

# Share partnership data
share_partnership_data() {
    local partnership_data="$1"
    
    # Cache partnership data
    cache_data "edboigames" "latest_partnership" "$partnership_data"
    
    # Share with Google Tasks for follow-up tasks
    share_data "edboigames" "google_tasks" "partnership_tasks" "$partnership_data"
    
    # Share with revenue tracking
    share_data "edboigames" "data_automation" "partnership_revenue" "$partnership_data"
    
    log_success "Partnership data shared across modules"
}

# Share revenue data
share_revenue_data() {
    local revenue_data="$1"
    local source_module="$2"
    
    # Cache revenue data
    cache_data "$source_module" "revenue_update" "$revenue_data"
    
    # Share with central data automation
    share_data "$source_module" "data_automation" "revenue_input" "$revenue_data"
    
    # Share with ChatGPT for insights
    share_data "$source_module" "chatgpt_integration" "revenue_analysis" "$revenue_data"
    
    log_success "Revenue data shared from $source_module"
}

# Get VRBO guest data for other modules
get_vrbo_guest_data() {
    local guest_id="$1"
    
    # Try to get from cache first
    local cached_data=$(get_cached_data "vrbo_automation" "guest_${guest_id}")
    
    if [ $? -eq 0 ]; then
        echo "$cached_data"
        return 0
    fi
    
    # If not cached, try to load from VRBO module
    if [ -f "$HOME/.bill-sloth/vrbo-automation/data/guests/${guest_id}.json" ]; then
        local guest_data=$(cat "$HOME/.bill-sloth/vrbo-automation/data/guests/${guest_id}.json")
        cache_data "vrbo_automation" "guest_${guest_id}" "$guest_data"
        echo "$guest_data"
        return 0
    fi
    
    log_warning "Guest data not found: $guest_id"
    return 1
}

# Get partnership data for other modules
get_partnership_data() {
    local partner_id="$1"
    
    # Try to get from cache first
    local cached_data=$(get_cached_data "edboigames" "partner_${partner_id}")
    
    if [ $? -eq 0 ]; then
        echo "$cached_data"
        return 0
    fi
    
    # If not cached, try to load from EdBoiGames module
    if [ -f "$HOME/edboigames_business/partnerships/active/${partner_id}.json" ]; then
        local partner_data=$(cat "$HOME/edboigames_business/partnerships/active/${partner_id}.json")
        cache_data "edboigames" "partner_${partner_id}" "$partner_data"
        echo "$partner_data"
        return 0
    fi
    
    log_warning "Partnership data not found: $partner_id"
    return 1
}

# Get consolidated revenue data
get_revenue_summary() {
    local period="${1:-current_month}"
    
    # Try to get from cache first
    local cached_data=$(get_cached_data "data_automation" "revenue_summary_${period}")
    
    if [ $? -eq 0 ]; then
        echo "$cached_data"
        return 0
    fi
    
    # If not cached, generate summary from available data
    local vrbo_revenue=$(get_cached_data "vrbo_automation" "revenue_update" 2>/dev/null || echo "0")
    local partnership_revenue=$(get_cached_data "edboigames" "revenue_update" 2>/dev/null || echo "0")
    
    local summary=$(cat << EOF
{
  "period": "$period",
  "generated": "$(date -Iseconds)",
  "vrbo_revenue": $vrbo_revenue,
  "partnership_revenue": $partnership_revenue,
  "total_revenue": $((${vrbo_revenue//[^0-9]/} + ${partnership_revenue//[^0-9]/}))
}
EOF
)
    
    cache_data "data_automation" "revenue_summary_${period}" "$summary"
    echo "$summary"
}

# Sync data across all modules
sync_all_data() {
    log_info "Starting cross-module data synchronization..."
    
    local sync_count=0
    
    # Process pending data shares
    for module in "vrbo_automation" "edboigames" "google_tasks" "chatgpt_integration" "data_automation"; do
        process_incoming_data "$module"
        ((sync_count++))
    done
    
    # Update sync status
    local sync_status_file="$REGISTRY_DIR/sync_status.json"
    jq --arg timestamp "$(date -Iseconds)" \
       --arg count "$sync_count" \
       '.last_sync = $timestamp | .sync_count += ($count | tonumber)' \
       "$sync_status_file" > "${sync_status_file}.tmp" && mv "${sync_status_file}.tmp" "$sync_status_file"
    
    # Clean up old cache files (older than 24 hours)
    find "$CACHE_DIR" -name "*.json" -mtime +1 -delete 2>/dev/null
    
    # Clean up processed sync files (older than 7 days)
    find "$SYNC_DIR/processed" -name "*.json" -mtime +7 -delete 2>/dev/null
    
    log_success "Data synchronization completed ($sync_count modules processed)"
}

# Monitor data sharing activity
monitor_data_sharing() {
    print_header "📊 DATA SHARING MONITORING"
    
    echo "📈 Cache Statistics:"
    echo "  VRBO Cache: $(ls -1 "$CACHE_DIR/vrbo/"*.json 2>/dev/null | wc -l) files"
    echo "  Partnership Cache: $(ls -1 "$CACHE_DIR/partnerships/"*.json 2>/dev/null | wc -l) files"
    echo "  Tasks Cache: $(ls -1 "$CACHE_DIR/tasks/"*.json 2>/dev/null | wc -l) files"
    echo "  Revenue Cache: $(ls -1 "$CACHE_DIR/revenue/"*.json 2>/dev/null | wc -l) files"
    echo ""
    
    echo "🔄 Sync Activity:"
    echo "  Pending: $(ls -1 "$SYNC_DIR/outgoing/"*.json 2>/dev/null | wc -l) files"
    echo "  Processed: $(ls -1 "$SYNC_DIR/processed/"*.json 2>/dev/null | wc -l) files"
    echo ""
    
    if [ -f "$REGISTRY_DIR/sync_status.json" ]; then
        local last_sync=$(jq -r '.last_sync' "$REGISTRY_DIR/sync_status.json")
        local sync_count=$(jq -r '.sync_count' "$REGISTRY_DIR/sync_status.json")
        echo "🕒 Last Sync: $last_sync"
        echo "📊 Total Syncs: $sync_count"
    fi
    echo ""
    
    echo "📋 Registered Data Sources:"
    if [ -f "$REGISTRY_DIR/data_registry.json" ]; then
        jq -r '.modules | keys[]' "$REGISTRY_DIR/data_registry.json" | while read module; do
            echo "  • $module:"
            jq -r --arg module "$module" '.modules[$module].data_sources | keys[]' "$REGISTRY_DIR/data_registry.json" | while read data_type; do
                local access_count=$(jq -r --arg module "$module" --arg data_type "$data_type" '.modules[$module].data_sources[$data_type].access_count' "$REGISTRY_DIR/data_registry.json")
                echo "    - $data_type (accessed $access_count times)"
            done
        done
    fi
}

# Setup automated data sharing for Bill
setup_bill_data_sharing() {
    log_info "Setting up Bill's cross-module data sharing..."
    
    init_data_sharing
    
    # Register Bill's data sources
    register_data_source "vrbo_automation" "bookings" "$HOME/.bill-sloth/vrbo-automation/data/bookings.csv" "VRBO booking data"
    register_data_source "vrbo_automation" "guests" "$HOME/.bill-sloth/vrbo-automation/data/guests/" "Guest information"
    register_data_source "edboigames" "partnerships" "$HOME/edboigames_business/partnerships/" "Partnership data"
    register_data_source "edboigames" "revenue" "$HOME/edboigames_business/templates/revenue_tracker.csv" "Revenue tracking"
    register_data_source "google_tasks" "tasks" "$HOME/.bill-sloth/google-tasks/data/" "Task management data"
    register_data_source "data_automation" "processed_data" "$HOME/.bill-sloth/data-automation/processed/" "Processed data files"
    
    # Create data sharing automation script
    cat > "$SHARED_DATA_DIR/auto_sync.sh" << 'EOF'
#!/bin/bash
# Automated data synchronization for Bill's modules

source "$HOME/.bill-sloth/lib/data_sharing.sh"

echo "🔄 Starting automated data sync..."
sync_all_data

# Run every 15 minutes via cron
# Add to crontab: */15 * * * * $HOME/.bill-sloth/shared-data/auto_sync.sh >> $HOME/.bill-sloth/shared-data/sync.log 2>&1
EOF
    chmod +x "$SHARED_DATA_DIR/auto_sync.sh"
    
    # Create data sharing dashboard
    cat > "$SHARED_DATA_DIR/data_dashboard.sh" << 'EOF'
#!/bin/bash
echo "📊 BILL'S DATA SHARING DASHBOARD"
echo "================================="
echo ""

source "$HOME/.bill-sloth/lib/data_sharing.sh"

while true; do
    clear
    echo "📊 BILL'S DATA SHARING DASHBOARD"
    echo "================================="
    echo ""
    
    monitor_data_sharing
    
    echo ""
    echo "⚙️  ACTIONS:"
    echo "1) Manual sync all data"
    echo "2) View VRBO guest data"
    echo "3) View partnership data"
    echo "4) View revenue summary"
    echo "5) Clear cache"
    echo "0) Exit"
    echo ""
    
    read -p "Select action: " action
    
    case $action in
        1) sync_all_data ;;
        2) 
            read -p "Enter guest ID: " guest_id
            get_vrbo_guest_data "$guest_id"
            ;;
        3)
            read -p "Enter partner ID: " partner_id
            get_partnership_data "$partner_id"
            ;;
        4) get_revenue_summary ;;
        5) 
            rm -rf "$HOME/.bill-sloth/shared-data/cache/"*
            echo "Cache cleared"
            ;;
        0) exit ;;
    esac
    
    if [ "$action" != "0" ]; then
        read -n 1 -s -r -p "Press any key to continue..."
    fi
done
EOF
    chmod +x "$SHARED_DATA_DIR/data_dashboard.sh"
    
    log_success "Data sharing system configured for Bill!"
    echo ""
    echo "🚀 Quick Start:"
    echo "  • Auto sync: $SHARED_DATA_DIR/auto_sync.sh"
    echo "  • Dashboard: $SHARED_DATA_DIR/data_dashboard.sh"
    echo "  • Manual sync: sync_all_data"
    echo ""
    echo "📅 To enable automatic sync every 15 minutes, add to crontab:"
    echo "*/15 * * * * $SHARED_DATA_DIR/auto_sync.sh >> $SHARED_DATA_DIR/sync.log 2>&1"
}

# Export functions
export -f init_data_sharing register_data_source cache_data get_cached_data
export -f share_data process_incoming_data sync_all_data monitor_data_sharing
export -f share_vrbo_booking share_partnership_data share_revenue_data
export -f get_vrbo_guest_data get_partnership_data get_revenue_summary
export -f setup_bill_data_sharing