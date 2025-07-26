#!/bin/bash
# Bill Sloth Aliases - ADHD-Friendly Shortcuts
# Source this file: source ~/BillSloth/shortcuts/aliases.sh
#
# 🚀 QUICKEST COMMANDS (for when typing is hard):
# up = update system | k9 = kill process | w = watch | re = restart
# s = sudo | ip = my IP | vpn = check VPN | fix = audio fix
# cam = webcam test | rec = record screen | find = find process
# eb = edit bash | ea = edit aliases | rl = reload bash
# ai = AI chat | game = gaming mode | stream = streaming | vibe = creative coding

# ADHD-friendly work shortcuts
alias work-mode='~/bin/work-mode'
alias focus='~/bin/focus-timer'
alias brain-dump='~/bin/brain-dump'
alias dashboard='~/bin/dashboard'
alias rental='~/bin/rental-dashboard'
alias edboigames='~/bin/edboigames-dashboard'
alias data-hoard='~/bin/data-dashboard'

# Memory aids
alias todo='echo "$(date): $*" >> ~/Productivity/.current-task && echo "Task set: $*"'
alias done='mv ~/Productivity/.current-task ~/Productivity/Done/$(date +%Y%m%d)-task.txt'
alias what-am-i-doing='cat ~/Productivity/.current-task 2>/dev/null || echo "No current task set"'

# System shortcuts - Easy to spell AND anime versions
alias update='~/bin/update || sudo apt update && sudo apt upgrade -y'
alias up='~/bin/update || sudo apt update && sudo apt upgrade -y'  # easy version
alias kamehameha='~/bin/update || sudo apt update && sudo apt upgrade -y'  # anime version
alias kill9='kill -9'
alias k9='kill -9'  # easy version
alias rasengan='kill -9'  # anime version
alias watch='watch -n1 -d'
alias w='watch -n1 -d'  # easy version
alias sharingan='watch -n1 -d'  # anime version
alias restart='sudo systemctl restart'
alias re='sudo systemctl restart'  # easy version
alias bankai='sudo systemctl restart'  # anime version
alias pause='sleep'
alias p='sleep'  # easy version
alias genjutsu='sleep'  # anime version
alias sudo-mode='echo "お前はもう死んでいる" && sleep 2 && echo "NANI?!" && sudo'
alias s='echo "お前はもう死んでいる" && sleep 2 && echo "NANI?!" && sudo'  # easy version
alias omae='echo "お前はもう死んでいる" && sleep 2 && echo "NANI?!" && sudo'  # anime version

# Quick system info
alias matrix='cmatrix -b -C green'
alias neofetch='neofetch --ascii_distro arch'
alias sysinfo='inxi -Fxz'
alias temp='sensors 2>/dev/null || echo "Install lm-sensors"'

# System health (mature, all-in-one)
alias system-health='if command -v glances &> /dev/null; then glances; else echo "Glances is not installed. Install with: sudo apt install glances"; fi'  # recommended

# Navigation made easy
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Network shortcuts
alias myip='curl -s ifconfig.me'
alias ip='curl -s ifconfig.me'  # easy version
alias localip='hostname -I | awk "{print \$1}"'
alias local='hostname -I | awk "{print \$1}"'  # easy version
alias ports='netstat -tulpn'
alias vpn-status='if ip addr | grep -q "tun\|wg"; then echo "🛡️ VPN Connected"; else echo "⚠️ VPN Disconnected"; fi'
alias vpn='if ip addr | grep -q "tun\|wg"; then echo "🛡️ VPN Connected"; else echo "⚠️ VPN Disconnected"; fi'  # easy version
alias listening='lsof -i -P -n | grep LISTEN'

# Git shortcuts for the lazy
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'

# Development shortcuts
alias serve='python3 -m http.server 8080'
alias weather='curl wttr.in'
alias qr='qrencode -t ansiutf8'

