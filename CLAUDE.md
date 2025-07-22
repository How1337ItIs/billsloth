# Bill Sloth Project - Claude Code Memory

## Project Overview
Bill Sloth is a comprehensive Linux automation system designed specifically for neurodivergent users (ADHD, dyslexia). It functions as a "self-building Jarvis for poor dyslexic Tony Stark."

### Team Structure
- **Dev (Midas Marsupius Whale):** Primary developer with final repository control
- **User (Nick "Bill Sloth"):** Co-developer providing feedback and testing (refuses to acknowledge his real name is Bill)  
- **Assistant:** Also called Bill Sloth due to early AI misunderstandings - we just ran with it

## Project Architecture

### Core Philosophy
- **Mature-First, Local-First:** Prefer robust open-source tools over custom solutions
- **Progressive Independence:** System learns and reduces Claude Code dependency over time
- **Pattern Learning & Adaptive Suggestions:** Local analytics track usage and suggest optimizations
- **ADHD/Dyslexia-Optimized UX:** ASCII art, color, motivational language, memory aids

### Key Components
- **Command Center:** `bill_command_center.sh` - Unified entry point for all operations
- **Onboarding System:** `onboard.sh` - Comprehensive user introduction and assessment
- **Module System:** `modules/` - Interactive toolkits for specific use cases
- **Library System:** `lib/` - Shared functionality and utilities
- **Voice Control:** Integrated Linux Voice Control system
- **Adaptive Learning:** Pattern recognition and auto-suggestion systems

### Critical Files to Understand First
1. `BILL_SLOTH_GIGA_DOC.md` - Complete project documentation
2. `bill_command_center.sh` - Main application entry point
3. `onboard.sh` - User experience and assessment system
4. `lib/` directory - Core functionality libraries
5. `modules/` directory - User-facing interactive tools

## Development Workflow

### Build and Test Commands
```bash
# System health check
bash bill_command_center.sh

# Test integration suite
bash tests/run_tests.sh

# Quick module test
bash tests/quick_integration_test.sh

# Generate documentation
bash scripts/generate_module_docs.sh
```

### Code Conventions
- All scripts include `# LLM_CAPABILITY: local_ok` header for AI compatibility
- ADHD-friendly interfaces with clear visual separation
- Error handling through centralized `lib/error_handling.sh`
- Data persistence via SQLite and JSON structures
- Modular, interchangeable components following Unix philosophy

## Claude Code Session Management

### Session Corruption Prevention
- Use `/clear` before switching between different modules
- Save progress to project's data persistence system before major operations
- Integrate with Bill Sloth's existing backup and monitoring infrastructure

### Project-Specific Recovery
```bash
# Use Bill Sloth's backup system
source lib/backup_management.sh
create_emergency_backup

# Restore from Bill Sloth data persistence
source lib/data_persistence.sh  
restore_session_context

# Health monitoring integration
source lib/system_health_monitoring.sh
check_system_health
```

### Context Management Strategy
- Leverage existing `prompts/claude_context.md` for project context
- Use Bill Sloth's adaptive learning logs for session continuity
- Integrate with the project's task runner and workflow orchestration

## Current Development Focus

### Active Areas
- Voice control integration and optimization
- Local LLM transition planning
- Module system expansion and refinement
- Adaptive learning algorithm improvements
- Testing and documentation automation

### Recent Changes
- Integrated comprehensive GIGA DOC documentation
- Enhanced onboarding experience with personalization
- Improved module interconnection and data sharing
- Added voice control via Linux Voice Control integration

## Working with This Project

### Before Major Changes
1. Run health check: `bash scripts/health_check.sh`
2. Create backup: `source lib/backup_management.sh && create_backup`
3. Review relevant module documentation in `BILL_SLOTH_GIGA_DOC.md`

### When Context Gets Full
1. Save current progress to Bill Sloth data persistence
2. Use project's workflow orchestration to checkpoint current task
3. Clear context and restore minimal necessary context
4. Continue with established project patterns and conventions

### Integration Points
- Data persistence system tracks all changes
- Notification system provides user feedback
- Workflow orchestration manages complex operations  
- Adaptive learning captures patterns for future optimization

This project represents a sophisticated approach to making technology accessible and empowering for neurodivergent users.