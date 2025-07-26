#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=Booking Manager, 2=Guest Communication, 3=Property Maintenance, 4=Revenue Tracking, 5=Complete Rental Suite
# CLAUDE_PROMPTS: Management tool selection, Property setup, Booking configuration
# CLAUDE_DEPENDENCIES: calendar-tools, communication-apps, maintenance-trackers, finance-tools
# VACATION RENTAL MANAGER - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

# Source required libraries
source "$SOURCE_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SOURCE_DIR/../lib/notification_system.sh" 2>/dev/null || true

# Note: vacation_rental_manager.sh functionality integrated directly in this file

vacation_rental_manager_interactive() {
    echo "🏖️ VACATION RENTAL EMPIRE - YOUR PROPERTY MANAGEMENT COMMAND CENTER"
    echo "================================================================"
    echo ""
    echo "🎯 Transform your vacation rental into a profitable, well-oiled machine"
    echo "with systems that handle everything while you focus on growing!"
    echo ""
    echo "🧠 Carl: 'I got rid of my teeth at a young age because... I'm straight.'"
    echo ""
    
    echo "🎓 WHAT IS VACATION RENTAL MANAGEMENT?"
    echo "===================================="
    echo "Vacation rental management is the art of running a successful property business."
    echo "It's more than just booking guests - it's creating systems that work:"
    echo "• Guest experience from inquiry to checkout"
    echo "• Property maintenance and cleanliness standards"
    echo "• Pricing optimization for maximum revenue"
    echo "• Communication workflows that delight guests"
    echo "• Financial tracking and tax preparation"
    echo ""
    echo "🧠 WHY SYSTEMS MATTER FOR RENTAL SUCCESS:"
    echo "• Consistent 5-star experiences increase bookings"
    echo "• Automation reduces your daily workload"
    echo "• Professional communication builds trust"
    echo "• Proper maintenance protects your investment"
    echo "• Data tracking helps optimize pricing"
    echo ""
    echo "🧠 WHY ADHD MINDS EXCEL AT RENTAL MANAGEMENT:"
    echo "• Hyperfocus creates incredibly detailed systems"
    echo "• Pattern recognition spots pricing opportunities"
    echo "• Creative problem-solving improves guest experience"
    echo "• External systems handle executive function challenges"
    echo "• Immediate feedback from guest reviews provides dopamine"
    echo ""
    echo "🍔 Meatwad: 'Well, all right! Free money! You ain't even got to leave the house.'"
    echo ""
    echo "🏆 THE COMPLETE RENTAL MANAGEMENT TOOLKIT:"
    echo "==========================================="
    echo ""
    echo "1) 🗺️ Property Management Hub - Command Central"
    echo "   💡 What it does: Complete workspace for managing your rental empire"
    echo "   ✅ Pros: Everything in one place, integrated workflows"
    echo "   🧠 ADHD-Friendly: Visual dashboard, automated reminders"
    echo "   📖 Learn: Professional property management principles"
    echo ""
    echo "2) 📋 Guest Communication System - 5-Star Service"
    echo "   💡 What it does: Templates and automation for guest interactions"
    echo "   ✅ Pros: Consistent messaging, time-saving templates"
    echo "   🧠 ADHD-Friendly: Pre-written responses, scheduled sending"
    echo "   📖 Learn: Hospitality best practices and guest psychology"
    echo ""
    echo "3) 🧼 Cleaning & Maintenance Tracker - Property Care"
    echo "   💡 What it does: Systematic cleaning and upkeep management"
    echo "   ✅ Pros: Never miss cleaning, proactive maintenance"
    echo "   🧠 ADHD-Friendly: Visual checklists, automated reminders"
    echo "   📖 Learn: Professional housekeeping and property care"
    echo ""
    echo "4) 📊 Booking & Revenue Analytics - Profit Optimization"
    echo "   💡 What it does: Track performance and optimize pricing"
    echo "   ✅ Pros: Data-driven decisions, revenue maximization"
    echo "   🧠 ADHD-Friendly: Visual charts, automated reporting"
    echo "   📖 Learn: Dynamic pricing and market analysis"
    echo ""
    echo "5) 📧 Platform Integration - Multi-Channel Management"
    echo "   💡 What it does: Manage VRBO, Airbnb, Booking.com from one place"
    echo "   ✅ Pros: Unified calendar, reduced double-bookings"
    echo "   🧠 ADHD-Friendly: Single dashboard, automated sync"
    echo "   📖 Learn: Channel management and distribution strategies"
    echo ""
    echo "6) 🚀 Complete Rental Empire Suite (All tools integrated)"
    echo "   💡 What it does: Professional vacation rental management system"
    echo "   ✅ Pros: Everything needed to scale your rental business"
    echo "   🧠 ADHD-Friendly: Comprehensive external brain for property management"
    echo "   📖 Learn: Run rentals like a hospitality professional"
    echo ""
    echo "🧠 Frylock: 'Will you hush?! You want to damage the search engine?'"
    echo "🥤 Shake: 'Damn it, they ain't movin'.'"
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " rental_choice
    
    # Ensure log directory exists
    mkdir -p ~/rental_empire
    
    case $rental_choice in
        1)
            echo "[LOG] $(date): Bill chose Full Rental Management Suite - Installing..." >> ~/VacationRental/assistant.log
            echo "\n🚀 Installing Full Rental Management Suite..."
            setup_rental_workspace
            create_vrbo_homeaway_launcher
            create_cleaning_checklists
            create_guest_communication_templates
            create_rental_dashboard
            create_google_calendar_integration
            create_guest_communication_helper
            create_cleaning_reminder_system
            create_emergency_contacts
            echo "\n✅ Full rental management suite installed!"
            echo "  - Run 'rental-dashboard' to access your management center"
            echo "  - Run 'rental-platforms' to open VRBO/HomeAway quickly"
            ;;
        2)
            echo "[LOG] $(date): Bill chose Basic Workspace Setup only" >> ~/VacationRental/assistant.log
            echo "\n📁 Setting up Basic Rental Workspace..."
            setup_rental_workspace
            echo "\n✅ Basic rental workspace created!"
            echo "  - Check ~/VacationRental/ for organized folders"
            echo "  - Desktop shortcut created for quick access"
            ;;
        3)
            echo "[LOG] $(date): Bill chose Cleaning & Maintenance Tools only" >> ~/VacationRental/assistant.log
            echo "\n🧹 Setting up Cleaning & Maintenance System..."
            setup_rental_workspace
            create_cleaning_checklists
            create_cleaning_reminder_system
            echo "\n✅ Cleaning and maintenance system ready!"
            echo "  - Check ~/VacationRental/Checklists/ for cleaning guides"
            echo "  - Run 'cleaning-reminder' to set cleaning alerts"
            ;;
        4)
            echo "[LOG] $(date): Bill chose Guest Communication Tools only" >> ~/VacationRental/assistant.log
            echo "\n💬 Setting up Guest Communication System..."
            setup_rental_workspace
            create_guest_communication_templates
            create_guest_communication_helper
            echo "\n✅ Guest communication system ready!"
            echo "  - Check ~/VacationRental/Templates/ for message templates"
            echo "  - Run 'guest-communication' for template helper"
            ;;
        5)
            echo "[LOG] $(date): Bill chose Custom Dashboard & Scripts only" >> ~/VacationRental/assistant.log
            echo "\n🛠️ Creating Custom Rental Management Scripts..."
            setup_rental_workspace
            create_rental_dashboard
            create_vrbo_homeaway_launcher
            create_google_calendar_integration
            echo "\n✅ Custom rental management scripts created!"
            echo "  - Run 'rental-dashboard' for management center"
            echo "  - Run 'rental-platforms' to open booking sites"
            echo "  - Run 'rental-calendar' for calendar management"
            ;;
        other|Other|OTHER)
            echo "[LOG] $(date): Bill requested more options from Claude Code" >> ~/VacationRental/assistant.log
            echo "\n🤔 Prompting Claude Code for more alternatives..."
            echo "Consider these additional rental management options:"
            echo "- Hostfully for property management software"
            echo "- OwnerRez for vacation rental management"
            echo "- Lodgify for booking website creation"
            echo "- PriceLabs for dynamic pricing optimization"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/VacationRental/assistant.log"
    echo "🔄 You can always re-run this assistant to try different options!"
}

# If run directly, launch the assistant
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    vacation_rental_manager_interactive
fi 