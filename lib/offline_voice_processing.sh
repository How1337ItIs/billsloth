#!/bin/bash
# LLM_CAPABILITY: local_ok
# Offline Voice Processing Library
# Local Whisper integration for complete voice independence

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Source required libraries
source "$(dirname "${BASH_SOURCE[0]}")/error_handling.sh"
source "$(dirname "${BASH_SOURCE[0]}")/notification.sh"
source "$(dirname "${BASH_SOURCE[0]}")/data_persistence.sh"

# Configuration
OFFLINE_VOICE_DIR="$HOME/.local/share/bill-sloth/voice"
WHISPER_MODELS_DIR="$OFFLINE_VOICE_DIR/models"
TEMP_AUDIO_DIR="$OFFLINE_VOICE_DIR/temp"
VOICE_CACHE_DIR="$OFFLINE_VOICE_DIR/cache"
VOICE_CONFIG_FILE="$OFFLINE_VOICE_DIR/config.json"

# Whisper model options (balanced for performance vs quality)
declare -A WHISPER_MODELS=(
    ["tiny"]="39MB - Fast, basic quality"
    ["base"]="74MB - Good balance"
    ["small"]="244MB - Better quality"
    ["medium"]="769MB - High quality (recommended)"
    ["large"]="1550MB - Best quality, slower"
)

# Audio processing settings
SAMPLE_RATE=16000
AUDIO_FORMAT="wav"
CHUNK_DURATION=30  # seconds
SILENCE_THRESHOLD=0.01
MIN_AUDIO_LENGTH=1  # minimum seconds to process

create_voice_directories() {
    log_info "Creating offline voice processing directories"
    
    mkdir -p "$OFFLINE_VOICE_DIR"
    mkdir -p "$WHISPER_MODELS_DIR"
    mkdir -p "$TEMP_AUDIO_DIR"
    mkdir -p "$VOICE_CACHE_DIR"
    
    log_success "Voice directories created"
}

check_whisper_installation() {
    log_info "Checking Whisper installation"
    
    if python3 -c "import whisper" 2>/dev/null; then
        log_success "Whisper is installed"
        return 0
    else
        log_warning "Whisper not found - will install"
        return 1
    fi
}

install_whisper() {
    log_info "Installing Whisper for offline voice processing"
    
    # Install dependencies
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y python3-pip ffmpeg portaudio19-dev
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y python3-pip ffmpeg portaudio-devel
    elif command -v brew >/dev/null 2>&1; then
        brew install ffmpeg portaudio
    fi
    
    # Install Python packages
    pip3 install --user openai-whisper
    pip3 install --user pyaudio
    pip3 install --user pydub
    pip3 install --user numpy
    
    log_success "Whisper installation completed"
}

download_whisper_model() {
    local model_size="${1:-medium}"
    
    log_info "Downloading Whisper model: $model_size"
    
    if [[ ! "${WHISPER_MODELS[*]}" =~ $model_size ]]; then
        log_error "Invalid model size: $model_size"
        log_info "Available models: ${!WHISPER_MODELS[@]}"
        return 1
    fi
    
    # Download model using Python
    python3 -c "
import whisper
try:
    model = whisper.load_model('$model_size')
    print('Model $model_size downloaded successfully')
except Exception as e:
    print(f'Error downloading model: {e}')
    exit(1)
"
    
    if [ $? -eq 0 ]; then
        log_success "Whisper model '$model_size' downloaded"
        save_state "whisper_model_$model_size" "installed"
    else
        log_error "Failed to download Whisper model"
        return 1
    fi
}

create_voice_config() {
    log_info "Creating offline voice processing configuration"
    
    cat > "$VOICE_CONFIG_FILE" << 'EOF'
{
  "offline_voice": {
    "enabled": true,
    "whisper_model": "medium",
    "sample_rate": 16000,
    "audio_format": "wav",
    "chunk_duration": 30,
    "silence_threshold": 0.01,
    "min_audio_length": 1,
    "auto_transcribe": true,
    "cache_enabled": true,
    "fallback_online": false
  },
  "processing": {
    "noise_reduction": true,
    "audio_enhancement": true,
    "voice_activity_detection": true,
    "speaker_adaptation": false
  },
  "performance": {
    "gpu_acceleration": true,
    "cpu_threads": 4,
    "batch_processing": true,
    "memory_optimization": true
  },
  "privacy": {
    "local_only": true,
    "no_cloud_fallback": true,
    "encrypted_cache": true,
    "auto_cleanup": true
  }
}
EOF
    
    log_success "Voice configuration created"
}

