#!/bin/bash
# LLM_CAPABILITY: local_ok
# 💀 INTELLIGENT AUTOMATION ADVISOR 💀
# AI-powered workflow analysis and automation recommendation engine

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true

# Configuration
AUTOMATION_CONFIG_DIR="$HOME/.bill-sloth/automation"
WORKFLOW_ANALYSIS_DB="$AUTOMATION_CONFIG_DIR/workflow_analysis.db"
AUTOMATION_RECOMMENDATIONS="$AUTOMATION_CONFIG_DIR/recommendations.json"

# Initialize automation advisor
init_automation_advisor() {
    create_directory "$AUTOMATION_CONFIG_DIR"
    create_directory "$AUTOMATION_CONFIG_DIR/workflows"
    create_directory "$AUTOMATION_CONFIG_DIR/integrations"
    create_directory "$AUTOMATION_CONFIG_DIR/templates"
    
    # Initialize SQLite database for workflow analysis
    sqlite3 "$WORKFLOW_ANALYSIS_DB" << 'EOF'
CREATE TABLE IF NOT EXISTS workflows (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    frequency TEXT,
    time_spent_minutes INTEGER,
    tools_used TEXT,
    pain_points TEXT,
    automation_potential INTEGER,
    current_solution TEXT,
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS automation_platforms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    type TEXT, -- 'cloud', 'local', 'hybrid'
    complexity TEXT, -- 'beginner', 'intermediate', 'advanced'
    cost TEXT, -- 'free', 'freemium', 'paid'
    strengths TEXT,
    ideal_for TEXT,
    integration_count INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS workflow_recommendations (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    workflow_id INTEGER,
    platform_id INTEGER,
    recommendation_score INTEGER,
    reasoning TEXT,
    implementation_steps TEXT,
    estimated_time_savings INTEGER,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id),
    FOREIGN KEY (platform_id) REFERENCES automation_platforms(id)
);
EOF

    # Initialize automation platforms database
    populate_automation_platforms
}

# Populate automation platforms with mature solutions
populate_automation_platforms() {
    sqlite3 "$WORKFLOW_ANALYSIS_DB" << 'EOF'
-- Cloud-based platforms
INSERT OR REPLACE INTO automation_platforms (name, type, complexity, cost, strengths, ideal_for, integration_count) VALUES
('Zapier', 'cloud', 'beginner', 'freemium', 'Massive app ecosystem, visual builder, robust error handling', 'Business workflows, SaaS integrations, non-technical users', 5000),
('Microsoft Power Automate', 'cloud', 'intermediate', 'freemium', 'Deep Office 365 integration, enterprise security, AI Builder', 'Office 365 environments, enterprise workflows', 1000),
('Integromat/Make', 'cloud', 'intermediate', 'freemium', 'Advanced logic, visual workflow designer, real-time execution', 'Complex multi-step automations, data transformation', 1500),
('IFTTT', 'cloud', 'beginner', 'freemium', 'Simple trigger-action, mobile-focused, consumer apps', 'Personal productivity, IoT, simple automations', 600),
('Automate.io', 'cloud', 'beginner', 'freemium', 'Business focus, CRM integrations, affordable pricing', 'Small business workflows, sales/marketing automation', 200),

-- Local/self-hosted solutions (business-focused)
('n8n', 'local', 'intermediate', 'free', 'Open source, self-hosted, extensive customization, code nodes', 'Privacy-conscious businesses, custom integrations, developers', 400),
('Apache NiFi', 'local', 'advanced', 'free', 'Enterprise data flows, big data processing, robust monitoring', 'Data engineering, enterprise ETL, high-volume processing', 100),
('Huginn', 'local', 'intermediate', 'free', 'Web scraping focus, RSS feeds, monitoring', 'Data monitoring, web scraping, business dashboards', 50),
('Activepieces', 'local', 'intermediate', 'free', 'Business automation focus, self-hosted, visual builder', 'Business process automation, team workflows', 200),
('Windmill', 'local', 'intermediate', 'free', 'Code-first automation, TypeScript/Python, enterprise features', 'Developer teams, complex business logic, API workflows', 150),

-- Hybrid/API-based solutions
('Pipedream', 'hybrid', 'intermediate', 'freemium', 'Code + no-code, serverless, real-time triggers', 'Developers, API integrations, serverless workflows', 1000),
('Tray.io', 'cloud', 'advanced', 'paid', 'Enterprise-grade, visual builder, compliance features', 'Enterprise automation, complex business processes', 500),
('Workato', 'cloud', 'advanced', 'paid', 'Enterprise iPaaS, AI-powered recipes, robust security', 'Large enterprise, complex integrations, compliance', 1000);
EOF
}

