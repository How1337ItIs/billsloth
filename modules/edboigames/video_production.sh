#!/bin/bash
# EdBoiGames Video Production Components
# Screen recording setup and workflow guidance

# Video production workflow education  
explain_video_production() {
    echo "🎬 VIDEO PRODUCTION & EDITING"
    echo "=============================="
    echo ""
    echo "Great content ideas mean nothing without good execution. Video production"
    echo "is the bridge between your gaming footage and engaging YouTube videos."
    echo ""
    echo "🎥 THE VIDEO PRODUCTION PIPELINE:"
    echo ""
    echo "1. 📋 PRE-PRODUCTION (Planning)"
    echo "   • Choose game and content angle"
    echo "   • Write basic script or talking points"
    echo "   • Set up recording environment"
    echo "   • Check audio/video settings"
    echo ""
    echo "2. 🎮 RECORDING (Capture)"
    echo "   • Game capture software (OBS, Bandicam, Shadowplay)"
    echo "   • Audio recording (separate microphone track recommended)"
    echo "   • Multiple takes if needed"
    echo "   • Monitor audio levels during recording"
    echo ""
    echo "3. ✂️  POST-PRODUCTION (Editing)"
    echo "   • Import footage to video editor"
    echo "   • Cut out dead space, mistakes, boring parts"
    echo "   • Add intro, outro, transitions"
    echo "   • Color correction, audio enhancement"
    echo "   • Export in YouTube-optimized format"
    echo ""
    echo "4. 📤 PUBLISHING (Upload & Optimize)"
    echo "   • Upload video with optimized title, description"
    echo "   • Add custom thumbnail"
    echo "   • Set up cards, end screens"
    echo "   • Schedule or publish immediately"
    echo ""
    echo "🛠️  VIDEO EDITING FUNDAMENTALS:"
    echo ""
    echo "✂️  BASIC CUTS & EDITS:"
    echo "• Cut = Remove unwanted parts"
    echo "• Jump cut = Quick transition between similar shots"
    echo "• Montage = Series of quick cuts set to music"
    echo "• B-roll = Supplementary footage to support main content"
    echo ""
    echo "🎵 AUDIO IS KING:"
    echo "• Viewers forgive bad video but not bad audio"
    echo "• Use noise reduction, compression, EQ"
    echo "• Background music adds energy (use copyright-free music)"
    echo "• Audio should be -12dB to -6dB for optimal levels"
    echo ""
    echo "🎨 VISUAL ENHANCEMENTS:"
    echo "• Color correction: Fix lighting, saturation issues"
    echo "• Text overlays: Highlight important information"
    echo "• Zoom/Pan: Add visual interest to static footage"
    echo "• Transitions: Smooth movement between scenes"
    echo ""
    echo "⏱️  PACING & ENGAGEMENT:"
    echo "• First 15 seconds are crucial - hook viewers immediately"
    echo "• Cut dead space aggressively - keep it moving"
    echo "• Vary shot lengths - mix quick cuts with longer scenes"
    echo "• End with call-to-action: 'Like, subscribe, comment'"
    echo ""
    echo "📏 TECHNICAL SPECIFICATIONS:"
    echo "• Resolution: 1920x1080 (1080p) minimum"
    echo "• Frame rate: 30fps or 60fps (match game recording)"
    echo "• Bitrate: 8-12 Mbps for 1080p upload"
    echo "• Format: MP4 with H.264 codec"
    echo ""
    read -p "Press Enter to see video editing tools..."
    clear
}

# Screen recording setup
setup_screen_recording() {
    echo "📹 SCREEN RECORDING FOR GAMING"
    echo "=============================="
    echo ""
    echo "Great gaming content starts with great recordings. Let's set up"
    echo "professional-quality game capture on your system!"
    echo ""
    echo "🎮 GAME RECORDING SOFTWARE COMPARISON:"
    echo ""
    echo "🥇 OBS STUDIO (Free, Professional)"
    echo "   ✅ Pros:"
    echo "   • Completely free and open source"
    echo "   • Professional streaming and recording features"
    echo "   • Unlimited recording length"
    echo "   • Custom scenes and overlays"
    echo "   • Works with all games"
    echo "   • Active community and plugins"
    echo "   ❌ Cons:"
    echo "   • Learning curve for optimization"
    echo "   • Requires setup and configuration"
    echo ""
    echo "🥈 NVIDIA SHADOWPLAY (Free, Nvidia Cards)"
    echo "   ✅ Pros:"
    echo "   • Minimal performance impact"
    echo "   • Instant replay feature"
    echo "   • Hardware encoding"
    echo "   • One-click recording"
    echo "   ❌ Cons:"
    echo "   • Nvidia GPUs only"
    echo "   • Limited customization"
    echo "   • Basic recording features"
    echo ""
    echo "🥉 BANDICAM (Paid, User-Friendly)"
    echo "   ✅ Pros:"
    echo "   • Very easy to use"
    echo "   • Good performance"
    echo "   • Screen drawing while recording"
    echo "   • Scheduled recording"
    echo "   ❌ Cons:"
    echo "   • Costs $39 (one-time)"
    echo "   • Watermark in free version"
    echo "   • Less flexible than OBS"
    echo ""
    
    read -p "Which recording software would you like to set up? (1=OBS, 2=Shadowplay info, 3=Bandicam info): " rec_choice
    
    case $rec_choice in
        1) install_obs_studio ;;
        2) shadowplay_info ;;
        3) bandicam_info ;;
        *) echo "Invalid choice"; return ;;
    esac
}

