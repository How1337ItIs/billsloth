#!/bin/bash
# LLM_CAPABILITY: local_ok
# 💀 DATA CONSCIOUSNESS ABSORPTION MATRIX 💀
# Neural data vampirism and digital reality hoarding protocols

clear
echo -e "\033[38;5;196m"
cat << 'EOF'
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░  💀 DATA CONSCIOUSNESS ABSORPTION MATRIX 💀                            ░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
EOF
echo -e "\033[0m"
echo ""
echo -e "\033[38;5;51m💀 DIGITAL DATA VAMPIRE AWAKENED! 💀\033[0m"

data_consciousness_absorption_capabilities() {
    echo -e "\033[38;5;226m💀 DIGITAL REALITY ABSORPTION CAPABILITIES:\033[0m"
    echo "1. 🏴‍☠️ Neural treasure hunting with VPN reality cloaking (Totally Legal Media Acquisition)"
    echo "2. 🗺️ Private data consciousness mapping and acquisition guides"
    echo "3. 💎 Digital storage matrix analytics and monitoring"
    echo "4. 📦 Automated data consciousness organization protocols"
    echo "5. 🔍 Duplicate reality detection and cleanup algorithms"
    echo "6. 🎬 Media consciousness library management (movies, shows, music)"
    echo "7. 🗜️ Data compression and backup preservation rituals"
    echo "8. ⚓ Remote data vampire (seedbox) consciousness management"
}

install_data_vampire_consciousness_suite() {
    echo -e "\033[38;5;129m💀 [*] Installing neural data vampire consciousness tools...\033[0m"
    
    # Torrent clients
    sudo apt install -y \
        qbittorrent \
        transmission-cli \
        transmission-daemon \
        deluge \
        rtorrent \
        aria2
    
    # File management tools
    sudo apt install -y \
        ncdu \
        duc \
        baobab \
        filelight \
        fdupes \
        rmlint \
        ranger \
        mc \
        tree
    
    # Media tools
    sudo apt install -y \
        mediainfo \
        ffmpeg \
        exiftool \
        mkvtoolnix \
        handbrake-cli
    
    # Archive tools
    sudo apt install -y \
        p7zip-full \
        unrar \
        zip \
        unzip \
        tar \
        gzip
    
    echo "[✓] Data hoarding toolkit installed"
}

setup_safe_torrenting() {
    echo "[*] Setting up safe torrenting environment..."
    
    # Create torrenting directory structure
    mkdir -p ~/Torrents/{Watch,Downloading,Complete,Seeds,Archive,Private,Public}
    
    # qBittorrent configuration for safety
    mkdir -p ~/.config/qBittorrent
    cat > ~/.config/qBittorrent/qBittorrent.conf << 'EOF'
[Preferences]
# Safety and privacy settings
Connection\GlobalDLLimit=0
Connection\GlobalUPLimit=1000
Connection\PortRangeMin=49152
Connection\Interface=tun0
Connection\InterfaceName=VPN Interface
Downloads\SavePath=/home/$USER/Torrents/Downloading/
Downloads\FinishedTorrentExportDir=/home/$USER/Torrents/Complete/
General\UseRandomPort=true
WebUI\Enabled=true
WebUI\Port=8080

# Privacy settings
Advanced\AnnounceToAllTrackers=true
Advanced\AnonymousMode=true
BitTorrent\DHT=false
BitTorrent\LSD=false
BitTorrent\PeX=false
BitTorrent\Encryption=2
BitTorrent\MaxConnections=200
BitTorrent\MaxUploads=20
EOF
    
    echo "[✓] Safe torrenting environment configured"
}

create_vpn_safety_system() {
    echo "[*] Creating VPN safety system..."
    
    # VPN kill switch for torrenting
    cat > ~/bin/torrent-killswitch << 'EOF'
#!/bin/bash
echo "🛡️ Torrent Kill Switch"
echo "This will block all torrenting if VPN disconnects"

# Check if VPN is active
check_vpn() {
    if ip addr | grep -q "tun\|wg"; then
        return 0  # VPN active
    else
        return 1  # VPN down
    fi
}

# Kill switch activation
if ! check_vpn; then
    echo "❌ VPN not detected! Activating kill switch..."
    pkill qbittorrent
    pkill transmission
    pkill deluge
    sudo iptables -A OUTPUT -p tcp --dport 6881:6999 -j DROP
    notify-send "TORRENT KILL SWITCH" "VPN down - all torrenting stopped!"
else
    echo "✅ VPN active - torrenting safe"
    # Allow torrent traffic
    sudo iptables -D OUTPUT -p tcp --dport 6881:6999 -j DROP 2>/dev/null
fi
EOF
    chmod +x ~/bin/torrent-killswitch
    
    # VPN checker for Bill
    cat > ~/bin/vpn-check << 'EOF'
#!/bin/bash
echo "🔒 VPN Status Check"
echo "=================="

if ip addr | grep -q "tun\|wg"; then
    echo "✅ VPN: CONNECTED"
    echo "🌐 External IP: $(curl -s ifconfig.me 2>/dev/null || echo 'Unable to check')"
    echo "🛡️ Safe to torrent: YES"
    
    # Show VPN interface details
    vpn_interface=$(ip addr | grep -E "tun|wg" | head -1 | awk '{print $2}' | sed 's/://')
    if [ ! -z "$vpn_interface" ]; then
        echo "📡 VPN Interface: $vpn_interface"
    fi
else
    echo "❌ VPN: DISCONNECTED"
    echo "⚠️  Safe to torrent: NO"
    echo "🚫 Start VPN before torrenting!"
fi

echo ""
echo "🏴‍☠️ Active torrent processes:"
pgrep -l "qbittorrent\|transmission\|deluge" || echo "None running"
EOF
    chmod +x ~/bin/vpn-check
    
    echo "[✓] VPN safety system created"
    random_athf_easter_egg
}

