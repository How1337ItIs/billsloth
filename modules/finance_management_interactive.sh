#!/bin/bash
# LLM_CAPABILITY: local_ok
# CLAUDE_OPTIONS: 1=Budget Tracker, 2=Expense Monitor, 3=Business Finance, 4=Investment Tracker, 5=Complete Finance Suite
# CLAUDE_PROMPTS: Finance tool selection, Account setup, Category configuration
# CLAUDE_DEPENDENCIES: gnucash, ledger, python3, sqlite3
# Finance Management Suite - Personal finance automation for Bill Sloth
# ADHD-friendly money tracking and business finance management

# Load Claude Interactive Bridge for AI/Human hybrid execution
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

# Source required libraries
source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/data_persistence.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || true

# Finance configuration
FINANCE_DATA_DIR="$HOME/.bill-sloth/finance"
FINANCE_DB="$FINANCE_DATA_DIR/finance.db"

# Initialize finance management system
init_finance_management() {
    log_info "Initializing finance management system..."
    
    # Create finance directories
    mkdir -p "$FINANCE_DATA_DIR"/{receipts,reports,budgets,taxes}
    
    # Initialize finance database
    if command -v sqlite3 &> /dev/null; then
        create_finance_schema
    else
        log_warning "SQLite not available - using file-based storage"
        mkdir -p "$FINANCE_DATA_DIR/json_storage"
    fi
    
    log_success "Finance management system initialized"
}

