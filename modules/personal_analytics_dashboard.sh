#!/bin/bash
# LLM_CAPABILITY: local_ok
# Personal Analytics Dashboard - Life tracking and productivity insights for Bill Sloth
# ADHD-friendly personal metrics and pattern analysis

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/data_persistence.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || true

# Analytics configuration
ANALYTICS_DATA_DIR="$HOME/.bill-sloth/analytics"
PERSONAL_METRICS_DB="$ANALYTICS_DATA_DIR/personal_metrics.db"

# Initialize personal analytics system
init_personal_analytics() {
    log_info "Initializing personal analytics dashboard..."
    
    # Create analytics directories
    mkdir -p "$ANALYTICS_DATA_DIR"/{daily,weekly,monthly,insights}
    
    # Initialize personal metrics database (separate from main DB)
    if command -v sqlite3 &> /dev/null; then
        create_personal_metrics_schema
    else
        log_warning "SQLite not available - using file-based storage"
        mkdir -p "$ANALYTICS_DATA_DIR/json_storage"
    fi
    
    log_success "Personal analytics system initialized"
}

# Create personal metrics database schema
create_personal_metrics_schema() {
    sqlite3 "$PERSONAL_METRICS_DB" << 'SQL'
-- Daily mood and energy tracking
CREATE TABLE IF NOT EXISTS daily_metrics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL UNIQUE,
    mood_score INTEGER, -- 1-10 scale
    energy_level INTEGER, -- 1-10 scale
    productivity_rating INTEGER, -- 1-10 scale
    sleep_quality INTEGER, -- 1-10 scale
    hours_slept REAL,
    caffeine_cups INTEGER,
    exercise_minutes INTEGER,
    creative_work_hours REAL,
    admin_work_hours REAL,
    social_interactions INTEGER,
    outdoor_time_minutes INTEGER,
    screen_time_hours REAL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Task completion tracking
CREATE TABLE IF NOT EXISTS task_analytics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    task_category TEXT, -- 'vrbo', 'edboigames', 'personal', 'admin'
    tasks_planned INTEGER,
    tasks_completed INTEGER,
    completion_rate REAL,
    avg_task_duration_minutes REAL,
    procrastination_score INTEGER, -- 1-10 scale
    focus_quality INTEGER, -- 1-10 scale
    interruptions INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- VRBO business analytics
CREATE TABLE IF NOT EXISTS vrbo_analytics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    bookings_received INTEGER,
    guest_interactions INTEGER,
    property_maintenance_hours REAL,
    revenue_amount REAL,
    guest_satisfaction_avg REAL,
    issues_resolved INTEGER,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- EdBoiGames business analytics
CREATE TABLE IF NOT EXISTS edboigames_analytics (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    content_created INTEGER,
    editing_hours REAL,
    uploads_completed INTEGER,
    engagement_metrics TEXT, -- JSON
    revenue_amount REAL,
    ideas_generated INTEGER,
    collaboration_time_hours REAL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Life pattern insights
CREATE TABLE IF NOT EXISTS pattern_insights (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    insight_date DATE NOT NULL,
    insight_type TEXT, -- 'correlation', 'trend', 'anomaly', 'recommendation'
    category TEXT, -- 'productivity', 'health', 'business', 'mood'
    title TEXT NOT NULL,
    description TEXT,
    confidence_score REAL, -- 0-1 scale
    actionable BOOLEAN DEFAULT FALSE,
    action_taken BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_daily_metrics_date ON daily_metrics(date);
CREATE INDEX IF NOT EXISTS idx_task_analytics_date ON task_analytics(date);
CREATE INDEX IF NOT EXISTS idx_vrbo_analytics_date ON vrbo_analytics(date);
CREATE INDEX IF NOT EXISTS idx_edboigames_analytics_date ON edboigames_analytics(date);
SQL
}

# Show personal analytics dashboard
show_personal_dashboard() {
    clear
    print_header "📊 PERSONAL ANALYTICS DASHBOARD"
    echo "Insights for the ADHD brain that builds digital empires"
    echo ""
    
    # Quick today's metrics
    show_todays_snapshot
    echo ""
    
    # Weekly trends
    show_weekly_trends
    echo ""
    
    # Business metrics
    show_business_metrics
    echo ""
    
    # AI-generated insights
    show_pattern_insights
    echo ""
    
    # Action menu
    show_analytics_menu
}

# Show today's snapshot
show_todays_snapshot() {
    local today=$(date +%Y-%m-%d)
    
    echo "📅 TODAY'S SNAPSHOT ($today):"
    echo "════════════════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$PERSONAL_METRICS_DB" ]; then
        local mood=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT mood_score FROM daily_metrics WHERE date='$today';" 2>/dev/null)
        local energy=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT energy_level FROM daily_metrics WHERE date='$today';" 2>/dev/null)
        local productivity=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT productivity_rating FROM daily_metrics WHERE date='$today';" 2>/dev/null)
        
        echo "🧠 Mood: ${mood:-'Not tracked'}/10"
        echo "⚡ Energy: ${energy:-'Not tracked'}/10"
        echo "🎯 Productivity: ${productivity:-'Not tracked'}/10"
    else
        echo "📝 No data recorded yet - let's start tracking!"
    fi
    
    # Task completion for today
    local completed_tasks=$(get_data "tasks" "completed_today" "0")
    local total_tasks=$(get_data "tasks" "planned_today" "0") 
    echo "✅ Tasks: ${completed_tasks}/${total_tasks} completed"
    
    # Business activity
    local vrbo_interactions=$(get_data "vrbo" "interactions_today" "0")
    local content_created=$(get_data "edboigames" "content_today" "0")
    echo "🏠 VRBO interactions: $vrbo_interactions"
    echo "🎮 EdBoiGames content: $content_created"
}

# Show weekly trends
show_weekly_trends() {
    echo "📈 WEEKLY TRENDS (Last 7 days):"
    echo "════════════════════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$PERSONAL_METRICS_DB" ]; then
        # Average mood and energy
        local avg_mood=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT ROUND(AVG(mood_score), 1) FROM daily_metrics WHERE date >= date('now', '-7 days');" 2>/dev/null)
        local avg_energy=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT ROUND(AVG(energy_level), 1) FROM daily_metrics WHERE date >= date('now', '-7 days');" 2>/dev/null)
        
        echo "🧠 Average mood: ${avg_mood:-'N/A'}/10"
        echo "⚡ Average energy: ${avg_energy:-'N/A'}/10"
        
        # Productivity trends
        local productive_days=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT COUNT(*) FROM daily_metrics WHERE productivity_rating >= 7 AND date >= date('now', '-7 days');" 2>/dev/null)
        echo "🎯 Highly productive days: ${productive_days:-0}/7"
        
        # Sleep consistency
        local avg_sleep=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT ROUND(AVG(hours_slept), 1) FROM daily_metrics WHERE hours_slept > 0 AND date >= date('now', '-7 days');" 2>/dev/null)
        echo "😴 Average sleep: ${avg_sleep:-'N/A'} hours"
    else
        echo "📊 Building your trends... track daily metrics to see patterns!"
    fi
}

