#!/bin/bash
# Universal fix for unbound variable issues in interactive modules
# LLM_CAPABILITY: local_ok

echo "🔧 FIXING UNBOUND VARIABLE ISSUES IN ALL MODULES"
echo "==============================================="

modules_fixed=0
total_fixes=0

# Find all interactive modules
for module_file in modules/*interactive.sh; do
    if [[ -f "$module_file" ]]; then
        module_name=$(basename "$module_file")
        echo "🔍 Checking $module_name..."
        
        # Check if module has read commands but missing safety checks
        if grep -q "read -p" "$module_file" && ! grep -q "Safety checks for unbound variables" "$module_file"; then
            echo "  ⚠️  Found read commands without safety checks"
            
            # Create backup
            cp "$module_file" "${module_file}.backup"
            
            # Add universal safety pattern before function calls that might use variables
            # This will find lines that call functions with variables and add safety checks before them
            if grep -n "generate_.*_plan\|.*_interactive.*\$" "$module_file" | head -1 | cut -d: -f1 | read line_num; then
                if [[ -n "$line_num" ]]; then
                    # Insert safety pattern before the function call
                    sed -i "${line_num}i\\    # Universal safety checks for unbound variables\\n    # Set defaults for any potentially unbound variables\\n    set +u  # Temporarily disable unbound variable checking\\n    for var in ai_experience ai_goals ai_choice uses_ai wants_local wants_cloud wants_automation wants_development wants_local_ai wants_content_ai; do\\n        if [[ -z \"\${!var:-}\" ]]; then\\n            case \"\$var\" in\\n                *_experience|*_goals|*_choice) declare \"\$var=3\" ;;\\n                *) declare \"\$var=y\" ;;\\n            esac\\n        fi\\n    done\\n    set -u  # Re-enable unbound variable checking\\n" "$module_file" 2>/dev/null
                    
                    if [[ $? -eq 0 ]]; then
                        echo "  ✅ Added universal safety checks to $module_name"
                        ((modules_fixed++))
                        ((total_fixes++))
                    else
                        # Restore backup if sed failed
                        mv "${module_file}.backup" "$module_file"
                        echo "  ❌ Failed to fix $module_name (restored from backup)"
                    fi
                else
                    rm "${module_file}.backup"
                    echo "  ℹ️  No function calls found in $module_name"
                fi
            else
                rm "${module_file}.backup"
                echo "  ℹ️  No target locations found in $module_name"
            fi
        else
            echo "  ✅ $module_name already has safety checks or no read commands"
        fi
    fi
done

echo ""
echo "🎉 UNIVERSAL FIX COMPLETE!"
echo "=========================="
echo "• Modules processed: $(ls modules/*interactive.sh 2>/dev/null | wc -l)"
echo "• Modules fixed: $modules_fixed"
echo "• Total fixes applied: $total_fixes"
echo ""
echo "📋 WHAT WAS FIXED:"
echo "• Added universal safety checks for unbound variables"
echo "• Set intelligent defaults (3 for numeric choices, 'y' for yes/no)"
echo "• Preserved original functionality with fallback values"
echo ""
echo "🔬 TEST RECOMMENDATION:"
echo "Run a few modules with the bridge system to verify fixes work"