# Create finance database schema
create_finance_schema() {
    sqlite3 "$FINANCE_DB" << 'SQL'
-- Income tracking
CREATE TABLE IF NOT EXISTS income (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    source TEXT NOT NULL, -- 'vrbo', 'edboigames', 'other'
    amount REAL NOT NULL,
    description TEXT,
    category TEXT, -- 'rental_income', 'content_revenue', 'partnership', 'other'
    tax_deductible BOOLEAN DEFAULT FALSE,
    payment_method TEXT,
    invoice_number TEXT,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Expense tracking  
CREATE TABLE IF NOT EXISTS expenses (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    date DATE NOT NULL,
    vendor TEXT NOT NULL,
    amount REAL NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL, -- 'property_maintenance', 'equipment', 'software', 'marketing', etc.
    business TEXT, -- 'vrbo', 'edboigames', 'personal'
    tax_deductible BOOLEAN DEFAULT FALSE,
    payment_method TEXT,
    receipt_path TEXT,
    mileage REAL,
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Budget tracking
CREATE TABLE IF NOT EXISTS budgets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    business TEXT, -- 'vrbo', 'edboigames', 'personal'
    period_type TEXT DEFAULT 'monthly', -- 'weekly', 'monthly', 'quarterly', 'yearly'
    budget_amount REAL NOT NULL,
    spent_amount REAL DEFAULT 0,
    start_date DATE,
    end_date DATE,
    alert_threshold REAL DEFAULT 0.8, -- Alert when 80% spent
    active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Financial goals
CREATE TABLE IF NOT EXISTS financial_goals (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    goal_name TEXT NOT NULL,
    target_amount REAL NOT NULL,
    current_amount REAL DEFAULT 0,
    target_date DATE,
    category TEXT, -- 'emergency_fund', 'equipment', 'expansion', 'retirement'
    business TEXT,
    priority TEXT DEFAULT 'medium', -- 'high', 'medium', 'low'
    status TEXT DEFAULT 'active', -- 'active', 'completed', 'paused'
    notes TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tax preparation tracking
CREATE TABLE IF NOT EXISTS tax_items (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    tax_year INTEGER NOT NULL,
    item_type TEXT NOT NULL, -- 'income', 'expense', 'deduction'
    source_table TEXT, -- 'income', 'expenses'
    source_id INTEGER,
    amount REAL NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    documentation_path TEXT,
    processed BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_income_date ON income(date);
CREATE INDEX IF NOT EXISTS idx_income_source ON income(source);
CREATE INDEX IF NOT EXISTS idx_expenses_date ON expenses(date);
CREATE INDEX IF NOT EXISTS idx_expenses_category ON expenses(category);
CREATE INDEX IF NOT EXISTS idx_expenses_business ON expenses(business);
CREATE INDEX IF NOT EXISTS idx_budgets_active ON budgets(active);
SQL
}

# Show finance dashboard
show_finance_dashboard() {
    clear
    print_header "💰 FINANCE MANAGEMENT DASHBOARD"
    echo "Money management for the ADHD entrepreneur"
    echo ""
    
    # Quick financial overview
    show_financial_overview
    echo ""
    
    # Budget status
    show_budget_status
    echo ""
    
    # Recent transactions
    show_recent_transactions
    echo ""
    
    # Financial goals progress
    show_goals_progress
    echo ""
    
    # Action menu
    show_finance_menu
}

# Show financial overview
show_financial_overview() {
    local current_month=$(date +%Y-%m)
    local last_month=$(date -d "last month" +%Y-%m 2>/dev/null || date +%Y-%m)
    
    echo "📊 FINANCIAL OVERVIEW (This Month):"
    echo "═══════════════════════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$FINANCE_DB" ]; then
        # This month's income by source
        local vrbo_income=$(sqlite3 "$FINANCE_DB" "SELECT COALESCE(SUM(amount), 0) FROM income WHERE source='vrbo' AND strftime('%Y-%m', date)='$current_month';" 2>/dev/null)
        local edboigames_income=$(sqlite3 "$FINANCE_DB" "SELECT COALESCE(SUM(amount), 0) FROM income WHERE source='edboigames' AND strftime('%Y-%m', date)='$current_month';" 2>/dev/null)
        local other_income=$(sqlite3 "$FINANCE_DB" "SELECT COALESCE(SUM(amount), 0) FROM income WHERE source='other' AND strftime('%Y-%m', date)='$current_month';" 2>/dev/null)
        
        # This month's expenses by business
        local vrbo_expenses=$(sqlite3 "$FINANCE_DB" "SELECT COALESCE(SUM(amount), 0) FROM expenses WHERE business='vrbo' AND strftime('%Y-%m', date)='$current_month';" 2>/dev/null)
        local edboigames_expenses=$(sqlite3 "$FINANCE_DB" "SELECT COALESCE(SUM(amount), 0) FROM expenses WHERE business='edboigames' AND strftime('%Y-%m', date)='$current_month';" 2>/dev/null)
        local personal_expenses=$(sqlite3 "$FINANCE_DB" "SELECT COALESCE(SUM(amount), 0) FROM expenses WHERE business='personal' AND strftime('%Y-%m', date)='$current_month';" 2>/dev/null)
        
        # Calculate totals
        local total_income=$(echo "$vrbo_income + $edboigames_income + $other_income" | bc 2>/dev/null || echo "0")
        local total_expenses=$(echo "$vrbo_expenses + $edboigames_expenses + $personal_expenses" | bc 2>/dev/null || echo "0")
        local net_income=$(echo "$total_income - $total_expenses" | bc 2>/dev/null || echo "0")
        
        echo "💵 Income:"
        echo "   🏠 VRBO: \$$(printf '%.2f' $vrbo_income)"
        echo "   🎮 EdBoiGames: \$$(printf '%.2f' $edboigames_income)"
        echo "   📈 Other: \$$(printf '%.2f' $other_income)"
        echo "   📊 Total: \$$(printf '%.2f' $total_income)"
        echo ""
        echo "💸 Expenses:"
        echo "   🏠 VRBO: \$$(printf '%.2f' $vrbo_expenses)"
        echo "   🎮 EdBoiGames: \$$(printf '%.2f' $edboigames_expenses)"
        echo "   🏡 Personal: \$$(printf '%.2f' $personal_expenses)"
        echo "   📊 Total: \$$(printf '%.2f' $total_expenses)"
        echo ""
        
        if (( $(echo "$net_income >= 0" | bc -l 2>/dev/null || echo 0) )); then
            echo "✅ Net Income: \$$(printf '%.2f' $net_income) (Profitable month! 🎉)"
        else
            echo "⚠️ Net Income: \$$(printf '%.2f' $net_income) (Investment month 💪)"
        fi
    else
        echo "📝 No financial data yet - let's start tracking your money!"
        echo ""
        echo "🏠 VRBO Income: \$0.00"
        echo "🎮 EdBoiGames Income: \$0.00"
        echo "📊 Total Expenses: \$0.00"
    fi
}

# Show budget status
show_budget_status() {
    echo "💳 BUDGET STATUS:"
    echo "═════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$FINANCE_DB" ]; then
        local budget_count=$(sqlite3 "$FINANCE_DB" "SELECT COUNT(*) FROM budgets WHERE active=1;" 2>/dev/null)
        
        if [ "$budget_count" -gt 0 ]; then
            sqlite3 "$FINANCE_DB" "SELECT name, budget_amount, spent_amount, category FROM budgets WHERE active=1 LIMIT 5;" 2>/dev/null | while IFS='|' read -r name budget spent category; do
                local percentage=$(echo "scale=1; ($spent / $budget) * 100" | bc 2>/dev/null || echo "0")
                
                if (( $(echo "$percentage >= 90" | bc -l 2>/dev/null || echo 0) )); then
                    echo "🔴 $name ($category): \$$(printf '%.2f' $spent)/\$$(printf '%.2f' $budget) (${percentage}%)"
                elif (( $(echo "$percentage >= 75" | bc -l 2>/dev/null || echo 0) )); then
                    echo "🟡 $name ($category): \$$(printf '%.2f' $spent)/\$$(printf '%.2f' $budget) (${percentage}%)"
                else
                    echo "🟢 $name ($category): \$$(printf '%.2f' $spent)/\$$(printf '%.2f' $budget) (${percentage}%)"
                fi
            done
        else
            echo "📋 No active budgets - let's create some spending limits!"
        fi
    else
        echo "📊 Budget tracking ready - set up your first budget!"
    fi
}

# Show recent transactions
show_recent_transactions() {
    echo "📋 RECENT TRANSACTIONS (Last 5):"
    echo "════════════════════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$FINANCE_DB" ]; then
        # Combine income and expenses, show most recent
        echo "Recent Income:"
        sqlite3 "$FINANCE_DB" "SELECT date, source, amount, description FROM income ORDER BY created_at DESC LIMIT 3;" 2>/dev/null | while IFS='|' read -r date source amount desc; do
            echo "   💰 $date: +\$$(printf '%.2f' $amount) ($source) - $desc"
        done
        
        echo ""
        echo "Recent Expenses:"
        sqlite3 "$FINANCE_DB" "SELECT date, vendor, amount, description FROM expenses ORDER BY created_at DESC LIMIT 3;" 2>/dev/null | while IFS='|' read -r date vendor amount desc; do
            echo "   💸 $date: -\$$(printf '%.2f' $amount) ($vendor) - $desc"
        done
    else
        echo "📝 No transactions yet - start by adding some income or expenses!"
    fi
}

# Show goals progress  
show_goals_progress() {
    echo "🎯 FINANCIAL GOALS:"
    echo "══════════════════"
    
    if command -v sqlite3 &> /dev/null && [ -f "$FINANCE_DB" ]; then
        local goals_count=$(sqlite3 "$FINANCE_DB" "SELECT COUNT(*) FROM financial_goals WHERE status='active';" 2>/dev/null)
        
        if [ "$goals_count" -gt 0 ]; then
            sqlite3 "$FINANCE_DB" "SELECT goal_name, target_amount, current_amount, target_date FROM financial_goals WHERE status='active' LIMIT 3;" 2>/dev/null | while IFS='|' read -r goal target current date; do
                local percentage=$(echo "scale=1; ($current / $target) * 100" | bc 2>/dev/null || echo "0")
                echo "🎯 $goal: \$$(printf '%.2f' $current)/\$$(printf '%.2f' $target) (${percentage}%) - Target: $date"
            done
        else
            echo "🎯 No financial goals set - let's create some targets!"
        fi
    else
        echo "🎯 Goal tracking ready - set your first financial target!"
    fi
}

# Show finance menu
show_finance_menu() {
    echo "💰 QUICK ACTIONS:"
    echo "═════════════════"
    echo "1) 💵 Add income (VRBO, EdBoiGames, other)"
    echo "2) 💸 Add expense"  
    echo "3) 💳 Manage budgets"
    echo "4) 🎯 Set financial goals"
    echo "5) 📊 Generate financial report"
    echo "6) 📋 Tax preparation tools"
    echo "7) 🏠 VRBO business finances"
    echo "8) 🎮 EdBoiGames business finances"
    echo "9) ⚙️ Finance settings & import"
    echo "0) 🏠 Return to main menu"
    echo ""
    
    read -p "Choose action (0-9): " choice
    handle_finance_choice "$choice"
}

# Handle menu choices
handle_finance_choice() {
    local choice="$1"
    
    case "$choice" in
        1) add_income ;;
        2) add_expense ;;
        3) manage_budgets ;;
        4) set_financial_goals ;;
        5) generate_financial_report ;;
        6) tax_preparation ;;
        7) vrbo_finances ;;
        8) edboigames_finances ;;
        9) finance_settings ;;
        0) echo "Returning to main menu..."; return 0 ;;
        *) 
            echo "❌ Invalid choice. Please try again."
            sleep 1
            show_finance_dashboard
            ;;
    esac
}

