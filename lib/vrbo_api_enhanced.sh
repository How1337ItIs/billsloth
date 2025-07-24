#!/bin/bash
# LLM_CAPABILITY: local_ok
# Enhanced VRBO API Integration Library with Retry Logic and Better Error Handling
# Professional-grade API integration for vacation rental management

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/input_sanitization.sh" 2>/dev/null || true
source "$SCRIPT_DIR/notification_system.sh" 2>/dev/null || true

# Configuration
VRBO_CONFIG_DIR="$HOME/.bill-sloth/vrbo"
VRBO_CREDENTIALS="$VRBO_CONFIG_DIR/credentials.json"
VRBO_CACHE_DIR="$VRBO_CONFIG_DIR/cache"
VRBO_LOGS_DIR="$VRBO_CONFIG_DIR/logs"
VRBO_DATA_DB="$VRBO_CONFIG_DIR/vrbo_data.db"
VRBO_METRICS_FILE="$VRBO_CONFIG_DIR/api_metrics.json"

# VRBO API endpoints (using Expedia Partner API)
VRBO_BASE_URL="https://api.expediapartnercentral.com"
VRBO_AUTH_URL="https://api.expediapartnercentral.com/authentication/v1/token"

# Retry configuration
MAX_RETRIES=3
RETRY_DELAY=5
BACKOFF_MULTIPLIER=2

# Rate limiting configuration
RATE_LIMIT_WINDOW=60  # seconds
RATE_LIMIT_REQUESTS=60  # requests per window

# Initialize enhanced VRBO integration
init_vrbo_enhanced() {
    log_info "Initializing enhanced VRBO API integration..."
    
    # Create directories
    safe_mkdir "$VRBO_CONFIG_DIR" 700
    safe_mkdir "$VRBO_CACHE_DIR" 755
    safe_mkdir "$VRBO_LOGS_DIR" 755
    safe_mkdir "$VRBO_CONFIG_DIR/retry_queue" 755
    
    # Initialize database with enhanced schema
    init_vrbo_database_enhanced
    
    # Initialize metrics tracking
    if [ ! -f "$VRBO_METRICS_FILE" ]; then
        echo '{
            "api_calls": {
                "total": 0,
                "successful": 0,
                "failed": 0,
                "retried": 0
            },
            "rate_limits": {
                "hits": 0,
                "last_reset": "'$(date -Iseconds)'"
            },
            "performance": {
                "average_response_time": 0,
                "last_24h_uptime": 100
            }
        }' > "$VRBO_METRICS_FILE"
    fi
    
    # Create credentials template if not exists
    if [ ! -f "$VRBO_CREDENTIALS" ]; then
        create_enhanced_credentials_template
    fi
    
    log_success "Enhanced VRBO integration initialized"
}

# Create enhanced SQLite database
init_vrbo_database_enhanced() {
    sqlite3 "$VRBO_DATA_DB" << 'EOF'
-- Enhanced properties table with more metadata
CREATE TABLE IF NOT EXISTS properties (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vrbo_property_id TEXT UNIQUE NOT NULL,
    name TEXT NOT NULL,
    address TEXT,
    city TEXT,
    state TEXT,
    country TEXT,
    property_type TEXT,
    bedrooms INTEGER,
    bathrooms INTEGER,
    max_guests INTEGER,
    amenities TEXT,  -- JSON array
    house_rules TEXT,  -- JSON object
    cancellation_policy TEXT,
    instant_book_enabled BOOLEAN DEFAULT FALSE,
    base_rate DECIMAL(10,2),
    cleaning_fee DECIMAL(10,2),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sync_status TEXT DEFAULT 'active',
    sync_errors INTEGER DEFAULT 0
);

-- Enhanced bookings table with guest preferences
CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vrbo_booking_id TEXT UNIQUE NOT NULL,
    property_id INTEGER,
    guest_name TEXT NOT NULL,
    guest_email TEXT,
    guest_phone TEXT,
    guest_preferences TEXT,  -- JSON object
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    nights INTEGER NOT NULL,
    adults INTEGER,
    children INTEGER,
    pets INTEGER DEFAULT 0,
    total_amount DECIMAL(10,2),
    paid_amount DECIMAL(10,2),
    currency TEXT DEFAULT 'USD',
    booking_status TEXT,
    payment_status TEXT,
    special_requests TEXT,
    arrival_time TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

-- API request tracking for retry logic
CREATE TABLE IF NOT EXISTS api_requests (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    request_id TEXT UNIQUE NOT NULL,
    endpoint TEXT NOT NULL,
    method TEXT NOT NULL,
    request_data TEXT,
    response_status INTEGER,
    response_data TEXT,
    retry_count INTEGER DEFAULT 0,
    error_message TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_date TIMESTAMP
);

-- Rate limiting tracking
CREATE TABLE IF NOT EXISTS rate_limits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    endpoint TEXT NOT NULL,
    requests_count INTEGER DEFAULT 0,
    window_start TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    window_end TIMESTAMP
);

