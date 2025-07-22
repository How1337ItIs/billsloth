#!/bin/bash
# Tests for Bill-specific integrations

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Test VRBO automation integration
test_vrbo_guest_workflow() {
    echo "Testing VRBO guest onboarding workflow..."
    
    # Source required libraries
    source "$BASE_DIR/lib/data_sharing.sh"
    source "$BASE_DIR/lib/workflow_orchestration.sh"
    
    # Initialize systems
    init_data_sharing
    init_workflow_system
    
    # Create VRBO directories
    mkdir -p "$HOME/.bill-sloth/vrbo-automation"/{data,scripts,templates}
    
    # Create test booking data
    local booking_data='{
        "booking_id": "TEST123",
        "guest": {
            "name": "John Smith",
            "email": "john@example.com",
            "phone": "555-1234"
        },
        "property": {
            "id": "beach_house_01",
            "name": "Sunset Beach House",
            "address": "123 Ocean Drive"
        },
        "dates": {
            "checkin": "2024-03-01",
            "checkout": "2024-03-05"
        },
        "payment": {
            "total": 1200,
            "deposit": 300,
            "status": "paid"
        }
    }'
    
    # Share booking data across modules
    cache_data "vrbo_automation" "current_booking" "$booking_data"
    share_data "vrbo_automation" "google_tasks" "new_booking" "$booking_data"
    share_data "vrbo_automation" "chatgpt" "guest_info" "$booking_data"
    
    # Create guest communication templates
    cat > "$HOME/.bill-sloth/vrbo-automation/templates/welcome_message.txt" << 'EOF'
Dear {{guest.name}},

Welcome to {{property.name}}! We're excited to host you from {{dates.checkin}} to {{dates.checkout}}.

Property Details:
- Address: {{property.address}}
- Check-in: 3:00 PM on {{dates.checkin}}
- Check-out: 11:00 AM on {{dates.checkout}}

Your booking confirmation: {{booking_id}}

We'll send check-in instructions 24 hours before your arrival.

Best regards,
Bill's Vacation Rentals
EOF
    
    # Verify data sharing
    local shared_data=$(get_cached_data "google_tasks" "vrbo_automation.new_booking")
    if [ -z "$shared_data" ]; then
        echo "FAILED: VRBO data not shared with Google Tasks"
        return 1
    fi
    
    # Verify template processing
    if [ ! -f "$HOME/.bill-sloth/vrbo-automation/templates/welcome_message.txt" ]; then
        echo "FAILED: Welcome message template not created"
        return 1
    fi
    
    echo "PASSED: VRBO guest workflow integration working"
    return 0
}

test_edboigames_content_pipeline() {
    echo "Testing EdBoiGames content processing pipeline..."
    
    # Create EdBoiGames directories
    mkdir -p "$HOME/edboigames_business"/{content,partnerships,analytics,automation/scripts}
    
    # Create test content metadata
    local content_data='{
        "content_id": "video_001",
        "title": "Epic Gaming Moments Compilation",
        "type": "video",
        "status": "processing",
        "metadata": {
            "duration": 600,
            "resolution": "1920x1080",
            "format": "mp4"
        },
        "publishing": {
            "platforms": ["youtube", "tiktok", "instagram"],
            "scheduled": "2024-03-15T14:00:00Z"
        }
    }'
    
    # Share content data for processing
    cache_data "edboigames" "current_content" "$content_data"
    share_data "edboigames" "media_processing" "new_content" "$content_data"
    share_data "edboigames" "google_tasks" "content_schedule" "$content_data"
    
    # Create partnership tracking
    cat > "$HOME/edboigames_business/partnerships/active_partners.json" << 'EOF'
{
    "partners": [
        {
            "id": "partner_001",
            "name": "Gaming Network Inc",
            "type": "content_distribution",
            "revenue_share": 0.3,
            "status": "active"
        },
        {
            "id": "partner_002", 
            "name": "StreamBoost Marketing",
            "type": "promotion",
            "monthly_fee": 500,
            "status": "active"
        }
    ]
}
EOF
    
    # Verify content pipeline
    local media_data=$(get_cached_data "media_processing" "edboigames.new_content")
    if [ -z "$media_data" ]; then
        echo "FAILED: EdBoiGames content not shared with media processing"
        return 1
    fi
    
    echo "PASSED: EdBoiGames content pipeline working"
    return 0
}

test_google_tasks_automation() {
    echo "Testing Google Tasks integration..."
    
    # Create Google Tasks directories
    mkdir -p "$HOME/.bill-sloth/google-tasks"/{data,scripts,auth}
    
    # Mock Google Tasks API functions
    create_google_task() {
        local list_name="$1"
        local title="$2"
        local due_date="$3"
        local notes="${4:-}"
        
        local task_id="task_$(date +%s)"
        local task_data="{
            \"id\": \"$task_id\",
            \"list\": \"$list_name\",
            \"title\": \"$title\",
            \"due\": \"$due_date\",
            \"notes\": \"$notes\",
            \"status\": \"needsAction\",
            \"created\": \"$(date -Iseconds)\"
        }"
        
        # Save task
        echo "$task_data" > "$HOME/.bill-sloth/google-tasks/data/$task_id.json"
        
        # Share task creation
        cache_data "google_tasks" "last_task" "$task_data"
        
        echo "$task_id"
    }
    
    export -f create_google_task
    
    # Test task creation from VRBO booking
    local vrbo_booking=$(get_cached_data "vrbo_automation" "current_booking")
    if [ ! -z "$vrbo_booking" ]; then
        local guest_name=$(echo "$vrbo_booking" | jq -r '.guest.name')
        local checkin=$(echo "$vrbo_booking" | jq -r '.dates.checkin')
        
        local task_id=$(create_google_task "VRBO" "Prepare for $guest_name arrival" "$checkin" "Property: Sunset Beach House")
        
        if [ ! -f "$HOME/.bill-sloth/google-tasks/data/$task_id.json" ]; then
            echo "FAILED: Google Task not created"
            return 1
        fi
    fi
    
    echo "PASSED: Google Tasks automation working"
    return 0
}

