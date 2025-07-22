# Quick Start: Claude Code Robustness

## TL;DR for Immediate Protection

### 🚀 Start Every Session This Way:
```bash
cd ~/bill-sloth
claunch --tmux
```

### ⚠️ If You See Any of These, EXIT IMMEDIATELY:
- Response times >10 seconds
- "no low surrogate in string" errors  
- Any 400-level API errors
- JSON parsing warnings
- Session resumption failures

### 🔧 Quick Recovery:
```bash
# Force exit corrupted session
pkill -f claude

# Clean and restart
claunch clean
claunch --tmux
```

## Essential Commands

### Session Management
```bash
claunch --tmux          # Start protected session
claunch list           # List active sessions  
claunch clean          # Clean up session files
```

### Before Major Work
```bash
# Create backup using Bill Sloth systems
source lib/backup_management.sh
create_development_backup "pre-work-$(date +%s)"

# Clear context between unrelated tasks
/clear
```

### Emergency Recovery
```bash
# Complete reset procedure
pkill -f claude
rm -rf ~/.claude/sessions/*
claunch --tmux

# Restore Bill Sloth context
cat CLAUDE.md | head -30
```

## Integration with Bill Sloth

### Quick Context Recovery
```bash
# Show project status
bash bill_command_center.sh | head -20

# Load core systems
source lib/data_persistence.sh
source lib/workflow_orchestration.sh
source lib/system_health_monitoring.sh
```

### Backup Integration
```bash
# Use existing backup system
source lib/backup_management.sh
create_development_backup "claude-session"

# Notification integration
source lib/notification_system.sh
notify_info "Session Backup" "Claude work saved"
```

## Prevention Checklist

**Daily Workflow:**
- [ ] Start with `claunch --tmux`
- [ ] Use `/clear` between different tasks
- [ ] Monitor response times
- [ ] Exit sessions properly
- [ ] Create backups before major work

**Warning Signs:**
- [ ] Slow responses (>5 seconds)
- [ ] Context window warnings
- [ ] API error messages
- [ ] Session file size >10MB
- [ ] Resumption problems

**Recovery Actions:**
- [ ] Exit immediately on corruption signs
- [ ] Clean session data
- [ ] Start fresh session
- [ ] Restore context from project files
- [ ] Continue work in new session

## File Locations

**Global Files:**
- `~/.claude/CLAUDE.md` - Global guidelines
- `~/.claude/commands/` - Recovery procedures

**Project Files:**
- `~/bill-sloth/CLAUDE.md` - Project context
- `~/bill-sloth/.claude/commands/` - Project-specific tools

## Help & Resources

**Quick Reference:**
- Full guide: `CLAUDE_CODE_ROBUSTNESS_GUIDE.md`
- Project context: `CLAUDE.md`
- System overview: `BILL_SLOTH_GIGA_DOC.md`

**Emergency Procedures:**
- Session health: `~/.claude/commands/session-health.md`
- Emergency reset: `~/.claude/commands/emergency-reset.md`
- Context cleanup: `~/.claude/commands/context-cleanup.md`

Remember: It's better to restart a session early than to fight with corruption!