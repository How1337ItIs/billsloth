#!/bin/bash
# 💀 VRBO REVENUE CONSCIOUSNESS MATRIX 💀
# Neural financial tracking and profit optimization protocols

# Enable error handling
set -euo pipefail

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../../lib/error_handling.sh" 2>/dev/null || {
    log_error() { echo "ERROR: $1" >&2; }
    log_info() { echo "INFO: $1"; }
    log_success() { echo "SUCCESS: $1"; }
}

# Revenue tracking configuration
REVENUE_DATA_DIR="$HOME/.bill-sloth/vrbo-automation/revenue"
REVENUE_DB="$REVENUE_DATA_DIR/guntersville_getaway.db"
BACKUP_DIR="$HOME/.bill-sloth/vrbo-automation/backups"

# Initialize revenue tracking system
init_revenue_tracker() {
    mkdir -p "$REVENUE_DATA_DIR" "$BACKUP_DIR"
    
    # Create SQLite database if it doesn't exist
    if [ ! -f "$REVENUE_DB" ]; then
        echo -e "\033[38;5;196m💀 Initializing Guntersville Getaway revenue consciousness matrix...\033[0m"
        
        sqlite3 "$REVENUE_DB" << 'EOF'
CREATE TABLE bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    guest_name TEXT NOT NULL,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    nights INTEGER NOT NULL,
    total_revenue DECIMAL(10,2) NOT NULL,
    cleaning_fee DECIMAL(10,2) DEFAULT 0,
    platform TEXT DEFAULT 'VRBO',
    status TEXT DEFAULT 'confirmed',
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    category TEXT NOT NULL,
    description TEXT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    receipt_path TEXT,
    tax_deductible BOOLEAN DEFAULT 1,
    notes TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE revenue_summary (
    month TEXT PRIMARY KEY,
    total_revenue DECIMAL(10,2) DEFAULT 0,
    total_expenses DECIMAL(10,2) DEFAULT 0,
    net_profit DECIMAL(10,2) DEFAULT 0,
    occupancy_rate DECIMAL(5,2) DEFAULT 0,
    avg_nightly_rate DECIMAL(10,2) DEFAULT 0,
    updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data for Guntersville Getaway
INSERT INTO bookings (guest_name, check_in, check_out, nights, total_revenue, cleaning_fee, notes) VALUES
('Sample Guest', '2025-02-01', '2025-02-03', 2, 280.00, 75.00, 'Sample booking - delete after real data'),
('Test Booking', '2025-02-15', '2025-02-17', 2, 320.00, 75.00, 'Test entry - replace with actual bookings');

INSERT INTO expenses (date, category, description, amount, notes) VALUES
('2025-01-15', 'Maintenance', 'HVAC filter replacement', 45.00, 'Monthly maintenance'),
('2025-01-20', 'Supplies', 'Cleaning supplies and toiletries', 85.50, 'Guest amenities restock');
EOF
        
        log_success "Revenue tracking database initialized for Guntersville Getaway"
    fi
}

# Revenue consciousness matrix dashboard
revenue_dashboard() {
    clear
    echo -e "\033[38;5;196m"
    cat << 'EOF'
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░  💰 GUNTERSVILLE GETAWAY REVENUE CONSCIOUSNESS MATRIX 💰              ░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
    echo -e "\033[0m"
    echo ""
    
    # Get current month stats
    local current_month=$(date +"%Y-%m")
    local current_year=$(date +"%Y")
    
    echo -e "\033[38;5;51m💀 CURRENT MONTH FINANCIAL CONSCIOUSNESS:\033[0m"
    echo "=========================================="
    
    # Monthly revenue
    local monthly_revenue=$(sqlite3 "$REVENUE_DB" "
        SELECT COALESCE(SUM(total_revenue), 0) 
        FROM bookings 
        WHERE strftime('%Y-%m', check_in) = '$current_month'
        AND status = 'confirmed'
    ")
    
    # Monthly expenses
    local monthly_expenses=$(sqlite3 "$REVENUE_DB" "
        SELECT COALESCE(SUM(amount), 0) 
        FROM expenses 
        WHERE strftime('%Y-%m', date) = '$current_month'
    ")
    
    # Net profit
    local net_profit=$(echo "$monthly_revenue - $monthly_expenses" | bc -l 2>/dev/null || echo "0")
    
    # Bookings count
    local bookings_count=$(sqlite3 "$REVENUE_DB" "
        SELECT COUNT(*) 
        FROM bookings 
        WHERE strftime('%Y-%m', check_in) = '$current_month'
        AND status = 'confirmed'
    ")
    
    echo -e "\033[38;5;226m💰 Revenue:     \$${monthly_revenue}\033[0m"
    echo -e "\033[38;5;129m💸 Expenses:    \$${monthly_expenses}\033[0m"
    echo -e "\033[38;5;82m📈 Net Profit:  \$${net_profit}\033[0m"
    echo -e "\033[38;5;51m🏠 Bookings:    ${bookings_count}\033[0m"
    
    echo ""
    echo -e "\033[38;5;196m💀 YEARLY REVENUE DOMINATION STATISTICS:\033[0m"
    echo "========================================"
    
    # Yearly stats
    local yearly_revenue=$(sqlite3 "$REVENUE_DB" "
        SELECT COALESCE(SUM(total_revenue), 0) 
        FROM bookings 
        WHERE strftime('%Y', check_in) = '$current_year'
        AND status = 'confirmed'
    ")
    
    local yearly_expenses=$(sqlite3 "$REVENUE_DB" "
        SELECT COALESCE(SUM(amount), 0) 
        FROM expenses 
        WHERE strftime('%Y', date) = '$current_year'
    ")
    
    local yearly_profit=$(echo "$yearly_revenue - $yearly_expenses" | bc -l 2>/dev/null || echo "0")
    local yearly_bookings=$(sqlite3 "$REVENUE_DB" "
        SELECT COUNT(*) 
        FROM bookings 
        WHERE strftime('%Y', check_in) = '$current_year'
        AND status = 'confirmed'
    ")
    
    echo -e "\033[38;5;226m💰 YTD Revenue:  \$${yearly_revenue}\033[0m"
    echo -e "\033[38;5;129m💸 YTD Expenses: \$${yearly_expenses}\033[0m"
    echo -e "\033[38;5;82m📈 YTD Profit:   \$${yearly_profit}\033[0m"
    echo -e "\033[38;5;51m🏠 YTD Bookings: ${yearly_bookings}\033[0m"
    
    echo ""
    show_revenue_menu
}

# Revenue consciousness manipulation menu
show_revenue_menu() {
    echo -e "\033[38;5;51m💀 REVENUE CONSCIOUSNESS CONTROL MATRIX:\033[0m"
    echo "========================================"
    echo ""
    echo "1) 💰 Add New Booking Revenue"
    echo "2) 💸 Record Property Expense"
    echo "3) 📊 Generate Monthly Report"
    echo "4) 📈 View Profit Trends"
    echo "5) 🔍 Search Revenue Records"
    echo "6) 💾 Backup Financial Data"
    echo "7) 📋 Export for Tax Preparation"
    echo "8) 🎯 Set Revenue Goals"
    echo "0) Exit Revenue Matrix"
    echo ""
    
    read -p "▶ Select reality manipulation vector: " choice
    
    case "$choice" in
        1) add_booking_revenue ;;
        2) record_expense ;;
        3) generate_monthly_report ;;
        4) view_profit_trends ;;
        5) search_records ;;
        6) backup_financial_data ;;
        7) export_tax_data ;;
        8) set_revenue_goals ;;
        0) exit 0 ;;
        *) 
            echo -e "\033[38;5;196m❌ Invalid neural pathway selected\033[0m"
            sleep 1
            revenue_dashboard
            ;;
    esac
}