# Audio/Video shortcuts
alias audio-fix='~/bin/fix-audio || pulseaudio -k && pulseaudio --start'
alias fix='~/bin/fix-audio || pulseaudio -k && pulseaudio --start'  # easy version
alias webcam-test='ffplay /dev/video0'
alias cam='ffplay /dev/video0'  # easy version
alias record-screen='ffmpeg -f x11grab -s 1920x1080 -i :0.0 output.mp4'
alias rec='ffmpeg -f x11grab -s 1920x1080 -i :0.0 output.mp4'  # easy version

# Security shortcuts
alias nmap-quick='nmap -sV -sC -O -T4'
alias nmap-stealth='nmap -sS -O -T2'
alias whatsmyport='netstat -tulpn | grep LISTEN'
alias secure-delete='shred -vfz -n 3'

# Fun stuff - Adult Swim & Anime references
alias hack='echo "Accessing mainframe..." && sleep 2 && echo "Access granted." && echo "Welcome to the Matrix, Neo."'
alias l33t='echo $@ | tr "aeiostlAEIOSTL" "4310571431057L"'
alias anime='echo "( ͡° ͜ʖ ͡°) Senpai noticed you!"'
alias baka='echo "ばか！(´∀｀)♡"'

# Aqua Teen Hunger Force references
alias meatwad='echo "I get it! It aint making me laugh, but I get it!"'
alias frylock='echo "Don'\''t drape that towel on my computer!"'
alias shake='echo "Number one in the hood, G!"'
alias carl='echo "Yeah, I know all about computers."'
alias athf='echo "My name is... Shake-zula, the mic rula, the old schoola!"'
alias wwwyzzerdd='echo "It is I, the wwwyzzerdd. D-d-d-d."'
alias broadbrain='echo "This is live streaming, broadbrain."'
alias brainframe='echo "He can'\''t hear you, Fry man. You are not on the brainframe."'
alias supervisor='echo "I'\''m the supervisor. What seems to be the problem?"'
alias cyberland='echo "You have entered the cyberland portal."'
alias instantpest='echo "Welcome to Instant Pestering!"'
alias wireless='echo "That'\''s wireless, broadbrain."'
alias emails='echo "Congratulations, you have been signed up to receive e-mails."'
alias rebuild='echo "We have the technology. We can rebuild him."'
alias carlemails='echo "I keep getting these freakin'\'' emails! These people know that I'\''m small down there!"'

# Productivity shortcuts
alias clean-system='sudo apt autoremove -y && sudo apt autoclean && sudo journalctl --vacuum-time=7d'
alias backup-home='tar -czf ~/backup-$(date +%Y%m%d).tar.gz ~/'

# Docker shortcuts (if Docker is installed)
alias dps='docker ps'
alias dim='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'

# AI shortcuts (when Ollama is installed)
alias ai='~/bin/ai'
alias code-ai='ollama run codellama:7b'
alias ai-list='ollama list'

# Creative coding shortcuts
alias vibe='~/bin/vibe'
alias processing='processing'

# Streaming shortcuts
alias stream='~/bin/stream'
alias stream-test='ffmpeg -f v4l2 -i /dev/video0 -t 10 -f null -'

# Gaming shortcuts
alias game='~/bin/game'
alias steam-native='steam -no-browser'
alias wine-tricks='winetricks'
alias fps-check='nvidia-smi dmon -s pucvmet -c 1 2>/dev/null || echo "Install nvidia-smi for GPU monitoring"'

# File operations with safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# Compression shortcuts
alias extract='function _extract() { if [ -f $1 ]; then case $1 in *.tar.bz2) tar xjf $1;; *.tar.gz) tar xzf $1;; *.bz2) bunzip2 $1;; *.rar) unrar x $1;; *.gz) gunzip $1;; *.tar) tar xf $1;; *.tbz2) tar xjf $1;; *.tgz) tar xzf $1;; *.zip) unzip $1;; *.Z) uncompress $1;; *.7z) 7z x $1;; *) echo "Unknown format";; esac; else echo "File not found"; fi }; _extract'

# Quick config edits
alias edit-bash='nano ~/.bashrc'
alias eb='nano ~/.bashrc'  # easy version
alias edit-aliases='nano ~/BillSloth/shortcuts/aliases.sh'
alias ea='nano ~/BillSloth/shortcuts/aliases.sh'  # easy version
alias reload-bash='source ~/.bashrc'
alias rl='source ~/.bashrc'  # easy version