create_private_tracker_guide() {
    echo "[*] Creating private tracker guide and management..."
    
    mkdir -p ~/Torrents/PrivateTrackers/{Guides,Configs,Stats}
    
    cat > ~/Torrents/PrivateTrackers/Guides/getting-started.md << 'EOF'
# 🏴‍☠️ Private Tracker Guide for Data Hoarders

## Why Private Trackers?
- **Quality Control**: Curated, high-quality content
- **Security**: No random peers, trusted community
- **Speed**: Better seeds and faster downloads
- **Retention**: Long-term availability
- **Community**: Expert knowledge and recommendations

## Top Private Trackers by Category

### 🎬 Movies & TV
- **PTP (PassThePopcorn)** - Movies (hard to get in)
- **BTN (BroadcasTheNet)** - TV Shows (invite only)
- **HDB (HDBits)** - HD Movies/TV (very exclusive)
- **TL (TorrentLeech)** - General content (easier entry)

### 🎵 Music
- **RED (Redacted)** - FLAC paradise (interview to join)
- **OPS (Orpheus)** - Alternative to RED
- **APL (Apollo)** - Another good music tracker

### 📚 Books & Learning
- **MAM (MyAnonamouse)** - Books/Audiobooks (interview)
- **Bibliotik** - E-books (very hard to get)

### 🎮 Games
- **GGn (GazelleGames)** - All gaming content
- **UGC (Underground Gamer)** - Classic games

### 🌸 Anime/Asian Content
- **AnimeBytes (AB)** - Holy grail of anime
- **BakaBT** - Curated anime/manga (open signups sometimes)
- **Nyaa.si** - Public but reliable (use VPN!)

## Getting Into Private Trackers

### Method 1: Interviews (Recommended)
1. **RED & MAM** have IRC interviews
2. Study the interview prep guides
3. Learn about audio formats (RED) or reading habits (MAM)
4. Join their IRC channels and request interview

### Method 2: Build Reputation
1. Start with easier trackers (TL, IPT)
2. Build good ratio and stats
3. Get Power User status
4. Access recruitment forums
5. Apply for invites to better trackers

### Method 3: Open Signups
1. Follow /r/OpenSignups on Reddit
2. Check tracker websites directly
3. Sign up immediately when open
4. Usually during holidays or special events

## Essential Private Tracker Rules

### The Golden Rules
1. **NEVER sell/trade invites** - Instant permanent ban
2. **Maintain ratio** - Seed everything you download
3. **Read the rules** - Every tracker is different
4. **Use same username** - Build reputation across trackers
5. **Don't cheat** - They have sophisticated detection

### Ratio Management
- **Start small** - Download popular, small files first
- **Seed forever** - Never stop seeding
- **Use freeleech** - Download during free events
- **Cross-seed** - Same content across multiple trackers
- **Bonus points** - Many trackers have point systems

## Safety Protocol for Private Trackers

### VPN Usage
- **Public trackers**: ALWAYS use VPN
- **Private trackers**: Check rules first!
- Many private trackers BAN VPN usage
- Use raw connection for most private trackers
- Some allow VPN if you notify them first

### Security Best Practices
1. **Separate email** for tracker accounts
2. **Strong unique passwords** (use password manager)
3. **2FA when available**
4. **Don't use real name** in username
5. **Regular password changes**

## Seedbox Strategy

### Why Use a Seedbox?
- **Build ratio quickly** on private trackers
- **24/7 seeding** even when home PC is off
- **Fast upload speeds** help with ratio
- **No home bandwidth usage**
- **Some trackers prefer/require seedboxes**

### Recommended Seedbox Providers
- **Whatbox** - Good for beginners
- **Seedhost** - Affordable options
- **Ultra.cc** - Premium features
- **Feral Hosting** - UK-based, good speeds

## Content Organization for Hoarders

### Directory Structure
```
~/Media/
├── Movies/
│   ├── 1080p/
│   ├── 4K/
│   └── Archives/
├── TV/
│   ├── Current/
│   ├── Complete/
│   └── Archives/
├── Music/
│   ├── FLAC/
│   ├── MP3/
│   └── Vinyl_Rips/
├── Books/
├── Games/
└── Software/
```

### Naming Conventions
- **Movies**: `Movie.Name.Year.Resolution.Source.Codec-Group`
- **TV**: `Show.Name.SxxExx.Episode.Title.Resolution.Source.Codec-Group`
- **Music**: `Artist - Album (Year) [Format]`

## Tracker-Specific Tips

### RED (Music)
- Learn about audio formats (FLAC, 320, V0, V2)
- Upload new releases for buffer
- Use Redacted Interview Prep guide
- Never transcode lossy to lossly

### MAM (Books)
- Be active in forums
- Seed everything forever
- Upload audiobooks for good ratio
- Participate in community events

### Private Movie Trackers
- Focus on quality over quantity
- Seed popular movies longer
- Upload missing content if you can
- Participate in site events

## Red Flags to Avoid
- Ratio requirements you can't meet
- Sites asking for payment for invites
- Trackers with no rules or moderation
- Sites that seem too good to be true
- Trackers allowing public registration always

## Building Your Tracker Portfolio
1. Start with MAM or RED (interview)
2. Get established with good ratio
3. Move to TL or IPT for general content
4. Build reputation across 2-3 trackers
5. Apply for specialty trackers in your interests
6. Eventually target top-tier trackers

Remember: Private trackers are communities. Be respectful, follow rules, contribute when possible, and enjoy the high-quality content!
EOF

    # Tracker management script
    cat > ~/bin/tracker-manager << 'EOF'
#!/bin/bash
echo "🏴‍☠️ Private Tracker Manager"
echo "============================"
echo ""
echo "📊 Tracker Management:"
echo "1) Check ratio status"
echo "2) View tracker guides"
echo "3) Log tracker activity"
echo "4) Set ratio goals"
echo "5) Tracker safety check"
echo ""
read -p "Select option: " option

case $option in
    1)
        echo "📈 Ratio Status Check"
        echo "Add your tracker ratios here:"
        if [ -f ~/Torrents/PrivateTrackers/Stats/ratios.txt ]; then
            cat ~/Torrents/PrivateTrackers/Stats/ratios.txt
        else
            echo "No ratio data yet - add manually to ~/Torrents/PrivateTrackers/Stats/ratios.txt"
        fi
        ;;
    2)
        echo "📚 Opening tracker guides..."
        cat ~/Torrents/PrivateTrackers/Guides/getting-started.md | less
        ;;
    3)
        echo "📝 Log tracker activity"
        echo "Enter activity:"
        read activity
        echo "$(date): $activity" >> ~/Torrents/PrivateTrackers/activity.log
        ;;
    4)
        echo "🎯 Set ratio goals"
        echo "Tracker name:"
        read tracker
        echo "Current ratio:"
        read current
        echo "Goal ratio:"
        read goal
        echo "$tracker: Current $current, Goal $goal" >> ~/Torrents/PrivateTrackers/Stats/goals.txt
        ;;
    5)
        echo "🛡️ Tracker Safety Check"
        ~/bin/vpn-check
        echo ""
        echo "🔍 Remember:"
        echo "• Most private trackers BAN VPN use"
        echo "• Use raw connection for private trackers"
        echo "• Only use VPN for public trackers"
        ;;
