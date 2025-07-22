#!/bin/bash
# Auto-Generated Module Documentation System
# Scans modules and creates comprehensive documentation

# Source error handling
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Configuration
MODULES_DIR="$SCRIPT_DIR/../modules"
DOCS_OUTPUT="$SCRIPT_DIR/../MODULE_INDEX.md"
TEMP_FILE="/tmp/bill-sloth-module-scan.tmp"

# Module scanning and documentation generation
main() {
    print_header "📚 BILL SLOTH MODULE DOCUMENTATION GENERATOR"
    
    log_info "Scanning modules directory: $MODULES_DIR"
    log_info "Output file: $DOCS_OUTPUT"
    
    if [ ! -d "$MODULES_DIR" ]; then
        log_error "Modules directory not found: $MODULES_DIR"
        exit 1
    fi
    
    # Generate documentation
    generate_module_index
    
    # Show summary
    show_generation_summary
}

# Generate the main module index
generate_module_index() {
    log_progress "Generating module documentation..."
    
    cat > "$DOCS_OUTPUT" << 'EOF'
# Bill Sloth Module Index

**Generated:** TIMESTAMP  
**Total Modules:** MODULE_COUNT  
**Modular Modules:** MODULAR_COUNT  

## 🚀 Module Status Overview

This document provides an auto-generated overview of all Bill Sloth modules,
their capabilities, and modular decomposition status.

EOF

    # Replace placeholders
    local timestamp=$(date -Iseconds)
    local module_count=$(find "$MODULES_DIR" -name "*_interactive.sh" -type f | wc -l)
    local modular_count=$(find "$MODULES_DIR" -name "*_v2.sh" -o -type d -name "*_mastery" | wc -l)
    
    sed -i "s/TIMESTAMP/$timestamp/g; s/MODULE_COUNT/$module_count/g; s/MODULAR_COUNT/$modular_count/g" "$DOCS_OUTPUT"
    
    # Scan and document modules
    scan_interactive_modules >> "$DOCS_OUTPUT"
    scan_modular_components >> "$DOCS_OUTPUT"
    scan_utility_scripts >> "$DOCS_OUTPUT"
    
    log_success "Module documentation generated: $DOCS_OUTPUT"
}

# Scan interactive modules
scan_interactive_modules() {
    echo ""
    echo "## 📋 Interactive Modules"
    echo ""
    echo "| Module | Lines | Status | LLM Capability | Description |"
    echo "|--------|-------|--------|---------------|-------------|"
    
    find "$MODULES_DIR" -name "*_interactive.sh" -type f | sort | while read -r module_file; do
        local module_name=$(basename "$module_file" .sh)
        local line_count=$(wc -l < "$module_file" 2>/dev/null || echo "0")
        local llm_capability=$(grep "^# LLM_CAPABILITY:" "$module_file" | head -1 | awk '{print $3}' || echo "unknown")
        local description=$(grep -E "^# .*[Gg]uide|^# .*[Mm]odule" "$module_file" | head -1 | sed 's/^# *//' || echo "No description")
        
        # Determine status
        local status="Monolithic"
        local v2_file="${module_file%%.sh}_v2.sh"
        local component_dir="${module_file%_interactive.sh}_mastery"
        
        if [ -f "$v2_file" ] || [ -d "$component_dir" ]; then
            status="Modular ✅"
        elif [ $line_count -gt 1000 ]; then
            status="Large 📏"
        elif [ $line_count -gt 500 ]; then
            status="Medium 📄"
        else
            status="Compact 📝"
        fi
        
        # Truncate description
        if [ ${#description} -gt 50 ]; then
            description="${description:0:47}..."
        fi
        
        printf "| %-30s | %5d | %-12s | %-13s | %-50s |\n" \
            "$module_name" "$line_count" "$status" "$llm_capability" "$description"
    done
}

# Scan modular components
scan_modular_components() {
    echo ""
    echo "## 🧩 Modular Components"
    echo ""
    
    local modular_dirs=$(find "$MODULES_DIR" -type d -name "*_mastery" 2>/dev/null)
    
    if [ -n "$modular_dirs" ]; then
        echo "| Component System | Files | Total Lines | Controller | Components |"
        echo "|------------------|-------|-------------|------------|------------|"
        
        echo "$modular_dirs" | while read -r component_dir; do
            local system_name=$(basename "$component_dir")
            local file_count=$(find "$component_dir" -name "*.sh" -type f | wc -l)
            local total_lines=0
            local controller_exists="❌"
            local component_list=""
            
            # Count total lines
            find "$component_dir" -name "*.sh" -type f | while read -r comp_file; do
                local lines=$(wc -l < "$comp_file" 2>/dev/null || echo "0")
                total_lines=$((total_lines + lines))
            done
            
            # Check for controller
            if [ -f "$component_dir/controller.sh" ]; then
                controller_exists="✅"
            fi
            
            # List components
            component_list=$(find "$component_dir" -name "*.sh" -type f -exec basename {} .sh \; | tr '\n' ', ' | sed 's/,$//')
            
            # Truncate component list
            if [ ${#component_list} -gt 40 ]; then
                component_list="${component_list:0:37}..."
            fi
            
            printf "| %-20s | %5d | %11d | %-10s | %-40s |\n" \
                "$system_name" "$file_count" "$total_lines" "$controller_exists" "$component_list"
        done
    else
        echo "*No modular component systems found yet.*"
    fi
}

# Scan utility scripts
scan_utility_scripts() {
    echo ""
    echo "## 🛠️ Utility Scripts & Libraries"
    echo ""
    echo "| Type | File | Lines | Purpose |"
    echo "|------|------|-------|---------|"
    
    # Scan lib directory
    if [ -d "$SCRIPT_DIR/../lib" ]; then
        find "$SCRIPT_DIR/../lib" -name "*.sh" -type f | sort | while read -r lib_file; do
            local lib_name=$(basename "$lib_file" .sh)
            local line_count=$(wc -l < "$lib_file" 2>/dev/null || echo "0")
            local purpose=$(grep -E "^# .*[Ll]ibrary|^# .*[Uu]tilities" "$lib_file" | head -1 | sed 's/^# *//' || echo "Library functions")
            
            # Truncate purpose
            if [ ${#purpose} -gt 50 ]; then
                purpose="${purpose:0:47}..."
            fi
            
            printf "| %-8s | %-20s | %5d | %-50s |\n" \
                "Library" "$lib_name" "$line_count" "$purpose"
        done
    fi
    
    # Scan scripts directory
    find "$SCRIPT_DIR" -name "*.sh" -type f | sort | while read -r script_file; do
        local script_name=$(basename "$script_file" .sh)
        local line_count=$(wc -l < "$script_file" 2>/dev/null || echo "0")
        local purpose=$(grep -E "^# .*[Ss]cript|^# .*[Tt]ool" "$script_file" | head -1 | sed 's/^# *//' || echo "Utility script")
        
        # Skip if it's the current script
        if [ "$script_file" = "${BASH_SOURCE[0]}" ]; then
            continue
        fi
        
        # Truncate purpose
        if [ ${#purpose} -gt 50 ]; then
            purpose="${purpose:0:47}..."
        fi
        
        printf "| %-8s | %-20s | %5d | %-50s |\n" \
            "Script" "$script_name" "$line_count" "$purpose"
    done
}

# Show generation summary
show_generation_summary() {
    echo ""
    print_separator
    log_success "Module documentation generation complete!"
    
    # Statistics
    local total_modules=$(find "$MODULES_DIR" -name "*_interactive.sh" -type f | wc -l)
    local large_modules=$(find "$MODULES_DIR" -name "*_interactive.sh" -type f -exec wc -l {} \; | awk '$1 > 1000 {count++} END {print count+0}')
    local modular_systems=$(find "$MODULES_DIR" -type d -name "*_mastery" | wc -l)
    local total_lib_files=$(find "$SCRIPT_DIR/../lib" -name "*.sh" -type f 2>/dev/null | wc -l)
    
    echo ""
    echo "📊 **Generation Statistics:**"
    echo "• Total interactive modules: $total_modules"
    echo "• Large modules (>1000 lines): $large_modules"
    echo "• Modular component systems: $modular_systems"
    echo "• Library files: $total_lib_files"
    echo "• Documentation file: $DOCS_OUTPUT"
    
    # Show file size
    if [ -f "$DOCS_OUTPUT" ]; then
        local doc_size=$(wc -l < "$DOCS_OUTPUT")
        echo "• Documentation lines: $doc_size"
    fi
    
    echo ""
    echo "📁 **Generated Files:**"
    echo "• Module Index: $DOCS_OUTPUT"
    
    if [ -f "$DOCS_OUTPUT" ]; then
        echo ""
        if confirm "View the generated documentation?"; then
            if command -v less &>/dev/null; then
                less "$DOCS_OUTPUT"
            elif command -v more &>/dev/null; then
                more "$DOCS_OUTPUT"
            else
                echo "Documentation saved to: $DOCS_OUTPUT"
                echo "Open with your preferred text editor to view."
            fi
        fi
    fi
}

# Export functions for external use
export -f scan_interactive_modules scan_modular_components scan_utility_scripts

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi