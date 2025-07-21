#!/bin/bash
# Bill Sloth Aliases - ADHD-Friendly Shortcuts
# Source this file: source ~/BillSloth/shortcuts/aliases.sh

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
alias update='sudo apt update && sudo apt upgrade -y'
alias kamehameha='sudo apt update && sudo apt upgrade -y'  # anime version
alias kill9='kill -9'
alias rasengan='kill -9'  # anime version
alias watch='watch -n1 -d'
alias sharingan='watch -n1 -d'  # anime version
alias restart='sudo systemctl restart'
alias bankai='sudo systemctl restart'  # anime version
alias pause='sleep'
alias genjutsu='sleep'  # anime version
alias sudo-mode='echo "お前はもう死んでいる" && sleep 2 && echo "NANI?!" && sudo'
alias omae='echo "お前はもう死んでいる" && sleep 2 && echo "NANI?!" && sudo'  # anime version

# Quick system info
alias matrix='cmatrix -b -C green'
alias neofetch='neofetch --ascii_distro arch'
alias sysinfo='inxi -Fxz'
alias temp='sensors 2>/dev/null || echo "Install lm-sensors"'

# Navigation made easy
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Network shortcuts
alias myip='curl -s ifconfig.me'
alias localip='hostname -I | awk "{print \$1}"'
alias ports='netstat -tulpn'
alias listening='lsof -i -P -n | grep LISTEN'
alias vpn-status='if ip addr | grep -q "tun\|wg"; then echo "🛡️ VPN Connected"; else echo "⚠️ VPN Disconnected"; fi'

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
alias audio-fix='pulseaudio -k && pulseaudio --start'
alias webcam-test='ffplay /dev/video0'
alias record-screen='ffmpeg -f x11grab -s 1920x1080 -i :0.0 output.mp4'

# Security shortcuts
alias nmap-quick='nmap -sV -sC -O -T4'
alias nmap-stealth='nmap -sS -O -T2'
alias whatsmyport='netstat -tulpn | grep LISTEN'
alias secure-delete='shred -vfz -n 3'

# Fun stuff
alias hack='echo "Accessing mainframe..." && sleep 2 && echo "Access granted." && echo "Welcome to the Matrix, Neo."'
alias l33t='echo $@ | tr "aeiostlAEIOSTL" "4310571431057L"'
alias anime='echo "( ͡° ͜ʖ ͡°) Senpai noticed you!"'
alias baka='echo "ばか！(´∀｀)♡"'

# Productivity shortcuts
alias update-all='sudo apt update && sudo apt upgrade -y && flatpak update -y && snap refresh'
alias clean-system='sudo apt autoremove -y && sudo apt autoclean && sudo journalctl --vacuum-time=7d'
alias backup-home='tar -czf ~/backup-$(date +%Y%m%d).tar.gz ~/'

# Docker shortcuts (if Docker is installed)
alias dps='docker ps'
alias dim='docker images'
alias dex='docker exec -it'
alias dlog='docker logs'

# AI shortcuts (when Ollama is installed)
alias ai='ollama run llama2:7b'
alias code-ai='ollama run codellama:7b'
alias ai-list='ollama list'

# Streaming shortcuts
alias start-stream='obs &'
alias audio-levels='pavucontrol &'
alias stream-test='ffmpeg -f v4l2 -i /dev/video0 -t 10 -f null -'

# Gaming shortcuts
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
alias edit-aliases='nano ~/BillSloth/shortcuts/aliases.sh'
alias reload-bash='source ~/.bashrc'

# Directory shortcuts for Bill's common locations
alias downloads='cd ~/Downloads'
alias documents='cd ~/Documents'
alias desktop='cd ~/Desktop'
alias lab='cd ~/BillSloth'

# Process shortcuts
alias psg='ps aux | grep'
alias top='htop'
alias cpu='top -o %CPU'
alias mem='top -o %MEM'

# Torrenting shortcuts (VPN check built-in)
alias torrent-safe='if ip addr | grep -q "tun\|wg"; then qbittorrent; else echo "⚠️ Start VPN first!"; fi'
alias seedbox-check='transmission-remote -l 2>/dev/null || echo "Transmission not running"'

# Study shortcuts for learning Linux
alias man-search='function _mansearch() { man -k $1 | head -10; }; _mansearch'
alias command-help='function _cmdhelp() { $1 --help | head -20; }; _cmdhelp'
alias what-is='function _whatis() { which $1 && man $1 | head -5; }; _whatis'

# Anime ASCII art functions
alias welcome='cat << "EOF"
    ⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣠⣤⣶⣶
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⢰⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⣀⣀⣾⣿⣿⣿⣿
    ⣿⣿⣿⣿⣿⡏⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿
    ⣿⣿⣿⣿⣿⣿⠀⠀⠀⠈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠛⠉⠁⠀
    ⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠙⠿⠿⠿⠻⠿⠿⠟⠿⠛⠉⠀⠀⠀⠀⠀⠀
    Welcome to the Bill Sloth Linux Lab! (◕‿◕)♡
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