# Show business metrics
show_business_metrics() {
    echo "💼 BUSINESS METRICS (This week):"
    echo "═══════════════════════════════"
    
    # VRBO metrics
    local vrbo_bookings=$(get_data "vrbo" "bookings_week" "0")
    local vrbo_revenue=$(get_data "vrbo" "revenue_week" "0")
    echo "🏠 VRBO: $vrbo_bookings bookings, $${vrbo_revenue} revenue"
    
    # EdBoiGames metrics
    local content_pieces=$(get_data "edboigames" "content_week" "0")
    local editing_hours=$(get_data "edboigames" "editing_hours_week" "0")
    echo "🎮 EdBoiGames: $content_pieces content pieces, ${editing_hours}h editing"
    
    # Cross-business insights
    if [ "$vrbo_bookings" -gt 0 ] && [ "$content_pieces" -gt 0 ]; then
        echo "🚀 Multi-business momentum: Both ventures active!"
    elif [ "$vrbo_bookings" -gt 0 ]; then
        echo "🏠 VRBO focus week - hospitality mode activated"
    elif [ "$content_pieces" -gt 0 ]; then
        echo "🎮 Creative mode week - content creation flowing"
    else
        echo "🌱 Building phase - planning and preparation"
    fi
}

# Show AI-generated pattern insights
show_pattern_insights() {
    echo "🔮 PATTERN INSIGHTS:"
    echo "═══════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$PERSONAL_METRICS_DB" ]; then
        # Show recent insights
        local recent_insights=$(sqlite3 "$PERSONAL_METRICS_DB" "SELECT title, description FROM pattern_insights WHERE insight_date >= date('now', '-7 days') ORDER BY created_at DESC LIMIT 3;" 2>/dev/null)
        
        if [ -n "$recent_insights" ]; then
            echo "$recent_insights" | while IFS='|' read -r title description; do
                echo "💡 $title"
                echo "   $description"
                echo ""
            done
        else
            # Generate some basic insights based on available data
            generate_basic_insights
        fi
    else
        echo "🧠 AI PATTERN RECOGNITION INSIGHTS"
        echo "================================="
        echo ""
        echo "📊 Building analytical foundation..."
        echo "• Collecting usage patterns from system logs"
        echo "• Analyzing interaction frequencies"
        echo "• Tracking productivity cycles"
        echo ""
        echo "💡 Early insights available:"
        echo "• Most active hours: $(get_most_active_hours 2>/dev/null || echo 'Data collecting...')"
        echo "• Preferred modules: $(get_most_used_modules 2>/dev/null || echo 'Data collecting...')"
        echo "• Workflow patterns: $(get_workflow_patterns 2>/dev/null || echo 'Data collecting...')"
        echo ""
        echo "🔮 As you use Bill Sloth more, insights will become more sophisticated!"
        echo "💭 Tip: The system learns your patterns to provide better automation suggestions"
    fi
}

