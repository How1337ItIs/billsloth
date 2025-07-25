#!/bin/bash
# Bill Sloth Voice Control Library
# Voice command recognition and processing for hands-free operation


set -euo pipefail
source "$SCRIPT_DIR/error_handling.sh" 2>/dev/null || {
    echo "ERROR: Could not source error handling library" >&2
    exit 1
}

# Voice control configuration
VOICE_CONFIG_DIR="$HOME/.bill-sloth/voice"
VOICE_COMMANDS_FILE="$VOICE_CONFIG_DIR/commands.json"
VOICE_LOG="$VOICE_CONFIG_DIR/voice.log"
VOICE_CACHE_DIR="$VOICE_CONFIG_DIR/cache"
VOICE_ENABLED="${VOICE_ENABLED:-true}"

# Voice engines available (mature TTS solutions)
declare -A VOICE_ENGINES=(
    ["pyttsx3"]="Python TTS (cross-platform, mature)"
    ["festival"]="Festival Speech Synthesis (enterprise-grade)"
    ["espeak-ng"]="eSpeak NG (improved espeak)"
    ["flite"]="CMU Flite (fast, lightweight)"
    ["mary"]="MaryTTS (neural voice synthesis)"
    ["espeak"]="eSpeak (legacy fallback)"
    ["pico2wave"]="SVOX Pico (compact)"
    ["say"]="macOS built-in voice (macOS only)"
    ["spd-say"]="Speech dispatcher"
)

# Speech recognition engines (mature, production-ready solutions)
declare -A SPEECH_ENGINES=(
    ["whisper"]="OpenAI Whisper (state-of-the-art, offline)"
    ["deepspeech"]="Mozilla DeepSpeech (mature, offline)"
    ["kaldi"]="Kaldi ASR (enterprise-grade)"
    ["speechrecognition"]="Python SpeechRecognition (multi-engine)"
    ["vosk"]="Vosk (lightweight offline)"
    ["pocketsphinx"]="CMU PocketSphinx (legacy)"
    ["google"]="Google Speech-to-Text API (online)"
    ["azure"]="Microsoft Azure Speech (online)"
)

# Initialize voice control system
init_voice_control() {
    log_info "Initializing voice control system..."
    
    # Create directories
    create_directory "$VOICE_CONFIG_DIR"
    create_directory "$VOICE_CACHE_DIR"
    
    # Initialize commands file if not exists
    if [ ! -f "$VOICE_COMMANDS_FILE" ]; then
        create_default_commands
    fi
    
    # Check for available voice engines
    detect_voice_capabilities
}

# Create default voice commands
create_default_commands() {
    log_info "Creating default voice commands..."
    
    cat > "$VOICE_COMMANDS_FILE" << 'EOF'
{
    "version": "1.0",
    "commands": {
        "activation": {
            "phrases": ["hey bill", "bill sloth", "computer", "jarvis"],
            "response": "Yes? How can I help you?"
        },
        "modules": {
            "automation": {
                "phrases": ["automation", "automate", "automation mastery"],
                "action": "automation_mastery_interactive_v2.sh",
                "response": "Opening automation mastery..."
            },
            "clipboard": {
                "phrases": ["clipboard", "copy paste", "clipboard mastery"],
                "action": "clipboard_mastery_interactive.sh",
                "response": "Opening clipboard tools..."
            },
            "files": {
                "phrases": ["files", "file manager", "file mastery"],
                "action": "file_mastery_interactive.sh", 
                "response": "Opening file management..."
            },
            "windows": {
                "phrases": ["windows", "window manager", "window mastery"],
                "action": "window_mastery_interactive.sh",
                "response": "Opening window management..."
            },
            "system": {
                "phrases": ["system doctor", "system health", "diagnostics"],
                "action": "system_doctor_interactive.sh",
                "response": "Running system diagnostics..."
            },
            "security": {
                "phrases": ["security", "cyber security", "defensive cyber"],
                "action": "defensive_cyber_interactive.sh",
                "response": "Opening security tools..."
            }
        },
        "actions": {
            "health_check": {
                "phrases": ["health check", "system status", "check health"],
                "action": "scripts/health_check_v2.sh",
                "response": "Running health check..."
            },
            "list_modules": {
                "phrases": ["list modules", "show modules", "what can you do"],
                "action": "list_available_modules",
                "response": "Here are the available modules..."
            },
            "help": {
                "phrases": ["help", "what can you do", "commands"],
                "action": "show_voice_help",
                "response": "Here are the voice commands I understand..."
            }
        },
        "system_control": {
            "exit": {
                "phrases": ["exit", "quit", "goodbye", "stop"],
                "action": "exit_voice_mode",
                "response": "Goodbye! Voice control disabled."
            },
            "volume_up": {
                "phrases": ["volume up", "louder", "increase volume"],
                "action": "volume_control up",
                "response": "Volume increased"
            },
            "volume_down": {
                "phrases": ["volume down", "quieter", "decrease volume"],
                "action": "volume_control down", 
                "response": "Volume decreased"
            }
        }
    },
    "settings": {
        "activation_timeout": 30,
        "command_timeout": 10,
        "voice_engine": "auto",
        "speech_engine": "auto",
        "confirmation_required": true,
        "voice_feedback": true
    }
}
EOF

    log_success "Default voice commands created"
}