# Directory shortcuts for Bill's common locations
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias desktop='cd ~/Desktop'
alias lab='cd ~/BillSloth'

# Process shortcuts
alias psg='ps aux | grep'
alias find='ps aux | grep'  # easy version
alias top='htop'
alias cpu='top -o %CPU'
alias mem='top -o %MEM'

# Torrenting shortcuts (VPN check built-in)
alias torrent='~/bin/torrent-safe'
alias seedbox-check='transmission-remote -l 2>/dev/null || echo "Transmission not running"'

# Study shortcuts for learning Linux
alias man-search='function _mansearch() { man -k $1 | head -10; }; _mansearch'
alias command-help='function _cmdhelp() { $1 --help | head -20; }; _cmdhelp'
alias what-is='function _whatis() { which $1 && man $1 | head -5; }; _whatis'

# Sloth ASCII art functions
alias welcome='cat << "EOF"
    🦥 Welcome to the Bill Sloth Linux Lab! 🦥
    
       ／|_/|     "Slow and steady wins the race!"
      (  o.o  )    Taking your time is perfectly fine
       > ^ <       One command at a time, no rush!
       
    Remember: Even sloths get things done eventually! (◕‿◕)♡
EOF'

alias sloth-motivation='cat << "EOF"
    🌿🦥 SLOTH WISDOM 🦥🌿
    
    "Speed isn't everything. Sometimes going slow
     means you actually finish what you start."
     
         ／|_/|
        (  ^.^ )  <- This is you, being awesome
         > v <
         
    🍃 Take breaks when you need them! 🍃
EOF'

# Function to show all custom aliases
alias show-powers='echo "🌟 Your Anime Powers:" && alias | grep -E "(kamehameha|rasengan|sharingan|bankai|omae)" | sort'

# Add some color to commands
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Loading message
echo "🎌 Bill Sloth aliases loaded! Type 'show-powers' to see your anime shortcuts."
alias midaswhale='if (( RANDOM % 10 == 0 )); then echo "🐋 Midas Marsupius Whale 👑🐋 — wombat in a whale suit, King Midas, bitten by a time-traveling whale on acid, now immortal. All of it may be true."; else echo "🐋 Developer: Midas Whale 👑🐋"; fi'

show_me_the_golden_wombat() {
  cat <<'EOF'
🐋👑 THE ORIGIN OF MIDAS WHALE 👑🐋

Long ago, before the first shell script was ever written, there lived a king named Midas. He was renowned for his golden touch, but also for his restless curiosity and a knack for getting into trouble.

One day, while wandering the palace gardens, King Midas stumbled upon a small, unassuming wombat. This wombat was not magical, nor famous, nor even particularly clever. It was just a simple wombat, content to dig burrows and munch on roots.

But fate had other plans.

Suddenly, a swirling portal opened in the sky, and from it emerged a time-traveling whale—its skin shimmering with psychedelic colors, its eyes wide with cosmic knowledge (and possibly the effects of interdimensional acid). The whale, in a fit of cosmic whimsy, swooped down and bit King Midas right on the hand.

In that moment, reality twisted. The golden power of Midas, the humble spirit of the wombat, and the cosmic weirdness of the whale fused together. King Midas was transformed—no longer just a king, but something much stranger.

He became MIDAS WHALE:
- Sometimes a whale in a golden crown,
- Sometimes a wombat in a whale suit,
- Sometimes just a king with a suspiciously aquatic aura,
- Always a little bit of everything, and never quite what you expect.

Some say he is immortal, wandering the timelines, leaving behind cryptic shell scripts, golden bugs, and the occasional easter egg in open source projects. Others say he’s just a myth, a story told by sysadmins who’ve been up too long.

But those who have glimpsed his handiwork—a rare golden sloth emoji, a bug that turns into a feature if you look at it sideways—know the truth:

All of it may be true.

Midas Whale 👑🐋: Simple wombat. Whale. King. Developer. Legend. And if you ever find a golden bug in your code, you know who to thank.
EOF
}
alias show-me-the-golden-wombat=show_me_the_golden_wombat