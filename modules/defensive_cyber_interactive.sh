#!/bin/bash
# LLM_CAPABILITY: auto
# CLAUDE_OPTIONS: 1=Network Scanner, 2=Vulnerability Assessment, 3=Security Monitoring, 4=Penetration Testing, 5=Complete Security Suite
# CLAUDE_PROMPTS: Security tool selection, Target configuration, Scan parameters
# CLAUDE_DEPENDENCIES: nmap, wireshark, metasploit, aircrack-ng, john
# Defensive Cybersecurity - Ethical hacking and security testing tools
# "You know what I'm gonna get you next Christmas, mom? A big wooden cross, so that every time you see it, you'll think of how much I care about you." - Carl

# Load Claude Interactive Bridge for AI/Human hybrid execution
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SOURCE_DIR/../lib/claude_interactive_bridge.sh" 2>/dev/null || true

source "../lib/interactive.sh" 2>/dev/null || {
    echo "🛡️  DEFENSIVE CYBERSECURITY SETUP"
    echo "================================="
}

# Load ASCII art gallery for cyber effects
source "$SOURCE_DIR/../lib/ascii_gallery.sh" 2>/dev/null || true

# Show cyber skull for hacking module (20% chance)
if [ $((RANDOM % 5)) -eq 0 ] && command -v show_cyber_skull &>/dev/null; then
    echo ""
    echo -e "${CYBER_RED}[CYBER DEFENSE MATRIX ACTIVATED]${CYBER_RESET}"
    show_cyber_skull "full"
    echo ""
fi

show_banner "DEFENSIVE CYBERSECURITY" "1337 h4x0r security testing tools for ethical defense" "SECURITY"

echo "🛡️  DEFENSIVE CYBERSECURITY - ETHICAL HACKING MASTERY"
echo "===================================================="
echo ""
echo "🎯 Transform your Linux system into a professional cybersecurity workstation"
echo "   for ethical hacking, penetration testing, and defensive security analysis!"
echo ""
echo "⚖️  ETHICAL USE ONLY:"
echo "   • Only test systems you own or have explicit permission to test"
echo "   • Use for learning, certification, and legitimate security testing"
echo "   • Defensive security and vulnerability assessment purposes"
echo "   • Educational cybersecurity skill development"
echo ""
echo "🧠 SECURITY PROFESSIONAL BENEFITS:"
echo "   • Complete penetration testing toolkit"
echo "   • Network security analysis and monitoring"
echo "   • Vulnerability assessment and reporting"
echo "   • Incident response and forensics capabilities"
echo "   • Automated security scanning and testing"
echo "   • Professional-grade security documentation"
echo ""

