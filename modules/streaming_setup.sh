#!/bin/bash
# LLM_CAPABILITY: local_ok
# Streaming setup for content creation

install_obs() {
    echo "📹 Installing OBS Studio..."
    sudo add-apt-repository ppa:obsproject/obs-studio -y
    sudo apt update
    sudo apt install obs-studio -y
    
    # Virtual camera support
    sudo apt install v4l2loopback-dkms -y
    sudo modprobe v4l2loopback
}

setup_audio_routing() {
    echo "🎤 Setting up audio routing..."
    sudo apt install pavucontrol -y
    
    # Create virtual audio devices for streaming
    pactl load-module module-null-sink sink_name=stream_audio sink_properties=device.description="Stream_Audio"
    pactl load-module module-loopback source=stream_audio.monitor
}

obs_scene_templates() {
    echo "📺 OBS Scene Ideas:"
    echo "- Gaming: Game capture + webcam overlay + chat"
    echo "- Coding: Screen share + webcam + terminal"
    echo "- Just Chatting: Webcam + background + alerts"
    echo "- Creative: Canvas capture + webcam + music viz"
}

create_stream_command() {
    cat > ~/bin/stream << 'EOF'
#!/bin/bash
echo "🎬 STREAM MODE ACTIVATED!"
echo "\"I’m on the internet. I’m downloading the internet as we speak. I’m going to have the whole thing on this computer by tomorrow.\" – Master Shake"
echo "Starting OBS and audio mixer..."
obs &
pavucontrol &
echo ""
echo "💡 Quick tips:"
echo "- Set OBS to use 'Stream_Audio' for desktop audio"
echo "- Use pavucontrol to route audio"
echo "- Check your VPN is OFF for better performance"
random_athf_easter_egg
EOF
    chmod +x ~/bin/stream
}