-- Guest communication templates
CREATE TABLE IF NOT EXISTS communication_templates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    template_name TEXT UNIQUE NOT NULL,
    template_type TEXT NOT NULL,  -- welcome, checkin, checkout, etc.
    subject TEXT,
    body_text TEXT NOT NULL,
    variables TEXT,  -- JSON array of required variables
    active BOOLEAN DEFAULT TRUE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for performance
CREATE INDEX IF NOT EXISTS idx_bookings_property ON bookings(property_id);
CREATE INDEX IF NOT EXISTS idx_bookings_checkin ON bookings(check_in);
CREATE INDEX IF NOT EXISTS idx_bookings_status ON bookings(booking_status);
CREATE INDEX IF NOT EXISTS idx_api_requests_status ON api_requests(response_status);
CREATE INDEX IF NOT EXISTS idx_api_requests_endpoint ON api_requests(endpoint);
EOF
}

# Enhanced credentials template
create_enhanced_credentials_template() {
    cat > "$VRBO_CREDENTIALS" << 'EOF'
{
  "api_type": "expedia_partner",
  "client_id": "your_client_id_here",
  "client_secret": "your_client_secret_here",
  "username": "your_vrbo_username",
  "password": "your_vrbo_password",
  "property_ids": [],
  "webhook_url": "",
  "test_mode": true,
  "rate_limit": {
    "requests_per_minute": 60,
    "requests_per_hour": 1000
  },
  "retry_config": {
    "max_retries": 3,
    "retry_delay": 5,
    "backoff_multiplier": 2,
    "retry_on_status": [429, 500, 502, 503, 504]
  },
  "notification_settings": {
    "email_on_error": true,
    "email_on_new_booking": true,
    "webhook_on_update": false
  }
}
EOF
    chmod 600 "$VRBO_CREDENTIALS"
    
    log_warning "Enhanced VRBO credentials template created at: $VRBO_CREDENTIALS"
    log_info "Please update with your actual API credentials"
}

# Enhanced authentication with token caching and refresh
authenticate_vrbo_enhanced() {
    log_info "Authenticating with VRBO API (enhanced)..."
    
    if [ ! -f "$VRBO_CREDENTIALS" ]; then
        log_error "Credentials file not found: $VRBO_CREDENTIALS"
        return 1
    fi
    
    # Check for cached valid token
    local token_cache="$VRBO_CACHE_DIR/access_token.json"
    if [ -f "$token_cache" ]; then
        local token_expiry=$(jq -r '.expires_at // ""' "$token_cache" 2>/dev/null)
        if [ -n "$token_expiry" ] && [ "$(date +%s)" -lt "$token_expiry" ]; then
            log_info "Using cached access token"
            return 0
        fi
    fi
    
    local client_id
    client_id=$(jq -r '.client_id' "$VRBO_CREDENTIALS")
    local client_secret
    client_secret=$(jq -r '.client_secret' "$VRBO_CREDENTIALS")
    
    if [ "$client_id" = "your_client_id_here" ] || [ "$client_secret" = "your_client_secret_here" ]; then
        log_error "Please configure your VRBO API credentials in $VRBO_CREDENTIALS"
        return 1
    fi
    
    # Request access token with retry logic
    local auth_response
    local retry_count=0
    local success=false
    
    while [ $retry_count -lt $MAX_RETRIES ] && [ "$success" = "false" ]; do
        auth_response=$(curl -s -w '\n%{http_code}' -X POST "$VRBO_AUTH_URL" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -d "grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret" 2>/dev/null || echo "ERROR")
        
        local http_code=$(echo "$auth_response" | tail -n1)
        local response_body=$(echo "$auth_response" | head -n-1)
        
        if [ "$http_code" = "200" ]; then
            local access_token=$(echo "$response_body" | jq -r '.access_token // ""')
            local expires_in=$(echo "$response_body" | jq -r '.expires_in // 3600')
            
            if [ -n "$access_token" ] && [ "$access_token" != "null" ]; then
                # Cache token with expiry
                local expires_at=$(($(date +%s) + expires_in - 300))  # 5 min buffer
                echo "{
                    \"access_token\": \"$access_token\",
                    \"expires_at\": $expires_at,
                    \"obtained_at\": \"$(date -Iseconds)\"
                }" > "$token_cache"
                chmod 600 "$token_cache"
                
                log_success "VRBO authentication successful"
                update_api_metrics "auth" "success"
                success=true
                return 0
            fi
        fi
        
        retry_count=$((retry_count + 1))
        if [ $retry_count -lt $MAX_RETRIES ]; then
            local delay=$((RETRY_DELAY * (BACKOFF_MULTIPLIER ** (retry_count - 1))))
            log_warning "Authentication failed (attempt $retry_count/$MAX_RETRIES), retrying in ${delay}s..."
            sleep $delay
        fi
    done
    
    log_error "Failed to authenticate with VRBO API after $MAX_RETRIES attempts"
    update_api_metrics "auth" "failure"
    return 1
}