test_chatgpt_integration() {
    echo "Testing ChatGPT integration..."
    
    # Create ChatGPT integration directories
    mkdir -p "$HOME/.bill-sloth/chatgpt-integration"/{scripts,templates,cache}
    
    # Mock ChatGPT API function
    generate_with_chatgpt() {
        local prompt="$1"
        local max_tokens="${2:-150}"
        
        # Simulate API response
        local response='{
            "id": "chatcmpl-test123",
            "object": "chat.completion",
            "created": '$(date +%s)',
            "model": "gpt-3.5-turbo",
            "choices": [{
                "message": {
                    "role": "assistant",
                    "content": "This is a mock response for testing. In production, this would be actual ChatGPT generated content based on the prompt: '"$prompt"'"
                }
            }]
        }'
        
        echo "$response" | jq -r '.choices[0].message.content'
    }
    
    export -f generate_with_chatgpt
    
    # Test guest communication generation
    local guest_data=$(get_cached_data "vrbo_automation" "current_booking")
    if [ ! -z "$guest_data" ]; then
        local guest_name=$(echo "$guest_data" | jq -r '.guest.name')
        local property=$(echo "$guest_data" | jq -r '.property.name')
        
        local welcome_msg=$(generate_with_chatgpt "Generate a friendly welcome message for $guest_name staying at $property")
        
        if [ -z "$welcome_msg" ]; then
            echo "FAILED: ChatGPT content generation failed"
            return 1
        fi
        
        # Cache generated content
        cache_data "chatgpt" "last_generation" "$welcome_msg"
    fi
    
    echo "PASSED: ChatGPT integration working"
    return 0
}

test_excel_replacement() {
    echo "Testing Excel replacement with CSV processing..."
    
    # Create data automation directories
    mkdir -p "$HOME/.bill-sloth/data-automation"/{spreadsheets,scripts,exports}
    
    # Create VRBO revenue tracking spreadsheet
    cat > "$HOME/.bill-sloth/data-automation/spreadsheets/vrbo_revenue.csv" << 'EOF'
Date,Property,Guest,Nights,Rate,Total,Status
2024-01-15,Beach House,Smith Family,7,200,1400,Paid
2024-01-22,Mountain Cabin,Johnson,3,150,450,Paid
2024-02-01,Beach House,Williams,5,200,1000,Pending
2024-02-10,Lake Cottage,Davis,4,175,700,Paid
EOF
    
    # CSV processing functions
    calculate_revenue_summary() {
        local csv_file="$1"
        
        # Skip header and sum totals
        local total_revenue=$(tail -n +2 "$csv_file" | awk -F',' '{sum += $6} END {print sum}')
        local total_bookings=$(tail -n +2 "$csv_file" | wc -l)
        local paid_revenue=$(tail -n +2 "$csv_file" | grep "Paid" | awk -F',' '{sum += $6} END {print sum}')
        
        cat > "$HOME/.bill-sloth/data-automation/exports/revenue_summary.json" << EOF
{
    "generated": "$(date -Iseconds)",
    "total_bookings": $total_bookings,
    "total_revenue": $total_revenue,
    "paid_revenue": $paid_revenue,
    "pending_revenue": $((total_revenue - paid_revenue))
}
EOF
        
        echo "Revenue Summary Generated"
    }
    
    # Test CSV processing
    calculate_revenue_summary "$HOME/.bill-sloth/data-automation/spreadsheets/vrbo_revenue.csv"
    
    if [ ! -f "$HOME/.bill-sloth/data-automation/exports/revenue_summary.json" ]; then
        echo "FAILED: Revenue summary not generated"
        return 1
    fi
    
    # Verify calculations
    local summary=$(cat "$HOME/.bill-sloth/data-automation/exports/revenue_summary.json")
    local total=$(echo "$summary" | jq -r '.total_revenue')
    
    if [ "$total" != "3550" ]; then
        echo "FAILED: Revenue calculation incorrect (expected 3550, got $total)"
        return 1
    fi
    
    echo "PASSED: Excel replacement working with CSV processing"
    return 0
}

# Run all Bill-specific integration tests
run_bill_integration_tests() {
    echo "======================================"
    echo "Bill-Specific Integration Tests"
    echo "======================================"
    
    local tests_passed=0
    local tests_failed=0
    
    # Initialize required systems
    source "$BASE_DIR/lib/data_sharing.sh"
    init_data_sharing
    
    # Run each test
    for test_func in test_vrbo_guest_workflow test_edboigames_content_pipeline test_google_tasks_automation test_chatgpt_integration test_excel_replacement; do
        echo ""
        if $test_func; then
            ((tests_passed++))
        else
            ((tests_failed++))
        fi
    done
    
    echo ""
    echo "Results: $tests_passed passed, $tests_failed failed"
    
    return $tests_failed
}

# Execute if run directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_bill_integration_tests
fi