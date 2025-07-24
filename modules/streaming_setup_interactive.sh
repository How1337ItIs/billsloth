#!/bin/bash
# LLM_CAPABILITY: auto
# STREAMING SETUP - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Source the non-interactive streaming setup module
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/streaming_setup.sh"

# Generate personalized streaming recommendations
generate_streaming_plan() {
    local streaming_level="$1"
    local monitor_count="$2" 
    local upload_speed="$3"
    local has_controllers="$4"
    local pc_setup="$5"
    local want_auto_scenes="$6"
    local want_multiplatform="$7"
    local want_remote="$8"
    local want_voice="$9"
    
    echo ""
    echo "🎯 PERSONALIZED STREAMING AUTOMATION PLAN"
    echo "========================================"
    echo ""
    
    case $streaming_level in
        1) echo "📊 Assessment: Casual Streamer Path" ;;
        2) echo "📊 Assessment: Regular Creator Path" ;;
        3) echo "📊 Assessment: Hardcore Streamer Path (SweatyPedals Level!)" ;;
        4) echo "📊 Assessment: Professional Broadcaster Path" ;;
    esac
    
    echo "🖥️  Hardware: $monitor_count monitor(s), $upload_speed Mbps upload, $pc_setup PC setup"
    echo "🎛️  Controllers: $([ "$has_controllers" = "y" ] && echo "Yes - we can integrate them!" || echo "None yet - we'll recommend some")"
    echo ""
    
    echo "🚀 RECOMMENDED AUTOMATION PRIORITY:"
    if [ "$want_auto_scenes" = "y" ]; then
        echo "✅ Scene automation - Perfect for reducing manual management"
    fi
    if [ "$want_multiplatform" = "y" ] && [ "$upload_speed" -ge 10 ]; then
        echo "✅ Multi-platform streaming - Your bandwidth can handle it!"
    elif [ "$want_multiplatform" = "y" ]; then
        echo "⚠️  Multi-platform streaming - Consider upgrading internet (need 10+ Mbps)"
    fi
    if [ "$want_remote" = "y" ]; then
        echo "✅ Remote streaming - Ultimate flexibility for content creation"
    fi
    if [ "$want_voice" = "y" ]; then
        echo "✅ Voice control - Hands-free streaming like a sci-fi movie"
    fi
    
    echo ""
    echo "💡 Your customized plan is ready! Choose options below that match your goals."
}

streaming_setup_interactive() {
    echo "🎥 HARDCORE STREAMING & AUTOMATION EMPIRE - SWEATYPEDALS LEVEL MASTERY"
    echo "======================================================================"
    echo ""
    echo "🎯 Transform into a streaming automation legend with SweatyPedals-level"
    echo "automation that makes other streamers ask 'How did you automate that?'"
    echo ""
    echo "🥤 Shake: 'I worked very hard to get these... streaming automations!'"
    echo ""
    
    # First, assess streaming goals and current setup
    echo "🔍 STREAMING MASTERY ASSESSMENT"
    echo "==============================="
    echo ""
    echo "Before we build your streaming empire, let's understand your goals:"
    echo ""
    echo "🎮 What type of streamer do you want to become?"
    echo "1) Casual Streamer - Basic setup for occasional streaming"
    echo "2) Regular Creator - Consistent schedule, growing audience"
    echo "3) Hardcore Streamer - SweatyPedals level automation and multi-platform"
    echo "4) Professional Broadcaster - Enterprise-level automation and redundancy"
    echo ""
    read -p "Your streaming aspirations (1-4): " streaming_level
    
    echo ""
    echo "🖥️ Current Hardware Assessment:"
    echo "• How many monitors do you have? (1-4+): "
    read -p "> " monitor_count
    echo "• What's your internet upload speed? (Mbps): "
    read -p "> " upload_speed
    echo "• Do you have any MIDI controllers or Stream Decks? (y/n): "
    read -p "> " has_controllers
    echo "• Single PC or dedicated streaming PC? (single/dual): "
    read -p "> " pc_setup
    
    echo ""
    echo "🎯 Automation Goals:"
    echo "• Auto scene switching based on activity? (y/n): "
    read -p "> " want_auto_scenes
    echo "• Multi-platform streaming (Twitch+Kick+YouTube)? (y/n): "
    read -p "> " want_multiplatform  
    echo "• Remote streaming capability? (y/n): "
    read -p "> " want_remote
    echo "• Voice control for stream management? (y/n): "
    read -p "> " want_voice
    
    # Generate personalized recommendations
    generate_streaming_plan "$streaming_level" "$monitor_count" "$upload_speed" "$has_controllers" "$pc_setup" "$want_auto_scenes" "$want_multiplatform" "$want_remote" "$want_voice"
    
    echo ""
    echo "🏆 CHOOSE YOUR STREAMING EVOLUTION PATH:"
    echo "======================================="
    echo ""
    echo "1) 📺 OBS Studio + Advanced Scene Switcher (Hardcore Automation)"
    echo "   💡 What it does: SweatyPedals-style automated scene switching"
    echo "   ✅ Features: Window detection, audio triggers, timer automation"
    echo "   🧠 ADHD-Friendly: Automatic management reduces mental load"
    echo "   📖 Learn: Professional broadcaster-level automation"
    echo ""
    echo "2) 🎧 Professional Audio Empire (PipeWire + Carla + Effects)"
    echo "   💡 What it does: Broadcast-quality audio with automation"
    echo "   ✅ Features: App-specific routing, real-time effects, presets"
    echo "   🧠 ADHD-Friendly: Visual audio flow, saved configurations"
    echo "   📖 Learn: Audio mastery that rivals professional studios"
    echo ""
    echo "3) 🌐 Multi-Platform Broadcasting (Twitch + Kick + YouTube)"
    echo "   💡 What it does: Stream to multiple platforms simultaneously"
    echo "   ✅ Features: RTMP multiplexing, platform-specific overlays"
    echo "   🧠 ADHD-Friendly: One-command multi-platform streaming"
    echo "   📖 Learn: SweatyPedals-style platform dominance"
    echo ""
    echo "4) 🎮 MIDI Control Surface Setup (Physical Stream Control)"
    echo "   💡 What it does: Professional hardware control like broadcast studios"
    echo "   ✅ Features: LED feedback, motorized faders, macro buttons"
    echo "   🧠 ADHD-Friendly: Tactile controls reduce cognitive load"
    echo "   📖 Learn: Hardware mastery that impresses other streamers"
    echo ""
    echo "5) 🗣️ Voice Control Integration (Hands-Free Stream Management)"
    echo "   💡 What it does: Control streaming with voice commands"
    echo "   ✅ Features: Scene switching, audio control, emergency commands"
    echo "   🧠 ADHD-Friendly: Natural interaction, no complex hotkeys"
    echo "   📖 Learn: Futuristic streaming that looks like magic"
    echo ""
    echo "6) 🌍 Remote Streaming Infrastructure (Stream From Anywhere)"
    echo "   💡 What it does: Linux equivalent of SweatyPedals' Apollo/Artemis"
    echo "   ✅ Features: Sunshine+Moonlight, VPN, mobile control"
    echo "   🧠 ADHD-Friendly: Stream from any location, any device"
    echo "   📖 Learn: Ultimate streaming flexibility"
    echo ""
    echo "7) 🚀 Complete Hardcore Streaming Empire (Everything Above)"
    echo "   💡 What it does: Full SweatyPedals-level automation mastery"
    echo "   ✅ Features: Everything above integrated and automated"
    echo "   🧠 ADHD-Friendly: Ultimate streaming automation system"
    echo "   📖 Learn: Become the streaming automation legend"
    echo ""
    echo "8) 🎥 Quick Basic Setup (Traditional simple streaming)"
    echo "   💡 What it does: Simple OBS setup for getting started"
    echo "   ✅ Features: Basic streaming, simple audio, manual control"
    echo "   🧠 ADHD-Friendly: Minimal complexity, quick setup"
    echo "   📖 Learn: Foundation for future automation growth"
    echo ""
    echo "🧠 Frylock: 'The automation... it's too powerful!'"
    echo "🥤 Shake: 'I WILL have that automation!'"
    echo ""
    echo "Type the number of your choice, or 'hardware' for shopping recommendations:"
    read -p "Your choice: " stream_choice
    
    # Ensure log directory exists
    mkdir -p ~/streaming_studio
    
    case $stream_choice in
        1)
            echo "[LOG] Bill chose OBS Studio + Advanced Scene Switcher" >> ~/streaming_studio/assistant.log
            echo "📺 DEPLOYING HARDCORE OBS AUTOMATION - SWEATYPEDALS LEVEL!"
            echo ""
            echo "🎓 WHAT IS ADVANCED SCENE SWITCHING?"
            echo "This is how SweatyPedals manages 600+ days of continuous streaming without"
            echo "manually switching scenes. Advanced Scene Switcher is a FREE OBS plugin that:"
            echo "• Automatically switches scenes based on what you're doing"
            echo "• Responds to audio levels (silent = music visualizer, talking = main scene)"
            echo "• Timer-based automation (starting soon, break screens, ending sequences)"
            echo "• Window detection (gaming scene when games launch, coding scene for terminals)"
            echo "• MQTT integration for external triggers from IoT devices or mobile apps"
            echo ""
            echo "🧠 WHY HARDCORE STREAMERS LOVE AUTOMATION:"
            echo "• Never manually switch scenes again - it just happens automatically"
            echo "• Professional broadcast feeling without the complexity"
            echo "• ADHD-friendly - removes cognitive load of remembering to switch"
            echo "• Looks impressive to viewers - seamless professional transitions"
            echo "• Enables long-form content like subathons without constant management"
            echo ""
            
            # Install OBS + Advanced Scene Switcher
            echo "🔧 INSTALLING HARDCORE STREAMING AUTOMATION..."
            if command -v obs &> /dev/null; then
                echo "✅ OBS Studio is already installed!"
            else
                echo "Installing OBS Studio..."
                if command -v apt &> /dev/null; then
                    sudo add-apt-repository -y ppa:obsproject/obs-studio
                    sudo apt update
                    sudo apt install -y obs-studio
                    echo "✅ OBS Studio installed!"
                else
                    echo "Please install OBS from: https://obsproject.com/"
                    return
                fi
            fi
            
            echo "Installing Advanced Scene Switcher plugin..."
            wget -O /tmp/advanced-scene-switcher.deb https://github.com/WarmUpTill/SceneSwitcher/releases/latest/download/advanced-scene-switcher-linux-x64.deb
            sudo dpkg -i /tmp/advanced-scene-switcher.deb || sudo apt-get install -f
            echo "✅ Advanced Scene Switcher installed!"
            
            echo ""
            echo "🚀 HARDCORE AUTOMATION SETUP GUIDE"
            echo "=================================="
            echo ""
            echo "🎯 SWEATYPEDALS-STYLE SCENE AUTOMATION:"
            echo ""
            echo "🎮 AUTOMATIC GAMING SCENES:"
            echo "• Games launch → Switch to 'Gaming' scene automatically"
            echo "• Game closes → Return to 'Just Chatting' scene"
            echo "• Multiple game configs for different games"
            echo "• Automatic overlay adjustments per game"
            echo ""
            echo "💻 CODING/WORK AUTOMATION:"
            echo "• Terminal/IDE opens → Switch to 'Coding' scene"
            echo "• Browser focus → Switch to 'Browsing' scene"
            echo "• Can detect specific applications and switch accordingly"
            echo ""
            echo "🎵 AUDIO-REACTIVE SCENES:"
            echo "• Microphone silent for 30 seconds → Music visualizer scene"
            echo "• Start talking → Immediately return to main scene"
            echo "• Background music detection → Adjust overlay opacity"
            echo ""
            echo "⏰ TIMER-BASED AUTOMATION:"
            echo "• Stream starts → Auto 'Starting Soon' countdown"
            echo "• Scheduled breaks → Automatic 'BRB' scene"
            echo "• End of stream → Automatic 'Thanks for watching' outro"
            echo "• Can integrate with calendar for scheduled content"
            echo ""
            echo "📱 EXTERNAL TRIGGER AUTOMATION:"
            echo "• Phone app triggers → Scene changes via MQTT"
            echo "• IoT button → Emergency 'Technical Difficulties' scene"
            echo "• Chat commands → Viewer-triggered scene effects"
            echo ""
            echo "🎨 ESSENTIAL AUTOMATED SCENES TO CREATE:"
            echo "• 'Starting Soon' - Auto-countdown with music"
            echo "• 'Gaming' - Game capture + minimal overlays"
            echo "• 'Just Chatting' - Webcam focus + chat integration"
            echo "• 'Coding' - Screen capture + terminal overlay"
            echo "• 'Music Mode' - Visualizer + now playing"
            echo "• 'BRB' - Animated break screen"
            echo "• 'Ending' - Outro with follow reminders"
            echo "• 'Technical Difficulties' - Emergency backup scene"
            echo ""
            echo "⚨ ADVANCED SCENE SWITCHER CONFIGURATION:"
            echo "1. Open OBS → Tools → Advanced Scene Switcher"
            echo "2. Create Window-based rules for automatic app detection"
            echo "3. Set up Audio-based rules for mic activity detection"
            echo "4. Configure Timer-based rules for scheduled automation"
            echo "5. Test all automations before going live"
            echo ""
            echo "💡 PRO AUTOMATION TIPS:"
            echo "• Use 'Conditions' to combine multiple triggers"
            echo "• Add delays to prevent rapid scene switching"
            echo "• Create macro sequences for complex automation"
            echo "• Use 'Pause' conditions to temporarily disable automation"
            echo "• Export/import configurations for backup"
            echo ""
            echo "🔌 ADDITIONAL HARDCORE PLUGINS TO INSTALL:"
            echo "• obs-websocket - External control from scripts/apps"
            echo "• StreamFX - Advanced video effects and filters"
            echo "• obs-midi-mg - MIDI controller integration"
            echo "• Move Transition - Smooth animated scene transitions"
            echo "• Source Dock - Quick source management"
            echo ""
            echo "✅ HARDCORE OBS AUTOMATION READY!"
            echo "Launch OBS and configure Advanced Scene Switcher!"
            echo "You're now equipped with SweatyPedals-level automation!"
            echo ""
            echo "🍔 Meatwad: 'This automation... it's beautiful!'"
            ;;
        2)
            echo "[LOG] Bill chose Professional Audio Empire" >> ~/streaming_studio/assistant.log
            echo "🎧 DEPLOYING PROFESSIONAL AUDIO EMPIRE - BROADCAST QUALITY!"
            echo ""
            echo "🎓 WHAT IS PROFESSIONAL AUDIO ROUTING?"
            echo "This is how hardcore streamers like SweatyPedals achieve broadcast-quality"
            echo "audio that rivals professional radio stations. We're setting up:"
            echo "• PipeWire - Modern Linux audio server that replaces PulseAudio"
            echo "• Carla - Visual audio patchbay for complex routing"
            echo "• Real-time effects processing (compression, EQ, noise gates)"
            echo "• Application-specific audio capture and routing"
            echo "• Saved audio configurations for instant recall"
            echo ""
            echo "🧠 WHY AUDIO MASTERY MATTERS FOR STREAMERS:"
            echo "• Bad audio kills streams faster than bad video"
            echo "• Professional sound makes you stand out immediately"
            echo "• Viewers stay longer when audio is crisp and clear"
            echo "• Advanced routing lets you control exactly what goes to stream"
            echo "• ADHD-friendly visual routing reduces audio confusion"
            echo ""
            
            # Install professional audio stack
            echo "🔧 INSTALLING PROFESSIONAL AUDIO EMPIRE..."
            if command -v pipewire &> /dev/null; then
                echo "✅ PipeWire is already installed!"
            else
                echo "Installing PipeWire audio server..."
                if command -v apt &> /dev/null; then
                    sudo apt update
                    sudo apt install -y pipewire pipewire-pulse pipewire-jack wireplumber
                    echo "✅ PipeWire installed!"
                fi
            fi
            
            if command -v carla &> /dev/null; then
                echo "✅ Carla is already installed!"
            else
                echo "Installing Carla audio patchbay..."
                sudo apt install -y carla carla-bridge-linux32 carla-bridge-linux64
                echo "✅ Carla installed!"
            fi
            
            echo "Installing audio effects and tools..."
            sudo apt install -y calf-plugins eq10q lsp-plugins-lv2 x42-plugins
            echo "✅ Professional audio effects installed!"
            
            echo ""
            echo "🚀 PROFESSIONAL AUDIO SETUP GUIDE"
            echo "================================="
            echo ""
            echo "🎯 STREAMER AUDIO CHAIN EXAMPLES:"
            echo ""
            echo "🎤 BASIC STREAMING CHAIN:"
            echo "Microphone → Noise Gate → Compressor → EQ → OBS → Stream"
            echo "• Noise Gate: Cuts background noise when not talking"
            echo "• Compressor: Evens out volume levels"
            echo "• EQ: Enhances voice clarity and warmth"
            echo ""
            echo "🎵 MUSIC + GAMING CHAIN:"
            echo "Game Audio → Game Bus → Mix"
            echo "Music Player → Music Bus → Mix"
            echo "Microphone → Voice Chain → Mix"
            echo "Mix → Stream (with individual volume control for each)"
            echo ""
            echo "🎮 GAMING WITH FRIENDS:"
            echo "Discord → Friends Bus → Stream + Local"
            echo "Game Audio → Game Bus → Stream + Local"
            echo "Your Mic → Voice Chain → Discord + Stream"
            echo "• Friends' voices go to stream but you control the levels"
            echo "• Your voice goes to both Discord and stream"
            echo "• Game audio mixes perfectly with everything"
            echo ""
            echo "⚨ CARLA AUDIO ROUTING MASTERY:"
            echo "1. Launch Carla in Patchbay mode"
            echo "2. Connect your microphone to effects chain"
            echo "3. Add Calf Compressor → Calf Equalizer → Calf Gate"
            echo "4. Route final output to OBS virtual sources"
            echo "5. Save your setup as a Carla project"
            echo ""
            echo "💡 ESSENTIAL AUDIO EFFECTS FOR STREAMERS:"
            echo "• Calf Compressor - Smooth, professional-sounding compression"
            echo "• EQ10Q - Parametric EQ for voice enhancement"
            echo "• LSP Gate - Advanced noise gate with sidechain"
            echo "• x42 AutoTune - Subtle pitch correction for vocals"
            echo "• Calf Reverb - Add space and presence to voice"
            echo ""
            echo "🎛️ STREAMING AUDIO PRESETS TO CREATE:"
            echo "• 'Streaming Voice' - Compressed, EQ'd, gated microphone"
            echo "• 'Gaming Mix' - Balanced game audio with communication"
            echo "• 'Music Focus' - Enhanced music with ducked voice"
            echo "• 'Podcast Mode' - Warm, intimate voice settings"
            echo "• 'Emergency Backup' - Simple routing when effects fail"
            echo ""
            echo "📊 AUDIO MONITORING SETUP:"
            echo "• qpwgraph - Visual PipeWire connection manager"
            echo "• Helvum - Alternative visual patchbay"
            echo "• pavucontrol - Volume control and device management"
            echo "• Real-time spectrum analyzer for voice EQ"
            echo ""
            echo "🔥 INSTALLING HARDCORE AUDIO MONITORING TOOLS..."
            sudo apt install -y qpwgraph helvum pavucontrol pulsemixer alsamixer
            sudo apt install -y carla-bridge-win32 carla-bridge-win64 # Windows VST support
            sudo apt install -y jaaa japa # Real-time audio analysis
            sudo apt install -y meterbridge # Professional audio meters
            sudo apt install -y hydrogen drumkitx # Drum machine for stream sounds
            sudo apt install -y qjackctl # Advanced JACK control
            echo "✅ Professional audio monitoring arsenal installed!"
            echo ""
            
            echo "🎛️ HARDWARE AUDIO INTERFACE DETECTION:"
            echo "======================================"
            echo ""
            echo "🔍 Scanning for professional audio hardware..."
            
            # Detect audio interfaces
            echo "📡 Detected Audio Devices:"
            aplay -l | grep -E "(card [0-9]+|device [0-9]+)" | while read line; do
                if [[ $line == *"card"* ]]; then
                    echo "🎵 $line"
                fi
            done
            
            echo ""
            echo "🎚️ Available ALSA Mixers:"
            amixer | grep -E "Simple mixer control" | head -5
            
            echo ""
            echo "📊 PipeWire Audio Graph Status:"
            if command -v pw-cli &> /dev/null; then
                echo "Active nodes: $(pw-cli list-objects | grep -c "type:PipeWire:Interface:Node")"
                echo "Active links: $(pw-cli list-objects | grep -c "type:PipeWire:Interface:Link")"
            fi
            
            echo ""
            echo "🔧 ADVANCED SIGNAL FLOW SETUP:"
            echo "=============================="
            echo ""
            
            # Create advanced Carla project templates
            mkdir -p ~/.config/carla/projects
            
            # Professional streaming template
            cat > ~/.config/carla/projects/streaming_pro.carxp << 'EOF'
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE CARLA-PROJECT>
<CARLA-PROJECT VERSION='2.5'>
 <EngineSettings>
  <ForceStereo>false</ForceStereo>
  <PreferPluginBridges>false</PreferPluginBridges>
  <PreferUiBridges>true</PreferUiBridges>
  <UIsAlwaysOnTop>false</UIsAlwaysOnTop>
  <MaxParameters>200</MaxParameters>
  <UIBridgesTimeout>4000</UIBridgesTimeout>
 </EngineSettings>
 
 <Transport>
  <BeatsPerMinute>120</BeatsPerMinute>
  <BeatsPerBar>4</BeatsPerBar>
  <BarBeat>1</BarBeat>
  <Frame>0</Frame>
 </Transport>
 
 <!-- Professional Microphone Chain -->
 <Plugin>
  <Info>
   <Type>LV2</Type>
   <Name>LSP Gate Stereo</Name>
   <URI>http://lsp-plug.in/plugins/lv2/gate_stereo</URI>
  </Info>
  <Data>
   <Active>Yes</Active>
  </Data>
 </Plugin>
 
 <Plugin>
  <Info>
   <Type>LV2</Type>
   <Name>Calf Compressor</Name>
   <URI>http://calf.sourceforge.net/plugins/Compressor</URI>
  </Info>
  <Data>
   <Active>Yes</Active>
  </Data>
 </Plugin>
 
 <Plugin>
  <Info>
   <Type>LV2</Type>
   <Name>EQ10Q</Name>
   <URI>http://eq10q.sourceforge.net/eq/eq10q</URI>
  </Info>
  <Data>
   <Active>Yes</Active>
  </Data>
 </Plugin>
 
