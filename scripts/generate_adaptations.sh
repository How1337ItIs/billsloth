#!/bin/bash
# Generate Adaptations Script - Create overlays for all modified modules
# Part of the overlay system architecture

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Source overlay system
source "$PROJECT_ROOT/lib/overlay_system.sh"

echo "🎯 GENERATING ADAPTATIONS FOR MODIFIED MODULES"
echo "=============================================="
echo ""

# Initialize overlay system if not done
init_overlay_system

echo "🔍 Scanning for modified modules..."
echo ""

# Track statistics
local created=0
local skipped=0
local errors=0

# Scan all modules for changes
find "$PROJECT_ROOT/modules" -name "*.sh" -type f | while read -r module; do
    local module_name=$(basename "$module")
    local pristine_path="$PROJECT_ROOT/modules/.pristine/$module_name"
    
    # Skip if no pristine version
    if [ ! -f "$pristine_path" ]; then
        echo "⚠️  No pristine version: $module_name (creating backup)"
        cp "$module" "$pristine_path"
        continue
    fi
    
    # Check if module has been modified
    if ! cmp -s "$pristine_path" "$module"; then
        echo "📝 Modified: $module_name"
        
        # Create overlay if doesn't exist
        if [ ! -d "$PROJECT_ROOT/overlays/$module_name" ]; then
            echo "   🆕 Creating overlay..."
            if create_overlay "$module_name" "Auto-generated from modifications" "system"; then
                created=$((created + 1))
                echo "   ✅ Overlay created"
            else
                errors=$((errors + 1))
                echo "   ❌ Failed to create overlay"
            fi
        else
            echo "   🔄 Updating existing overlay..."
            # Update existing overlay
            cp "$module" "$PROJECT_ROOT/overlays/$module_name/adapted.sh"
            update_adaptations_manifest "$module_name" "update" "Auto-updated from modifications"
            skipped=$((skipped + 1))
            echo "   ✅ Overlay updated"
        fi
    else
        echo "✅ Pristine: $module_name"
    fi
done

echo ""
echo "📊 ADAPTATION GENERATION SUMMARY"
echo "================================"
echo "Created: $created overlays"
echo "Updated: $skipped overlays"
echo "Errors: $errors overlays"
echo ""

if [ $errors -eq 0 ]; then
    echo "🎉 Adaptation generation completed successfully!"
else
    echo "⚠️  Completed with $errors errors"
fi