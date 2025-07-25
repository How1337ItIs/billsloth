#!/bin/bash
# LLM_CAPABILITY: auto
# DATA HOARDING SUITE - INTERACTIVE ASSISTANT PATTERN
# Presents mature open-source tools, explains pros/cons, logs choice, and allows open-ended input.

# CLAUDE_OPTIONS: 1=FileBot (Media), 2=Keka (Archives), 3=SyncThing (Sync), 4=Restic (Backup), 5=Complete Hoarding Suite
# CLAUDE_PROMPTS: Main tool selection, Installation confirmation, Additional tools
# CLAUDE_DEPENDENCIES: java, python3, curl, git

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

data_hoarding_interactive() {
    # Pirate-themed header with ASCII art and colors
    echo -e "\033[31m"
    cat << 'PIRATE_BANNER'
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣤⣤⣤⣤⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⢀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⣿⣿⣿⡿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⠿⢿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⢸⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠈⣿⣿⣿⣷⣦⣄⣀⠀⠀⠀⠀⠀⠀⣀⣠⣴⣾⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠿⣿⣿⣿⣿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
    
    🏴‍☠️ ═══════════════════════════════════════════════════════════ 🏴‍☠️
       ██████╗ ██╗██████╗  █████╗ ████████╗███████╗    ██████╗  █████╗ ████████╗ █████╗ 
       ██╔══██╗██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    ██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗
       ██████╔╝██║██████╔╝███████║   ██║   █████╗      ██║  ██║███████║   ██║   ███████║
       ██╔═══╝ ██║██╔══██╗██╔══██║   ██║   ██╔══╝      ██║  ██║██╔══██║   ██║   ██╔══██║
       ██║     ██║██║  ██║██║  ██║   ██║   ███████╗    ██████╔╝██║  ██║   ██║   ██║  ██║
       ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚══════╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝
    
       ██╗  ██╗ ██████╗  █████╗ ██████╗ ██████╗ ██╗███╗   ██╗ ██████╗     ███████╗██╗   ██╗██╗████████╗███████╗
       ██║  ██║██╔═══██╗██╔══██╗██╔══██╗██╔══██╗██║████╗  ██║██╔════╝     ██╔════╝██║   ██║██║╚══██╔══╝██╔════╝
       ███████║██║   ██║███████║██████╔╝██║  ██║██║██╔██╗ ██║██║  ███╗    ███████╗██║   ██║██║   ██║   █████╗  
       ██╔══██║██║   ██║██╔══██║██╔══██╗██║  ██║██║██║╚██╗██║██║   ██║    ╚════██║██║   ██║██║   ██║   ██╔══╝  
       ██║  ██║╚██████╔╝██║  ██║██║  ██║██████╔╝██║██║ ╚████║╚██████╔╝    ███████║╚██████╔╝██║   ██║   ███████╗
       ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚══════╝ ╚═════╝ ╚═╝   ╚═╝   ╚══════╝
    🏴‍☠️ ═══════════════════════════════════════════════════════════ 🏴‍☠️
PIRATE_BANNER
    echo -e "\033[33m"
    echo "    ⚓ AHOY BILL! Time to plunder the digital seas and organize your treasure! ⚓"
    echo "    🗺️  Here be the finest tools for managing your precious media bounty! 🗺️ "
    echo "    🏴‍☠️ Choose your weapon, and I'll teach you the ways of each tool! 🏴‍☠️"
    echo "    🦜 Say 'other' to summon Claude Code for more treasure hunting options! 🦜"
    echo -e "\033[0m"
    echo ""
    echo "🎓 WHAT IS DATA HOARDING?"
    echo "========================="
    echo "Data hoarding is the practice of collecting, organizing, and preserving digital media"
    echo "for offline access. Think Netflix + Spotify, but you own everything locally!"
    echo ""
    echo "🏆 WHY HOARD DATA?"
    echo "• 🔒 Privacy - No tracking or data collection"
    echo "• ⚡ Performance - No buffering or slow connections"
    echo "• 💰 Cost - No monthly subscriptions forever"
    echo "• 🌐 Availability - Works without internet"
    echo "• 🎯 Control - Keep what you want, remove ads"
    echo ""
    echo "📚 THE COMPLETE MEDIA PIPELINE:"
    echo "==============================="
    echo ""
    echo "1) 📥 yt-dlp Video Downloader (Essential first mate!)"
    echo "   💡 What it does: Downloads videos/audio from 1000+ sites (YouTube, etc.)"
    echo "   ✅ Pros: Supports everything, gets best quality, includes subtitles"
    echo "   🧠 ADHD-Friendly: Command-line = no distracting ads or UI"
    echo "   📖 Learn: One command downloads entire playlists automatically"
    echo ""
    echo "2) ⚔️ *arr Armada (Sonarr/Radarr/Prowlarr - Automation Captain!)"
    echo "   💡 What it does: Automates finding, downloading & organizing TV/movies"
    echo "   ✅ Pros: Set it once, runs forever, perfect metadata & naming"
    echo "   🧠 ADHD-Friendly: Reduces executive function load - no manual searching"
    echo "   📖 Learn: 'Smart' pirates use this for hands-off media collection"
    echo ""
    echo "3) 🎵 Beets Music Librarian (Your music's personal butler)"
    echo "   💡 What it does: Organizes & tags music collections automatically"
    echo "   ✅ Pros: Fixes messy ID3 tags, finds album art, detects duplicates"
    echo "   🧠 ADHD-Friendly: One command fixes thousands of files instantly"
    echo "   📖 Learn: Used by obsessive collectors to maintain perfect libraries"
    echo ""
    echo "4) 🍿 Jellyfin Streaming Ship (Your personal Netflix)"
    echo "   💡 What it does: Streams your collected media to any device"
    echo "   ✅ Pros: Beautiful interface, transcoding, multi-user support"
    echo "   🧠 ADHD-Friendly: Familiar Netflix-like interface reduces cognitive load"
    echo "   📖 Learn: Open-source alternative to Plex with no account required"
    echo ""
    echo "5) 🏷️ TagSpaces File Organizer (Color-coded digital filing)"
    echo "   💡 What it does: Tag and organize ANY files with colors & notes"
    echo "   ✅ Pros: Works offline, visual organization, search by tags"
    echo "   🧠 ADHD-Friendly: Visual/color system aids memory and reduces chaos"
    echo "   📖 Learn: Like having a personal assistant for file organization"
    echo ""
    echo "6) 🔍 ExifTool Metadata Master (Photo/video forensics tool)"
    echo "   💡 What it does: Reads/writes metadata for photos, videos, any file"
    echo "   ✅ Pros: Bulk operations, privacy stripping, auto-organization"
    echo "   🧠 ADHD-Friendly: Scriptable for automated batch operations"
    echo "   📖 Learn: Professional archivists' secret weapon for metadata control"
    echo ""
    echo "7) 🔒 Gluetun VPN Fortress (Bulletproof protection)"
    echo "   💡 What it does: Routes all downloads through VPN automatically"
    echo "   ✅ Pros: If VPN fails, downloads stop - zero leaks guaranteed"
    echo "   🧠 ADHD-Friendly: Set-and-forget protection, no manual VPN management"
    echo "   📖 Learn: Docker networking creates unhackable privacy barrier"
    echo ""
    echo "8) 🎯 Complete Media Pipeline (Full automation setup)"
    echo "   💡 What it does: Combines all tools into seamless workflow"
    echo "   ✅ Pros: Ultimate hands-off media management system"
    echo "   🧠 ADHD-Friendly: Reduces decision fatigue with automated choices"
    echo "   📖 Learn: The 'holy grail' setup most pirates dream of achieving"
    echo ""
    echo "9) ⚓ Current Setup Enhancement (Upgrade your existing tools)"
    echo "   💡 What it does: Improves your current qBittorrent setup"
    echo "   ✅ Pros: Builds on what you know, gradual learning curve"
    echo "   🧠 ADHD-Friendly: Familiar tools with new automation features"
    echo "   📖 Learn: Evolution over revolution - smart upgrade path"
    echo ""
    echo "Type the number of your choice, or 'other' to ask Claude Code for more options:"
    read -p "Your choice: " dh_choice
    case $dh_choice in
        1)
            echo "[LOG] Bill chose yt-dlp Video Downloader" >> ~/data_hoarding/assistant.log
            echo "📥 DEPLOYING YT-DLP - THE ULTIMATE VIDEO DOWNLOADER!"
            echo ""
            echo "🎓 WHAT IS YT-DLP?"
            echo "yt-dlp is the most powerful video downloader available. It's a fork of"
            echo "youtube-dl with extra features and supports 1000+ sites including:"
            echo "• YouTube (videos, playlists, channels)"
            echo "• Twitch, TikTok, Instagram, Twitter"
            echo "• Educational sites (Khan Academy, Coursera)"
            echo "• Podcasts and music platforms"
            echo ""
            echo "🧠 WHY IT'S ADHD-FRIENDLY:"
            echo "• Command-line interface = no distracting ads or popups"
            echo "• Batch downloads = set it and forget it"
            echo "• Automatic subtitles and metadata"
            echo "• Works offline once installed"
            echo ""
            
            # Check if Python is installed
            if ! command -v python3 &> /dev/null; then
                echo "⚓ Installing Python first (yt-dlp needs it)..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    sudo apt update && sudo apt install -y python3 python3-pip
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    brew install python3
                else
                    echo "Please install Python 3 manually, then rerun this script"
                    return 1
                fi
            fi
            
            echo "🔧 Installing yt-dlp..."
            pip3 install --user yt-dlp
            
            # Add to PATH if needed
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
                export PATH="$HOME/.local/bin:$PATH"
            fi
            
            # Create downloads directory
            mkdir -p ~/Downloads/yt-dlp
            
            echo ""
            echo "🎓 YT-DLP CRASH COURSE:"
            echo "======================"
            echo ""
            echo "📖 BASIC EXAMPLES:"
            echo "# Download a single video:"
            echo "yt-dlp 'https://www.youtube.com/watch?v=VIDEO_ID'"
            echo ""
            echo "# Download entire playlist:"
            echo "yt-dlp 'https://www.youtube.com/playlist?list=PLAYLIST_ID'"
            echo ""
            echo "# Download only audio (great for music/podcasts):"
            echo "yt-dlp -x --audio-format mp3 'VIDEO_URL'"
            echo ""
            echo "# Download with subtitles:"
            echo "yt-dlp --write-subs --write-auto-subs 'VIDEO_URL'"
            echo ""
            echo "🎯 POWER USER FEATURES:"
            echo "# Download best quality up to 1080p:"
            echo "yt-dlp -f 'best[height<=1080]' 'VIDEO_URL'"
            echo ""
            echo "# Archive downloaded videos (skip duplicates):"
            echo "yt-dlp --download-archive downloaded.txt 'CHANNEL_URL'"
            echo ""
            echo "# Custom filename format:"
            echo "yt-dlp -o '%(uploader)s - %(title)s.%(ext)s' 'VIDEO_URL'"
            echo ""
            echo "💡 PRO TIP: Create a simple alias for your most common use:"
            echo "echo \"alias ytmp3='yt-dlp -x --audio-format mp3'\" >> ~/.bashrc"
            echo ""
            echo "🎬 EXAMPLE WORKFLOW:"
            echo "1. Find interesting playlist/channel"
            echo "2. Run: yt-dlp --download-archive archive.txt 'PLAYLIST_URL'"
            echo "3. Set up cron job to auto-download new videos"
            echo "4. Videos appear in ~/Downloads/yt-dlp automatically!"
            echo ""
            echo "✅ YT-DLP INSTALLED! Try: yt-dlp 'https://www.youtube.com/watch?v=dQw4w9WgXcQ'"
            ;;
        2)
            echo "[LOG] Bill chose *arr Armada" >> ~/data_hoarding/assistant.log
            echo "🏴‍☠️ DEPLOYING THE *ARR ARMADA! Prepare to sail the automation seas, matey!"
            
            # Check Docker
            if ! command -v docker &> /dev/null; then
                echo "⚓ Installing Docker first - every good pirate ship needs proper rigging..."
                curl -fsSL https://get.docker.com | sudo bash
                sudo usermod -aG docker $USER
                echo "🦜 Arrr! Log out and back in for Docker permissions, then set sail again!"
            fi
            
            # Set up *arr stack
            mkdir -p ~/docker/media-stack && cd ~/docker/media-stack
            wget https://raw.githubusercontent.com/docker/awesome-compose/master/pihole-cloudflared-DoH/docker-compose.yaml -O docker-compose.yml
            # Actually, let me create a proper one...
            cat > docker-compose.yml << 'EOF'
