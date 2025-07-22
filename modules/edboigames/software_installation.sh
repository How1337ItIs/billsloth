#!/bin/bash
# EdBoiGames Software Installation Components
# Video editing, audio tools, and screen recording software

# Video editing software setup
setup_video_editing() {
    echo "🎬 VIDEO EDITING SOFTWARE SETUP"
    echo "==============================="
    echo ""
    echo "Choosing the right video editor can make or break your YouTube journey."
    echo "Let's explore your options from beginner-friendly to professional tools."
    echo ""
    echo "🏆 VIDEO EDITOR COMPARISON:"
    echo ""
    echo "🥇 BEGINNER FRIENDLY:"
    echo ""
    echo "1. 📱 SHOTCUT (Free, Open Source)"
    echo "   ✅ Pros:"
    echo "   • Completely free, no watermarks"
    echo "   • Cross-platform (Windows, Mac, Linux)"
    echo "   • Good selection of effects and transitions"
    echo "   • Active community and tutorials"
    echo "   • Handles most gaming footage well"
    echo "   ❌ Cons:"
    echo "   • Interface can feel clunky at first"
    echo "   • Limited advanced features"
    echo "   • Slower rendering compared to paid alternatives"
    echo ""
    echo "2. 🎯 OPENSHOT (Free, Open Source)"
    echo "   ✅ Pros:"
    echo "   • Very beginner-friendly interface"
    echo "   • Drag-and-drop simplicity"
    echo "   • Good basic effects and titles"
    echo "   • Completely free"
    echo "   ❌ Cons:"
    echo "   • Can be unstable with large files"
    echo "   • Limited professional features"
    echo "   • Slower performance on complex projects"
    echo ""
    echo "🥈 INTERMEDIATE LEVEL:"
    echo ""
    echo "3. 🎪 KDENLIVE (Free, Professional)"
    echo "   ✅ Pros:"
    echo "   • Professional features for free"
    echo "   • Multi-track timeline"
    echo "   • Advanced effects and color correction"
    echo "   • Great for Linux users"
    echo "   • Active development"
    echo "   ❌ Cons:"
    echo "   • Steeper learning curve"
    echo "   • Can be overwhelming for beginners"
    echo "   • Occasional stability issues"
    echo ""
    echo "4. 💰 DAVINCI RESOLVE (Free + Paid)"
    echo "   ✅ Pros:"
    echo "   • Hollywood-grade professional software"
    echo "   • Best color grading tools available"
    echo "   • Advanced audio editing included"
    echo "   • Free version is incredibly powerful"
    echo "   ❌ Cons:"
    echo "   • Requires powerful computer"
    echo "   • Very steep learning curve"
    echo "   • Can be overkill for gaming content"
    echo ""
    echo "🥇 PROFESSIONAL (Paid):"
    echo ""
    echo "5. 💎 ADOBE PREMIERE PRO (Subscription)"
    echo "   ✅ Pros:"
    echo "   • Industry standard for YouTube creators"
    echo "   • Seamless integration with After Effects"
    echo "   • Excellent performance and stability"
    echo "   • Huge library of tutorials and resources"
    echo "   ❌ Cons:"
    echo "   • Expensive monthly subscription ($20.99/month)"
    echo "   • Requires Creative Cloud subscription"
    echo "   • Can be resource intensive"
    echo ""
    
    echo "🎯 RECOMMENDATION FOR GAMING CONTENT:"
    echo ""
    echo "Starting out? → SHOTCUT or KDENLIVE"
    echo "Want professional features? → DAVINCI RESOLVE (free version)"
    echo "Ready to invest? → ADOBE PREMIERE PRO"
    echo ""
    
    read -p "Which video editor would you like to install? (1-5): " editor_choice
    
    case $editor_choice in
        1) install_shotcut ;;
        2) install_openshot ;;
        3) install_kdenlive ;;
        4) install_davinci_resolve ;;
        5) install_adobe_info ;;
        *) echo "Invalid choice, returning to menu"; return ;;
    esac
}

# Shotcut installation
install_shotcut() {
    echo "📱 INSTALLING SHOTCUT"
    echo "===================="
    echo ""
    echo "Shotcut is perfect for gaming content creators who want professional"
    echo "results without the complexity or cost of premium software!"
    echo ""
    
    if command -v shotcut &> /dev/null; then
        echo "✅ Shotcut is already installed!"
    else
        echo "📦 Installing Shotcut..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v flatpak &> /dev/null; then
                flatpak install -y flathub org.shotcut.Shotcut
            elif command -v snap &> /dev/null; then
                sudo snap install shotcut --classic
            elif command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y shotcut
            else
                echo "Please download Shotcut manually from: https://shotcut.org/download/"
                xdg-open https://shotcut.org/download/ &
                return
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install --cask shotcut
            else
                echo "Please download Shotcut from: https://shotcut.org/download/"
                open https://shotcut.org/download/
                return
            fi
        else
            echo "Please download Shotcut from: https://shotcut.org/download/"
            return
        fi
        
        echo "✅ Shotcut installed successfully!"
    fi
    
    echo ""
    echo "🚀 GETTING STARTED WITH SHOTCUT:"
    echo "==============================="
    echo ""
    echo "📋 FIRST-TIME SETUP CHECKLIST:"
    echo "1. Open Shotcut"
    echo "2. Go to Settings > Video Mode > HD 1080p 30fps"
    echo "3. Set up your workspace: View > Layout > Logging"
    echo "4. Enable auto-save: Settings > Auto-save"
    echo ""
    echo "🎮 GAMING VIDEO WORKFLOW:"
    echo ""
    echo "STEP 1: Import your footage"
    echo "• File > Open File (select your game recording)"
    echo "• Drag video to timeline at bottom"
    echo ""
    echo "STEP 2: Basic editing"
    echo "• Use 'S' key to split clips"
    echo "• Delete unwanted sections with Delete key"
    echo "• Drag clips to reorder"
    echo ""
    echo "STEP 3: Add audio"
    echo "• Import commentary/music as separate files"
    echo "• Drag to audio tracks below video"
    echo "• Adjust volume: Filters > Audio > Gain/Volume"
    echo ""
    echo "STEP 4: Enhance video"
    echo "• Filters > Video > Color/Brightness adjustments"
    echo "• Add text: Open Other > Text > Simple Text"
    echo "• Transitions: between clips in timeline"
    echo ""
    echo "STEP 5: Export"
    echo "• File > Export Video"
    echo "• Select 'YouTube' preset"
    echo "• Click 'Export File'"
    echo ""
    echo "🎓 LEARNING RESOURCES:"
    echo "• Official tutorials: https://shotcut.org/tutorials/"
    echo "• YouTube channel: Shotcut Video Editor"
    echo "• Keyboard shortcuts: Help > Keyboard Shortcuts"
    echo ""
    
    read -p "Want to start Shotcut now? (y/n): " start_shotcut
    if [[ $start_shotcut =~ ^[Yy]$ ]]; then
        echo "🚀 Starting Shotcut..."
        nohup shotcut > /dev/null 2>&1 &
        echo "Shotcut is loading - start with File > New to create your first project!"
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# OpenShot installation
install_openshot() {
    echo "🎯 INSTALLING OPENSHOT"
    echo "======================"
    echo ""
    echo "OpenShot offers the simplest path to video editing for beginners!"
    echo ""
    
    if command -v openshot-qt &> /dev/null; then
        echo "✅ OpenShot is already installed!"
    else
        echo "📦 Installing OpenShot..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v flatpak &> /dev/null; then
                flatpak install -y flathub org.openshot.OpenShot
            elif command -v snap &> /dev/null; then
                sudo snap install openshot-qt
            elif command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y openshot-qt
            else
                echo "Download from: https://openshot.org/download/"
                xdg-open https://openshot.org/download/ &
                return
            fi
        else
            echo "Download from: https://openshot.org/download/"
            return
        fi
        
        echo "✅ OpenShot installed successfully!"
    fi
    
    echo ""
    echo "🚀 OPENSHOT QUICK START:"
    echo "========================"
    echo ""
    echo "1. Drag video files into the project panel"
    echo "2. Drag clips to timeline"
    echo "3. Use scissors tool to cut clips"
    echo "4. Add transitions between clips"
    echo "5. Export: File > Export Video"
    echo ""
    
    read -p "Want to start OpenShot now? (y/n): " start_openshot
    if [[ $start_openshot =~ ^[Yy]$ ]]; then
        echo "🚀 Starting OpenShot..."
        nohup openshot-qt > /dev/null 2>&1 &
        echo "OpenShot is loading - perfect for getting started quickly!"
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# Kdenlive installation
install_kdenlive() {
    echo "🎪 INSTALLING KDENLIVE"
    echo "======================"
    echo ""
    echo "Kdenlive offers professional-grade features perfect for serious gaming"
    echo "content creators who want advanced control over their videos!"
    echo ""
    
    if command -v kdenlive &> /dev/null; then
        echo "✅ Kdenlive is already installed!"
    else
        echo "📦 Installing Kdenlive..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v flatpak &> /dev/null; then
                flatpak install -y flathub org.kde.kdenlive
            elif command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y kdenlive
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y kdenlive
            elif command -v pacman &> /dev/null; then
                sudo pacman -S kdenlive
            else
                echo "Please download Kdenlive manually from: https://kdenlive.org/download/"
                xdg-open https://kdenlive.org/download/ &
                return
            fi
        else
            echo "Kdenlive works best on Linux. For Windows/Mac:"
            echo "Download from: https://kdenlive.org/download/"
            xdg-open https://kdenlive.org/download/ &
            return
        fi
        
        echo "✅ Kdenlive installed successfully!"
    fi
    
    echo ""
    echo "🚀 KDENLIVE FOR GAMING CONTENT:"
    echo "==============================="
    echo ""
    echo "🎯 KDENLIVE ADVANTAGES FOR GAMING:"
    echo "• Multi-track timeline - perfect for gameplay + commentary"
    echo "• Advanced keyframe animation"
    echo "• Professional color correction tools"
    echo "• Proxy editing for smooth performance with large files"
    echo "• Built-in title templates"
    echo ""
    echo "📋 GAMING VIDEO SETUP:"
    echo ""
    echo "STEP 1: Project setup"
    echo "• Create new project"
    echo "• Set project profile to match your game footage (usually 1080p60)"
    echo "• Enable proxy clips for smoother editing"
    echo ""
    echo "STEP 2: Multi-track workflow"
    echo "• V1: Main gameplay footage"
    echo "• V2: Webcam/facecam overlay"
    echo "• V3: Text overlays and graphics"
    echo "• A1: Game audio"
    echo "• A2: Your commentary"
    echo "• A3: Background music"
    echo ""
    echo "STEP 3: Advanced editing"
    echo "• Use razor tool (R) for precise cuts"
    echo "• Color correction: Effects > Color > 3-Way Color Corrector"
    echo "• Audio mixing: Use Audio Mixer panel"
    echo "• Keyframe animations for zoom/pan effects"
    echo ""
    echo "STEP 4: Professional touches"
    echo "• Add lower thirds for game information"
    echo "• Use wipe transitions between scenes"
    echo "• Apply noise reduction to commentary audio"
    echo "• Add motion blur for fast-paced game sequences"
    echo ""
    echo "🎓 MASTERING KDENLIVE:"
    echo "• Official manual: https://kdenlive.org/manual/"
    echo "• YouTube tutorials: Search 'Kdenlive gaming tutorial'"
    echo "• Practice with short clips before full videos"
    echo ""
    
    read -p "Want to start Kdenlive now? (y/n): " start_kdenlive
    if [[ $start_kdenlive =~ ^[Yy]$ ]]; then
        echo "🚀 Starting Kdenlive..."
        nohup kdenlive > /dev/null 2>&1 &
        echo "Kdenlive is loading - great choice for professional gaming content!"
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# DaVinci Resolve installation info
install_davinci_resolve() {
    echo "💰 DAVINCI RESOLVE INSTALLATION"
    echo "==============================="
    echo ""
    echo "DaVinci Resolve is Hollywood-grade software that's free for most users!"
    echo "Perfect for creators who want the absolute best tools available."
    echo ""
    echo "⚠️  SYSTEM REQUIREMENTS:"
    echo "• Powerful graphics card (GTX 1060/RX 580 minimum)"
    echo "• 16GB+ RAM recommended"
    echo "• 50GB+ free disk space"
    echo "• Windows 10/11, macOS 10.15+, or Linux"
    echo ""
    echo "🎯 DAVINCI RESOLVE FEATURES:"
    echo "• Professional color grading (used in Hollywood films)"
    echo "• Advanced audio editing (Fairlight)"
    echo "• Motion graphics (Fusion)"
    echo "• Collaboration tools for teams"
    echo "• AI-powered features"
    echo ""
    echo "📋 INSTALLATION STEPS:"
    echo "1. Go to https://blackmagicdesign.com/products/davinciresolve"
    echo "2. Download DaVinci Resolve (free version)"
    echo "3. Create account (required for download)"
    echo "4. Install following their setup wizard"
    echo "5. Consider their free training courses"
    echo ""
    
    read -p "Open DaVinci Resolve download page? (y/n): " open_davinci
    if [[ $open_davinci =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open "https://blackmagicdesign.com/products/davinciresolve"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            open "https://blackmagicdesign.com/products/davinciresolve"
        else
            echo "Visit: https://blackmagicdesign.com/products/davinciresolve"
        fi
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# Adobe info (subscription required)
install_adobe_info() {
    echo "💎 ADOBE PREMIERE PRO INFORMATION"
    echo "================================="
    echo ""
    echo "Adobe Premiere Pro is the industry standard used by most YouTube creators"
    echo "and professional video editors worldwide."
    echo ""
    echo "💰 PRICING (as of 2025):"
    echo "• Premiere Pro only: $20.99/month"
    echo "• Creative Cloud All Apps: $52.99/month"
    echo "• Student discount: 60% off"
    echo ""
    echo "✅ ADVANTAGES:"
    echo "• Industry standard - most tutorials available"
    echo "• Seamless integration with After Effects"
    echo "• Regular updates with new features"
    echo "• Excellent performance and stability"
    echo "• Professional workflows and collaboration"
    echo ""
    echo "❌ CONSIDERATIONS:"
    echo "• Subscription required (no one-time purchase)"
    echo "• Can be expensive for hobbyists"
    echo "• Requires Adobe ID and internet connection"
    echo "• Resource intensive"
    echo ""
    echo "🎯 ALTERNATIVES TO CONSIDER:"
    echo "• DaVinci Resolve - Professional features, free"
    echo "• Kdenlive - Full-featured, open source"
    echo "• Shotcut - Lightweight, beginner-friendly"
    echo ""
    echo "📋 IF YOU CHOOSE ADOBE:"
    echo "1. Visit https://adobe.com/products/premiere.html"
    echo "2. Start with 7-day free trial"
    echo "3. Consider student pricing if eligible"
    echo "4. Download Creative Cloud installer"
    echo ""
    
    read -p "Open Adobe Premiere Pro page? (y/n): " open_adobe
    if [[ $open_adobe =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            xdg-open "https://adobe.com/products/premiere.html"
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            open "https://adobe.com/products/premiere.html"
        else
            echo "Visit: https://adobe.com/products/premiere.html"
        fi
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# Audacity installation and setup
install_audacity() {
    echo "🎵 INSTALLING AUDACITY - FREE PROFESSIONAL AUDIO EDITOR"
    echo "======================================================"
    echo ""
    echo "Audacity is the gold standard for free audio editing and perfect"
    echo "for cleaning up gaming commentary and creating professional audio!"
    echo ""
    echo "🎯 AUDACITY ADVANTAGES FOR GAMING CONTENT:"
    echo "• Completely free and open source"
    echo "• Powerful noise reduction (removes fan noise, keyboard clicks)"
    echo "• Multi-track editing (game audio + commentary)"
    echo "• Professional effects and filters"
    echo "• Export to any format YouTube needs"
    echo "• Lightweight - runs on any computer"
    echo ""
    
    if command -v audacity &> /dev/null; then
        echo "✅ Audacity is already installed!"
    else
        echo "📦 Installing Audacity..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v flatpak &> /dev/null; then
                flatpak install -y flathub org.audacityteam.Audacity
            elif command -v snap &> /dev/null; then
                sudo snap install audacity
            elif command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y audacity
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y audacity
            elif command -v pacman &> /dev/null; then
                sudo pacman -S audacity
            else
                echo "Download from: https://www.audacityteam.org/download/"
                xdg-open https://www.audacityteam.org/download/ &
                return
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install --cask audacity
            else
                echo "Download from: https://www.audacityteam.org/download/"
                open https://www.audacityteam.org/download/
                return
            fi
        else
            echo "Download from: https://www.audacityteam.org/download/"
            return
        fi
        
        echo "✅ Audacity installed successfully!"
    fi
    
    echo ""
    echo "🚀 AUDACITY FOR GAMING CONTENT CREATORS"
    echo "======================================="
    echo ""
    echo "🎓 GAMING COMMENTARY WORKFLOW:"
    echo ""
    echo "STEP 1: Import your audio"
    echo "• File > Import > Audio (select your recording)"
    echo "• Drag game audio and commentary into separate tracks"
    echo "• Use Tracks > New > Stereo Track for multiple sources"
    echo ""
    echo "STEP 2: Clean up the audio"
    echo "• Select a quiet section > Effect > Noise Reduction > Get Noise Profile"
    echo "• Select all audio > Effect > Noise Reduction > OK"
    echo "• This removes background hum, fan noise, keyboard clicks"
    echo ""
    echo "STEP 3: Improve your voice"
    echo "• Select commentary track"
    echo "• Effect > Compressor (makes volume more consistent)"
    echo "• Effect > Normalize (sets optimal volume level)"
    echo "• Effect > Equalization > Bass Boost (makes voice fuller)"
    echo ""
    echo "STEP 4: Balance game and voice audio"
    echo "• Use the gain sliders on each track"
    echo "• Your voice should be clearly audible over game sounds"
    echo "• Game audio typically 20-30% volume of commentary"
    echo ""
    echo "STEP 5: Export for video editing"
    echo "• File > Export > Export as WAV (highest quality)"
    echo "• Choose 44100 Hz, 16-bit for YouTube compatibility"
    echo "• Import this cleaned audio into your video editor"
    echo ""
    echo "🎯 ADHD-FRIENDLY AUDACITY TIPS:"
    echo "• Use keyboard shortcuts: Spacebar (play/pause), Ctrl+Z (undo)"
    echo "• Save project frequently: Ctrl+S"
    echo "• Work in small segments - don't try to edit entire videos at once"
    echo "• Create templates with your favorite effects for consistency"
    echo "• Use labels (Ctrl+B) to mark sections for easy navigation"
    echo ""
    echo "🎵 COMMON GAMING AUDIO PROBLEMS AUDACITY SOLVES:"
    echo "• Background noise from fans/AC: Noise Reduction effect"
    echo "• Quiet voice over loud game: Compressor + Amplify"
    echo "• Audio from different devices at different volumes: Normalize"
    echo "• Mouth sounds (clicks, breaths): Spectral editing tools"
    echo "• Audio that's too long: Trim tool (Ctrl+T)"
    echo ""
    
    read -p "Want to start Audacity now? (y/n): " start_audacity
    if [[ $start_audacity =~ ^[Yy]$ ]]; then
        echo "🚀 Starting Audacity..."
        nohup audacity > /dev/null 2>&1 &
        echo "Audacity is loading - perfect for professional gaming audio!"
    fi
    
    read -p "Press Enter to continue..."
    clear
}

# LMMS installation and setup
install_lmms() {
    echo "🎹 INSTALLING LMMS - FREE MUSIC PRODUCTION STUDIO"
    echo "================================================"
    echo ""
    echo "LMMS (Linux MultiMedia Studio) is perfect for creating custom music"
    echo "for your gaming content - no licensing fees, no copyright issues!"
    echo ""
    
    if command -v lmms &> /dev/null; then
        echo "✅ LMMS is already installed!"
    else
        echo "📦 Installing LMMS..."
        
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            if command -v flatpak &> /dev/null; then
                flatpak install -y flathub io.lmms.LMMS
            elif command -v apt &> /dev/null; then
                sudo apt update && sudo apt install -y lmms
            elif command -v dnf &> /dev/null; then
                sudo dnf install -y lmms
            elif command -v pacman &> /dev/null; then
                sudo pacman -S lmms
            else
                echo "Download from: https://lmms.io/download"
                xdg-open https://lmms.io/download &
                return
            fi
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            if command -v brew &> /dev/null; then
                brew install --cask lmms
            else
                echo "Download from: https://lmms.io/download"
                open https://lmms.io/download
                return
            fi
        else
            echo "Download from: https://lmms.io/download"
            return
        fi
        
        echo "✅ LMMS installed successfully!"
    fi
    
    echo ""
    echo "🎵 LMMS FOR GAMING CONTENT CREATORS"
    echo "=================================="
    echo ""
    echo "🎯 WHAT YOU CAN CREATE WITH LMMS:"
    echo "• Custom intro/outro music"
    echo "• Background music for montages"
    echo "• Sound effects and jingles"
    echo "• Podcast-style intro music"
    echo "• Stream overlay music"
    echo ""
    echo "🎹 LMMS FEATURES:"
    echo "• Built-in synthesizers and drum machines"
    echo "• VST plugin support"
    echo "• MIDI controller support"
    echo "• Multi-track mixing"
    echo "• Export to WAV/MP3/OGG"
    echo ""
    echo "🚀 GETTING STARTED:"
    echo "1. Open LMMS"
    echo "2. Start with a template: File > New from Template"
    echo "3. Try 'Hip Hop' or 'Electronic' templates for gaming"
    echo "4. Experiment with different instruments"
    echo "5. Export: File > Export > WAV"
    echo ""
    
    read -p "Want to start LMMS now? (y/n): " start_lmms
    if [[ $start_lmms =~ ^[Yy]$ ]]; then
        echo "🚀 Starting LMMS..."
        nohup lmms > /dev/null 2>&1 &
        echo "LMMS is loading - time to create your signature sound!"
    fi
    
    read -p "Press Enter to continue..."
    clear
}