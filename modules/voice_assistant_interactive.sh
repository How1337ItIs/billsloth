#!/bin/bash
# LLM_CAPABILITY: auto
# Bill Sloth Voice Assistant Module
# Complete voice control setup and management

# Source libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/interactive.sh" 2>/dev/null || {
    echo "🎤 VOICE ASSISTANT"
    echo "=================="
}

source "$SCRIPT_DIR/../lib/voice_control.sh" 2>/dev/null || {
    echo "❌ ERROR: Voice control library not available"
    exit 1
}

# Show voice assistant banner
show_banner "VOICE ASSISTANT" "Transform Bill Sloth into Jarvis" "ACCESSIBILITY"

echo "🎤 Welcome to Bill Sloth Voice Control!"
echo "Transform your Linux system into a voice-controlled assistant like Jarvis."
echo ""
echo "🧠 Perfect for ADHD users who benefit from hands-free operation and"
echo "anyone who wants to feel like Tony Stark controlling their computer!"
echo ""

# Main voice assistant menu
voice_assistant_menu() {
    while true; do
        print_separator "=" 60
        echo "🎤 VOICE ASSISTANT MENU"
        print_separator "=" 60
        echo ""
        
        echo "🔧 SETUP & CONFIGURATION:"
        echo "  1) Quick Voice Setup           - First-time voice control setup"
        echo "  2) Voice Control Status        - Check voice system status"
        echo "  3) Install Voice Dependencies  - Install speech engines"
        echo "  4) Test Voice Output           - Test text-to-speech"
        echo "  5) Configure Voice Commands    - Customize voice commands"
        echo ""
        
        echo "🎯 VOICE CONTROL:"
        echo "  6) Start Voice Control         - Begin voice command mode"
        echo "  7) Voice Command Reference     - List all voice commands"
        echo "  8) Voice Training Mode         - Practice voice commands"
        echo ""
        
        echo "🛠️ ADVANCED OPTIONS:"
        echo "  9) Voice Engine Selection      - Choose TTS/STT engines"
        echo " 10) Custom Command Builder     - Create custom voice commands"
        echo " 11) Voice Shortcuts Manager    - Manage voice shortcuts"
        echo " 12) Accessibility Settings     - Voice accessibility options"
        echo ""
        
        echo "📚 HELP & LEARNING:"
        echo " 13) Voice Control Tutorial     - Learn voice control basics"
        echo " 14) Troubleshooting Guide      - Fix voice control issues"
        echo " 15) Integration Examples       - Voice + other modules"
        echo ""
        
        echo " 0) Exit Voice Assistant"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select an option (0-15)" 30 "0")
        
        case "$choice" in
            1) voice_quick_setup ;;
            2) show_voice_status_detailed ;;
            3) install_voice_dependencies ;;
            4) test_voice_output ;;
            5) configure_voice_commands ;;
            6) start_voice_control_mode ;;
            7) show_voice_help ;;
            8) voice_training_mode ;;
            9) voice_engine_selection ;;
            10) custom_command_builder ;;
            11) voice_shortcuts_manager ;;
            12) accessibility_settings ;;
            13) voice_control_tutorial ;;
            14) troubleshooting_guide ;;
            15) integration_examples ;;
            0) 
                log_info "Exiting Voice Assistant"
                break
                ;;
            *)
                log_warning "Invalid option: $choice"
                echo "Please select a number between 0 and 15."
                sleep 2
                ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to return to menu..."
            echo ""
        fi
    done
}

# Detailed voice status
show_voice_status_detailed() {
    print_header "🎤 DETAILED VOICE CONTROL STATUS"
    
    # Initialize voice control to check status
    init_voice_control
    
    echo "**System Information:**"
    echo "• OS: $(uname -o 2>/dev/null || echo 'Unknown')"
    echo "• Architecture: $(uname -m)"
    echo "• User: $USER"
    echo ""
    
    # Check configuration
    echo "**Configuration Status:**"
    if [ -f "$VOICE_COMMANDS_FILE" ]; then
        local cmd_count=$(jq '.commands | length' "$VOICE_COMMANDS_FILE" 2>/dev/null || echo "unknown")
        echo "✅ Voice commands configured ($cmd_count command groups)"
        echo "   File: $VOICE_COMMANDS_FILE"
    else
        echo "❌ Voice commands not configured"
    fi
    
    if [ -d "$VOICE_CONFIG_DIR" ]; then
        echo "✅ Voice config directory exists"
        echo "   Location: $VOICE_CONFIG_DIR"
    else
        echo "❌ Voice config directory missing"
    fi
    
    echo ""
    
    # Audio system status
    echo "**Audio System:**"
    if command -v pulseaudio &>/dev/null; then
        echo "✅ PulseAudio available"
    elif command -v alsa &>/dev/null; then
        echo "✅ ALSA available" 
    else
        echo "⚠️  Audio system status unknown"
    fi
    
    # Check audio devices
    if command -v aplay &>/dev/null; then
        local audio_devices=$(aplay -l 2>/dev/null | grep -c "card")
        echo "🔊 Audio output devices: $audio_devices"
    fi
    
    if command -v arecord &>/dev/null; then
        local input_devices=$(arecord -l 2>/dev/null | grep -c "card")
        echo "🎙️ Audio input devices: $input_devices"
    fi
    
    echo ""
    
    # Voice engine capabilities
    detect_voice_capabilities
    
    echo ""
    echo "**Next Steps:**"
    if [ ! -f "$VOICE_COMMANDS_FILE" ]; then
        echo "• Run option 1 (Quick Voice Setup) to get started"
    else
        echo "• Use option 6 (Start Voice Control) to begin"
        echo "• Try option 4 (Test Voice Output) to verify audio"
    fi
}

