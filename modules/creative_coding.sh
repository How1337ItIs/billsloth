#!/bin/bash
# LLM_CAPABILITY: local_ok
# Creative coding and generative art

setup_p5js() {
    echo "🎨 Setting up p5.js environment..."
    npm install -g live-server
    
    mkdir -p ~/Creative/p5js
    cat > ~/Creative/p5js/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.7.0/p5.min.js"></script>
    <script src="sketch.js"></script>
    <style>body {margin: 0; overflow: hidden;}</style>
</head>
<body></body>
</html>
EOF

    cat > ~/Creative/p5js/sketch.js << 'EOF'
// Welcome to the vibe zone!
let hue = 0;

function setup() {
    createCanvas(windowWidth, windowHeight);
    colorMode(HSB);
    background(0);
}

function draw() {
    hue = (hue + 1) % 360;
    
    if (mouseIsPressed) {
        strokeWeight(random(1, 10));
        stroke(hue, 80, 100, 0.5);
        line(pmouseX, pmouseY, mouseX, mouseY);
    }
}

function windowResized() {
    resizeCanvas(windowWidth, windowHeight);
}

function keyPressed() {
    if (key === 's') {
        saveCanvas('vibe-' + frameCount, 'png');
    } else if (key === 'c') {
        background(0);
    }
}
EOF
}

create_vibe_command() {
    cat > ~/bin/vibe << 'EOF'
#!/bin/bash
echo "✨ Entering the VIBE ZONE ✨"
echo "Controls:"
echo "- Click/drag to draw"
echo "- 's' to save image"
echo "- 'c' to clear"
echo ""
cd ~/Creative/p5js
live-server --open
EOF
    chmod +x ~/bin/vibe
}

install_processing() {
    echo "🎯 Installing Processing..."
    cd /tmp
    wget https://github.com/processing/processing4/releases/download/processing-1293-4.3/processing-4.3-linux-x64.tgz
    tar -xzf processing-4.3-linux-x64.tgz
    sudo mv processing-4.3 /opt/
    sudo ln -s /opt/processing-4.3/processing /usr/local/bin/processing
}