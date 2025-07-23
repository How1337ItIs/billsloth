#!/bin/bash
# LLM_CAPABILITY: local_ok  
# VRBO API Integration Library for Bill Sloth
# Real API integration for vacation rental management

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/input_sanitization.sh" 2>/dev/null || true

# Configuration
VRBO_CONFIG_DIR="$HOME/.bill-sloth/vrbo"
VRBO_CREDENTIALS="$VRBO_CONFIG_DIR/credentials.json"
VRBO_CACHE_DIR="$VRBO_CONFIG_DIR/cache"
VRBO_LOGS_DIR="$VRBO_CONFIG_DIR/logs"
VRBO_DATA_DB="$VRBO_CONFIG_DIR/vrbo_data.db"

# VRBO API endpoints (using Expedia Partner API)
VRBO_BASE_URL="https://api.expediapartnercentral.com"
VRBO_AUTH_URL="https://api.expediapartnercentral.com/authentication/v1/token"

# Initialize VRBO integration
init_vrbo_integration() {
    log_info "Initializing VRBO API integration..."
    
    # Create directories
    safe_mkdir "$VRBO_CONFIG_DIR" 700
    safe_mkdir "$VRBO_CACHE_DIR" 755
    safe_mkdir "$VRBO_LOGS_DIR" 755
    
    # Initialize database
    init_vrbo_database
    
    # Create credentials template if not exists
    if [ ! -f "$VRBO_CREDENTIALS" ]; then
        create_credentials_template
    fi
    
    log_success "VRBO integration initialized"
}

# Create SQLite database for VRBO data
init_vrbo_database() {
    sqlite3 "$VRBO_DATA_DB" << 'EOF'
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
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    vrbo_booking_id TEXT UNIQUE NOT NULL,
    property_id INTEGER,
    guest_name TEXT NOT NULL,
    guest_email TEXT,
    guest_phone TEXT,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    nights INTEGER NOT NULL,
    adults INTEGER,
    children INTEGER,
    total_amount DECIMAL(10,2),
    currency TEXT DEFAULT 'USD',
    booking_status TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

CREATE TABLE IF NOT EXISTS rates (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    property_id INTEGER,
    date DATE NOT NULL,
    rate DECIMAL(10,2),
    currency TEXT DEFAULT 'USD',
    available BOOLEAN DEFAULT TRUE,
    minimum_stay INTEGER DEFAULT 1,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id)
);

CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    booking_id INTEGER,
    direction TEXT, -- 'inbound' or 'outbound'
    subject TEXT,
    message_text TEXT,
    sent_date TIMESTAMP,
    read_status BOOLEAN DEFAULT FALSE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);

CREATE TABLE IF NOT EXISTS reviews (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    property_id INTEGER,
    booking_id INTEGER,
    rating INTEGER,
    review_text TEXT,
    guest_name TEXT,
    review_date DATE,
    response_text TEXT,
    response_date DATE,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (property_id) REFERENCES properties(id),
    FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
EOF
}

# Create credentials template
create_credentials_template() {
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
  }
}
EOF
    chmod 600 "$VRBO_CREDENTIALS"
    
    log_warning "VRBO credentials template created at: $VRBO_CREDENTIALS"
    log_info "Please update with your actual API credentials"
}