# Enhanced API request with retry logic and rate limiting
vrbo_api_request_enhanced() {
    local endpoint="$1"
    local method="${2:-GET}"
    local data="${3:-}"
    local request_id="${4:-$(uuidgen 2>/dev/null || echo "req_$(date +%s)_$$")}"
    
    # Check rate limits
    if ! check_rate_limit "$endpoint"; then
        log_warning "Rate limit exceeded for endpoint: $endpoint"
        return 1
    fi
    
    # Get access token
    local access_token
    access_token=$(get_access_token_enhanced)
    
    if [ -z "$access_token" ]; then
        log_error "No valid access token available"
        return 1
    fi
    
    local url="${VRBO_BASE_URL}${endpoint}"
    local retry_count=0
    local success=false
    local response
    local http_code
    
    # Log request start
    log_api_request "$request_id" "$endpoint" "$method" "$data"
    
    while [ $retry_count -lt $MAX_RETRIES ] && [ "$success" = "false" ]; do
        local start_time=$(date +%s.%N)
        
        case "$method" in
            GET)
                response=$(curl -s -w '\n%{http_code}' \
                    -H "Authorization: Bearer $access_token" \
                    -H "Accept: application/json" \
                    -H "X-Request-ID: $request_id" \
                    "$url" 2>/dev/null || echo "ERROR")
                ;;
            POST)
                response=$(curl -s -w '\n%{http_code}' -X POST \
                    -H "Authorization: Bearer $access_token" \
                    -H "Content-Type: application/json" \
                    -H "Accept: application/json" \
                    -H "X-Request-ID: $request_id" \
                    -d "$data" \
                    "$url" 2>/dev/null || echo "ERROR")
                ;;
            PUT)
                response=$(curl -s -w '\n%{http_code}' -X PUT \
                    -H "Authorization: Bearer $access_token" \
                    -H "Content-Type: application/json" \
                    -H "Accept: application/json" \
                    -H "X-Request-ID: $request_id" \
                    -d "$data" \
                    "$url" 2>/dev/null || echo "ERROR")
                ;;
            DELETE)
                response=$(curl -s -w '\n%{http_code}' -X DELETE \
                    -H "Authorization: Bearer $access_token" \
                    -H "Accept: application/json" \
                    -H "X-Request-ID: $request_id" \
                    "$url" 2>/dev/null || echo "ERROR")
                ;;
            *)
                log_error "Unsupported HTTP method: $method"
                return 1
                ;;
        esac
        
        local end_time=$(date +%s.%N)
        local response_time=$(echo "$end_time - $start_time" | bc)
        
        if [ "$response" = "ERROR" ]; then
            log_error "Network error for request: $method $endpoint"
            retry_count=$((retry_count + 1))
            continue
        fi
        
        http_code=$(echo "$response" | tail -n1)
        local response_body=$(echo "$response" | head -n-1)
        
        # Update request log
        update_api_request "$request_id" "$http_code" "$response_body" "$retry_count"
        
        # Check if request was successful
        if [ "$http_code" -ge 200 ] && [ "$http_code" -lt 300 ]; then
            success=true
            update_api_metrics "$endpoint" "success" "$response_time"
            echo "$response_body"
            return 0
        fi
        
        # Check if we should retry based on status code
        local should_retry=$(should_retry_status "$http_code")
        if [ "$should_retry" = "true" ] && [ $retry_count -lt $((MAX_RETRIES - 1)) ]; then
            retry_count=$((retry_count + 1))
            local delay=$((RETRY_DELAY * (BACKOFF_MULTIPLIER ** (retry_count - 1))))
            
            # Handle specific status codes
            case "$http_code" in
                429)  # Rate limited
                    local retry_after=$(echo "$response" | grep -i "retry-after:" | cut -d' ' -f2)
                    if [ -n "$retry_after" ]; then
                        delay=$retry_after
                    fi
                    log_warning "Rate limited, waiting ${delay}s..."
                    ;;
                401)  # Unauthorized - try to refresh token
                    log_warning "Token expired, refreshing..."
                    rm -f "$VRBO_CACHE_DIR/access_token.json"
                    if authenticate_vrbo_enhanced; then
                        access_token=$(get_access_token_enhanced)
                    else
                        break
                    fi
                    ;;
                *)
                    log_warning "Request failed with status $http_code, retrying in ${delay}s..."
                    ;;
            esac
            
            sleep $delay
        else
            break
        fi
    done
    
    log_error "API request failed after $retry_count retries: $method $endpoint (status: $http_code)"
    update_api_metrics "$endpoint" "failure"
    
    # Return error response if available
    if [ -n "$response_body" ]; then
        echo "$response_body"
    fi
    
    return 1
}