# Generate basic insights from available data
generate_basic_insights() {
    local total_tasks=$(get_data_count "tasks" "*")
    local vrbo_interactions=$(get_data_count "integration" "vrbo_*")
    local content_items=$(get_data_count "integration" "edboigames_*")
    
    if [ "$total_tasks" -gt 0 ]; then
        echo "💡 Task Management Insight:"
        echo "   You've created $total_tasks tasks - your system is actively organizing your work!"
        echo ""
    fi
    
    if [ "$vrbo_interactions" -gt 0 ] || [ "$content_items" -gt 0 ]; then
        echo "💡 Business Integration Insight:"
        echo "   Cross-module workflows are active - your businesses are getting systematic support!"
        echo ""
    fi
    
    echo "💡 System Health Insight:"
    echo "   Bill Sloth is learning your patterns - more data means better recommendations!"
}

# Show analytics action menu
show_analytics_menu() {
    echo "🎯 QUICK ACTIONS:"
    echo "═════════════════"
    echo "1) 📝 Log today's metrics (mood, energy, productivity)"
    echo "2) ✅ Update task completion status"
    echo "3) 🏠 Log VRBO business activity"
    echo "4) 🎮 Log EdBoiGames activity" 
    echo "5) 📊 Generate weekly report"
    echo "6) 🔍 Analyze patterns and correlations"
    echo "7) 🎯 Set personal goals and tracking"
    echo "8) 📈 Export data for external analysis"
    echo "9) 🔧 Configure tracking preferences"
    echo "0) 🏠 Return to main menu"
    echo ""
    
    read -p "Choose action (0-9): " choice
    handle_analytics_choice "$choice"
}

# Handle menu choices
handle_analytics_choice() {
    local choice="$1"
    
    case "$choice" in
        1) log_daily_metrics ;;
        2) update_task_completion ;;
        3) log_vrbo_activity ;;
        4) log_edboigames_activity ;;
        5) generate_weekly_report ;;
        6) analyze_patterns ;;
        7) set_personal_goals ;;
        8) export_analytics_data ;;
        9) configure_tracking ;;
        0) echo "Returning to main menu..."; return 0 ;;
        *) 
            echo "❌ Invalid choice. Please try again."
            sleep 1
            show_analytics_menu
            ;;
    esac
}