# Authenticate with VRBO API
authenticate_vrbo() {
    log_info "Authenticating with VRBO API..."
    
    if [ ! -f "$VRBO_CREDENTIALS" ]; then
        log_error "Credentials file not found: $VRBO_CREDENTIALS"
        return 1
    fi
    
    local client_id
    client_id=$(jq -r '.client_id' "$VRBO_CREDENTIALS")
    local client_secret
    client_secret=$(jq -r '.client_secret' "$VRBO_CREDENTIALS")
    
    if [ "$client_id" = "your_client_id_here" ] || [ "$client_secret" = "your_client_secret_here" ]; then
        log_error "Please configure your VRBO API credentials in $VRBO_CREDENTIALS"
        return 1
    fi
    
    # Request access token
    local auth_response
    auth_response=$(curl -s -X POST "$VRBO_AUTH_URL" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=client_credentials&client_id=$client_id&client_secret=$client_secret" 2>/dev/null || echo "ERROR")
    
    if [ "$auth_response" = "ERROR" ]; then
        log_error "Failed to authenticate with VRBO API"
        return 1
    fi
    
    local access_token
    access_token=$(echo "$auth_response" | jq -r '.access_token // "ERROR"')
    
    if [ "$access_token" = "ERROR" ] || [ "$access_token" = "null" ]; then
        log_error "Invalid authentication response from VRBO API"
        return 1
    fi
    
    # Store token temporarily (in production, handle token refresh)
    echo "$access_token" > "$VRBO_CACHE_DIR/access_token"
    chmod 600 "$VRBO_CACHE_DIR/access_token"
    
    log_success "VRBO authentication successful"
    return 0
}

# Get access token
get_access_token() {
    local token_file="$VRBO_CACHE_DIR/access_token"
    
    if [ ! -f "$token_file" ] || [ ! -s "$token_file" ]; then
        if ! authenticate_vrbo; then
            return 1
        fi
    fi
    
    cat "$token_file"
}

# Make authenticated API request
vrbo_api_request() {
    local endpoint="$1"
    local method="${2:-GET}"
    local data="${3:-}"
    
    local access_token
    access_token=$(get_access_token)
    
    if [ -z "$access_token" ]; then
        log_error "No valid access token available"
        return 1
    fi
    
    local url="${VRBO_BASE_URL}${endpoint}"
    local response
    
    case "$method" in
        GET)
            response=$(curl -s -H "Authorization: Bearer $access_token" \
                           -H "Accept: application/json" \
                           "$url" 2>/dev/null || echo "ERROR")
            ;;
        POST)
            response=$(curl -s -X POST \
                           -H "Authorization: Bearer $access_token" \
                           -H "Content-Type: application/json" \
                           -H "Accept: application/json" \
                           -d "$data" \
                           "$url" 2>/dev/null || echo "ERROR")
            ;;
        PUT)
            response=$(curl -s -X PUT \
                           -H "Authorization: Bearer $access_token" \
                           -H "Content-Type: application/json" \
                           -H "Accept: application/json" \
                           -d "$data" \
                           "$url" 2>/dev/null || echo "ERROR")
            ;;
        *)
            log_error "Unsupported HTTP method: $method"
            return 1
            ;;
    esac
    
    if [ "$response" = "ERROR" ]; then
        log_error "API request failed: $method $endpoint"
        return 1
    fi
    
    echo "$response"
}

# Sync properties from VRBO
sync_properties() {
    log_info "Syncing properties from VRBO..."
    
    local properties_response
    properties_response=$(vrbo_api_request "/property/v1/properties")
    
    if [ $? -ne 0 ]; then
        log_error "Failed to fetch properties"
        return 1
    fi
    
    # Parse and store properties
    echo "$properties_response" | jq -c '.properties[]?' 2>/dev/null | while read -r property; do
        local property_id
        property_id=$(echo "$property" | jq -r '.propertyId')
        local name
        name=$(echo "$property" | jq -r '.name // "Unknown Property"')
        local address
        address=$(echo "$property" | jq -r '.address.line1 // ""')
        local city
        city=$(echo "$property" | jq -r '.address.city // ""')
        local state
        state=$(echo "$property" | jq -r '.address.stateProvinceCode // ""')
        local country
        country=$(echo "$property" | jq -r '.address.countryCode // ""')
        local property_type
        property_type=$(echo "$property" | jq -r '.propertyType // ""')
        local bedrooms
        bedrooms=$(echo "$property" | jq -r '.bedrooms // 0')
        local bathrooms
        bathrooms=$(echo "$property" | jq -r '.bathrooms // 0')
        local max_guests
        max_guests=$(echo "$property" | jq -r '.maxGuests // 0')
        
        # Insert or update property
        sqlite3 "$VRBO_DATA_DB" << EOF
INSERT OR REPLACE INTO properties 
(vrbo_property_id, name, address, city, state, country, property_type, bedrooms, bathrooms, max_guests, last_updated)
VALUES ('$property_id', '$name', '$address', '$city', '$state', '$country', '$property_type', $bedrooms, $bathrooms, $max_guests, CURRENT_TIMESTAMP);
EOF
        
        log_debug "Synced property: $name ($property_id)"
    done
    
    local property_count
    property_count=$(sqlite3 "$VRBO_DATA_DB" "SELECT COUNT(*) FROM properties;")
    
    log_success "Synced $property_count properties"
}

