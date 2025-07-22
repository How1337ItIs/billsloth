#!/bin/bash
# LLM_CAPABILITY: local_ok
# Data Persistence Library - Modern SQLite replacement for JSON file caching
# Replaces file-based JSON caching with proper database for better reliability

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Database configuration
DB_DIR="$HOME/.bill-sloth/data"
DB_FILE="$DB_DIR/bill_sloth.db"
LEGACY_CACHE_DIR="$HOME/.bill-sloth/cache"

# Initialize data persistence system
init_data_persistence() {
    log_info "Initializing Bill Sloth data persistence..."
    
    # Create database directory
    mkdir -p "$DB_DIR"
    
    # Check for SQLite
    if command -v sqlite3 &> /dev/null; then
        DATABASE_ENGINE="sqlite3"
        create_database_schema
        log_success "Using SQLite for data persistence"
    else
        DATABASE_ENGINE="json_files"
        log_warning "SQLite not found, using JSON file fallback"
        mkdir -p "$LEGACY_CACHE_DIR"
    fi
    
    export DATABASE_ENGINE
}

# Create SQLite database schema
create_database_schema() {
    sqlite3 "$DB_FILE" << 'SQL'
-- Core data sharing table (replaces JSON cache files)
CREATE TABLE IF NOT EXISTS data_cache (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module TEXT NOT NULL,
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    data_type TEXT DEFAULT 'string',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    expires_at DATETIME,
    metadata TEXT,
    UNIQUE(module, key)
);

-- User preferences and settings
CREATE TABLE IF NOT EXISTS user_preferences (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category TEXT NOT NULL,
    key TEXT NOT NULL,
    value TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(category, key)
);

-- Task/workflow execution history
CREATE TABLE IF NOT EXISTS task_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    task_name TEXT NOT NULL,
    status TEXT NOT NULL, -- 'success', 'failure', 'running'
    started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    completed_at DATETIME,
    duration_seconds INTEGER,
    output TEXT,
    error_message TEXT,
    user_feedback INTEGER, -- 1-5 rating
    metadata TEXT -- JSON for additional data
);

-- Module usage analytics
CREATE TABLE IF NOT EXISTS module_usage (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    module_name TEXT NOT NULL,
    action TEXT NOT NULL,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_satisfaction INTEGER, -- 1-5 rating
    session_id TEXT,
    metadata TEXT
);

-- VRBO automation data
CREATE TABLE IF NOT EXISTS vrbo_bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    guest_name TEXT NOT NULL,
    property TEXT NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE,
    booking_status TEXT DEFAULT 'confirmed',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    tasks_created BOOLEAN DEFAULT FALSE,
    metadata TEXT
);

-- EdBoiGames content tracking
CREATE TABLE IF NOT EXISTS edboigames_content (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    content_type TEXT NOT NULL, -- 'video', 'thumbnail', 'description'
    file_path TEXT,
    title TEXT,
    status TEXT DEFAULT 'draft', -- 'draft', 'processed', 'published'
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    processed_at DATETIME,
    published_at DATETIME,
    metadata TEXT
);

-- System health snapshots
CREATE TABLE IF NOT EXISTS health_snapshots (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    cpu_usage REAL,
    memory_usage REAL,
    disk_usage REAL,
    module_status TEXT, -- JSON of module health
    issues_detected TEXT, -- JSON array of issues
    overall_score INTEGER
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_data_cache_module_key ON data_cache(module, key);
CREATE INDEX IF NOT EXISTS idx_data_cache_expires ON data_cache(expires_at);
CREATE INDEX IF NOT EXISTS idx_task_history_task_date ON task_history(task_name, started_at);
CREATE INDEX IF NOT EXISTS idx_module_usage_module_timestamp ON module_usage(module_name, timestamp);
CREATE INDEX IF NOT EXISTS idx_vrbo_checkin ON vrbo_bookings(checkin_date);
CREATE INDEX IF NOT EXISTS idx_health_timestamp ON health_snapshots(timestamp);
SQL

    log_success "Database schema created/updated"
}

# Store data with TTL support (replaces cache_data function)
store_data() {
    local module="$1"
    local key="$2" 
    local value="$3"
    local ttl_hours="${4:-24}" # Default 24 hour TTL
    local data_type="${5:-string}"
    
    if [ -z "$module" ] || [ -z "$key" ] || [ -z "$value" ]; then
        log_error "store_data requires module, key, and value"
        return 1
    fi
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            local expires_at=""
            if [ "$ttl_hours" != "0" ]; then
                expires_at="datetime('now', '+$ttl_hours hours')"
            else
                expires_at="NULL"
            fi
            
            sqlite3 "$DB_FILE" << EOF
INSERT OR REPLACE INTO data_cache 
(module, key, value, data_type, expires_at, metadata)
VALUES ('$module', '$key', '$value', '$data_type', $expires_at, '{"ttl_hours": $ttl_hours}');
EOF
            ;;
        "json_files")
            # Fallback to file-based storage
            local cache_file="$LEGACY_CACHE_DIR/${module}_${key}.json"
            local expires_at=""
            if [ "$ttl_hours" != "0" ]; then
                expires_at=$(date -d "+$ttl_hours hours" -Iseconds)
            fi
            
            cat > "$cache_file" << EOF
{
  "module": "$module",
  "key": "$key", 
  "value": "$value",
  "data_type": "$data_type",
  "created_at": "$(date -Iseconds)",
  "expires_at": "$expires_at"
}
EOF
            ;;
    esac
}