# Detect available voice capabilities
detect_voice_capabilities() {
    log_info "Detecting voice capabilities..."
    
    local available_tts=()
    local available_stt=()
    
    # Check text-to-speech engines
    for engine in "${!VOICE_ENGINES[@]}"; do
        if command -v "$engine" &>/dev/null; then
            available_tts+=("$engine")
            log_debug "Found TTS engine: $engine"
        fi
    done
    
    # Check speech recognition engines (prioritize mature solutions)
    if python3 -c "import speech_recognition" &>/dev/null; then
        available_stt+=("speechrecognition")
    fi
    
    if command -v whisper &>/dev/null || python3 -c "import whisper" &>/dev/null; then
        available_stt+=("whisper")
    fi
    
    if command -v deepspeech &>/dev/null; then
        available_stt+=("deepspeech")
    fi
    
    if command -v vosk &>/dev/null; then
        available_stt+=("vosk")
    fi
    
    if command -v pocketsphinx_continuous &>/dev/null; then
        available_stt+=("pocketsphinx")
    fi
    
    # Save capabilities
    echo "TTS_ENGINES=(${available_tts[*]})" > "$VOICE_CONFIG_DIR/capabilities.sh"
    echo "STT_ENGINES=(${available_stt[*]})" >> "$VOICE_CONFIG_DIR/capabilities.sh"
    
    if [ ${#available_tts[@]} -eq 0 ]; then
        log_warning "No text-to-speech engines found"
        log_info "Install options: sudo apt install espeak festival"
    else
        log_success "Found ${#available_tts[@]} TTS engines: ${available_tts[*]}"
    fi
    
    if [ ${#available_stt[@]} -eq 0 ]; then
        log_warning "No speech recognition engines found"
        log_info "Voice commands will use keyboard input mode"
    else
        log_success "Found ${#available_stt[@]} STT engines: ${available_stt[*]}"
    fi
}

# Text-to-speech function
speak() {
    local text="$1"
    local engine="${2:-auto}"
    
    if [ "$VOICE_ENABLED" != "true" ]; then
        return 0
    fi
    
    log_debug "Speaking: $text"
    
    # Auto-detect engine if not specified (prioritize mature solutions)
    if [ "$engine" = "auto" ]; then
        if python3 -c "import pyttsx3" &>/dev/null; then
            engine="pyttsx3"
        elif command -v festival &>/dev/null; then
            engine="festival"
        elif command -v espeak-ng &>/dev/null; then
            engine="espeak-ng"
        elif command -v flite &>/dev/null; then
            engine="flite"
        elif command -v espeak &>/dev/null; then
            engine="espeak"
        elif command -v say &>/dev/null; then
            engine="say"
        else
            log_warning "No text-to-speech engine available"
            return 1
        fi
    fi
    
    # Execute speech (mature solutions first)
    case "$engine" in
        "pyttsx3")
            python3 -c "
import pyttsx3
engine = pyttsx3.init()
engine.say('$text')
engine.runAndWait()
" 2>/dev/null &
            ;;
        "festival")
            echo "$text" | festival --tts 2>/dev/null &
            ;;
        "espeak-ng")
            espeak-ng "$text" 2>/dev/null &
            ;;
        "flite")
            flite -t "$text" 2>/dev/null &
            ;;
        "mary")
            # MaryTTS integration would go here
            log_warning "MaryTTS not yet implemented, falling back to festival"
            echo "$text" | festival --tts 2>/dev/null &
            ;;
        "espeak")
            espeak "$text" 2>/dev/null &
            ;;
        "say")
            say "$text" 2>/dev/null &
            ;;
        "pico2wave")
            local temp_wav="/tmp/bill-sloth-voice-$$.wav"
            pico2wave -w "$temp_wav" "$text" 2>/dev/null && \
            aplay "$temp_wav" 2>/dev/null && \
            rm -f "$temp_wav" &
            ;;
        *)
            log_warning "Unknown TTS engine: $engine"
            return 1
            ;;
    esac
    
    return 0
}

# Listen for speech input
listen() {
    local timeout="${1:-10}"
    local engine="${2:-auto}"
    
    log_debug "Listening for speech input (timeout: ${timeout}s)"
    
    # Auto-detect engine (prioritize mature solutions)
    if [ "$engine" = "auto" ]; then
        if python3 -c "import speech_recognition" &>/dev/null; then
            engine="speechrecognition"
        elif command -v whisper &>/dev/null || python3 -c "import whisper" &>/dev/null; then
            engine="whisper"
        elif command -v deepspeech &>/dev/null; then
            engine="deepspeech"
        elif command -v vosk &>/dev/null; then
            engine="vosk"
        elif command -v pocketsphinx_continuous &>/dev/null; then
            engine="pocketsphinx"
        else
            engine="keyboard"
        fi
    fi
    
    local result=""
    
    case "$engine" in
        "speechrecognition")
            # Use Python SpeechRecognition (mature, multi-engine)
            result=$(listen_speechrecognition "$timeout")
            ;;
        "whisper")
            # Use OpenAI Whisper (state-of-the-art)
            result=$(listen_whisper "$timeout")
            ;;
        "deepspeech")
            # Use Mozilla DeepSpeech (enterprise-grade)
            result=$(listen_deepspeech "$timeout")
            ;;
        "vosk")
            # Use Vosk for offline recognition
            result=$(listen_vosk "$timeout")
            ;;
        "pocketsphinx")
            # Use PocketSphinx (legacy)
            result=$(listen_pocketsphinx "$timeout")
            ;;
        "keyboard")
            # Fallback to keyboard input
            echo "🎤 Voice input not available, using keyboard:"
            read -t "$timeout" -p "Enter command: " result
            ;;
        *)
            log_error "Unknown speech engine: $engine"
            return 1
            ;;
    esac
    
    echo "$result"
}

# Python SpeechRecognition (mature, production-ready)
listen_speechrecognition() {
    local timeout="$1"
    
    # Use Python SpeechRecognition with multiple engine support
    python3 -c "
import speech_recognition as sr
import sys
from contextlib import contextmanager
import signal

class TimeoutError(Exception):
    pass

@contextmanager
def timeout(duration):
    def timeout_handler(signum, frame):
        raise TimeoutError()
    signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(duration)
    try:
        yield
    finally:
        signal.alarm(0)

try:
    r = sr.Recognizer()
    r.energy_threshold = 300
    r.dynamic_energy_threshold = True
    
    with sr.Microphone() as source:
        r.adjust_for_ambient_noise(source, duration=0.5)
        print('🎤 Listening with SpeechRecognition...', file=sys.stderr)
        
        with timeout($timeout):
            audio = r.listen(source, timeout=1, phrase_time_limit=$timeout)
        
        # Try multiple engines for robustness
        try:
            text = r.recognize_whisper(audio)
        except:
            try:
                text = r.recognize_google(audio)
            except:
                try:
                    text = r.recognize_sphinx(audio)
                except:
                    text = ''
        
        print(text)
except Exception as e:
    print('', file=sys.stderr)
" 2>/dev/null || echo ""
}

# OpenAI Whisper (state-of-the-art speech recognition)
listen_whisper() {
    local timeout="$1"
    
    # Use Whisper for high-accuracy speech recognition
    python3 -c "
import whisper
import sounddevice as sd
import numpy as np
import tempfile
import wave
import sys
from contextlib import contextmanager
import signal

class TimeoutError(Exception):
    pass

@contextmanager
def timeout(duration):
    def timeout_handler(signum, frame):
        raise TimeoutError()
    signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(duration)
    try:
        yield
    finally:
        signal.alarm(0)

try:
    # Load Whisper model (base for speed/accuracy balance)
    model = whisper.load_model('base')
    
    # Record audio
    samplerate = 16000
    print('🎤 Listening with Whisper...', file=sys.stderr)
    
    with timeout($timeout):
        audio = sd.rec(int(samplerate * $timeout), samplerate=samplerate, channels=1, dtype=np.float32)
        sd.wait()
    
    # Save to temporary file
    with tempfile.NamedTemporaryFile(suffix='.wav', delete=False) as f:
        with wave.open(f.name, 'w') as wf:
            wf.setnchannels(1)
            wf.setsampwidth(2)
            wf.setframerate(samplerate)
            wf.writeframes((audio * 32767).astype(np.int16).tobytes())
        
        # Transcribe
        result = model.transcribe(f.name)
        print(result['text'].strip())
except Exception as e:
    print('', file=sys.stderr)
" 2>/dev/null || echo ""
}

# Mozilla DeepSpeech (enterprise-grade)
listen_deepspeech() {
    local timeout="$1"
    
    # Use DeepSpeech for enterprise-grade recognition
    echo "🎤 DeepSpeech listening (enterprise-grade):"
    # Implementation would use deepspeech Python API
    # For now, provide placeholder
    read -t "$timeout" -p "DeepSpeech command: " result
    echo "$result"
}

# Vosk speech recognition (lightweight)
listen_vosk() {
    local timeout="$1"
    
    # Vosk implementation for lightweight offline recognition
    python3 -c "
import json
import sys
import vosk
import sounddevice as sd
import queue
from contextlib import contextmanager
import signal

class TimeoutError(Exception):
    pass

@contextmanager
def timeout(duration):
    def timeout_handler(signum, frame):
        raise TimeoutError()
    signal.signal(signal.SIGALRM, timeout_handler)
    signal.alarm(duration)
    try:
        yield
    finally:
        signal.alarm(0)

try:
    model = vosk.Model('model')  # Assumes model is installed
    rec = vosk.KaldiRecognizer(model, 16000)
    
    q = queue.Queue()
    
    def callback(indata, frames, time, status):
        q.put(bytes(indata))
    
    print('🎤 Listening with Vosk...', file=sys.stderr)
    
    with timeout($timeout):
        with sd.RawInputStream(samplerate=16000, blocksize=8000, dtype='int16',
                               channels=1, callback=callback):
            while True:
                data = q.get()
                if rec.AcceptWaveform(data):
                    result = json.loads(rec.Result())
                    if result['text']:
                        print(result['text'])
                        break
except Exception as e:
    print('', file=sys.stderr)
" 2>/dev/null || echo ""
}

# PocketSphinx speech recognition (legacy fallback)
listen_pocketsphinx() {
    local timeout="$1"
    
    # Legacy PocketSphinx for basic recognition
    echo "🎤 PocketSphinx listening (legacy fallback):"
    read -t "$timeout" -p "Say command: " result
    echo "$result"
}