# Intelligent workflow assessment
assess_workflows() {
    clear
    print_header "🧠 INTELLIGENT WORKFLOW ASSESSMENT"
    
    echo -e "\033[38;5;51m🔍 Let's analyze your workflows to find automation opportunities\033[0m"
    echo ""
    echo "I'll ask you contextual questions about your daily work patterns,"
    echo "then recommend the best automation platforms and solutions for YOU."
    echo ""
    
    # Bill's specific business workflow categories
    echo -e "\033[38;5;226m📋 Business workflow categories:\033[0m"
    echo "• Property management (VRBO, guest communication, booking workflows)"
    echo "• Content creation (blog posts, social media, marketing automation)"
    echo "• Data management (spreadsheets, CRM, business intelligence)"
    echo "• Communication (customer emails, team notifications, follow-ups)"
    echo "• File organization and backup (documents, contracts, media)"
    echo "• Financial workflows (invoicing, expense tracking, reporting)"
    echo "• Development and deployment (git, CI/CD, project management)"
    echo "• Lead generation and customer acquisition"
    echo ""
    
    local continue="y"
    while [ "$continue" = "y" ]; do
        add_workflow_assessment
        echo ""
        continue=$(prompt_user "Add another workflow? (y/n)" "n")
    done
    
    # Generate recommendations
    generate_automation_recommendations
}

# Add individual workflow assessment
add_workflow_assessment() {
    echo -e "\033[38;5;129m💡 WORKFLOW ASSESSMENT\033[0m"
    echo "======================="
    
    # Contextual workflow discovery
    local workflow_name
    workflow_name=$(prompt_user "What's this workflow called? (e.g., 'Guest check-in process')")
    
    local description
    description=$(prompt_user "Describe what you do in this workflow:")
    
    echo ""
    echo -e "\033[38;5;82m⏱️ FREQUENCY & TIME ANALYSIS\033[0m"
    local frequency
    echo "How often do you do this?"
    echo "1) Multiple times per day"
    echo "2) Daily"
    echo "3) Weekly"
    echo "4) Monthly"
    echo "5) Occasionally"
    local freq_choice
    freq_choice=$(prompt_user "Choose frequency (1-5)" "2")
    
    case "$freq_choice" in
        1) frequency="multiple_daily" ;;
        2) frequency="daily" ;;
        3) frequency="weekly" ;;
        4) frequency="monthly" ;;
        5) frequency="occasional" ;;
        *) frequency="daily" ;;
    esac
    
    local time_spent
    time_spent=$(prompt_user "How many minutes does this usually take?" "15")
    
    echo ""
    echo -e "\033[38;5;51m🛠️ TOOLS & PLATFORMS\033[0m"
    local tools_used
    tools_used=$(prompt_user "What tools/apps do you use? (comma-separated)")
    
    echo ""
    echo -e "\033[38;5;196m😤 PAIN POINTS\033[0m"
    local pain_points
    pain_points=$(prompt_user "What's annoying/repetitive about this workflow?")
    
    echo ""
    echo -e "\033[38;5;226m🎯 AUTOMATION POTENTIAL\033[0m"
    echo "How much of this could potentially be automated?"
    echo "1) Almost everything (90%+)"
    echo "2) Most of it (70-90%)"
    echo "3) About half (40-70%)"
    echo "4) Some parts (10-40%)"
    echo "5) Very little (<10%)"
    local auto_potential
    auto_potential=$(prompt_user "Choose automation potential (1-5)" "3")
    
    local current_solution
    current_solution=$(prompt_user "Any current automation/shortcuts you use?" "None")
    
    # Save to database
    sqlite3 "$WORKFLOW_ANALYSIS_DB" << EOF
INSERT INTO workflows (name, description, frequency, time_spent_minutes, tools_used, pain_points, automation_potential, current_solution)
VALUES ('$workflow_name', '$description', '$frequency', $time_spent, '$tools_used', '$pain_points', $auto_potential, '$current_solution');
EOF
    
    echo ""
    echo -e "\033[38;5;82m✅ Workflow analysis saved!\033[0m"
}