create_audio_processor() {
    log_info "Creating audio processing script"
    
    cat > "$OFFLINE_VOICE_DIR/audio_processor.py" << 'EOF'
#!/usr/bin/env python3
"""
Offline Audio Processing for Bill Sloth Voice Control
Local Whisper-based speech recognition with privacy focus
"""

import whisper
import numpy as np
import pyaudio
import wave
import json
import os
import sys
import tempfile
import threading
import time
from datetime import datetime
from pathlib import Path

class OfflineVoiceProcessor:
    def __init__(self, config_file=None):
        """Initialize offline voice processor"""
        self.config = self.load_config(config_file)
        self.model = None
        self.audio_stream = None
        self.is_recording = False
        self.temp_dir = Path(os.path.expanduser("~/.local/share/bill-sloth/voice/temp"))
        self.cache_dir = Path(os.path.expanduser("~/.local/share/bill-sloth/voice/cache"))
        
        # Ensure directories exist
        self.temp_dir.mkdir(parents=True, exist_ok=True)
        self.cache_dir.mkdir(parents=True, exist_ok=True)
        
    def load_config(self, config_file=None):
        """Load voice processing configuration"""
        if config_file is None:
            config_file = os.path.expanduser("~/.local/share/bill-sloth/voice/config.json")
        
        try:
            with open(config_file, 'r') as f:
                return json.load(f)
        except FileNotFoundError:
            # Default configuration
            return {
                "offline_voice": {
                    "whisper_model": "medium",
                    "sample_rate": 16000,
                    "chunk_duration": 30,
                    "silence_threshold": 0.01
                }
            }
    
    def load_whisper_model(self):
        """Load Whisper model for speech recognition"""
        if self.model is None:
            model_name = self.config["offline_voice"]["whisper_model"]
            print(f"Loading Whisper model: {model_name}")
            
            try:
                self.model = whisper.load_model(model_name)
                print(f"Model {model_name} loaded successfully")
            except Exception as e:
                print(f"Error loading model: {e}")
                # Fallback to smaller model
                try:
                    self.model = whisper.load_model("base")
                    print("Fallback to base model successful")
                except Exception as e2:
                    print(f"Fallback model also failed: {e2}")
                    return False
        return True
    
    def transcribe_audio_file(self, audio_file):
        """Transcribe audio file to text"""
        if not self.load_whisper_model():
            return None
        
        try:
            # Check cache first
            cache_key = self.get_cache_key(audio_file)
            cached_result = self.get_cached_transcription(cache_key)
            if cached_result:
                return cached_result
            
            # Transcribe with Whisper
            result = self.model.transcribe(str(audio_file))
            text = result["text"].strip()
            
            # Cache result
            self.cache_transcription(cache_key, text)
            
            return text
            
        except Exception as e:
            print(f"Transcription error: {e}")
            return None
    
    def record_audio_chunk(self, duration=None):
        """Record audio chunk for specified duration"""
        if duration is None:
            duration = self.config["offline_voice"]["chunk_duration"]
        
        sample_rate = self.config["offline_voice"]["sample_rate"]
        
        # Initialize PyAudio
        audio = pyaudio.PyAudio()
        
        try:
            # Open audio stream
            stream = audio.open(
                format=pyaudio.paInt16,
                channels=1,
                rate=sample_rate,
                input=True,
                frames_per_buffer=1024
            )
            
            print(f"Recording for {duration} seconds...")
            frames = []
            
            for _ in range(0, int(sample_rate / 1024 * duration)):
                data = stream.read(1024)
                frames.append(data)
            
            stream.stop_stream()
            stream.close()
            
            # Save to temporary file
            temp_file = self.temp_dir / f"recording_{int(time.time())}.wav"
            
            with wave.open(str(temp_file), 'wb') as wf:
                wf.setnchannels(1)
                wf.setsampwidth(audio.get_sample_size(pyaudio.paInt16))
                wf.setframerate(sample_rate)
                wf.writeframes(b''.join(frames))
            
            return temp_file
            
        except Exception as e:
            print(f"Recording error: {e}")
            return None
        finally:
            audio.terminate()
    
    def detect_voice_activity(self, audio_data):
        """Simple voice activity detection"""
        # Calculate RMS (root mean square) for voice detection
        rms = np.sqrt(np.mean(audio_data**2))
        threshold = self.config["offline_voice"]["silence_threshold"]
        return rms > threshold
    
    def process_continuous_audio(self, callback=None):
        """Continuously process audio input"""
        print("Starting continuous voice processing...")
        print("Say 'stop listening' to exit")
        
        while True:
            try:
                # Record audio chunk
                audio_file = self.record_audio_chunk(3)  # 3-second chunks
                
                if audio_file and audio_file.exists():
                    # Transcribe
                    text = self.transcribe_audio_file(audio_file)
                    
                    if text and len(text.strip()) > 0:
                        print(f"Recognized: {text}")
                        
                        # Check for exit command
                        if "stop listening" in text.lower():
                            print("Stopping voice processing...")
                            break
                        
                        # Call callback if provided
                        if callback:
                            callback(text)
                    
                    # Cleanup temp file
                    audio_file.unlink()
                
            except KeyboardInterrupt:
                print("\nVoice processing interrupted")
                break
            except Exception as e:
                print(f"Processing error: {e}")
                time.sleep(1)  # Brief pause before retry
    
    def get_cache_key(self, audio_file):
        """Generate cache key for audio file"""
        import hashlib
        
        # Use file modification time and size for cache key
        stat = os.stat(audio_file)
        key_data = f"{audio_file}_{stat.st_mtime}_{stat.st_size}"
        return hashlib.md5(key_data.encode()).hexdigest()
    
    def get_cached_transcription(self, cache_key):
        """Retrieve cached transcription"""
        cache_file = self.cache_dir / f"{cache_key}.txt"
        
        if cache_file.exists():
            try:
                return cache_file.read_text().strip()
            except:
                pass
        return None
    
    def cache_transcription(self, cache_key, text):
        """Cache transcription result"""
        cache_file = self.cache_dir / f"{cache_key}.txt"
        
        try:
            cache_file.write_text(text)
        except Exception as e:
            print(f"Caching error: {e}")
    
    def cleanup_temp_files(self):
        """Clean up temporary audio files"""
        for temp_file in self.temp_dir.glob("*.wav"):
            try:
                if temp_file.stat().st_mtime < time.time() - 3600:  # 1 hour old
                    temp_file.unlink()
            except:
                pass

def main():
    """Main function for command-line usage"""
    if len(sys.argv) < 2:
        print("Usage:")
        print(f"  {sys.argv[0]} transcribe <audio_file>")
        print(f"  {sys.argv[0]} record <duration_seconds>")
        print(f"  {sys.argv[0]} listen")
        sys.exit(1)
    
    processor = OfflineVoiceProcessor()
    command = sys.argv[1]
    
    if command == "transcribe":
        if len(sys.argv) < 3:
            print("Please provide audio file path")
            sys.exit(1)
        
        audio_file = sys.argv[2]
        text = processor.transcribe_audio_file(audio_file)
        if text:
            print(text)
        else:
            print("Transcription failed")
    
    elif command == "record":
        duration = int(sys.argv[2]) if len(sys.argv) > 2 else 5
        audio_file = processor.record_audio_chunk(duration)
        if audio_file:
            print(f"Audio saved to: {audio_file}")
            
            # Auto-transcribe
            text = processor.transcribe_audio_file(audio_file)
            if text:
                print(f"Transcription: {text}")
    
    elif command == "listen":
        processor.process_continuous_audio()
    
    else:
        print(f"Unknown command: {command}")
        sys.exit(1)

if __name__ == "__main__":
    main()
EOF
    
    chmod +x "$OFFLINE_VOICE_DIR/audio_processor.py"
    log_success "Audio processor created"
}