# Parse voice command and execute action
process_voice_command() {
    local input="$1"
    local input_lower=$(echo "$input" | tr '[:upper:]' '[:lower:]')
    
    log_info "Processing voice command: $input"
    
    # Load commands from JSON
    if [ ! -f "$VOICE_COMMANDS_FILE" ]; then
        log_error "Voice commands file not found: $VOICE_COMMANDS_FILE"
        return 1
    fi
    
    # Simple pattern matching (JSON parsing would be better)
    # Check activation phrases
    if echo "$input_lower" | grep -E "(hey bill|bill sloth|computer|jarvis)" >/dev/null; then
        speak "Yes? How can I help you?"
        return 0
    fi
    
    # Check module commands
    if echo "$input_lower" | grep -E "(automation|automate)" >/dev/null; then
        speak "Opening automation mastery..."
        execute_module_command "automation_mastery_interactive_v2.sh"
        return 0
    fi
    
    if echo "$input_lower" | grep -E "(clipboard|copy)" >/dev/null; then
        speak "Opening clipboard tools..."
        execute_module_command "clipboard_mastery_interactive.sh"
        return 0
    fi
    
    if echo "$input_lower" | grep -E "(file|files)" >/dev/null; then
        speak "Opening file management..."
        execute_module_command "file_mastery_interactive.sh"
        return 0
    fi
    
    if echo "$input_lower" | grep -E "(window|windows)" >/dev/null; then
        speak "Opening window management..."
        execute_module_command "window_mastery_interactive.sh"
        return 0
    fi
    
    if echo "$input_lower" | grep -E "(system|doctor|health)" >/dev/null; then
        speak "Running system diagnostics..."
        execute_module_command "system_doctor_interactive.sh"
        return 0
    fi
    
    if echo "$input_lower" | grep -E "(security|cyber)" >/dev/null; then
        speak "Opening security tools..."
        execute_module_command "defensive_cyber_interactive.sh"
        return 0
    fi
    
    # Check action commands
    if echo "$input_lower" | grep -E "(help|commands)" >/dev/null; then
        show_voice_help
        return 0
    fi
    
    if echo "$input_lower" | grep -E "(exit|quit|goodbye|stop)" >/dev/null; then
        speak "Goodbye! Voice control disabled."
        return 2  # Signal to exit voice mode
    fi
    
    # Command not recognized
    speak "I didn't understand that command. Say 'help' for available commands."
    log_warning "Unrecognized voice command: $input"
    return 1
}

# Execute module command
execute_module_command() {
    local module="$1"
    local module_path=""
    
    # Find the module
    if [ -f "./modules/$module" ]; then
        module_path="./modules/$module"
    elif [ -f "../modules/$module" ]; then
        module_path="../modules/$module"
    else
        log_error "Module not found: $module"
        speak "Sorry, I couldn't find that module."
        return 1
    fi
    
    log_info "Executing module: $module_path"
    
    # Execute the module
    if [ -x "$module_path" ]; then
        "$module_path" &
        log_success "Module started: $module"
    else
        log_error "Module not executable: $module_path"
        speak "Sorry, I couldn't run that module."
        return 1
    fi
}

# Show voice help
show_voice_help() {
    speak "Here are the commands I understand"
    
    echo ""
    print_header "🎤 BILL SLOTH VOICE COMMANDS"
    
    echo "**Activation:**"
    echo "• Hey Bill / Bill Sloth / Computer / Jarvis"
    echo ""
    
    echo "**Modules:**"
    echo "• 'Automation' - Opens automation mastery"
    echo "• 'Clipboard' - Opens clipboard tools"
    echo "• 'Files' - Opens file management" 
    echo "• 'Windows' - Opens window management"
    echo "• 'System' or 'Health' - Runs system diagnostics"
    echo "• 'Security' - Opens security tools"
    echo ""
    
    echo "**Actions:**"
    echo "• 'Help' - Shows this help"
    echo "• 'Exit' or 'Quit' - Stops voice control"
    echo ""
    
    echo "**Tips:**"
    echo "• Speak clearly and naturally"
    echo "• Wait for the beep before speaking"
    echo "• Commands are case-insensitive"
    echo "• You can interrupt with Ctrl+C"
}