# Retrieve data (replaces get_cached_data function)
get_data() {
    local module="$1"
    local key="$2"
    local default_value="$3"
    
    if [ -z "$module" ] || [ -z "$key" ]; then
        log_error "get_data requires module and key"
        return 1
    fi
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            # Clean expired data first
            sqlite3 "$DB_FILE" "DELETE FROM data_cache WHERE expires_at IS NOT NULL AND expires_at < datetime('now');"
            
            local result=$(sqlite3 "$DB_FILE" "SELECT value FROM data_cache WHERE module='$module' AND key='$key' LIMIT 1;")
            
            if [ -n "$result" ]; then
                echo "$result"
            elif [ -n "$default_value" ]; then
                echo "$default_value"
            else
                return 1
            fi
            ;;
        "json_files")
            local cache_file="$LEGACY_CACHE_DIR/${module}_${key}.json"
            
            if [ -f "$cache_file" ]; then
                # Check expiration
                local expires_at=$(jq -r '.expires_at // empty' "$cache_file" 2>/dev/null)
                if [ -n "$expires_at" ] && [ "$expires_at" != "null" ]; then
                    if [[ "$expires_at" < "$(date -Iseconds)" ]]; then
                        rm -f "$cache_file"
                        echo "$default_value"
                        return 1
                    fi
                fi
                
                jq -r '.value' "$cache_file" 2>/dev/null || echo "$default_value"
            else
                echo "$default_value"
                return 1
            fi
            ;;
    esac
}

# Store user preference
store_preference() {
    local category="$1"
    local key="$2"
    local value="$3"
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            sqlite3 "$DB_FILE" << EOF
INSERT OR REPLACE INTO user_preferences 
(category, key, value, updated_at)
VALUES ('$category', '$key', '$value', datetime('now'));
EOF
            ;;
        "json_files")
            local pref_file="$LEGACY_CACHE_DIR/preferences_${category}.json"
            local prefs="{}"
            [ -f "$pref_file" ] && prefs=$(cat "$pref_file")
            
            echo "$prefs" | jq --arg key "$key" --arg value "$value" \
                '. += {($key): $value}' > "$pref_file"
            ;;
    esac
}

# Get user preference
get_preference() {
    local category="$1"
    local key="$2"
    local default_value="$3"
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            local result=$(sqlite3 "$DB_FILE" "SELECT value FROM user_preferences WHERE category='$category' AND key='$key' LIMIT 1;")
            echo "${result:-$default_value}"
            ;;
        "json_files")
            local pref_file="$LEGACY_CACHE_DIR/preferences_${category}.json"
            if [ -f "$pref_file" ]; then
                jq -r --arg key "$key" --arg default "$default_value" \
                    '.[$key] // $default' "$pref_file" 2>/dev/null || echo "$default_value"
            else
                echo "$default_value"
            fi
            ;;
    esac
}

# Log task execution (replaces workflow logging)
log_task_execution() {
    local task_name="$1"
    local status="$2" # success, failure, running
    local duration_seconds="${3:-0}"
    local output="$4"
    local error_message="$5"
    local user_feedback="$6" # 1-5 rating
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            local completed_at="NULL"
            [ "$status" != "running" ] && completed_at="datetime('now')"
            
            sqlite3 "$DB_FILE" << EOF
INSERT INTO task_history 
(task_name, status, duration_seconds, output, error_message, user_feedback, completed_at)
VALUES ('$task_name', '$status', $duration_seconds, '$output', '$error_message', 
        ${user_feedback:-NULL}, $completed_at);
EOF
            ;;
        "json_files")
            local log_file="$LEGACY_CACHE_DIR/task_history.jsonl"
            local log_entry=$(cat << EOF
{
  "task_name": "$task_name",
  "status": "$status", 
  "timestamp": "$(date -Iseconds)",
  "duration_seconds": $duration_seconds,
  "output": "$output",
  "error_message": "$error_message",
  "user_feedback": $user_feedback
}
EOF
)
            echo "$log_entry" >> "$log_file"
            ;;
    esac
}