# Generate intelligent automation recommendations
generate_automation_recommendations() {
    clear
    print_header "🤖 INTELLIGENT AUTOMATION RECOMMENDATIONS"
    
    echo -e "\033[38;5;51m🧠 Analyzing your workflows and generating recommendations...\033[0m"
    echo ""
    
    # Get all workflows
    local workflows_count
    workflows_count=$(sqlite3 "$WORKFLOW_ANALYSIS_DB" "SELECT COUNT(*) FROM workflows;")
    
    if [ "$workflows_count" -eq 0 ]; then
        echo "❌ No workflows found. Please run workflow assessment first."
        return 1
    fi
    
    echo -e "\033[38;5;226m📊 WORKFLOW ANALYSIS SUMMARY\033[0m"
    echo "Found $workflows_count workflows to analyze..."
    echo ""
    
    # Analyze each workflow and generate recommendations
    while IFS='|' read -r id name frequency time_spent tools pain_points auto_potential; do
        echo -e "\033[38;5;129m🎯 Workflow: $name\033[0m"
        echo "Frequency: $(format_frequency "$frequency")"
        echo "Time spent: ${time_spent} minutes"
        echo "Tools: $tools"
        echo "Pain points: $pain_points"
        echo "Automation potential: $(format_automation_potential "$auto_potential")"
        echo ""
        
        # Generate platform recommendations based on context
        recommend_platforms_for_workflow "$id" "$tools" "$auto_potential" "$frequency"
        
        echo ""
        echo "---"
        echo ""
    done < <(sqlite3 "$WORKFLOW_ANALYSIS_DB" "SELECT id, name, frequency, time_spent_minutes, tools_used, pain_points, automation_potential FROM workflows;")
    
    # Generate comprehensive implementation guide
    generate_implementation_guide
}

# Recommend platforms for specific workflow
recommend_platforms_for_workflow() {
    local workflow_id="$1"
    local tools="$2"
    local auto_potential="$3"
    local frequency="$4"
    
    echo -e "\033[38;5;82m🚀 RECOMMENDED AUTOMATION PLATFORMS:\033[0m"
    
    # Smart platform selection based on context
    local recommended_platforms=()
    
    # Check for specific tool integrations
    if echo "$tools" | grep -iE "(google|gmail|sheets|drive)" >/dev/null; then
        recommended_platforms+=("Zapier|5|Excellent Google ecosystem integration")
        recommended_platforms+=("Microsoft Power Automate|4|Good Google integration with Office 365 bonus")
    fi
    
    if echo "$tools" | grep -iE "(office|excel|outlook|teams|sharepoint)" >/dev/null; then
        recommended_platforms+=("Microsoft Power Automate|5|Native Office 365 integration")
        recommended_platforms+=("Zapier|4|Strong Office 365 support")
    fi
    
    if echo "$tools" | grep -iE "(slack|discord|telegram)" >/dev/null; then
        recommended_platforms+=("Zapier|5|Excellent communication app support")
        recommended_platforms+=("n8n|4|Good chat integrations with self-hosting benefits")
    fi
    
    if echo "$tools" | grep -iE "(github|gitlab|git)" >/dev/null; then
        recommended_platforms+=("n8n|5|Excellent developer tool support")
        recommended_platforms+=("Pipedream|5|Developer-focused with code capabilities")
        recommended_platforms+=("Zapier|4|Good GitHub integration")
    fi
    
    # Frequency-based recommendations
    if [ "$frequency" = "multiple_daily" ] || [ "$frequency" = "daily" ]; then
        recommended_platforms+=("Zapier|5|Reliable for high-frequency automations")
        recommended_platforms+=("Microsoft Power Automate|4|Enterprise reliability")
    fi
    
    # Automation potential recommendations
    if [ "$auto_potential" -ge 4 ]; then
        recommended_platforms+=("n8n|5|Advanced automation capabilities for complex workflows")
        recommended_platforms+=("Integromat/Make|4|Excellent for complex multi-step processes")
    elif [ "$auto_potential" -le 2 ]; then
        recommended_platforms+=("IFTTT|4|Perfect for simple trigger-action automations")
        recommended_platforms+=("Zapier|3|Easy setup for basic automations")
    fi
    
    # Privacy/self-hosting preferences for business (assume Bill wants local control)
    recommended_platforms+=("n8n|4|Full business control with self-hosting")
    recommended_platforms+=("Activepieces|3|Business-focused local automation hub")
    
    # Remove duplicates and sort by score
    local unique_platforms
    unique_platforms=$(printf '%s\n' "${recommended_platforms[@]}" | sort -t'|' -k2 -nr | awk -F'|' '!seen[$1]++')
    
    # Display top 3 recommendations
    local count=0
    while IFS='|' read -r platform score reasoning && [ $count -lt 3 ]; do
        if [ -n "$platform" ]; then
            echo "$(($count + 1)). $platform (Score: $score/5)"
            echo "   Reason: $reasoning"
            
            # Get platform details
            local platform_details
            platform_details=$(sqlite3 "$WORKFLOW_ANALYSIS_DB" "SELECT type, complexity, cost, strengths FROM automation_platforms WHERE name = '$platform';")
            if [ -n "$platform_details" ]; then
                echo "   Details: $platform_details"
            fi
            echo ""
            
            # Save recommendation to database
            sqlite3 "$WORKFLOW_ANALYSIS_DB" << EOF
INSERT INTO workflow_recommendations (workflow_id, platform_id, recommendation_score, reasoning, estimated_time_savings)
SELECT $workflow_id, id, $score, '$reasoning', 0
FROM automation_platforms WHERE name = '$platform';
EOF
            
            count=$((count + 1))
        fi
    done <<< "$unique_platforms"
}

