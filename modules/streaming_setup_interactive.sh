#!/bin/bash
# LLM_CAPABILITY: auto
# STREAMING SETUP - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# Source the non-interactive streaming setup module
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/streaming_setup.sh"

streaming_setup_interactive() {
    echo "🎥 STREAMING & RECORDING STUDIO - YOUR CONTENT CREATION POWERHOUSE"
    echo "==============================================================="
    echo ""
    echo "🎯 Build a professional streaming and recording setup with open-source"
    echo "tools that rival expensive proprietary software!"
    echo ""
    echo "🥤 Shake: 'Gentlemen, turn it on!'"
    echo ""
    
    echo "🎓 WHAT IS STREAMING & CONTENT CREATION?"
    echo "========================================"
    echo "Streaming and content creation involves broadcasting or recording your screen,"
    echo "games, or camera to share with others. Modern tools make this accessible:"
    echo "• Live streaming - Share gameplay, tutorials, or events in real-time"
    echo "• Screen recording - Create tutorials, demos, or capture memories"
    echo "• Virtual cameras - Use OBS as a webcam in any application"
    echo "• Audio mixing - Professional sound without expensive hardware"
    echo "• Scene composition - Multiple sources in one polished output"
    echo ""
    echo "🧠 WHY LINUX FOR STREAMING:"
    echo "• Lower system overhead = more resources for encoding"
    echo "• Complete control over audio routing"
    echo "• No forced updates during streams"
    echo "• Free and open-source ecosystem"
    echo "• Better privacy and security"
    echo ""
    echo "🧠 WHY ADHD MINDS EXCEL AT STREAMING:"
    echo "• Hyperfocus sessions create engaging content"
    echo "• Real-time interaction provides dopamine feedback"
    echo "• Visual tools satisfy need for stimulation"
    echo "• Creative expression through multiple mediums"
    echo "• Community building around special interests"
    echo ""
    echo "🍔 Meatwad: 'Click yes for yes!'"
    echo ""
    echo "🏆 THE COMPLETE STREAMING TOOLKIT:"
    echo "=================================="
    echo ""
    echo "1) 📺 OBS Studio - The Broadcasting Powerhouse"
    echo "   💡 What it does: Professional streaming and recording software"
    echo "   ✅ Pros: Industry standard, unlimited scenes, plugin ecosystem"
    echo "   🧠 ADHD-Friendly: Visual scene builder, instant feedback"
    echo "   📖 Learn: Used by millions of creators worldwide"
    echo ""
    echo "2) 🎧 PipeWire + Carla - Audio Routing Magic"
    echo "   💡 What it does: Professional audio mixing and routing"
    echo "   ✅ Pros: Low latency, visual patchbay, unlimited flexibility"
    echo "   🧠 ADHD-Friendly: See your audio flow visually"
    echo "   📖 Learn: Route any audio anywhere with ease"
    echo ""
    echo "3) 🎥 SimpleScreenRecorder - Quick and Easy Recording"
    echo "   💡 What it does: Lightweight screen recording without complexity"
    echo "   ✅ Pros: Simple interface, low resource usage, just works"
    echo "   🧠 ADHD-Friendly: Minimal setup, quick results"
    echo "   📖 Learn: Perfect for tutorials and quick captures"
    echo ""
    echo "4) 🔗 Streamlink - Watch and Record Streams"
    echo "   💡 What it does: Command-line stream downloader and viewer"
    echo "   ✅ Pros: Watch streams in VLC, record for later, no ads"
    echo "   🧠 ADHD-Friendly: Distraction-free stream viewing"
    echo "   📖 Learn: Archive favorite streams and videos"
    echo ""
    echo "5) 🎬 Kdenlive Integration - Video Editing"
    echo "   💡 What it does: Professional video editing for your recordings"
    echo "   ✅ Pros: Multi-track editing, effects, transitions"
    echo "   🧠 ADHD-Friendly: Visual timeline, immediate preview"
    echo "   📖 Learn: Turn raw footage into polished content"
    echo ""
    echo "6) 🚀 Complete Streaming Suite (All tools integrated)"
    echo "   💡 What it does: Professional content creation studio"
    echo "   ✅ Pros: Everything you need for any content type"
    echo "   🧠 ADHD-Friendly: One setup for all creative moods"
    echo "   📖 Learn: The ultimate content creator toolkit"
    echo ""
    echo "🧠 Frylock: 'Turn it off! Turn it off...'"
    echo "🥤 Shake: '...before it's too late!'"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " stream_choice
    
    # Ensure log directory exists
    mkdir -p ~/streaming_studio
    
    case $stream_choice in
        1)
            echo "[LOG] Bill chose OBS Studio" >> ~/streaming_studio/assistant.log
            echo "📺 DEPLOYING OBS STUDIO - THE BROADCASTING POWERHOUSE!"
            echo ""
            echo "🎓 WHAT IS OBS STUDIO?"
            echo "OBS (Open Broadcaster Software) Studio is the gold standard for streaming"
            echo "and recording. It's completely free and rivals $1000+ professional software:"
            echo "• Stream to Twitch, YouTube, Facebook, or any RTMP server"
            echo "• Record in multiple formats and qualities simultaneously"
            echo "• Unlimited scenes and sources (webcam, screen, images, etc.)"
            echo "• Real-time audio/video mixing and effects"
            echo "• Plugin support for endless customization"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR CONTENT CREATORS:"
            echo "• Visual scene builder reduces cognitive load"
            echo "• Hotkey support for ADHD-friendly quick switching"
            echo "• Preview before going live prevents mistakes"
            echo "• Automatic scene switching based on window focus"
            echo "• Community plugins for every possible need"
            echo ""
            
            # Install OBS
            if command -v obs &> /dev/null; then
                echo "✅ OBS Studio is already installed!"
            else
                echo "🔧 Installing OBS Studio..."
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
            
            echo ""
            echo "🚀 OBS STUDIO MASTERY GUIDE"
            echo "==========================="
            echo ""
            echo "🎯 FIRST-TIME SETUP:"
            echo "1. Run Auto-Configuration Wizard (Tools > Auto-Configuration)"
            echo "2. Choose 'Optimize for streaming' or 'recording'"
            echo "3. Run bandwidth test for optimal settings"
            echo "4. Set up your first scene"
            echo ""
            echo "🎬 ESSENTIAL SCENES TO CREATE:"
            echo "• 'Starting Soon' - Pre-stream countdown"
            echo "• 'Main Content' - Your primary scene"
            echo "• 'Be Right Back' - For breaks"
            echo "• 'Ending' - Stream outro"
            echo "• 'Technical Difficulties' - Just in case!"
            echo ""
            echo "🎨 SOURCES YOU'LL USE:"
            echo "• Display Capture - Share your entire screen"
            echo "• Window Capture - Specific application only"
            echo "• Video Capture Device - Webcam or camera"
            echo "• Audio Input/Output - Microphone and desktop audio"
            echo "• Image - Overlays, logos, backgrounds"
            echo "• Text - Stream info, social media handles"
            echo "• Browser Source - Alerts, chat, web content"
            echo ""
            echo "⚨ HOTKEYS FOR ADHD PRODUCTIVITY:"
            echo "• F1-F4: Quick scene switching"
            echo "• F5: Start/Stop streaming"
            echo "• F6: Start/Stop recording"
            echo "• F7: Mute/Unmute mic"
            echo "• F8: Push-to-talk (if preferred)"
            echo ""
            echo "💡 ADHD-FRIENDLY OBS WORKFLOW:"
            echo "• Create scene templates you can reuse"
            echo "• Use Studio Mode to preview before switching"
            echo "• Set up automatic scene switching rules"
            echo "• Use colored sources to organize visually"
            echo "• Create a 'panic button' scene for emergencies"
            echo ""
            echo "🔌 ESSENTIAL PLUGINS:"
            echo "• StreamFX - Advanced effects and filters"
            echo "• Move Transition - Smooth scene transitions"
            echo "• Advanced Scene Switcher - Automation"
            echo "• Virtual Cam - Use OBS as webcam anywhere"
            echo ""
            echo "🎓 STREAMING SETTINGS GUIDE:"
            echo ""
            echo "📹 FOR 1080p 60fps STREAMING:"
            echo "• Video Bitrate: 6000 Kbps"
            echo "• Audio Bitrate: 160"
            echo "• Encoder: x264 or NVENC (NVIDIA)"
            echo "• Preset: Quality or Max Quality"
            echo ""
            echo "💾 FOR HIGH-QUALITY RECORDING:"
            echo "• Recording Format: MKV (can recover if OBS crashes)"
            echo "• Recording Quality: 'Indistinguishable Quality'"
            echo "• Can record while streaming different quality!"
            echo ""
            echo "✅ OBS STUDIO READY!"
            echo "Launch with: obs"
            echo "Auto-config wizard will help with initial setup!"
            echo ""
            echo "🍔 Meatwad: 'Whoa! Damn! You need to watch what you agree to!'"
            ;;
        2)
            echo "[LOG] Bill chose PipeWire + Carla" >> ~/streaming_studio/assistant.log
            echo "🎧 DEPLOYING PIPEWIRE + CARLA - AUDIO ROUTING MAGIC!"
            echo ""
            echo "🎓 WHAT IS PIPEWIRE + CARLA?"
            echo "PipeWire is the modern Linux audio/video server that replaces PulseAudio/JACK."
            echo "Carla is a visual patchbay that makes audio routing intuitive:"
            echo "• Route any audio source to any destination"
            echo "• Apply real-time effects and filters"
            echo "• Mix multiple sources with individual control"
            echo "• Save and load complex routing setups"
            echo "• Low latency for live performance"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR STREAMERS:"
            echo "• Visual patchbay shows audio flow clearly"
            echo "• No more audio routing headaches"
            echo "• Professional mixing without hardware"
            echo "• Perfect for music streamers and podcasters"
            echo "• Saves complex setups for instant recall"
            echo ""
            
            # Install PipeWire and Carla
            echo "🔧 Setting up professional audio routing..."
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y pipewire pipewire-pulse pipewire-jack carla
                echo "✅ PipeWire and Carla installed!"
            else
                echo "Please install PipeWire and Carla for your distribution"
                return
            fi
            
            echo ""
            echo "🚀 AUDIO ROUTING MASTERY"
            echo "======================"
            echo ""
            echo "🎯 COMMON STREAMING AUDIO SETUPS:"
            echo ""
            echo "🎤 BASIC STREAMING:"
            echo "• Microphone → OBS"
            echo "• Desktop Audio → OBS"
            echo "• OBS Monitor → Headphones"
            echo ""
            echo "🎵 MUSIC STREAMING:"
            echo "• Microphone → Compressor → OBS"
            echo "• Music Player → EQ → OBS"
            echo "• OBS Mix → Limiter → Stream"
            echo ""
            echo "🎮 GAMING WITH FRIENDS:"
            echo "• Discord → OBS (friends' voices)"
            echo "• Game Audio → OBS"
            echo "• Your Mic → Discord + OBS"
            echo "• Separate volume control for each!"
            echo ""
            echo "💡 CARLA QUICK START:"
            echo "1. Launch Carla"
            echo "2. Click 'Add Plugin' for effects"
            echo "3. Use 'Patchbay' tab to connect audio"
            echo "4. Save your setup as a project"
            echo "5. Reload instantly next time!"
            echo ""
            echo "✅ AUDIO ROUTING READY!"
            echo "Launch Carla to start routing audio visually!"
            echo ""
            echo "🧠 Carl: 'Well, let's compute it, and I will solve the answer... to your face!'"
            ;;
        3)
            echo "[LOG] Bill chose SimpleScreenRecorder" >> ~/streaming_studio/assistant.log
            echo "🎥 DEPLOYING SIMPLESCREENRECORDER - QUICK AND EASY RECORDING!"
            echo ""
            echo "🎓 WHAT IS SIMPLESCREENRECORDER?"
            echo "SimpleScreenRecorder is exactly what it says - a simple, reliable screen"
            echo "recorder that just works:"
            echo "• Record full screen or specific windows"
            echo "• Live preview while recording"
            echo "• Pause and resume recording"
            echo "• Multiple video codecs and formats"
            echo "• Minimal resource usage"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR QUICK CAPTURES:"
            echo "• No complex setup - just record"
            echo "• ADHD-friendly simple interface"
            echo "• Perfect for tutorials and demos"
            echo "• Low CPU usage during recording"
            echo "• Works great on older hardware"
            echo ""
            
            # Install SimpleScreenRecorder
            if command -v simplescreenrecorder &> /dev/null; then
                echo "✅ SimpleScreenRecorder is already installed!"
            else
                echo "🔧 Installing SimpleScreenRecorder..."
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y simplescreenrecorder
                    echo "✅ SimpleScreenRecorder installed!"
                else
                    echo "Please install SimpleScreenRecorder for your distribution"
                    return
                fi
            fi
            
            echo ""
            echo "🚀 QUICK RECORDING GUIDE"
            echo "======================"
            echo ""
            echo "🎯 RECORDING WORKFLOW:"
            echo "1. Launch SimpleScreenRecorder"
            echo "2. Choose what to record:"
            echo "   • Entire screen"
            echo "   • Fixed rectangle"
            echo "   • Follow cursor"
            echo "   • Record OpenGL (games)"
            echo "3. Set audio input (mic/system/both)"
            echo "4. Choose output file location"
            echo "5. Hit record!"
            echo ""
            echo "💾 RECOMMENDED SETTINGS:"
            echo "• Container: MKV (crash-resistant)"
            echo "• Video codec: H.264"
            echo "• Audio codec: AAC"
            echo "• Frame rate: 30 or 60 FPS"
            echo "• Constant rate factor: 23 (good quality)"
            echo ""
            echo "💡 ADHD RECORDING TIPS:"
            echo "• Set up keyboard shortcuts for start/stop"
            echo "• Use the preview to ensure you're recording right area"
            echo "• Enable 'Show recording area' for visual feedback"
            echo "• Save recordings with descriptive names immediately"
            echo "• Create a dedicated 'Recordings' folder"
            echo ""
            echo "✅ SIMPLESCREENRECORDER READY!"
            echo "Launch from applications menu or run: simplescreenrecorder"
            echo ""
            echo "🍔 Meatwad: 'That is mine. I asked somebody to send that to me, please!'"
            ;;
        4)
            echo "[LOG] Bill chose Streamlink" >> ~/streaming_studio/assistant.log
            echo "🔗 DEPLOYING STREAMLINK - WATCH AND RECORD STREAMS!"
            echo ""
            echo "🎓 WHAT IS STREAMLINK?"
            echo "Streamlink lets you watch online streams in your favorite media player"
            echo "instead of web browsers:"
            echo "• Watch Twitch, YouTube, and 100+ platforms"
            echo "• No ads, no web player issues"
            echo "• Use VLC, MPV, or any media player"
            echo "• Record streams for later viewing"
            echo "• Better performance than web players"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR STREAM VIEWERS:"
            echo "• No web distractions while watching"
            echo "• Lower CPU usage than browsers"
            echo "• Record favorite streams automatically"
            echo "• Watch in picture-in-picture mode"
            echo "• Skip ads and overlays"
            echo ""
            
            # Install Streamlink
            if command -v streamlink &> /dev/null; then
                echo "✅ Streamlink is already installed!"
            else
                echo "🔧 Installing Streamlink..."
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y streamlink
                    echo "✅ Streamlink installed!"
                else
                    pip3 install --user streamlink
                fi
            fi
            
            echo ""
            echo "🚀 STREAMLINK USAGE GUIDE"
            echo "======================="
            echo ""
            echo "🎯 WATCHING STREAMS:"
            echo "• streamlink https://twitch.tv/channel best"
            echo "• streamlink https://youtube.com/watch?v=VIDEO 1080p60"
            echo "• streamlink --player mpv URL quality"
            echo ""
            echo "💾 RECORDING STREAMS:"
            echo "• streamlink -o video.mp4 URL best"
            echo "• streamlink --record video.mp4 URL best (watch + record)"
            echo "• Add date to filename: -o '{time:%Y-%m-%d}-stream.mp4'"
            echo ""
            echo "🎮 QUALITY OPTIONS:"
            echo "• best - Highest available quality"
            echo "• worst - Lowest quality (save bandwidth)"
            echo "• 1080p60, 720p, 480p - Specific qualities"
            echo "• audio_only - Just the audio stream"
            echo ""
            echo "💡 ADHD VIEWING TIPS:"
            echo "• Create aliases for favorite channels"
            echo "• Use --retry-streams to handle drops"
            echo "• Set --player-passthrough hls for stability"
            echo "• Record streams to watch at your own pace"
            echo "• Use MPV's speed controls for VODs"
            echo ""
            echo "✅ STREAMLINK READY!"
            echo "Try: streamlink https://twitch.tv/videos/1234567890 best"
            echo ""
            echo "🧠 Frylock: 'Click on that. Now, give me 5 on black.'"
            ;;
        5)
            echo "[LOG] Bill chose Kdenlive Integration" >> ~/streaming_studio/assistant.log
            echo "🎬 DEPLOYING KDENLIVE - VIDEO EDITING INTEGRATION!"
            echo ""
            echo "🎓 WHAT IS KDENLIVE?"
            echo "Kdenlive is a professional open-source video editor that rivals"
            echo "expensive software like Adobe Premiere:"
            echo "• Multi-track timeline editing"
            echo "• Hundreds of effects and transitions"
            echo "• Color correction and grading"
            echo "• Audio mixing and synchronization"
            echo "• GPU acceleration for fast rendering"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR CONTENT CREATORS:"
            echo "• Visual timeline perfect for ADHD minds"
            echo "• Real-time preview of all edits"
            echo "• Automatic backup prevents lost work"
            echo "• Proxy editing for smooth performance"
            echo "• Direct upload to YouTube/Vimeo"
            echo ""
            
            # Install Kdenlive
            if command -v kdenlive &> /dev/null; then
                echo "✅ Kdenlive is already installed!"
            else
                echo "🔧 Installing Kdenlive..."
                if command -v apt &> /dev/null; then
                    sudo apt update && sudo apt install -y kdenlive
                    echo "✅ Kdenlive installed!"
                else
                    echo "Please install Kdenlive for your distribution"
                    return
                fi
            fi
            
            echo ""
            echo "🚀 VIDEO EDITING WORKFLOW"
            echo "======================="
            echo ""
            echo "🎯 EDITING YOUR STREAMS:"
            echo "1. Import your OBS recordings"
            echo "2. Cut out boring parts with 'S' key"
            echo "3. Add transitions between scenes"
            echo "4. Color correct for consistency"
            echo "5. Add intro/outro sequences"
            echo "6. Export for YouTube/Twitch"
            echo ""
            echo "✂️ ESSENTIAL SHORTCUTS:"
            echo "• Space - Play/Pause"
            echo "• S - Split clip at playhead"
            echo "• X - Cut selected clip"
            echo "• Delete - Remove selected"
            echo "• Ctrl+Z - Undo (lifesaver!)"
            echo "• Ctrl+Enter - Render project"
            echo ""
            echo "🎨 EFFECTS TO MASTER:"
            echo "• Color Correction - Fix OBS color issues"
            echo "• Audio Normalize - Consistent volume"
            echo "• Blur - Hide sensitive info"
            echo "• Speed - Fast forward boring parts"
            echo "• Stabilize - Fix shaky footage"
            echo ""
            echo "💡 ADHD EDITING WORKFLOW:"
            echo "• Edit in small chunks, save often"
            echo "• Use markers to note important moments"
            echo "• Create project templates for consistency"
            echo "• Render preview sections to check work"
            echo "• Keep source files organized by date"
            echo ""
            echo "✅ KDENLIVE READY!"
            echo "Launch with: kdenlive"
            echo "Check out built-in tutorials in Help menu!"
            echo ""
            echo "🥤 Shake: 'I worked very hard to get these.'"
            ;;
        6)
            echo "[LOG] Bill chose Complete Streaming Suite" >> ~/streaming_studio/assistant.log
            echo "🚀 DEPLOYING COMPLETE STREAMING & CONTENT CREATION SUITE!"
            echo ""
            echo "This installs ALL streaming and content creation tools for a professional setup."
            echo "You'll have everything needed to stream, record, edit, and publish content!"
            echo ""
            read -p "Continue with complete suite installation? (y/n): " suite_confirm
            if [[ $suite_confirm =~ ^[Yy]$ ]]; then
                echo "🏗️ Building complete streaming studio..."
                
                # Install all tools
                echo "1/5 Installing OBS Studio..."
                if command -v apt &> /dev/null; then
                    sudo add-apt-repository -y ppa:obsproject/obs-studio 2>/dev/null
                    sudo apt update
                    sudo apt install -y obs-studio 2>/dev/null
                fi
                
                echo "2/5 Installing audio tools..."
                sudo apt install -y pipewire pipewire-pulse carla 2>/dev/null
                
                echo "3/5 Installing SimpleScreenRecorder..."
                sudo apt install -y simplescreenrecorder 2>/dev/null
                
                echo "4/5 Installing Streamlink..."
                sudo apt install -y streamlink 2>/dev/null
                
                echo "5/5 Installing Kdenlive..."
                sudo apt install -y kdenlive 2>/dev/null
                
                # Create streaming dashboard
                cat > ~/streaming_studio/streaming-dashboard << 'EOF'
#!/bin/bash
echo "🎥 BILL'S STREAMING & CONTENT STUDIO"
echo "===================================="
echo ""
echo "Available Tools:"
echo "1) OBS Studio (obs) - Streaming & recording"
echo "2) Carla (carla) - Audio routing"
echo "3) SimpleScreenRecorder - Quick recordings"
echo "4) Streamlink - Watch & record streams"
echo "5) Kdenlive - Video editing"
echo ""
echo "Quick Commands:"
echo "• stream-setup - Configure streaming"
echo "• audio-route - Set up audio routing"
echo "• quick-record - Fast screen recording"
echo ""
echo "Your streaming workspace: ~/streaming_studio/"
EOF
                chmod +x ~/streaming_studio/streaming-dashboard
                
                # Create useful aliases
                cat >> ~/.bashrc << 'EOF'

# Bill Sloth Streaming Studio Aliases
alias stream-dash='~/streaming_studio/streaming-dashboard'
alias obs-config='obs --scene "Main Content"'
alias record-screen='simplescreenrecorder'
alias watch-stream='streamlink'
alias edit-video='kdenlive'
EOF
                
                echo ""
                echo "🎉 COMPLETE STREAMING SUITE DEPLOYED!"
                echo "====================================="
                echo ""
                echo "🎯 YOUR CONTENT CREATION ARSENAL:"
                echo "• OBS Studio - Professional streaming/recording"
                echo "• PipeWire + Carla - Pro audio routing"
                echo "• SimpleScreenRecorder - Quick captures"
                echo "• Streamlink - Stream viewing/recording"
                echo "• Kdenlive - Professional video editing"
                echo ""
                echo "✅ You now have a complete content creation studio!"
                echo "Start with: stream-dash (after reloading your shell)"
                echo ""
                echo "🎓 NEXT STEPS:"
                echo "1. Run OBS auto-configuration wizard"
                echo "2. Set up your streaming scenes"
                echo "3. Configure audio routing in Carla"
                echo "4. Create Kdenlive project templates"
                echo "5. Start creating amazing content!"
            fi
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/streaming_studio/assistant.log
            echo "🤖 SUMMONING CLAUDE CODE FOR ADVANCED STREAMING TOOLS..."
            echo ""
            echo "Claude Code can help you with specialized streaming tools:"
            echo ""
            echo "🎧 ADVANCED AUDIO:"
            echo "• JACK Audio Connection Kit - Professional audio routing"
            echo "• Ardour - Multi-track audio recording and editing"
            echo "• Calf Studio Gear - Professional audio effects"
            echo "• x42-plugins - Broadcast-quality audio processing"
            echo ""
            echo "🎥 SPECIALIZED VIDEO:"
            echo "• DaVinci Resolve - Professional color grading"
            echo "• Natron - Node-based compositing"
            echo "• Blender - 3D graphics and video editing"
            echo "• Motion - Motion graphics and animations"
            echo ""
            echo "💡 Tell Claude Code about your specific streaming needs!"
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\n📝 All actions logged to ~/streaming_setup/assistant.log"
    echo "🔄 You can always re-run this assistant to try a different solution!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    streaming_setup_interactive
fi 