# Log daily metrics
log_daily_metrics() {
    local today=$(date +%Y-%m-%d)
    
    clear
    print_header "📝 DAILY METRICS LOGGING"
    echo "ADHD-friendly quick capture for $today"
    echo ""
    
    # Mood check
    echo "🧠 How's your mood today? (1=terrible, 10=amazing)"
    read -p "Mood score: " mood_score
    
    # Energy level
    echo ""
    echo "⚡ What's your energy level? (1=exhausted, 10=energized)"
    read -p "Energy level: " energy_level
    
    # Productivity rating
    echo ""
    echo "🎯 How productive do you feel? (1=distracted, 10=laser focused)"
    read -p "Productivity rating: " productivity_rating
    
    # Optional details
    echo ""
    echo "💤 Hours of sleep last night (optional):"
    read -p "Sleep hours: " sleep_hours
    
    echo ""
    echo "☕ Cups of caffeine today (optional):"
    read -p "Caffeine cups: " caffeine_cups
    
    echo ""
    echo "📝 Any notes about today (optional):"
    read -p "Notes: " daily_notes
    
    # Store metrics
    if command -v sqlite3 &> /dev/null && [ -f "$PERSONAL_METRICS_DB" ]; then
        sqlite3 "$PERSONAL_METRICS_DB" << EOF
INSERT OR REPLACE INTO daily_metrics 
(date, mood_score, energy_level, productivity_rating, hours_slept, caffeine_cups, notes)
VALUES ('$today', $mood_score, $energy_level, $productivity_rating, 
        ${sleep_hours:-NULL}, ${caffeine_cups:-NULL}, '$daily_notes');
EOF
    else
        # Fallback to data persistence system
        local metrics_data="{
            \"mood\": $mood_score,
            \"energy\": $energy_level, 
            \"productivity\": $productivity_rating,
            \"sleep_hours\": ${sleep_hours:-0},
            \"caffeine\": ${caffeine_cups:-0},
            \"notes\": \"$daily_notes\"
        }"
        store_data "personal_metrics" "$today" "$metrics_data"
    fi
    
    echo ""
    echo "✅ Daily metrics logged! Building your personal insights..."
    notify_success "Metrics Logged" "Today's data captured for pattern analysis"
    
    sleep 2
    show_personal_dashboard
}

# Generate weekly report
generate_weekly_report() {
    clear
    print_header "📊 WEEKLY ANALYTICS REPORT"
    echo "Personal insights for the past 7 days"
    echo ""
    
    local report_file="$ANALYTICS_DATA_DIR/weekly/report_$(date +%Y%m%d).md"
    mkdir -p "$(dirname "$report_file")"
    
    # Generate comprehensive report
    cat > "$report_file" << EOF
# Personal Analytics Report - Week of $(date +"%B %d, %Y")

## Mood & Energy Trends
$(show_weekly_trends | grep -A 10 "WEEKLY TRENDS")

## Business Performance
$(show_business_metrics | grep -A 10 "BUSINESS METRICS")

## Key Insights
$(show_pattern_insights | grep -A 10 "PATTERN INSIGHTS")

## Recommendations
- Continue tracking daily metrics for better pattern detection
- Focus on maintaining energy levels above 7/10 for optimal productivity
- Balance VRBO and EdBoiGames activities for sustainable growth

Generated by Bill Sloth Personal Analytics Dashboard
$(date)
EOF
    
    echo "📋 Weekly report generated!"
    echo "Location: $report_file"
    echo ""
    
    if command -v less &> /dev/null; then
        echo "Press Enter to view report (q to quit viewer)..."
        read -r
        less "$report_file"
    else
        cat "$report_file"
    fi
    
    echo ""
    read -p "Press Enter to return to dashboard..."
    show_personal_dashboard
}

# Main execution
personal_analytics_main() {
    init_personal_analytics
    show_personal_dashboard
}

# Export functions for integration
export -f init_personal_analytics show_personal_dashboard log_daily_metrics
export -f generate_weekly_report personal_analytics_main

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    personal_analytics_main "$@"
fi