# Test voice output with different engines
test_voice_output() {
    print_header "🔊 VOICE OUTPUT TEST"
    
    echo "Testing all available text-to-speech engines..."
    echo ""
    
    local test_message="Hello! This is Bill Sloth voice control test."
    local engines_tested=0
    
    # Test each available engine
    for engine in espeak festival say pico2wave; do
        if command -v "$engine" &>/dev/null; then
            echo "🔊 Testing $engine..."
            speak "$test_message" "$engine"
            engines_tested=$((engines_tested + 1))
            
            echo "Did you hear the voice output clearly?"
            if confirm "Was the $engine test successful?"; then
                log_success "$engine test passed"
            else
                log_warning "$engine test failed or unclear"
            fi
            echo ""
        fi
    done
    
    if [ $engines_tested -eq 0 ]; then
        log_warning "No text-to-speech engines found"
        echo ""
        echo "To install TTS engines:"
        echo "• Ubuntu/Debian: sudo apt install espeak festival"
        echo "• macOS: Built-in 'say' command should be available"
        echo "• Other systems: Check your package manager"
        echo ""
        
        if confirm "Install TTS engines now?"; then
            install_voice_dependencies
        fi
    else
        log_success "Voice output test complete ($engines_tested engines tested)"
    fi
}

# Start voice control mode
start_voice_control_mode() {
    print_header "🎤 STARTING VOICE CONTROL MODE"
    
    echo "🚀 **Voice Control Tips:**"
    echo "• Speak clearly and naturally"
    echo "• Wait for the listening prompt"
    echo "• Say 'help' to hear available commands"
    echo "• Say 'exit' to stop voice control"
    echo "• Use Ctrl+C to force quit"
    echo ""
    
    if ! confirm "Ready to start voice control?"; then
        return 0
    fi
    
    echo ""
    log_info "Starting voice control loop..."
    voice_control_loop
}

# Voice training mode
voice_training_mode() {
    print_header "🎓 VOICE TRAINING MODE"
    
    echo "Practice voice commands in a safe training environment."
    echo "This mode will recognize commands but won't execute them."
    echo ""
    
    local training_commands=(
        "hey bill"
        "automation"
        "clipboard"
        "files"
        "windows"
        "system health"
        "security"
        "help"
        "exit"
    )
    
    echo "📚 **Training Commands to Practice:**"
    for i in "${!training_commands[@]}"; do
        echo "$((i+1)). '${training_commands[i]}'"
    done
    echo ""
    
    if confirm "Start voice training?"; then
        echo ""
        echo "🎤 **Training Mode Active** - Commands recognized but not executed"
        echo "Say any command to practice (or 'quit' to exit training):"
        echo ""
        
        while true; do
            echo "🎤 Training - say a command:"
            local input
            input=$(listen 15)
            
            if [ -n "$input" ]; then
                local input_lower=$(echo "$input" | tr '[:upper:]' '[:lower:]')
                
                if echo "$input_lower" | grep -E "(quit|exit|stop)" >/dev/null; then
                    speak "Training complete. Good job!"
                    break
                fi
                
                # Check if command would be recognized
                local recognized=false
                for cmd in "${training_commands[@]}"; do
                    if echo "$input_lower" | grep -E "$(echo "$cmd" | sed 's/ /.*/g')" >/dev/null; then
                        speak "Good! I recognized: $cmd"
                        echo "✅ Recognized: '$cmd'"
                        recognized=true
                        break
                    fi
                done
                
                if [ "$recognized" = false ]; then
                    speak "I didn't recognize that command. Try again."
                    echo "❌ Not recognized: '$input'"
                    echo "   Try one of the training commands listed above."
                fi
            else
                echo "🔇 No input detected. Try speaking more clearly."
            fi
            
            echo ""
        done
        
        log_success "Voice training session completed!"
    fi
}

