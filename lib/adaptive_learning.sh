#!/bin/bash
# Adaptive Learning System - Self-modifying modules based on user feedback
# Token-efficient personalization system


set -euo pipefail
USAGE_DIR="$HOME/.bill-sloth/usage"
ADAPTATIONS_DIR="$HOME/.bill-sloth/adaptations"

mkdir -p "$FEEDBACK_DIR" "$USAGE_DIR" "$ADAPTATIONS_DIR"

# Initialize adaptive learning
init_adaptive_learning() {
    local module_name="$1"
    local module_path="$2"
    
    # Create usage tracking for this module
    echo "0" > "$USAGE_DIR/${module_name}_count"
    echo "$(date)" > "$USAGE_DIR/${module_name}_first_run"
    echo "" > "$FEEDBACK_DIR/${module_name}_feedback.log"
    echo "" > "$ADAPTATIONS_DIR/${module_name}_customizations.sh"
}

# Log module usage
log_usage() {
    local module_name="$1"
    local feature_used="$2"
    
    # Increment usage counter
    local count_file="$USAGE_DIR/${module_name}_count"
    local current_count=$(cat "$count_file" 2>/dev/null || echo "0")
    echo $((current_count + 1)) > "$count_file"
    
    # Log specific feature usage
    echo "$(date)|$feature_used" >> "$USAGE_DIR/${module_name}_features.log"
    
    # Update last used timestamp
    echo "$(date)" > "$USAGE_DIR/${module_name}_last_used"
}

# Collect user feedback with minimal token usage
collect_feedback() {
    local module_name="$1"
    local context="$2"
    
    echo ""
    echo "🤔 Quick feedback on $module_name:"
    echo "1) 😍 Perfect - exactly what I needed"
    echo "2) 👍 Good - mostly helpful"
    echo "3) 😐 Okay - somewhat useful"
    echo "4) 👎 Meh - not quite right"
    echo "5) 😤 Wrong - this doesn't match my workflow"
    echo "6) 💬 Custom feedback (uses more tokens)"
    echo ""
    
    read -p "Rate this experience (1-6): " rating
    
    case $rating in
        1) log_feedback "$module_name" "perfect" "$context" ;;
        2) log_feedback "$module_name" "good" "$context" ;;
        3) log_feedback "$module_name" "okay" "$context" ;;
        4) log_feedback "$module_name" "meh" "$context" ;;
        5) 
            echo ""
            read -p "What should this do instead? (brief): " expectation
            log_feedback "$module_name" "wrong" "$context|Expected: $expectation"
            schedule_adaptation "$module_name" "$context" "$expectation"
            ;;
        6)
            echo ""
            read -p "Tell me more (this will use AI tokens): " custom_feedback
            log_feedback "$module_name" "custom" "$context|$custom_feedback"
            if command -v claude &> /dev/null; then
                generate_adaptation "$module_name" "$context" "$custom_feedback"
            fi
            ;;
        *)
            log_feedback "$module_name" "skipped" "$context"
            ;;
    esac
}

# Log feedback efficiently
log_feedback() {
    local module_name="$1"
    local rating="$2" 
    local context="$3"
    
    echo "$(date)|$rating|$context" >> "$FEEDBACK_DIR/${module_name}_feedback.log"
    
    # Update satisfaction score
    local score_file="$FEEDBACK_DIR/${module_name}_satisfaction"
    local current_score=$(cat "$score_file" 2>/dev/null || echo "3")
    
    case $rating in
        "perfect") new_score=5 ;;
        "good") new_score=4 ;;
        "okay") new_score=3 ;;
        "meh") new_score=2 ;;
        "wrong") new_score=1 ;;
        *) new_score=$current_score ;;
    esac
    
    # Simple weighted average (90% old, 10% new)
    local weighted_score=$(echo "scale=1; ($current_score * 0.9) + ($new_score * 0.1)" | bc 2>/dev/null || echo "$new_score")
    echo "$weighted_score" > "$score_file"
}

# Schedule adaptation for next AI session
schedule_adaptation() {
    local module_name="$1"
    local context="$2"
    local expectation="$3"
    
    cat >> "$ADAPTATIONS_DIR/pending_adaptations.log" << EOF
MODULE: $module_name
DATE: $(date)
CONTEXT: $context
EXPECTATION: $expectation
STATUS: pending
---
EOF
    
    echo "📝 Adaptation scheduled! Next time you run 'adapt-modules', I'll customize this."
}

# Generate AI-powered adaptation (token-efficient)
generate_adaptation() {
    local module_name="$1"
    local context="$2"
    local feedback="$3"
    
    echo "🤖 Generating adaptation..."
    
    # Create focused prompt to minimize token usage
    local prompt="Module '$module_name' context '$context'. User feedback: '$feedback'. Generate 1-2 shell function modifications that better match user's workflow. Be specific and concise."
    
    local adaptation=$(claude "$prompt" 2>/dev/null)
    
    if [ $? -eq 0 ] && [ -n "$adaptation" ]; then
        cat >> "$ADAPTATIONS_DIR/${module_name}_customizations.sh" << EOF
# Auto-generated adaptation - $(date)
# Context: $context
# Feedback: $feedback

$adaptation

EOF
        echo "✅ Adaptation generated and saved!"
    else
        echo "❌ AI adaptation failed - feedback logged for manual review"
        schedule_adaptation "$module_name" "$context" "$feedback"
    fi
}

# Apply accumulated adaptations efficiently
apply_adaptations() {
    local module_name="$1"
    local module_file="$2"
    
    local customizations_file="$ADAPTATIONS_DIR/${module_name}_customizations.sh"
    
    if [ -f "$customizations_file" ] && [ -s "$customizations_file" ]; then
        echo "🔧 Applying learned customizations to $module_name..."
        
        # Create backup
        cp "$module_file" "${module_file}.backup.$(date +%s)"
        
        # Append customizations to module
        cat >> "$module_file" << EOF

# === ADAPTIVE LEARNING CUSTOMIZATIONS ===
# Auto-generated based on user feedback and usage patterns
$(cat "$customizations_file")
EOF
        
        echo "✅ Customizations applied! Module now adapts to your workflow."
        
        # Archive applied customizations
        mv "$customizations_file" "${customizations_file}.applied.$(date +%s)"
    fi
}