# Sync bookings from VRBO
sync_bookings() {
    log_info "Syncing bookings from VRBO..."
    
    # Get property IDs from database
    sqlite3 "$VRBO_DATA_DB" "SELECT vrbo_property_id FROM properties;" | while read -r property_id; do
        log_debug "Fetching bookings for property: $property_id"
        
        local bookings_response
        bookings_response=$(vrbo_api_request "/booking/v1/properties/$property_id/bookings")
        
        if [ $? -eq 0 ]; then
            # Parse and store bookings
            echo "$bookings_response" | jq -c '.bookings[]?' 2>/dev/null | while read -r booking; do
                local booking_id
                booking_id=$(echo "$booking" | jq -r '.bookingId')
                local guest_name
                guest_name=$(echo "$booking" | jq -r '.guestName // "Unknown Guest"')
                local guest_email
                guest_email=$(echo "$booking" | jq -r '.guestEmail // ""')
                local check_in
                check_in=$(echo "$booking" | jq -r '.checkInDate')
                local check_out
                check_out=$(echo "$booking" | jq -r '.checkOutDate')
                local total_amount
                total_amount=$(echo "$booking" | jq -r '.totalAmount // 0')
                local booking_status
                booking_status=$(echo "$booking" | jq -r '.status // ""')
                
                # Calculate nights
                local nights
                nights=$(( ( $(date -d "$check_out" +%s) - $(date -d "$check_in" +%s) ) / 86400 ))
                
                # Get internal property ID
                local internal_property_id
                internal_property_id=$(sqlite3 "$VRBO_DATA_DB" "SELECT id FROM properties WHERE vrbo_property_id = '$property_id' LIMIT 1;")
                
                # Insert or update booking
                sqlite3 "$VRBO_DATA_DB" << EOF
INSERT OR REPLACE INTO bookings 
(vrbo_booking_id, property_id, guest_name, guest_email, check_in, check_out, nights, total_amount, booking_status, last_updated)
VALUES ('$booking_id', $internal_property_id, '$guest_name', '$guest_email', '$check_in', '$check_out', $nights, $total_amount, '$booking_status', CURRENT_TIMESTAMP);
EOF
                
                log_debug "Synced booking: $guest_name ($check_in to $check_out)"
            done
        fi
    done
    
    local booking_count
    booking_count=$(sqlite3 "$VRBO_DATA_DB" "SELECT COUNT(*) FROM bookings;")
    
    log_success "Synced $booking_count bookings"
}