# Configure voice commands
configure_voice_commands() {
    print_header "⚙️ VOICE COMMANDS CONFIGURATION"
    
    echo "Customize your voice commands and responses."
    echo ""
    
    if [ -f "$VOICE_COMMANDS_FILE" ]; then
        echo "📁 Current commands file: $VOICE_COMMANDS_FILE"
        
        if command -v jq &>/dev/null; then
            echo ""
            echo "📋 **Current Command Categories:**"
            jq -r '.commands | keys[]' "$VOICE_COMMANDS_FILE" 2>/dev/null | while read -r category; do
                echo "• $category"
            done
        else
            echo "⚠️  Install 'jq' to view current configuration"
        fi
        
        echo ""
        echo "🔧 **Configuration Options:**"
        echo "1. Reset to default commands"
        echo "2. Backup current commands" 
        echo "3. Edit commands file manually"
        echo "4. View raw configuration"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select option (1-4)" 30 "4")
        
        case "$choice" in
            1)
                if confirm "Reset to default commands? This will overwrite your current settings."; then
                    backup_file "$VOICE_COMMANDS_FILE"
                    create_default_commands
                    log_success "Commands reset to defaults"
                fi
                ;;
            2)
                backup_file "$VOICE_COMMANDS_FILE"
                log_success "Commands backed up"
                ;;
            3)
                if command -v nano &>/dev/null; then
                    nano "$VOICE_COMMANDS_FILE"
                elif command -v vim &>/dev/null; then
                    vim "$VOICE_COMMANDS_FILE"
                else
                    echo "Edit manually: $VOICE_COMMANDS_FILE"
                fi
                ;;
            4)
                echo ""
                echo "📄 **Current Configuration:**"
                cat "$VOICE_COMMANDS_FILE"
                ;;
        esac
    else
        log_warning "No voice commands file found"
        if confirm "Create default commands configuration?"; then
            init_voice_control
            log_success "Default commands created"
        fi
    fi
}

# Placeholder functions for advanced features
voice_engine_selection() {
    log_info "Voice engine selection coming in next update"
    echo "This will allow you to choose between different TTS and STT engines."
}

custom_command_builder() {
    log_info "Custom command builder coming in next update"
    echo "This will provide a GUI for creating custom voice commands."
}

voice_shortcuts_manager() {
    log_info "Voice shortcuts manager coming in next update"
    echo "This will help you create shortcuts for complex command sequences."
}

accessibility_settings() {
    log_info "Accessibility settings coming in next update"
    echo "This will provide options for different accessibility needs."
}

voice_control_tutorial() {
    print_header "📚 VOICE CONTROL TUTORIAL"
    
    echo "🎓 **Learn Bill Sloth Voice Control**"
    echo ""
    echo "**Step 1: Activation**"
    echo "Say 'Hey Bill' or 'Bill Sloth' to activate listening mode."
    echo "You'll hear a response and see a listening prompt."
    echo ""
    
    echo "**Step 2: Commands**"
    echo "Speak your command clearly. Examples:"
    echo "• 'Automation' - Opens automation mastery module"
    echo "• 'System health' - Runs health diagnostics"
    echo "• 'Help' - Shows available commands"
    echo ""
    
    echo "**Step 3: Feedback**"
    echo "Bill Sloth will confirm what it understood and execute the action."
    echo "If it doesn't understand, it will ask you to try again."
    echo ""
    
    echo "**Pro Tips:**"
    echo "• Speak naturally - no need to robot-talk"
    echo "• Wait for the listening prompt before speaking"
    echo "• Use the training mode to practice"
    echo "• Say 'exit' to stop voice control anytime"
    echo ""
    
    if confirm "Try the voice training mode now?"; then
        voice_training_mode
    fi
}

troubleshooting_guide() {
    print_header "🔧 VOICE CONTROL TROUBLESHOOTING"
    
    echo "**Common Issues and Solutions:**"
    echo ""
    
    echo "❌ **No voice output (can't hear Bill Sloth)**"
    echo "• Check audio volume and speakers/headphones"
    echo "• Test with: bill-voice test"
    echo "• Install TTS engines: sudo apt install espeak"
    echo "• Check audio system: pulseaudio or alsa"
    echo ""
    
    echo "❌ **Voice commands not recognized**"
    echo "• Speak more clearly and slowly"
    echo "• Check microphone is working"
    echo "• Use keyboard input mode as fallback"
    echo "• Try the training mode to practice"
    echo ""
    
    echo "❌ **Commands recognized but modules don't start**"
    echo "• Check module file permissions (chmod +x)"
    echo "• Ensure modules directory is accessible"
    echo "• Run health check to verify system status"
    echo ""
    
    echo "❌ **Voice control freezes or hangs**"
    echo "• Use Ctrl+C to force quit"
    echo "• Check system resources (memory, CPU)"
    echo "• Restart voice control: bill-voice start"
    echo ""
    
    echo "💡 **Getting Help:**"
    echo "• Use 'bill-voice status' to check system"
    echo "• Check logs in ~/.bill-sloth/voice/"
    echo "• Run system health check for overall status"
}

integration_examples() {
    log_info "Integration examples coming in next update"
    echo "This will show how to use voice control with other Bill Sloth modules."
}

# Main execution
main() {
    voice_assistant_menu
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    main "$@"
fi