# Generate implementation guide
generate_implementation_guide() {
    echo -e "\033[38;5;196m📚 IMPLEMENTATION GUIDE\033[0m"
    echo "======================="
    echo ""
    
    echo -e "\033[38;5;51m🎯 NEXT STEPS:\033[0m"
    echo ""
    echo "1. **Start with Quick Wins**"
    echo "   • Pick the highest-impact, lowest-effort automations first"
    echo "   • Focus on daily/frequent workflows"
    echo ""
    
    echo "2. **Platform Selection Strategy**"
    echo "   • For business beginners: Start with Zapier"
    echo "   • For business privacy: Consider n8n (self-hosted)"
    echo "   • For Office 365 businesses: Microsoft Power Automate"
    echo "   • For developer/technical teams: n8n or Pipedream"
    echo "   • For enterprise workflows: Tray.io or Workato"
    echo ""
    
    echo "3. **Implementation Order**"
    echo "   • Customer communication workflows (email, CRM)"
    echo "   • Business data sync (spreadsheets, databases, reports)"
    echo "   • Lead generation and marketing automation"
    echo "   • Financial and invoicing workflows"
    echo "   • Complex multi-step business processes (last)"
    echo ""
    
    echo "4. **Best Practices**"
    echo "   • Test automations thoroughly before going live"
    echo "   • Set up error notifications"
    echo "   • Document your automations for maintenance"
    echo "   • Start simple, then add complexity"
    echo ""
    
    echo -e "\033[38;5;226m🛠️ BILL'S RECOMMENDED STARTER PACK:\033[0m"
    echo ""
    echo "**Immediate Setup (Week 1):**"
    echo "• Zapier account for general automation"
    echo "• n8n for self-hosted control"
    echo "• Google Workspace integration"
    echo ""
    
    echo "**Quick Wins (Week 2-3):**"
    echo "• VRBO guest communication automation"
    echo "• Google Tasks integration for property management"
    echo "• Lead capture and CRM automation"
    echo "• Automated invoice generation"
    echo ""
    
    echo "**Advanced Workflows (Month 2+):**"
    echo "• Revenue tracking and business intelligence"
    echo "• Content creation and marketing workflows"
    echo "• Multi-platform business process automation"
    echo "• Custom API integrations for business tools"
    echo ""
}

# Format helper functions
format_frequency() {
    case "$1" in
        "multiple_daily") echo "Multiple times per day" ;;
        "daily") echo "Daily" ;;
        "weekly") echo "Weekly" ;;
        "monthly") echo "Monthly" ;;
        "occasional") echo "Occasionally" ;;
        *) echo "Unknown" ;;
    esac
}

format_automation_potential() {
    case "$1" in
        1) echo "Almost everything (90%+)" ;;
        2) echo "Most of it (70-90%)" ;;
        3) echo "About half (40-70%)" ;;
        4) echo "Some parts (10-40%)" ;;
        5) echo "Very little (<10%)" ;;
        *) echo "Unknown" ;;
    esac
}

