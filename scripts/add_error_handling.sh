#!/bin/bash
# Add proper error handling to Bill Sloth scripts
# Adds 'set -euo pipefail' to scripts that don't have it

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "🔧 Adding error handling to Bill Sloth scripts..."
echo ""

# Find all bash scripts
find "$PROJECT_ROOT" -name "*.sh" -type f | while read -r script; do
    # Skip this script itself
    if [[ "$script" == *"add_error_handling.sh" ]]; then
        continue
    fi
    
    # Check if it's a bash script
    if ! head -1 "$script" | grep -q "#!/bin/bash"; then
        continue
    fi
    
    # Check if it already has error handling
    if grep -q "set -euo pipefail" "$script"; then
        echo "✅ Already has error handling: $(basename "$script")"
        continue
    fi
    
    echo "🔧 Adding error handling to: $(basename "$script")"
    
    # Create backup
    cp "$script" "$script.backup"
    
    # Add error handling after shebang and comments
    {
        # Read first line (shebang)
        head -1 "$script"
        
        # Read comments and add error handling
        tail -n +2 "$script" | while IFS= read -r line; do
            echo "$line"
            # Add error handling after last comment/empty line before actual code
            if [[ ! "$line" =~ ^#.* ]] && [[ -n "$line" ]] && ! grep -q "set -euo pipefail" "$script"; then
                echo ""
                echo "set -euo pipefail"
                break
            fi
        done
        
        # Read rest of file
        tail -n +2 "$script" | sed '1,/^[^#].*$/d'
    } > "$script.tmp"
    
    # Replace original if successful
    if [ -s "$script.tmp" ]; then
        mv "$script.tmp" "$script"
        chmod +x "$script"
        echo "✅ Updated: $(basename "$script")"
    else
        # Restore backup if failed
        mv "$script.backup" "$script"
        rm -f "$script.tmp"
        echo "❌ Failed to update: $(basename "$script")"
    fi
    
    # Remove backup if successful
    rm -f "$script.backup"
done

echo ""
echo "🎉 Error handling update complete!"
echo ""
echo "📝 What was added:"
echo "• set -euo pipefail - Exit on error, undefined variables, pipe failures"
echo "• This makes scripts more reliable and easier to debug"