# OBS Studio installation and setup
install_obs_studio() {
    echo "📹 INSTALLING OBS STUDIO"
    echo "========================"
    echo ""
    echo "OBS Studio is the gold standard for game recording and streaming!"
    echo ""
    
    if command -v obs &> /dev/null; then
        echo "✅ OBS Studio is already installed!"
    else
        echo "📦 Installing OBS Studio..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v flatpak &> /dev/null; then
                flatpak install -y flathub com.obsproject.Studio
            elif command -v snap &> /dev/null; then
                sudo snap install obs-studio
            elif command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y obs-studio
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y obs-studio
            else
                echo "Please download OBS from: https://obsproject.com/"
                xdg-open https://obsproject.com/ &
                return
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install --cask obs
            else
                echo "Download OBS from: https://obsproject.com/"
                open https://obsproject.com/
                return
            fi
        else
            echo "Download OBS from: https://obsproject.com/"
            return
        fi
        
        echo "✅ OBS Studio installed!"
    fi
    
    echo ""
    echo "🚀 OBS STUDIO GAMING SETUP"
    echo "=========================="
    echo ""
    echo "📋 OPTIMAL OBS SETTINGS FOR GAMING:"
    echo ""
    echo "🎮 VIDEO SETTINGS:"
    echo "• Base Resolution: 1920x1080"
    echo "• Output Resolution: 1920x1080 (or 1280x720 for performance)"
    echo "• FPS: 60fps for fast games, 30fps for slower content"
    echo ""
    echo "🎯 OUTPUT SETTINGS:"
    echo "• Recording Format: MP4"
    echo "• Encoder: Hardware (NVENC/AMF) if available, otherwise x264"
    echo "• Rate Control: CBR (Constant Bitrate)"
    echo "• Bitrate: 15000-25000 Kbps for 1080p"
    echo ""
    echo "🎵 AUDIO SETTINGS:"
    echo "• Sample Rate: 44.1 kHz"
    echo "• Channels: Stereo"
    echo "• Desktop Audio: 192 Kbps"
    echo "• Microphone: 192 Kbps"
    echo ""
    echo "🎬 FIRST-TIME SETUP GUIDE:"
    echo ""
    echo "STEP 1: Run Auto-Configuration Wizard"
    echo "• Tools > Auto-Configuration Wizard"
    echo "• Select 'Optimize for recording'"
    echo "• Follow the wizard recommendations"
    echo ""
    echo "STEP 2: Add Game Capture Source"
    echo "• Sources panel > + > Game Capture"
    echo "• Mode: Capture specific window"
    echo "• Window: [Select your game]"
    echo ""
    echo "STEP 3: Add Audio Sources"
    echo "• Sources panel > + > Audio Input Capture (for microphone)"
    echo "• Sources panel > + > Audio Output Capture (for game sound)"
    echo ""
    echo "STEP 4: Test Recording"
    echo "• Start Recording button"
    echo "• Play game for 30 seconds"
    echo "• Stop Recording"
    echo "• Check video quality and audio sync"
    echo ""
    echo "🎯 GAMING-SPECIFIC OBS TIPS:"
    echo "• Use 'Game Capture' source for best performance"
    echo "• Enable 'Capture Cursor' for strategy games"
    echo "• Create scenes for different games/layouts"
    echo "• Use hotkeys for start/stop recording"
    echo "• Monitor CPU usage - switch to hardware encoding if high"
    echo ""
    echo "🧠 ADHD-FRIENDLY OBS WORKFLOW:"
    echo "• Set up recording hotkeys so you don't forget to record"
    echo "• Use OBS Studio's status bar to see recording time"
    echo "• Create simple scenes - avoid over-complicating setup"
    echo "• Test record before important gaming sessions"
    echo ""
    
    read -p "Want to start OBS Studio now? (y/n): " start_obs
    if [[ $start_obs =~ ^[Yy]$ ]]; then
        echo "🚀 Starting OBS Studio..."
        nohup obs > /dev/null 2>&1 &
        echo "OBS Studio is loading - run the Auto-Configuration Wizard first!"
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# Shadowplay information
shadowplay_info() {
    echo "🟢 NVIDIA SHADOWPLAY INFORMATION"
    echo "================================"
    echo ""
    echo "Shadowplay (now GeForce Experience) is Nvidia's built-in recording solution."
    echo ""
    echo "✅ ADVANTAGES:"
    echo "• Minimal performance impact (hardware encoding)"
    echo "• Instant Replay - capture last 5-20 minutes automatically"
    echo "• One-click recording"
    echo "• Automatic game optimization"
    echo "• Free with Nvidia graphics cards"
    echo ""
    echo "❌ LIMITATIONS:"
    echo "• Nvidia GPUs only (GTX 600 series and newer)"
    echo "• Limited customization options"
    echo "• Requires GeForce Experience account"
    echo "• Basic recording features compared to OBS"
    echo ""
    echo "🎮 SHADOWPLAY SETUP:"
    echo "1. Install GeForce Experience from nvidia.com"
    echo "2. Create/login to Nvidia account"
    echo "3. Alt+Z to open overlay"
    echo "4. Settings > Privacy Control > Desktop capture: On"
    echo "5. Settings > Recordings > Quality: High"
    echo "6. Use Alt+F9 to start/stop recording"
    echo ""
    echo "💡 BEST FOR:"
    echo "• Nvidia GPU users who want simple recording"
    echo "• Capturing highlight moments with Instant Replay"
    echo "• Users who prioritize performance over features"
    echo ""
    
    read -p "Open Nvidia GeForce Experience download page? (y/n): " open_nvidia
    if [[ $open_nvidia =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open "https://www.nvidia.com/geforce/geforce-experience/"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            open "https://www.nvidia.com/geforce/geforce-experience/"
        else
            echo "Visit: https://www.nvidia.com/geforce/geforce-experience/"
        fi
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# Bandicam information
bandicam_info() {
    echo "🔴 BANDICAM INFORMATION"
    echo "======================"
    echo ""
    echo "Bandicam is a paid screen recording software known for its simplicity."
    echo ""
    echo "💰 PRICING:"
    echo "• One-time purchase: $39"
    echo "• Free version: 10-minute recordings with watermark"
    echo ""
    echo "✅ ADVANTAGES:"
    echo "• Very user-friendly interface"
    echo "• Good performance with games"
    echo "• Screen drawing while recording"
    echo "• Scheduled recording features"
    echo "• Hardware acceleration support"
    echo ""
    echo "❌ CONSIDERATIONS:"
    echo "• Costs money while OBS is free"
    echo "• Less customization than OBS"
    echo "• No streaming capabilities"
    echo "• Limited advanced features"
    echo ""
    echo "🎮 BANDICAM FEATURES:"
    echo "• Game recording mode"
    echo "• Screen recording mode"
    echo "• Device recording (webcam)"
    echo "• Real-time drawing"
    echo "• Chroma key (green screen)"
    echo ""
    echo "💡 BEST FOR:"
    echo "• Users who want simplicity over features"
    echo "• People willing to pay for ease of use"
    echo "• Recording tutorials with drawing features"
    echo ""
    echo "🤔 RECOMMENDATION:"
    echo "Try OBS Studio first - it's free and more powerful."
    echo "Consider Bandicam only if you need maximum simplicity."
    echo ""
    
    read -p "Open Bandicam website? (y/n): " open_bandicam
    if [[ $open_bandicam =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open "https://www.bandicam.com/"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            open "https://www.bandicam.com/"
        else
            echo "Visit: https://www.bandicam.com/"
        fi
    fi
    
    read -p "Press Enter to continue..."
    clear
}