version: "3"
services:
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/prowlarr:/config
    ports:
      - 9696:9696
    restart: unless-stopped

  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/sonarr:/config
      - ~/Torrents:/downloads
      - ~/Media/TV:/tv
    ports:
      - 8989:8989
    restart: unless-stopped

  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/radarr:/config
      - ~/Torrents:/downloads
      - ~/Media/Movies:/movies
    ports:
      - 7878:7878
    restart: unless-stopped
EOF
            mkdir -p ~/Media/{TV,Movies,Music}
            docker-compose up -d
            
            echo "🏴‍☠️ ARMADA DEPLOYED! Your automation fleet is ready to sail!"
            echo "🗺️ Navigate to your treasure management dashboards:"
            echo "   🔍 Prowlarr (Treasure Maps): http://localhost:9696"
            echo "   📺 Sonarr (TV Treasures): http://localhost:8989" 
            echo "   🎬 Radarr (Movie Treasures): http://localhost:7878"
            echo "⚓ May fair winds fill your sails, and may your drives never be empty!"
            ;;
        2)
            echo "[LOG] Bill chose Jellyfin Streaming Ship" >> ~/data_hoarding/assistant.log
            echo "🍿 LAUNCHING THE JELLYFIN STREAMING SHIP!"
            wget -O - https://repo.jellyfin.org/install-debuntu.sh | sudo bash
            echo "🎬 Streaming ship ready for duty! All aboard at http://localhost:8096"
            ;;
        3)
            echo "[LOG] Bill chose Beets Music Librarian" >> ~/data_hoarding/assistant.log
            echo "🎵 DEPLOYING BEETS - YOUR MUSIC'S PERSONAL BUTLER!"
            echo ""
            echo "🎓 WHAT IS BEETS?"
            echo "Beets is a music library manager that automatically organizes and"
            echo "tags your music collection. Think of it as a librarian who:"
            echo "• Identifies songs from messy filenames"
            echo "• Downloads correct metadata from MusicBrainz"
            echo "• Finds and embeds album artwork"
            echo "• Detects and removes duplicates"
            echo "• Organizes files into a consistent structure"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD:"
            echo "• One command processes thousands of files"
            echo "• Eliminates decision paralysis with smart defaults"  
            echo "• Visual confirmation before changes"
            echo "• No manual tagging or sorting needed"
            echo ""
            
            # Install Python and pip if needed
            if ! command -v python3 &> /dev/null; then
                echo "🔧 Installing Python (Beets requires it)..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    sudo apt update && sudo apt install -y python3 python3-pip
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    brew install python3
                fi
            fi
            
            echo "🔧 Installing Beets with essential plugins..."
            pip3 install --user beets[fetchart,lyrics,lastgenre]
            
            # Create beets config directory and basic config
            mkdir -p ~/.config/beets
            cat > ~/.config/beets/config.yaml << 'EOF'