create_voice_commands() {
    log_info "Creating voice command integration scripts"
    
    # Quick transcription script
    cat > "$OFFLINE_VOICE_DIR/transcribe" << 'EOF'
#!/bin/bash
# Quick audio transcription with local Whisper

VOICE_DIR="$HOME/.local/share/bill-sloth/voice"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <audio_file>"
    echo "       $0 record [duration]"
    exit 1
fi

if [ "$1" = "record" ]; then
    duration=${2:-5}
    echo "Recording for $duration seconds..."
    python3 "$VOICE_DIR/audio_processor.py" record "$duration"
else
    python3 "$VOICE_DIR/audio_processor.py" transcribe "$1"
fi
EOF
    
    # Voice listener script
    cat > "$OFFLINE_VOICE_DIR/voice-listen" << 'EOF'
#!/bin/bash
# Continuous voice listening with local processing

VOICE_DIR="$HOME/.local/share/bill-sloth/voice"

echo "🎤 Starting offline voice listener..."
echo "Say 'stop listening' to exit"

python3 "$VOICE_DIR/audio_processor.py" listen
EOF
    
    # Integration with Bill Sloth voice control
    cat > "$OFFLINE_VOICE_DIR/bill-voice-integration" << 'EOF'
#!/bin/bash
# Integration script for Bill Sloth voice control

VOICE_DIR="$HOME/.local/share/bill-sloth/voice"
LIB_DIR="$(dirname "$VOICE_DIR")/lib"

# Source Bill Sloth libraries
source "$LIB_DIR/local_llm_integration.sh" 2>/dev/null || true

process_voice_command() {
    local voice_text="$1"
    
    echo "🎤 Voice: $voice_text"
    
    # Process with local LLM if available
    if command -v query_local_llm >/dev/null 2>&1; then
        echo "🤖 Thinking..."
        local response=$(query_local_llm "Respond to this voice command: $voice_text")
        echo "💬 Bill: $response"
        
        # Convert response to speech if TTS available
        if command -v espeak >/dev/null 2>&1; then
            echo "$response" | espeak
        elif command -v say >/dev/null 2>&1; then
            say "$response"
        fi
    else
        echo "🔍 Processing: $voice_text"
        # Basic command processing without LLM
        case "$voice_text" in
            *"time"*|*"clock"*)
                date "+It's %I:%M %p on %A, %B %d"
                ;;
            *"weather"*)
                echo "I'd check the weather if I had internet access."
                ;;
            *"help"*)
                echo "I can process voice commands locally. Try asking about time, weather, or system status."
                ;;
            *)
                echo "I heard: $voice_text"
                ;;
        esac
    fi
}

