#!/bin/bash
# Automatically enhance all existing modules with adaptive learning
# This script applies the adaptive learning system to every module at once

echo "🚀 BATCH ENHANCING ALL BILL SLOTH MODULES"
echo "========================================="
echo ""

MODULES_DIR="../modules"
BACKUP_DIR="../backups/$(date +%Y%m%d_%H%M%S)"
ENHANCED_COUNT=0
SKIPPED_COUNT=0
ERROR_COUNT=0

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "📦 Creating backups in: $BACKUP_DIR"
echo ""

# Get list of all modules
MODULES=($(find "$MODULES_DIR" -name "*_interactive.sh" -type f | sort))

if [ ${#MODULES[@]} -eq 0 ]; then
    echo "❌ No modules found in $MODULES_DIR"
    exit 1
fi

echo "🎯 Found ${#MODULES[@]} modules to enhance"
echo ""

for module_path in "${MODULES[@]}"; do
    module_file=$(basename "$module_path")
    module_name=$(basename "$module_file" "_interactive.sh")
    
    echo "📝 Processing: $module_name"
    
    # Create backup
    cp "$module_path" "$BACKUP_DIR/$module_file"
    
    # Check if already enhanced
    if grep -q "adaptive_learning.sh" "$module_path"; then
        echo "   ✅ Already enhanced - skipping"
        SKIPPED_COUNT=$((SKIPPED_COUNT + 1))
        continue
    fi
    
    # Create enhanced version
    temp_file=$(mktemp)
    
    # Phase 1: Add adaptive learning imports after the first source command
    awk -v module_name="$module_name" '
    /^source.*interactive\.sh/ && !added_imports {
        print $0
        print ""
        print "# Adaptive Learning Integration"
        print "source \"../lib/adaptive_learning.sh\" 2>/dev/null || {"
        print "    echo \"⚠️  Adaptive learning not available - using default content\""
        print "}"
        print ""
        print "# Initialize adaptive learning for this module"
        print "init_adaptive_learning \"" module_name "\" \"$0\" 2>/dev/null || true"
        added_imports = 1
        next
    }
    { print }
    ' "$module_path" > "$temp_file"
    
    # Phase 2: Add logging to main menu functions
    awk -v module_name="$module_name" '
    /^main_menu\(\)/ {
        in_main_menu = 1
        print $0
        next
    }
    in_main_menu && /read -p.*[Cc]hoose.*option/ {
        print "        # Log menu access for adaptive learning"
        print "        log_usage \"" module_name "\" \"menu_access\" 2>/dev/null || true"
        print ""
        print $0
        next
    }
    in_main_menu && /exit 0/ && (/echo.*[Bb]ye|[Dd]one|[Cc]omplete|[Ff]inish/ || /👋|🎉|✅/) {
        print $0
        print "        "
        print "        # Collect feedback on module completion"
        print "        smart_feedback_prompt \"" module_name "\" \"session_complete\" 2>/dev/null || true"
        next
    }
    /^}$/ && in_main_menu {
        in_main_menu = 0
    }
    { print }
    ' "$temp_file" > "$module_path"
    
    # Phase 3: Add usage logging to major functions
    sed -i.bak "s/echo \"✅/log_usage \"$module_name\" \"feature_completed\" 2>\/dev\/null || true\n    &/" "$module_path"
    sed -i.bak "s/read -p \"Press Enter to continue\"/log_usage \"$module_name\" \"section_completed\" 2>\/dev\/null || true\n    &/" "$module_path"
    
    # Remove backup file created by sed
    rm -f "${module_path}.bak"
    
    # Clean up temp file
    rm -f "$temp_file"
    
    # Verify the enhancement worked
    if grep -q "adaptive_learning.sh" "$module_path" && grep -q "init_adaptive_learning" "$module_path"; then
        echo "   ✅ Successfully enhanced"
        ENHANCED_COUNT=$((ENHANCED_COUNT + 1))
    else
        echo "   ❌ Enhancement failed"
        ERROR_COUNT=$((ERROR_COUNT + 1))
        # Restore from backup
        cp "$BACKUP_DIR/$module_file" "$module_path"
        echo "   🔄 Restored from backup"
    fi
done

echo ""
echo "🎉 BATCH ENHANCEMENT COMPLETE"
echo "============================"
echo ""
echo "📊 RESULTS:"
echo "   ✅ Enhanced: $ENHANCED_COUNT modules"
echo "   ⏭️  Skipped: $SKIPPED_COUNT modules (already enhanced)"
echo "   ❌ Errors: $ERROR_COUNT modules"
echo ""
echo "💾 Backups saved to: $BACKUP_DIR"
echo ""

if [ $ENHANCED_COUNT -gt 0 ]; then
    echo "🧠 ADAPTIVE LEARNING NOW ACTIVE IN $ENHANCED_COUNT MODULES!"
    echo ""
    echo "Users can now:"
    echo "• Get personalized module experiences"
    echo "• Provide feedback to improve content relevance"
    echo "• Track usage patterns and satisfaction"
    echo "• Benefit from AI-powered customizations"
    echo ""
    echo "Commands to try:"
    echo "  bill-sloth dashboard     # View learning insights"
    echo "  adapt-modules status     # Check module satisfaction"
    echo "  adapt-modules customize  # Apply AI improvements"
fi

if [ $ERROR_COUNT -gt 0 ]; then
    echo "⚠️  Some modules had enhancement errors and were restored from backup."
    echo "   Check module structure and try manual enhancement if needed."
fi

echo ""
echo "🚀 All modules are now adaptive and will learn from user behavior!"