# Add income
add_income() {
    clear
    print_header "💵 ADD INCOME"
    echo "Track your money coming in"
    echo ""
    
    echo "💰 What type of income is this?"
    echo "1) 🏠 VRBO rental income"
    echo "2) 🎮 EdBoiGames content revenue"
    echo "3) 📈 Partnership/collaboration"
    echo "4) 🔧 Other income"
    echo ""
    read -p "Choose source (1-4): " source_choice
    
    case "$source_choice" in
        1) local source="vrbo"; local category="rental_income" ;;
        2) local source="edboigames"; local category="content_revenue" ;;
        3) local source="other"; local category="partnership" ;;
        4) local source="other"; local category="other" ;;
        *) echo "Invalid choice"; sleep 1; show_finance_dashboard; return ;;
    esac
    
    echo ""
    read -p "💵 Amount received: \$" amount
    read -p "📅 Date (YYYY-MM-DD) or 'today': " income_date
    [ "$income_date" = "today" ] && income_date=$(date +%Y-%m-%d)
    read -p "📝 Description: " description
    read -p "💳 Payment method (optional): " payment_method
    
    # Store income
    if command -v sqlite3 &> /dev/null && [ -f "$FINANCE_DB" ]; then
        sqlite3 "$FINANCE_DB" << EOF