explain_defensive_cyber() {
    echo "💡 WHAT IS DEFENSIVE CYBERSECURITY?"
    echo "==================================="
    echo ""
    echo "Transform your system into a professional security testing platform:"
    echo ""
    echo "🎯 PENETRATION TESTING:"
    echo "   • Kali Linux tools integration"
    echo "   • Network reconnaissance and scanning"
    echo "   • Vulnerability assessment and exploitation"
    echo "   • Web application security testing"
    echo "   • Wireless network security analysis"
    echo ""
    echo "🔍 SECURITY ANALYSIS:"
    echo "   • Network traffic analysis with Wireshark"
    echo "   • Log analysis and SIEM capabilities"
    echo "   • Malware analysis in isolated environments"
    echo "   • Digital forensics and incident response"
    echo ""
    echo "🛡️  DEFENSIVE TOOLS:"
    echo "   • Intrusion detection systems (IDS)"
    echo "   • Firewall configuration and monitoring"
    echo "   • Security hardening automation"
    echo "   • Compliance scanning and reporting"
    echo ""
    echo "📚 LEARNING & CERTIFICATION:"
    echo "   • CEH, CISSP, OSCP preparation environments"
    echo "   • Capture The Flag (CTF) challenge setup"
    echo "   • Security lab environments"
    echo "   • Professional documentation templates"
    echo ""
    echo "🤖 AI-ENHANCED SECURITY:"
    echo "   • Intelligent threat detection"
    echo "   • Automated vulnerability reporting"
    echo "   • Security policy generation"
    echo "   • AI-powered penetration testing assistance"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

install_kali_tools() {
    echo "🐉 INSTALLING KALI LINUX PENETRATION TESTING TOOLS"
    echo "=================================================="
    echo ""
    echo "🎯 Installing essential ethical hacking tools..."
    echo ""
    
    # Add Kali repository (for Debian-based systems)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            echo "📦 Adding Kali Linux tools repository..."
            
            # Install essential pentesting tools available in standard repos
            sudo apt update
            sudo apt install -y \
                nmap nikto dirb gobuster hydra john hashcat \
                aircrack-ng wireshark-qt metasploit-framework \
                sqlmap burpsuite zaproxy masscan fierce \
                netcat-traditional socat tcpdump ngrep \
                binwalk foremost hexedit ghex \
                python3-pip python3-venv git curl wget \
                build-essential libssl-dev libffi-dev
                
        elif command -v dnf &> /dev/null; then
            # Fedora/CentOS
            sudo dnf install -y \
                nmap nikto hydra john aircrack-ng wireshark \
                python3-pip python3-virtualenv git curl wget \
                openssl-devel libffi-devel gcc
                
        elif command -v pacman &> /dev/null; then
            # Arch Linux
            sudo pacman -S nmap nikto hydra john aircrack-ng wireshark-qt \
                          python-pip python-virtualenv git curl wget \
                          openssl libffi gcc
        fi
    fi
    
    # Install additional tools via pip
    echo "🐍 Installing Python security tools..."
    pip3 install --user \
        impacket pwntools scapy requests beautifulsoup4 \
        dnspython python-nmap netaddr ipaddress \
        colorama termcolor pyfiglet
    
    echo "✅ Core penetration testing tools installed!"
    echo ""
    echo "🛡️  INSTALLED TOOLS:"
    echo "   • nmap        = Network discovery and security auditing"
    echo "   • nikto       = Web server scanner"
    echo "   • hydra       = Password cracking tool"
    echo "   • john        = John the Ripper password cracker"
    echo "   • aircrack-ng = Wireless network security testing"
    echo "   • wireshark   = Network protocol analyzer"
    echo "   • burpsuite   = Web application security testing"
    echo "   • sqlmap      = SQL injection testing tool"
    echo "   • metasploit  = Penetration testing framework"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_security_workspace() {
    echo "🏗️  SETTING UP SECURITY TESTING WORKSPACE"
    echo "=========================================="
    echo ""
    echo "🎯 Creating organized workspace for security testing..."
    echo ""
    
    # Create security workspace directories
    SECURITY_HOME="$HOME/security-workspace"
    mkdir -p "$SECURITY_HOME"/{tools,targets,reports,exploits,wordlists,scripts,labs}
    
    # Create subdirectories for different testing phases
    mkdir -p "$SECURITY_HOME/reports"/{reconnaissance,scanning,exploitation,post-exploitation}
    mkdir -p "$SECURITY_HOME/tools"/{custom,downloaded,compiled}
    mkdir -p "$SECURITY_HOME/targets"/{web-apps,networks,wireless,mobile}
    mkdir -p "$SECURITY_HOME/wordlists"/{passwords,directories,subdomains,usernames}
    
    echo "📁 Created security workspace at: $SECURITY_HOME"
    echo ""
    
    # Download common wordlists
    echo "📚 Downloading essential wordlists..."
    cd "$SECURITY_HOME/wordlists"
    
    # SecLists (comprehensive wordlist collection)
    if [ ! -d "SecLists" ]; then
        git clone https://github.com/danielmiessler/SecLists.git 2>/dev/null || {
            echo "⚠️  SecLists download failed - will create basic wordlists"
            mkdir -p SecLists/Discovery/Web-Content
            echo -e "admin\nadministrator\ntest\nlogin\nindex\nphp\nhtml\njs\ncss" > SecLists/Discovery/Web-Content/common.txt
        }
    fi
    
    # Common passwords
    cat > passwords/common-passwords.txt << 'EOF'
123456
password
123456789
12345678
12345
1234567
password1
123123
admin
qwerty
abc123
Password1
letmein
welcome
monkey
dragon
EOF
    
    echo "✅ Security workspace configured!"
    echo ""
    echo "📁 WORKSPACE STRUCTURE:"
    echo "   $SECURITY_HOME/tools/     = Custom and downloaded tools"
    echo "   $SECURITY_HOME/targets/   = Target information and data"
    echo "   $SECURITY_HOME/reports/   = Testing reports and documentation"
    echo "   $SECURITY_HOME/wordlists/ = Password and directory lists"
    echo "   $SECURITY_HOME/exploits/  = Exploit code and payloads"
    echo "   $SECURITY_HOME/labs/      = Practice lab environments"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_hacking_scripts() {
    echo "⚡ CREATING 1337 H4X0R AUTOMATION SCRIPTS"
    echo "========================================"
    echo ""
    echo "🎯 Building custom automation tools for efficient testing..."
    echo ""
    
    # Create custom pentesting scripts
    mkdir -p ~/.local/bin
    
    # Network reconnaissance script
    cat > ~/.local/bin/recon-target << 'EOF'
#!/bin/bash
# Advanced network reconnaissance script
# Usage: recon-target <target_ip_or_domain>

TARGET="$1"
WORKSPACE="$HOME/security-workspace"
REPORT_DIR="$WORKSPACE/reports/reconnaissance"

if [ -z "$TARGET" ]; then
    echo "🎯 Advanced Network Reconnaissance"
    echo "================================="
    echo ""
    echo "Usage: recon-target <target_ip_or_domain>"
    echo ""
    echo "Examples:"
    echo "  recon-target 192.168.1.1"
    echo "  recon-target example.com"
    echo "  recon-target 10.0.0.0/24"
    echo ""
    exit 1
fi

echo "🔍 RECONNAISSANCE: $TARGET"
echo "=========================="
echo ""

# Create target-specific directory
TARGET_DIR="$REPORT_DIR/$(echo $TARGET | tr '/' '_')"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

echo "📍 Starting reconnaissance on: $TARGET"
echo "📁 Results will be saved to: $TARGET_DIR"
echo ""

# Basic host discovery
echo "1️⃣  Host Discovery..."
nmap -sn "$TARGET" > host-discovery.txt 2>&1 &
HOST_PID=$!

# Port scanning
echo "2️⃣  Port Scanning..."
nmap -sS -O -sV -p- "$TARGET" > port-scan.txt 2>&1 &
PORT_PID=$!

# Service enumeration
echo "3️⃣  Service Enumeration..."
nmap -sC -sV -p 1-1000 "$TARGET" > service-enum.txt 2>&1 &
SERVICE_PID=$!

# Wait for scans to complete
wait $HOST_PID $PORT_PID $SERVICE_PID

echo ""
echo "✅ Reconnaissance complete!"
echo "📄 Results saved in: $TARGET_DIR"
echo ""
echo "📊 QUICK SUMMARY:"
if command -v claude &> /dev/null; then
    echo "🤖 Generating AI analysis..."
    SCAN_RESULTS=$(cat port-scan.txt service-enum.txt)
    claude "Analyze these nmap scan results and provide a security assessment summary with potential vulnerabilities: $SCAN_RESULTS" > ai-analysis.txt 2>/dev/null
    head -10 ai-analysis.txt 2>/dev/null || echo "AI analysis failed - review scan files manually"
else
    echo "   • Open ports found: $(grep -c "open" port-scan.txt 2>/dev/null || echo "0")"
    echo "   • Services detected: $(grep -c "SERVICE" service-enum.txt 2>/dev/null || echo "0")"
    echo "   • Review scan files for detailed information"
fi
EOF

    # Web application testing script
    cat > ~/.local/bin/web-test << 'EOF'
#!/bin/bash
# Web application security testing script
# Usage: web-test <url>

URL="$1"
WORKSPACE="$HOME/security-workspace"
REPORT_DIR="$WORKSPACE/reports"

if [ -z "$URL" ]; then
    echo "🌐 Web Application Security Testing"
    echo "=================================="
    echo ""
    echo "Usage: web-test <url>"
    echo ""
    echo "Examples:"
    echo "  web-test https://example.com"
    echo "  web-test http://192.168.1.100:8080"
    echo ""
    exit 1
fi

echo "🌐 WEB TESTING: $URL"
echo "==================="
echo ""

# Create target-specific directory
DOMAIN=$(echo "$URL" | sed 's|https\?://||' | sed 's|/.*||' | tr ':' '_')
TARGET_DIR="$REPORT_DIR/web-apps/$DOMAIN"
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR"

echo "📍 Starting web application testing on: $URL"
echo "📁 Results will be saved to: $TARGET_DIR"
echo ""

# Directory brute force
echo "1️⃣  Directory Discovery..."
if command -v gobuster &> /dev/null; then
    gobuster dir -u "$URL" -w "$WORKSPACE/wordlists/SecLists/Discovery/Web-Content/common.txt" -o directory-scan.txt 2>&1 &
    GOBUSTER_PID=$!
fi

# Nikto web scanner
echo "2️⃣  Web Vulnerability Scanning..."
if command -v nikto &> /dev/null; then
    nikto -h "$URL" -o nikto-scan.txt &
    NIKTO_PID=$!
fi

# Basic SQL injection testing
echo "3️⃣  SQL Injection Testing..."
if command -v sqlmap &> /dev/null; then
    echo "$URL" > target.txt
    sqlmap -m target.txt --batch --random-agent --output-dir=sqlmap-results &
    SQLMAP_PID=$!
fi

# Wait for scans
if [ ! -z "$GOBUSTER_PID" ]; then wait $GOBUSTER_PID; fi
if [ ! -z "$NIKTO_PID" ]; then wait $NIKTO_PID; fi
if [ ! -z "$SQLMAP_PID" ]; then wait $SQLMAP_PID; fi

echo ""
echo "✅ Web application testing complete!"
echo "📄 Results saved in: $TARGET_DIR"
echo ""

# AI-powered analysis if available
if command -v claude &> /dev/null; then
    echo "🤖 Generating security assessment..."
    RESULTS=$(cat nikto-scan.txt directory-scan.txt 2>/dev/null)
    claude "Analyze these web security scan results and prioritize vulnerabilities by risk level: $RESULTS" > security-assessment.txt 2>/dev/null
    echo "📊 Security assessment saved to: security-assessment.txt"
fi
EOF

    # Password cracking automation
    cat > ~/.local/bin/crack-hash << 'EOF'
#!/bin/bash
# Password hash cracking script
# Usage: crack-hash <hash_file> [wordlist]

HASH_FILE="$1"
WORDLIST="${2:-$HOME/security-workspace/wordlists/passwords/common-passwords.txt}"

if [ -z "$HASH_FILE" ] || [ ! -f "$HASH_FILE" ]; then
    echo "🔓 Password Hash Cracking"
    echo "========================"
    echo ""
    echo "Usage: crack-hash <hash_file> [wordlist]"
    echo ""
    echo "Examples:"
    echo "  crack-hash hashes.txt"
    echo "  crack-hash hashes.txt /path/to/custom/wordlist.txt"
    echo ""
    echo "Hash file format: one hash per line"
    exit 1
fi

echo "🔓 HASH CRACKING: $HASH_FILE"
echo "============================="
echo ""
echo "📍 Hash file: $HASH_FILE"
echo "📚 Wordlist: $WORDLIST"
echo ""

# Detect hash type and crack with John the Ripper
if command -v john &> /dev/null; then
    echo "🔍 Detecting hash types..."
    john --list=formats | head -5
    echo ""
    echo "🚀 Starting John the Ripper..."
    john --wordlist="$WORDLIST" "$HASH_FILE"
    echo ""
    echo "✅ Cracking complete! Results:"
    john --show "$HASH_FILE"
else
    echo "❌ John the Ripper not installed. Install it first."
fi
EOF

    # CTF helper script
    cat > ~/.local/bin/ctf-helper << 'EOF'
#!/bin/bash
# CTF (Capture The Flag) challenge helper
# Usage: ctf-helper <challenge_type>

CHALLENGE_TYPE="$1"
WORKSPACE="$HOME/security-workspace/labs"

case "$CHALLENGE_TYPE" in
    "crypto")
        echo "🔐 CRYPTOGRAPHY CHALLENGE TOOLS"
        echo "==============================="
        echo ""
        echo "Available tools:"
        echo "• base64 decode: echo 'SGVsbG8=' | base64 -d"
        echo "• ROT13: echo 'text' | tr 'A-Za-z' 'N-ZA-Mn-za-m'"
        echo "• MD5 hash: echo -n 'text' | md5sum"
        echo "• SHA256: echo -n 'text' | sha256sum"
        echo "• Frequency analysis: Add frequency_analysis.py"
        ;;
    "forensics")
        echo "🔍 DIGITAL FORENSICS TOOLS"
        echo "=========================="
        echo ""
        echo "Available tools:"
        echo "• File analysis: file <filename>"
        echo "• Strings extraction: strings <filename>"
        echo "• Binary analysis: hexdump -C <filename>"
        echo "• Image metadata: exiftool <image> (install: apt install exiftool)"
        echo "• Hidden files: binwalk <filename>"
        ;;
    "web")
        echo "🌐 WEB EXPLOITATION TOOLS"
        echo "========================="
        echo ""
        echo "Available tools:"
        echo "• View source code inspection"
        echo "• Cookie analysis and manipulation"
        echo "• SQL injection testing with sqlmap"
        echo "• XSS payload testing"
        echo "• Directory brute forcing with gobuster"
        ;;
    "pwn")
        echo "💥 BINARY EXPLOITATION TOOLS"
        echo "============================"
        echo ""
        echo "Available tools:"
        echo "• GDB debugging: gdb <binary>"
        echo "• Buffer overflow pattern: python3 -c \"print('A'*100)\""
        echo "• Checksec: checksec <binary> (install: apt install checksec)"
        echo "• ROPgadget: ROPgadget --binary <file>"
        ;;
    *)
        echo "🏁 CTF CHALLENGE HELPER"
        echo "======================"
        echo ""
        echo "Usage: ctf-helper <challenge_type>"
        echo ""
        echo "Challenge types:"
        echo "  crypto     - Cryptography challenges"
        echo "  forensics  - Digital forensics"
        echo "  web        - Web exploitation"
        echo "  pwn        - Binary exploitation"
        echo ""
        ;;