# Send message to guest
send_guest_message() {
    local booking_id="$1"
    local subject="$2"
    local message_text="$3"
    
    # Sanitize inputs
    booking_id=$(sanitize_input "$booking_id" false)
    subject=$(sanitize_input "$subject" true)
    message_text=$(sanitize_input "$message_text" true)
    
    log_info "Sending message to guest for booking: $booking_id"
    
    # Create message payload
    local message_payload
    message_payload=$(jq -n \
        --arg subject "$subject" \
        --arg message "$message_text" \
        '{
            subject: $subject,
            message: $message
        }')
    
    local response
    response=$(vrbo_api_request "/messaging/v1/bookings/$booking_id/messages" "POST" "$message_payload")
    
    if [ $? -eq 0 ]; then
        # Store message in database
        local internal_booking_id
        internal_booking_id=$(sqlite3 "$VRBO_DATA_DB" "SELECT id FROM bookings WHERE vrbo_booking_id = '$booking_id' LIMIT 1;")
        
        sqlite3 "$VRBO_DATA_DB" << EOF
INSERT INTO messages (booking_id, direction, subject, message_text, sent_date)
VALUES ($internal_booking_id, 'outbound', '$subject', '$message_text', CURRENT_TIMESTAMP);
EOF
        
        log_success "Message sent successfully"
        return 0
    else
        log_error "Failed to send message"
        return 1
    fi
}

# Update property rates
update_property_rates() {
    local property_id="$1"
    local start_date="$2"
    local end_date="$3"
    local rate="$4"
    local available="${5:-true}"
    
    # Sanitize inputs
    property_id=$(sanitize_input "$property_id" false)
    start_date=$(sanitize_input "$start_date" false)
    end_date=$(sanitize_input "$end_date" false)
    rate=$(sanitize_number "$rate" 0 10000)
    
    log_info "Updating rates for property $property_id from $start_date to $end_date"
    
    # Create rate payload
    local rate_payload
    rate_payload=$(jq -n \
        --arg start "$start_date" \
        --arg end "$end_date" \
        --argjson rate "$rate" \
        --argjson available "$available" \
        '{
            dateRange: {
                start: $start,
                end: $end
            },
            rate: $rate,
            available: $available
        }')
    
    local response
    response=$(vrbo_api_request "/rates/v1/properties/$property_id/rates" "PUT" "$rate_payload")
    
    if [ $? -eq 0 ]; then
        log_success "Rates updated successfully"
        return 0
    else
        log_error "Failed to update rates"
        return 1
    fi
}

# Get property performance stats
get_property_stats() {
    local property_id="${1:-all}"
    
    echo "📊 VRBO PROPERTY PERFORMANCE"
    echo "==========================="
    echo ""
    
    if [ "$property_id" = "all" ]; then
        # Overall stats
        local total_properties
        total_properties=$(sqlite3 "$VRBO_DATA_DB" "SELECT COUNT(*) FROM properties;")
        local total_bookings
        total_bookings=$(sqlite3 "$VRBO_DATA_DB" "SELECT COUNT(*) FROM bookings;")
        local total_revenue
        total_revenue=$(sqlite3 "$VRBO_DATA_DB" "SELECT COALESCE(SUM(total_amount), 0) FROM bookings;")
        
        echo "🏠 Portfolio Summary:"
        echo "Properties: $total_properties"
        echo "Total Bookings: $total_bookings"
        echo "Total Revenue: \$$(printf "%.2f" "$total_revenue")"
        echo ""
        
        # Top performing properties
        echo "🏆 Top Properties by Revenue:"
        sqlite3 "$VRBO_DATA_DB" -header -column << 'EOF'
SELECT 
    p.name as "Property",
    COUNT(b.id) as "Bookings",
    COALESCE(SUM(b.total_amount), 0) as "Revenue",
    AVG(b.total_amount) as "Avg Booking"
FROM properties p
LEFT JOIN bookings b ON p.id = b.property_id
GROUP BY p.id, p.name
ORDER BY Revenue DESC
LIMIT 5;
EOF
    else
        # Specific property stats
        echo "📈 Property Performance: $property_id"
        sqlite3 "$VRBO_DATA_DB" -header -column << EOF
SELECT 
    guest_name as "Guest",
    check_in as "Check In",
    check_out as "Check Out",
    nights as "Nights",
    total_amount as "Revenue",
    booking_status as "Status"
FROM bookings b
JOIN properties p ON b.property_id = p.id
WHERE p.vrbo_property_id = '$property_id'
ORDER BY check_in DESC
LIMIT 10;
EOF
    fi
}