# Check if status code should trigger retry
should_retry_status() {
    local status_code="$1"
    local retry_statuses=$(jq -r '.retry_config.retry_on_status[]' "$VRBO_CREDENTIALS" 2>/dev/null)
    
    if [ -z "$retry_statuses" ]; then
        # Default retry statuses
        case "$status_code" in
            429|500|502|503|504) echo "true" ;;
            *) echo "false" ;;
        esac
    else
        echo "$retry_statuses" | grep -q "^$status_code$" && echo "true" || echo "false"
    fi
}

# Rate limiting check
check_rate_limit() {
    local endpoint="$1"
    local current_time=$(date +%s)
    
    # Get rate limit configuration
    local requests_per_minute=$(jq -r '.rate_limit.requests_per_minute // 60' "$VRBO_CREDENTIALS")
    
    # Check current window
    local window_start=$(sqlite3 "$VRBO_DATA_DB" "
        SELECT strftime('%s', window_start) 
        FROM rate_limits 
        WHERE endpoint = '$endpoint' 
        ORDER BY id DESC 
        LIMIT 1;")
    
    if [ -z "$window_start" ] || [ $((current_time - window_start)) -gt $RATE_LIMIT_WINDOW ]; then
        # Start new window
        sqlite3 "$VRBO_DATA_DB" "
            INSERT INTO rate_limits (endpoint, requests_count, window_start)
            VALUES ('$endpoint', 1, datetime('now'));"
        return 0
    fi
    
    # Check requests in current window
    local requests_count=$(sqlite3 "$VRBO_DATA_DB" "
        SELECT requests_count 
        FROM rate_limits 
        WHERE endpoint = '$endpoint' 
        ORDER BY id DESC 
        LIMIT 1;")
    
    if [ "$requests_count" -lt "$requests_per_minute" ]; then
        # Increment counter
        sqlite3 "$VRBO_DATA_DB" "
            UPDATE rate_limits 
            SET requests_count = requests_count + 1 
            WHERE endpoint = '$endpoint' 
            AND id = (SELECT MAX(id) FROM rate_limits WHERE endpoint = '$endpoint');"
        return 0
    fi
    
    return 1
}

# Get cached access token
get_access_token_enhanced() {
    local token_file="$VRBO_CACHE_DIR/access_token.json"
    
    if [ ! -f "$token_file" ] || [ ! -s "$token_file" ]; then
        if ! authenticate_vrbo_enhanced; then
            return 1
        fi
    fi
    
    jq -r '.access_token // ""' "$token_file"
}

# Log API request
log_api_request() {
    local request_id="$1"
    local endpoint="$2"
    local method="$3"
    local request_data="$4"
    
    sqlite3 "$VRBO_DATA_DB" "
        INSERT INTO api_requests (request_id, endpoint, method, request_data)
        VALUES ('$request_id', '$endpoint', '$method', '$request_data');"
}

# Update API request log
update_api_request() {
    local request_id="$1"
    local status="$2"
    local response_data="$3"
    local retry_count="$4"
    
    sqlite3 "$VRBO_DATA_DB" "
        UPDATE api_requests 
        SET response_status = $status,
            response_data = '$response_data',
            retry_count = $retry_count,
            completed_date = datetime('now')
        WHERE request_id = '$request_id';"
}

# Update API metrics
update_api_metrics() {
    local endpoint="$1"
    local status="$2"
    local response_time="${3:-0}"
    
    # Update metrics file
    local metrics=$(cat "$VRBO_METRICS_FILE")
    
    # Increment counters
    metrics=$(echo "$metrics" | jq ".api_calls.total += 1")
    
    if [ "$status" = "success" ]; then
        metrics=$(echo "$metrics" | jq ".api_calls.successful += 1")
    else
        metrics=$(echo "$metrics" | jq ".api_calls.failed += 1")
    fi
    
    # Update average response time
    if [ "$response_time" != "0" ]; then
        local total_calls=$(echo "$metrics" | jq -r '.api_calls.total')
        local avg_time=$(echo "$metrics" | jq -r '.performance.average_response_time')
        local new_avg=$(echo "scale=3; ($avg_time * ($total_calls - 1) + $response_time) / $total_calls" | bc)
        metrics=$(echo "$metrics" | jq ".performance.average_response_time = $new_avg")
    fi
    
    echo "$metrics" > "$VRBO_METRICS_FILE"
}

# Enhanced property sync with error recovery
sync_properties_enhanced() {
    log_info "Starting enhanced property synchronization..."
    
    local properties_response
    properties_response=$(vrbo_api_request_enhanced "/property/v1/properties")
    
    if [ $? -ne 0 ]; then
        log_error "Failed to fetch properties"
        
        # Check for partial sync data in retry queue
        if [ -f "$VRBO_CONFIG_DIR/retry_queue/properties_sync.json" ]; then
            log_info "Resuming from partial sync..."
            properties_response=$(cat "$VRBO_CONFIG_DIR/retry_queue/properties_sync.json")
        else
            return 1
        fi
    fi
    
    # Save sync state for recovery
    echo "$properties_response" > "$VRBO_CONFIG_DIR/retry_queue/properties_sync.json"
    
    local sync_count=0
    local error_count=0
    
    # Parse and store properties with error handling
    echo "$properties_response" | jq -c '.properties[]?' 2>/dev/null | while read -r property; do
        if process_property_enhanced "$property"; then
            sync_count=$((sync_count + 1))
        else
            error_count=$((error_count + 1))
            # Log failed property for manual review
            echo "$property" >> "$VRBO_LOGS_DIR/failed_properties_$(date +%Y%m%d).json"
        fi
        
        # Progress notification every 10 properties
        if [ $((sync_count % 10)) -eq 0 ]; then
            log_info "Processed $sync_count properties..."
        fi
    done
    
    # Clean up successful sync
    rm -f "$VRBO_CONFIG_DIR/retry_queue/properties_sync.json"
    
    # Update sync status
    local total_properties=$(sqlite3 "$VRBO_DATA_DB" "SELECT COUNT(*) FROM properties WHERE sync_status = 'active';")
    
    log_success "Enhanced sync completed: $total_properties active properties"
    
    if [ $error_count -gt 0 ]; then
        log_warning "Failed to sync $error_count properties - check logs for details"
        notify_error "VRBO Sync" "Failed to sync $error_count properties"
    fi
    
    # Generate sync report
    generate_sync_report "properties" $sync_count $error_count
}

# Process individual property with validation
process_property_enhanced() {
    local property_json="$1"
    
    # Validate required fields
    local property_id=$(echo "$property_json" | jq -r '.propertyId // ""')
    if [ -z "$property_id" ]; then
        log_error "Invalid property data: missing propertyId"
        return 1
    fi
    
    # Extract all fields with defaults
    local name=$(echo "$property_json" | jq -r '.name // "Unknown Property"' | sed "s/'/''/g")
    local address=$(echo "$property_json" | jq -r '.address.line1 // ""' | sed "s/'/''/g")
    local city=$(echo "$property_json" | jq -r '.address.city // ""' | sed "s/'/''/g")
    local state=$(echo "$property_json" | jq -r '.address.stateProvinceCode // ""' | sed "s/'/''/g")
    local country=$(echo "$property_json" | jq -r '.address.countryCode // ""' | sed "s/'/''/g")
    local property_type=$(echo "$property_json" | jq -r '.propertyType // ""' | sed "s/'/''/g")
    local bedrooms=$(echo "$property_json" | jq -r '.bedrooms // 0')
    local bathrooms=$(echo "$property_json" | jq -r '.bathrooms // 0')
    local max_guests=$(echo "$property_json" | jq -r '.maxGuests // 0')
    local amenities=$(echo "$property_json" | jq -c '.amenities // []' | sed "s/'/''/g")
    local house_rules=$(echo "$property_json" | jq -c '.houseRules // {}' | sed "s/'/''/g")
    local cancellation_policy=$(echo "$property_json" | jq -r '.cancellationPolicy // "moderate"' | sed "s/'/''/g")
    local instant_book=$(echo "$property_json" | jq -r '.instantBookEnabled // false')
    local base_rate=$(echo "$property_json" | jq -r '.baseRate // 0')
    local cleaning_fee=$(echo "$property_json" | jq -r '.cleaningFee // 0')
    
    # Insert or update property with error handling
    local sql_result
    sql_result=$(sqlite3 "$VRBO_DATA_DB" 2>&1 << EOF
INSERT OR REPLACE INTO properties 
(vrbo_property_id, name, address, city, state, country, property_type, 
 bedrooms, bathrooms, max_guests, amenities, house_rules, cancellation_policy,
 instant_book_enabled, base_rate, cleaning_fee, last_updated, sync_status, sync_errors)
VALUES ('$property_id', '$name', '$address', '$city', '$state', '$country', '$property_type',
        $bedrooms, $bathrooms, $max_guests, '$amenities', '$house_rules', '$cancellation_policy',
        $instant_book, $base_rate, $cleaning_fee, CURRENT_TIMESTAMP, 'active', 0);
EOF
)
    
    if [ $? -eq 0 ]; then
        log_debug "Synced property: $name ($property_id)"
        return 0
    else
        log_error "Failed to sync property $property_id: $sql_result"
        
        # Update error count for property
        sqlite3 "$VRBO_DATA_DB" "
            UPDATE properties 
            SET sync_errors = sync_errors + 1, 
                sync_status = CASE WHEN sync_errors >= 5 THEN 'error' ELSE sync_status END
            WHERE vrbo_property_id = '$property_id';"
        
        return 1
    fi
}

# Enhanced booking sync with guest preferences
sync_bookings_enhanced() {
    log_info "Starting enhanced booking synchronization..."
    
    local active_properties=$(sqlite3 "$VRBO_DATA_DB" "SELECT vrbo_property_id FROM properties WHERE sync_status = 'active';")
    
    if [ -z "$active_properties" ]; then
        log_warning "No active properties to sync bookings for"
        return 1
    fi
    
    local total_bookings=0
    local new_bookings=0
    local updated_bookings=0
    
    echo "$active_properties" | while read -r property_id; do
        log_debug "Fetching bookings for property: $property_id"
        
        local bookings_response
        bookings_response=$(vrbo_api_request_enhanced "/booking/v1/properties/$property_id/bookings")
        
        if [ $? -eq 0 ]; then
            # Process bookings for this property
            echo "$bookings_response" | jq -c '.bookings[]?' 2>/dev/null | while read -r booking; do
                local result=$(process_booking_enhanced "$booking" "$property_id")
                case "$result" in
                    "new") new_bookings=$((new_bookings + 1)) ;;
                    "updated") updated_bookings=$((updated_bookings + 1)) ;;
                esac
                total_bookings=$((total_bookings + 1))
            done
        else
            log_warning "Failed to fetch bookings for property: $property_id"
        fi
        
        # Rate limit compliance
        sleep 1
    done
    
    log_success "Booking sync completed: $total_bookings total, $new_bookings new, $updated_bookings updated"
    
    # Send notification for new bookings
    if [ $new_bookings -gt 0 ]; then
        notify_success "New Bookings" "$new_bookings new booking(s) received!"
    fi
    
    # Generate sync report
    generate_sync_report "bookings" $total_bookings 0
}