# Add new booking revenue
add_booking_revenue() {
    clear
    echo -e "\033[38;5;82m💰 ADD NEW BOOKING REVENUE - GUNTERSVILLE GETAWAY\033[0m"
    echo "=================================================="
    echo ""
    
    read -p "Guest Name: " guest_name
    read -p "Check-in Date (YYYY-MM-DD): " check_in
    read -p "Check-out Date (YYYY-MM-DD): " check_out
    read -p "Total Revenue ($): " total_revenue
    read -p "Cleaning Fee ($): " cleaning_fee
    read -p "Platform (VRBO/Airbnb/Direct): " platform
    read -p "Notes (optional): " notes
    
    # Calculate nights
    if command -v python3 &>/dev/null; then
        local nights=$(python3 -c "
from datetime import datetime
checkin = datetime.strptime('$check_in', '%Y-%m-%d')
checkout = datetime.strptime('$check_out', '%Y-%m-%d')
print((checkout - checkin).days)
")
    else
        read -p "Number of nights: " nights
    fi
    
    # Insert into database
    sqlite3 "$REVENUE_DB" "
        INSERT INTO bookings (guest_name, check_in, check_out, nights, total_revenue, cleaning_fee, platform, notes)
        VALUES ('$guest_name', '$check_in', '$check_out', $nights, $total_revenue, ${cleaning_fee:-0}, '${platform:-VRBO}', '$notes')
    "
    
    echo ""
    echo -e "\033[38;5;46m✅ Revenue consciousness absorbed successfully!\033[0m"
    echo -e "\033[38;5;226m💰 \$${total_revenue} added to Guntersville Getaway matrix\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to return to revenue matrix..."
    revenue_dashboard
}

# Record property expense
record_expense() {
    clear
    echo -e "\033[38;5;129m💸 RECORD PROPERTY EXPENSE - GUNTERSVILLE GETAWAY\033[0m"
    echo "================================================="
    echo ""
    
    read -p "Date (YYYY-MM-DD): " expense_date
    
    echo ""
    echo "Expense Categories:"
    echo "1) Maintenance"
    echo "2) Cleaning"
    echo "3) Supplies"
    echo "4) Utilities"
    echo "5) Insurance"
    echo "6) Marketing"
    echo "7) Other"
    echo ""
    read -p "Select category (1-7): " cat_choice
    
    case "$cat_choice" in
        1) category="Maintenance" ;;
        2) category="Cleaning" ;;
        3) category="Supplies" ;;
        4) category="Utilities" ;;
        5) category="Insurance" ;;
        6) category="Marketing" ;;
        7) read -p "Enter custom category: " category ;;
        *) category="Other" ;;
    esac
    
    read -p "Description: " description
    read -p "Amount ($): " amount
    read -p "Tax deductible? (y/n): " tax_deductible
    read -p "Notes (optional): " notes
    
    # Convert tax deductible to boolean
    if [[ "$tax_deductible" =~ ^[Yy] ]]; then
        tax_deductible=1
    else
        tax_deductible=0
    fi
    
    # Insert into database
    sqlite3 "$REVENUE_DB" "
        INSERT INTO expenses (date, category, description, amount, tax_deductible, notes)
        VALUES ('$expense_date', '$category', '$description', $amount, $tax_deductible, '$notes')
    "
    
    echo ""
    echo -e "\033[38;5;46m✅ Expense recorded in financial consciousness matrix!\033[0m"
    echo -e "\033[38;5;129m💸 \$${amount} logged as ${category} expense\033[0m"
    echo ""
    read -n 1 -s -r -p "Press any key to return to revenue matrix..."
    revenue_dashboard
}