directory: ~/Music/Library
library: ~/.config/beets/musiclibrary.db

import:
    move: yes
    write: yes
    
plugins: fetchart lyrics lastgenre
    
fetchart:
    auto: yes
    
lyrics:
    auto: yes
    
lastgenre:
    auto: yes
EOF
            
            # Create music directories
            mkdir -p ~/Music/{Library,Incoming}
            
            echo ""
            echo "🎓 BEETS CRASH COURSE:"
            echo "====================="
            echo ""
            echo "📖 BASIC WORKFLOW:"
            echo "1. Put messy music files in ~/Music/Incoming/"
            echo "2. Run: beet import ~/Music/Incoming/"
            echo "3. Beets identifies each song and asks for confirmation"
            echo "4. Clean, organized music appears in ~/Music/Library/"
            echo ""
            echo "🎯 POWER COMMANDS:"
            echo "# Import with automatic confirmation (ADHD-friendly!):"
            echo "beet import -A ~/Music/Incoming/"
            echo ""
            echo "# Update library with new tags and artwork:"
            echo "beet update"
            echo ""
            echo "# Find and remove duplicate tracks:"
            echo "beet duplicates"
            echo ""
            echo "# Search your library:"
            echo "beet ls artist:Beatles"
            echo ""
            echo "# Get statistics about your collection:"
            echo "beet stats"
            echo ""
            echo "💡 PRO TIP: For maximum ADHD-friendliness, create this alias:"
            echo "echo \"alias musicimport='beet import -A'\" >> ~/.bashrc"
            echo ""
            echo "🎵 EXAMPLE RESULTS:"
            echo "Before: '01-track01.mp3' (unknown metadata)"
            echo "After:  'The Beatles/Abbey Road/01 Come Together.mp3' (perfect tags + art)"
            echo ""
            echo "✅ BEETS INSTALLED! Try: beet import ~/Music/Incoming/"
            echo "Put some messy music files in ~/Music/Incoming/ and watch the magic!"
            ;;
        4)
            echo "[LOG] Bill chose Jellyfin Streaming Ship" >> ~/data_hoarding/assistant.log
            echo "🍿 LAUNCHING THE JELLYFIN STREAMING SHIP!"
            echo ""
            echo "🎓 WHAT IS JELLYFIN?"
            echo "Jellyfin is your personal Netflix! It's an open-source media server that:"
            echo "• Streams your movies/TV shows to any device"
            echo "• Automatically fetches beautiful artwork & metadata"  
            echo "• Transcodes video for smooth playback everywhere"
            echo "• Supports user accounts and parental controls"
            echo "• Works with Roku, Apple TV, Android, iOS, web browsers"
            echo ""
            echo "🧠 WHY IT'S ADHD-FRIENDLY:"
            echo "• Familiar Netflix-like interface reduces cognitive load"
            echo "• Automatic organization with posters and descriptions"
            echo "• Resume watching from any device"
            echo "• No ads or distractions"
            echo ""
            
            # Check for Docker first (recommended method)
            if command -v docker &> /dev/null; then
                echo "🔧 Installing Jellyfin via Docker (recommended)..."
                mkdir -p ~/docker/jellyfin
                mkdir -p ~/Media/{Movies,TV,Music}
                cd ~/docker/jellyfin
                cat > docker-compose.yml << 'EOF'