# Log module usage for analytics
log_module_usage() {
    local module_name="$1"
    local action="$2"
    local user_satisfaction="$3" # 1-5 rating
    local session_id="$4"
    local metadata="$5" # JSON string
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            sqlite3 "$DB_FILE" << EOF
INSERT INTO module_usage 
(module_name, action, user_satisfaction, session_id, metadata)
VALUES ('$module_name', '$action', ${user_satisfaction:-NULL}, '$session_id', '$metadata');
EOF
            ;;
        "json_files")
            local usage_file="$LEGACY_CACHE_DIR/module_usage.jsonl"
            local usage_entry=$(cat << EOF
{
  "module_name": "$module_name",
  "action": "$action",
  "timestamp": "$(date -Iseconds)",
  "user_satisfaction": $user_satisfaction,
  "session_id": "$session_id",
  "metadata": $metadata
}
EOF
)
            echo "$usage_entry" >> "$usage_file"
            ;;
    esac
}

# Store VRBO booking (Bill-specific functionality)
store_vrbo_booking() {
    local guest_name="$1"
    local property="$2"
    local checkin_date="$3"
    local checkout_date="$4"
    local metadata="$5"
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            sqlite3 "$DB_FILE" << EOF
INSERT INTO vrbo_bookings 
(guest_name, property, checkin_date, checkout_date, metadata)
VALUES ('$guest_name', '$property', '$checkin_date', '$checkout_date', '$metadata');
EOF
            ;;
        "json_files")
            local booking_file="$LEGACY_CACHE_DIR/vrbo_bookings.jsonl"
            local booking_entry=$(cat << EOF
{
  "guest_name": "$guest_name",
  "property": "$property", 
  "checkin_date": "$checkin_date",
  "checkout_date": "$checkout_date",
  "created_at": "$(date -Iseconds)",
  "metadata": $metadata
}
EOF
)
            echo "$booking_entry" >> "$booking_file"
            ;;
    esac
    
    notify_success "Booking Stored" "📅 $guest_name booking for $property saved"
}

# Get upcoming VRBO bookings
get_upcoming_bookings() {
    local days_ahead="${1:-30}"
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            sqlite3 "$DB_FILE" << EOF
SELECT guest_name, property, checkin_date 
FROM vrbo_bookings 
WHERE checkin_date BETWEEN date('now') AND date('now', '+$days_ahead days')
ORDER BY checkin_date;
EOF
            ;;
        "json_files")
            local booking_file="$LEGACY_CACHE_DIR/vrbo_bookings.jsonl"
            if [ -f "$booking_file" ]; then
                # Simple date filtering for files (less precise)
                local cutoff_date=$(date -d "+$days_ahead days" +%Y-%m-%d)
                jq -r --arg cutoff "$cutoff_date" \
                    'select(.checkin_date <= $cutoff) | "\(.guest_name) \(.property) \(.checkin_date)"' \
                    "$booking_file" 2>/dev/null || true
            fi
            ;;
    esac
}

# Store system health snapshot
store_health_snapshot() {
    local cpu_usage="$1"
    local memory_usage="$2" 
    local disk_usage="$3"
    local module_status="$4" # JSON
    local issues_detected="$5" # JSON array
    local overall_score="$6"
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            sqlite3 "$DB_FILE" << EOF
INSERT INTO health_snapshots 
(cpu_usage, memory_usage, disk_usage, module_status, issues_detected, overall_score)
VALUES ($cpu_usage, $memory_usage, $disk_usage, '$module_status', '$issues_detected', $overall_score);
EOF
            ;;
        "json_files")
            local health_file="$LEGACY_CACHE_DIR/health_snapshots.jsonl"
            local health_entry=$(cat << EOF
{
  "timestamp": "$(date -Iseconds)",
  "cpu_usage": $cpu_usage,
  "memory_usage": $memory_usage,
  "disk_usage": $disk_usage,
  "module_status": $module_status,
  "issues_detected": $issues_detected,
  "overall_score": $overall_score
}
EOF
)
            echo "$health_entry" >> "$health_file"
            ;;
    esac
}

# Clean expired data and optimize database
maintain_database() {
    echo "🧹 Running database maintenance..."
    
    case "$DATABASE_ENGINE" in
        "sqlite3")
            # Clean expired cache entries
            local expired_count=$(sqlite3 "$DB_FILE" "DELETE FROM data_cache WHERE expires_at IS NOT NULL AND expires_at < datetime('now'); SELECT changes();")
            
            # Keep only last 1000 task history entries
            sqlite3 "$DB_FILE" << EOF