# Process individual booking with enhanced data
process_booking_enhanced() {
    local booking_json="$1"
    local property_vrbo_id="$2"
    
    # Get internal property ID
    local property_id=$(sqlite3 "$VRBO_DATA_DB" "SELECT id FROM properties WHERE vrbo_property_id = '$property_vrbo_id' LIMIT 1;")
    
    if [ -z "$property_id" ]; then
        log_error "Property not found: $property_vrbo_id"
        return 1
    fi
    
    # Extract booking data
    local booking_id=$(echo "$booking_json" | jq -r '.bookingId // ""')
    local guest_name=$(echo "$booking_json" | jq -r '.guestName // "Unknown Guest"' | sed "s/'/''/g")
    local guest_email=$(echo "$booking_json" | jq -r '.guestEmail // ""' | sed "s/'/''/g")
    local guest_phone=$(echo "$booking_json" | jq -r '.guestPhone // ""' | sed "s/'/''/g")
    local guest_preferences=$(echo "$booking_json" | jq -c '.guestPreferences // {}' | sed "s/'/''/g")
    local check_in=$(echo "$booking_json" | jq -r '.checkInDate // ""')
    local check_out=$(echo "$booking_json" | jq -r '.checkOutDate // ""')
    local adults=$(echo "$booking_json" | jq -r '.adults // 1')
    local children=$(echo "$booking_json" | jq -r '.children // 0')
    local pets=$(echo "$booking_json" | jq -r '.pets // 0')
    local total_amount=$(echo "$booking_json" | jq -r '.totalAmount // 0')
    local paid_amount=$(echo "$booking_json" | jq -r '.paidAmount // 0')
    local booking_status=$(echo "$booking_json" | jq -r '.status // "pending"' | sed "s/'/''/g")
    local payment_status=$(echo "$booking_json" | jq -r '.paymentStatus // "pending"' | sed "s/'/''/g")
    local special_requests=$(echo "$booking_json" | jq -r '.specialRequests // ""' | sed "s/'/''/g")
    local arrival_time=$(echo "$booking_json" | jq -r '.arrivalTime // ""' | sed "s/'/''/g")
    
    # Calculate nights
    local nights=0
    if [ -n "$check_in" ] && [ -n "$check_out" ]; then
        nights=$(( ( $(date -d "$check_out" +%s) - $(date -d "$check_in" +%s) ) / 86400 ))
    fi
    
    # Check if booking exists
    local existing_booking=$(sqlite3 "$VRBO_DATA_DB" "SELECT id FROM bookings WHERE vrbo_booking_id = '$booking_id' LIMIT 1;")
    
    if [ -n "$existing_booking" ]; then
        # Update existing booking
        sqlite3 "$VRBO_DATA_DB" << EOF
UPDATE bookings SET
    guest_name = '$guest_name',
    guest_email = '$guest_email',
    guest_phone = '$guest_phone',
    guest_preferences = '$guest_preferences',
    check_in = '$check_in',
    check_out = '$check_out',
    nights = $nights,
    adults = $adults,
    children = $children,
    pets = $pets,
    total_amount = $total_amount,
    paid_amount = $paid_amount,
    booking_status = '$booking_status',
    payment_status = '$payment_status',
    special_requests = '$special_requests',
    arrival_time = '$arrival_time',
    last_updated = CURRENT_TIMESTAMP
WHERE vrbo_booking_id = '$booking_id';
EOF
        echo "updated"
    else
        # Insert new booking
        sqlite3 "$VRBO_DATA_DB" << EOF
INSERT INTO bookings 
(vrbo_booking_id, property_id, guest_name, guest_email, guest_phone, guest_preferences,
 check_in, check_out, nights, adults, children, pets, total_amount, paid_amount,
 booking_status, payment_status, special_requests, arrival_time)
VALUES ('$booking_id', $property_id, '$guest_name', '$guest_email', '$guest_phone', '$guest_preferences',
        '$check_in', '$check_out', $nights, $adults, $children, $pets, $total_amount, $paid_amount,
        '$booking_status', '$payment_status', '$special_requests', '$arrival_time');
EOF
        
        # Trigger automated guest communication for new bookings
        if [ "$booking_status" = "confirmed" ]; then
            schedule_guest_communications "$booking_id"
        fi
        
        echo "new"
    fi
}