# Get usage insights
get_usage_insights() {
    local module_name="$1"
    
    local count=$(cat "$USAGE_DIR/${module_name}_count" 2>/dev/null || echo "0")
    local satisfaction=$(cat "$FEEDBACK_DIR/${module_name}_satisfaction" 2>/dev/null || echo "3.0")
    local first_run=$(cat "$USAGE_DIR/${module_name}_first_run" 2>/dev/null || echo "Never")
    local last_used=$(cat "$USAGE_DIR/${module_name}_last_used" 2>/dev/null || echo "Never")
    
    echo "📊 Usage Insights for $module_name:"
    echo "   Times used: $count"
    echo "   Satisfaction: $satisfaction/5.0"
    echo "   First used: $first_run"
    echo "   Last used: $last_used"
    
    if [ -f "$USAGE_DIR/${module_name}_features.log" ]; then
        local popular_feature=$(cut -d'|' -f2 "$USAGE_DIR/${module_name}_features.log" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
        echo "   Most used feature: $popular_feature"
    fi
    
    # Check if adaptation is needed
    if (( $(echo "$satisfaction < 3.5" | bc -l 2>/dev/null || echo "0") )); then
        echo "   🔧 Module could benefit from customization"
        return 1
    fi
    
    return 0
}

# Smart feedback prompting (only ask when useful)
smart_feedback_prompt() {
    local module_name="$1"
    local context="$2"
    
    local count=$(cat "$USAGE_DIR/${module_name}_count" 2>/dev/null || echo "0")
    local last_feedback=$(grep -c "$(date +%Y-%m-%d)" "$FEEDBACK_DIR/${module_name}_feedback.log" 2>/dev/null || echo "0")
    
    # Only prompt for feedback on:
    # - First use
    # - Every 5th use (but not more than once per day)  
    # - After experiencing issues
    
    if [ "$count" -eq "1" ]; then
        echo "👋 First time using $module_name!"
        collect_feedback "$module_name" "$context"
    elif [ "$((count % 5))" -eq "0" ] && [ "$last_feedback" -eq "0" ]; then
        echo "📈 You've used $module_name $count times."
        collect_feedback "$module_name" "$context"
    fi
}

# Create user command for managing adaptations
create_adaptation_commands() {
    cat > ~/.local/bin/adapt-modules << 'EOF'
#!/bin/bash
# User command for managing module adaptations

source "$HOME/.bill-sloth/lib/adaptive_learning.sh" 2>/dev/null || {
    echo "❌ Adaptive learning system not found"
    exit 1
}

case "$1" in
    "status")
        echo "📊 BILL SLOTH ADAPTATION STATUS"
        echo "==============================="
        echo ""
        
        for module_dir in ~/.bill-sloth/usage/*_count; do
            if [ -f "$module_dir" ]; then
                module_name=$(basename "$module_dir" "_count")
                get_usage_insights "$module_name"
                echo ""
            fi
        done
        ;;
        
    "pending")
        echo "📋 PENDING ADAPTATIONS"
        echo "======================"
        
        if [ -f ~/.bill-sloth/adaptations/pending_adaptations.log ]; then
            cat ~/.bill-sloth/adaptations/pending_adaptations.log
        else
            echo "No pending adaptations"
        fi
        ;;
        
    "apply")
        if [ -z "$2" ]; then
            echo "Usage: adapt-modules apply <module_name>"
            exit 1
        fi
        
        module_name="$2"
        module_file="$HOME/.bill-sloth/modules/${module_name}_interactive.sh"
        
        if [ ! -f "$module_file" ]; then
            echo "❌ Module not found: $module_file"
            exit 1
        fi
        
        apply_adaptations "$module_name" "$module_file"
        ;;
        
    "customize")
        echo "🤖 AI-POWERED CUSTOMIZATION"
        echo "=========================="
        
        if ! command -v claude &> /dev/null; then
            echo "❌ Claude Code required for AI customization"
            exit 1
        fi
        
        # Process pending adaptations with AI
        if [ -f ~/.bill-sloth/adaptations/pending_adaptations.log ]; then
            echo "Processing pending adaptations..."
            
            # Read pending adaptations and generate customizations
            while IFS= read -r line; do
                if [[ $line =~ ^MODULE:\ (.+)$ ]]; then
                    current_module="${BASH_REMATCH[1]}"
                elif [[ $line =~ ^CONTEXT:\ (.+)$ ]]; then
                    current_context="${BASH_REMATCH[1]}"
                elif [[ $line =~ ^EXPECTATION:\ (.+)$ ]]; then
                    current_expectation="${BASH_REMATCH[1]}"
                elif [[ $line == "---" ]] && [ -n "$current_module" ]; then
                    echo "Customizing $current_module..."
                    generate_adaptation "$current_module" "$current_context" "$current_expectation"
                    current_module=""
                    current_context=""
                    current_expectation=""
                fi
            done < ~/.bill-sloth/adaptations/pending_adaptations.log
            
            # Clear processed adaptations
            > ~/.bill-sloth/adaptations/pending_adaptations.log
        else
            echo "No pending adaptations to process"
        fi
        ;;
        
    *)
        echo "🧠 BILL SLOTH ADAPTIVE LEARNING"
        echo "==============================="
        echo ""
        echo "Your modules learn from your feedback and adapt to your workflow!"
        echo ""
        echo "Commands:"
        echo "  adapt-modules status     = Show usage and satisfaction stats"
        echo "  adapt-modules pending    = Show scheduled adaptations"  
        echo "  adapt-modules customize  = Run AI customization (uses tokens)"
        echo "  adapt-modules apply <module> = Apply customizations to module"
        echo ""
        echo "💡 Pro tip: Modules automatically ask for feedback occasionally."
        echo "   Rate them honestly so they can improve!"
        ;;
esac
EOF
    
    chmod +x ~/.local/bin/adapt-modules
    
    # Add to PATH if needed
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    fi
}

# Initialize the adaptive learning system
initialize_adaptive_system() {
    create_adaptation_commands
    
    echo "✅ Adaptive learning system initialized!"
    echo ""
    echo "🧠 HOW IT WORKS:"
    echo "   • Modules occasionally ask for quick feedback (1-6 rating)"
    echo "   • Your usage patterns are tracked anonymously"
    echo "   • AI generates customizations based on your needs"
    echo "   • Modules adapt to match your workflow over time"
    echo ""
    echo "🎯 COMMANDS:"
    echo "   adapt-modules        = Manage your personalized adaptations"
    echo "   adapt-modules status = See how satisfied you are with each module"
    echo ""
    echo "💰 TOKEN EFFICIENCY:"
    echo "   • Quick 1-6 ratings use NO tokens"
    echo "   • Custom feedback only uses tokens when you choose option 6"
    echo "   • AI customization runs in batches to minimize usage"
    echo ""
}