#!/bin/bash
# LLM_CAPABILITY: local_ok
# Overlay System for Bill Sloth - Prevents direct module modification
# Implements pristine modules + adaptation overlays architecture

set -euo pipefail

# Source dependencies
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/input_sanitization.sh" 2>/dev/null || true

# Configuration
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OVERLAYS_DIR="$PROJECT_ROOT/overlays"
ADAPTATIONS_MANIFEST="$PROJECT_ROOT/adaptations/manifest.json"
PRISTINE_MODULES_DIR="$PROJECT_ROOT/modules/.pristine"

# Initialize overlay system
init_overlay_system() {
    log_info "Initializing overlay system..."
    
    # Create overlay directories
    safe_mkdir "$OVERLAYS_DIR" 755
    safe_mkdir "$PROJECT_ROOT/adaptations" 755
    safe_mkdir "$PRISTINE_MODULES_DIR" 755
    
    # Initialize manifest if it doesn't exist
    if [ ! -f "$ADAPTATIONS_MANIFEST" ]; then
        create_adaptations_manifest
    fi
    
    # Backup existing modules as pristine if not already done
    if [ ! -f "$PRISTINE_MODULES_DIR/.initialized" ]; then
        backup_pristine_modules
    fi
    
    # Setup git protections
    setup_git_protections
    
    log_success "Overlay system initialized"
}

# Create adaptations manifest
create_adaptations_manifest() {
    log_info "Creating adaptations manifest..."
    
    cat > "$ADAPTATIONS_MANIFEST" << 'EOF'
{
  "version": "1.0",
  "description": "Bill Sloth Module Adaptations Tracking",
  "last_updated": "",
  "adaptations": {},
  "overlays": {},
  "rollback_points": []
}
EOF
    
    # Update timestamp
    local timestamp=$(date -Iseconds)
    jq --arg ts "$timestamp" '.last_updated = $ts' "$ADAPTATIONS_MANIFEST" > "$ADAPTATIONS_MANIFEST.tmp"
    mv "$ADAPTATIONS_MANIFEST.tmp" "$ADAPTATIONS_MANIFEST"
    
    log_success "Adaptations manifest created"
}

# Backup existing modules as pristine
backup_pristine_modules() {
    log_info "Backing up pristine modules..."
    
    # Copy all current modules to pristine
    find "$PROJECT_ROOT/modules" -name "*.sh" -type f | while read -r module; do
        local module_name=$(basename "$module")
        local pristine_path="$PRISTINE_MODULES_DIR/$module_name"
        
        if [ ! -f "$pristine_path" ]; then
            cp "$module" "$pristine_path"
            log_debug "Backed up pristine: $module_name"
        fi
    done
    
    # Mark as initialized
    touch "$PRISTINE_MODULES_DIR/.initialized"
    echo "$(date -Iseconds)" > "$PRISTINE_MODULES_DIR/.initialized"
    
    log_success "Pristine modules backed up"
}

# Setup git protections to prevent accidental commits of adapted modules
setup_git_protections() {
    log_info "Setting up git protections..."
    
    # Create .gitignore entries for adapted modules
    local gitignore="$PROJECT_ROOT/.gitignore"
    
    if ! grep -q "# Overlay system protections" "$gitignore" 2>/dev/null; then
        cat >> "$gitignore" << 'EOF'

# Overlay system protections
modules/*.sh.adapted
overlays/
adaptations/manifest.json
modules/.pristine/
.bill-sloth-overlay-active
EOF
        log_info "Added overlay protections to .gitignore"
    fi
    
    # Mark modules as assume-unchanged if they exist
    if [ -d "$PROJECT_ROOT/.git" ]; then
        find "$PROJECT_ROOT/modules" -name "*.sh" -type f | while read -r module; do
            local module_rel=$(realpath --relative-to="$PROJECT_ROOT" "$module")
            git update-index --assume-unchanged "$module_rel" 2>/dev/null || true
        done
        log_debug "Git assume-unchanged set for modules"
    fi
}

# Create an overlay for a module
create_overlay() {
    local module_name="$1"
    local adaptation_description="$2"
    local author="${3:-$(whoami)}"
    
    if [ -z "$module_name" ] || [ -z "$adaptation_description" ]; then
        log_error "Usage: create_overlay <module_name> <description> [author]"
        return 1
    fi
    
    # Sanitize inputs
    module_name=$(sanitize_filename "$module_name")
    adaptation_description=$(sanitize_input "$adaptation_description" true)
    author=$(sanitize_input "$author" true)
    
    local module_path="$PROJECT_ROOT/modules/$module_name"
    local pristine_path="$PRISTINE_MODULES_DIR/$module_name"
    local overlay_dir="$OVERLAYS_DIR/$module_name"
    
    # Validate module exists
    if [ ! -f "$module_path" ]; then
        log_error "Module not found: $module_name"
        return 1
    fi
    
    # Ensure pristine copy exists
    if [ ! -f "$pristine_path" ]; then
        cp "$module_path" "$pristine_path"
        log_info "Created pristine backup: $module_name"
    fi
    
    # Create overlay directory
    safe_mkdir "$overlay_dir" 755
    
    # Create diff between current and pristine
    local diff_file="$overlay_dir/changes.diff"
    if ! diff -u "$pristine_path" "$module_path" > "$diff_file" 2>/dev/null; then
        log_info "Created overlay diff for: $module_name"
    else
        echo "# No changes detected" > "$diff_file"
    fi
    
    # Create overlay metadata
    local metadata_file="$overlay_dir/metadata.json"
    cat > "$metadata_file" << EOF
{
  "module": "$module_name",
  "description": "$adaptation_description",
  "author": "$author",
  "created": "$(date -Iseconds)",
  "version": "1.0",
  "applied": true,
  "checksum_pristine": "$(sha256sum "$pristine_path" | cut -d' ' -f1)",
  "checksum_adapted": "$(sha256sum "$module_path" | cut -d' ' -f1)"
}
EOF
    
    # Update manifest
    update_adaptations_manifest "$module_name" "create" "$adaptation_description"
    
    # Copy current adapted version
    cp "$module_path" "$overlay_dir/adapted.sh"
    
    log_success "Overlay created for: $module_name"
}

# Apply an overlay to a module
apply_overlay() {
    local module_name="$1"
    
    if [ -z "$module_name" ]; then
        log_error "Usage: apply_overlay <module_name>"
        return 1
    fi
    
    module_name=$(sanitize_filename "$module_name")
    
    local module_path="$PROJECT_ROOT/modules/$module_name"
    local pristine_path="$PRISTINE_MODULES_DIR/$module_name"
    local overlay_dir="$OVERLAYS_DIR/$module_name"
    local adapted_file="$overlay_dir/adapted.sh"
    
    # Validate overlay exists
    if [ ! -d "$overlay_dir" ] || [ ! -f "$adapted_file" ]; then
        log_error "Overlay not found for: $module_name"
        return 1
    fi
    
    # Backup current if different from pristine
    if ! cmp -s "$module_path" "$pristine_path" 2>/dev/null; then
        local backup_file="$module_path.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$module_path" "$backup_file"
        log_info "Backed up current version: $(basename "$backup_file")"
    fi
    
    # Apply overlay
    cp "$adapted_file" "$module_path"
    
    # Update manifest
    update_adaptations_manifest "$module_name" "apply" "Applied overlay"
    
    log_success "Overlay applied to: $module_name"
}

# Rollback a module to pristine state
rollback_to_pristine() {
    local module_name="$1"
    
    if [ -z "$module_name" ]; then
        log_error "Usage: rollback_to_pristine <module_name>"
        return 1
    fi
    
    module_name=$(sanitize_filename "$module_name")
    
    local module_path="$PROJECT_ROOT/modules/$module_name"
    local pristine_path="$PRISTINE_MODULES_DIR/$module_name"
    
    # Validate pristine exists
    if [ ! -f "$pristine_path" ]; then
        log_error "Pristine version not found for: $module_name"
        return 1
    fi
    
    # Backup current
    local backup_file="$module_path.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$module_path" "$backup_file"
    
    # Restore pristine
    cp "$pristine_path" "$module_path"
    
    # Update manifest
    update_adaptations_manifest "$module_name" "rollback" "Rolled back to pristine"
    
    log_success "Rolled back to pristine: $module_name"
}

# Update adaptations manifest
update_adaptations_manifest() {
    local module_name="$1"
    local action="$2"
    local description="$3"
    
    local timestamp=$(date -Iseconds)
    
    # Create entry if manifest is corrupted
    if [ ! -f "$ADAPTATIONS_MANIFEST" ] || ! jq empty "$ADAPTATIONS_MANIFEST" 2>/dev/null; then
        create_adaptations_manifest
    fi
    
    # Update manifest with new action
    jq --arg module "$module_name" \
       --arg action "$action" \
       --arg desc "$description" \
       --arg ts "$timestamp" \
       '.last_updated = $ts | 
        .adaptations[$module] = {
          "last_action": $action,
          "description": $desc,
          "timestamp": $ts
        }' "$ADAPTATIONS_MANIFEST" > "$ADAPTATIONS_MANIFEST.tmp"
    
    mv "$ADAPTATIONS_MANIFEST.tmp" "$ADAPTATIONS_MANIFEST"
}

# List all overlays
list_overlays() {
    echo "📋 BILL SLOTH OVERLAY SYSTEM STATUS"
    echo "==================================="
    echo ""
    
    if [ ! -d "$OVERLAYS_DIR" ] || [ -z "$(ls -A "$OVERLAYS_DIR" 2>/dev/null)" ]; then
        echo "❌ No overlays found"
        return 0
    fi
    
    echo "🔄 Active Overlays:"
    echo ""
    
    for overlay_dir in "$OVERLAYS_DIR"/*; do
        if [ -d "$overlay_dir" ]; then
            local module_name=$(basename "$overlay_dir")
            local metadata_file="$overlay_dir/metadata.json"
            
            if [ -f "$metadata_file" ]; then
                local description=$(jq -r '.description' "$metadata_file" 2>/dev/null || echo "No description")
                local created=$(jq -r '.created' "$metadata_file" 2>/dev/null || echo "Unknown")
                local author=$(jq -r '.author' "$metadata_file" 2>/dev/null || echo "Unknown")
                
                echo "📄 $module_name"
                echo "   Description: $description"
                echo "   Created: $created"
                echo "   Author: $author"
                echo ""
            fi
        fi
    done
}

# Show overlay diff
show_overlay_diff() {
    local module_name="$1"
    
    if [ -z "$module_name" ]; then
        log_error "Usage: show_overlay_diff <module_name>"
        return 1
    fi
    
    module_name=$(sanitize_filename "$module_name")
    
    local overlay_dir="$OVERLAYS_DIR/$module_name"
    local diff_file="$overlay_dir/changes.diff"
    
    if [ ! -f "$diff_file" ]; then
        log_error "Overlay diff not found for: $module_name"
        return 1
    fi
    
    echo "📄 OVERLAY DIFF: $module_name"
    echo "=========================="
    echo ""
    cat "$diff_file"
}

# Validate overlay system integrity
validate_overlay_system() {
    log_info "Validating overlay system integrity..."
    
    local errors=0
    
    # Check manifest integrity
    if [ ! -f "$ADAPTATIONS_MANIFEST" ] || ! jq empty "$ADAPTATIONS_MANIFEST" 2>/dev/null; then
        log_error "Adaptations manifest is missing or corrupted"
        errors=$((errors + 1))
    fi
    
    # Check pristine modules
    if [ ! -d "$PRISTINE_MODULES_DIR" ]; then
        log_error "Pristine modules directory missing"
        errors=$((errors + 1))
    fi
    
    # Validate overlay directories
    if [ -d "$OVERLAYS_DIR" ]; then
        for overlay_dir in "$OVERLAYS_DIR"/*; do
            if [ -d "$overlay_dir" ]; then
                local module_name=$(basename "$overlay_dir")
                local metadata_file="$overlay_dir/metadata.json"
                local adapted_file="$overlay_dir/adapted.sh"
                
                if [ ! -f "$metadata_file" ]; then
                    log_warning "Missing metadata for overlay: $module_name"
                    errors=$((errors + 1))
                fi
                
                if [ ! -f "$adapted_file" ]; then
                    log_warning "Missing adapted file for overlay: $module_name"
                    errors=$((errors + 1))
                fi
            fi
        done
    fi
    
    if [ $errors -eq 0 ]; then
        log_success "Overlay system integrity validated"
        return 0
    else
        log_error "Found $errors integrity issues"
        return 1
    fi
}

# Sync bill-specific adaptations (bill-sync.sh equivalent)
sync_bill_adaptations() {
    log_info "Syncing Bill-specific adaptations..."
    
    # List of Bill's commonly adapted modules
    local bill_modules=(
        "automation_mastery_interactive.sh"
        "vrbo_automation_interactive.sh"
        "clipboard_mastery_interactive.sh"
        "file_mastery_interactive.sh"
    )
    
    for module in "${bill_modules[@]}"; do
        if [ -f "$PROJECT_ROOT/modules/$module" ]; then
            # Check if module has been modified
            local pristine_path="$PRISTINE_MODULES_DIR/$module"
            local current_path="$PROJECT_ROOT/modules/$module"
            
            if [ -f "$pristine_path" ] && ! cmp -s "$pristine_path" "$current_path"; then
                log_info "Detected changes in: $module"
                
                # Create overlay if doesn't exist
                if [ ! -d "$OVERLAYS_DIR/$module" ]; then
                    create_overlay "$module" "Bill's customizations - auto-detected" "bill"
                else
                    log_info "Updating existing overlay: $module"
                    # Update existing overlay
                    cp "$current_path" "$OVERLAYS_DIR/$module/adapted.sh"
                    update_adaptations_manifest "$module" "sync" "Auto-synced changes"
                fi
            fi
        fi
    done
    
    log_success "Bill adaptations sync complete"
}

# Main overlay management menu
overlay_management_menu() {
    while true; do
        clear
        echo "🔄 BILL SLOTH OVERLAY SYSTEM"
        echo "============================"
        echo ""
        echo "Pristine modules + adaptation overlays architecture"
        echo ""
        echo "1) 📋 List overlays"
        echo "2) 🆕 Create overlay"
        echo "3) ✅ Apply overlay"
        echo "4) ↩️  Rollback to pristine"
        echo "5) 🔍 Show overlay diff"
        echo "6) 🔄 Sync Bill adaptations"
        echo "7) ✅ Validate system"
        echo "8) 🚪 Exit"
        echo ""
        
        local choice
        choice=$(safe_prompt "Choose option (1-8)" "1" 1 false)
        
        case "$choice" in
            1) list_overlays ;;
            2) 
                local module
                module=$(safe_prompt "Module name (e.g., automation_mastery_interactive.sh)")
                local desc
                desc=$(safe_prompt "Adaptation description")
                create_overlay "$module" "$desc"
                ;;
            3)
                local module
                module=$(safe_prompt "Module name to apply overlay")
                apply_overlay "$module"
                ;;
            4)
                local module
                module=$(safe_prompt "Module name to rollback")
                rollback_to_pristine "$module"
                ;;
            5)
                local module
                module=$(safe_prompt "Module name to show diff")
                show_overlay_diff "$module"
                ;;
            6) sync_bill_adaptations ;;
            7) validate_overlay_system ;;
            8) echo "Overlay management terminated."; break ;;
            *) echo "Invalid choice. Please select 1-8." && sleep 2 ;;
        esac
        
        if [ "$choice" != "8" ]; then
            echo ""
            safe_prompt "Press Enter to continue..." ""
        fi
    done
}

# Export functions
export -f init_overlay_system create_overlay apply_overlay rollback_to_pristine
export -f list_overlays show_overlay_diff validate_overlay_system sync_bill_adaptations
export -f overlay_management_menu

# Initialize on first source
if [ ! -f "$PROJECT_ROOT/.bill-sloth-overlay-initialized" ]; then
    init_overlay_system
    touch "$PROJECT_ROOT/.bill-sloth-overlay-initialized"
fi

# Main function for standalone execution
main() {
    local command="${1:-menu}"
    shift || true
    
    case "$command" in
        init) init_overlay_system ;;
        create) create_overlay "$@" ;;
        apply) apply_overlay "$@" ;;
        rollback) rollback_to_pristine "$@" ;;
        list) list_overlays ;;
        diff) show_overlay_diff "$@" ;;
        sync) sync_bill_adaptations ;;
        validate) validate_overlay_system ;;
        menu) overlay_management_menu ;;
        *)
            echo "Usage: $0 {init|create|apply|rollback|list|diff|sync|validate|menu}"
            echo ""
            echo "Commands:"
            echo "  init     - Initialize overlay system"
            echo "  create   - Create overlay for module"
            echo "  apply    - Apply overlay to module"
            echo "  rollback - Rollback module to pristine"
            echo "  list     - List all overlays"
            echo "  diff     - Show overlay diff"
            echo "  sync     - Sync Bill adaptations"
            echo "  validate - Validate system integrity"
            echo "  menu     - Interactive management menu"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi