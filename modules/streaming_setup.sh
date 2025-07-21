#!/bin/bash
# STREAMING SETUP - OBS, audio, scenes
# For Claude Code to execute with intelligence

echo "STREAMING_SETUP_MODULE_LOADED"

streaming_capabilities() {
    echo "Streaming Setup Module Capabilities:"
    echo "1. Install and configure OBS Studio"
    echo "2. Audio routing setup (PulseAudio/PipeWire)"
    echo "3. Scene template creation"
    echo "4. Stream key configuration helpers"
    echo "5. Performance optimization"
    echo "6. Multi-platform streaming setup"
}

install_obs() {
    echo "[*] Installing OBS Studio and plugins..."
    sudo apt update
    sudo apt install -y obs-studio
    
    # Additional plugins
    sudo apt install -y \
        obs-plugins \
        v4l2loopback-dkms \
        v4l-utils
        
    # Install OBS websocket plugin
    mkdir -p ~/.config/obs-studio/plugins
    echo "[✓] OBS Studio installed with plugins"
}

setup_audio_routing() {
    echo "[*] Setting up audio routing..."
    
    # Install audio tools
    sudo apt install -y \
        pavucontrol \
        pulseaudio-module-jack \
        jack-tools \
        qjackctl
    
    # Create virtual audio devices
    pactl load-module module-null-sink sink_name=virtual_mic sink_properties=device.description="Virtual_Microphone"
    pactl load-module module-null-sink sink_name=desktop_audio sink_properties=device.description="Desktop_Audio"
    
    echo "[✓] Audio routing configured"
}

create_scene_templates() {
    echo "[*] Creating OBS scene templates..."
    
    # Basic scenes for streaming
    obs_config_dir="$HOME/.config/obs-studio"
    mkdir -p "$obs_config_dir/basic/scenes"
    
    cat > "$obs_config_dir/basic/scenes/gaming.json" << 'EOF'
{
    "name": "Gaming Scene",
    "sources": [
        {"name": "Game Capture", "type": "game_capture"},
        {"name": "Webcam", "type": "v4l2_capture_source"},
        {"name": "Microphone", "type": "pulse_input_capture"}
    ]
}
EOF

    cat > "$obs_config_dir/basic/scenes/chatting.json" << 'EOF'
{
    "name": "Just Chatting",
    "sources": [
        {"name": "Webcam", "type": "v4l2_capture_source"},
        {"name": "Background", "type": "image_source"},
        {"name": "Chat Overlay", "type": "browser_source"}
    ]
}
EOF

    echo "[✓] Scene templates created"
}

optimize_for_streaming() {
    echo "[*] Optimizing system for streaming..."
    
    # CPU governor for performance
    echo 'performance' | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
    
    # Increase file descriptor limits
    echo "* soft nofile 65536" | sudo tee -a /etc/security/limits.conf
    echo "* hard nofile 65536" | sudo tee -a /etc/security/limits.conf
    
    # Disable composition for better performance
    export KWIN_TRIPLE_BUFFER=1
    
    echo "[✓] System optimized for streaming"
}

quick_stream_check() {
    echo "[*] Streaming system check:"
    
    # Check if OBS is installed
    if command -v obs &> /dev/null; then
        echo "✓ OBS Studio: Installed"
    else
        echo "✗ OBS Studio: Not installed"
    fi
    
    # Check audio devices
    echo "Audio devices:"
    pactl list short sinks | head -5
    
    # Check system resources
    echo "CPU cores: $(nproc)"
    echo "RAM: $(free -h | awk '/^Mem:/ {print $2}')"
    echo "GPU: $(lspci | grep -i vga | cut -d':' -f3)"
}

configure_stream_keys() {
    echo "[*] Stream key configuration helper"
    echo "Popular platforms:"
    echo "1. Twitch - rtmp://live.twitch.tv/live/"
    echo "2. YouTube - rtmp://a.rtmp.youtube.com/live2/"
    echo "3. Facebook - rtmps://live-api-s.facebook.com:443/rtmp/"
    echo ""
    echo "Claude Code should help Bill configure these in OBS settings"
}

# Bill's anime-themed overlay helper
create_anime_overlays() {
    echo "[*] Creating anime-themed overlays..."
    mkdir -p ~/StreamAssets/overlays
    
    # Create a simple HTML overlay template
    cat > ~/StreamAssets/overlays/chat.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <style>
        body { 
            background: transparent; 
            font-family: 'Comic Sans MS', cursive;
            color: #ff6b9d;
            text-shadow: 2px 2px 4px #000;
        }
        .chat-message {
            margin: 5px;
            padding: 10px;
            background: rgba(0,0,0,0.7);
            border-left: 3px solid #ff6b9d;
            animation: slideIn 0.5s ease-in;
        }
        @keyframes slideIn {
            from { transform: translateX(-100%); }
            to { transform: translateX(0); }
        }
    </style>
</head>
<body>
    <div id="chat-container">
        <!-- Chat messages will appear here -->
    </div>
</body>
</html>
EOF

    echo "[✓] Anime overlays created in ~/StreamAssets/overlays/"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This streaming module should be executed by Claude Code"
    echo "Available functions: install_obs, setup_audio_routing, create_scene_templates, optimize_for_streaming, quick_stream_check"
fi