DELETE FROM task_history 
WHERE id NOT IN (
    SELECT id FROM task_history 
    ORDER BY started_at DESC 
    LIMIT 1000
);
EOF
            
            # Keep only last 30 days of health snapshots  
            sqlite3 "$DB_FILE" "DELETE FROM health_snapshots WHERE timestamp < datetime('now', '-30 days');"
            
            # Optimize database
            sqlite3 "$DB_FILE" "VACUUM;"
            
            echo "✅ Database maintenance complete (removed $expired_count expired entries)"
            ;;
        "json_files")
            # Clean old JSON files
            find "$LEGACY_CACHE_DIR" -name "*.json" -mtime +7 -delete 2>/dev/null || true
            
            # Truncate large log files
            for log_file in "$LEGACY_CACHE_DIR"/*.jsonl; do
                [ -f "$log_file" ] || continue
                if [ $(wc -l < "$log_file") -gt 1000 ]; then
                    tail -1000 "$log_file" > "${log_file}.tmp"
                    mv "${log_file}.tmp" "$log_file"
                fi
            done
            
            echo "✅ File cache maintenance complete"
            ;;
    esac
}

# Migration helper: Convert old JSON cache to SQLite
migrate_json_cache_to_sqlite() {
    if [ "$DATABASE_ENGINE" != "sqlite3" ]; then
        log_warning "SQLite not available, skipping migration"
        return 0
    fi
    
    echo "🔄 Migrating JSON cache to SQLite..."
    
    if [ ! -d "$LEGACY_CACHE_DIR" ]; then
        echo "ℹ️  No legacy cache found, skipping migration"
        return 0
    fi
    
    local migrated_count=0
    
    # Migrate cache files
    for cache_file in "$LEGACY_CACHE_DIR"/*.json; do
        [ -f "$cache_file" ] || continue
        
        local module=$(jq -r '.module // "unknown"' "$cache_file" 2>/dev/null)
        local key=$(jq -r '.key // "unknown"' "$cache_file" 2>/dev/null) 
        local value=$(jq -r '.value // ""' "$cache_file" 2>/dev/null)
        local data_type=$(jq -r '.data_type // "string"' "$cache_file" 2>/dev/null)
        
        if [ "$module" != "unknown" ] && [ "$key" != "unknown" ]; then
            store_data "$module" "$key" "$value" 24 "$data_type"
            migrated_count=$((migrated_count + 1))
        fi
    done
    
    # Migrate JSONL files
    for jsonl_file in "$LEGACY_CACHE_DIR"/*.jsonl; do
        [ -f "$jsonl_file" ] || continue
        
        while IFS= read -r line; do
            # Basic migration for task history and module usage
            if [[ "$jsonl_file" == *"task_history"* ]]; then
                local task_name=$(echo "$line" | jq -r '.task_name // "unknown"')
                local status=$(echo "$line" | jq -r '.status // "unknown"')
                
                if [ "$task_name" != "unknown" ]; then
                    log_task_execution "$task_name" "$status" 0 "" "" ""
                fi
            fi
        done < "$jsonl_file"
    done
    
    echo "✅ Migration complete: $migrated_count cache entries migrated"
    
    # Backup old cache
    if [ -d "$LEGACY_CACHE_DIR" ]; then
        mv "$LEGACY_CACHE_DIR" "${LEGACY_CACHE_DIR}.backup"
        echo "💾 Old cache backed up to: ${LEGACY_CACHE_DIR}.backup"
    fi
}

# Export functions
export -f init_data_persistence store_data get_data store_preference get_preference
export -f log_task_execution log_module_usage store_vrbo_booking get_upcoming_bookings
export -f store_health_snapshot maintain_database migrate_json_cache_to_sqlite

# Initialize on source
if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
    init_data_persistence 2>/dev/null || true
fi

# Main function for standalone execution
data_persistence_main() {
    local command="$1"
    shift || true
    
    case "$command" in
        init)
            init_data_persistence
            ;;
        store)
            if [ $# -lt 3 ]; then
                echo "Usage: data_persistence_main store <module> <key> <value> [ttl_hours] [data_type]"
                return 1
            fi
            store_data "$@"
            ;;
        get)
            if [ $# -lt 2 ]; then
                echo "Usage: data_persistence_main get <module> <key> [default]"
                return 1
            fi
            get_data "$@"
            ;;
        migrate)
            migrate_json_cache_to_sqlite
            ;;
        maintain)
            maintain_database
            ;;
        bookings)
            get_upcoming_bookings "$1"
            ;;
        *)
            echo "Bill Sloth Data Persistence System"
            echo "Usage: $0 {init|store|get|migrate|maintain|bookings}"
            echo ""
            echo "Commands:"
            echo "  init       - Initialize data persistence system"
            echo "  store      - Store data with TTL"
            echo "  get        - Retrieve data"
            echo "  migrate    - Migrate from JSON cache to SQLite"
            echo "  maintain   - Clean and optimize database"
            echo "  bookings   - Show upcoming VRBO bookings"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    data_persistence_main "$@"
fi