esac
EOF

    chmod +x ~/.local/bin/recon-target ~/.local/bin/web-test ~/.local/bin/crack-hash ~/.local/bin/ctf-helper
    
    echo "✅ 1337 hacking scripts created!"
    echo ""
    echo "🎯 YOUR NEW H4X0R COMMANDS:"
    echo "   recon-target <ip/domain>  = Advanced network reconnaissance"
    echo "   web-test <url>            = Web application security testing"
    echo "   crack-hash <file>         = Password hash cracking"
    echo "   ctf-helper <type>         = CTF challenge assistance"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

setup_security_monitoring() {
    echo "👁️  SETTING UP SECURITY MONITORING"
    echo "=================================="
    echo ""
    echo "🎯 Installing network monitoring and intrusion detection..."
    echo ""
    
    # Install monitoring tools
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt &> /dev/null; then
            sudo apt install -y \
                fail2ban ufw iptables-persistent \
                rkhunter chkrootkit lynis \
                auditd rsyslog logwatch
        fi
    fi
    
    # Configure basic firewall
    echo "🔥 Configuring UFW firewall..."
    sudo ufw --force enable
    sudo ufw default deny incoming
    sudo ufw default allow outgoing
    sudo ufw allow ssh
    
    # Create security monitoring script
    cat > ~/.local/bin/security-monitor << 'EOF'
#!/bin/bash
# Security monitoring dashboard
# Usage: security-monitor

echo "🛡️  SECURITY MONITORING DASHBOARD"
echo "================================="
echo ""

# System security status
echo "📊 SYSTEM SECURITY STATUS:"
echo ""

# Firewall status
echo "🔥 Firewall (UFW):"
sudo ufw status | head -5
echo ""

# Failed login attempts
echo "🚫 Failed Login Attempts (Last 10):"
grep "Failed password" /var/log/auth.log 2>/dev/null | tail -10 | cut -d' ' -f1,2,3,11,13 || echo "No recent failed attempts"
echo ""

# Active network connections
echo "🌐 Active Network Connections:"
ss -tuln | head -10
echo ""

# Running processes
echo "⚙️  Suspicious Processes Check:"
ps aux --sort=-%cpu | head -10
echo ""

# Disk usage
echo "💾 Disk Usage:"
df -h / | tail -1
echo ""

# Load average
echo "📈 System Load:"
uptime
echo ""

echo "💡 Run 'sudo lynis audit system' for detailed security audit"
EOF

    chmod +x ~/.local/bin/security-monitor
    
    echo "✅ Security monitoring configured!"
    echo ""
    echo "🛡️  SECURITY TOOLS READY:"
    echo "   security-monitor     = Security dashboard"
    echo "   sudo lynis audit     = Complete security audit"
    echo "   sudo rkhunter --check = Rootkit scanner"
    echo "   sudo fail2ban-client status = Intrusion prevention"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

create_lab_environments() {
    echo "🧪 CREATING SECURITY LAB ENVIRONMENTS"
    echo "====================================="
    echo ""
    echo "🎯 Setting up practice environments for ethical hacking..."
    echo ""
    
    LABS_DIR="$HOME/security-workspace/labs"
    mkdir -p "$LABS_DIR"/{vulnerable-apps,docker-labs,vm-configs}
    cd "$LABS_DIR"
    
    # Create vulnerable web application
    cat > vulnerable-apps/simple-sql-lab.php << 'EOF'
<?php
// INTENTIONALLY VULNERABLE - FOR EDUCATIONAL PURPOSES ONLY
// DO NOT DEPLOY ON PRODUCTION SERVERS

if (isset($_GET['id'])) {
    $id = $_GET['id'];
    
    // Vulnerable SQL query (DO NOT USE IN PRODUCTION)
    $query = "SELECT * FROM users WHERE id = " . $id;
    
    echo "<h2>User Information</h2>";
    echo "<p>Query: " . htmlspecialchars($query) . "</p>";
    echo "<p>This is intentionally vulnerable for learning SQL injection</p>";
    echo "<p>Try: ?id=1' OR '1'='1</p>";
}
?>
<html>
<body>
<h1>Vulnerable Web App Lab</h1>
<p>This is a deliberately vulnerable application for learning purposes.</p>
<form method="GET">
    <input type="text" name="id" placeholder="User ID">
    <input type="submit" value="Search">
</form>
</body>
</html>
EOF
    
    # Create Docker lab setup script
    cat > docker-labs/setup-dvwa.sh << 'EOF'
#!/bin/bash
# Setup Damn Vulnerable Web Application (DVWA) in Docker

echo "🐳 Setting up DVWA (Damn Vulnerable Web Application)"
echo "=================================================="
echo ""

if command -v docker &> /dev/null; then
    echo "📦 Starting DVWA container..."
    docker run -d -p 8080:80 --name dvwa vulnerables/web-dvwa
    
    echo ""
    echo "✅ DVWA is now running!"
    echo "🌐 Access it at: http://localhost:8080"
    echo "🔑 Default credentials: admin/password"
    echo ""
    echo "⚠️  EDUCATIONAL USE ONLY - DO NOT EXPOSE TO INTERNET"
else
    echo "❌ Docker not installed. Install Docker first:"
    echo "   sudo apt install docker.io"
    echo "   sudo usermod -aG docker $USER"
    echo "   (then log out and back in)"
fi
EOF
    
    chmod +x docker-labs/setup-dvwa.sh
    
    # Create learning resources
    cat > README-Labs.md << 'EOF'
# Security Laboratory Environments

## 🧪 Available Labs

### 1. Vulnerable Web Applications
- `vulnerable-apps/simple-sql-lab.php` - Basic SQL injection practice
- Run `docker-labs/setup-dvwa.sh` to deploy DVWA

### 2. Network Scanning Practice
- Use `recon-target 127.0.0.1` to practice on localhost
- Set up local services for testing

### 3. Password Cracking
- Practice with `crack-hash` on sample hashes
- Use common passwords wordlist

### 4. CTF Challenges
- Use `ctf-helper <type>` for challenge assistance
- Practice on online CTF platforms

## ⚠️  ETHICAL GUIDELINES

**ONLY test on:**
- Your own systems
- Lab environments you create
- Systems you have explicit written permission to test
- Designated CTF/training platforms

**NEVER test on:**
- Production systems without permission
- Other people's systems
- Public websites or services
- Any system you don't own or lack permission for

## 📚 Learning Resources

1. **Online CTF Platforms:**
   - PicoCTF (beginner-friendly)
   - HackTheBox (intermediate/advanced)
   - TryHackMe (guided learning)

2. **Certification Prep:**
   - CEH (Certified Ethical Hacker)
   - OSCP (Offensive Security Certified Professional)
   - CISSP (Certified Information Systems Security Professional)

3. **Books:**
   - "The Web Application Hacker's Handbook"
   - "Metasploit: The Penetration Tester's Guide"
   - "Black Hat Python"
EOF
    
    echo "✅ Security lab environments created!"
    echo ""
    echo "🧪 LABS AVAILABLE:"
    echo "   📁 $LABS_DIR/vulnerable-apps/ = Practice web applications"
    echo "   🐳 $LABS_DIR/docker-labs/     = Docker-based environments"
    echo "   📚 $LABS_DIR/README-Labs.md   = Learning guide and ethics"
    echo ""
    echo "🚀 QUICK START:"
    echo "   1. Run: cd $LABS_DIR/docker-labs && ./setup-dvwa.sh"
    echo "   2. Practice with: recon-target 127.0.0.1"
    echo "   3. Try CTF challenges with: ctf-helper crypto"
    echo ""
    read -p "Press Enter to continue..."
    clear
}

demo_hacking_skills() {
    echo "🎯 DEFENSIVE CYBERSECURITY DEMONSTRATION"
    echo "======================================="
    echo ""
    echo "Let's test your new 1337 h4x0r skills!"
    echo ""
    
    # Test basic tools
    echo "🔍 TESTING RECONNAISSANCE TOOLS:"
    echo ""
    
    # Test nmap
    echo "1️⃣  Testing nmap (network scanner):"
    if command -v nmap &> /dev/null; then
        echo "✅ nmap available"
        nmap -V | head -1
        echo "   Try: nmap -sn 192.168.1.0/24  (scan local network)"
    else
        echo "❌ nmap not installed"
    fi
    echo ""
    
    # Test custom scripts
    echo "2️⃣  Testing custom reconnaissance script:"
    if command -v recon-target &> /dev/null; then
        echo "✅ recon-target script ready"
        echo "   Try: recon-target google.com"
    else
        echo "❌ recon-target script not available"
    fi
    echo ""
    
    echo "🌐 TESTING WEB SECURITY TOOLS:"
    echo ""
    
    # Test web tools
    echo "3️⃣  Testing web security tools:"
    WEB_TOOLS=("nikto" "sqlmap" "gobuster")
    for tool in "${WEB_TOOLS[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo "   ✅ $tool available"
        else
            echo "   ❌ $tool not installed"
        fi
    done
    echo ""
    
    echo "🔓 TESTING PASSWORD TOOLS:"
    echo ""
    
    # Test password tools
    echo "4️⃣  Testing John the Ripper:"
    if command -v john &> /dev/null; then
        echo "✅ John the Ripper available"
        john 2>&1 | head -2
        echo "   Create test hashes and use: crack-hash <hash_file>"
    else
        echo "❌ John the Ripper not installed"
    fi
    echo ""
    
    echo "📊 SECURITY WORKSPACE STATUS:"
    WORKSPACE="$HOME/security-workspace"
    if [ -d "$WORKSPACE" ]; then
        echo "✅ Security workspace created at: $WORKSPACE"
        echo "   📁 Directories: $(ls -1 $WORKSPACE | wc -l)"
        echo "   📚 Wordlists available: $(find $WORKSPACE/wordlists -name "*.txt" 2>/dev/null | wc -l)"
        echo "   🛠️  Custom tools: $(ls -1 ~/.local/bin/*-* 2>/dev/null | wc -l)"
    else
        echo "❌ Security workspace not found"
    fi
    echo ""
    
    echo "🎯 YOUR 1337 H4X0R COMMANDS:"
    echo ""
    echo "🔍 RECONNAISSANCE:"
    echo "   recon-target <target>     = Full network reconnaissance"
    echo "   nmap -sS <target>         = Stealth port scan"
    echo "   nmap -sC -sV <target>     = Service detection"
    echo ""
    echo "🌐 WEB TESTING:"
    echo "   web-test <url>            = Complete web app testing"
    echo "   nikto -h <url>            = Web vulnerability scanner"
    echo "   sqlmap -u <url>           = SQL injection testing"
    echo "   gobuster dir -u <url>     = Directory brute force"
    echo ""
    echo "🔓 PASSWORD ATTACKS:"
    echo "   crack-hash <file>         = Password hash cracking"
    echo "   hydra -l user -P list <target> = Brute force login"
    echo ""
    echo "🧪 PRACTICE LABS:"
    echo "   cd ~/security-workspace/labs/docker-labs"
    echo "   ./setup-dvwa.sh           = Deploy vulnerable web app"
    echo "   ctf-helper <type>         = CTF challenge assistance"
    echo ""
    echo "🛡️  MONITORING:"
    echo "   security-monitor          = Security dashboard"
    echo "   sudo lynis audit system   = Security audit"
    echo ""
    echo "⚖️  REMEMBER: ETHICAL USE ONLY!"
    echo "   • Only test systems you own or have permission to test"
    echo "   • Use for learning, certification, and legitimate security testing"
    echo "   • Never attack systems without explicit authorization"
    echo ""
    read -p "Press Enter to finish 1337 h4x0r setup..."
    clear
}

# Main menu
main_menu() {
    while true; do
        show_banner "DEFENSIVE CYBERSECURITY" "1337 h4x0r security testing tools for ethical defense" "SECURITY"
        
        echo "🛡️  DEFENSIVE CYBERSECURITY MENU"
        echo "================================"
        echo ""
        echo "1) 💡 What is Defensive Cybersecurity?"
        echo "2) 🐉 Install Kali Linux Penetration Testing Tools"
        echo "3) 🏗️  Setup Security Testing Workspace"
        echo "4) ⚡ Create 1337 H4x0r Automation Scripts"
        echo "5) 👁️  Setup Security Monitoring & IDS"
        echo "6) 🧪 Create Security Lab Environments"
        echo "7) 🎯 Demo Your 1337 H4x0r Skills"
        echo "8) 🚀 Complete Setup (All Steps)"
        echo "0) Exit"
        echo ""
        
        read -p "Choose an option (0-8): " choice
        
        case $choice in
            1) explain_defensive_cyber ;;
            2) install_kali_tools ;;
            3) setup_security_workspace ;;
            4) create_hacking_scripts ;;
            5) setup_security_monitoring ;;
            6) create_lab_environments ;;
            7) demo_hacking_skills ;;
            8) complete_setup ;;
            0) echo "👋 May your exploits be ethical and your defenses be strong! 🛡️"; exit 0 ;;
            *) echo "❌ Invalid choice. Please try again."; sleep 2 ;;
        esac
    done
}