</CARLA-PROJECT>
EOF
            
            echo "✅ Created professional streaming Carla template!"
            
            # Gaming audio template
            cat > ~/.config/carla/projects/gaming_mix.carxp << 'EOF'
<?xml version='1.0' encoding='UTF-8'?>
<!DOCTYPE CARLA-PROJECT>
<CARLA-PROJECT VERSION='2.5'>
 <EngineSettings>
  <ForceStereo>false</ForceStereo>
  <PreferPluginBridges>false</PreferPluginBridges>
  <PreferUiBridges>true</PreferUiBridges>
  <UIsAlwaysOnTop>false</UIsAlwaysOnTop>
  <MaxParameters>200</MaxParameters>
  <UIBridgesTimeout>4000</UIBridgesTimeout>
 </EngineSettings>
 
 <!-- Gaming Audio Bus -->
 <Plugin>
  <Info>
   <Type>LV2</Type>
   <Name>Calf Multiband Compressor</Name>
   <URI>http://calf.sourceforge.net/plugins/MultibandCompressor</URI>
  </Info>
  <Data>
   <Active>Yes</Active>
  </Data>
 </Plugin>
 
 <!-- Music Bus -->
 <Plugin>
  <Info>
   <Type>LV2</Type>
   <Name>Calf Stereo Tools</Name>
   <URI>http://calf.sourceforge.net/plugins/StereoTools</URI>
  </Info>
  <Data>
   <Active>Yes</Active>
  </Data>
 </Plugin>
 
