#!/bin/bash
# LLM_CAPABILITY: local_ok
# Media Processing Pipeline Module
# Complete media processing and automation system for Bill Sloth

echo "🎬 MEDIA PROCESSING PIPELINE MODULE LOADED 🎬"

# Source required libraries
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/error_handling.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/notification_system.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/data_sharing.sh" 2>/dev/null || true
source "$SCRIPT_DIR/../lib/modern_cli.sh" 2>/dev/null || true

media_processing_capabilities() {
    echo "🎬 MEDIA PROCESSING PIPELINE CAPABILITIES:"
    echo "1. 📸 Automated photo/image processing and optimization"
    echo "2. 🎥 Video processing, conversion, and compression"
    echo "3. 🎵 Audio processing and enhancement"
    echo "4. 🏠 VRBO property media automation"
    echo "5. 🎮 EdBoiGames content processing"
    echo "6. 📱 Mobile-optimized media workflows"
    echo "7. 🤖 AI-powered media analysis and tagging"
    echo "8. ☁️ Cloud storage and backup automation"
}

# === INSTALLATION AND SETUP ===

install_media_processing_tools() {
    print_header "📦 INSTALLING MEDIA PROCESSING TOOLS"
    
    echo "Installing core media processing software..."
    
    # Image processing tools
    sudo apt update
    sudo apt install -y \
        imagemagick \
        gimp \
        rawtherapee \
        darktable \
        exiftool \
        jpegoptim \
        optipng \
        webp \
        graphicsmagick
    
    # Video processing tools
    sudo apt install -y \
        ffmpeg \
        handbrake-cli \
        obs-studio \
        kdenlive \
        openshot \
        mkvtoolnix \
        mediainfo \
        mp4v2-utils
    
    # Audio processing tools
    sudo apt install -y \
        audacity \
        lame \
        flac \
        sox \
        pulseaudio-utils \
        alsa-utils
    
    # Additional utilities
    sudo apt install -y \
        parallel \
        rsync \
        rclone \
        fdupes \
        jq \
        curl \
        wget
    
    # Python packages for advanced processing
    pip3 install --user \
        Pillow \
        opencv-python \
        moviepy \
        pydub \
        face_recognition \
        pytesseract
    
    log_success "Media processing tools installed!"
}

# === PHOTO/IMAGE PROCESSING ===

setup_image_processing() {
    print_header "📸 IMAGE PROCESSING SETUP"
    
    # Create image processing directory structure
    mkdir -p ~/.bill-sloth/media-processing/{images,videos,audio,processed,templates}
    mkdir -p ~/.bill-sloth/media-processing/images/{raw,processed,optimized,thumbnails,watermarked}
    
    # Create image optimization script
    cat > ~/.bill-sloth/media-processing/scripts/optimize_images.sh << 'EOF'
#!/bin/bash
echo "📸 IMAGE OPTIMIZATION PIPELINE"
echo "==============================="

INPUT_DIR="$1"
OUTPUT_DIR="$2"
QUALITY="${3:-85}"

if [ -z "$INPUT_DIR" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <input_dir> <output_dir> [quality]"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "Processing images from $INPUT_DIR..."
echo "Output directory: $OUTPUT_DIR"
echo "Quality setting: $QUALITY%"
echo ""

# Process JPEG images
find "$INPUT_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while read image; do
    filename=$(basename "$image")
    echo "Optimizing: $filename"
    
    # Optimize JPEG
    jpegoptim --max="$QUALITY" --strip-all --preserve --dest="$OUTPUT_DIR" "$image"
    
    # Create thumbnail
    convert "$image" -resize 300x300^ -gravity center -extent 300x300 "$OUTPUT_DIR/thumb_$filename"
done

# Process PNG images
find "$INPUT_DIR" -type f -iname "*.png" | while read image; do
    filename=$(basename "$image")
    echo "Optimizing: $filename"
    
    # Optimize PNG
    optipng -o2 "$image" -out "$OUTPUT_DIR/$filename"
    
    # Create thumbnail
    convert "$image" -resize 300x300^ -gravity center -extent 300x300 "$OUTPUT_DIR/thumb_$filename"
done

# Convert to WebP for web use
find "$OUTPUT_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read image; do
    filename=$(basename "$image" | sed 's/\.[^.]*$//')
    echo "Creating WebP: $filename.webp"
    cwebp -q "$QUALITY" "$image" -o "$OUTPUT_DIR/$filename.webp"
done

echo ""
echo "✅ Image optimization complete!"
echo "📊 Results:"
echo "  Input files: $(find "$INPUT_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | wc -l)"
echo "  Output files: $(find "$OUTPUT_DIR" -type f | wc -l)"
echo "  Space saved: $(du -sh "$INPUT_DIR" | cut -f1) -> $(du -sh "$OUTPUT_DIR" | cut -f1)"
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/optimize_images.sh
    
    log_success "Image processing setup complete!"
}