# Complete setup - all steps in sequence
complete_setup() {
    echo "🚀 COMPLETE DEFENSIVE CYBERSECURITY SETUP"
    echo "========================================="
    echo ""
    echo "This will set up the ultimate ethical hacking environment:"
    echo "Kali tools + Custom scripts + Lab environments + Monitoring"
    echo ""
    echo "⚠️  ETHICAL USE AGREEMENT:"
    echo "By continuing, you agree to use these tools only for:"
    echo "• Educational purposes and skill development"
    echo "• Testing systems you own or have explicit permission to test"
    echo "• Legitimate security assessments and penetration testing"
    echo "• Defensive security analysis and incident response"
    echo ""
    read -p "I agree to ethical use only (y/n): " ethical_confirm
    
    if [[ ! $ethical_confirm =~ ^[Yy]$ ]]; then
        echo "❌ Ethical use agreement required. Exiting..."
        return
    fi
    
    read -p "Continue with complete 1337 h4x0r setup? (y/n): " setup_confirm
    
    if [[ $setup_confirm =~ ^[Yy]$ ]]; then
        explain_defensive_cyber
        install_kali_tools
        setup_security_workspace
        create_hacking_scripts
        setup_security_monitoring
        create_lab_environments
        demo_hacking_skills
        
        echo ""
        echo "🎉 DEFENSIVE CYBERSECURITY MASTERY COMPLETE!"
        echo "==========================================="
        echo ""
        echo "🎯 YOU NOW HAVE:"
        echo "   ✅ Complete penetration testing toolkit"
        echo "   ✅ Automated reconnaissance and scanning scripts"
        echo "   ✅ Web application security testing capabilities"
        echo "   ✅ Password cracking and forensics tools"
        echo "   ✅ Security monitoring and intrusion detection"
        echo "   ✅ Practice lab environments for safe learning"
        echo "   ✅ CTF challenge assistance and automation"
        echo ""
        echo "🚀 NEXT STEPS:"
        echo "   • Practice on lab environments: cd ~/security-workspace/labs"
        echo "   • Try reconnaissance: recon-target <your-test-target>"
        echo "   • Set up DVWA practice app: ./docker-labs/setup-dvwa.sh"
        echo "   • Monitor system security: security-monitor"
        echo ""
        echo "🏆 Welcome to the world of ethical hacking!"
        echo "   Your 1337 h4x0r skills are now fully operational."
        echo "   Remember: With great power comes great responsibility."
        echo ""
        echo "📚 CERTIFICATION PATHS TO CONSIDER:"
        echo "   • CEH (Certified Ethical Hacker)"
        echo "   • OSCP (Offensive Security Certified Professional)"
        echo "   • CISSP (Certified Information Systems Security Professional)"
        echo "   • GCIH (GIAC Certified Incident Handler)"
        echo ""
        
        # Log this installation
        echo "$(date): Defensive Cybersecurity setup completed with full penetration testing toolkit and lab environments" >> ~/.bill-sloth/history.log
    else
        return
    fi
}

# Make sure we're in the right directory
cd "$(dirname "${BASH_SOURCE[0]}")/.."

# Create necessary directories
mkdir -p ~/.bill-sloth
mkdir -p ~/security-workspace/{tools,targets,reports,exploits,wordlists,scripts,labs}
mkdir -p ~/.local/bin

# Start the main menu
main_menu