</CARLA-PROJECT>
EOF
            
            echo "✅ Created gaming mix Carla template!"
            
            echo ""
            echo "🎚️ CREATING AUDIO CONTROL CENTER LAUNCHER:"
            cat > ~/.local/share/applications/audio-control-center.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Audio Control Center
Comment=Professional audio routing and control suite
Exec=bash -c 'carla ~/.config/carla/projects/streaming_pro.carxp & qpwgraph & pavucontrol & meterbridge -t vu -n "Stream Meters" &'
Icon=multimedia-volume-control
Terminal=false
Categories=AudioVideo;Audio;
StartupNotify=true
EOF
            
            chmod +x ~/.local/share/applications/audio-control-center.desktop
            echo "✅ Audio Control Center launcher created!"
            
            echo ""
            echo "🔊 ADVANCED AUDIO ROUTING PRESETS:"
            echo "================================="
            
            # Create audio routing scripts
            mkdir -p ~/bin/audio-presets
            
            # Streaming preset
            cat > ~/bin/audio-presets/streaming-mode << 'EOF'
#!/bin/bash
echo "🎬 ACTIVATING STREAMING AUDIO MODE"
echo "================================="

# Kill any existing audio processes
pkill carla 2>/dev/null
pkill qpwgraph 2>/dev/null

# Wait for cleanup
sleep 2

# Start professional audio chain
echo "🔧 Starting Carla with streaming template..."
carla ~/.config/carla/projects/streaming_pro.carxp &

# Start visual patchbay
echo "📊 Launching visual audio router..."
qpwgraph &

# Start meters
echo "📈 Starting audio meters..."
meterbridge -t vu -n "Stream Meters" &

# Create virtual sinks for OBS
echo "🎤 Creating OBS audio sinks..."
pactl load-module module-null-sink sink_name=obs_mic sink_properties=device.description="OBS_Microphone"
pactl load-module module-null-sink sink_name=obs_desktop sink_properties=device.description="OBS_Desktop"
pactl load-module module-null-sink sink_name=obs_music sink_properties=device.description="OBS_Music"

echo ""
echo "✅ STREAMING AUDIO MODE ACTIVATED!"
echo "🎵 Virtual sinks created for OBS:"
echo "   • OBS_Microphone - Your processed voice"
echo "   • OBS_Desktop - Game/application audio"  
echo "   • OBS_Music - Background music"
echo ""
echo "🔧 Next steps:"
echo "1. Configure your effects in Carla"
echo "2. Route audio sources in qpwgraph"
echo "3. Select virtual sinks in OBS"
echo "4. Rock that professional sound! 🚀"

# Log the activation
echo "$(date): Streaming audio mode activated" >> ~/.config/streaming-studio/audio.log
EOF
            
            chmod +x ~/bin/audio-presets/streaming-mode
            
            # Gaming preset
            cat > ~/bin/audio-presets/gaming-mode << 'EOF'
#!/bin/bash
echo "🎮 ACTIVATING GAMING AUDIO MODE"
echo "=============================="

# Clean start
pkill carla 2>/dev/null
sleep 2

# Start gaming audio template
echo "🔧 Starting Carla with gaming template..."
carla ~/.config/carla/projects/gaming_mix.carxp &

# Create gaming-specific virtual devices
echo "🎮 Creating gaming audio buses..."
pactl load-module module-null-sink sink_name=game_audio sink_properties=device.description="Game_Audio"
pactl load-module module-null-sink sink_name=discord_audio sink_properties=device.description="Discord_Audio"
pactl load-module module-null-sink sink_name=master_mix sink_properties=device.description="Master_Gaming_Mix"

# Route game audio to mix
pactl load-module module-loopback source=game_audio.monitor sink=master_mix latency_msec=1

echo ""
echo "✅ GAMING AUDIO MODE ACTIVATED!"
echo "🎵 Gaming audio buses created:"
echo "   • Game_Audio - Route your games here"
echo "   • Discord_Audio - Route Discord here"
echo "   • Master_Gaming_Mix - Final output"
echo ""
echo "🎚️ Pro tip: Use pavucontrol to route each application"

echo "$(date): Gaming audio mode activated" >> ~/.config/streaming-studio/audio.log
EOF
            
            chmod +x ~/bin/audio-presets/gaming-mode
            
            # Recording preset
            cat > ~/bin/audio-presets/recording-mode << 'EOF'
#!/bin/bash
echo "🎙️ ACTIVATING RECORDING AUDIO MODE"
echo "================================="

# Ultra-low latency setup for recording
echo "🔧 Configuring ultra-low latency..."

# Start JACK for ultra-low latency (if available)
if command -v jackd &> /dev/null; then
    echo "🚀 Starting JACK for minimal latency..."
    jack_control start
    jack_control ds alsa
    jack_control dps rate 48000
    jack_control dps period 64
    jack_control dps nperiods 2
fi

# Start recording-optimized Carla
carla &

# Create recording sinks
pactl load-module module-null-sink sink_name=recording_output sink_properties=device.description="Recording_Output"

echo ""
echo "✅ RECORDING AUDIO MODE ACTIVATED!"
echo "🎙️ Ultra-low latency configuration:"
echo "   • JACK server running at 48kHz"
echo "   • 64 sample buffer (1.3ms latency)"
echo "   • Recording_Output sink created"
echo ""
echo "📀 Ready for professional recording!"

echo "$(date): Recording audio mode activated" >> ~/.config/streaming-studio/audio.log
EOF
            
            chmod +x ~/bin/audio-presets/recording-mode
            
            # Monitoring preset
            cat > ~/bin/audio-presets/monitoring-mode << 'EOF'
#!/bin/bash
echo "📊 ACTIVATING AUDIO MONITORING MODE"
echo "=================================="

echo "🔍 Starting comprehensive audio monitoring..."

# Visual monitoring
qpwgraph &
pavucontrol &
meterbridge -t vu -n "Level Meters" &
meterbridge -t ppm -n "Peak Meters" &

# Real-time analysis
if command -v jaaa &> /dev/null; then
    echo "📈 Starting spectrum analyzer..."
    jaaa &
fi

if command -v japa &> /dev/null; then
    echo "📊 Starting phase scope..."
    japa &
fi

# Advanced monitoring
if command -v qjackctl &> /dev/null; then
    echo "🎛️ Starting JACK control panel..."
    qjackctl &
fi

echo ""
echo "✅ AUDIO MONITORING ACTIVATED!"
echo "📊 Monitoring tools launched:"
echo "   • qpwgraph - Visual audio routing"
echo "   • pavucontrol - Volume control"
echo "   • meterbridge - Professional meters"
echo "   • jaaa - Spectrum analyzer"
echo "   • japa - Phase scope"
echo ""
echo "👀 Watch those levels and keep it clean!"

echo "$(date): Monitoring mode activated" >> ~/.config/streaming-studio/audio.log
EOF
            
            chmod +x ~/bin/audio-presets/monitoring-mode
            
            echo "✅ Created professional audio preset scripts!"
            
            echo ""
            echo "🎚️ CREATING AUDIO EFFECTS PRESETS:"
            echo "=================================="
            
            # Microphone presets directory
            mkdir -p ~/.config/carla/presets/microphone
            
            # Voice processing preset
            cat > ~/.config/carla/presets/microphone/streaming_voice.preset << 'EOF'
# Professional Streaming Voice Preset
# Optimized for clear, professional broadcast sound

# Noise Gate Settings
gate_threshold=-45dB
gate_ratio=10:1
gate_attack=0.1ms
gate_release=100ms

# Compressor Settings  
comp_threshold=-18dB
comp_ratio=4:1
comp_attack=3ms
comp_release=100ms
comp_makeup_gain=+6dB

# EQ Settings (Enhance voice clarity)
eq_highpass=80Hz
eq_low_shelf=+2dB@200Hz  
eq_mid_boost=+3dB@2.5kHz
eq_high_shelf=+1dB@8kHz
eq_lowpass=15kHz

# De-esser
deess_threshold=-15dB
deess_frequency=7kHz
EOF
            
            # Gaming communication preset
            cat > ~/.config/carla/presets/microphone/gaming_comms.preset << 'EOF'
# Gaming Communication Preset
# Optimized for clear communication in games

# Aggressive Noise Gate (gaming environments are noisy)
gate_threshold=-40dB
gate_ratio=20:1
gate_attack=0.5ms
gate_release=50ms

# Light Compression (preserve dynamics for emotion)
comp_threshold=-20dB
comp_ratio=2:1
comp_attack=5ms
comp_release=150ms
comp_makeup_gain=+3dB

# Communication EQ (cut low rumble, boost presence)
eq_highpass=100Hz
eq_low_cut=-3dB@300Hz
eq_mid_boost=+4dB@3kHz
eq_high_shelf=+2dB@6kHz
EOF
            
            echo "✅ Created professional microphone presets!"
            
            echo ""
            echo "🎛️ AUDIO CONTROL ALIASES:"
            echo "========================"
            
            # Add audio control aliases
            cat >> ~/.bashrc << 'EOF'

# Professional Audio Control Aliases
alias audio-stream='~/bin/audio-presets/streaming-mode'
alias audio-game='~/bin/audio-presets/gaming-mode'
alias audio-record='~/bin/audio-presets/recording-mode'
alias audio-monitor='~/bin/audio-presets/monitoring-mode'
alias audio-control='carla & qpwgraph & pavucontrol &'
alias audio-meters='meterbridge -t vu &'
alias audio-analyze='jaaa &'
alias audio-restart='pulseaudio -k && sleep 2 && pulseaudio --start'

# Quick Audio Status
alias audio-status='echo "🔊 Audio System Status:" && pw-cli info && echo "" && pactl list short sinks'

# Professional Audio Shortcuts
alias mic-test='parecord --channels=1 --rate=48000 --format=s16le | hexdump -C | head'
alias audio-latency='pw-cli list-objects | grep -A5 -B5 latency'
alias audio-graph='qpwgraph'
EOF
            
            echo "✅ Professional audio aliases added!"
            
            echo ""
            echo "🚀 ULTIMATE STREAMING AUDIO QUICK START:"
            echo "======================================="
            echo ""
            echo "💥 INSTANT PROFESSIONAL SETUP:"
            echo "1. Run: audio-stream"
            echo "2. Open Audio Control Center from applications"
            echo "3. Route your mic through the effects chain in Carla"
            echo "4. Set OBS audio sources to the virtual sinks"
            echo "5. Dominate with broadcast-quality audio! 🎵"
            echo ""
            echo "🎮 FOR GAMING:"
            echo "Run: audio-game"
            echo "Perfect balance of game audio, comms, and stream"
            echo ""
            echo "🎙️ FOR RECORDING:"
            echo "Run: audio-record"
            echo "Ultra-low latency for professional recording"
            echo ""
            echo "📊 FOR MONITORING:"
            echo "Run: audio-monitor"
            echo "Complete visual monitoring of your audio pipeline"
            echo ""
            echo "🔧 TROUBLESHOOTING:"
            echo "Run: audio-restart (if things get weird)"
            echo "Run: audio-status (check system status)"
            echo ""
            echo "✅ PROFESSIONAL AUDIO EMPIRE READY!"
            echo "Launch Carla and start building your audio chains!"
            echo "Your stream now has broadcast-quality audio!"
            echo ""
            echo "🧠 Carl: 'Finally! Some professional-grade audio routing!'"
            ;;
        3)
            echo "[LOG] Bill chose Multi-Platform Broadcasting" >> ~/streaming_studio/assistant.log
            echo "🌐 DEPLOYING MULTI-PLATFORM BROADCASTING - SWEATYPEDALS DOMINANCE!"
            echo ""
            echo "🎓 WHAT IS MULTI-PLATFORM STREAMING?"
            echo "This is SweatyPedals' secret weapon - streaming to Twitch, Kick, TikTok,"
            echo "and YouTube SIMULTANEOUSLY with one OBS setup. We're building:"
            echo "• RTMP multiplexing to send your stream to multiple platforms"
            echo "• Platform-specific overlays and chat integration"
            echo "• Automated failover when platforms go down"
            echo "• Unified chat management across all platforms"
            echo "• Different stream qualities per platform if needed"
            echo ""
            echo "🧠 WHY MULTI-PLATFORM STREAMING IS POWERFUL:"
            echo "• Maximize your audience reach across all platforms"
            echo "• Platform redundancy - if Twitch goes down, you're still live"
            echo "• Compare platform performance and revenue"
            echo "• Build communities on multiple platforms simultaneously"
            echo "• Future-proof your streaming career"
            echo ""
            
            # Install multi-platform streaming tools
            echo "🔧 INSTALLING MULTI-PLATFORM STREAMING EMPIRE..."
            
            echo "Installing nginx with RTMP module for stream multiplexing..."
            sudo apt update
            sudo apt install -y nginx libnginx-mod-rtmp
            echo "✅ nginx RTMP server installed!"
            
            echo "Installing stream management tools..."
            sudo apt install -y ffmpeg streamlink yt-dlp
            echo "✅ Stream management tools installed!"
            
            # Configure nginx RTMP server
            echo "Configuring RTMP multiplexer..."
            sudo tee /etc/nginx/sites-available/rtmp > /dev/null << 'EOF'