INSERT INTO income (date, source, amount, description, category, payment_method)
VALUES ('$income_date', '$source', $amount, '$description', '$category', '$payment_method');
EOF
    else
        local income_data="{\"source\": \"$source\", \"amount\": $amount, \"description\": \"$description\", \"category\": \"$category\"}"
        store_data "finance_income" "$(date +%s)" "$income_data"
    fi
    
    echo ""
    echo "✅ Income added: \$$(printf '%.2f' $amount) from $source"
    notify_success "Income Added" "💰 \$$(printf '%.2f' $amount) from $source recorded"
    
    # Update integration data for cross-module workflows  
    if [ "$source" = "vrbo" ]; then
        store_data "vrbo" "revenue_$(date +%s)" "$amount"
    elif [ "$source" = "edboigames" ]; then
        store_data "edboigames" "revenue_$(date +%s)" "$amount"
    fi
    
    sleep 2
    show_finance_dashboard
}

# Add expense
add_expense() {
    clear
    print_header "💸 ADD EXPENSE"
    echo "Track your business and personal spending"
    echo ""
    
    read -p "🏪 Vendor/Store: " vendor
    read -p "💸 Amount spent: \$" amount
    read -p "📅 Date (YYYY-MM-DD) or 'today': " expense_date
    [ "$expense_date" = "today" ] && expense_date=$(date +%Y-%m-%d)
    read -p "📝 Description: " description
    
    echo ""
    echo "🏢 Which business is this for?"
    echo "1) 🏠 VRBO (property expenses)"
    echo "2) 🎮 EdBoiGames (content creation)"
    echo "3) 🏡 Personal"
    echo ""
    read -p "Choose business (1-3): " business_choice
    
    case "$business_choice" in
        1) local business="vrbo" ;;
        2) local business="edboigames" ;;
        3) local business="personal" ;;
        *) local business="personal" ;;
    esac
    
    echo ""
    echo "📊 Expense category:"
    if [ "$business" = "vrbo" ]; then
        echo "1) Property maintenance  2) Supplies  3) Marketing  4) Insurance  5) Other"
    elif [ "$business" = "edboigames" ]; then
        echo "1) Equipment  2) Software  3) Marketing  4) Supplies  5) Other"
    else
        echo "1) Food  2) Transportation  3) Utilities  4) Entertainment  5) Other"
    fi
    read -p "Choose category (1-5): " cat_choice
    
    # Set category based on business and choice
    local category="other"
    if [ "$business" = "vrbo" ]; then
        case "$cat_choice" in
            1) category="property_maintenance" ;;
            2) category="supplies" ;;
            3) category="marketing" ;;
            4) category="insurance" ;;
        esac
    elif [ "$business" = "edboigames" ]; then
        case "$cat_choice" in
            1) category="equipment" ;;
            2) category="software" ;;
            3) category="marketing" ;;
            4) category="supplies" ;;
        esac
    fi
    
    echo ""
    read -p "🧾 Is this tax deductible? (y/n): " tax_deduct
    local tax_deductible="false"
    [[ "$tax_deduct" =~ ^[Yy]$ ]] && tax_deductible="true"
    
    # Store expense
    if command -v sqlite3 &> /dev/null && [ -f "$FINANCE_DB" ]; then
        sqlite3 "$FINANCE_DB" << EOF