# Continuous listening with command processing
python3 -c "
import sys
sys.path.append('$VOICE_DIR')
from audio_processor import OfflineVoiceProcessor

def handle_voice_command(text):
    import subprocess
    subprocess.run(['bash', '-c', f'source \"$0\" && process_voice_command \"{text}\"'])

processor = OfflineVoiceProcessor()
processor.process_continuous_audio(callback=handle_voice_command)
" "$0"
EOF
    
    chmod +x "$OFFLINE_VOICE_DIR"/{transcribe,voice-listen,bill-voice-integration}
    
    # Add to PATH
    echo "export PATH=\"\$PATH:$OFFLINE_VOICE_DIR\"" >> ~/.bashrc
    
    log_success "Voice command scripts created"
}

test_offline_voice() {
    log_info "Testing offline voice processing"
    
    # Test Whisper installation
    if python3 -c "import whisper; print('Whisper test: OK')" 2>/dev/null; then
        log_success "Whisper import test passed"
    else
        log_error "Whisper import test failed"
        return 1
    fi
    
    # Test model loading
    if python3 -c "import whisper; model = whisper.load_model('base'); print('Model test: OK')" 2>/dev/null; then
        log_success "Whisper model test passed"
    else
        log_error "Whisper model test failed"
        return 1
    fi
    
    # Test audio recording (short test)
    if python3 "$OFFLINE_VOICE_DIR/audio_processor.py" record 1 >/dev/null 2>&1; then
        log_success "Audio recording test passed"
    else
        log_warning "Audio recording test failed - check microphone permissions"
    fi
    
    log_success "Offline voice processing tests completed"
}