rtmp {
    server {
        listen 1935;
        chunk_size 4096;
        
        application live {
            live on;
            record off;
            
            # Push to multiple platforms
            push rtmp://ingest.twitch.tv/live/YOUR_TWITCH_KEY;
            push rtmp://ingest.kick.com/live/YOUR_KICK_KEY;
            push rtmp://a.rtmp.youtube.com/live2/YOUR_YOUTUBE_KEY;
            
            # Allow publishing only from localhost
            allow publish 127.0.0.1;
            deny publish all;
        }
    }
}
EOF
            
            sudo ln -sf /etc/nginx/sites-available/rtmp /etc/nginx/sites-enabled/
            sudo systemctl restart nginx
            echo "✅ RTMP multiplexer configured!"
            
            echo ""
            echo "🚀 MULTI-PLATFORM STREAMING SETUP GUIDE"
            echo "======================================="
            echo ""
            echo "🎯 SWEATYPEDALS-STYLE PLATFORM DOMINATION:"
            echo ""
            echo "🔑 STEP 1: GET YOUR STREAM KEYS"
            echo "• Twitch: https://dashboard.twitch.tv/settings/stream"
            echo "• Kick: https://kick.com/dashboard/settings/stream"
            echo "• YouTube: https://studio.youtube.com/channel/UC.../livestreaming"
            echo "• TikTok: https://www.tiktok.com/live/settings"
            echo ""
            echo "⚙️ STEP 2: CONFIGURE RTMP MULTIPLEXER"
            echo "Edit /etc/nginx/sites-available/rtmp and add your stream keys:"
            echo "• Replace YOUR_TWITCH_KEY with your actual Twitch stream key"
            echo "• Replace YOUR_KICK_KEY with your actual Kick stream key"
            echo "• Replace YOUR_YOUTUBE_KEY with your actual YouTube stream key"
            echo "• Restart nginx: sudo systemctl restart nginx"
            echo ""
            echo "🎥 STEP 3: CONFIGURE OBS FOR MULTI-PLATFORM"
            echo "• Go to OBS Settings → Stream"
            echo "• Service: Custom"
            echo "• Server: rtmp://localhost:1935/live"
            echo "• Stream Key: any_key_name (this goes to your local RTMP server)"
            echo "• Start streaming - you're now live on ALL platforms!"
            echo ""
            echo "📊 PLATFORM-SPECIFIC OPTIMIZATIONS:"
            echo ""
            echo "🟣 TWITCH OPTIMIZATION:"
            echo "• 1080p60 @ 6000 Kbps (Partner) or 720p60 @ 3500 Kbps"
            echo "• Focus on chat interaction and community building"
            echo "• Use Twitch-specific overlays with StreamElements"
            echo ""
            echo "🟢 KICK OPTIMIZATION:"
            echo "• Higher bitrates allowed - can push 1080p60 @ 8000 Kbps"
            echo "• Less restrictive content policy"
            echo "• Growing platform with great monetization"
            echo ""
            echo "🔴 YOUTUBE OPTIMIZATION:"
            echo "• Up to 1080p60 @ 9000 Kbps for good quality"
            echo "• Focus on educational/tutorial content"
            echo "• Great for building long-term audience"
            echo ""
            echo "⚫ TIKTOK OPTIMIZATION:"
            echo "• Vertical 9:16 format works best"
            echo "• Short, engaging content clips"
            echo "• Younger demographic focus"
            echo ""
            echo "💬 UNIFIED CHAT MANAGEMENT:"
            echo "• Streamlabs Chatbot - Manages chat across platforms"
            echo "• Restream Chat - Unified chat interface"
            echo "• Custom chat overlay showing all platform messages"
            echo ""
            echo "🛡️ FAILOVER AND REDUNDANCY:"
            echo "• Monitor stream health with custom scripts"
            echo "• Auto-disable failed platforms in nginx config"
            echo "• Emergency single-platform fallback configuration"
            echo ""
            echo "📈 ANALYTICS AND OPTIMIZATION:"
            echo "• Compare viewer count across platforms"
            echo "• Track revenue per platform"
            echo "• A/B test content on different platforms"
            echo "• Schedule platform-specific content"
            echo ""
            echo "✅ MULTI-PLATFORM BROADCASTING EMPIRE READY!"
            echo "Configure your stream keys and dominate ALL platforms!"
            echo "You're now competing with SweatyPedals for platform supremacy!"
            echo ""
            echo "🥤 Shake: 'I am now streaming to ALL the platforms... simultaneously!'"
            ;;
        hardware|Hardware|HARDWARE)
            echo "[LOG] Bill requested hardware shopping recommendations" >> ~/streaming_studio/assistant.log
            echo "🛒 HARDCORE STREAMING HARDWARE SHOPPING GUIDE"
            echo "============================================="
            echo ""
            echo "🎯 Transform your setup into a SweatyPedals-level streaming empire!"
            echo "Here's exactly what hardcore streamers use to dominate platforms:"
            echo ""
            echo "💰 BUDGET TIER ($200-500) - Get Started Right:"
            echo "========================================"
            echo "🎛️ MIDI Control: Behringer X-Touch Mini ($99)"
            echo "   • 8 rotary encoders + 16 buttons with LED feedback"
            echo "   • Perfect for OBS scene switching and audio control"
            echo "   • Compatible with obs-midi-mg plugin"
            echo ""
            echo "🎤 Audio Interface: Focusrite Scarlett Solo ($120)"
            echo "   • Professional XLR input for real microphones"
            echo "   • Zero-latency monitoring"
            echo "   • Broadcast-quality preamps"
            echo ""
            echo "📹 Webcam: Logitech C920 ($70) or C922 Pro ($99)"
            echo "   • 1080p 30fps (C920) or 1080p 60fps (C922)"
            echo "   • Great low-light performance"
            echo "   • Works perfectly with OBS"
            echo ""
            echo "🎧 Headphones: Audio-Technica ATH-M40x ($99)"
            echo "   • Accurate monitoring for stream audio"
            echo "   • Comfortable for long streaming sessions"
            echo "   • Professional studio quality"
            echo ""
            echo "💎 PROFESSIONAL TIER ($500-1500) - Serious Streamer:"
            echo "================================================="
            echo "🎛️ Professional Controller: Novation Launchkey 49 MK3 ($199)"
            echo "   • 49 keys + 16 pads + 8 knobs + faders"
            echo "   • Massive automation potential"
            echo "   • Can control everything in your streaming setup"
            echo ""
            echo "🎤 Professional Microphone Setup:"
            echo "   • Shure SM7B ($399) - The podcaster's dream mic"
            echo "   • Cloudlifter CL-1 ($149) - Boosts SM7B signal"
            echo "   • Boom arm + pop filter ($50)"
            echo ""
            echo "🔊 Audio Interface: Focusrite Scarlett 2i2 ($170)"
            echo "   • Two XLR inputs for mic + guest"
            echo "   • Professional monitoring outputs"
            echo "   • Zero-latency direct monitoring"
            echo ""
            echo "💡 Lighting: Elgato Key Light ($199)"
            echo "   • Professional streaming lighting"
            echo "   • App-controlled brightness and color temperature"
            echo "   • Makes you look like a professional broadcaster"
            echo ""
            echo "🚀 HARDCORE TIER ($1500+) - SweatyPedals Level:"
            echo "=============================================="
            echo "🎛️ Professional Mixer: Behringer X32 Producer ($599)"
            echo "   • 32-channel digital mixer"
            echo "   • Motorized faders with automation"
            echo "   • Multiple effects processors built-in"
            echo "   • Can handle any audio scenario"
            echo ""
            echo "📺 Capture Cards for Multi-Source:"
            echo "   • Elgato 4K60 Pro MK.2 ($249) - Internal PCIe"
            echo "   • AVerMedia Live Gamer Ultra ($179) - USB 3.0"
            echo "   • Multiple cards for console + guest feeds"
            echo ""
            echo "🖥️ Dedicated Streaming PC:"
            echo "   • Separate machine for encoding/streaming"
            echo "   • Gaming PC stays focused on games"
            echo "   • Ultimate performance for both tasks"
            echo ""
            echo "📱 Stream Control Tablet:"
            echo "   • iPad with Touch Portal app"
            echo "   • 110+ customizable buttons"
            echo "   • Control scenes, audio, alerts from anywhere"
            echo ""
            echo "🌐 NETWORK UPGRADES:"
            echo "=================="
            echo "• Dedicated upload bandwidth (minimum 10 Mbps for multi-platform)"
            echo "• Wired ethernet connection (never WiFi for streaming)"
            echo "• Backup internet connection for redundancy"
            echo "• Quality router with QoS prioritization"
            echo ""
            echo "💾 STORAGE UPGRADES:"
            echo "==================="
            echo "• NVMe SSD for recording buffer (1TB+ recommended)"
            echo "• External storage for VOD archives"
            echo "• RAID setup for redundant recording"
            echo ""
            echo "🛍️ SHOPPING PRIORITY ORDER:"
            echo "=========================="
            echo "1. Audio first - Bad audio kills streams"
            echo "2. MIDI controller - Automation is key"
            echo "3. Better camera/lighting - Visual quality matters"
            echo "4. Capture cards - Multi-source content"
            echo "5. Dedicated streaming PC - Ultimate performance"
            echo ""
            echo "💡 PRO TIP: Start with budget tier and upgrade as you grow!"
            echo "Many successful streamers started with basic setups and upgraded"
            echo "as their channels grew. Focus on content first, gear second."
            echo ""
            echo "✅ Ready to build your streaming empire!"
            echo "Start shopping and transform into the streamer you want to be!"
            echo ""
            echo "🧠 Frylock: 'The gear... it's calling to me!'"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo ""
    echo "📝 All actions logged to ~/streaming_studio/assistant.log"
    echo "🔄 You can always re-run this assistant to try different automation options!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    streaming_setup_interactive
fi
