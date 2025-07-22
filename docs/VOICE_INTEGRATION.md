# Bill Sloth Voice Control Integration

Bill Sloth now integrates with **Linux Voice Control** for robust, accurate voice command recognition using OpenAI Whisper.

## Why Linux Voice Control?

Instead of building speech recognition from scratch, we integrate with a mature, proven system:

- **OpenAI Whisper** - State-of-the-art speech recognition
- **Fuzzy matching** - Handles natural speech variations  
- **JSON configuration** - Easy to customize commands
- **Master control mode** - Personalized voice recognition
- **Offline capable** - No cloud dependencies required

## Quick Start

```bash
# 1. Setup voice control
bill-voice setup

# 2. Start voice control
bill-voice start

# 3. Train personalized recognition (optional)
bill-voice train
```

## Available Voice Commands

All Bill Sloth modules are voice-controllable:

- **"automation mastery"** - Complete automation tools
- **"clipboard tools"** - Clipboard management
- **"file management"** - File operations
- **"window control"** - Window management
- **"system doctor"** - System diagnostics
- **"security tools"** - Defensive cyber security
- **"health check"** - System health monitoring
- **"creative coding"** - Creative development tools
- **"gaming boost"** - Gaming optimization
- **"privacy tools"** - Privacy protection
- And many more...

## Natural Speech Recognition

Thanks to fuzzy matching, you can say commands naturally:
- "automation" → automation mastery
- "files" → file management  
- "system health" → system doctor
- "cyber security" → security tools

## Master Control Mode

For personalized voice recognition:

```bash
# Train the system to recognize your voice specifically
bill-voice train

# Enable master mode in config
echo '{"master-mode": true}' >> ~/.config/lvc-config-patch.json
```

## Configuration Files

- `~/lvc-commands.json` - Voice command mappings
- `~/lvc-config.json` - Voice control settings
- `external/bill-sloth-voice-config.json` - Bill Sloth command definitions

## Requirements

- Python 3.8+
- OpenAI Whisper
- PyAudio 
- Linux audio system (ALSA/PulseAudio)

## Integration Architecture

```
User Voice → Whisper → Fuzzy Match → Bill Sloth Module
```

1. **Whisper** converts speech to text
2. **Fuzzy matching** finds closest command
3. **Bill Sloth** executes the corresponding module
4. **Voice feedback** confirms action

## Troubleshooting

```bash
# Check voice system status
bill-voice status

# Test voice output
bill-voice test

# Reinstall/update
bill-voice setup
```

## ADHD-Friendly Features

- **Voice confirmation** - Speaks back what it understood
- **Natural commands** - No rigid syntax required
- **Master mode** - Learns your specific voice patterns
- **Hands-free operation** - Perfect for focus maintenance
- **Clear feedback** - Always know what's happening

This integration transforms Bill Sloth into a true "Linux Jarvis for dyslexic Tony Stark" - combining powerful automation with intuitive voice control.