esac
EOF
    chmod +x ~/bin/tracker-manager
    
    echo "[✓] Private tracker guide and manager created"
}

create_disk_analytics_tools() {
    echo "[*] Setting up disk analytics and monitoring..."
    
    cat > ~/bin/disk-analyzer << 'EOF'
#!/bin/bash
echo "💾 Disk Space Analytics"
echo "======================"
echo ""
echo "📊 Analysis Tools:"
echo "1) Overall disk usage summary"
echo "2) Directory size analysis (ncdu)"
echo "3) Visual disk usage (baobab)"
echo "4) Large file finder"
echo "5) Duplicate file scanner"
echo "6) Media file analysis"
echo "7) Cleanup recommendations"
echo ""
read -p "Select tool: " tool

case $tool in
    1)
        echo "💽 Disk Usage Summary:"
        df -h
        echo ""
        echo "🏠 Home directory usage:"
        du -sh ~/* 2>/dev/null | sort -hr | head -10
        ;;
    2)
        echo "📂 Interactive directory analysis..."
        if command -v ncdu &> /dev/null; then
            ncdu ~
        else
            echo "Installing ncdu..."
            sudo apt install -y ncdu && ncdu ~
        fi
        ;;
    3)
        echo "🎯 Visual disk usage analyzer..."
        if command -v baobab &> /dev/null; then
            baobab &
        else
            echo "Installing baobab..."
            sudo apt install -y baobab && baobab &
        fi
        ;;
    4)
        echo "🔍 Finding large files (>1GB)..."
        find ~ -type f -size +1G -exec ls -lh {} \; 2>/dev/null | sort -k5 -hr | head -20
        ;;
    5)
        echo "👥 Scanning for duplicate files..."
        if command -v fdupes &> /dev/null; then
            fdupes -r ~/Downloads ~/Documents | head -50
        else
            echo "Installing fdupes..."
            sudo apt install -y fdupes && fdupes -r ~/Downloads ~/Documents
        fi
        ;;
    6)
        echo "🎬 Media file analysis..."
        echo "Large video files:"
        find ~ -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" | xargs ls -lh 2>/dev/null | sort -k5 -hr | head -10
        echo ""
        echo "Audio collection size:"
        du -sh ~/Music 2>/dev/null || echo "No ~/Music directory"
        ;;
    7)
        echo "🧹 Cleanup Recommendations:"
        echo "• Browser cache: ~/.cache/"
        echo "• Thumbnail cache: ~/.cache/thumbnails/"
        echo "• Trash: ~/.local/share/Trash/"
        echo "• Old downloads: ~/Downloads/ (files older than 30 days)"
        echo "• System logs: /var/log/ (requires sudo)"
        echo ""
        echo "Run cleanup? (y/n)"
        read cleanup_confirm
        if [[ $cleanup_confirm == "y" ]]; then
            echo "Cleaning up..."
            rm -rf ~/.cache/thumbnails/*
            find ~/Downloads -type f -mtime +30 -exec rm {} \; 2>/dev/null
            echo "Basic cleanup complete!"
        fi
        ;;
esac
EOF
    chmod +x ~/bin/disk-analyzer
    
    echo "[✓] Disk analytics tools created"
}

create_file_organization_system() {
    echo "[*] Setting up automated file organization..."
    
    cat > ~/bin/file-organizer << 'EOF'
#!/bin/bash
echo "📁 File Organization System"
echo "=========================="
echo ""
echo "🗂️ Organization Tools:"
echo "1) Auto-organize Downloads"
echo "2) Organize media files"
echo "3) Create directory structure"
echo "4) Sort files by type"
echo "5) Archive old files"
echo "6) Compress large directories"
echo ""
read -p "Select tool: " tool

case $tool in
    1)
        echo "📥 Auto-organizing Downloads folder..."
        cd ~/Downloads || exit
        
        # Create organization folders
        mkdir -p {Images,Videos,Audio,Documents,Archives,Software,Torrents}
        
        # Sort files by extension
        mv *.{jpg,jpeg,png,gif,bmp,svg} Images/ 2>/dev/null
        mv *.{mp4,mkv,avi,mov,wmv,flv,webm} Videos/ 2>/dev/null
        mv *.{mp3,flac,wav,aac,ogg,m4a} Audio/ 2>/dev/null
        mv *.{pdf,doc,docx,txt,odt,rtf} Documents/ 2>/dev/null
        mv *.{zip,rar,7z,tar,gz,bz2} Archives/ 2>/dev/null
        mv *.{deb,rpm,exe,msi,dmg,pkg} Software/ 2>/dev/null
        mv *.{torrent} Torrents/ 2>/dev/null
        
        echo "✅ Downloads organized!"
        ;;
    2)
        echo "🎬 Organizing media files..."
        
        # Create media structure
        mkdir -p ~/Media/{Movies,TV,Music,Books,Games}
        
        echo "Move video files to Movies/TV? (y/n)"
        read move_media
        if [[ $move_media == "y" ]]; then
            find ~/Downloads -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" | while read file; do
                echo "Move $file to Movies? (y/n/s for skip)"
                read -n 1 confirm
                echo
                case $confirm in
                    y) mv "$file" ~/Media/Movies/ ;;
                    n) mv "$file" ~/Media/TV/ ;;
                    s) continue ;;
                esac
            done
        fi
        ;;
    3)
        echo "🏗️ Creating standard directory structure..."
        mkdir -p ~/Media/{Movies/{1080p,4K,Archive},TV/{Current,Complete,Archive}}
        mkdir -p ~/Media/Music/{FLAC,MP3,Vinyl}
        mkdir -p ~/Media/{Books,Games,Software}
        mkdir -p ~/Torrents/{Watch,Downloading,Complete,Seeds,Archive}
        mkdir -p ~/Projects/{Code,Creative,Work}
        mkdir -p ~/Archive/{2024,2023,2022}
        echo "✅ Directory structure created!"
        ;;
    4)
        echo "📂 Sorting files by type..."
        echo "Which directory to sort?"
        read sort_dir
        if [ -d "$sort_dir" ]; then
            cd "$sort_dir" || exit
            for ext in jpg png mp4 mkv mp3 flac pdf txt; do
                if ls *.$ext 1> /dev/null 2>&1; then
                    mkdir -p ${ext^^}_Files
                    mv *.$ext ${ext^^}_Files/
                fi
            done
            echo "✅ Files sorted by type in $sort_dir"
        else
            echo "Directory not found"
        fi
        ;;
    5)
        echo "📦 Archiving old files..."
        echo "Archive files older than how many days?"
        read days
        archive_date=$(date -d "$days days ago" +%Y%m%d)
        mkdir -p ~/Archive/auto-archive-$archive_date
        
        find ~/Downloads -type f -mtime +$days -exec mv {} ~/Archive/auto-archive-$archive_date/ \; 2>/dev/null
        echo "✅ Files older than $days days archived to ~/Archive/auto-archive-$archive_date/"
        ;;
    6)
        echo "🗜️ Compressing large directories..."
        echo "Enter directory path to compress:"
        read compress_dir
        if [ -d "$compress_dir" ]; then
            dir_name=$(basename "$compress_dir")
            echo "Compressing $dir_name..."
            tar -czf "${dir_name}-$(date +%Y%m%d).tar.gz" -C "$(dirname "$compress_dir")" "$dir_name"
            echo "✅ Compressed to ${dir_name}-$(date +%Y%m%d).tar.gz"
        else
            echo "Directory not found"
        fi
        ;;
esac
EOF
    chmod +x ~/bin/file-organizer
    
    echo "[✓] File organization system created"
}

create_media_library_manager() {
    echo "[*] Setting up media library management..."
    
    cat > ~/bin/media-manager << 'EOF'
#!/bin/bash
echo "🎬 Media Library Manager"
echo "======================="
echo ""
echo "📚 Library Tools:"
echo "1) Scan media collection"
echo "2) Rename media files"
echo "3) Check media info"
echo "4) Convert media formats"
echo "5) Organize by quality"
echo "6) Create media reports"
echo ""
read -p "Select tool: " tool

case $tool in
    1)
        echo "🔍 Scanning media collection..."
        echo ""
        echo "📽️ Movies found:"
        find ~/Media/Movies -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" 2>/dev/null | wc -l
        echo ""
        echo "📺 TV episodes found:"
        find ~/Media/TV -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" 2>/dev/null | wc -l
        echo ""
        echo "🎵 Music files found:"
        find ~/Media/Music -name "*.flac" -o -name "*.mp3" -o -name "*.m4a" 2>/dev/null | wc -l
        echo ""
        echo "💾 Total media size:"
        du -sh ~/Media 2>/dev/null || echo "No media directory found"
        ;;
    2)
        echo "✏️ Media file renaming tool"
        echo "This would integrate with tools like FileBot (recommended)."
        echo "For now, manual renaming recommended (LEGACY)."
        echo "Standard format: Movie.Name.Year.1080p.BluRay.x264-GROUP"
        ;;
    3)
        echo "ℹ️ Media info checker"
        echo "Enter path to media file:"
        read media_file
        if [ -f "$media_file" ]; then
            mediainfo "$media_file" 2>/dev/null || echo "Install mediainfo: sudo apt install mediainfo"
        else
            echo "File not found"
        fi
        ;;
    4)
        echo "🔄 Media format conversion"
        echo "Enter input file:"
        read input_file
        if [ -f "$input_file" ]; then
            echo "Convert to (mp4/mkv/avi):"
            read output_format
            output_file="${input_file%.*}.$output_format"
            echo "Converting with ffmpeg..."
            ffmpeg -i "$input_file" "$output_file"
        else
            echo "File not found"
        fi
        ;;
    5)
        echo "📊 Organizing by quality..."
        cd ~/Media/Movies || exit
        mkdir -p {720p,1080p,4K,Other}
        
        # Move files based on resolution in filename
        mv *720p* 720p/ 2>/dev/null
        mv *1080p* 1080p/ 2>/dev/null
        mv *2160p* 4K/ 2>/dev/null
        mv *4K* 4K/ 2>/dev/null
        
        echo "✅ Movies organized by quality"
        ;;
    6)
        echo "📋 Creating media reports..."
        {
            echo "# Media Library Report - $(date)"
            echo ""
            echo "## Collection Size"
            echo "Total: $(du -sh ~/Media 2>/dev/null | cut -f1)"
            echo ""
            echo "## File Counts"
            echo "Movies: $(find ~/Media/Movies -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" 2>/dev/null | wc -l)"
            echo "TV Episodes: $(find ~/Media/TV -name "*.mkv" -o -name "*.mp4" -o -name "*.avi" 2>/dev/null | wc -l)"
            echo "Music Files: $(find ~/Media/Music -name "*.flac" -o -name "*.mp3" 2>/dev/null | wc -l)"
            echo ""
            echo "## Largest Files"
            find ~/Media -type f -size +2G -exec ls -lh {} \; 2>/dev/null | head -10
        } > ~/Media/library-report-$(date +%Y%m%d).md
        
        echo "✅ Report saved to ~/Media/library-report-$(date +%Y%m%d).md"
        ;;
esac
EOF
    chmod +x ~/bin/media-manager
    
    echo "[✓] Media library manager created"
}

create_data_hoarding_dashboard() {
    echo "[*] Creating data hoarding dashboard..."
    
    cat > ~/bin/data-dashboard << 'EOF'
#!/bin/bash
clear
echo "🏴‍☠️ DIGITAL TREASURE COMMAND CENTER"
echo "It is I, the wwwyzzerdd of data hoarding!"
echo "====================================="
echo ""
echo "💾 Storage: $(df -h ~ | awk 'NR==2{print $3 "/" $2 " (" $5 " used)"}')"
echo "📊 Today: $(date '+%A, %B %d, %Y')"
echo ""

# VPN Status
if ip addr | grep -q "tun\|wg"; then
    echo "🛡️ VPN: ✅ CONNECTED (Safe to torrent)"
else
    echo "🛡️ VPN: ❌ DISCONNECTED (NOT safe for public torrents)"
fi

echo ""
echo "🏴‍☠️ DATA HOARDING TOOLS:"
echo "1) VPN & torrent safety check"
echo "2) Private tracker manager"
echo "3) Disk space analysis"
echo "4) File organization system"
echo "5) Media library manager"
echo "6) Archive & compression tools"
echo "7) Seedbox management"
echo "8) Download queue manager"
echo "9) Open torrent clients"
echo "0) Exit"
echo ""
read -p "Choose tool: " choice

case $choice in
    1) ~/bin/vpn-check && ~/bin/torrent-killswitch ;;
    2) ~/bin/tracker-manager ;;
    3) ~/bin/disk-analyzer ;;
    4) ~/bin/file-organizer ;;
    5) ~/bin/media-manager ;;
    6) ~/bin/archive-tools ;;
    7) ~/bin/seedbox-manager ;;
    8) ~/bin/download-queue ;;
    9)
        echo "🚀 Opening torrent clients..."
        if ip addr | grep -q "tun\|wg"; then
            qbittorrent &
            echo "✅ qBittorrent launched with VPN protection"
        else
            echo "⚠️ VPN not detected! Start VPN first or use for private trackers only"
            echo "Continue anyway? (y/n)"
            read continue_anyway
            if [[ $continue_anyway == "y" ]]; then
                qbittorrent &
            fi
        fi
        ;;
    0) exit ;;
esac
EOF
    chmod +x ~/bin/data-dashboard
    
    echo "[✓] Data hoarding dashboard created"
    random_athf_easter_egg
}

create_archive_tools() {
    echo "[*] Setting up archive and compression tools..."
    
    cat > ~/bin/archive-tools << 'EOF'
#!/bin/bash
echo "📦 Archive & Compression Tools"
echo "=============================="
echo ""
echo "🗜️ Archive Operations:"
echo "1) Create compressed archive"
echo "2) Extract archive"
echo "3) Archive old directories"
echo "4) Backup important data"
echo "5) Split large archives"
echo "6) Archive integrity check"
echo ""
read -p "Select operation: " operation

case $operation in
    1)
        echo "📁 Create compressed archive"
        echo "Directory to archive:"
        read archive_dir
        if [ -d "$archive_dir" ]; then
            dir_name=$(basename "$archive_dir")
            echo "Archive format (tar.gz/tar.bz2/7z):"
            read format
            case $format in
                tar.gz) tar -czf "${dir_name}-$(date +%Y%m%d).tar.gz" -C "$(dirname "$archive_dir")" "$dir_name" ;;
                tar.bz2) tar -cjf "${dir_name}-$(date +%Y%m%d).tar.bz2" -C "$(dirname "$archive_dir")" "$dir_name" ;;
                7z) 7z a "${dir_name}-$(date +%Y%m%d).7z" "$archive_dir" ;;
            esac
            echo "✅ Archive created!"
        fi
        ;;
    2)
        echo "📂 Extract archive"
        echo "Archive file path:"
        read archive_file
        if [ -f "$archive_file" ]; then
            case "$archive_file" in
                *.tar.gz) tar -xzf "$archive_file" ;;
                *.tar.bz2) tar -xjf "$archive_file" ;;
                *.zip) unzip "$archive_file" ;;
                *.7z) 7z x "$archive_file" ;;
                *.rar) unrar x "$archive_file" ;;
                *) echo "Unsupported format" ;;
            esac
        fi
        ;;
    3)
        echo "🗂️ Archive old directories"
        echo "Archive directories older than how many days?"
        read days
        mkdir -p ~/Archive/$(date +%Y)
        find ~ -maxdepth 2 -type d -mtime +$days -exec tar -czf ~/Archive/$(date +%Y)/{}-$(date +%Y%m%d).tar.gz {} \; 2>/dev/null
        echo "✅ Old directories archived to ~/Archive/$(date +%Y)/"
        ;;
    4)
        echo "💾 Backup important data"
        important_dirs=(
            "~/Documents"
            "~/Pictures" 
            "~/Projects"
            "~/VacationRental"
            "~/EdBoiGames"
        )
        
        backup_dir="~/Backups/backup-$(date +%Y%m%d)"
        mkdir -p "$backup_dir"
        
        for dir in "${important_dirs[@]}"; do
            if [ -d "$dir" ]; then
                echo "Backing up $dir..."
                cp -r "$dir" "$backup_dir/"
            fi
        done
        
        echo "Creating compressed backup..."
        tar -czf "backup-$(date +%Y%m%d).tar.gz" -C ~/Backups "backup-$(date +%Y%m%d)"
        echo "✅ Backup created: backup-$(date +%Y%m%d).tar.gz"
        ;;
    5)
        echo "✂️ Split large archive"
        echo "Archive file to split:"
        read large_file
        echo "Split size (e.g., 100M, 1G):"
        read split_size
        split -b "$split_size" "$large_file" "${large_file}.part"
        echo "✅ Archive split into parts"
        ;;
    6)
        echo "🔍 Archive integrity check"
        echo "Archive file to check:"
        read check_file
        case "$check_file" in
            *.tar.gz) tar -tzf "$check_file" > /dev/null && echo "✅ Archive OK" || echo "❌ Archive corrupted" ;;
            *.zip) unzip -t "$check_file" > /dev/null && echo "✅ Archive OK" || echo "❌ Archive corrupted" ;;
            *.7z) 7z t "$check_file" > /dev/null && echo "✅ Archive OK" || echo "❌ Archive corrupted" ;;
        esac
        ;;
esac
EOF
    chmod +x ~/bin/archive-tools
    
    echo "[✓] Archive tools created"
}

check_data_hoarding_setup() {
    echo "[*] Data hoarding setup verification:"
    
    # Check torrenting tools
    torrent_tools=("qbittorrent" "transmission-cli" "aria2c")
    for tool in "${torrent_tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo "✓ $tool: Installed"
        else
            echo "✗ $tool: Not installed"
        fi
    done
    
    # Check file management tools
    file_tools=("ncdu" "fdupes" "mediainfo" "7z")
    for tool in "${file_tools[@]}"; do
        if command -v $tool &> /dev/null; then
            echo "✓ $tool: Installed"
        else
            echo "✗ $tool: Not installed"
        fi
    done
    
    # Check scripts
    scripts=("data-dashboard" "vpn-check" "tracker-manager" "disk-analyzer" "file-organizer")
    for script in "${scripts[@]}"; do
        if [ -f ~/bin/$script ]; then
            echo "✓ $script: Ready"
        else
            echo "✗ $script: Missing"
        fi
    done
    
    # Check directory structure
    if [ -d ~/Torrents ]; then
        echo "✓ Torrents workspace: $(find ~/Torrents -type d | wc -l) directories"
    else
        echo "✗ Torrents workspace: Not created"
    fi
}

# === MEDIA RENAMING & ORGANIZATION ===
# RECOMMENDATION: Integrate with FileBot (https://www.filebot.net/) or similar mature tools for automated media renaming and organization.
# TODO: Automate this step. Current manual steps are legacy and should be replaced with direct FileBot integration.

# === SEEDBOX MANAGEMENT TOOLS ===
create_seedbox_manager() {
    echo "[*] Setting up seedbox management tools..."
    
    cat > ~/bin/seedbox-manager << 'EOF'
#!/bin/bash
echo "📡 Seedbox Management Center"
echo "==========================="
echo ""
echo "🚀 Seedbox Operations:"
echo "1) Connect to seedbox (SSH)"
echo "2) Upload torrents to seedbox"
echo "3) Download completed files"
echo "4) Check seedbox status"
echo "5) Sync seedbox to local"
echo "6) Configure seedbox settings"
echo ""
read -p "Select operation: " operation

case $operation in
    1)
        echo "🔐 SSH Connection to Seedbox"
        echo "Enter seedbox details:"
        read -p "Username: " sb_user
        read -p "Hostname/IP: " sb_host
        read -p "Port (default 22): " sb_port
        sb_port=${sb_port:-22}
        
        echo "Connecting to $sb_user@$sb_host:$sb_port..."
        ssh -p $sb_port $sb_user@$sb_host
        ;;
    2)
        echo "📤 Upload Torrents to Seedbox"
        echo "Enter torrent file path:"
        read torrent_file
        if [ -f "$torrent_file" ]; then
            echo "Enter seedbox details:"
            read -p "Username@host: " sb_connection
            read -p "Remote path: " remote_path
            scp "$torrent_file" "$sb_connection:$remote_path"
            echo "✅ Torrent uploaded to seedbox"
        else
            echo "❌ Torrent file not found"
        fi
        ;;
    3)
        echo "📥 Download Completed Files"
        echo "Enter seedbox details:"
        read -p "Username@host: " sb_connection
        read -p "Remote completed path: " remote_complete
        read -p "Local download path: " local_path
        
        echo "Downloading completed files..."
        rsync -avz --progress "$sb_connection:$remote_complete/" "$local_path/"
        echo "✅ Download complete"
        ;;
    4)
        echo "📊 Seedbox Status Check"
        echo "Enter seedbox SSH details:"
        read -p "Username@host: " sb_connection
        
        ssh $sb_connection << 'REMOTE_SCRIPT'
echo "💾 Disk Usage:"
df -h
echo ""
echo "📡 Active Torrents:"
ps aux | grep -E "rtorrent|deluge|transmission" | grep -v grep
echo ""
echo "🌐 Network Usage:"
vnstat -d 2>/dev/null || echo "vnstat not available"
REMOTE_SCRIPT
        ;;
    5)
        echo "🔄 Seedbox Sync Setup"
        cat > ~/bin/seedbox-sync << 'SYNC_EOF'
#!/bin/bash
# Automated seedbox sync script
SEEDBOX_USER="your-username"
SEEDBOX_HOST="your-seedbox.com"
REMOTE_COMPLETE="/home/$SEEDBOX_USER/completed"
LOCAL_DOWNLOAD="$HOME/Downloads/Seedbox"

mkdir -p "$LOCAL_DOWNLOAD"

echo "🔄 Syncing from seedbox..."
rsync -avz --progress \
    --remove-source-files \
    "$SEEDBOX_USER@$SEEDBOX_HOST:$REMOTE_COMPLETE/" \
    "$LOCAL_DOWNLOAD/"

echo "✅ Sync complete"
SYNC_EOF
        chmod +x ~/bin/seedbox-sync
        echo "✅ Seedbox sync script created at ~/bin/seedbox-sync"
        echo "Edit the script with your seedbox details"
        ;;
    6)
        echo "⚙️ Seedbox Configuration"
        echo "Common seedbox configurations:"
        echo ""
        echo "For rtorrent (.rtorrent.rc):"
        echo "directory = /home/user/downloads"
        echo "session = /home/user/.session"
        echo "port_range = 49164-49164"
        echo "encryption = allow_incoming,try_outgoing,enable_retry"
        echo ""
        echo "For deluge:"
        echo "Visit http://your-seedbox:8112 for web interface"
        echo ""
        echo "For transmission:"
        echo "Visit http://your-seedbox:9091 for web interface"
        ;;
esac
EOF
    chmod +x ~/bin/seedbox-manager
    
    echo "[✓] Seedbox manager created"
}

# === DOWNLOAD QUEUE MANAGER ===
create_download_queue_manager() {
    echo "[*] Setting up download queue manager..."
    
    cat > ~/bin/download-queue << 'EOF'
#!/bin/bash
echo "📋 Download Queue Manager"
echo "========================"
echo ""
echo "📁 Queue Operations:"
echo "1) Add torrent to queue"
echo "2) View download queue"
echo "3) Start next download"
echo "4) Pause all downloads"
echo "5) Resume all downloads"
echo "6) Clear completed downloads"
echo ""
read -p "Select operation: " operation

QUEUE_DIR="$HOME/.download-queue"
mkdir -p "$QUEUE_DIR"

case $operation in
    1)
        echo "➕ Add Torrent to Queue"
        echo "Enter torrent file path or magnet link:"
        read torrent_input
        
        if [[ $torrent_input == magnet:* ]]; then
            echo "$torrent_input" >> "$QUEUE_DIR/magnet_queue.txt"
            echo "✅ Magnet link added to queue"
        elif [ -f "$torrent_input" ]; then
            cp "$torrent_input" "$QUEUE_DIR/"
            echo "✅ Torrent file added to queue"
        else
            echo "❌ Invalid input"
        fi
        ;;
    2)
        echo "📋 Download Queue Status"
        echo ""
        echo "🗂️ Torrent files in queue:"
        ls -la "$QUEUE_DIR"/*.torrent 2>/dev/null | wc -l
        echo ""
        echo "🧲 Magnet links in queue:"
        wc -l < "$QUEUE_DIR/magnet_queue.txt" 2>/dev/null || echo "0"
        echo ""
        echo "🏃 Currently downloading:"
        pgrep -l qbittorrent || echo "No active downloads"
        ;;
    3)
        echo "▶️ Starting Next Download"
        
        # Start next torrent file
        next_torrent=$(ls "$QUEUE_DIR"/*.torrent 2>/dev/null | head -1)
        if [ -f "$next_torrent" ]; then
            qbittorrent "$next_torrent" &
            mv "$next_torrent" "$QUEUE_DIR/active/"
            echo "✅ Started: $(basename "$next_torrent")"
        fi
        
        # Start next magnet link
        if [ -f "$QUEUE_DIR/magnet_queue.txt" ]; then
            next_magnet=$(head -1 "$QUEUE_DIR/magnet_queue.txt")
            if [ ! -z "$next_magnet" ]; then
                qbittorrent "$next_magnet" &
                tail -n +2 "$QUEUE_DIR/magnet_queue.txt" > "$QUEUE_DIR/magnet_queue.tmp"
                mv "$QUEUE_DIR/magnet_queue.tmp" "$QUEUE_DIR/magnet_queue.txt"
                echo "✅ Started magnet download"
            fi
        fi
        ;;
    4)
        echo "⏸️ Pausing All Downloads"
        pkill -STOP qbittorrent
        echo "✅ All downloads paused"
        ;;
    5)
        echo "▶️ Resuming All Downloads"
        pkill -CONT qbittorrent
        echo "✅ All downloads resumed"
        ;;
    6)
        echo "🧹 Clearing Completed Downloads"
        mkdir -p "$QUEUE_DIR/completed"
        mv "$QUEUE_DIR/active"/* "$QUEUE_DIR/completed/" 2>/dev/null
        echo "✅ Completed downloads moved to archive"
        ;;
esac
EOF
    chmod +x ~/bin/download-queue
    
    echo "[✓] Download queue manager created"
}

# === AUTOMATED MEDIA RENAMING & ORGANIZATION (FileBot Integration) ===
automate_media_renaming() {
    echo "[*] Automated Media Renaming & Organization (FileBot)"
    if ! command -v filebot &> /dev/null; then
        echo "[!] FileBot is not installed. Please install from https://www.filebot.net/"
        return 1
    fi
    echo "Select media type to organize:"
    echo "1) Movies"
    echo "2) TV Shows"
    echo "3) Music"
    read -p "Choice: " media_type
    case $media_type in
        1)
            read -p "Enter path to Movies folder: " movies_path
            filebot -rename "$movies_path" --db TheMovieDB --format "{n} ({y})/{n} ({y})"
            ;;
        2)
            read -p "Enter path to TV Shows folder: " tv_path
            filebot -rename "$tv_path" --db TheTVDB --format "{n}/Season {s}/{n} - S{s}E{e} - {t}"
            ;;
        3)
            read -p "Enter path to Music folder: " music_path
            filebot -rename "$music_path" --db ID3 --format "{artist}/{album}/{pi.pad(2)} - {t}"
            ;;
        *)
            echo "Invalid choice."
            return 1
            ;;
    esac
    echo "[✓] Media renaming/organization complete."
    echo "$(date): FileBot media organization run for type $media_type" >> "$HOME/.billsloth-reminders/filebot_automation.log"
}

# === MAIN EXECUTION FUNCTIONS ===
run_data_hoarding_setup() {
    print_header "🏴‍☠️ COMPLETE DATA HOARDING SETUP"
    
    echo "Setting up complete data hoarding system..."
    echo ""
    
    # Install base tools
    install_pirate_treasure_hunting_suite
    echo ""
    
    # Setup safe torrenting
    setup_safe_torrenting
    echo ""
    
    # Create VPN safety
    create_vpn_safety_system
    echo ""
    
    # Create guides and management
    create_private_tracker_guide
    echo ""
    
    # Create disk analytics
    create_disk_analytics_tools
    echo ""
    
    # Create file organization
    create_file_organization_system
    echo ""
    
    # Create media library manager
    create_media_library_manager
    echo ""
    
    # Create archive tools
    create_archive_tools
    echo ""
    
    # Create seedbox manager
    create_seedbox_manager
    echo ""
    
    # Create download queue manager
    create_download_queue_manager
    echo ""
    
    # Create main dashboard
    create_data_hoarding_dashboard
    echo ""
    
    # Run setup verification
    check_data_hoarding_setup
    echo ""
    
    log_success "🏴‍☠️ Data hoarding system setup complete!"
    echo ""
    echo "🚀 Quick Start:"
    echo "  • Run: ~/bin/data-dashboard"
    echo "  • VPN check: ~/bin/vpn-check"
    echo "  • Tracker manager: ~/bin/tracker-manager"
    echo "  • File organizer: ~/bin/file-organizer"
    echo ""
    echo "⚠️  Remember: Always use VPN for public trackers!"
    echo "              Most private trackers BAN VPN usage."
}

# === DATA HOARDING INTERACTIVE MENU ===
data_hoarding_interactive() {
    while true; do
        print_header "🏴‍☠️ DATA HOARDING INTERACTIVE MENU"
        echo ""
        echo "📊 Storage: $(df -h ~ | awk 'NR==2{print $3 "/" $2 " (" $5 " used)"}')"
        
        # VPN Status
        if ip addr | grep -q "tun\|wg"; then
            echo "🛡️ VPN: ✅ CONNECTED (Safe to torrent)"
        else
            echo "🛡️ VPN: ❌ DISCONNECTED (NOT safe for public torrents)"
        fi
        echo ""
        
        echo "🏴‍☠️ SETUP & INSTALLATION:"
        echo "  1) Complete data hoarding setup"
        echo "  2) Install torrent tools only"
        echo "  3) Setup VPN safety system"
        echo ""
        
        echo "🛠️ MANAGEMENT TOOLS:"
        echo "  4) Data hoarding dashboard"
        echo "  5) VPN & torrent safety check"
        echo "  6) Private tracker manager"
        echo "  7) Disk space analyzer"
        echo "  8) File organization system"
        echo "  9) Media library manager"
        echo " 10) Archive & compression tools"
        echo ""
        
        echo "📡 ADVANCED TOOLS:"
        echo " 11) Seedbox management"
        echo " 12) Download queue manager"
        echo " 13) Setup verification"
        echo ""
        
        echo " 0) Exit data hoarding module"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select option (0-13)" 30 "0")
        
        case "$choice" in
            1) run_data_hoarding_setup ;;
            2) install_pirate_treasure_hunting_suite ;;
            3) create_vpn_safety_system ;;
            4) 
                if [ -f ~/bin/data-dashboard ]; then
                    ~/bin/data-dashboard
                else
                    log_warning "Dashboard not found. Run setup first (option 1)"
                fi
                ;;
            5)
                if [ -f ~/bin/vpn-check ]; then
                    ~/bin/vpn-check && ~/bin/torrent-killswitch
                else
                    log_warning "VPN tools not found. Run setup first (option 1)"
                fi
                ;;
            6)
                if [ -f ~/bin/tracker-manager ]; then
                    ~/bin/tracker-manager
                else
                    log_warning "Tracker manager not found. Run setup first (option 1)"
                fi
                ;;
            7)
                if [ -f ~/bin/disk-analyzer ]; then
                    ~/bin/disk-analyzer
                else
                    log_warning "Disk analyzer not found. Run setup first (option 1)"
                fi
                ;;
            8)
                if [ -f ~/bin/file-organizer ]; then
                    ~/bin/file-organizer
                else
                    log_warning "File organizer not found. Run setup first (option 1)"
                fi
                ;;
            9)
                if [ -f ~/bin/media-manager ]; then
                    ~/bin/media-manager
                else
                    log_warning "Media manager not found. Run setup first (option 1)"
                fi
                ;;
            10)
                if [ -f ~/bin/archive-tools ]; then
                    ~/bin/archive-tools
                else
                    log_warning "Archive tools not found. Run setup first (option 1)"
                fi
                ;;
            11)
                if [ -f ~/bin/seedbox-manager ]; then
                    ~/bin/seedbox-manager
                else
                    log_warning "Seedbox manager not found. Run setup first (option 1)"
                fi
                ;;
            12)
                if [ -f ~/bin/download-queue ]; then
                    ~/bin/download-queue
                else
                    log_warning "Download queue not found. Run setup first (option 1)"
                fi
                ;;
            13) check_data_hoarding_setup ;;
            0)
                log_info "Exiting data hoarding module"
                break
                ;;
            *)
                log_warning "Invalid option: $choice"
                sleep 2
                ;;
        esac
        
        if [ "$choice" != "0" ]; then
            echo ""
            read -n 1 -s -r -p "Press any key to continue..."
            echo ""
        fi
    done
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "🏴‍☠️ Data Hoarding Module - Interactive Mode"
    data_hoarding_interactive
fi