version: "3.5"
services:
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    user: 1000:1000
    network_mode: 'host'
    volumes:
      - ./config:/config
      - ./cache:/cache
      - ~/Media:/media:ro
    restart: 'unless-stopped'
    environment:
      - JELLYFIN_PublishedServerUrl=http://localhost:8096
EOF
                docker-compose up -d
                echo "🎬 Jellyfin started via Docker!"
            else
                # Fallback to direct installation
                echo "🔧 Installing Jellyfin directly..."
                if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                    wget -O - https://repo.jellyfin.org/install-debuntu.sh | sudo bash
                elif [[ "$OSTYPE" == "darwin"* ]]; then
                    brew install --cask jellyfin
                fi
            fi
            
            echo ""
            echo "🎓 JELLYFIN SETUP GUIDE:"
            echo "======================="
            echo ""
            echo "📖 FIRST-TIME SETUP:"
            echo "1. Open http://localhost:8096 in your browser"
            echo "2. Create admin account when prompted"
            echo "3. Add media libraries:"
            echo "   • Movies: ~/Media/Movies" 
            echo "   • TV Shows: ~/Media/TV"
            echo "   • Music: ~/Media/Music"
            echo "4. Jellyfin will scan and organize everything automatically!"
            echo ""
            echo "🎯 PRO TIPS:"
            echo "• Use proper folder structure: Movies/Movie Name (Year)/movie.mkv"
            echo "• TV shows: TV/Show Name/Season 01/S01E01 - Episode.mkv"
            echo "• Let Jellyfin download metadata - it makes everything beautiful"
            echo ""
            echo "📱 ACCESSING YOUR LIBRARY:"
            echo "• Web: http://localhost:8096"
            echo "• Mobile: Download Jellyfin app from app store"
            echo "• TV: Available on Roku, Apple TV, Android TV"
            echo ""
            echo "✅ JELLYFIN READY! Visit http://localhost:8096 to set up your server!"
            ;;
        5)
            echo "[LOG] Bill chose TagSpaces File Organizer" >> ~/data_hoarding/assistant.log
            echo "🏷️ DEPLOYING TAGSPACES - YOUR COLOR-CODED DIGITAL FILING SYSTEM!"
            echo ""
            echo "🎓 WHAT IS TAGSPACES?"
            echo "TagSpaces is a visual file organizer that lets you tag and categorize"
            echo "ANY files with colors and notes - completely offline! Think of it as:"
            echo "• A visual filing cabinet for your digital life"
            echo "• Color-coded tags that work across all file types"
            echo "• Quick preview and search for any document"
            echo "• Notes and descriptions for files and folders"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD:"
            echo "• Visual/color system aids memory and reduces chaos"
            echo "• No complex folder hierarchies to remember"
            echo "• Quick search-by-tag instead of hunting through folders"
            echo "• Offline operation = no distractions"
            echo ""
            
            # Download and install TagSpaces
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "🔧 Installing TagSpaces for Linux..."
                cd ~/Downloads
                wget https://github.com/tagspaces/tagspaces/releases/latest/download/tagspaces-linux-x64.tar.gz
                tar -xzf tagspaces-linux-x64.tar.gz
                mkdir -p ~/.local/bin
                mv tagspaces-linux-x64/tagspaces ~/.local/bin/
                echo "✅ TagSpaces installed! Run 'tagspaces' to start"
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                echo "🔧 Installing TagSpaces for macOS..."
                if command -v brew &> /dev/null; then
                    brew install --cask tagspaces
                else
                    echo "Please install from: https://www.tagspaces.org/downloads/"
                fi
            else
                echo "🔧 Please download TagSpaces from: https://www.tagspaces.org/downloads/"
            fi
            
            echo ""
            echo "🎓 TAGSPACES CRASH COURSE:"
            echo "========================="
            echo ""
            echo "📖 BASIC WORKFLOW:"
            echo "1. Open TagSpaces and point it to a folder (like ~/Documents)"
            echo "2. Right-click any file and select 'Add Tags'"
            echo "3. Create colored tags like: 🟢 Work, 🔵 Personal, 🟡 Important"
            echo "4. Use the search bar to find files by tag instantly!"
            echo ""
            echo "🎯 POWER FEATURES:"
            echo "• Thumbnail previews for images, videos, PDFs"
            echo "• Full-text search within documents"
            echo "• Geo-tagging with map view for photos"
            echo "• Custom perspectives (saved searches)"
            echo ""
            echo "💡 ADHD-FRIENDLY ORGANIZATION IDEAS:"
            echo "🟢 Project-Active (current work)"
            echo "🟡 Project-Someday (future ideas)"
            echo "🔴 Urgent (needs immediate attention)"
            echo "🔵 Reference (keep for later)"
            echo "🟣 Archive (completed/old)"
            echo ""
            echo "✅ TAGSPACES READY! Perfect for organizing downloads, documents, and media!"
            ;;
        6)
            echo "[LOG] Bill chose ExifTool Metadata Master" >> ~/data_hoarding/assistant.log
            echo "🔍 DEPLOYING EXIFTOOL - THE METADATA FORENSICS TOOL!"
            echo ""
            echo "🎓 WHAT IS EXIFTOOL?"
            echo "ExifTool is a metadata Swiss Army knife that can read and write"
            echo "information in virtually any file format. It's like having X-ray"
            echo "vision for your files - you can see and modify hidden data like:"
            echo "• Photo EXIF data (camera, location, date taken)"
            echo "• Video metadata (codec, resolution, duration)"
            echo "• Document properties (author, creation date, software)"
            echo "• Audio tags (artist, album, genre, bitrate)"
            echo ""
            echo "🧠 WHY IT'S PERFECT FOR ADHD:"
            echo "• Batch operations on thousands of files"
            echo "• Command-line automation = set it and forget it"
            echo "• Precise control without GUI distractions"
            echo "• Scriptable for repetitive tasks"
            echo ""
            
            # Install ExifTool
            if [[ "$OSTYPE" == "linux-gnu"* ]]; then
                echo "🔧 Installing ExifTool for Linux..."
                sudo apt update && sudo apt install -y libimage-exiftool-perl
            elif [[ "$OSTYPE" == "darwin"* ]]; then
                echo "🔧 Installing ExifTool for macOS..."
                if command -v brew &> /dev/null; then
                    brew install exiftool
                else
                    echo "Please install Homebrew first, then run: brew install exiftool"
                fi
            else
                echo "🔧 Please install ExifTool from: https://exiftool.org/"
            fi
            
            echo ""
            echo "🎓 EXIFTOOL CRASH COURSE:"
            echo "========================"
            echo ""
            echo "📖 BASIC COMMANDS:"
            echo "# View all metadata for a file:"
            echo "exiftool photo.jpg"
            echo ""
            echo "# View specific fields:"
            echo "exiftool -DateTimeOriginal -GPS* photo.jpg"
            echo ""
            echo "# Remove ALL metadata (privacy):"
            echo "exiftool -all= photo.jpg"
            echo ""
            echo "# Bulk rename photos by date taken:"
            echo "exiftool '-filename<DateTimeOriginal' -d '%Y-%m-%d_%H%M%S.%%e' *.jpg"
            echo ""
            echo "🎯 POWER USER EXAMPLES:"
            echo "# Organize photos into date folders:"
            echo "exiftool '-Directory<DateTimeOriginal' -d '%Y/%m' photos/"
            echo ""
            echo "# Add copyright to all images:"
            echo "exiftool -overwrite_original -Copyright='© Your Name' *.jpg"
            echo ""
            echo "# Extract GPS coordinates from photos:"
            echo "exiftool -GPS* -T -n *.jpg > gps_data.txt"
            echo ""
            echo "💡 PRIVACY TIP: Always strip metadata before sharing files online!"
            echo "Create this alias: echo \"alias stripdata='exiftool -all='\" >> ~/.bashrc"
            echo ""
            echo "🎬 MEDIA ORGANIZATION EXAMPLE:"
            echo "# Auto-organize downloads by file type and date:"
            echo "exiftool '-Directory<FileType' '-Directory<DateTimeOriginal' -d '%Y/%m' ~/Downloads/"
            echo ""
            echo "✅ EXIFTOOL INSTALLED! Try: exiftool ~/Pictures/*.jpg"
            ;;
        7)
            echo "[LOG] Bill chose Gluetun VPN Fortress" >> ~/data_hoarding/assistant.log
            echo "🔒 DEPLOYING GLUETUN VPN FORTRESS - BULLETPROOF PROTECTION!"
            echo ""
            echo "🎓 WHAT IS GLUETUN?"
            echo "Gluetun is a VPN container that creates an impenetrable fortress"
            echo "around your downloads. Unlike regular VPN apps, it works at the"
            echo "Docker network level, meaning:"
            echo "• If VPN connection drops, downloads STOP immediately"
            echo "• No possible IP leaks - traffic can't bypass the VPN"
            echo "• Multiple apps can share the same VPN connection"
            echo "• Works with any VPN provider (NordVPN, ExpressVPN, etc.)"
            echo ""
            echo "🧠 WHY IT'S ADHD-FRIENDLY:"
            echo "• Set-and-forget protection - no manual VPN management"  
            echo "• Automatic kill switch reduces anxiety about privacy"
            echo "• Visual Docker logs show VPN status clearly"
            echo "• Works in background without interrupting workflow"
            echo ""
            
            # Check for Docker
            if ! command -v docker &> /dev/null; then
                echo "⚓ Installing Docker first..."
                curl -fsSL https://get.docker.com | sudo bash
                sudo usermod -aG docker $USER
                echo "🦜 Log out and back in for Docker permissions!"
                return 1
            fi
            
            echo "🔧 Setting up Gluetun VPN fortress..."
            mkdir -p ~/docker/vpn && cd ~/docker/vpn
            cat > docker-compose.yml << 'EOF'
version: "3"
services:
  gluetun:
    image: qmcgaw/gluetun
    container_name: gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    ports:
      - 8080:8080 # qBittorrent
    volumes:
      - ./gluetun:/gluetun
    environment:
      # CHANGE THESE FOR YOUR VPN PROVIDER:
      - VPN_SERVICE_PROVIDER=nordvpn
      - VPN_TYPE=openvpn
      - OPENVPN_USER=your_username
      - OPENVPN_PASSWORD=your_password
      # For other providers, see: https://github.com/qdm12/gluetun/wiki
    restart: unless-stopped
    
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    network_mode: "service:gluetun"  # This is the magic line!
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
      - WEBUI_PORT=8080
    volumes:
      - ./qbittorrent:/config
      - ~/Downloads:/downloads
    depends_on:
      - gluetun
    restart: unless-stopped
EOF
            
            echo ""
            echo "🎓 GLUETUN SETUP GUIDE:"
            echo "======================"
            echo ""
            echo "📖 CONFIGURATION STEPS:"
            echo "1. Edit docker-compose.yml with YOUR VPN credentials"
            echo "2. Change VPN_SERVICE_PROVIDER to your provider (nordvpn, expressvpn, etc.)"
            echo "3. Add your VPN username/password"
            echo "4. Run: docker-compose up -d"
            echo "5. Check logs: docker-compose logs gluetun"
            echo ""
            echo "🎯 SUPPORTED VPN PROVIDERS:"
            echo "• NordVPN, ExpressVPN, Surfshark, CyberGhost"
            echo "• Private Internet Access (PIA), ProtonVPN"
            echo "• Mullvad, Windscribe, and 50+ others!"
            echo "• See full list: https://github.com/qdm12/gluetun/wiki"
            echo ""
            echo "🛡️ TESTING YOUR FORTRESS:"
            echo "1. Start containers: docker-compose up -d"
            echo "2. Check your IP: docker exec gluetun wget -qO- ifconfig.me"
            echo "3. Access qBittorrent at: http://localhost:8080"
            echo "4. All downloads now go through VPN automatically!"
            echo ""
            echo "💡 PRO TIP: Gluetun logs show exactly when VPN connects/disconnects"
            echo "Use: docker-compose logs -f gluetun to watch in real-time"
            echo ""
            echo "✅ VPN FORTRESS CONFIGURED! Edit docker-compose.yml and run: docker-compose up -d"
            ;;
        8)
            echo "[LOG] Bill chose Complete Media Pipeline" >> ~/data_hoarding/assistant.log
            echo "🎯 DEPLOYING COMPLETE MEDIA PIPELINE - THE HOLY GRAIL SETUP!"
            echo ""
            echo "🎓 WHAT IS THE COMPLETE PIPELINE?"
            echo "This combines ALL the tools into one seamless, automated media"
            echo "management system. Once set up, it will:"
            echo "• Automatically find and download new episodes/movies"
            echo "• Organize everything with perfect naming and metadata"
            echo "• Stream beautifully to all your devices"
            echo "• Maintain music library with artwork and tags"
            echo "• Route everything through VPN for safety"
            echo ""
            echo "🧠 THE ULTIMATE ADHD-FRIENDLY SETUP:"
            echo "• Zero manual work after initial configuration"
            echo "• No decision fatigue - smart defaults handle everything"
            echo "• Visual dashboards for monitoring and control"
            echo "• Reduces executive function load to absolute minimum"
            echo ""
            
            echo "🚀 This will install the full *arr stack + Jellyfin + VPN protection..."
            read -p "Continue with complete pipeline setup? (y/n): " pipeline_confirm
            
            if [[ $pipeline_confirm =~ ^[Yy]$ ]]; then
                # Install Docker if needed
                if ! command -v docker &> /dev/null; then
                    echo "🔧 Installing Docker..."
                    curl -fsSL https://get.docker.com | sudo bash
                    sudo usermod -aG docker $USER
                    echo "⚠️ Please log out and back in, then rerun this option"
                    return 1
                fi
                
                echo "🏗️ Creating complete media pipeline..."
                mkdir -p ~/docker/media-pipeline && cd ~/docker/media-pipeline
                mkdir -p ~/Media/{Movies,TV,Music,Downloads}
                
                cat > docker-compose.yml << 'EOF'
version: "3.8"
services:
  # VPN Container - All traffic routes through here
  gluetun:
    image: qmcgaw/gluetun
    container_name: gluetun
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun:/dev/net/tun
    ports:
      - "8080:8080"   # qBittorrent
      - "9696:9696"   # Prowlarr
    environment:
      - VPN_SERVICE_PROVIDER=nordvpn
      - VPN_TYPE=openvpn
      - OPENVPN_USER=CHANGE_ME
      - OPENVPN_PASSWORD=CHANGE_ME
    volumes:
      - ./gluetun:/gluetun
    restart: unless-stopped

  # Download Client
  qbittorrent:
    image: lscr.io/linuxserver/qbittorrent:latest
    container_name: qbittorrent
    network_mode: "service:gluetun"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
      - WEBUI_PORT=8080
    volumes:
      - ./config/qbittorrent:/config
      - ~/Media/Downloads:/downloads
    restart: unless-stopped
    depends_on:
      - gluetun

  # Indexer Manager
  prowlarr:
    image: lscr.io/linuxserver/prowlarr:latest
    container_name: prowlarr
    network_mode: "service:gluetun"
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/prowlarr:/config
    restart: unless-stopped
    depends_on:
      - gluetun

  # TV Show Manager
  sonarr:
    image: lscr.io/linuxserver/sonarr:latest
    container_name: sonarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/sonarr:/config
      - ~/Media/TV:/tv
      - ~/Media/Downloads:/downloads
    ports:
      - "8989:8989"
    restart: unless-stopped

  # Movie Manager
  radarr:
    image: lscr.io/linuxserver/radarr:latest
    container_name: radarr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/radarr:/config
      - ~/Media/Movies:/movies
      - ~/Media/Downloads:/downloads
    ports:
      - "7878:7878"
    restart: unless-stopped

  # Media Server
  jellyfin:
    image: jellyfin/jellyfin
    container_name: jellyfin
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Chicago
    volumes:
      - ./config/jellyfin:/config
      - ./cache/jellyfin:/cache
      - ~/Media:/media:ro
    ports:
      - "8096:8096"
    restart: unless-stopped
EOF
                
                echo "🔧 Starting complete media pipeline..."
                docker-compose up -d
                
                echo ""
                echo "🎉 COMPLETE PIPELINE DEPLOYED!"
                echo "============================="
                echo ""
                echo "🎯 YOUR DASHBOARD URLS:"
                echo "• 🍿 Jellyfin (Your Netflix): http://localhost:8096"
                echo "• 📺 Sonarr (TV Management): http://localhost:8989"
                echo "• 🎬 Radarr (Movie Management): http://localhost:7878"
                echo "• 🔍 Prowlarr (Indexer Setup): http://localhost:9696"
                echo "• ⬇️  qBittorrent (Downloads): http://localhost:8080"
                echo ""
                echo "📖 NEXT STEPS:"
                echo "1. Edit docker-compose.yml with your VPN credentials"
                echo "2. Restart: docker-compose down && docker-compose up -d"
                echo "3. Configure Prowlarr with your indexers"
                echo "4. Set up Sonarr/Radarr to use qBittorrent and Prowlarr"
                echo "5. Add your first movie/show requests!"
                echo ""
                echo "🎓 Full setup guide: https://wiki.servarr.com/"
                echo ""
                echo "🎊 CONGRATULATIONS! You now have a professional media server!"
            else
                echo "Pipeline setup cancelled."
            fi
            ;;
        9)
            echo "[LOG] Bill chose Current Setup Enhancement" >> ~/data_hoarding/assistant.log
            echo "🔍 ENHANCING YOUR CURRENT SETUP..."
            echo ""
            echo "🎓 CURRENT SETUP ANALYSIS:"
            echo "Let me check what you already have and suggest improvements..."
            echo ""
            
            # Source the non-interactive data hoarding module
            SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
            if [[ -f "$SOURCE_DIR/data_hoarding.sh" ]]; then
                source "$SOURCE_DIR/data_hoarding.sh"
                echo "✅ Non-interactive data hoarding functions loaded!"
            fi
            
            echo "📊 AVAILABLE ENHANCEMENT FUNCTIONS:"
            echo "  - check_media_setup() - Analyze current media folders"
            echo "  - optimize_qbittorrent() - Improve torrent client settings"  
            echo "  - create_media_folders() - Set up proper folder structure"
            echo "  - setup_plex_alternatives() - Install Jellyfin/alternatives"
            echo ""
            echo "🎯 SUGGESTED UPGRADE PATH:"
            echo "1. Run check_media_setup() to see current state"
            echo "2. Install yt-dlp for downloading (option 1 in this menu)"
            echo "3. Install Beets for music organization (option 3)"
            echo "4. Set up Jellyfin for streaming (option 4)"
            echo "5. Eventually upgrade to full automation (option 8)"
            echo ""
            echo "💡 You can now use these functions directly in your terminal."
            echo "🛡️ Remember: Stay safe with VPN when torrenting!"
            ;;
        other|Other|OTHER)
            echo "[LOG] Bill requested more options from Claude Code" >> ~/data_hoarding/assistant.log
            echo "Prompting Claude Code for more alternatives..."
            ;;
        *)
            echo "No valid choice made. Nothing launched."
            ;;
    esac
    echo "\nYou can always re-run this assistant to try a different solution!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    data_hoarding_interactive
fi 