# Show existing automation platforms
show_automation_platforms() {
    clear
    print_header "🌟 AUTOMATION PLATFORM DIRECTORY"
    
    echo -e "\033[38;5;51m📋 Available automation platforms and their strengths:\033[0m"
    echo ""
    
    # Group by type
    echo -e "\033[38;5;82m☁️ CLOUD-BASED PLATFORMS:\033[0m"
    sqlite3 "$WORKFLOW_ANALYSIS_DB" -header -column "SELECT name, complexity, cost, strengths FROM automation_platforms WHERE type = 'cloud' ORDER BY integration_count DESC;"
    echo ""
    
    echo -e "\033[38;5;129m🏠 LOCAL/SELF-HOSTED BUSINESS SOLUTIONS:\033[0m"
    sqlite3 "$WORKFLOW_ANALYSIS_DB" -header -column "SELECT name, complexity, cost, strengths FROM automation_platforms WHERE type = 'local' ORDER BY integration_count DESC;"
    echo ""
    
    echo -e "\033[38;5;226m🔄 HYBRID SOLUTIONS:\033[0m"
    sqlite3 "$WORKFLOW_ANALYSIS_DB" -header -column "SELECT name, complexity, cost, strengths FROM automation_platforms WHERE type = 'hybrid' ORDER BY integration_count DESC;"
    echo ""
}

# Main menu
automation_advisor_menu() {
    while true; do
        clear
        print_header "💀 INTELLIGENT AUTOMATION ADVISOR 💀"
        
        echo -e "\033[38;5;51m🤖 AI-powered workflow analysis and automation recommendations\033[0m"
        echo ""
        echo "Choose your automation journey:"
        echo ""
        echo "1) 🔍 Assess My Workflows (Smart questionnaire)"
        echo "2) 🎯 View My Recommendations"
        echo "3) 🌟 Browse Automation Platforms"
        echo "4) 📊 View Workflow Analysis"
        echo "5) 🚀 Setup Specific Automation"
        echo "6) 📚 Automation Best Practices"
        echo "7) 🔧 Reset Analysis Data"
        echo "8) 🚪 Exit"
        echo ""
        
        local choice
        choice=$(prompt_user "Choose option (1-8)" "1")
        
        case "$choice" in
            1) assess_workflows ;;
            2) show_recommendations ;;
            3) show_automation_platforms ;;
            4) show_workflow_analysis ;;
            5) setup_specific_automation ;;
            6) show_best_practices ;;
            7) reset_analysis_data ;;
            8) echo "Automation consciousness terminated. 🤖"; break ;;
            *) echo "Invalid choice. Please select 1-8." && sleep 2 ;;
        esac
        
        if [ "$choice" != "8" ]; then
            echo ""
            prompt_user "Press Enter to continue..." ""
        fi
    done
}

# Show existing recommendations
show_recommendations() {
    clear
    print_header "🎯 YOUR AUTOMATION RECOMMENDATIONS"
    
    local rec_count
    rec_count=$(sqlite3 "$WORKFLOW_ANALYSIS_DB" "SELECT COUNT(*) FROM workflow_recommendations;")
    
    if [ "$rec_count" -eq 0 ]; then
        echo "❌ No recommendations found. Please run workflow assessment first."
        return 1
    fi
    
    echo -e "\033[38;5;51m📋 Generated recommendations based on your workflow analysis:\033[0m"
    echo ""
    
    sqlite3 "$WORKFLOW_ANALYSIS_DB" << 'EOF'
SELECT 
    w.name as "Workflow",
    ap.name as "Platform", 
    wr.recommendation_score as "Score",
    wr.reasoning as "Why This Platform"
FROM workflow_recommendations wr
JOIN workflows w ON wr.workflow_id = w.id
JOIN automation_platforms ap ON wr.platform_id = ap.id
ORDER BY wr.recommendation_score DESC;
EOF
}

# Show workflow analysis summary
show_workflow_analysis() {
    clear
    print_header "📊 WORKFLOW ANALYSIS SUMMARY"
    
    echo -e "\033[38;5;51m📈 Your current workflow patterns:\033[0m"
    echo ""
    
    sqlite3 "$WORKFLOW_ANALYSIS_DB" -header -column "SELECT name, frequency, time_spent_minutes as 'Time (min)', automation_potential as 'Auto Score' FROM workflows ORDER BY time_spent_minutes DESC;"
}

# Reset analysis data
reset_analysis_data() {
    echo -e "\033[38;5;196m⚠️ WARNING: This will delete all workflow analysis data!\033[0m"
    echo ""
    
    if confirm "Are you sure you want to reset all data?"; then
        sqlite3 "$WORKFLOW_ANALYSIS_DB" << 'EOF'
DELETE FROM workflow_recommendations;
DELETE FROM workflows;
EOF
        echo "✅ Analysis data reset successfully."
    else
        echo "❌ Reset cancelled."
    fi
}

# Setup specific automation
setup_specific_automation() {
    echo -e "\033[38;5;226m🚀 SPECIFIC AUTOMATION SETUP\033[0m"
    echo ""
    echo "🎯 Choose your automation platform to set up:"
    echo ""
    echo "1) 🟢 Zapier - Web-based automation (easiest)"
    echo "   💡 Best for: Web services, SaaS integrations"
    echo "   🚀 Setup: Account creation + workflow templates"
    echo ""
    echo "2) 🔵 n8n - Self-hosted automation (most powerful)"
    echo "   💡 Best for: Privacy, complex workflows, local control"
    echo "   🚀 Setup: Docker installation + configuration"
    echo ""
    echo "3) 🟠 IFTTT - Simple trigger-action automation"
    echo "   💡 Best for: IoT, social media, simple triggers"
    echo "   🚀 Setup: Mobile app + applet configuration"
    echo ""
    echo "4) ⚡ Custom Scripts - Bill Sloth automation scripts"
    echo "   💡 Best for: System-specific tasks, local automation"
    echo "   🚀 Setup: Bash scripts + cron jobs"
    echo ""
    echo "5) 🎯 All Platforms - Complete automation ecosystem"
    echo "   💡 Best for: Maximum flexibility and power"
    echo "   🚀 Setup: Guided setup for all platforms"
    echo ""
    
    read -p "Select automation platform (1-5): " platform_choice
    
    case $platform_choice in
        1) setup_zapier_automation ;;
        2) setup_n8n_automation ;;
        3) setup_ifttt_automation ;;
        4) setup_custom_scripts_automation ;;
        5) setup_all_automation_platforms ;;
        *) echo "❌ Invalid choice. Please select 1-5." ;;
    esac
}

# Show best practices
show_best_practices() {
    clear
    print_header "📚 AUTOMATION BEST PRACTICES"
    
    echo -e "\033[38;5;51m🏆 Expert tips for successful automation:\033[0m"
    echo ""
    
    cat << 'EOF'
🎯 **Start Small, Scale Up**
• Begin with simple, single-step automations
• Add complexity gradually as you gain confidence
• Test each step before adding the next

🛡️ **Error Handling & Monitoring**
• Set up failure notifications for critical automations
• Include fallback actions when possible
• Monitor automation performance regularly

🔒 **Security & Privacy**
• Use secure authentication methods (OAuth when possible)
• Limit API permissions to minimum required
• Consider self-hosted solutions for sensitive data

📊 **Documentation & Maintenance**
• Document what each automation does
• Note dependencies and requirements
• Schedule regular reviews and updates

⚡ **Performance Optimization**
• Avoid unnecessary API calls
• Use webhooks instead of polling when possible
• Batch operations when supported

🧠 **ADHD-Friendly Business Automation Design**
• Keep business automations predictable and transparent
• Add confirmation steps for important financial/customer actions
• Use visual indicators and clear naming for business processes
• Set up regular summary reports to maintain awareness

💡 **ROI Maximization**
• Focus on high-frequency, time-consuming tasks first
• Measure time savings after implementation
• Automate the automations (meta-automation)
EOF
}

# Specific automation platform setup functions
setup_zapier_automation() {
    echo "🟢 ZAPIER AUTOMATION SETUP"
    echo "=========================="
    echo ""
    echo "📋 Setting up Zapier automation:"
    echo ""
    echo "1️⃣ Create Zapier account (if needed):"
    echo "   🌐 Visit: https://zapier.com/sign-up"
    echo "   💡 Tip: Start with free plan (100 tasks/month)"
    echo ""
    echo "2️⃣ Recommended Zaps for Bill Sloth users:"
    echo "   📧 Gmail → Google Sheets (track important emails)"
    echo "   📅 Google Calendar → Slack (meeting reminders)"
    echo "   📝 Typeform → Airtable (collect and organize data)"
    echo "   🗂️ Google Drive → Dropbox (backup automation)"
    echo ""
    echo "3️⃣ Bill-specific workflow templates:"
    mkdir -p ~/.bill-sloth/zapier-templates
    cat > ~/.bill-sloth/zapier-templates/vrbo-guest-workflow.txt << 'EOF'
VRBO Guest Communication Workflow:
Trigger: New email with "booking confirmed"
Actions:
1. Create Google Calendar event
2. Add task to Google Tasks
3. Send Slack notification
4. Update guest spreadsheet
EOF
    echo "   ✅ Created VRBO workflow template"
    echo ""
    echo "🚀 Next steps:"
    echo "   1. Log into Zapier and create your first Zap"
    echo "   2. Use templates in ~/.bill-sloth/zapier-templates/"
    echo "   3. Test workflows with sample data"
}

setup_n8n_automation() {
    echo "🔵 N8N AUTOMATION SETUP"
    echo "======================="
    echo ""
    echo "📋 Setting up n8n (self-hosted automation):"
    echo ""
    
    # Check for Docker
    if command -v docker &> /dev/null; then
        echo "✅ Docker detected - ready for n8n installation"
        echo ""
        echo "🚀 Installing n8n with Docker:"
        
        # Create n8n directory
        mkdir -p ~/.bill-sloth/n8n/{data,workflows}
        
        echo "📁 Created n8n directories"
        echo ""
        
        # Create docker-compose file
        cat > ~/.bill-sloth/n8n/docker-compose.yml << 'EOF'
version: '3.1'
services:
  n8n:
    image: n8nio/n8n
    restart: always
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=bill
      - N8N_BASIC_AUTH_PASSWORD=sloth123
    volumes:
      - ~/.bill-sloth/n8n/data:/home/node/.n8n
      - ~/.bill-sloth/n8n/workflows:/workflows
EOF
        
        echo "🐳 Starting n8n with Docker:"
        cd ~/.bill-sloth/n8n
        docker-compose up -d
        
        echo ""
        echo "✅ n8n installation complete!"
        echo "🌐 Access n8n at: http://localhost:5678"
        echo "👤 Username: bill"
        echo "🔐 Password: sloth123"
        echo ""
        echo "📝 Change password after first login!"
    else
        echo "❌ Docker not found. Installing Docker first..."
        echo ""
        echo "🐳 Docker installation (Ubuntu/WSL):"
        echo "curl -fsSL https://get.docker.com -o get-docker.sh"
        echo "sudo sh get-docker.sh"
        echo "sudo usermod -aG docker \$USER"
        echo ""
        echo "⚠️  After Docker installation, re-run this setup"
    fi
}

setup_ifttt_automation() {
    echo "🟠 IFTTT AUTOMATION SETUP"
    echo "========================="
    echo ""
    echo "📋 Setting up IFTTT (If This Then That):"
    echo ""
    echo "1️⃣ Download IFTTT app:"
    echo "   📱 iOS: https://apps.apple.com/app/ifttt/id660944635"
    echo "   🤖 Android: https://play.google.com/store/apps/details?id=com.ifttt.ifttt"
    echo ""
    echo "2️⃣ Recommended applets for Bill Sloth users:"
    echo "   🏠 Smart home integration (lights, locks, etc.)"
    echo "   📧 Email notifications for important events"
    echo "   📱 Phone automation (location-based triggers)"
    echo "   ☁️ Weather-based automation"
    echo ""
    echo "3️⃣ Bill-specific IFTTT ideas:"
    mkdir -p ~/.bill-sloth/ifttt-templates
    cat > ~/.bill-sloth/ifttt-templates/applet-ideas.txt << 'EOF'
Bill Sloth IFTTT Applet Ideas:

1. Location-based reminders:
   - When I arrive at VRBO property → Send checkout checklist

2. Time-based automation:
   - Every Monday 9 AM → Create weekly planning task

3. Weather integration:
   - If rain forecast → Remind to update VRBO guest instructions

4. Social media automation:
   - New Instagram post → Save to Google Drive folder

5. Smart home integration:
   - When I leave home → Turn off all lights and set security
EOF
    echo "   ✅ Created IFTTT applet ideas"
    echo ""
    echo "🚀 Next steps:"
    echo "   1. Create IFTTT account and connect services"
    echo "   2. Browse applet ideas in ~/.bill-sloth/ifttt-templates/"
    echo "   3. Start with simple applets and build complexity"
}