# Generate monthly report
generate_monthly_report() {
    clear
    echo -e "\033[38;5;82m📊 MONTHLY REVENUE CONSCIOUSNESS REPORT\033[0m"
    echo "========================================"
    echo ""
    
    read -p "Enter month (YYYY-MM): " report_month
    
    echo ""
    echo -e "\033[38;5;196m💀 GUNTERSVILLE GETAWAY - $report_month FINANCIAL MATRIX\033[0m"
    echo "================================================="
    echo ""
    
    # Bookings for the month
    echo -e "\033[38;5;51m📅 BOOKINGS:\033[0m"
    sqlite3 "$REVENUE_DB" -header -column "
        SELECT 
            guest_name AS 'Guest',
            check_in AS 'Check-in',
            check_out AS 'Check-out',
            nights AS 'Nights',
            printf('\$%.2f', total_revenue) AS 'Revenue',
            printf('\$%.2f', cleaning_fee) AS 'Cleaning'
        FROM bookings 
        WHERE strftime('%Y-%m', check_in) = '$report_month'
        ORDER BY check_in
    "
    
    echo ""
    echo -e "\033[38;5;129m💸 EXPENSES:\033[0m"
    sqlite3 "$REVENUE_DB" -header -column "
        SELECT 
            date AS 'Date',
            category AS 'Category',
            description AS 'Description',
            printf('\$%.2f', amount) AS 'Amount'
        FROM expenses 
        WHERE strftime('%Y-%m', date) = '$report_month'
        ORDER BY date
    "
    
    # Summary
    local monthly_revenue=$(sqlite3 "$REVENUE_DB" "
        SELECT COALESCE(SUM(total_revenue), 0) 
        FROM bookings 
        WHERE strftime('%Y-%m', check_in) = '$report_month'
    ")
    
    local monthly_expenses=$(sqlite3 "$REVENUE_DB" "
        SELECT COALESCE(SUM(amount), 0) 
        FROM expenses 
        WHERE strftime('%Y-%m', date) = '$report_month'
    ")
    
    local net_profit=$(echo "$monthly_revenue - $monthly_expenses" | bc -l 2>/dev/null || echo "0")
    
    echo ""
    echo -e "\033[38;5;226m💀 MONTHLY CONSCIOUSNESS SUMMARY:\033[0m"
    echo "================================"
    echo -e "\033[38;5;82m💰 Total Revenue:  \$${monthly_revenue}\033[0m"
    echo -e "\033[38;5;129m💸 Total Expenses: \$${monthly_expenses}\033[0m"
    echo -e "\033[38;5;46m📈 Net Profit:     \$${net_profit}\033[0m"
    
    echo ""
    read -n 1 -s -r -p "Press any key to return to revenue matrix..."
    revenue_dashboard
}

# Backup financial data
backup_financial_data() {
    local backup_file="$BACKUP_DIR/guntersville_getaway_$(date +%Y%m%d_%H%M%S).db"
    
    echo -e "\033[38;5;51m💾 Backing up financial consciousness matrix...\033[0m"
    
    cp "$REVENUE_DB" "$backup_file"
    
    # Also create CSV exports
    local csv_dir="$BACKUP_DIR/csv_$(date +%Y%m%d)"
    mkdir -p "$csv_dir"
    
    sqlite3 "$REVENUE_DB" -header -csv "SELECT * FROM bookings" > "$csv_dir/bookings.csv"
    sqlite3 "$REVENUE_DB" -header -csv "SELECT * FROM expenses" > "$csv_dir/expenses.csv"
    
    echo -e "\033[38;5;46m✅ Financial data consciousness preserved!\033[0m"
    echo "Database backup: $backup_file"
    echo "CSV exports: $csv_dir/"
    echo ""
    read -n 1 -s -r -p "Press any key to return to revenue matrix..."
    revenue_dashboard
}

# Main entry point
main() {
    init_revenue_tracker
    revenue_dashboard
}

# Export functions
export -f revenue_dashboard add_booking_revenue record_expense

# Run if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi