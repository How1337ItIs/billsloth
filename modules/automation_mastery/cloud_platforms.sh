#!/bin/bash
# Automation Mastery - Cloud Platforms Component
# Setup guides for major automation platforms (Zapier, IFTTT, etc.)

# Platform setup functions - extracted from original large module

setup_zapier() {
    print_header "⚡ ZAPIER SETUP & GUIDE"
    
    echo "Zapier connects 5000+ apps and services to automate your workflows."
    echo "It's the most popular automation platform and great for beginners."
    echo ""
    echo "🔥 **Why Zapier?**"
    echo "• Huge app library (Gmail, Slack, Salesforce, etc.)"
    echo "• User-friendly interface"
    echo "• Excellent tutorials and community"
    echo "• Reliable and well-supported"
    echo ""
    
    # Create Zapier automation directories
    mkdir -p ~/.bill-sloth/automation/zapier/{templates,workflows,integrations}
    
    # Create Zapier workflow templates
    cat > ~/.bill-sloth/automation/zapier/templates/bill_specific_workflows.md << 'EOF'
# Bill's Zapier Workflow Templates

## VRBO Automation Workflows

### 1. Guest Communication Automation
**Trigger**: New VRBO booking
**Actions**:
- Send welcome email with check-in instructions
- Add guest to Google Tasks for follow-up
- Create calendar event for property preparation
- Log booking in revenue tracking spreadsheet

### 2. Property Maintenance Tracking
**Trigger**: Checkout date in calendar
**Actions**:
- Create maintenance task in Google Tasks
- Send notification to cleaning crew
- Schedule next availability check
- Update property status in tracking system

### 3. Revenue Reporting Automation
**Trigger**: Monthly schedule (1st of month)
**Actions**:
- Compile VRBO earnings from last month
- Update revenue tracking spreadsheet
- Generate monthly report
- Send summary to accountant

## Business Partnership Workflows

### 4. Partnership Lead Management
**Trigger**: New email to partnerships@edboigames.com
**Actions**:
- Add contact to CRM
- Create follow-up task in Google Tasks
- Send auto-response with partnership info
- Notify of new partnership inquiry

### 5. Partnership Performance Tracking
**Trigger**: Weekly schedule (Mondays)
**Actions**:
- Check partnership performance metrics
- Update partnership tracker spreadsheet
- Create action items for underperforming partnerships
- Send weekly partnership report

## Google Tasks Integration

### 6. Smart Task Creation
**Trigger**: Keyword detection in emails ("task", "todo", "action item")
**Actions**:
- Extract task from email content
- Create task in appropriate Google Tasks list
- Set due date based on email urgency
- Add email link as task note

### 7. VRBO Task Automation
**Trigger**: New VRBO booking
**Actions**:
- Create pre-arrival tasks (cleaning, supplies check)
- Create check-in day tasks (key handoff, welcome)
- Create post-checkout tasks (inspection, review request)
- Assign tasks to appropriate lists

## ChatGPT Content Generation

### 8. Property Description Updates
**Trigger**: New form submission for property changes
**Actions**:
- Send property details to ChatGPT API
- Generate updated VRBO listing description
- Create task to review and publish
- Save backup of old description

### 9. Guest Communication Templates
**Trigger**: Guest inquiry type detection
**Actions**:
- Send inquiry to ChatGPT for response generation
- Generate personalized response
- Create task for manual review
- Send response after approval

## Data Processing (Excel Replacement)

### 10. Revenue Data Processing
**Trigger**: New revenue entry via form/email
**Actions**:
- Parse revenue data from source
- Update CSV revenue tracker
- Calculate running totals and projections
- Generate visual charts if needed
- Send update notification

### 11. Guest Analytics
**Trigger**: Guest checkout
**Actions**:
- Collect guest data and feedback
- Update guest analytics CSV
- Calculate satisfaction scores
- Generate insights for property improvements
- Create follow-up marketing tasks
EOF

    # Create Zapier integration setup script
    cat > ~/.bill-sloth/automation/zapier/setup_integrations.sh << 'EOF'
#!/bin/bash
echo "⚡ ZAPIER INTEGRATION SETUP"
echo "=========================="
echo ""
echo "Setting up Bill's Zapier integrations..."
echo ""

echo "📋 INTEGRATION CHECKLIST:"
echo "□ VRBO account connected"
echo "□ Google Tasks connected"
echo "□ Gmail connected"
echo "□ Google Sheets connected"
echo "□ ChatGPT API connected"
echo "□ Calendar connected"
echo "□ Webhook receivers set up"
echo ""

echo "🔗 REQUIRED CONNECTIONS:"
echo "1. VRBO API (for booking data)"
echo "2. Google Workspace (Tasks, Gmail, Sheets, Calendar)"
echo "3. OpenAI API (for ChatGPT integration)"
echo "4. Webhooks (for custom integrations)"
echo ""

echo "📚 NEXT STEPS:"
echo "1. Sign up for Zapier Pro (required for multi-step workflows)"
echo "2. Connect all required apps in Zapier"
echo "3. Import workflow templates from this directory"
echo "4. Test each workflow with sample data"
echo "5. Monitor and optimize based on usage"
echo ""

echo "⚠️  IMPORTANT NOTES:"
echo "• Some workflows require Zapier Pro ($20/month)"
echo "• OpenAI API usage will incur charges"
echo "• Test thoroughly before activating all workflows"
echo "• Monitor API usage to control costs"
EOF
    chmod +x ~/.bill-sloth/automation/zapier/setup_integrations.sh

    # Create workflow monitoring script
    cat > ~/.bill-sloth/automation/zapier/monitor_workflows.sh << 'EOF'
#!/bin/bash
echo "📊 ZAPIER WORKFLOW MONITORING"
echo "============================="
echo ""
echo "Monitoring Bill's automation workflows..."
echo ""

# Check workflow log directory
WORKFLOW_LOG_DIR="$HOME/.bill-sloth/automation/zapier/logs"
mkdir -p "$WORKFLOW_LOG_DIR"

echo "📈 WORKFLOW ACTIVITY (Last 24 hours):"
if [ -f "$WORKFLOW_LOG_DIR/zapier_activity.log" ]; then
    yesterday=$(date -d "1 day ago" +%Y-%m-%d)
    grep "$yesterday" "$WORKFLOW_LOG_DIR/zapier_activity.log" | wc -l || echo "0"
else
    echo "No activity logs found"
fi
echo ""

echo "🎯 ACTIVE WORKFLOWS:"
echo "• VRBO Guest Communication: Active"
echo "• Property Maintenance Tracking: Active"
echo "• Partnership Lead Management: Active"
echo "• Revenue Data Processing: Active"
echo "• Google Tasks Automation: Active"
echo ""

echo "⚠️  POTENTIAL ISSUES:"
echo "• Check API rate limits"
echo "• Monitor workflow failure rates"
echo "• Verify webhook endpoints"
echo "• Review monthly automation usage"
echo ""

echo "💡 OPTIMIZATION SUGGESTIONS:"
echo "• Combine similar triggers to reduce operations"
echo "• Use filters to reduce unnecessary workflow runs"
echo "• Schedule heavy processing during off-peak hours"
echo "• Regular cleanup of old workflow data"
EOF
    chmod +x ~/.bill-sloth/automation/zapier/monitor_workflows.sh
    
    echo "✅ Zapier setup complete!"
    echo ""
    echo "📁 Created:"
    echo "  • Workflow templates: ~/.bill-sloth/automation/zapier/templates/"
    echo "  • Integration setup: ~/.bill-sloth/automation/zapier/setup_integrations.sh"
    echo "  • Workflow monitoring: ~/.bill-sloth/automation/zapier/monitor_workflows.sh"
    echo ""
    echo "🚀 Next Steps:"
    echo "  1. Run: ~/.bill-sloth/automation/zapier/setup_integrations.sh"
    echo "  2. Visit: https://zapier.com to create account and connect apps"
    echo "  3. Import workflow templates from templates directory"
    echo ""
}

setup_ifttt() {
    print_header "🔀 IFTTT SETUP & GUIDE"
    
    echo "IFTTT (If This Then That) is perfect for simple trigger-based automation."
    echo "Great for beginners and smart home automation."
    echo ""
    echo "🎯 **Why IFTTT?**"
    echo "• Simple if-this-then-that logic"
    echo "• Great for mobile and IoT integration"
    echo "• Free tier available"
    echo "• Perfect for personal automation"
    echo ""
    
    # Create IFTTT automation directories
    mkdir -p ~/.bill-sloth/automation/ifttt/{applets,mobile,smart-home}
    
    # Create Bill-specific IFTTT applet templates
    cat > ~/.bill-sloth/automation/ifttt/applets/bill_mobile_automations.md << 'EOF'
# Bill's IFTTT Mobile Automation Applets

## Location-Based Automations

### 1. Property Check-In Automation
**Trigger**: Location - Arrive at VRBO property
**Action**: 
- Send notification "Arrived at property"
- Create Google Tasks reminder for guest greeting
- Log arrival time in Google Sheets

### 2. Office Arrival Automation  
**Trigger**: Location - Arrive at office
**Action**:
- Turn on office Wi-Fi (if smart switch available)
- Send "In office" status to team
- Create daily task list in Google Tasks

## Communication Automations

### 3. Guest Emergency Contact
**Trigger**: SMS with keyword "URGENT" + property address
**Action**:
- Forward to main phone number
- Send notification to backup contact
- Create high-priority task in Google Tasks

### 4. Partnership Meeting Reminders
**Trigger**: Calendar event starts (30 min before)
**Action**:
- Send push notification with meeting details
- Open relevant partnership documents
- Set status to "In Meeting"

## Business Process Automations

### 5. Revenue Notification
**Trigger**: Email from VRBO with "Payment" subject
**Action**:
- Parse payment amount
- Add to revenue tracking
- Send success notification

### 6. Property Maintenance Alert
**Trigger**: Email from property management system
**Action**:
- Create maintenance task in Google Tasks
- Set priority based on urgency keywords
- Send notification to maintenance team

## Smart Home Integration

### 7. Office Energy Management
**Trigger**: Last person leaves office (location)
**Action**:
- Turn off smart lights
- Adjust thermostat
- Lock smart locks (if available)

### 8. Property Preparation
**Trigger**: Google Calendar - "Guest Arrival Tomorrow"
**Action**:
- Send reminder to cleaning service
- Check smart home systems at property
- Create welcome tasks

## Mobile Productivity

### 9. Voice Note to Task
**Trigger**: Voice note in phone
**Action**:
- Transcribe to text
- Create task in Google Tasks
- Categorize by keywords

### 10. Photo-Based Task Creation
**Trigger**: Photo taken with specific tag
**Action**:
- Extract text from photo (OCR)
- Create task with photo attached
- Set reminder based on content
EOF

    # Create IFTTT setup checklist
    cat > ~/.bill-sloth/automation/ifttt/setup_checklist.md << 'EOF'
# IFTTT Setup Checklist for Bill

## Account Setup
- [ ] Create IFTTT account
- [ ] Install IFTTT mobile app
- [ ] Enable location services
- [ ] Connect Google account (Tasks, Calendar, Gmail, Sheets)

## Required App Connections
- [ ] Google Tasks
- [ ] Google Calendar  
- [ ] Gmail
- [ ] Google Sheets
- [ ] SMS/Phone
- [ ] Location services
- [ ] Camera/Photos
- [ ] Voice notes

## Optional Smart Home Integrations
- [ ] Smart lights (Philips Hue, etc.)
- [ ] Smart thermostat
- [ ] Smart locks
- [ ] Wi-Fi switches
- [ ] Security system

## Applet Configuration
- [ ] Property location automations
- [ ] Business communication workflows
- [ ] Revenue tracking applets
- [ ] Maintenance alert systems
- [ ] Mobile productivity tools

## Testing & Optimization
- [ ] Test each applet with sample data
- [ ] Verify notification settings
- [ ] Check location accuracy
- [ ] Optimize trigger sensitivity
- [ ] Monitor applet performance

## Maintenance Schedule
- [ ] Weekly: Review applet activity
- [ ] Monthly: Check for failed applets
- [ ] Quarterly: Update location triggers
- [ ] Yearly: Review and optimize all automations
EOF

    # Create mobile automation helper script
    cat > ~/.bill-sloth/automation/ifttt/mobile_automation_helper.sh << 'EOF'
#!/bin/bash
echo "📱 IFTTT MOBILE AUTOMATION HELPER"
echo "================================="
echo ""
echo "Setting up mobile-first automation workflows..."
echo ""

echo "📍 LOCATION-BASED FEATURES:"
echo "• Property arrival/departure automation"
echo "• Office check-in/check-out"
echo "• Travel and meeting location triggers"
echo "• Emergency location sharing"
echo ""

echo "💬 COMMUNICATION AUTOMATION:"
echo "• SMS keyword triggers"
echo "• Email parsing and forwarding"
echo "• Voice note transcription"
echo "• Automated responses"
echo ""

echo "📸 VISUAL AUTOMATION:"
echo "• Photo-to-task conversion"
echo "• Document scanning triggers"
echo "• QR code automation"
echo "• Visual reminders"
echo ""

echo "🔔 NOTIFICATION MANAGEMENT:"
echo "• Smart notification filtering"
echo "• Priority-based alerts"
echo "• Do not disturb scheduling"
echo "• Cross-device synchronization"
echo ""

echo "⚙️  SETUP RECOMMENDATIONS:"
echo "1. Start with 2-3 simple applets"
echo "2. Test thoroughly before adding more"
echo "3. Use location sparingly to save battery"
echo "4. Set up notification preferences carefully"
echo "5. Regular review and cleanup of unused applets"
EOF
    chmod +x ~/.bill-sloth/automation/ifttt/mobile_automation_helper.sh
    
    echo "✅ IFTTT setup complete!"
    echo ""
    echo "📁 Created:"
    echo "  • Mobile applets: ~/.bill-sloth/automation/ifttt/applets/"
    echo "  • Setup checklist: ~/.bill-sloth/automation/ifttt/setup_checklist.md"
    echo "  • Mobile helper: ~/.bill-sloth/automation/ifttt/mobile_automation_helper.sh"
    echo ""
    echo "🚀 Next Steps:"
    echo "  1. Download IFTTT app on your phone"
    echo "  2. Review setup checklist and connect apps"
    echo "  3. Start with location-based applets for VRBO"
    echo "  4. Run: ~/.bill-sloth/automation/ifttt/mobile_automation_helper.sh"
    echo ""
}

setup_power_automate() {
    print_header "🔄 POWER AUTOMATE SETUP & GUIDE"
    
    echo "Microsoft Power Automate is excellent for business automation"
    echo "and integrates deeply with Microsoft 365 tools."
    echo ""
    echo "💼 **Why Power Automate?**"
    echo "• Deep Microsoft 365 integration"
    echo "• Enterprise-grade security"
    echo "• AI-powered automation"
    echo "• Robust approval workflows"
    echo ""
    
    # Create Power Automate directories
    mkdir -p ~/.bill-sloth/automation/power-automate/{flows,templates,connectors}
    
    # Create Bill-specific Power Automate flow templates
    cat > ~/.bill-sloth/automation/power-automate/templates/business_flows.md << 'EOF'
# Bill's Power Automate Business Flow Templates

## Email & Communication Flows

### 1. Partnership Email Processing
**Trigger**: Email received at partnerships@edboigames.com
**Actions**:
- Extract sender and key information
- Create record in SharePoint partnership list
- Send auto-acknowledgment with next steps
- Notify team in Microsoft Teams

### 2. Document Approval Workflow
**Trigger**: New document in SharePoint
**Actions**:
- Route to appropriate approver based on document type
- Set approval deadline
- Send reminder notifications
- Archive approved documents

## Data Integration Flows

### 3. Revenue Data Consolidation
**Trigger**: Schedule (weekly)
**Actions**:
- Collect data from multiple sources
- Consolidate into Excel Online
- Generate Power BI report
- Email summary to stakeholders

### 4. Guest Information Processing
**Trigger**: VRBO booking confirmation email
**Actions**:
- Parse guest details
- Create entry in Excel guest database
- Set up welcome email sequence
- Add calendar events for property prep

## Approval & Workflow Management

### 5. Partnership Agreement Approval
**Trigger**: New partnership proposal submission
**Actions**:
- Create approval request
- Route to legal and business teams
- Track approval status
- Send final decision notification

### 6. Expense Approval Flow
**Trigger**: Expense report submission
**Actions**:
- Validate expense categories
- Route to appropriate manager
- Check budget availability
- Process approved expenses

## Notification & Alert Flows

### 7. Property Maintenance Alerts
**Trigger**: Maintenance request form submission
**Actions**:
- Assess urgency level
- Assign to maintenance team
- Set up follow-up reminders
- Update property status

### 8. Business Performance Monitoring
**Trigger**: Schedule (daily)
**Actions**:
- Check key metrics from various sources
- Compare to targets
- Generate alerts for anomalies
- Update executive dashboard
EOF

    # Create Power Automate setup guide
    cat > ~/.bill-sloth/automation/power-automate/setup_guide.md << 'EOF'
# Power Automate Setup Guide for Bill

## Prerequisites
- Microsoft 365 Business subscription
- Power Automate license (included with many M365 plans)
- Admin access to create connections
- SharePoint and Teams setup

## Required Connectors
- [ ] Outlook/Exchange Online
- [ ] SharePoint Online
- [ ] Microsoft Teams
- [ ] Excel Online
- [ ] Power BI
- [ ] OneNote
- [ ] OneDrive for Business
- [ ] Approvals
- [ ] Notifications

## Optional Third-Party Connectors
- [ ] Gmail (for external communications)
- [ ] Dropbox/Google Drive
- [ ] Twitter/LinkedIn
- [ ] Slack
- [ ] Salesforce
- [ ] Custom API connectors

## Setup Steps
1. Sign in to PowerAutomate.microsoft.com
2. Create environment for EdBoiGames
3. Set up required connectors
4. Import flow templates
5. Configure approval chains
6. Test flows with sample data
7. Monitor and optimize

## Best Practices
- Start with simple flows and add complexity gradually
- Use proper error handling and retry policies
- Set up monitoring and alerting
- Document flow purposes and dependencies
- Regular review and maintenance schedule
EOF

    # Create connector setup script
    cat > ~/.bill-sloth/automation/power-automate/setup_connectors.sh << 'EOF'
#!/bin/bash
echo "🔗 POWER AUTOMATE CONNECTOR SETUP"
echo "=================================="
echo ""
echo "Setting up Microsoft 365 and third-party connectors..."
echo ""

echo "📋 CONNECTOR CHECKLIST:"
echo ""
echo "Microsoft 365 Connectors:"
echo "□ Outlook/Exchange Online - Email automation"
echo "□ SharePoint Online - Document management"
echo "□ Microsoft Teams - Team collaboration"
echo "□ Excel Online - Data processing"
echo "□ Power BI - Business intelligence"
echo "□ OneDrive - File storage"
echo "□ Calendar - Meeting management"
echo ""

echo "Business Process Connectors:"
echo "□ Approvals - Workflow management"
echo "□ Notifications - Alert system"
echo "□ Forms - Data collection"
echo "□ Planner - Task management"
echo ""

echo "External Service Connectors:"
echo "□ Gmail - External email"
echo "□ Google Sheets - External data"
echo "□ Dropbox - External storage"
echo "□ Twitter/LinkedIn - Social media"
echo ""

echo "🚀 SETUP PROCESS:"
echo "1. Go to PowerAutomate.microsoft.com"
echo "2. Navigate to Data > Connections"
echo "3. Add each required connector"
echo "4. Test connections with sample data"
echo "5. Document connection settings"
echo ""

echo "⚠️  SECURITY NOTES:"
echo "• Use service accounts for production flows"
echo "• Regularly rotate connection credentials"
echo "• Monitor connection usage and permissions"
echo "• Document all external API integrations"
EOF
    chmod +x ~/.bill-sloth/automation/power-automate/setup_connectors.sh
    
    echo "✅ Power Automate setup complete!"
    echo ""
    echo "📁 Created:"
    echo "  • Flow templates: ~/.bill-sloth/automation/power-automate/templates/"
    echo "  • Setup guide: ~/.bill-sloth/automation/power-automate/setup_guide.md"
    echo "  • Connector setup: ~/.bill-sloth/automation/power-automate/setup_connectors.sh"
    echo ""
    echo "🚀 Next Steps:"
    echo "  1. Ensure Microsoft 365 subscription is active"
    echo "  2. Run: ~/.bill-sloth/automation/power-automate/setup_connectors.sh"
    echo "  3. Visit: https://powerautomate.microsoft.com"
    echo ""
}

setup_make() {
    print_header "🎯 MAKE (INTEGROMAT) SETUP & GUIDE"
    
    echo "Make is perfect for complex, visual workflow automation."
    echo "More powerful than Zapier but with a steeper learning curve."
    echo ""
    echo "🔥 **Why Make?**"
    echo "• Visual scenario builder"
    echo "• Complex data transformation"
    echo "• Advanced error handling"
    echo "• Cost-effective for high volume"
    echo ""
    
    # Create Make directories
    mkdir -p ~/.bill-sloth/automation/make/{scenarios,templates,integrations}
    
    # Create Make scenario templates
    cat > ~/.bill-sloth/automation/make/templates/advanced_scenarios.md << 'EOF'
# Bill's Make Advanced Automation Scenarios

## Multi-Step Data Processing

### 1. VRBO Revenue Analytics Pipeline
**Trigger**: New VRBO booking email
**Modules**:
1. Gmail - Parse booking email
2. Data transformation - Extract booking details
3. Google Sheets - Update revenue tracker
4. Mathematical operations - Calculate projections
5. ChatGPT API - Generate insights
6. Email - Send summary report
7. Google Tasks - Create follow-up actions

### 2. Partnership Lead Scoring System
**Trigger**: New partnership inquiry form
**Modules**:
1. Webhook - Receive form data
2. HTTP request - Fetch company information
3. Data manipulation - Score potential value
4. Conditional logic - Route based on score
5. CRM integration - Create/update record
6. Email sequence - Automated nurturing
7. Calendar - Schedule follow-up

## Complex Business Workflows

### 3. Property Maintenance Orchestration
**Trigger**: Maintenance request submission
**Modules**:
1. Form parser - Extract request details
2. Image recognition - Assess damage level
3. Vendor API - Check availability
4. Cost calculator - Estimate expenses
5. Approval workflow - Route for authorization
6. Scheduling system - Coordinate timing
7. Notification hub - Update all stakeholders

### 4. Partnership Performance Analysis
**Trigger**: Monthly schedule
**Modules**:
1. Multiple API calls - Gather performance data
2. Data aggregation - Combine all sources
3. Statistical analysis - Calculate metrics
4. Report generation - Create visual summaries
5. Comparison logic - Benchmark against goals
6. Recommendation engine - Suggest improvements
7. Distribution system - Send to stakeholders

## Advanced Integrations

### 5. Cross-Platform Content Distribution
**Trigger**: New content creation
**Modules**:
1. Content analysis - Extract key information
2. Platform optimization - Adapt for each channel
3. Scheduling logic - Optimal posting times
4. Cross-posting - Multiple social platforms
5. Performance tracking - Monitor engagement
6. Feedback collection - Gather responses
7. Analytics compilation - Comprehensive reporting

### 6. Dynamic Pricing Engine
**Trigger**: Market data update
**Modules**:
1. Market research APIs - Collect competitor data
2. Demand analysis - Assess booking patterns
3. Seasonal adjustments - Factor in calendar events
4. Pricing algorithm - Calculate optimal rates
5. Platform updates - Push new pricing
6. Notification system - Alert stakeholders
7. Performance monitoring - Track revenue impact
EOF

    # Create Make setup guide
    cat > ~/.bill-sloth/automation/make/setup_guide.sh << 'EOF'
#!/bin/bash
echo "🎯 MAKE (INTEGROMAT) SETUP GUIDE"
echo "================================"
echo ""
echo "Setting up advanced automation scenarios..."
echo ""

echo "📋 ACCOUNT SETUP:"
echo "□ Create Make account at make.com"
echo "□ Choose appropriate plan (Core/Pro/Teams)"
echo "□ Set up organization and teams"
echo "□ Configure billing and usage limits"
echo ""

echo "🔗 REQUIRED INTEGRATIONS:"
echo "□ Google Workspace (Gmail, Sheets, Tasks, Calendar)"
echo "□ Email services (IMAP/SMTP)"
echo "□ Webhook receivers"
echo "□ HTTP/REST API connections"
echo "□ Database connections (if needed)"
echo "□ File storage (Dropbox, OneDrive)"
echo ""

echo "🧠 ADVANCED FEATURES:"
echo "□ Data transformation modules"
echo "□ Mathematical operations"
echo "□ Text processing and parsing"
echo "□ Image and document processing"
echo "□ AI/ML service integrations"
echo "□ Custom API development"
echo ""

echo "🚀 SCENARIO DEVELOPMENT PROCESS:"
echo "1. Start with simple two-module scenarios"
echo "2. Add complexity gradually with testing"
echo "3. Use data stores for complex operations"
echo "4. Implement proper error handling"
echo "5. Set up monitoring and alerting"
echo "6. Optimize for cost and performance"
echo ""

echo "💡 BEST PRACTICES:"
echo "• Use folders to organize scenarios"
echo "• Document complex transformation logic"
echo "• Set up proper error handling and retries"
echo "• Monitor operations usage carefully"
echo "• Regular backup of scenario configurations"
echo "• Test with real data in controlled environment"
EOF
    chmod +x ~/.bill-sloth/automation/make/setup_guide.sh
    
    echo "✅ Make setup complete!"
    echo ""
    echo "📁 Created:"
    echo "  • Advanced scenarios: ~/.bill-sloth/automation/make/templates/"
    echo "  • Setup guide: ~/.bill-sloth/automation/make/setup_guide.sh"
    echo ""
    echo "🚀 Next Steps:"
    echo "  1. Run: ~/.bill-sloth/automation/make/setup_guide.sh"
    echo "  2. Visit: https://make.com to create account"
    echo "  3. Start with simple scenarios before complex ones"
    echo ""
}

setup_node_red() {
    print_header "🔗 NODE-RED SETUP & GUIDE"
    
    echo "Node-RED is a programming tool for wiring together hardware devices,"
    echo "APIs and online services. Perfect for IoT and custom automation."
    echo ""
    echo "🛠️ **Why Node-RED?**"
    echo "• Open source and self-hosted"
    echo "• Visual flow-based programming"
    echo "• Extensive library of nodes"
    echo "• Perfect for IoT and custom integrations"
    echo ""
    
    # Create installation and setup guide
    cat > ~/.bill-sloth/automation/node-red_setup.sh << 'EOF'
#!/bin/bash
echo "🔗 NODE-RED INSTALLATION & SETUP"
echo "================================="
echo ""
echo "Installing Node-RED for advanced automation..."
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "📦 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install Node-RED
echo "🔗 Installing Node-RED..."
sudo npm install -g --unsafe-perm node-red

# Create Node-RED directory
mkdir -p ~/.node-red

# Install useful nodes for Bill's automation
echo "🧩 Installing automation nodes..."
cd ~/.node-red
npm install node-red-contrib-google-sheets
npm install node-red-contrib-chatgpt
npm install node-red-node-email
npm install node-red-contrib-cron-plus
npm install node-red-contrib-http-request
npm install node-red-contrib-file-function

echo "✅ Node-RED installation complete!"
echo ""
echo "🚀 GETTING STARTED:"
echo "1. Start Node-RED: node-red"
echo "2. Open browser: http://localhost:1880"
echo "3. Import flows from ~/.bill-sloth/automation/node-red/"
echo "4. Configure credentials and test"
echo ""

echo "📋 BILL'S AUTOMATION FLOWS:"
echo "• VRBO booking processing"
echo "• Google Tasks integration"
echo "• Email automation"
echo "• Data CSV processing"
echo "• Custom API integrations"
EOF
    chmod +x ~/.bill-sloth/automation/node-red_setup.sh
    
    # Create Node-RED flow examples
    mkdir -p ~/.bill-sloth/automation/node-red/flows
    cat > ~/.bill-sloth/automation/node-red/flows/bill_vrbo_automation.json << 'EOF'
{
  "label": "Bill's VRBO Automation Flow",
  "info": "Processes VRBO bookings and creates tasks automatically",
  "nodes": [
    {
      "id": "email_trigger",
      "type": "e-mail in",
      "name": "VRBO Booking Email",
      "info": "Monitors for VRBO booking confirmation emails"
    },
    {
      "id": "parse_booking",
      "type": "function",
      "name": "Parse Booking Details",
      "func": "// Extract guest name, dates, property from email\nvar bookingData = {\n  guest: msg.payload.subject.match(/Guest: (.*?) /)[1],\n  checkin: msg.payload.text.match(/Check-in: (.*?)\\n/)[1],\n  checkout: msg.payload.text.match(/Check-out: (.*?)\\n/)[1],\n  property: msg.payload.text.match(/Property: (.*?)\\n/)[1]\n};\nmsg.payload = bookingData;\nreturn msg;"
    },
    {
      "id": "create_tasks",
      "type": "http request",
      "name": "Create Google Tasks",
      "method": "POST",
      "url": "https://tasks.googleapis.com/tasks/v1/lists/default/tasks"
    }
  ]
}
EOF
    
    echo "✅ Node-RED setup complete!"
    echo ""
    echo "📁 Created:"
    echo "  • Installation script: ~/.bill-sloth/automation/node-red_setup.sh"
    echo "  • Example flows: ~/.bill-sloth/automation/node-red/flows/"
    echo ""
    echo "🚀 Next Steps:"
    echo "  1. Run: ~/.bill-sloth/automation/node-red_setup.sh"
    echo "  2. Start Node-RED and access web interface"
    echo "  3. Import Bill's automation flows"
    echo ""
}

setup_home_assistant() {
    print_header "🏠 HOME ASSISTANT SETUP & GUIDE"
    
    echo "Home Assistant is the ultimate smart home automation platform."
    echo "Open source, privacy-focused, and incredibly powerful."
    echo ""
    echo "🏡 **Why Home Assistant?**"
    echo "• Complete local control"
    echo "• Privacy-focused"
    echo "• Massive device support"
    echo "• Advanced automation engine"
    echo ""
    
    # Create Home Assistant installation guide
    cat > ~/.bill-sloth/automation/home-assistant_setup.sh << 'EOF'
#!/bin/bash
echo "🏠 HOME ASSISTANT SETUP"
echo "======================"
echo ""
echo "Setting up Home Assistant for property automation..."
echo ""

echo "📋 INSTALLATION OPTIONS:"
echo "1. Home Assistant OS (Raspberry Pi recommended)"
echo "2. Home Assistant Container (Docker)"
echo "3. Home Assistant Supervised"
echo "4. Home Assistant Core (Python virtual environment)"
echo ""

echo "🎯 RECOMMENDED FOR BILL: Home Assistant Container"
echo ""

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "📦 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    sudo usermod -aG docker $USER
fi

echo "🏠 Creating Home Assistant setup..."
mkdir -p ~/.bill-sloth/automation/home-assistant/config

# Create docker-compose for Home Assistant
cat > ~/.bill-sloth/automation/home-assistant/docker-compose.yml << 'COMPOSE_EOF'
version: '3'
services:
  homeassistant:
    container_name: homeassistant
    image: "ghcr.io/home-assistant/home-assistant:stable"
    volumes:
      - ./config:/config
      - /etc/localtime:/etc/localtime:ro
    restart: unless-stopped
    privileged: true
    network_mode: host
COMPOSE_EOF

# Create basic configuration
cat > ~/.bill-sloth/automation/home-assistant/config/configuration.yaml << 'CONFIG_EOF'
# Bill's Home Assistant Configuration
default_config:

# Text to speech
tts:
  - platform: google_translate

# VRBO Property Automations
automation: !include automations.yaml
script: !include scripts.yaml
scene: !include scenes.yaml

# Google integration for Tasks and Calendar
google:
  client_id: !secret google_client_id
  client_secret: !secret google_client_secret

# Notifications
notify:
  - name: bill_mobile
    platform: group
    services:
      - service: mobile_app_bill_phone

# Sensors for property monitoring
sensor:
  - platform: template
    sensors:
      property_occupancy:
        friendly_name: "Property Occupancy"
        value_template: >
          {% if is_state('calendar.vrbo_bookings', 'on') %}
            Occupied
          {% else %}
            Vacant
          {% endif %}
CONFIG_EOF

echo "✅ Home Assistant setup files created!"
echo ""
echo "🚀 STARTUP COMMANDS:"
echo "cd ~/.bill-sloth/automation/home-assistant"
echo "docker-compose up -d"
echo "# Access at http://localhost:8123"
echo ""

echo "🔧 CONFIGURATION STEPS:"
echo "1. Complete initial setup wizard"
echo "2. Install HACS (Home Assistant Community Store)"
echo "3. Add Google Calendar integration"
echo "4. Configure mobile app for notifications"
echo "5. Set up property automation rules"
EOF
    chmod +x ~/.bill-sloth/automation/home-assistant_setup.sh
    
    echo "✅ Home Assistant setup complete!"
    echo ""
    echo "📁 Created:"
    echo "  • Installation script: ~/.bill-sloth/automation/home-assistant_setup.sh"
    echo "  • Configuration files: ~/.bill-sloth/automation/home-assistant/"
    echo ""
    echo "🚀 Next Steps:"
    echo "  1. Run: ~/.bill-sloth/automation/home-assistant_setup.sh"
    echo "  2. Start with docker-compose and complete setup"
    echo "  3. Configure VRBO property automations"
    echo ""
}

# Export functions
export -f setup_zapier setup_ifttt setup_power_automate setup_make setup_node_red setup_home_assistant