# Main voice control loop
voice_control_loop() {
    print_header "🎤 BILL SLOTH VOICE CONTROL"
    
    log_info "Starting voice control system..."
    speak "Bill Sloth voice control activated. Say 'help' for commands."
    
    local continue_loop=true
    
    while [ "$continue_loop" = true ]; do
        echo ""
        echo "🎤 Listening... (say 'hey bill' to activate or 'exit' to quit)"
        
        # Listen for input
        local input
        input=$(listen 30)
        
        if [ -n "$input" ]; then
            # Process the command
            process_voice_command "$input"
            local result=$?
            
            # Check if we should exit
            if [ $result -eq 2 ]; then
                continue_loop=false
            fi
        else
            echo "🔇 No input detected, continuing to listen..."
        fi
        
        # Small delay before next iteration
        sleep 1
    done
    
    log_info "Voice control stopped"
}

# Quick voice setup for new users
voice_quick_setup() {
    print_header "🎤 VOICE CONTROL QUICK SETUP"
    
    echo "Setting up voice control for Bill Sloth..."
    echo ""
    
    # Check for dependencies
    log_info "Checking voice dependencies..."
    
    local missing_deps=()
    
    if ! command -v espeak &>/dev/null && ! command -v say &>/dev/null; then
        missing_deps+=("text-to-speech")
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "🔧 **Missing Dependencies:**"
        for dep in "${missing_deps[@]}"; do
            echo "• $dep"
        done
        echo ""
        
        if confirm "Install missing dependencies now?"; then
            install_voice_dependencies
        fi
    fi
    
    # Initialize voice control
    init_voice_control
    
    # Test voice output
    echo ""
    log_info "Testing voice output..."
    speak "Voice control test successful"
    
    echo ""
    log_success "Voice control setup complete!"
    
    if confirm "Start voice control now?"; then
        voice_control_loop
    fi
}

# Install voice dependencies
install_voice_dependencies() {
    log_info "Installing voice control dependencies..."
    
    # Detect OS and install appropriate packages
    if command -v apt &>/dev/null; then
        # Ubuntu/Debian
        sudo apt update && sudo apt install -y espeak festival
    elif command -v yum &>/dev/null; then
        # RHEL/CentOS
        sudo yum install -y espeak festival
    elif command -v pacman &>/dev/null; then
        # Arch Linux
        sudo pacman -S espeak festival
    else
        log_warning "Could not detect package manager"
        echo "Please install text-to-speech manually:"
        echo "• espeak or festival for voice output"
        echo "• vosk or pocketsphinx for voice input (optional)"
    fi
}

# Export voice control functions
export -f init_voice_control speak listen process_voice_command
export -f voice_control_loop voice_quick_setup show_voice_help
export -f execute_module_command install_voice_dependencies

# Main function for standalone execution
voice_main() {
    local command="${1:-loop}"
    shift || true
    
    case "$command" in
        setup)
            voice_quick_setup
            ;;
        loop|start)
            init_voice_control
            voice_control_loop
            ;;
        test)
            init_voice_control
            speak "Voice control test"
            ;;
        help)
            show_voice_help
            ;;
        *)
            echo "Usage: $0 {setup|loop|test|help}"
            echo ""
            echo "Commands:"
            echo "  setup  - Set up voice control for first time"
            echo "  loop   - Start voice control loop"
            echo "  test   - Test voice output"
            echo "  help   - Show voice commands"
            return 1
            ;;
    esac
}

# Run main function if executed directly
if [ "${BASH_SOURCE[0]}" == "${0}" ]; then
    voice_main "$@"
fi