INSERT INTO expenses (date, vendor, amount, description, category, business, tax_deductible)
VALUES ('$expense_date', '$vendor', $amount, '$description', '$category', '$business', $tax_deductible);
EOF
    else
        local expense_data="{\"vendor\": \"$vendor\", \"amount\": $amount, \"description\": \"$description\", \"category\": \"$category\", \"business\": \"$business\"}"
        store_data "finance_expenses" "$(date +%s)" "$expense_data"
    fi
    
    echo ""
    echo "✅ Expense added: \$$(printf '%.2f' $amount) for $category ($business)"
    notify_success "Expense Added" "💸 \$$(printf '%.2f' $amount) expense recorded"
    
    sleep 2
    show_finance_dashboard
}

# Generate financial report
generate_financial_report() {
    clear
    print_header "📊 FINANCIAL REPORT GENERATOR"
    echo ""
    
    local report_file="$FINANCE_DATA_DIR/reports/financial_report_$(date +%Y%m%d).md"
    mkdir -p "$(dirname "$report_file")"
    
    echo "Generating comprehensive financial report..."
    
    # Generate report
    cat > "$report_file" << EOF
# Financial Report - $(date +"%B %Y")

## Income Summary
$(show_financial_overview | grep -A 20 "FINANCIAL OVERVIEW")

## Business Performance
### VRBO Business
- Focus: Vacation rental management
- Key metrics: Occupancy rate, guest satisfaction, maintenance costs

### EdBoiGames Business  
- Focus: Content creation and gaming
- Key metrics: Content output, engagement, monetization

## Budget Analysis
$(show_budget_status | grep -A 10 "BUDGET STATUS")

## Financial Goals Progress
$(show_goals_progress | grep -A 10 "FINANCIAL GOALS")

## Tax Preparation Notes
- Track all business expenses for deductions
- Separate VRBO and EdBoiGames income streams
- Maintain receipts and documentation

## Recommendations
- Continue tracking all income and expenses
- Review budget allocations monthly
- Set aside 25-30% of income for taxes
- Build emergency fund (3-6 months expenses)

Generated by Bill Sloth Finance Management
$(date)
EOF
    
    echo "✅ Report generated: $report_file"
    
    if command -v less &> /dev/null; then
        echo ""
        read -p "Press Enter to view report (q to quit)..."
        less "$report_file"
    fi
    
    echo ""
    read -p "Press Enter to return to dashboard..."
    show_finance_dashboard
}

# Main execution
finance_management_main() {
    init_finance_management
    show_finance_dashboard
}

# Export functions for integration
export -f init_finance_management show_finance_dashboard add_income add_expense
export -f generate_financial_report finance_management_main

# Run main function if executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    finance_management_main "$@"
fi