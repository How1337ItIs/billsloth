#!/bin/bash
# Batch script to apply adaptive learning to all existing modules
# This will enhance all modules with feedback and usage tracking

MODULES_DIR="../modules"
ADAPTIVE_LIB="../lib/adaptive_learning.sh"

# List of modules to enhance
MODULES=(
    "kodi_setup_interactive.sh"
    "data_hoarding_interactive.sh"
    "discord_mod_toolkit_interactive.sh"
    "automation_mastery_interactive.sh"
    "ai_playground_interactive.sh"
    "creative_coding_interactive.sh"
    "gaming_boost_interactive.sh"
    "system_ops_interactive.sh"
    "productivity_suite_interactive.sh"
    "ai_setup_commands_interactive.sh"
    "privacy_tools_interactive.sh"
    "repetitive_tasks_interactive.sh"
    "streaming_setup_interactive.sh"
    "vacation_rental_manager_interactive.sh"
)

echo "🧠 BATCH APPLYING ADAPTIVE LEARNING TO ALL MODULES"
echo "================================================="
echo ""
echo "This will enhance $(echo ${#MODULES[@]}) modules with:"
echo "• Usage tracking and analytics"
echo "• Smart feedback collection"
echo "• Satisfaction monitoring"
echo "• Token-efficient AI customization"
echo ""

read -p "Continue with batch enhancement? (y/n): " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "❌ Batch enhancement cancelled."
    exit 1
fi

echo ""
echo "🚀 Starting batch enhancement..."
echo ""

for module in "${MODULES[@]}"; do
    module_path="$MODULES_DIR/$module"
    module_name=$(basename "$module" "_interactive.sh")
    
    echo "📝 Enhancing: $module_name"
    
    if [ ! -f "$module_path" ]; then
        echo "   ❌ Module not found: $module_path"
        continue
    fi
    
    # Create backup
    cp "$module_path" "$module_path.backup.$(date +%s)"
    
    # Check if already has adaptive learning
    if grep -q "adaptive_learning.sh" "$module_path"; then
        echo "   ✅ Already has adaptive learning"
        continue
    fi
    
    # Create temporary file with enhancements
    temp_file=$(mktemp)
    
    # Add adaptive learning imports after the first source command
    awk '
    /^source.*interactive\.sh/ && !added {
        print $0
        print ""
        print "source \"../lib/adaptive_learning.sh\" 2>/dev/null || {"
        print "    echo \"⚠️  Adaptive learning not available - using default content\""
        print "}"
        print ""
        print "# Initialize adaptive learning for this module"
        print "init_adaptive_learning \"'$module_name'\" \"$0\" 2>/dev/null || true"
        added = 1
        next
    }
    { print }
    ' "$module_path" > "$temp_file"
    
    # Find main menu function and add feedback collection
    awk '
    /^main_menu\(\)/ {
        in_main_menu = 1
    }
    in_main_menu && /read -p.*Choose.*option/ {
        print $0
        print ""
        print "        # Log menu access for adaptive learning"
        print "        log_usage \"'$module_name'\" \"menu_access\" 2>/dev/null || true"
        next
    }
    in_main_menu && /exit 0/ && /echo.*[Bb]ye|[Dd]one|[Cc]omplete/ {
        print $0
        print "        smart_feedback_prompt \"'$module_name'\" \"session_complete\" 2>/dev/null || true"
        next
    }
    /^}$/ && in_main_menu {
        in_main_menu = 0
    }
    { print }
    ' "$temp_file" > "$module_path"
    
    # Add feedback collection to main functions
    sed -i 's/read -p "Press Enter to continue\.\.\."/log_usage "'$module_name'" "feature_used" 2>\/dev\/null || true\n    &/' "$module_path"
    
    rm "$temp_file"
    
    echo "   ✅ Enhanced with adaptive learning"
done

echo ""
echo "🎉 BATCH ENHANCEMENT COMPLETE!"
echo "============================="
echo ""
echo "Enhanced modules will now:"
echo "• Track usage patterns and satisfaction"
echo "• Collect smart feedback automatically"
echo "• Learn from user preferences over time"
echo "• Adapt content based on actual usage"
echo ""
echo "🧠 Users can now run:"
echo "   bill-sloth dashboard     = View learning insights"
echo "   adapt-modules status     = Check module satisfaction"
echo "   adapt-modules customize  = Apply AI improvements"
echo ""
echo "💡 All feedback stays local and uses minimal tokens!"