# VRBO integration menu
vrbo_integration_menu() {
    while true; do
        clear
        echo "🏠 VRBO API INTEGRATION"
        echo "======================="
        echo ""
        echo "Real VRBO API integration for property management"
        echo ""
        echo "1) 🔑 Setup Credentials"
        echo "2) 🔄 Sync Properties"
        echo "3) 📅 Sync Bookings"
        echo "4) 💬 Send Guest Message"
        echo "5) 💰 Update Rates"
        echo "6) 📊 Property Stats"
        echo "7) 🔧 Test API Connection"
        echo "8) 🚪 Exit"
        echo ""
        
        local choice
        choice=$(safe_prompt "Choose option (1-8)" "1" 1 false)
        
        case "$choice" in
            1) 
                echo "📝 Please edit the credentials file:"
                echo "$VRBO_CREDENTIALS"
                echo ""
                echo "You need to obtain API credentials from VRBO/Expedia Partner Central"
                ;;
            2) sync_properties ;;
            3) sync_bookings ;;
            4)
                local booking_id
                booking_id=$(safe_prompt "Booking ID")
                local subject
                subject=$(safe_prompt "Message subject")
                local message
                message=$(safe_prompt "Message text")
                send_guest_message "$booking_id" "$subject" "$message"
                ;;
            5)
                local prop_id
                prop_id=$(safe_prompt "Property ID")
                local start_date
                start_date=$(safe_prompt "Start date (YYYY-MM-DD)")
                local end_date
                end_date=$(safe_prompt "End date (YYYY-MM-DD)")
                local rate
                rate=$(safe_prompt "Rate per night")
                update_property_rates "$prop_id" "$start_date" "$end_date" "$rate"
                ;;
            6)
                local prop_id
                prop_id=$(safe_prompt "Property ID (or 'all')" "all")
                get_property_stats "$prop_id"
                ;;
            7) authenticate_vrbo ;;
            8) echo "VRBO integration terminated."; break ;;
            *) echo "Invalid choice. Please select 1-8." && sleep 2 ;;
        esac
        
        if [ "$choice" != "8" ]; then
            echo ""
            safe_prompt "Press Enter to continue..." ""
        fi
    done
}

# Export functions
export -f init_vrbo_integration authenticate_vrbo sync_properties sync_bookings
export -f send_guest_message update_property_rates get_property_stats
export -f vrbo_integration_menu vrbo_api_request

# Initialize on first source
if [ ! -f "$VRBO_CONFIG_DIR/.vrbo-initialized" ]; then
    init_vrbo_integration
    touch "$VRBO_CONFIG_DIR/.vrbo-initialized"
fi

# Main function for standalone execution
main() {
    local command="${1:-menu}"
    shift || true
    
    case "$command" in
        init) init_vrbo_integration ;;
        auth) authenticate_vrbo ;;
        sync-properties) sync_properties ;;
        sync-bookings) sync_bookings ;;
        send-message) send_guest_message "$@" ;;
        update-rates) update_property_rates "$@" ;;
        stats) get_property_stats "$@" ;;
        menu) vrbo_integration_menu ;;
        *)
            echo "Usage: $0 {init|auth|sync-properties|sync-bookings|send-message|update-rates|stats|menu}"
            echo ""
            echo "Commands:"
            echo "  init           - Initialize VRBO integration"
            echo "  auth           - Authenticate with VRBO API"
            echo "  sync-properties - Sync properties from VRBO"
            echo "  sync-bookings  - Sync bookings from VRBO"
            echo "  send-message   - Send message to guest"
            echo "  update-rates   - Update property rates"
            echo "  stats          - Show property statistics"
            echo "  menu           - Interactive management menu"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi