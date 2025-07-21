#!/bin/bash
# DATA HOARDING - Advanced File Management & Torrenting
# "Information wants to be free" - But organized and safe!

echo "DATA_HOARDING_MODULE_LOADED"

data_hoarding_capabilities() {
    echo "Data Hoarding & File Management Capabilities:"
    echo "1. Safe torrenting setup with VPN integration"
    echo "2. Private tracker management and guides"
    echo "3. Disk space analytics and monitoring"
    echo "4. Automated file organization systems"
    echo "5. Duplicate file detection and cleanup"
    echo "6. Media library management (movies, shows, music)"
    echo "7. Archive compression and backup strategies"
    echo "8. Seedbox integration and remote management"
}

install_torrenting_suite() {
    echo "[*] Installing torrenting and file management tools..."
    
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
    mkdir -p ~/Torrents/{
        Watch,
        Downloading,
        Complete,
        Seeds,
        Archive,
        Private,
        Public
    }
    
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
        echo "This would integrate with tools like FileBot"
        echo "For now, manual renaming recommended"
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
echo "🏴‍☠️ DATA HOARDING COMMAND CENTER"
echo "=================================="
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

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This data hoarding module should be executed by Claude Code"
    echo "Available functions: install_torrenting_suite, setup_safe_torrenting, create_vpn_safety_system, create_private_tracker_guide"
fi