# Schedule automated guest communications
schedule_guest_communications() {
    local booking_id="$1"
    
    # Get booking details
    local booking_data=$(sqlite3 "$VRBO_DATA_DB" -json "
        SELECT b.*, p.name as property_name, p.address as property_address
        FROM bookings b
        JOIN properties p ON b.property_id = p.id
        WHERE b.vrbo_booking_id = '$booking_id'
        LIMIT 1;" | jq -r '.[0]')
    
    if [ -z "$booking_data" ] || [ "$booking_data" = "null" ]; then
        log_error "Booking not found: $booking_id"
        return 1
    fi
    
    local check_in=$(echo "$booking_data" | jq -r '.check_in')
    local guest_email=$(echo "$booking_data" | jq -r '.guest_email')
    
    # Schedule welcome email (immediate)
    create_communication_task "welcome" "$booking_id" "immediate"
    
    # Schedule check-in instructions (24 hours before)
    create_communication_task "checkin_instructions" "$booking_id" "$(date -d "$check_in -1 day" +%Y-%m-%d)"
    
    # Schedule checkout reminder (morning of checkout)
    local check_out=$(echo "$booking_data" | jq -r '.check_out')
    create_communication_task "checkout_reminder" "$booking_id" "$check_out"
    
    # Schedule review request (1 day after checkout)
    create_communication_task "review_request" "$booking_id" "$(date -d "$check_out +1 day" +%Y-%m-%d)"
    
    log_info "Scheduled guest communications for booking: $booking_id"
}

# Create communication task
create_communication_task() {
    local task_type="$1"
    local booking_id="$2"
    local send_date="$3"
    
    # This would integrate with the guest communication service
    echo "{
        \"task_type\": \"$task_type\",
        \"booking_id\": \"$booking_id\",
        \"send_date\": \"$send_date\",
        \"status\": \"scheduled\"
    }" >> "$VRBO_CONFIG_DIR/communication_queue.jsonl"
}