# VRBO property image automation
setup_vrbo_image_automation() {
    print_header "🏠 VRBO PROPERTY IMAGE AUTOMATION"
    
    mkdir -p ~/.bill-sloth/media-processing/vrbo/{listings,property-photos,guest-uploads,processed}
    
    # Create VRBO image processing script
    cat > ~/.bill-sloth/media-processing/scripts/vrbo_image_processor.sh << 'EOF'
#!/bin/bash
echo "🏠 VRBO IMAGE PROCESSOR"
echo "======================"

PROPERTY_ID="$1"
SOURCE_DIR="$2"
ACTION="${3:-process}"

if [ -z "$PROPERTY_ID" ] || [ -z "$SOURCE_DIR" ]; then
    echo "Usage: $0 <property_id> <source_dir> [action]"
    echo "Actions: process, watermark, listing, thumbnail"
    exit 1
fi

VRBO_DIR="$HOME/.bill-sloth/media-processing/vrbo"
PROPERTY_DIR="$VRBO_DIR/property-photos/$PROPERTY_ID"
PROCESSED_DIR="$PROPERTY_DIR/processed"
LISTING_DIR="$PROPERTY_DIR/listing"

mkdir -p "$PROCESSED_DIR" "$LISTING_DIR"

case "$ACTION" in
    "process")
        echo "🔄 Processing property photos for $PROPERTY_ID..."
        
        # Optimize images for web
        ~/.bill-sloth/media-processing/scripts/optimize_images.sh "$SOURCE_DIR" "$PROCESSED_DIR" 90
        
        # Create listing-ready images (1200x800)
        find "$PROCESSED_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while read image; do
            filename=$(basename "$image")
            convert "$image" -resize 1200x800^ -gravity center -extent 1200x800 "$LISTING_DIR/listing_$filename"
        done
        
        # Extract EXIF data for organization
        exiftool -csv -filename -createdate -gps* "$SOURCE_DIR"/*.jpg > "$PROPERTY_DIR/image_metadata.csv" 2>/dev/null
        
        echo "✅ Property photos processed for listing!"
        ;;
        
    "watermark")
        echo "💧 Adding watermarks to property photos..."
        
        WATERMARK_TEXT="© $(date +%Y) Property Listing"
        
        find "$SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | while read image; do
            filename=$(basename "$image")
            output_file="$PROCESSED_DIR/watermarked_$filename"
            
            convert "$image" \
                -pointsize 24 \
                -fill "rgba(255,255,255,0.7)" \
                -gravity southeast \
                -annotate +20+20 "$WATERMARK_TEXT" \
                "$output_file"
        done
        
        echo "✅ Watermarks added to all images!"
        ;;
        
    "listing")
        echo "📋 Creating VRBO listing image package..."
        
        LISTING_PACKAGE="$VRBO_DIR/listings/${PROPERTY_ID}_listing_$(date +%Y%m%d).zip"
        
        cd "$LISTING_DIR"
        zip -r "$LISTING_PACKAGE" . -x "*.DS_Store" "*.thumbs.db"
        
        echo "✅ Listing package created: $LISTING_PACKAGE"
        ;;
        
    "thumbnail")
        echo "🖼️ Generating property thumbnails..."
        
        THUMB_DIR="$PROPERTY_DIR/thumbnails"
        mkdir -p "$THUMB_DIR"
        
        # Create various thumbnail sizes
        for size in "150x150" "300x200" "600x400"; do
            size_dir="$THUMB_DIR/${size/x/_by_}"
            mkdir -p "$size_dir"
            
            find "$SOURCE_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" \) | head -5 | while read image; do
                filename=$(basename "$image")
                convert "$image" -resize "$size^" -gravity center -extent "$size" "$size_dir/$filename"
            done
        done
        
        echo "✅ Thumbnails generated for all sizes!"
        ;;
esac

# Share processed data with other modules
if command -v share_data &> /dev/null; then
    property_data='{"property_id": "'$PROPERTY_ID'", "processed_date": "'$(date -Iseconds)'", "action": "'$ACTION'"}'
    share_data "media_processing" "vrbo_automation" "property_images" "$property_data"
fi
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/vrbo_image_processor.sh
    
    log_success "VRBO image automation setup complete!"
}

# === VIDEO PROCESSING ===

setup_video_processing() {
    print_header "🎥 VIDEO PROCESSING SETUP"
    
    mkdir -p ~/.bill-sloth/media-processing/videos/{raw,processed,compressed,thumbnails,clips}
    
    # Create video processing script
    cat > ~/.bill-sloth/media-processing/scripts/process_videos.sh << 'EOF'
#!/bin/bash
echo "🎥 VIDEO PROCESSING PIPELINE"
echo "============================"

INPUT_FILE="$1"
OUTPUT_DIR="$2"
PRESET="${3:-standard}"

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <input_file> <output_dir> [preset]"
    echo "Presets: web, mobile, high-quality, compressed, edboigames"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

filename=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')

echo "Processing: $INPUT_FILE"
echo "Output: $OUTPUT_DIR"
echo "Preset: $PRESET"
echo ""

case "$PRESET" in
    "web")
        echo "🌐 Optimizing for web playback..."
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset medium -crf 23 \
            -c:a aac -b:a 128k \
            -movflags +faststart \
            -vf "scale=-2:720" \
            "$OUTPUT_DIR/${filename}_web.mp4"
        ;;
        
    "mobile")
        echo "📱 Optimizing for mobile devices..."
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset fast -crf 26 \
            -c:a aac -b:a 96k \
            -movflags +faststart \
            -vf "scale=-2:480" \
            "$OUTPUT_DIR/${filename}_mobile.mp4"
        ;;
        
    "high-quality")
        echo "🎯 High quality processing..."
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset slow -crf 18 \
            -c:a aac -b:a 192k \
            -movflags +faststart \
            "$OUTPUT_DIR/${filename}_hq.mp4"
        ;;
        
    "compressed")
        echo "🗜️ Maximum compression..."
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset veryslow -crf 28 \
            -c:a aac -b:a 64k \
            -movflags +faststart \
            -vf "scale=-2:360" \
            "$OUTPUT_DIR/${filename}_compressed.mp4"
        ;;
        
    "edboigames")
        echo "🎮 EdBoiGames content optimization..."
        # Multiple formats for different platforms
        
        # YouTube format
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset medium -crf 20 \
            -c:a aac -b:a 192k \
            -movflags +faststart \
            -vf "scale=-2:1080" \
            "$OUTPUT_DIR/${filename}_youtube.mp4"
        
        # Social media format (square)
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset medium -crf 23 \
            -c:a aac -b:a 128k \
            -movflags +faststart \
            -vf "scale=1080:1080:force_original_aspect_ratio=decrease,pad=1080:1080:(ow-iw)/2:(oh-ih)/2" \
            "$OUTPUT_DIR/${filename}_social.mp4"
        
        # Short clips (first 60 seconds)
        ffmpeg -i "$INPUT_FILE" -t 60 \
            -c:v libx264 -preset medium -crf 23 \
            -c:a aac -b:a 128k \
            -movflags +faststart \
            -vf "scale=-2:720" \
            "$OUTPUT_DIR/${filename}_clip.mp4"
        ;;
        
    "standard"|*)
        echo "⚙️ Standard processing..."
        ffmpeg -i "$INPUT_FILE" \
            -c:v libx264 -preset medium -crf 23 \
            -c:a aac -b:a 128k \
            -movflags +faststart \
            "$OUTPUT_DIR/${filename}_processed.mp4"
        ;;
esac

# Generate thumbnail
echo "🖼️ Creating video thumbnail..."
ffmpeg -i "$INPUT_FILE" -ss 00:00:05 -vframes 1 -vf "scale=-2:720" "$OUTPUT_DIR/${filename}_thumb.jpg"

# Extract video info
echo "📊 Extracting video information..."
mediainfo "$INPUT_FILE" > "$OUTPUT_DIR/${filename}_info.txt"

echo ""
echo "✅ Video processing complete!"
echo "📁 Output files in: $OUTPUT_DIR"
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/process_videos.sh
    
    log_success "Video processing setup complete!"
}

# EdBoiGames content processing
setup_edboigames_content_processing() {
    print_header "🎮 EDBOIGAMES CONTENT PROCESSING"
    
    mkdir -p ~/.bill-sloth/media-processing/edboigames/{recordings,edited,thumbnails,clips,streams}
    
    # Create EdBoiGames content automation
    cat > ~/.bill-sloth/media-processing/scripts/edboigames_content.sh << 'EOF'
#!/bin/bash
echo "🎮 EDBOIGAMES CONTENT PROCESSOR"
echo "==============================="

CONTENT_TYPE="$1"
INPUT_FILE="$2"
GAME_NAME="$3"

if [ -z "$CONTENT_TYPE" ] || [ -z "$INPUT_FILE" ]; then
    echo "Usage: $0 <content_type> <input_file> [game_name]"
    echo "Content types: gameplay, stream, review, tutorial, highlight"
    exit 1
fi

EDBOIGAMES_DIR="$HOME/.bill-sloth/media-processing/edboigames"
OUTPUT_DIR="$EDBOIGAMES_DIR/$CONTENT_TYPE"
mkdir -p "$OUTPUT_DIR"

filename=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
timestamp=$(date +%Y%m%d_%H%M%S)

case "$CONTENT_TYPE" in
    "gameplay")
        echo "🎮 Processing gameplay footage..."
        
        # Full gameplay video
        ~/.bill-sloth/media-processing/scripts/process_videos.sh "$INPUT_FILE" "$OUTPUT_DIR" "edboigames"
        
        # Create highlight reel (first and last 5 minutes)
        ffmpeg -i "$INPUT_FILE" -t 300 -c copy "$OUTPUT_DIR/${filename}_intro.mp4"
        duration=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$INPUT_FILE")
        start_time=$(echo "$duration - 300" | bc)
        ffmpeg -ss "$start_time" -i "$INPUT_FILE" -c copy "$OUTPUT_DIR/${filename}_outro.mp4"
        
        # Combine intro and outro for highlight reel
        echo "file '${filename}_intro.mp4'" > "$OUTPUT_DIR/highlight_list.txt"
        echo "file '${filename}_outro.mp4'" >> "$OUTPUT_DIR/highlight_list.txt"
        ffmpeg -f concat -safe 0 -i "$OUTPUT_DIR/highlight_list.txt" -c copy "$OUTPUT_DIR/${filename}_highlights.mp4"
        rm "$OUTPUT_DIR/highlight_list.txt"
        ;;
        
    "stream")
        echo "📺 Processing stream recording..."
        
        # Split into segments (every 30 minutes)
        ffmpeg -i "$INPUT_FILE" -c copy -map 0 -segment_time 1800 -f segment "$OUTPUT_DIR/${filename}_part%03d.mp4"
        
        # Create stream highlights (detect loud audio moments)
        ffmpeg -i "$INPUT_FILE" -af "volumedetect" -f null - 2>&1 | grep "mean_volume" > "$OUTPUT_DIR/${filename}_audio_analysis.txt"
        ;;
        
    "review")
        echo "📝 Processing game review content..."
        
        # Standard YouTube format
        ~/.bill-sloth/media-processing/scripts/process_videos.sh "$INPUT_FILE" "$OUTPUT_DIR" "edboigames"
        
        # Create teaser (first 30 seconds)
        ffmpeg -i "$INPUT_FILE" -t 30 -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k "$OUTPUT_DIR/${filename}_teaser.mp4"
        ;;
        
    "tutorial")
        echo "📚 Processing tutorial content..."
        
        # High quality for detail visibility
        ~/.bill-sloth/media-processing/scripts/process_videos.sh "$INPUT_FILE" "$OUTPUT_DIR" "high-quality"
        
        # Create chapter markers (every 5 minutes)
        duration=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$INPUT_FILE")
        chapters=$(echo "$duration / 300" | bc)
        
        for ((i=0; i<chapters; i++)); do
            start_time=$(echo "$i * 300" | bc)
            ffmpeg -ss "$start_time" -i "$INPUT_FILE" -t 1 -vf "scale=-2:720" "$OUTPUT_DIR/${filename}_chapter${i}_thumb.jpg"
        done
        ;;
        
    "highlight")
        echo "⭐ Processing highlight reel..."
        
        # Multiple format outputs
        ~/.bill-sloth/media-processing/scripts/process_videos.sh "$INPUT_FILE" "$OUTPUT_DIR" "edboigames"
        
        # Create gif for social media
        ffmpeg -i "$INPUT_FILE" -t 10 -vf "fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" "$OUTPUT_DIR/${filename}.gif"
        ;;
esac

# Generate custom thumbnail with game branding
echo "🎨 Creating branded thumbnail..."
if [ ! -z "$GAME_NAME" ]; then
    # Extract a good frame for thumbnail
    ffmpeg -i "$INPUT_FILE" -ss 00:01:00 -vframes 1 -vf "scale=1280:720" "$OUTPUT_DIR/temp_thumb.jpg"
    
    # Add game name text overlay
    convert "$OUTPUT_DIR/temp_thumb.jpg" \
        -pointsize 48 -fill white -stroke black -strokewidth 2 \
        -gravity north -annotate +0+50 "$GAME_NAME" \
        -pointsize 32 -fill yellow -stroke black -strokewidth 1 \
        -gravity south -annotate +0+50 "EdBoiGames" \
        "$OUTPUT_DIR/${filename}_branded_thumb.jpg"
    
    rm "$OUTPUT_DIR/temp_thumb.jpg"
fi

# Share content data with other modules
if command -v share_data &> /dev/null; then
    content_data='{"content_type": "'$CONTENT_TYPE'", "game": "'$GAME_NAME'", "processed_date": "'$(date -Iseconds)'", "file": "'$filename'"}'
    share_data "media_processing" "edboigames" "processed_content" "$content_data"
fi

echo ""
echo "✅ EdBoiGames content processing complete!"
echo "📁 Output files in: $OUTPUT_DIR"
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/edboigames_content.sh
    
    log_success "EdBoiGames content processing setup complete!"
}

# === AUDIO PROCESSING ===

setup_audio_processing() {
    print_header "🎵 AUDIO PROCESSING SETUP"
    
    mkdir -p ~/.bill-sloth/media-processing/audio/{raw,processed,enhanced,podcasts}
    
    # Create audio processing script
    cat > ~/.bill-sloth/media-processing/scripts/process_audio.sh << 'EOF'
#!/bin/bash
echo "🎵 AUDIO PROCESSING PIPELINE"
echo "============================"

INPUT_FILE="$1"
OUTPUT_DIR="$2"
PRESET="${3:-standard}"

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_DIR" ]; then
    echo "Usage: $0 <input_file> <output_dir> [preset]"
    echo "Presets: podcast, music, voice, compressed, enhanced"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

filename=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')

echo "Processing: $INPUT_FILE"
echo "Output: $OUTPUT_DIR"
echo "Preset: $PRESET"
echo ""

case "$PRESET" in
    "podcast")
        echo "🎙️ Podcast optimization..."
        sox "$INPUT_FILE" "$OUTPUT_DIR/${filename}_podcast.mp3" \
            trim 0 \
            highpass 80 \
            lowpass 8000 \
            compand 0.02,0.20 5:-60,-40,-10 -5 -90 0.1 \
            norm -1
        ;;
        
    "music")
        echo "🎵 Music processing..."
        sox "$INPUT_FILE" "$OUTPUT_DIR/${filename}_music.mp3" \
            norm -1 \
            reverb 20 0.8 100 0.9 0 0
        ;;
        
    "voice")
        echo "🗣️ Voice enhancement..."
        sox "$INPUT_FILE" "$OUTPUT_DIR/${filename}_voice.mp3" \
            highpass 100 \
            lowpass 3400 \
            compand 0.02,0.20 5:-60,-40,-10 -5 -90 0.1 \
            norm -3 \
            silence 1 0.1 1% -1 0.1 1%
        ;;
        
    "compressed")
        echo "🗜️ High compression..."
        ffmpeg -i "$INPUT_FILE" \
            -c:a mp3 -b:a 64k \
            "$OUTPUT_DIR/${filename}_compressed.mp3"
        ;;
        
    "enhanced")
        echo "✨ Audio enhancement..."
        sox "$INPUT_FILE" "$OUTPUT_DIR/${filename}_enhanced.mp3" \
            highpass 50 \
            compand 0.02,0.20 5:-60,-40,-10 -5 -90 0.1 \
            reverb 10 0.5 100 0.1 0 0 \
            norm -1
        ;;
        
    "standard"|*)
        echo "⚙️ Standard processing..."
        sox "$INPUT_FILE" "$OUTPUT_DIR/${filename}_processed.mp3" \
            norm -1
        ;;
esac

# Create waveform visualization
echo "📊 Generating waveform..."
sox "$INPUT_FILE" -n spectrogram -o "$OUTPUT_DIR/${filename}_waveform.png"

echo ""
echo "✅ Audio processing complete!"
echo "📁 Output files in: $OUTPUT_DIR"
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/process_audio.sh
    
    log_success "Audio processing setup complete!"
}

# === AI-POWERED MEDIA ANALYSIS ===

setup_ai_media_analysis() {
    print_header "🤖 AI MEDIA ANALYSIS SETUP"
    
    mkdir -p ~/.bill-sloth/media-processing/ai-analysis/{face-detection,object-recognition,text-extraction,content-analysis}
    
    # Create AI analysis script
    cat > ~/.bill-sloth/media-processing/scripts/ai_media_analysis.sh << 'EOF'
#!/bin/bash
echo "🤖 AI MEDIA ANALYSIS"
echo "===================="

MEDIA_FILE="$1"
ANALYSIS_TYPE="$2"

if [ -z "$MEDIA_FILE" ] || [ -z "$ANALYSIS_TYPE" ]; then
    echo "Usage: $0 <media_file> <analysis_type>"
    echo "Analysis types: faces, objects, text, content, all"
    exit 1
fi

AI_DIR="$HOME/.bill-sloth/media-processing/ai-analysis"
filename=$(basename "$MEDIA_FILE" | sed 's/\.[^.]*$//')

case "$ANALYSIS_TYPE" in
    "faces")
        echo "👤 Face detection analysis..."
        python3 << 'PYTHON_EOF'
import face_recognition
import cv2
import sys
import json
import os

media_file = sys.argv[1]
filename = sys.argv[2]
output_dir = sys.argv[3]

# Load image
image = face_recognition.load_image_file(media_file)
face_locations = face_recognition.face_locations(image)

# Save results
results = {
    "file": media_file,
    "faces_detected": len(face_locations),
    "face_locations": face_locations,
    "analysis_date": "$(date -Iseconds)"
}

with open(f"{output_dir}/{filename}_faces.json", "w") as f:
    json.dump(results, f, indent=2)

print(f"Detected {len(face_locations)} faces")
PYTHON_EOF
        ;;
        
    "objects")
        echo "🔍 Object recognition..."
        # Placeholder for object detection (requires more advanced setup)
        echo "Object recognition requires additional AI models to be installed"
        ;;
        
    "text")
        echo "📝 Text extraction (OCR)..."
        tesseract "$MEDIA_FILE" "$AI_DIR/text-extraction/${filename}_text" -l eng
        echo "Text extracted to: $AI_DIR/text-extraction/${filename}_text.txt"
        ;;
        
    "content")
        echo "📊 Content analysis..."
        # Basic image analysis
        identify -verbose "$MEDIA_FILE" > "$AI_DIR/content-analysis/${filename}_analysis.txt"
        
        # Extract EXIF data
        exiftool -json "$MEDIA_FILE" > "$AI_DIR/content-analysis/${filename}_exif.json"
        ;;
        
    "all")
        echo "🎯 Running all analysis types..."
        $0 "$MEDIA_FILE" "faces"
        $0 "$MEDIA_FILE" "text"
        $0 "$MEDIA_FILE" "content"
        ;;
esac

echo "✅ AI analysis complete!"
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/ai_media_analysis.sh
    
    log_success "AI media analysis setup complete!"
}

# === CLOUD STORAGE AUTOMATION ===

setup_cloud_storage_automation() {
    print_header "☁️ CLOUD STORAGE AUTOMATION"
    
    mkdir -p ~/.bill-sloth/media-processing/cloud/{backup,sync,downloads}
    
    # Create cloud storage script
    cat > ~/.bill-sloth/media-processing/scripts/cloud_storage.sh << 'EOF'
#!/bin/bash
echo "☁️ CLOUD STORAGE AUTOMATION"
echo "==========================="

ACTION="$1"
SOURCE="$2"
DESTINATION="$3"

if [ -z "$ACTION" ]; then
    echo "Usage: $0 <action> [source] [destination]"
    echo "Actions: backup, sync, download, upload, list"
    exit 1
fi

case "$ACTION" in
    "backup")
        echo "💾 Backing up media to cloud..."
        if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
            echo "Usage: $0 backup <local_dir> <cloud_destination>"
            exit 1
        fi
        
        # Use rclone for cloud backup (configure with rclone config first)
        rclone copy "$SOURCE" "$DESTINATION" --progress --transfers 4
        
        # Create backup manifest
        find "$SOURCE" -type f > "$HOME/.bill-sloth/media-processing/cloud/backup_manifest_$(date +%Y%m%d).txt"
        ;;
        
    "sync")
        echo "🔄 Syncing with cloud storage..."
        rclone sync "$SOURCE" "$DESTINATION" --progress
        ;;
        
    "download")
        echo "📥 Downloading from cloud..."
        rclone copy "$SOURCE" "$DESTINATION" --progress
        ;;
        
    "upload")
        echo "📤 Uploading to cloud..."
        rclone copy "$SOURCE" "$DESTINATION" --progress
        ;;
        
    "list")
        echo "📋 Listing cloud storage..."
        rclone ls "$SOURCE"
        ;;
        
    *)
        echo "Unknown action: $ACTION"
        exit 1
        ;;
esac

echo "✅ Cloud storage operation complete!"
EOF
    chmod +x ~/.bill-sloth/media-processing/scripts/cloud_storage.sh
    
    log_success "Cloud storage automation setup complete!"
}

# === MEDIA PROCESSING DASHBOARD ===

create_media_processing_dashboard() {
    print_header "📊 CREATING MEDIA PROCESSING DASHBOARD"
    
    cat > ~/.bill-sloth/media-processing/media_dashboard.sh << 'EOF'
#!/bin/bash
echo "🎬 BILL'S MEDIA PROCESSING DASHBOARD"
echo "===================================="

while true; do
    clear
    echo "🎬 BILL'S MEDIA PROCESSING DASHBOARD"
    echo "===================================="
    echo ""
    
    echo "📊 STORAGE OVERVIEW:"
    echo "  Images: $(find ~/.bill-sloth/media-processing/images -type f | wc -l) files"
    echo "  Videos: $(find ~/.bill-sloth/media-processing/videos -type f | wc -l) files"  
    echo "  Audio: $(find ~/.bill-sloth/media-processing/audio -type f | wc -l) files"
    echo "  Total Size: $(du -sh ~/.bill-sloth/media-processing | cut -f1)"
    echo ""
    
    echo "🎯 QUICK ACTIONS:"
    echo "1) 📸 Process Images (VRBO Property)"
    echo "2) 🎥 Process Videos (EdBoiGames)"
    echo "3) 🎵 Process Audio"
    echo "4) 🤖 AI Media Analysis"
    echo "5) ☁️  Cloud Backup"
    echo "6) 🎮 EdBoiGames Content Pipeline"
    echo "7) 🏠 VRBO Property Images"
    echo "8) 📊 View Processing Stats"
    echo "9) 🧹 Cleanup Old Files"
    echo "0) Exit"
    echo ""
    
    read -p "Select action: " action
    
    case $action in
        1)
            echo "📸 Image Processing"
            read -p "Enter source directory: " source_dir
            read -p "Enter output directory: " output_dir
            ~/.bill-sloth/media-processing/scripts/optimize_images.sh "$source_dir" "$output_dir"
            ;;
        2)
            echo "🎥 Video Processing"
            read -p "Enter video file: " video_file
            read -p "Enter output directory: " output_dir
            read -p "Enter preset (web/mobile/edboigames): " preset
            ~/.bill-sloth/media-processing/scripts/process_videos.sh "$video_file" "$output_dir" "$preset"
            ;;
        3)
            echo "🎵 Audio Processing"
            read -p "Enter audio file: " audio_file
            read -p "Enter output directory: " output_dir
            read -p "Enter preset (podcast/voice/music): " preset
            ~/.bill-sloth/media-processing/scripts/process_audio.sh "$audio_file" "$output_dir" "$preset"
            ;;
        4)
            echo "🤖 AI Analysis"
            read -p "Enter media file: " media_file
            read -p "Enter analysis type (faces/text/content/all): " analysis_type
            ~/.bill-sloth/media-processing/scripts/ai_media_analysis.sh "$media_file" "$analysis_type"
            ;;
        5)
            echo "☁️ Cloud Backup"
            read -p "Enter source directory: " source_dir
            read -p "Enter cloud destination: " cloud_dest
            ~/.bill-sloth/media-processing/scripts/cloud_storage.sh backup "$source_dir" "$cloud_dest"
            ;;
        6)
            echo "🎮 EdBoiGames Content"
            read -p "Enter content type (gameplay/stream/review): " content_type
            read -p "Enter video file: " video_file
            read -p "Enter game name: " game_name
            ~/.bill-sloth/media-processing/scripts/edboigames_content.sh "$content_type" "$video_file" "$game_name"
            ;;
        7)
            echo "🏠 VRBO Property Images"
            read -p "Enter property ID: " property_id
            read -p "Enter source directory: " source_dir
            read -p "Enter action (process/watermark/listing): " vrbo_action
            ~/.bill-sloth/media-processing/scripts/vrbo_image_processor.sh "$property_id" "$source_dir" "$vrbo_action"
            ;;
        8)
            echo "📊 Processing Statistics"
            echo "Recent activity:"
            smart_find "*.log" ~/.bill-sloth/media-processing | head -10
            ;;
        9)
            echo "🧹 Cleanup"
            smart_find "*.tmp" ~/.bill-sloth/media-processing | xargs -r rm -f
            smart_find "temp_*" ~/.bill-sloth/media-processing | xargs -r rm -f
            echo "Cleanup complete!"
            ;;
        0)
            exit
            ;;
        *)
            echo "Invalid choice"
            ;;
    esac
    
    if [ "$action" != "0" ]; then
        echo ""
        read -n 1 -s -r -p "Press any key to continue..."
    fi
done
EOF
    chmod +x ~/.bill-sloth/media-processing/media_dashboard.sh
    
    log_success "Media processing dashboard created!"
}

# === MAIN SETUP FUNCTION ===

setup_media_processing_pipeline() {
    print_header "🎬 SETTING UP COMPLETE MEDIA PROCESSING PIPELINE"
    
    echo "Setting up comprehensive media processing system for Bill..."
    echo ""
    
    # Install tools
    install_media_processing_tools
    echo ""
    
    # Setup processing modules
    setup_image_processing
    echo ""
    
    setup_video_processing
    echo ""
    
    setup_audio_processing
    echo ""
    
    # Setup specialized workflows
    setup_vrbo_image_automation
    echo ""
    
    setup_edboigames_content_processing
    echo ""
    
    # Setup AI and cloud features
    setup_ai_media_analysis
    echo ""
    
    setup_cloud_storage_automation
    echo ""
    
    # Create dashboard
    create_media_processing_dashboard
    echo ""
    
    # Create main scripts directory
    mkdir -p ~/.bill-sloth/media-processing/scripts
    
    log_success "🎬 Media Processing Pipeline setup complete!"
    echo ""
    echo "🚀 Quick Start:"
    echo "  • Dashboard: ~/.bill-sloth/media-processing/media_dashboard.sh"
    echo "  • Image processing: ~/.bill-sloth/media-processing/scripts/optimize_images.sh"
    echo "  • Video processing: ~/.bill-sloth/media-processing/scripts/process_videos.sh"
    echo "  • VRBO images: ~/.bill-sloth/media-processing/scripts/vrbo_image_processor.sh"
    echo "  • EdBoiGames content: ~/.bill-sloth/media-processing/scripts/edboigames_content.sh"
    echo ""
    echo "📋 Next Steps:"
    echo "  1. Configure rclone for cloud storage: rclone config"
    echo "  2. Test image optimization with sample photos"
    echo "  3. Process first VRBO property images"
    echo "  4. Set up EdBoiGames content pipeline"
}

# === INTERACTIVE MEDIA PROCESSING MENU ===

media_processing_interactive() {
    while true; do
        print_header "🎬 MEDIA PROCESSING PIPELINE INTERACTIVE MENU"
        echo ""
        
        media_processing_capabilities
        echo ""
        
        echo "🛠️ SETUP & INSTALLATION:"
        echo "  1) Complete media processing setup"
        echo "  2) Install media processing tools only"
        echo "  3) Setup cloud storage automation"
        echo ""
        
        echo "📸 IMAGE PROCESSING:"
        echo "  4) Setup image optimization"
        echo "  5) Setup VRBO property image automation"
        echo "  6) Process images (interactive)"
        echo ""
        
        echo "🎥 VIDEO PROCESSING:"
        echo "  7) Setup video processing"
        echo "  8) Setup EdBoiGames content processing"
        echo "  9) Process videos (interactive)"
        echo ""
        
        echo "🎵 AUDIO PROCESSING:"
        echo " 10) Setup audio processing"
        echo " 11) Process audio (interactive)"
        echo ""
        
        echo "🤖 AI & AUTOMATION:"
        echo " 12) Setup AI media analysis"
        echo " 13) Run AI analysis (interactive)"
        echo ""
        
        echo "📊 MANAGEMENT:"
        echo " 14) Media processing dashboard"
        echo " 15) View processing statistics"
        echo ""
        
        echo " 0) Exit media processing module"
        echo ""
        
        local choice
        choice=$(prompt_with_timeout "Select option (0-15)" 30 "0")
        
        case "$choice" in
            1) setup_media_processing_pipeline ;;
            2) install_media_processing_tools ;;
            3) setup_cloud_storage_automation ;;
            4) setup_image_processing ;;
            5) setup_vrbo_image_automation ;;
            6)
                read -p "Enter source directory: " source_dir
                read -p "Enter output directory: " output_dir
                if [ -f ~/.bill-sloth/media-processing/scripts/optimize_images.sh ]; then
                    ~/.bill-sloth/media-processing/scripts/optimize_images.sh "$source_dir" "$output_dir"
                else
                    log_warning "Image processing not set up. Run option 4 first."
                fi
                ;;
            7) setup_video_processing ;;
            8) setup_edboigames_content_processing ;;
            9)
                read -p "Enter video file: " video_file
                read -p "Enter output directory: " output_dir
                read -p "Enter preset (web/mobile/edboigames): " preset
                if [ -f ~/.bill-sloth/media-processing/scripts/process_videos.sh ]; then
                    ~/.bill-sloth/media-processing/scripts/process_videos.sh "$video_file" "$output_dir" "$preset"
                else
                    log_warning "Video processing not set up. Run option 7 first."
                fi
                ;;
            10) setup_audio_processing ;;
            11)
                read -p "Enter audio file: " audio_file
                read -p "Enter output directory: " output_dir
                read -p "Enter preset (podcast/voice/music): " preset
                if [ -f ~/.bill-sloth/media-processing/scripts/process_audio.sh ]; then
                    ~/.bill-sloth/media-processing/scripts/process_audio.sh "$audio_file" "$output_dir" "$preset"
                else
                    log_warning "Audio processing not set up. Run option 10 first."
                fi
                ;;
            12) setup_ai_media_analysis ;;
            13)
                read -p "Enter media file: " media_file
                read -p "Enter analysis type (faces/text/content/all): " analysis_type
                if [ -f ~/.bill-sloth/media-processing/scripts/ai_media_analysis.sh ]; then
                    ~/.bill-sloth/media-processing/scripts/ai_media_analysis.sh "$media_file" "$analysis_type"
                else
                    log_warning "AI analysis not set up. Run option 12 first."
                fi
                ;;
            14)
                if [ -f ~/.bill-sloth/media-processing/media_dashboard.sh ]; then
                    ~/.bill-sloth/media-processing/media_dashboard.sh
                else
                    log_warning "Dashboard not found. Run complete setup first (option 1)."
                fi
                ;;
            15)
                echo "📊 Media Processing Statistics:"
                echo "  Total files processed: $(smart_find "*_processed.*" ~/.bill-sloth/media-processing 2>/dev/null | wc -l)"
                echo "  Storage used: $(du -sh ~/.bill-sloth/media-processing 2>/dev/null | cut -f1 || echo "0B")"
                echo "  Last processing: $(find ~/.bill-sloth/media-processing -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2- || echo "None")"
                ;;
            0)
                log_info "Exiting media processing module"
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
    echo "🎬 Media Processing Pipeline Module - Interactive Mode"
    media_processing_interactive
fi