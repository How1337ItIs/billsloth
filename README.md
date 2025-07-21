# 🦥 Bill Sloth Linux Helper: The Ultimate ADHD-Friendly Linux Power User System

**A comprehensive Linux toolkit designed for neurodivergent minds, powered by Claude Code and open-source excellence.**

## 🎯 What Is This?

Bill Sloth is a modular Linux helper system that transforms your computer into an ADHD-friendly powerhouse. It combines:
- **Educational modules** that teach you WHY, not just HOW
- **Comprehensive automation** for repetitive tasks
- **Gaming optimization** for peak performance
- **Creative tools** for hyperfocus sessions
- **Privacy protection** for peace of mind
- **ATHF personality** because learning should be fun

## 🚀 QUICK START: From Zero to Hero

### Step 1: Set Up Claude Code (REQUIRED)

**Claude Code is the AI brain that makes this system work. You need the subscription CLI version, NOT the API.**

1. **Get Claude Code Subscription**:
   ```bash
   # Go to: https://claude.ai/code
   # Sign up for Claude Code subscription ($10/month as of 2024)
   # This gives you UNLIMITED usage with the CLI
   ```

2. **Install Claude Code CLI**:
   ```bash
   # For Linux/macOS:
   curl -fsSL https://claude.ai/install.sh | sh
   
   # For Windows (WSL recommended):
   # Install WSL first: wsl --install
   # Then run the Linux command above
   ```

3. **Authenticate Claude Code**:
   ```bash
   claude login
   # This opens your browser to authenticate
   # Follow the prompts to connect your subscription
   ```

4. **Test Claude Code**:
   ```bash
   claude "Hello, are you working?"
   # Should respond with a greeting
   ```

### Step 2: Install Bill Sloth System

```bash
# Clone the repository
git clone https://github.com/yourusername/bill-sloth.git ~/bill-sloth
cd ~/bill-sloth

# Make everything executable
chmod +x lab.sh bin/* modules/*.sh

# Start the system
./lab.sh
```

### Step 3: Your First Commands

```bash
# Ask Claude Code to help you:
claude "Run the Bill Sloth lab from ~/bill-sloth"

# Or use specific modules:
claude "I want to set up my gaming system using Bill Sloth"
claude "Help me automate my repetitive tasks with Bill Sloth"
claude "Set up privacy tools using the Bill Sloth system"
```

## 🧠 How It Works

1. **You talk to Claude Code** in natural language
2. **Claude Code reads the modules** to understand available tools
3. **Interactive scripts guide you** through setup with education
4. **Everything is logged** so you can learn and review
5. **ATHF characters** make it fun and memorable

## 📚 Complete Module Guide

### 🤖 AI & Development
- **`ai_setup_commands_interactive.sh`** - Local AI development (Ollama, Transformers, LangChain)
- **`ai_playground_interactive.sh`** - AI experimentation with GPT4All and Llama.cpp

### 🎮 Gaming
- **`gaming_boost_interactive.sh`** - Steam, Lutris, MangoHud, GameMode, RetroArch
- Complete Linux gaming optimization with performance monitoring

### 🎥 Content Creation
- **`streaming_setup_interactive.sh`** - OBS Studio, audio routing, streaming tools
- **`edboigames_toolkit_interactive.sh`** - YouTube creation (Kdenlive, Audacity, LMMS)
- **`creative_coding_interactive.sh`** - p5.js, Processing, Jupyter notebooks

### 🔧 System & Productivity
- **`system_ops_interactive.sh`** - VisiData, TLDR pages, Zeal, system monitoring
- **`productivity_suite_interactive.sh`** - Taskwarrior, Super Productivity, Logseq
- **`automation_mastery_interactive.sh`** - Zapier, Node-RED, Home Assistant concepts

### 🛡️ Privacy & Data
- **`privacy_tools_interactive.sh`** - VPN, Tor, Nextcloud, voice assistants
- **`data_hoarding_interactive.sh`** - yt-dlp, Jellyfin, Sonarr/Radarr, Beets

### 🎭 Community & Special
- **`discord_mod_toolkit_interactive.sh`** - Discord moderation and bot management
- **`vacation_rental_manager_interactive.sh`** - Rental property management tools
- **`kodi_setup_interactive.sh`** - Media center with debrid services

## 💡 Understanding the Workflow

### Traditional Way (Frustrating)
```
You → Google → Stack Overflow → Try commands → Fail → Repeat
```

### Bill Sloth Way (Empowering)
```
You → Claude Code → Interactive Module → Learn WHY → Success → Knowledge Retained
```

### Example Session
```bash
# You say:
claude "I want to automate downloading YouTube videos"

# Claude Code:
# 1. Recognizes this is a data hoarding task
# 2. Launches data_hoarding_interactive.sh
# 3. You see educational content about yt-dlp
# 4. You choose options interactively
# 5. Everything is set up with understanding
```

## 🔥 Architecture Philosophy

### Why This Design?
- **Educational First**: Every module teaches you WHY, not just HOW
- **ADHD-Friendly**: Visual menus, clear explanations, no overwhelm
- **Token Efficient**: Reusable modules save Claude Code tokens
- **Future-Proof**: Learn skills that last, not just quick fixes

### Core Components
- **Claude Code**: Your AI assistant and guide (REQUIRED - subscription CLI)
- **Interactive Modules**: Educational scripts that teach while doing
- **ATHF Personality**: Makes learning fun and memorable
- **Logging System**: Track everything for review and learning

## 🎯 Common Use Cases

### "I want to game on Linux"
```bash
claude "Set up my Linux gaming system with Bill Sloth"
# Launches gaming_boost_interactive.sh
# Installs Steam, Proton, Lutris, performance tools
# Explains everything along the way
```