# Generate sync report
generate_sync_report() {
    local sync_type="$1"
    local success_count="$2"
    local error_count="$3"
    
    local report_file="$VRBO_LOGS_DIR/sync_report_$(date +%Y%m%d_%H%M%S).json"
    
    cat > "$report_file" << EOF
{
    "sync_type": "$sync_type",
    "timestamp": "$(date -Iseconds)",
    "results": {
        "successful": $success_count,
        "failed": $error_count,
        "total": $((success_count + error_count))
    },
    "metrics": $(cat "$VRBO_METRICS_FILE"),
    "duration_seconds": $SECONDS
}
EOF
    
    log_info "Sync report generated: $report_file"
}

# Get comprehensive API health status
get_api_health_status() {
    echo "🏥 VRBO API HEALTH STATUS"
    echo "========================"
    echo ""
    
    # Load metrics
    local metrics=$(cat "$VRBO_METRICS_FILE")
    
    # API call statistics
    echo "📊 API Call Statistics:"
    echo "Total Calls: $(echo "$metrics" | jq -r '.api_calls.total')"
    echo "Successful: $(echo "$metrics" | jq -r '.api_calls.successful')"
    echo "Failed: $(echo "$metrics" | jq -r '.api_calls.failed')"
    echo "Success Rate: $(echo "$metrics" | jq -r '(.api_calls.successful / .api_calls.total * 100) | floor')%"
    echo ""
    
    # Performance metrics
    echo "⚡ Performance Metrics:"
    echo "Avg Response Time: $(echo "$metrics" | jq -r '.performance.average_response_time')s"
    echo "Last 24h Uptime: $(echo "$metrics" | jq -r '.performance.last_24h_uptime')%"
    echo ""
    
    # Recent errors
    echo "❌ Recent Errors (Last 24h):"
    sqlite3 "$VRBO_DATA_DB" -column -header << 'EOF'
SELECT endpoint, response_status, COUNT(*) as count
FROM api_requests
WHERE response_status >= 400
AND created_date > datetime('now', '-1 day')
GROUP BY endpoint, response_status
ORDER BY count DESC
LIMIT 5;
EOF
    echo ""
    
    # Rate limit status
    echo "🚦 Rate Limit Status:"
    sqlite3 "$VRBO_DATA_DB" -column -header << 'EOF'
SELECT endpoint, requests_count, 
       datetime(window_start) as window_start
FROM rate_limits
WHERE id IN (
    SELECT MAX(id) FROM rate_limits GROUP BY endpoint
)
ORDER BY requests_count DESC
LIMIT 5;
EOF
}

# Export functions
export -f init_vrbo_enhanced authenticate_vrbo_enhanced vrbo_api_request_enhanced
export -f sync_properties_enhanced sync_bookings_enhanced get_api_health_status
export -f check_rate_limit update_api_metrics generate_sync_report

# Initialize on first source
if [ ! -f "$VRBO_CONFIG_DIR/.vrbo-enhanced-initialized" ]; then
    init_vrbo_enhanced
    touch "$VRBO_CONFIG_DIR/.vrbo-enhanced-initialized"
fi

# Main function for testing
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    case "${1:-}" in
        health) get_api_health_status ;;
        sync-properties) sync_properties_enhanced ;;
        sync-bookings) sync_bookings_enhanced ;;
        *) echo "Usage: $0 {health|sync-properties|sync-bookings}" ;;
    esac
fi