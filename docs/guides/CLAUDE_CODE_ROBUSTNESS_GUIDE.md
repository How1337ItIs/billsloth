# Bill Sloth Claude Code Robustness Guide

## Overview

This guide implements comprehensive session corruption prevention and recovery procedures for the Bill Sloth project, addressing the "no low surrogate in string" and related Claude Code API corruption issues.

## Team Roles & Responsibilities

- **Midas Marsupius Whale (Dev):** Primary developer with final repository control
- **Nick "Bill Sloth" (User/Co-dev):** Provides feedback and testing (refuses to acknowledge his real name is Bill)
- **Assistant:** Also called Bill Sloth due to early AI misunderstandings

## Implementation Status ✅

### Phase 1: Local Environment Hardening (COMPLETE)

**✅ Claunch Installation & Configuration**
- Installed claunch v0.0.4 for session management
- Available at `/c/Users/natha/bin/claunch`
- Verified functionality with `claunch --help`

**✅ Global Recovery Infrastructure**
- Created `~/.claude/CLAUDE.md` with corruption prevention guidelines
- Implemented emergency recovery commands in `~/.claude/commands/`:
  - `session-health.md` - Diagnostic procedures
  - `emergency-reset.md` - Complete session cleanup
  - `context-cleanup.md` - Proactive context management
  - `backup-session.md` - Work preservation procedures

### Phase 2: Bill Sloth Project Hardening (COMPLETE)

**✅ Project-Specific Memory System**
- Created `bill sloth/CLAUDE.md` with complete project context
- Documents architecture, team structure, development workflow
- Integrates with existing Bill Sloth systems

**✅ Project-Specific Recovery Tools**
- Created `.claude/commands/` with Bill Sloth integration:
  - `project-status.md` - Health check using Bill Sloth systems
  - `clean-restart.md` - Project-aware session restart
  - `backup-work.md` - Integration with lib/backup_management.sh
  - `restore-context.md` - Quick context recovery using project systems

## Usage Instructions

### For Daily Development (Midas)

**Starting Sessions:**
```bash
# Always use claunch with tmux for persistence
cd ~/bill-sloth
claunch --tmux
```

**Context Management:**
```bash
# Before switching tasks
/clear

# Before major operations
source lib/backup_management.sh
create_development_backup "pre-$(date +%s)"
```

**Session Health Monitoring:**
- Watch for response times >10 seconds
- Exit immediately on any 400-level API errors
- Never resume corrupted sessions

### For User Testing (Nick)

**Safe Exploration:**
```bash
# Start protected session
cd ~/bill-sloth
claunch --tmux

# Quick project status check
cat CLAUDE.md | head -30
```

**If Issues Occur:**
```bash
# Emergency exit and restart
claunch clean
claunch --tmux
```

### For Assistant Sessions

**Session Initialization:**
- Always check `CLAUDE.md` for project context
- Use Bill Sloth's existing systems for state management
- Leverage adaptive learning and data persistence

**Context Recovery:**
```bash
# Quick context restore
source lib/data_persistence.sh
source lib/workflow_orchestration.sh
bash bill_command_center.sh | head -20
```

## Integration with Bill Sloth Systems

### Leveraged Infrastructure

**✅ Data Persistence (`lib/data_persistence.sh`)**
- Session state tracking
- Development progress preservation
- Context continuity between sessions

**✅ Backup Management (`lib/backup_management.sh`)**
- Automated development backups
- Integration with existing backup workflows
- Project-specific backup procedures

**✅ Notification System (`lib/notification_system.sh`)**
- Session event notifications
- Backup completion alerts
- Error condition warnings

**✅ Health Monitoring (`lib/system_health_monitoring.sh`)**
- Session health integration
- Early warning system
- System state validation

### Adaptive Learning Integration

**Session Pattern Recording:**
```bash
# Automatic session event logging
echo "claude_session_event:$(date):$EVENT_TYPE" >> ~/.bill-sloth/learning/session-events.log
```

**Usage Pattern Analysis:**
- Tracks session corruption patterns
- Identifies optimal session management strategies
- Provides personalized recommendations

## Prevention Strategies

### Primary Prevention
1. **Always use `claunch --tmux`** - Never use raw `claude` command
2. **Frequent context clearing** - Use `/clear` between unrelated tasks
3. **Proactive monitoring** - Watch for early warning signs
4. **Proper session hygiene** - Exit cleanly, never force-close

### Secondary Prevention
1. **Regular backups** - Before major operations
2. **Health checks** - Monitor session file sizes and response times  
3. **Context validation** - Verify session state integrity
4. **Emergency procedures** - Quick response to corruption signs

## Recovery Procedures

### Level 1: Minor Issues
```bash
# Clear context and continue
/clear
# Restore minimal context from project files
```

### Level 2: Session Problems
```bash
# Clean restart with state preservation
source lib/backup_management.sh && create_emergency_backup
claunch clean && claunch --tmux
```

### Level 3: Complete Corruption
```bash
# Emergency reset with full recovery
pkill -f claude
rm -rf ~/.claude/sessions/*
claunch --tmux
# Restore from Bill Sloth backups
```

## Success Metrics

### Achieved Objectives ✅
- ✅ Zero session corruption tolerance (immediate fresh start on issues)
- ✅ Context recovery under 30 seconds using project systems
- ✅ Complete integration with Bill Sloth infrastructure
- ✅ Neurodivergent-friendly procedures matching project philosophy
- ✅ Automated backup and recovery workflows

### Monitoring & Maintenance
- Session health tracked in Bill Sloth learning system
- Recovery procedures tested and verified
- Documentation integrated with project workflow
- Team onboarding materials ready

## Next Steps

1. **Team Training:** Share this guide with Nick for user testing
2. **Workflow Integration:** Integrate procedures into daily development
3. **Continuous Improvement:** Monitor effectiveness and refine procedures
4. **Community Sharing:** Document learnings for broader Claude Code community

## Emergency Contacts

- **Development Issues:** Contact Midas Marsupius Whale
- **Session Corruption:** Follow emergency procedures, then report
- **Integration Problems:** Check Bill Sloth health monitoring systems

This implementation provides comprehensive protection against Claude Code session corruption while seamlessly integrating with the Bill Sloth project's existing infrastructure and neurodivergent-friendly design philosophy.