### "I need to be more productive"
```bash
claude "Help me set up ADHD-friendly productivity tools"
# Launches productivity_suite_interactive.sh
# Sets up Taskwarrior, Super Productivity, Logseq
# Creates external brain system
```

### "I want to learn AI development"
```bash
claude "Set up local AI development with Bill Sloth"
# Launches ai_setup_commands_interactive.sh
# Installs Ollama, Transformers, LangChain
# Provides learning path
```

### "I need privacy tools"
```bash
claude "Set up privacy protection with Bill Sloth"
# Launches privacy_tools_interactive.sh
# Configures VPN, Tor, Nextcloud
# Explains digital privacy
```

## 🆘 Troubleshooting

### Claude Code Not Working?
1. **Check subscription**: Must be Claude Code CLI subscription, not API
2. **Re-authenticate**: `claude logout` then `claude login`
3. **Update CLI**: `claude update`
4. **Check connection**: `claude "Are you there?"`

### Modules Not Running?
1. **Make executable**: `chmod +x modules/*.sh`
2. **Check path**: `cd ~/bill-sloth`
3. **Run directly**: `./modules/module_name_interactive.sh`

### Getting Errors?
1. **Check logs**: Each module creates logs in `~/module_name/`
2. **Ask Claude Code**: `claude "Help debug this error: [paste error]"`
3. **Update system**: `sudo apt update && sudo apt upgrade`

## 🎓 Learning Path Recommendations

### Beginner (Start Here)
1. **System Basics**: `system_ops_interactive.sh` - Learn Linux fundamentals
2. **Productivity**: `productivity_suite_interactive.sh` - Build your external brain
3. **Privacy**: `privacy_tools_interactive.sh` - Understand digital safety

### Intermediate 
1. **Automation**: `automation_mastery_interactive.sh` - Automate everything
2. **Gaming**: `gaming_boost_interactive.sh` - Optimize for performance
3. **AI Basics**: `ai_playground_interactive.sh` - Start with AI

### Advanced
1. **AI Development**: `ai_setup_commands_interactive.sh` - Build AI applications
2. **Content Creation**: `streaming_setup_interactive.sh` + `edboigames_toolkit_interactive.sh`
3. **Creative Coding**: `creative_coding_interactive.sh` - Make digital art

## 🧠 ADHD/Neurodivergent Features

### Executive Function Support
- **Visual Menus**: No need to remember commands
- **Educational Content**: Understand WHY you're doing something
- **Progress Tracking**: See what you've accomplished
- **External Brain**: Tools like Logseq and Taskwarrior remember for you

### Hyperfocus Optimization
- **Comprehensive Setups**: Everything you need in one place
- **Minimal Switching**: Stay in flow state
- **Offline Options**: No internet distractions
- **Quick Access**: Aliases and shortcuts for common tasks

### Dopamine Design
- **ATHF Quotes**: Fun personality throughout
- **Success Messages**: Celebrate accomplishments
- **Visual Feedback**: See progress happening
- **Choice Architecture**: Multiple options prevent overwhelm

## 🚨 IMPORTANT: Subscription vs API

### ✅ Claude Code Subscription (REQUIRED)
- **Cost**: $10/month flat rate
- **Usage**: UNLIMITED conversations
- **Access**: Full CLI with all features
- **Best for**: Regular use, learning, development
- **Get it**: https://claude.ai/code

### ❌ Claude API (Won't Work)
- **Cost**: Pay per token (expensive for this system)
- **Usage**: Limited by token costs
- **Access**: API only, no CLI
- **Why not**: This system needs interactive CLI features

## 📊 What You'll Learn

### System Administration
- Linux fundamentals with VisiData and TLDR pages
- System monitoring and optimization
- Package management and updates

### Development Skills
- Local AI development with Ollama and LangChain
- Creative coding with p5.js and Processing
- Automation with Node-RED concepts

### Content Creation
- Video editing with Kdenlive
- Audio production with Audacity
- Streaming with OBS Studio

### Digital Sovereignty 
- Privacy tools and practices
- Local-first computing
- Open-source alternatives to big tech

## 🤝 Community & Support

### Getting Help
1. **Ask Claude Code**: It knows this system inside out
2. **Check Logs**: Each module logs to `~/module_name/assistant.log`
3. **GitHub Issues**: Report bugs or request features
4. **Discord**: Join the neurodivergent Linux community (coming soon)

### Contributing
- **Add Modules**: Follow the educational pattern
- **Improve Docs**: Help others learn
- **Share Workflows**: What works for your ADHD?
- **Report Issues**: Help make it better

## 🎯 Next Steps After Installation

1. **Explore Modules**: Ask Claude Code to show you around
   ```bash
   claude "Show me all the Bill Sloth modules and what they do"
   ```

2. **Start with Basics**: Build your foundation
   ```bash
   claude "Help me set up basic system tools with Bill Sloth"
   ```

3. **Customize for You**: Make it yours
   ```bash
   claude "Help me customize Bill Sloth for my ADHD workflow"
   ```

4. **Learn and Grow**: Use the educational content
   ```bash
   claude "Teach me about Linux automation using Bill Sloth"
   ```

## 🌟 Final Words

This system was built BY someone with ADHD FOR people with ADHD. It's not about doing things the "right" way - it's about doing things in a way that works with your brain, not against it.

Every module teaches you WHY, not just HOW. Every tool is chosen for its ADHD-friendliness. Every feature is designed to reduce cognitive load and increase success.

You're not broken. You just need tools that understand how your amazing brain works.

Now go forth and compute! 🚀

---

*"I don't need instructions to know how to rock!"* - Carl