optimize_voice_performance() {
    log_info "Optimizing offline voice performance"
    
    # Create performance optimization script
    cat > "$OFFLINE_VOICE_DIR/optimize-performance" << 'EOF'
#!/bin/bash
# Voice processing performance optimization

echo "🚀 Optimizing voice processing performance..."

# GPU optimization for Whisper
if command -v nvidia-smi >/dev/null 2>&1; then
    echo "✅ NVIDIA GPU detected - enabling GPU acceleration"
    export CUDA_VISIBLE_DEVICES=0
    pip3 install --user torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
fi

# CPU optimization
echo "🧠 Optimizing CPU usage..."
export OMP_NUM_THREADS=$(nproc)
export MKL_NUM_THREADS=$(nproc)

# Memory optimization
echo "💾 Configuring memory settings..."
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf >/dev/null 2>&1

# Audio system optimization
echo "🎤 Optimizing audio system..."
if command -v pulseaudio >/dev/null 2>&1; then
    # Reduce PulseAudio latency
    echo 'default-sample-rate = 16000' | sudo tee -a /etc/pulse/daemon.conf >/dev/null 2>&1
    echo 'default-fragment-size-msec = 25' | sudo tee -a /etc/pulse/daemon.conf >/dev/null 2>&1
fi

echo "✅ Performance optimization completed"
EOF
    
    chmod +x "$OFFLINE_VOICE_DIR/optimize-performance"
    
    log_success "Voice performance optimization configured"
}

setup_offline_voice_complete() {
    log_info "Setting up complete offline voice processing for Bill Sloth"
    
    create_voice_directories
    
    if ! check_whisper_installation; then
        install_whisper
    fi
    
    # Download recommended model
    download_whisper_model "medium"
    
    create_voice_config
    create_audio_processor
    create_voice_commands
    optimize_voice_performance
    
    # Test the setup
    if test_offline_voice; then
        log_success "Offline voice processing setup completed successfully!"
        log_info "Available commands:"
        log_info "  - transcribe audio_file.wav"
        log_info "  - transcribe record 5  # Record and transcribe 5 seconds"
        log_info "  - voice-listen  # Continuous listening"
        log_info "  - bill-voice-integration  # Full Bill Sloth integration"
        
        # Save setup status
        save_state "offline_voice_enabled" "true"
        save_state "offline_voice_setup_date" "$(date)"
        
        return 0
    else
        log_error "Offline voice setup failed verification"
        return 1
    fi
}

# Integration functions
integrate_with_bill_sloth_voice() {
    log_info "Integrating offline voice with Bill Sloth voice control"
    
    # Update main voice control library
    if [ -f "$(dirname "${BASH_SOURCE[0]}")/voice_control.sh" ]; then
        cat >> "$(dirname "${BASH_SOURCE[0]}")/voice_control.sh" << 'EOF'

# Offline Voice Processing Integration
source "$(dirname "${BASH_SOURCE[0]}")/offline_voice_processing.sh"

# Override for offline processing
process_voice_offline() {
    local audio_file="$1"
    
    if [ -f "$OFFLINE_VOICE_DIR/audio_processor.py" ]; then
        python3 "$OFFLINE_VOICE_DIR/audio_processor.py" transcribe "$audio_file"
    else
        log_error "Offline voice processor not available"
        return 1
    fi
}

# Enhanced voice command with offline fallback
enhanced_voice_command() {
    local use_offline="${1:-false}"
    
    if [ "$use_offline" = "true" ] || [ "$OFFLINE_MODE" = "true" ]; then
        # Use local processing
        python3 "$OFFLINE_VOICE_DIR/bill-voice-integration"
    else
        # Use existing voice control
        start_voice_recognition
    fi
}
EOF
        
        log_success "Bill Sloth voice control integration completed"
    fi
}

# Export functions
export -f transcribe_audio_file
export -f record_audio_chunk
export -f test_offline_voice