setup_custom_scripts_automation() {
    echo "⚡ CUSTOM SCRIPTS AUTOMATION SETUP"
    echo "=================================="
    echo ""
    echo "📋 Setting up Bill Sloth custom automation scripts:"
    echo ""
    
    # Create automation scripts directory
    mkdir -p ~/.bill-sloth/automation-scripts/{daily,weekly,monthly}
    
    # Daily automation script
    cat > ~/.bill-sloth/automation-scripts/daily/morning-routine.sh << 'EOF'
#!/bin/bash
# Daily morning routine automation
echo "🌅 Good morning, Bill! Starting your daily automation..."

# Check weather
curl -s "wttr.in/YourCity?format=3" 

# Check calendar for today
gcalcli agenda --calendar="primary" --tsv --nocolor

# VRBO property check (if applicable)
if [ -d ~/.bill-sloth/vrbo-automation ]; then
    echo "🏠 Checking VRBO properties..."
    # Add VRBO-specific checks here
fi

# EdBoiGames business check
if [ -d ~/edboigames_business ]; then
    echo "🎮 Checking EdBoiGames metrics..."
    # Add business metrics here
fi

echo "✅ Daily automation complete!"
EOF
    
    # Weekly automation script
    cat > ~/.bill-sloth/automation-scripts/weekly/sunday-planning.sh << 'EOF'
#!/bin/bash
# Weekly planning automation
echo "📅 Starting weekly planning automation..."

# Create weekly backup
mkdir -p ~/.bill-sloth/backups/$(date +%Y-%m-%d)

# Generate weekly report
echo "📊 Weekly Report - $(date)" > ~/.bill-sloth/reports/weekly-$(date +%Y-%m-%d).txt

# VRBO weekly summary
echo "🏠 VRBO Properties:" >> ~/.bill-sloth/reports/weekly-$(date +%Y-%m-%d).txt

# EdBoiGames weekly summary  
echo "🎮 EdBoiGames Business:" >> ~/.bill-sloth/reports/weekly-$(date +%Y-%m-%d).txt

echo "✅ Weekly planning complete!"
EOF
    
    # Make scripts executable
    chmod +x ~/.bill-sloth/automation-scripts/daily/*.sh
    chmod +x ~/.bill-sloth/automation-scripts/weekly/*.sh
    
    echo "✅ Created custom automation scripts:"
    echo "   📁 Daily: ~/.bill-sloth/automation-scripts/daily/"
    echo "   📁 Weekly: ~/.bill-sloth/automation-scripts/weekly/"
    echo ""
    echo "🕒 Setting up cron jobs for automation:"
    
    # Add cron jobs
    (crontab -l 2>/dev/null; echo "# Bill Sloth daily automation") | crontab -
    (crontab -l 2>/dev/null; echo "0 8 * * * ~/.bill-sloth/automation-scripts/daily/morning-routine.sh") | crontab -
    (crontab -l 2>/dev/null; echo "# Bill Sloth weekly automation") | crontab -
    (crontab -l 2>/dev/null; echo "0 9 * * 0 ~/.bill-sloth/automation-scripts/weekly/sunday-planning.sh") | crontab -
    
    echo "✅ Cron jobs configured:"
    echo "   🌅 Daily routine: 8:00 AM every day"
    echo "   📅 Weekly planning: 9:00 AM every Sunday"
    echo ""
    echo "🔧 Manage cron jobs with:"
    echo "   View: crontab -l"
    echo "   Edit: crontab -e"
}

setup_all_automation_platforms() {
    echo "🎯 COMPLETE AUTOMATION ECOSYSTEM SETUP"
    echo "======================================"
    echo ""
    echo "🚀 Setting up all automation platforms for maximum power..."
    echo ""
    
    # Run all setup functions
    setup_zapier_automation
    echo ""
    echo "─────────────────────────────────────────────────────────"
    echo ""
    setup_n8n_automation
    echo ""
    echo "─────────────────────────────────────────────────────────"
    echo ""
    setup_ifttt_automation
    echo ""
    echo "─────────────────────────────────────────────────────────"
    echo ""
    setup_custom_scripts_automation
    echo ""
    echo "🎉 COMPLETE AUTOMATION ECOSYSTEM READY!"
    echo "======================================="
    echo ""
    echo "📊 Your automation toolkit:"
    echo "   🟢 Zapier: Web service automation"
    echo "   🔵 n8n: Self-hosted workflows"
    echo "   🟠 IFTTT: Mobile and IoT automation"
    echo "   ⚡ Custom Scripts: Local system automation"
    echo ""
    echo "🎯 Next steps:"
    echo "   1. Test each platform with simple workflows"
    echo "   2. Connect platforms for complex automation chains"
    echo "   3. Monitor and optimize your automation ecosystem"
}

# Main function
main() {
    # Initialize on first run
    if [ ! -f "$WORKFLOW_ANALYSIS_DB" ]; then
        init_automation_advisor
    fi
    
    automation_advisor_menu
}

# Run if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi