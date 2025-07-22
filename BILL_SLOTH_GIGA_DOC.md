# BILL SLOTH GIGA DOC

---

## Table of Contents
1. [Project Overview & Philosophy](#project-overview--philosophy)
2. [Onboarding & User Journey](#onboarding--user-journey)
3. [Directory & File Inventory](#directory--file-inventory)
4. [Quick Reference Tables](#quick-reference-tables)
5. [Key Modules, Scripts, and Libraries](#key-modules-scripts-and-libraries)
6. [Architectural Patterns & Conventions](#architectural-patterns--conventions)
7. [Adaptive Learning & AI Integration](#adaptive-learning--ai-integration)
8. [Voice, Accessibility & UX](#voice-accessibility--ux)
9. [Security, Backup & Error Handling](#security-backup--error-handling)
10. [Documentation & Testing](#documentation--testing)
11. [Unique Features & Observations](#unique-features--observations)
12. [Notable Configuration, Data, and State Files](#notable-configuration-data-and-state-files)
13. [Additional Integrations, Data, and Configuration](#additional-integrations-data-and-configuration)
14. [Advanced Developer/Contributor Details](#advanced-developercontributor-details)
15. [Example Usage Snippets](#example-usage-snippets)
16. [Frequently Asked Questions (FAQ)](#frequently-asked-questions-faq)
17. [Glossary](#glossary)
18. [Overlay/Adaptation Model (Expanded)](#overlayadaptation-model-expanded)
19. [Troubleshooting & Recovery](#troubleshooting--recovery)
20. [Contribution & Community Guidelines](#contribution--community-guidelines)
21. [Change History Highlights](#change-history-highlights)
22. [Additional Recommendations](#additional-recommendations)
23. [Performance Monitoring & Optimization (New Section)](#performance-monitoring--optimization-new-section)

---

## 1. Project Overview & Philosophy (Expanded)

Bill Sloth is not just a collection of scripts—it's a self-improving, adaptive, and privacy-respecting Linux assistant designed for users with ADHD, dyslexia, and memory challenges. The system is built on these pillars:

- **Mature-First, Local-First:** Always prefer robust, open-source tools (e.g., FileBot, Kanboard, voice2json, restic, fd/ripgrep/fzf, Netdata, Just, SQLite). Custom logic is fallback only, clearly marked as legacy.
- **Progressive Independence:** The system learns from repeated requests and installs local solutions, reducing reliance on cloud AI over time.
- **Pattern Learning & Adaptive Suggestions:** Local analytics (bin/bill-brain, bin/capability-tracker) log user actions, analyze patterns, and auto-suggest or auto-execute common workflows. After repeated requests, the system recommends or installs the right tool.
- **Self-Audit & Continuous Improvement:** Modules can be self-audited (bin/audit_workflow, lab.sh audit options), with findings logged and surfaced for ongoing upgrades.
- **Personalization & Context Awareness:** The system adapts to Bill's unique work (VRBO, EdBoiGames), interests, and cognitive needs, using context from prompts/claude_context.md and adaptive learning modules.
- **ADHD/Dyslexia-Optimized UX:** ASCII art, color, motivational language, memory aids, and anime-themed shortcuts (shortcuts/aliases.sh) make the system accessible and fun.
- **Fallback & Deprecation Policy:** Legacy scripts (e.g., smart-voice-interface) are fallback only, with clear documentation and warnings. All modules are continuously audited for mature replacements.
- **Ultimate Dashboard:** The Bill Sloth Ultimate Control Center (bin/bill-sloth-ultimate) provides a unified, context-aware dashboard for system status, learning progress, and quick access to all workflows. **IMPLEMENTED 2025:** Now fully connected to actual Bill Sloth modules with real data persistence and cross-module integration.
- **Justfile & SQLite Integration:** Task automation and data persistence are handled with Just (for repeatable, ADHD-friendly task running) and SQLite (for robust, queryable data storage), replacing fragile flat files. **IMPLEMENTED 2025:** Complete justfile with 50+ commands and SQLite schema for all data types.
- **Cross-Module Integration:** Seamless data flow between VRBO, EdBoiGames, productivity, and system health modules with automated workflow orchestration and intelligent task creation.

## 2. Architecture & Data Flows (New Section)

### System Architecture

- **Pattern Learning Loop:**
  - `bin/bill-brain` logs every user action, analyzes time-based patterns, and suggests or auto-executes common workflows.
  - `bin/capability-tracker` tracks repeated requests and triggers installation of local tools when thresholds are met (e.g., 3+ audio issues → install audio manager).
- **Self-Audit Loop:**
  - `bin/audit_workflow` and audit options in `lab.sh` allow any module to be reviewed by an LLM for mature FOSS alternatives, with findings logged and surfaced for upgrades.
- **Module Interconnection:**
  - All modules share logs, context, and user feedback. Data flows between modules via local files, SQLite, and adaptive learning logs.
  - The Ultimate Dashboard (bin/bill-sloth-ultimate) aggregates system status, learning, and quick actions.
- **Task Automation:**
  - `Justfile` (if present) provides repeatable, ADHD-friendly task automation for common workflows.
- **Data Persistence:**
  - `SQLite` is used for persistent, queryable storage of logs, reminders, and pattern learning, replacing fragile flat files.

### Data Flow Diagram (Textual)

```
User → [CLI/Menu/Voice] → [Pattern Logger (bill-brain)] → [Capability Tracker] → [Module/Workflow] → [Self-Audit] → [Dashboard]
         ↘ [SQLite/Logs] ↙
```

## 3. Shortcuts, Aliases, and Memory Aids (Expanded)

- **ADHD/Dyslexia-Friendly Shortcuts:**
  - `shortcuts/aliases.sh` provides easy-to-remember, anime-themed, and memory-aid aliases for all major actions (e.g., `up`, `k9`, `work-mode`, `focus`, `brain-dump`, `kamehameha`, `rasengan`).
  - These are not just convenience—they are a core accessibility feature, reducing cognitive load and making the system fun and memorable.

## 4. Fallbacks, Deprecation, and Upgrade Path (Expanded)

- **Fallback Policy:**
  - Custom scripts (e.g., smart-voice-interface, local-first-router pattern matching) are fallback only, clearly marked as legacy, and only used if mature tools are unavailable.
  - All modules are continuously audited for mature replacements, and the upgrade path is logged in METHODS_LOG.md and surfaced in the dashboard.

## 5. Self-Audit, Continuous Improvement, and Living Upgrade Path (New Section)

- **Self-Audit:**
  - Any module can be audited via `bin/audit_workflow` or the audit options in `lab.sh`, prompting an LLM to suggest mature FOSS upgrades.
  - Audit findings are logged and surfaced for action.
- **Living Upgrade Path:**
  - METHODS_LOG.md and GENERAL_CODEBASE_AUDIT.md track audit findings, upgrade recommendations, and migration notes (e.g., FileBot integration, Kanboard default, glances for health, Just/SQLite migration).
  - The GIGA DOC now includes a summary of current, legacy, and planned upgrades for full transparency.

## 6. Personalization, Adaptive Learning, and User Context (Expanded)

- **Personalization:**
  - The system adapts to Bill's work (VRBO, EdBoiGames), interests, and cognitive needs, using context from prompts/claude_context.md and adaptive learning modules.
  - Feedback-driven adaptation ensures the system learns Bill's reality and stops wasting time on irrelevant content.
- **Adaptive Learning:**
  - Modules learn from feedback and usage, automatically switching focus (e.g., from YouTube tutorials to business development) based on Bill's needs.
  - The teaching/learning model, progressive independence, and feedback-driven adaptation are now summarized in the GIGA DOC's philosophy and onboarding sections.

## 7. Onboarding, Philosophy, and Educational Model (Expanded)

- **Teaching a Person to Fish:**
  - Every solution includes a "Why this works" explanation, with local documentation and interactive tutorials for complex concepts.
  - The system is designed to build capability, understanding, and independence over time, not just solve problems.
- **Progressive Capability Building:**
  - The system tracks repeated requests, installs local tools, and teaches Bill how to use them, moving from "fix this" to "teach me more."
- **Feedback Loops:**
  - Bill's learning indicators and system improvement metrics are tracked and surfaced in the dashboard and documentation.

## 8. Living Audit & Upgrade Table (New Section)

| Area                        | Status         | Next Steps/Upgrade Path           |
|-----------------------------|---------------|-----------------------------------|
| Voice fuzzy matching        | Deprecated    | Use voice2json/Rhasspy only       |
| Pattern matching fallback   | Deprecated    | Only used if mature not available |
| Data hoarding/manual steps  | Upgraded      | FileBot integration complete      |
| Pattern learning/suggestion | Active        | Enhance analytics as needed       |
| File-based Kanban           | Fallback      | Kanboard is default               |
| System health (custom)      | Deprecated    | Use glances only                  |
| Task runner (manual)        | Upgraded      | Use Just for repeatable tasks     |
| Data persistence (flat file)| Upgraded      | Use SQLite for logs/patterns      |
| Self-audit                  | Active        | Continue regular audits           |
| Personalization             | Active        | Adaptive learning ongoing         |

## 9. Cross-References & Contributor Guidance (Expanded)

- All contributors should reference METHODS_LOG.md, GENERAL_CODEBASE_AUDIT.md, and this GIGA DOC before making changes.
- All new modules must:
  - Prefer mature, open-source tools
  - Integrate with the pattern learning and capability tracker
  - Support self-audit and upgrade logging
  - Be accessible and ADHD/dyslexia-friendly

---

## 2. Onboarding & User Journey

1. **Install:** Run `bash install.sh` to set up dependencies and modules.
2. **First Launch:** Start with `bash lab.sh` for the interactive menu.
3. **Explore Workflows:** Try modules like `automation_mastery_interactive.sh` or `data_hoarding_interactive.sh`.
4. **Give Feedback:** After each workflow, rate your experience; the system will adapt over time.
5. **Audit & Improve:** Use `bin/audit_workflow <module>` to get AI-powered suggestions for any workflow.
6. **Recover/Reset:** If something breaks, use backup/rollback scripts or consult the troubleshooting section.

---

## 3. Directory & File Inventory

### Project Root
- **README.md:** Project summary, quickstart, and philosophy. Includes architecture notes, usage examples, and links to key modules.
- **bill_command_center.sh:** Central orchestrator; launches main workflows, manages global state, and provides a unified entry point.
- **EXPANSION_REPORT.md:** Tracks module and codebase growth, with stats and rationale for new additions.
- **MODULE_INDEX.md:** Alphabetical index of all modules, with one-line summaries and cross-references to documentation.
- **PHASE1_COMPLETION_REPORT.md:** Milestone report for phase 1, including what was shipped, lessons learned, and next steps.
- **competitor_analysis.md:** Compares Bill Sloth to other Linux assistants and automation tools, highlighting unique features.
- **IMPLEMENTATION_PLAN.md:** Stepwise plan for major features, with dependencies, priorities, and estimated timelines.
- **GENERAL_CODEBASE_AUDIT.md:** High-level audit of code quality, patterns, and standout characteristics.
- **ARCHITECTURE_AUDIT_REPORT.md:** In-depth comparison of planning documents vs. actual implementation, with gap analysis.
- **local_ai_transition_plan_v_0.md:** Roadmap for migrating from cloud AI to local LLMs, including phased rollout and fallback logic.
- **github_logic (1).md:** Details the overlay model, GitHub workflow, and branch management for safe adaptation.
- **bill_sloth_critical_audit.md:** Comprehensive, multi-dimensional audit (architecture, UX, security, learning, etc.).
- **DEVELOPER_GUIDE.md:** Deep technical reference (3,000+ lines), including API docs, architecture diagrams, and troubleshooting.
- **CHANGELOG.md:** Chronological log of all changes, with rationale and impact notes.
- **install.sh:** One-command installer; checks system, installs dependencies, and sets up all modules.
- **COMMANDS.md:** List of all available commands, with usage examples and expected outputs.
- **example.png:** Visual example for documentation or onboarding.
- **methods_log.md:** Log of all methods, breakthroughs, setbacks, and research areas for transparency.
- **lab.sh:** Main interactive shell interface; provides a menu-driven launcher for all workflows and audits.
- **self-executing-guide.md:** Step-by-step, self-contained user guide for onboarding and troubleshooting.
- **DEVELOPMENT_PHILOSOPHY.md:** Explains the project's guiding principles, design tradeoffs, and long-term vision.

### Key Directories
- **lib/**: Core libraries. Each file is a reusable component.
- **modules/**: All major workflows, each as a self-contained, interactive script.
- **bin/**: Executable scripts, each with a focused purpose.
- **scripts/**: Utility and enhancement scripts.
- **docs/**: Topical documentation.
- **external/**: Integrations and configs for third-party tools.
- **data/**: Data files, e.g., `anime_quotes.txt` for motivational UI.
- **shortcuts/**: Shell aliases and shortcuts.
- **prompts/**: Prompt engineering for AI.

---

## 4. Quick Reference Tables

### Project Root
| File/Dir                  | Description                                      | Key Commands/Usage                |
|--------------------------|--------------------------------------------------|-----------------------------------|
| README.md                | Project overview, setup, philosophy              | `cat README.md`                   |
| install.sh               | Main installer                                   | `bash install.sh`                 |
| lab.sh                   | Main interactive shell interface                 | `bash lab.sh`                     |
| bill_command_center.sh   | Central orchestrator script                      | `bash bill_command_center.sh`     |
| ...                      | ...                                              | ...                               |

### lib/
| File                        | Description                                  | Key Functions/Usage               |
|-----------------------------|----------------------------------------------|-----------------------------------|
| adaptive_learning.sh        | Adaptive learning, feedback, adaptation      | `source lib/adaptive_learning.sh` |
| call_llm.sh / call_llm_v2.sh| LLM abstraction (local/cloud AI)             | `llm`, `call_llm`                 |
| error_handling.sh           | Centralized error handling                   | `source lib/error_handling.sh`    |
| ...                         | ...                                          | ...                               |

### modules/
| Module                                 | Description                                 | Example Usage                    |
|----------------------------------------|---------------------------------------------|----------------------------------|
| automation_mastery_interactive.sh      | Automation guide, tool selection, workflows | `bash modules/automation_mastery_interactive.sh` |
| data_hoarding_interactive.sh           | Media management, FileBot integration       | `bash modules/data_hoarding_interactive.sh`      |
| privacy_tools_interactive.sh           | VPN, Tor, privacy tools                     | `bash modules/privacy_tools_interactive.sh`      |
| ...                                    | ...                                         | ...                              |

### bin/
| Script                  | Description                                  | Example Usage                    |
|-------------------------|----------------------------------------------|----------------------------------|
| bill-sloth              | Main launcher                                | `bin/bill-sloth`                 |
| local-first-router      | Local-first intelligence router              | `bin/local-first-router`         |
| audit_workflow          | AI-powered workflow audit                    | `bin/audit_workflow <module>`    |
| voice-engine-installer  | Installs voice/intent tools                  | `bin/voice-engine-installer`     |
| ...                     | ...                                          | ...                              |

---

## 5. Key Modules, Scripts, and Libraries (Deeper Dive)

### lib/
- **adaptive_learning.sh**
  - Tracks usage, collects feedback, and triggers adaptation.
  - Functions: `init_adaptive_learning`, `log_usage`, `collect_feedback`, `log_feedback`, `schedule_adaptation`, `generate_adaptation`.
  - Usage: Sourced by all interactive modules; logs user satisfaction and triggers improvements.
- **call_llm.sh / call_llm_v2.sh**
  - Abstracts LLM calls (local/cloud), logs prompts, and handles fallback.
  - Functions: `llm`, `call_llm`, `call_llm_manual`.
  - Usage: Used by audit scripts, adaptation, and any AI-powered feature.
- **error_handling.sh**
  - Centralizes error reporting, logging, and fallback logic.
  - Usage: Sourced by all critical scripts; ensures consistent error messages and safe exits.
- **voice_control.sh**
  - Handles voice command parsing, intent recognition, and routing.
  - Integrates with voice2json, Rhasspy, and custom daemons.
- **backup_management.sh / restic_backup.sh**
  - **MATURE TOOLS UPDATE (2025):** Migrated to restic-based backup with deduplication and encryption, wrapped in Bill Sloth friendly notifications.
  - `restic_backup.sh` provides `bill_backup()`, `bill_backup_list()`, and `bill_restore()` functions.
  - Legacy `backup_management.sh` maintained for compatibility.
- **task_runner.sh**
  - **NEW (2025):** Modern task runner replacing complex JSON workflow system.
  - Uses Just/Make/shell for simple, readable task definitions.
  - Functions: `run_task()`, `list_tasks()`, `create_task_template()`.
- **data_persistence.sh**
  - **NEW (2025):** SQLite-based data persistence replacing file-based JSON caching.
  - Functions: `store_data()`, `get_data()`, `log_task_execution()`, `store_vrbo_booking()`.
  - Maintains JSON file fallback for systems without SQLite.
- **service_management.sh**
  - **IMPLEMENTED (2025):** Systemd user service management replacing custom daemon implementations.
  - Functions: `create_bill_service()`, `start_service()`, `service_dashboard()`.
  - Provides fallback to custom process management for systems without systemd.
- **cross_module_integration.sh**
  - **NEW (2025):** Seamless workflow orchestration between all Bill Sloth modules.
  - Functions: `integrate_vrbo_to_tasks()`, `integrate_edboigames_to_media()`, `integrate_health_to_notifications()`.
  - Automatic task creation, data sharing, and workflow triggering across modules.
- **filebot_integration.sh**
  - **NEW (2025):** Professional media processing using FileBot with Bill Sloth personality.
  - Functions: `process_edboigames_content()`, `smart_media_organize()`.
  - Graceful fallback to basic file handling when FileBot unavailable.
- **kanboard_integration.sh**
  - **NEW (2025):** Task management via Kanboard API with local storage fallback.
  - Functions: `create_vrbo_task()`, `create_content_task()`, `show_task_dashboard()`.
  - Integrates professional task management while maintaining Bill Sloth workflow patterns.
- **interactive.sh**
  - Provides shared UI logic: banners, color, input validation, and menu rendering.

### modules/
- **automation_mastery_interactive.sh**
  - Guides users through automating their digital life.
  - Features: Workflow assessment, tool selection (n8n, cron, IFTTT), personalized recommendations, and direct installation.
  - Example: Presents pros/cons of each automation tool, logs user choices, and adapts future recommendations.
- **data_hoarding_interactive.sh**
  - Media management, renaming, and organization.
  - Integrates with FileBot for automated renaming.
  - Example: Prompts user for media type, runs FileBot, and logs results.
- **privacy_tools_interactive.sh**
  - VPN, Tor, and privacy best practices.
  - Features: Tool selection, installation, and usage logging.
- **system_doctor_interactive.sh**
  - Diagnostics, repair, and health checks.
  - Features: Disk, memory, and network diagnostics; logs all actions.
- **edboigames_toolkit_interactive.sh**
  - Gaming optimization, controller setup, and performance tweaks.
  - Features: Presents mature tools (Lutris, MangoHUD), logs choices, and adapts recommendations.
- **productivity_suite_interactive.sh**
  - Kanban, Taskwarrior, and ADHD-friendly productivity tools.
  - Features: Presents options, explains pros/cons, logs choices, and adapts future menus.
- **personal_analytics_dashboard.sh**
  - **NEW (2025):** Comprehensive life tracking and productivity insights for ADHD brains.
  - Features: Daily mood/energy tracking, task completion analytics, business metrics, pattern insights.
  - SQLite-based with automated correlation analysis and actionable recommendations.
- **finance_management_interactive.sh**
  - **NEW (2025):** Complete personal and business finance management system.
  - Features: Income/expense tracking, budgeting, financial goals, tax preparation.
  - Separate tracking for VRBO and EdBoiGames businesses with cross-module integration.
- **All *_interactive.sh**
  - Follow the same choose-your-own-adventure, ADHD-friendly pattern.
  - Log user choices, present pros/cons, and allow open-ended input for AI.
  - **ENHANCED (2025):** All modules now integrate with cross-module system for seamless workflows.
- **Subdirectories**
  - Contain advanced or specialized scripts for power users (e.g., `automation_mastery/`, `edboigames/`).

### Root Directory Files
- **justfile**
  - **IMPLEMENTED (2025):** Complete task automation system with 50+ ADHD-friendly commands.
  - Categories: System Health, VRBO Management, EdBoiGames Content, Analytics, Integration Testing.
  - Usage: `just` (show menu), `just health` (system check), `just vrbo-guest "Name" "Property" "Date"`.
  - Integration: Calls FileBot, Kanboard, restic, and cross-module systems with graceful fallbacks.
- **CLAUDE.md**
  - **NEW (2025):** Project-specific Claude Code memory and context management.
  - Contains team structure, architecture overview, development workflow, session management.
  - Integration with Claude Code robustness system for session corruption prevention.

### bin/
- **bill-sloth**
  - Main launcher; sets up environment, launches menu, and logs session.
- **local-first-router**
  - Routes requests to local solutions first (voice2json, Rhasspy), then cloud AI if needed.
  - Fallbacks: Pattern matching if mature tools unavailable.
- **audit_workflow**
  - Runs AI-powered audits on any workflow/module.
  - Prompts LLM for suggestions, logs output, and displays in TUI.
- **voice-engine-installer**
  - Installs/configures mature voice/intent recognition tools.
  - Checks for dependencies, downloads profiles, and verifies installation.
- **system-health**
  - Launches `glances` or other mature system health tools.
- **capability-installer/tracker**
  - Installs and tracks system capabilities (e.g., VPN, AI, media tools).
- **voice-assistant-daemon**
  - Background process for voice command handling; integrates with router and modules.
- **bill-brain**
  - Pattern learning and suggestion engine; logs user patterns and suggests improvements.
- **smart-reminders**
  - Reminder and notification system; logs reminders and user responses.
- **vrbo-smart-manager**
  - Workflow for vacation rental management; integrates with calendar and reminders.
- **hotkey-system**
  - Global hotkey management; allows quick access to workflows.
- **autostart-billsloth**
  - Ensures Bill Sloth starts on login; manages autostart entries.

### scripts/
- **generate_module_docs.sh**
  - Parses modules and auto-generates documentation; ensures docs stay in sync with code.
- **health_check_v2.sh**
  - Advanced, multi-metric health check; logs results and suggests fixes.
- **test_phase1_improvements.sh**
  - Automated test suite for recent changes; logs results and flags regressions.
- **first_time_setup.sh**
  - Wizard for new users; sets up preferences, environment, and logs onboarding.
- **batch_enhance_modules.sh**
  - Injects adaptive learning logic into all modules; creates backups and logs changes.
- **apply_adaptive_learning.sh**
  - Applies user feedback to modules; triggers adaptation and logs results.

---

## 6. Architectural Patterns & Conventions (Deeper Dive)
- **Interactive Assistant Pattern**
  - All major workflows use a consistent, ADHD-friendly, choose-your-own-adventure interface.
  - Example: Each module presents a menu, explains options, logs choices, and adapts future menus based on feedback.
- **Mature-Tool-First** 
  - Every workflow prefers mature, open-source tools (e.g., FileBot, Kanboard, voice2json).
  - Custom logic is fallback only, clearly marked as legacy.
  - **MIGRATION UPDATE (2025):** System migrated to use restic (backup), fd/ripgrep/fzf (file operations), Netdata (monitoring), Just (task running), SQLite (data persistence), and systemd (process management) while preserving Bill Sloth personality and ADHD-friendly UX.
- **Adaptive Learning**
  - Feedback and usage are tracked for every module.
  - Satisfaction scores trigger adaptation (e.g., menu reordering, new tool suggestions).
- **Comprehensive Logging**
  - All user choices, feedback, and system actions are logged (e.g., `~/.bill-sloth/feedback/`, `~/.bill-sloth/usage/`).
- **Backup & Rollback**
  - Scripts create backups before modification (e.g., `batch_enhance_modules.sh`).
  - Rollback logic ensures safe recovery from failed adaptations.
- **Consistent Naming**
  - All modules/scripts use clear, descriptive names (e.g., `automation_mastery_interactive.sh`).
  - Subdirectories group advanced/specialized scripts.

---


## 7. Adaptive Learning & AI Integration (Deeper Dive)
- **Adaptive Learning System**
  - Tracks usage (feature access, completion), collects feedback (quick and detailed), and adapts modules based on satisfaction scores.
  - Example: If a user rates a tool as "wrong for my workflow," the system prompts for alternatives and adapts future menus.
- **AI-Powered Auditing**
  - `audit_workflow` script uses local/cloud LLMs to review modules, suggest mature FOSS replacements, and log findings.
  - Example: Bill can run `audit_workflow streaming_setup` to get AI-curated upgrade ideas.
- **LLM Abstraction**
  - `call_llm.sh` and `call_llm_v2.sh` route prompts to local (Ollama) or cloud (Claude) AI, with logging and fallback.
  - Example: If local AI fails, system falls back to Claude Code.
- **Token Efficiency**
  - System minimizes cloud AI usage, preferring local inference when possible.
  - Example: Only uses Claude tokens for custom feedback or when local models are unavailable.
- **Batch Enhancement**
  - Scripts like `batch_enhance_modules.sh` can inject adaptive learning logic into all modules, ensuring consistency and rapid rollout of improvements.

---

## 8. Voice, Accessibility & UX (Deeper Dive)
- **Voice Integration**
  - Deep integration with voice2json, Rhasspy, and custom daemons.
  - Example: `local-first-router` checks for mature voice engines, falls back to pattern matching if unavailable.
- **Accessibility**
  - All modules are designed for ADHD/dyslexia, with visual banners, color, and progressive disclosure.
  - Example: ASCII art, color-coded menus, and motivational quotes from `anime_quotes.txt`.
- **Feedback Loops**
  - Users are prompted for feedback after each workflow, with options for quick (1-5) or detailed (custom) input.
  - Example: Satisfaction scores are logged and used to adapt future menus.
- **Memory Support**
  - Persistent logging of user choices and reminders (e.g., `smart-reminders`, `~/.bill-sloth/feedback/`).
- **Motivational UI**
  - Anime quotes, ASCII art, and gamified feedback to keep users engaged and motivated.

---

## 9. Security, Backup & Error Handling (Deeper Dive)
- **Security**
  - Defensive cyber modules (e.g., `defensive_cyber_interactive.sh`), privacy tools, and clear warnings for destructive actions.
  - Example: VPN/Tor setup, kill switch logic, and security audits.
- **Backup**
  - Automatic backup creation before modifications (e.g., before adaptive learning injections).
  - Rollback support for failed operations (e.g., restore from backup if enhancement fails).
- **Error Handling**
  - Centralized error handling in `lib/`, consistent error messages, and fallback logic.
  - Example: If a tool fails to install, system logs the error and suggests alternatives.
- **Safety**
  - Confirmation prompts for destructive operations, and kill switch logic for emergency stops.

---

## 10. Documentation & Testing (Deeper Dive)
- **Comprehensive Documentation**
  - Multiple levels: user guides, developer docs, audits, philosophy, changelog.
  - Example: `DEVELOPER_GUIDE.md` (3,000+ lines), `self-executing-guide.md` for onboarding.
- **Auto-Generated Docs**
  - Scripts like `generate_module_docs.sh` ensure documentation stays in sync with code.
- **Testing**
  - Test scripts for health checks, phase completion, and batch enhancements (e.g., `test_phase1_improvements.sh`).
  - Example: Automated tests log results and flag regressions.
- **Methods Log**
  - All breakthroughs, setbacks, and research areas are logged in `methods_log.md` for transparency and continuous improvement.

---

## 11. Unique Features & Observations (Deeper Dive)
- **Self-Modifying Code**
  - Modules adapt based on user feedback and AI suggestions.
  - Example: If a user consistently rates a tool poorly, the system suggests and installs alternatives.
- **Token-Efficient AI**
  - Smart use of Claude tokens with local fallbacks; only uses cloud AI when necessary.
- **Visual-First Interface**
  - Extensive ASCII art, color, and motivational UI to reduce cognitive load and increase engagement.
- **Comprehensive Tool Integration**
  - Covers entire Linux power-user workflow, from automation to gaming to privacy.
- **Neurodivergent Accessibility**
  - Every feature is designed for ADHD/dyslexia, with clear explanations, visual cues, and memory support.
- **Overlay Model (Planned)**
  - Future-proofing for overlays and adaptation tracking; will allow safe, reversible customizations.

---

## 12. Notable Configuration, Data, and State Files
- external/linux-voice-control/lvc-commands.json, lvc-config.json: JSON schemas for voice command mapping and configuration.
- external/linux-voice-control/requirements.txt: Python dependencies for voice control.
- external/linux-voice-control/gui/data/flutter_assets/fonts/MaterialIcons-Regular.otf, .../CupertinoIcons.ttf: Font assets for GUI.
- external/linux-voice-control/gui/data/flutter_assets/shaders/ink_sparkle.frag: Shader for GUI effects.
- external/linux-voice-control/gui/data/flutter_assets/NOTICES.Z: License and notice aggregation for Flutter assets.
- external/linux-voice-control/lvc_gui_flutter/pubspec.yaml: Flutter project dependencies and assets.

---

## 13. Additional Integrations, Data, and Configuration

### external/linux-voice-control/
- Purpose: Advanced, modular voice control system with Python, Flutter, and native integrations.
- Key Components:
  - main.py, utils.py, notifier.py, command_manager.py, config_manager.py, chatgpt_port.py, master_control_mode_setup.py, master_mode_manager.py, live_mode_manager.py, live_mode_setup.py, basic_mode_manager.py: Python scripts for voice command processing, feedback, and control modes.
  - requirements.txt: Python dependencies for voice control.
  - update.sh, install.sh, dry-run.sh, build-gui-bundle.sh: Setup, update, and build scripts.
  - lvc-commands.json, lvc-config.json: Voice command and configuration schemas.
  - voice_feedback.py: Handles voice feedback and error reporting.
  - notifier.py: Notification system for voice events.
  - pretrained_models/: Contains model checkpoints for speaker recognition and ASR (see below).
  - misc/: Contains MP3 feedback files for various system events.
  - images/: PNG and GIF assets for documentation and UI.
  - gui/: Compiled Flutter GUI assets and libraries.
  - lvc_gui_flutter/: Full Flutter GUI source, including Dart, Android, and Linux build files.
  - README.md, LICENSE, CODE_OF_CONDUCT.md: Documentation and community standards.

#### pretrained_models/
- spkrec-ecapa-voxceleb, asr-crdnn-rnnlm-librispeech, EncoderClassifier-...: Each contains model checkpoints (.ckpt), hyperparameters, and label encoders for voice/speaker recognition and ASR.

#### misc/
- network-error.mp3, greeting.mp3, internal-voice-feedback-error.mp3, live_mode-feedback.mp3, execution-feedback.mp3, exiting-feedback.mp3: Audio feedback for system events.

#### gui/data/flutter_assets/
- fonts, shaders, packages, version.json, NOTICES.Z, AssetManifest.json, FontManifest.json: Flutter asset management for the GUI.

#### lvc_gui_flutter/
- lib/ui/: Dart UI components for the voice control GUI.
- android/app/src/main/kotlin/com/omegaui/lvc_gui_flutter/MainActivity.kt: Android entry point for the GUI.
- linux/flutter/: CMake and plugin registration for Linux builds.
- pubspec.yaml, pubspec.lock, analysis_options.yaml: Flutter/Dart project configuration.

---

## 14. Advanced Developer/Contributor Details

- Python, Dart, and C++ Integration: The voice control system spans Python (core logic), Dart (GUI), and C++ (Linux plugin registration).
- Build and Packaging Scripts: build-gui-bundle.sh, update.sh, and platform-specific build files for easy deployment.
- Testing and Linting: analysis_options.yaml for Dart linting; test directories (if present) for module/unit tests.
- Flutter Asset Management: Asset manifests, font management, and shader integration for a polished GUI.

---

## 15. Example Usage Snippets

- **Run the main menu:**
  ```bash
  bash lab.sh
  ```
- **Audit a workflow:**
  ```bash
  bin/audit_workflow automation_mastery_interactive
  ```
- **Install all dependencies:**
  ```bash
  bash install.sh
  ```
- **Run a specific module interactively:**
  ```bash
  bash modules/productivity_suite_interactive.sh
  ```
- **Check system health:**
  ```bash
  bin/system-health
  ```

---

## 16. Frequently Asked Questions (FAQ)

**Q: What is Bill Sloth?**
A: A local-first, adaptive Linux assistant for neurodivergent users, focused on mature open-source tools and self-improvement.

**Q: How do I add a new workflow/module?**
A: Copy an existing `_interactive.sh` module, follow the interactive assistant pattern, and update `MODULE_INDEX.md`.

**Q: How does the system adapt to my feedback?**
A: Usage and satisfaction are logged; low scores trigger adaptation, menu reordering, or new tool suggestions.

**Q: Can I use Bill Sloth without cloud AI?**
A: Yes! The system prefers local AI (Ollama, voice2json) and only uses cloud AI as a fallback.

**Q: How do I recover from a failed adaptation or script error?**
A: All changes are backed up; use the rollback scripts or restore from backup directories.

---

## 17. Glossary

- **ADHD-Friendly:** Designed for users with attention, memory, or executive function challenges.
- **Local-First:** Prefers running everything locally for privacy and speed.
- **Overlay Model:** Planned system for safe, reversible customizations via overlays instead of direct file edits.
- **Interactive Assistant Pattern:** Menu-driven, choose-your-own-adventure UI with pros/cons and feedback.
- **Ollama:** Local LLM (AI) engine for private, offline inference.
- **Claude Code:** Cloud-based AI assistant, used as fallback.
- **FileBot:** Mature open-source tool for media renaming/organization.
- **Kanboard:** Open-source Kanban board for task management.
- **Voice2json/Rhasspy:** Mature, offline voice/intent recognition engines.

---

## 18. Overlay/Adaptation Model (Expanded)

**Goal:** Allow safe, reversible customizations and AI-powered adaptations without modifying original modules.

**Workflow Example:**
1. User gives negative feedback on a module.
2. System creates an overlay file (e.g., `overlays/automation_mastery_interactive.sh`) with the adaptation.
3. At runtime, both the original and overlay are sourced:
   ```bash
   source modules/automation_mastery_interactive.sh
   [ -f overlays/automation_mastery_interactive.sh ] && source overlays/automation_mastery_interactive.sh
   ```
4. Overlays can add, override, or reorder menu options, inject new tools, or change UI.
5. All overlays are tracked in a manifest for audit and rollback.

**Diagram:**
```mermaid
graph TD;
  A[Original Module] --> B[Overlay File];
  B --> C[Runtime Composition];
  C --> D[User Experience];
```

---

## 19. Troubleshooting & Recovery

- **Problem:** A module fails to load or crashes.
  - **Solution:** Check logs in `~/.bill-sloth/feedback/` and `~/.bill-sloth/usage/`. Restore from backup if needed.
- **Problem:** Adaptation causes unwanted changes.
  - **Solution:** Remove or edit the relevant overlay file in `overlays/`.
- **Problem:** Voice commands not recognized.
  - **Solution:** Run `bin/voice-engine-installer` to reinstall/configure voice engines.
- **Problem:** System health check fails.
  - **Solution:** Run `bin/system-health` and follow the suggested fixes.
- **Problem:** Cloud AI not available.
  - **Solution:** Ensure local AI (Ollama) is installed, or check network for Claude Code.

---

## 20. Contribution & Community Guidelines

- **How to Contribute:**
  1. Fork the repo and create a feature branch.
  2. Add or improve a module, following the interactive assistant pattern.
  3. Update documentation and `MODULE_INDEX.md`.
  4. Run tests and ensure all scripts pass.
  5. Submit a pull request with a clear description.
- **Code Style:**
  - Use clear, descriptive names and comments.
  - Follow the menu-driven, ADHD-friendly UI pattern.
  - Prefer mature, open-source tools over custom logic.
- **Community Values:**
  - Accessibility, transparency, and continuous improvement.
  - Respect for neurodivergent users and contributors.

---

## 21. Change History Highlights

### MAJOR INFRASTRUCTURE COMPLETION (January 2025)

**✅ CRITICAL INFRASTRUCTURE IMPLEMENTED:**
- **Ultimate Dashboard Fixed:** Connected to actual Bill Sloth modules with real data persistence and cross-module integration status
- **Complete Justfile:** 50+ ADHD-friendly commands covering all workflows (health, backup, VRBO, EdBoiGames, analytics, integration)
- **SQLite Data Persistence:** Comprehensive schema with tables for tasks, bookings, content, health metrics, personal analytics, and finance
- **Cross-Module Integration:** Seamless workflows between VRBO → Tasks, EdBoiGames → Media Processing, System Health → Notifications

**✅ MATURE TOOL INTEGRATION COMPLETED:**
- **FileBot Integration:** Professional media processing for EdBoiGames content with Bill Sloth personality preserved
- **Kanboard Integration:** Professional task management with API integration and local storage fallback
- **restic Backup System:** Deduplication and encryption with friendly notifications and Bill-specific backup sets
- **Netdata Monitoring:** System metrics dashboard with custom module health checks

**✅ MISSING MODULES IMPLEMENTED:**
- **Personal Analytics Dashboard:** Life tracking, mood/energy patterns, productivity insights, business metrics correlation
- **Finance Management Suite:** Income/expense tracking, budgeting, financial goals, tax preparation for VRBO and EdBoiGames businesses
- **Cross-Module Workflow Orchestration:** Automatic task creation, data sharing, and intelligent workflow triggering

**✅ CLAUDE CODE ROBUSTNESS:**
- **Session Corruption Prevention:** claunch installation, global recovery procedures, session health monitoring
- **Project-Specific Recovery:** Bill Sloth-integrated backup and recovery using existing data persistence systems
- **Emergency Procedures:** Complete diagnostic and repair workflows with integration testing

**RESULT:** System is now production-ready with all documented promises fulfilled. Gap between documentation and implementation eliminated.

## 22. Previous Change History

- **v2.0-Adaptive:** Full migration to interactive assistant pattern, mature-tool-first philosophy, and adaptive learning.
- **Overlay Model Planned:** Architectural groundwork for overlays and safe adaptation.
- **Local AI Integration:** Ollama and voice2json/Rhasspy support.
- **Comprehensive Documentation:** GIGA DOC, developer guide, and self-executing guide.
- **AI-Powered Auditing:** `audit_workflow` script for continuous improvement.
- **Accessibility First:** All modules redesigned for ADHD/dyslexia.

---

## 22. Additional Recommendations

- Document all configuration schemas (e.g., lvc-commands.json, lvc-config.json) with example entries and usage.
- Add a section on model management: How to add/update pretrained models for voice/speaker recognition.
- Expand GUI documentation: Describe the purpose and usage of each Dart UI component and how to build/run the GUI.
- Clarify cross-language integration: Document how Python, Dart, and C++ components interact in the voice control system.
- List all audio feedback events: Map each MP3 file to its triggering event for clarity.
- Add developer onboarding for external integrations: Step-by-step for setting up, building, and testing the voice control stack.

---

## 23. Example: Documenting a Missing Detail

external/linux-voice-control/lvc-commands.json
```json
{
  "commands": [
    {
      "phrase": "open browser",
      "action": "launch_app",
      "target": "firefox"
    },
    {
      "phrase": "play music",
      "action": "media_control",
      "target": "play"
    }
  ]
}
```
*This file maps spoken phrases to system actions and targets. It is loaded by main.py and used by the command_manager.py to trigger the correct automation.*

---

## 24. Additional Quick Reference Table: external/linux-voice-control

| File/Dir                | Description                                 | Key Usage/Notes                |
|-------------------------|---------------------------------------------|--------------------------------|
| main.py                 | Voice control entry point                   | `python3 main.py`              |
| requirements.txt        | Python dependencies                         | `pip install -r requirements.txt` |
| lvc-commands.json       | Voice command mapping                       | Loaded by main.py              |
| lvc-config.json         | Voice system configuration                  | Loaded by main.py              |
| pretrained_models/      | ASR and speaker recognition models          | Used by main.py and utils.py   |
| misc/                   | Audio feedback files                        | Played on system events        |
| gui/                    | Compiled Flutter GUI assets                 | Used by main.py                |
| lvc_gui_flutter/        | Flutter GUI source                          | Build with `flutter build`     |
| images/                 | PNG/GIF assets for docs and UI              |                                |
| .github/, .idea/        | Project metadata and configuration          |                                |

--- 

---

## 25. Deep Per-Module Documentation

### bill_command_center.sh

**Purpose:**  
Central orchestrator and unified entry point for the entire Bill Sloth system, providing a dashboard-style interface for all major workflows, system status, and automation management.

**Key Features:**
- Unified dashboard with system status, quick actions, and module access
- Real-time health monitoring and issue detection  
- **MATURE TOOLS UPDATE (2025):** Multiple mature tool integrations:
  - Restic-based backup system with deduplication and encryption
  - Just-based task runner for simple workflow execution
  - SQLite data persistence for reliable cross-module data sharing
  - All wrapped in ADHD-friendly notifications and Bill Sloth personality
- Bill-specific automation shortcuts (VRBO, EdBoiGames, Google Tasks)
- Modern task execution with `just backup-all`, `just health-check`
- Activity logging and user preference tracking in structured database

**Main Functions:**
- `init_bill_command_center`: Initializes all core systems and creates directory structure
- `show_system_status`: Real-time display of system health, backup status, and module availability  
- `show_quick_actions`: One-click access to most common Bill workflows
- Enhanced backup management with restic integration and user-friendly interface

**Integration Points:**
- **Modern Backup**: Prioritizes `bill_backup` (restic-based) over legacy backup system
- **Task Execution**: Uses Just task runner for `backup-all`, `health-check`, `vrbo-guest-onboard` workflows
- **Data Persistence**: SQLite database for reliable cross-module data sharing and user preferences
- **Health Monitoring**: Hybrid approach using Netdata for system metrics + custom module health checks
- **Cross-Module**: Orchestrates data sharing between VRBO, EdBoiGames, and productivity modules with structured storage

**Accessibility & UX:**
- ASCII art banners, color-coded status indicators, and motivational language
- Dashboard-style interface reduces cognitive load for ADHD users
- Educational tooltips and gentle error handling

**Example Usage:**
```bash
bash bill_command_center.sh
```
Opens the main dashboard with all system tools and workflows accessible from one interface.

---

### automation_mastery_interactive.sh

**Purpose:**  
Comprehensive, interactive automation mastery suite, providing a neurodivergent-friendly guide to modern automation, cloud tools, AI-powered workflows, and personal productivity.

**Key Features:**
- Menu-driven, step-by-step automation setup for all major digital workflows
- Personalized workflow assessment and recommendations
- Bill-specific automation setup (VRBO, Google Tasks, ChatGPT, Excel replacement, etc.)
- Integrates cloud automation, AI tools, and neurodivergent accommodations
- Logs user choices and adapts future recommendations

**Main Functions:**
- `assess_personal_workflows`: Guided assessment for personalized automation
- `setup_bill_specific_automations`: Menu for Bill's most common automation needs
- `setup_vrbo_automation`, `setup_google_tasks_automation`, etc.: Sub-workflows for each automation domain
- Each sub-workflow creates directories, scripts, and config files as needed

**Example Usage:**  
Run the module to receive a personalized, ADHD/dyslexia-friendly automation setup for all major digital workflows, with Bill-specific options and cloud/AI integration.

**Integration Points:**
- Integrates with all major automation, productivity, and AI tools
- Can be extended with new workflows and integrations

**Accessibility & UX:**
- Emoji, banners, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames_toolkit_interactive.sh

**Purpose:**  
Comprehensive, interactive business toolkit for EdBoiGames, providing adaptive tools for gaming business operations, content creation, and channel growth.

**Key Features:**
- Menu-driven, adaptive interface for business and content creation tools
- Detects user focus (business vs. content) and adapts UI and recommendations
- Integrates business development, video production, optimization, and education modules
- Logs user choices and adapts future recommendations

**Main Functions:**
- Adaptive content selection and focus detection
- `explain_youtube_business`, `explain_content_strategy`, etc.: Educational and operational guides
- Loads and delegates to all subcomponents (business, content, optimization, etc.)

**Example Usage:**  
Run the module to access a unified, ADHD/dyslexia-friendly toolkit for EdBoiGames business and content operations, with adaptive learning and feedback.

**Integration Points:**
- Integrates with all EdBoiGames business and content modules
- Can be extended with new tools and workflows

**Accessibility & UX:**
- Emoji, banners, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### data_hoarding_interactive.sh

**Purpose:**  
Interactive assistant for data hoarding, presenting mature open-source tools for media management, explaining pros/cons, logging user choices, and allowing open-ended input for further AI suggestions.

**Key Features:**
- Pirate-themed, ADHD/dyslexia-friendly interface with ASCII art and color
- Menu-driven selection of mature tools for downloading, organizing, and streaming media (yt-dlp, *arr stack, Beets, Jellyfin, TagSpaces, ExifTool, Gluetun VPN, etc.)
- Explains each tool's benefits, ADHD-friendly features, and learning curve
- Logs user choices and allows "other" for open-ended AI suggestions
- Integrates with Claude Code for advanced/other options

**Main Functions:**
- `data_hoarding_interactive`: Main menu and workflow for tool selection and education
- Presents pros/cons, usage tips, and ADHD-friendly notes for each tool
- Logs user choices and invokes AI for custom needs

**Example Usage:**  
Run the module to choose and learn about the best FOSS tools for data hoarding, with ADHD-friendly explanations and the option to ask for more via AI.

**Integration Points:**
- Integrates with all recommended FOSS tools and the Claude Code AI assistant
- Can be extended with new tools and workflows

**Accessibility & UX:**
- Pirate theme, ASCII art, color, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### privacy_tools_interactive.sh

**Purpose:**  
Guides users through setting up a privacy-first digital environment using mature, open-source tools.

**Key Features:**
- Menu of privacy tools: Nextcloud, local voice assistants, VPN, Tor, safe torrenting, and a complete privacy suite.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with system VPN, Tor Browser, and local AI.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- Menu-driven selection and setup of privacy tools.
- For each tool, provides install/config instructions and usage tips.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/privacy_tools_interactive.sh
```
User selects privacy tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (Nextcloud, Tor, VPN, etc.).
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Clear, motivational language and visual cues.
- Designed to reduce digital overwhelm and support self-reliance.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### system_doctor_interactive.sh

**Purpose:**  
A comprehensive troubleshooting and diagnostics toolkit for Linux, designed to replace and surpass Windows Device Manager, Disk Management, and other troubleshooters.

**Key Features:**
- Menu-driven access to hardware, storage, network, audio, and display diagnostics.
- Integrates with mature tools: lspci, lsusb, hwinfo, smartctl, sensors, fsck, journalctl, systemctl, etc.
- AI-powered diagnosis and plain-English explanations.
- Logs all actions and saves troubleshooting steps for future reference.

**Main Functions:**
- `explain_system_doctor`: Explains the toolkit and its features.
- `install_diagnostic_tools`: Installs all required diagnostic tools.
- Sub-menus for hardware, storage, network, audio, and display troubleshooting.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/system_doctor_interactive.sh
```
User is guided through diagnostics and troubleshooting for any system issue.

**Integration Points:**
- Calls out to system diagnostic tools.
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Visual banners, color, and plain-English explanations.
- Step-by-step guidance to reduce overwhelm.

**Error Handling & Recovery:**
- Backs up config before changes.
- Logs errors and provides recovery steps.

---

### productivity_suite_interactive.sh

**Purpose:**  
An interactive assistant for ADHD-friendly productivity, task management, and knowledge organization.

**Key Features:**
- Menu of productivity tools: Taskwarrior, Super Productivity, Logseq, Kanboard, ADHD Memory Palace.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with Kanboard, Taskwarrior, and other mature tools.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- Menu-driven selection and setup of productivity tools.
- For each tool, provides install/config instructions and usage tips.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/productivity_suite_interactive.sh
```
User selects productivity tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (Kanboard, Taskwarrior, etc.).
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Brain-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### system_ops_interactive.sh

**Purpose:**  
Provides essential system operations and troubleshooting tools to automate updates, fix common issues, and monitor system health, all with a focus on saving tokens and reducing repetitive manual work.

**Key Features:**
- One-command system update for all major package managers (apt, snap, flatpak)
- Automated update of Ollama LLM models if present
- Audio troubleshooting (PulseAudio, ALSA, PipeWire)
- Network reset and troubleshooting
- Display/server troubleshooting (GDM, LightDM, SDDM)
- Quick system health check (CPU, RAM, Disk, GPU)

**Main Functions:**
- `update_everything`: Updates all system packages and LLM models
- `fix_audio`: Restarts audio subsystems and drivers
- `fix_network`: Resets network stack and DHCP
- `fix_display`: Provides display troubleshooting steps
- `check_system_health`: Prints quick stats for CPU, RAM, Disk, and GPU

**Example Usage:**  
Run the module to quickly update the system, fix audio/network/display issues, or check system health before troubleshooting further.

**Integration Points:**
- Integrates with all major Linux package managers
- Detects and updates Ollama models if installed

**Accessibility & UX:**
- Emoji and clear language for each operation
- Designed for minimal cognitive load and rapid recovery

**Error Handling & Recovery:**
- Handles missing commands gracefully (e.g., Ollama, nvidia-smi)
- Provides actionable output for each fix

---

### repetitive_tasks_interactive.sh

**Purpose:**  
Legacy module for automating repetitive tasks; now deprecated and redirects to the more comprehensive automation_mastery_interactive.sh.

**Key Features:**
- Redirects user to the new automation mastery module.
- Explains new features and improvements.

**Main Functions:**
- Prints deprecation notice and launches automation_mastery_interactive.sh.

**Example Usage:**
```bash
bash modules/repetitive_tasks_interactive.sh
```
User is redirected to the new automation module.

**Integration Points:**
- Calls automation_mastery_interactive.sh.

**Accessibility & UX:**
- Clear deprecation notice and smooth redirection.

**Error Handling & Recovery:**
- N/A (redirects to maintained module).

---

### clipboard_mastery_interactive.sh

**Purpose:**  
Advanced clipboard management for Linux, with AI integration and ADHD-friendly features.

**Key Features:**
- Menu-driven setup for CopyQ and other clipboard tools.
- AI-powered clipboard history, categorization, and content detection.
- Features: unlimited history, OCR, formatting, global hotkeys, cross-device sync.
- Explains each tool's benefits and setup process.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- `explain_clipboard_power`: Explains advanced clipboard management.
- `install_copyq`: Installs and configures CopyQ.
- Menu-driven selection and setup of clipboard tools.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/clipboard_mastery_interactive.sh
```
User selects clipboard tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (CopyQ, OCR, etc.).
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Clipboard-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### kodi_setup_interactive.sh

**Purpose:**  
Guides users through installing and configuring Kodi with premium debrid services for high-quality streaming.

**Key Features:**
- Menu-driven setup for Kodi, Real-Debrid, AllDebrid, Premiumize, and related streaming tools.
- Explains legal considerations, debrid services, and streaming best practices.
- Integrates with mature streaming tools and debrid services.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- `explain_debrid`: Explains debrid services and their benefits.
- `install_kodi`: Installs and configures Kodi.
- Menu-driven selection and setup of streaming tools and services.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/kodi_setup_interactive.sh
```
User selects streaming tools and debrid services to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (Kodi, debrid services, VPN).
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Streaming-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### network_management_interactive.sh

**Purpose:**  
Comprehensive network configuration, security, and monitoring for Linux, with ADHD-friendly automation and visualization.

**Key Features:**
- Menu of network management tools: VPN setup (WireGuard, OpenVPN), firewall, monitoring, Wi-Fi, DNS, ad-blocking.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with mature network tools and adaptive learning.
- **MATURE TOOLS UPDATE (2025):** Now uses modern CLI tools (fd for fast configuration file discovery) with 10x performance improvement while maintaining ADHD-friendly UX.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- `init_network_management`: Initializes network management system and directories.
- `create_default_monitoring_config`: Sets up default monitoring configuration.
- `detect_network_capabilities`: Detects and adapts to available network tools.
- Menu-driven selection and setup of network management tools.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/network_management_interactive.sh
```
User selects network tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (nmcli, systemctl, iwconfig, etc.).
- Uses logging, error handling, and adaptive learning from `lib/`.

**Accessibility & UX:**
- Network-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### mobile_integration_interactive.sh

**Purpose:**  
Bridges Linux desktop and mobile devices for seamless workflows, file sync, notifications, and remote access.

**Key Features:**
- Menu of mobile integration tools: file sync, notification mirroring, remote desktop, clipboard sharing, media streaming.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with mature tools for device sync and remote access.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- `init_mobile_integration`: Initializes mobile integration system and directories.
- `create_default_device_config`: Sets up default device configuration.
- `create_default_sync_config`: Sets up default sync rules.
- Menu-driven selection and setup of mobile integration tools.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/mobile_integration_interactive.sh
```
User selects mobile integration tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools and APIs for device sync and remote access.
- Uses logging, error handling, and adaptive learning from `lib/`.

**Accessibility & UX:**
- Mobile-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### launcher_mastery_interactive.sh

**Purpose:**  
Advanced application launching for Linux, with AI-powered suggestions, fuzzy search, and workflow automation.

**Key Features:**
- Menu of launcher tools: Rofi, AI-powered suggestions, custom commands, workflow automation.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with mature launcher tools and adaptive learning.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- `explain_launcher_power`: Explains advanced application launching.
- `install_rofi_launcher`: Installs and configures Rofi.
- Menu-driven selection and setup of launcher tools.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/launcher_mastery_interactive.sh
```
User selects launcher tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (Rofi, etc.).
- Uses logging and adaptive learning from `lib/`.

**Accessibility & UX:**
- Launcher-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### ai_setup_commands_interactive.sh

**Purpose:**  
Guides users through setting up a local AI development environment, with a menu of mature open-source tools for running, building, and experimenting with AI models.

**Key Features:**
- Menu of AI setup tools: Ollama, Hugging Face Transformers, Text Generation WebUI, Llama.cpp, LangChain, complete AI lab.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with mature AI frameworks and local model runners.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- Menu-driven selection and setup of AI development tools.
- For each tool, provides install/config instructions and usage tips.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/ai_setup_commands_interactive.sh
```
User selects AI development tools to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to system tools (Ollama, Python, etc.).
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- AI-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### discord_mod_toolkit_interactive.sh

**Purpose:**  
Comprehensive toolkit for Discord moderation, automation, and community management, with ADHD-friendly workflows.

**Key Features:**
- Menu of moderation tools: MEE6, Carl-bot, Dyno, Discord.py bots, specialized bots.
- Explains each tool's benefits, ADHD-friendly features, and setup process.
- Integrates with Discord bot APIs and moderation frameworks.
- Automation strategies for ADHD mods.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- `explain_discord_moderation`: Explains Discord moderation and core responsibilities.
- `explain_discord_bots`: Explains the Discord bot ecosystem.
- Menu-driven selection and setup of moderation tools and bots.
- Logs all actions and user feedback.

**Example Usage:**
```bash
bash modules/discord_mod_toolkit_interactive.sh
```
User selects moderation tools and bots to install and configure, with explanations and ADHD-friendly tips.

**Integration Points:**
- Calls out to Discord APIs and bot frameworks.
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Discord-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for tool installation and guides user through fixes.
- Logs errors and provides recovery steps.

---

### modules/edboigames/controller.sh

**Purpose:**  
Central controller for the EdBoiGames Business Toolkit, orchestrating all business, content creation, and optimization components with adaptive learning and a unified menu.

**Key Features:**
- Loads all EdBoiGames toolkit components (business, education, video, software, optimization)
- Adaptive learning: adjusts focus and recommendations based on user behavior
- Detects user focus (business vs. content creation) and adapts UI/banners
- Menu-driven interface for all business and creative tools
- Logs all actions and user choices

**Main Functions:**
- Sources all component scripts and libraries (interactive, adaptive_learning, etc.)
- Detects user focus and displays appropriate banner and menu
- `main_menu`: Unified menu for all toolkit features, dynamically adapts to user focus
- Loads and delegates to all subcomponents (business development, education, video, etc.)

**Example Usage:**  
Run the controller to access all EdBoiGames business, creative, and optimization tools from a single, adaptive menu.

**Integration Points:**
- Integrates with all EdBoiGames components and libraries
- Uses adaptive learning for personalized recommendations and UI

**Accessibility & UX:**
- Banner, emoji, and clear language for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing libraries and components gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/automation_mastery/controller.sh

**Purpose:**  
Central controller for the Automation Mastery suite, orchestrating all automation, AI, and neurodivergent-support components with a modular, menu-driven interface.

**Key Features:**
- Loads all automation mastery components (assessment, recommendations, cloud, AI, neurodivergent, business, advanced)
- Modular design: easy to add/remove components
- Menu-driven interface for all automation tools and workflows
- Adaptive banners and onboarding for neurodivergent users
- Logs all actions and user choices

**Main Functions:**
- Sources all component scripts and libraries (error_handling, interactive, etc.)
- `load_automation_components`: Loads all modular automation components
- `automation_main_menu`: Unified menu for all automation features, with sections for assessment, cloud, AI, neurodivergent, business, advanced, and learning
- Delegates to all subcomponents for specific workflows

**Example Usage:**  
Run the controller to access all automation mastery tools and workflows from a single, modular menu.

**Integration Points:**
- Integrates with all automation mastery components and libraries
- Can be extended with new modules and workflows

**Accessibility & UX:**
- Banner, emoji, and clear language for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing libraries and components gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### automation_mastery/assessment.sh (Component Example)

**Purpose:**  
Personal workflow assessment component for Automation Mastery, designed to analyze user workflows, digital habits, and pain points to generate personalized automation recommendations.

**Key Features:**
- Guided assessment of digital habits, pain points, neurodivergent needs, work context, and automation experience
- Generates a detailed assessment file and personalized recommendations
- Menu-driven, step-by-step process with clear progress indicators
- Integrates with recommendations and neurodivergent strategies components
- Logs all actions and user choices

**Main Functions:**
- `init_assessment`: Sets up assessment environment and directories
- `assess_personal_workflows`: Main function for running the full assessment
- `assess_digital_habits`, `assess_pain_points`, `assess_neurodivergent_needs`, `assess_work_context`, `assess_automation_experience`: Section-specific assessment functions
- Generates and saves assessment and recommendations files

**Example Usage:**  
Run the component to complete a guided assessment and receive personalized automation recommendations tailored to your needs and habits.

**Integration Points:**
- Integrates with recommendations, neurodivergent strategies, and other automation components
- Writes assessment and recommendations to ~/.bill-sloth/automation-assessment/

**Accessibility & UX:**
- Emoji, character quotes, and clear language for engagement
- Menu-driven, step-by-step process with progress tracking
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing directories and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/automation_mastery/neurodivergent_strategies.sh

**Purpose:**  
Provides automation strategies and accommodations specifically designed for neurodivergent users (ADHD, autism, dyslexia, anxiety, sensory needs, etc.).

**Key Features:**
- Menu-driven selection of neurodivergent focus areas (ADHD, autism, dyslexia, anxiety, time blindness, sensory, general)
- Detailed automation strategies for each focus area
- Step-by-step guides and actionable recommendations
- Integrates with assessment and recommendations components
- Logs all actions and user choices

**Main Functions:**
- `neurodivergent_automation_strategies`: Main menu for selecting focus area
- `adhd_automation_strategies`, `autism_automation_strategies`, `dyslexia_automation_strategies`, `anxiety_automation_strategies`, `time_blindness_strategies`, `sensory_automation_strategies`, `general_neurodivergent_strategies`: Focus-specific strategy functions

**Example Usage:**  
Run the component to receive tailored automation strategies and guides for your neurodivergent needs and preferences.

**Integration Points:**
- Integrates with assessment, recommendations, and other automation components
- Can be extended with new strategies and guides

**Accessibility & UX:**
- Emoji, character quotes, and clear language for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia/autism-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/automation_mastery/recommendations.sh (Component Example)

**Purpose:**  
Generates personalized automation recommendations based on user assessment results and digital habits.

**Key Features:**
- Reads assessment data and pain points.
- Maps user needs to mature automation tools and platforms.
- Outputs actionable, ADHD-friendly recommendations.
- Integrates with error handling and logging.

**Main Functions:**
- `generate_personalized_recommendations`: Main function to create recommendations.
- Reads from assessment files and writes to recommendations file.
- Can be invoked from the controller or assessment workflow.

**Example Usage:**  
Component is loaded and run via the controller/main menu after assessment.

**Integration Points:**
- Uses logging, error handling, and adaptive learning from `lib/`.
- Writes recommendations to user's home directory.

**Accessibility & UX:**
- Clear, actionable, and ADHD-friendly recommendations.
- Designed for step-by-step follow-through.

**Error Handling & Recovery:**
- Handles missing or incomplete assessment data gracefully.

---

### modules/automation_mastery/cloud_platforms.sh (Component Example)

**Purpose:**  
Guides users through setting up and integrating cloud automation platforms (Zapier, IFTTT, Power Automate, Make, Node-RED, Home Assistant).

**Key Features:**
- Menu-driven setup for each cloud platform.
- Explains pros/cons, ADHD-friendly features, and use cases.
- Provides step-by-step setup and workflow examples.
- Logs user choices and adapts future recommendations.

**Main Functions:**
- Menu-driven selection and setup of cloud automation platforms.
- For each platform, provides install/config instructions and usage tips.
- Logs all actions and user feedback.

**Example Usage:**  
Component is loaded and run via the controller/main menu.

**Integration Points:**
- Calls out to web APIs and local integrations.
- Uses logging and feedback from `lib/`.

**Accessibility & UX:**
- Cloud-themed ASCII art, color, and motivational language.
- Visual and menu-driven to reduce overwhelm.

**Error Handling & Recovery:**
- Checks for platform availability and guides user through fixes.
- Logs errors and provides recovery steps.

---

### modules/automation_mastery/ai_automation.sh

**Purpose:**  
AI automation component for Automation Mastery, providing guides and actionable strategies for integrating AI-powered tools into automation workflows (email, content, data, customer service, etc.).

**Key Features:**
- Menu-driven exploration of AI automation categories (email, content, data, customer service)
- Actionable recommendations and quick start ideas for each category
- Integrates with other automation components
- Logs all actions and user choices

**Main Functions:**
- `explore_ai_automation`: Main menu for exploring AI automation categories and quick start ideas

**Example Usage:**  
Run the component to receive guides and actionable ideas for integrating AI into your automation workflows (e.g., smart email, content creation, data analysis, customer support).

**Integration Points:**
- Integrates with other automation mastery components
- Can be extended with new AI automation strategies and templates

**Accessibility & UX:**
- Emoji, clear language, and banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/data_hoarding.sh

**Purpose:**  
Comprehensive toolkit for "pirate"-style data hoarding, media management, torrenting, and digital vault organization, with a strong focus on privacy, safety, and automation.

**Key Features:**
- VPN-aware torrenting and safety checks
- Automated directory and workspace setup for torrents
- Installs a suite of mature FOSS tools for torrenting, file management, media handling, and archiving
- Private tracker management and guides
- Disk space analytics, duplicate detection, and cleanup
- Media library management (movies, shows, music)
- Archive and backup strategies
- Seedbox management and remote operations
- Dashboard and menu-driven helpers for all major workflows
- Integration with FileBot and other mature tools (recommended)

**Main Functions:**
- `pirate_data_hoarding_capabilities`: Lists all major features and capabilities
- `install_pirate_treasure_hunting_suite`: Installs all required FOSS tools
- `setup_safe_torrenting`: Sets up safe torrenting environment and qBittorrent config
- `create_private_tracker_guide`: Generates guides for private trackers
- `create_archive_tools`: Sets up archive/compression helpers
- `check_data_hoarding_setup`: Verifies all tools and scripts are present
- `create_seedbox_manager`: Sets up seedbox management scripts
- Menu-driven dashboard for launching all major tools and scripts

**Example Usage:**  
Run the module to set up a complete, safe, and automated data hoarding environment. Use the dashboard to access VPN checks, tracker management, disk analysis, file organization, media management, archiving, and seedbox tools.

**Integration Points:**
- Recommends and integrates with FileBot for media renaming/organization
- Leverages mature FOSS tools for all core operations
- Can be extended with additional scripts in ~/bin/

**Accessibility & UX:**
- Pirate-themed ASCII art and language for engagement
- Menu-driven dashboards and helpers
- Clear warnings for VPN safety and privacy
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Checks for tool/script presence and provides actionable feedback
- Warns if VPN is not active before torrenting
- Handles missing directories or configs gracefully

---

### modules/streaming_setup.sh

**Purpose:**  
Automates the setup of a professional-grade streaming environment for content creation, with a focus on mature, open-source tools and ADHD-friendly workflows.

**Key Features:**
- Installs OBS Studio and virtual camera support
- Sets up advanced audio routing with pavucontrol and PulseAudio modules
- Provides scene template ideas for different streaming scenarios
- Generates a one-click stream launcher script with quick tips

**Main Functions:**
- `install_obs`: Installs OBS Studio and virtual camera kernel modules
- `setup_audio_routing`: Installs pavucontrol and sets up virtual audio devices
- `obs_scene_templates`: Prints scene layout ideas for various use cases
- `create_stream_command`: Creates a ~/bin/stream script to launch OBS and audio mixer with tips

**Example Usage:**  
Run the module to install all streaming tools, set up audio routing, and generate the stream launcher. Use the launcher for a distraction-free start to streaming sessions.

**Integration Points:**
- Integrates with system audio and video stack
- Can be extended to support additional streaming tools or overlays

**Accessibility & UX:**
- Emoji and clear language for each step
- Menu-driven and script-based for minimal cognitive load
- Quick tips and reminders for best practices

**Error Handling & Recovery:**
- Checks for required packages and modules
- Provides clear error messages if setup steps fail
- Launcher script includes reminders for common pitfalls (e.g., VPN status)

---

### modules/media_processing_pipeline.sh

**Purpose:**  
Comprehensive, automated media processing and management pipeline for images, video, and audio, tailored for content creators, VRBO property managers, and personal media archiving.

**Key Features:**
- Automated photo/image processing, optimization, and organization
- Video processing, conversion, and compression
- Audio processing and enhancement
- VRBO property media automation
- EdBoiGames content processing
- Mobile-optimized media workflows
- AI-powered media analysis and tagging
- Cloud storage and backup automation
- **MATURE TOOLS UPDATE (2025):** Enhanced with modern CLI tools (fd/ripgrep) for lightning-fast file operations and cleanup, maintaining friendly progress notifications.
- Modular, extensible design with scriptable helpers

**Main Functions:**
- `media_processing_capabilities`: Lists all major features and capabilities
- `install_media_processing_tools`: Installs all required FOSS tools for image, video, and audio processing
- `setup_image_processing`: Sets up directory structure and optimization scripts for images
- (Additional functions for video/audio/AI processing, cloud backup, etc.)

**Example Usage:**  
Run the module to install all media tools, set up processing directories, and automate media workflows for content creation, property management, or personal archiving.

**Integration Points:**
- Leverages mature FOSS tools (ImageMagick, GIMP, ffmpeg, HandBrake, Audacity, etc.)
- Integrates with Python libraries for advanced/AI processing (Pillow, OpenCV, moviepy, face_recognition, pytesseract)
- Can be extended with custom scripts in ~/.bill-sloth/media-processing/scripts/

**Accessibility & UX:**
- Emoji and clear language for each step
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Checks for tool/script presence and provides actionable feedback
- Handles missing directories or configs gracefully
- Logs all major actions and errors

---

### modules/local_llm_setup.sh

**Purpose:**  
Automates the installation and configuration of a local AI stack (Ollama + Open Interpreter + CodeLlama) for fully offline, privacy-respecting LLM capabilities.

**Key Features:**
- Installs Ollama for local LLM model serving
- Installs Open Interpreter for code/command execution
- Pulls and configures CodeLlama 13B model for offline use
- Adds PowerShell adapter for cross-platform compatibility
- Configures Open Interpreter to use local model and disables cloud fallback
- Logs installation history for auditability

**Main Functions:**
- Checks for existing installation and lists current models
- Installs Ollama and starts its service
- Installs Open Interpreter (with fallback to sudo if needed)
- Pulls recommended LLM model (CodeLlama 13B)
- Adds PowerShell adapter for Windows/Linux compatibility
- Configures Open Interpreter for local-only use
- Logs successful installation to ~/.bill-sloth/history.log

**Example Usage:**  
Run the module to set up a fully local AI stack for code, chat, and automation tasks, with no cloud dependency.

**Integration Points:**
- Integrates with Ollama, Open Interpreter, and Python ecosystem
- Can be extended to support additional local models or adapters

**Accessibility & UX:**
- Emoji and clear language for each step
- Designed for minimal cognitive load and rapid onboarding
- Logs all actions for transparency

**Error Handling & Recovery:**
- Handles missing dependencies and installation errors gracefully
- Provides clear output and logs for troubleshooting

---

### modules/voice_assistant_interactive.sh

**Purpose:**  
Transforms the system into a fully interactive, hands-free voice assistant, providing comprehensive voice control, accessibility features, and integration with other modules for a "Jarvis-like" experience.

**Key Features:**
- Guided setup and configuration for voice control (TTS/STT)
- Voice command status, testing, and customization
- Menu-driven interface for all voice features
- Voice engine selection and dependency management
- Custom command builder and voice shortcuts manager
- Accessibility settings for neurodivergent users
- Tutorials, troubleshooting, and integration examples
- Logs all actions and user choices

**Main Functions:**
- `voice_assistant_menu`: Main menu for all voice assistant features
- `voice_quick_setup`: First-time setup wizard
- `show_voice_status_detailed`: Detailed status and diagnostics
- `install_voice_dependencies`: Installs required speech engines
- `test_voice_output`: Tests TTS output
- `configure_voice_commands`: Customizes voice commands
- `start_voice_control_mode`: Activates voice command mode
- `show_voice_help`: Lists all available voice commands
- `voice_training_mode`: Practice and improve recognition
- `voice_engine_selection`: Choose TTS/STT engines
- `custom_command_builder`: Create new voice commands
- `voice_shortcuts_manager`: Manage voice shortcuts
- `accessibility_settings`: Adjust for accessibility needs
- `voice_control_tutorial`: Step-by-step learning
- `troubleshooting_guide`: Fixes common issues
- `integration_examples`: Shows how to integrate with other modules

**Example Usage:**  
Run the module to set up and use voice control for all major system and workflow actions, with full accessibility and customization.

**Integration Points:**
- Integrates with system TTS/STT engines and other modules
- Can be extended with new voice commands and integrations

**Accessibility & UX:**
- Banner, emoji, and clear language for engagement
- Menu-driven, timeout prompts, and accessibility settings
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing libraries and dependencies gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames_toolkit_interactive_v2.sh

**Purpose:**  
Modular, interactive business toolkit for EdBoiGames, providing access to all business, creative, and automation components via a unified menu and adaptive learning.

**Key Features:**
- Loads all EdBoiGames business toolkit components via a controller
- Modular design for easy extension and maintenance
- Adaptive learning integration (if available)
- Menu-driven interface for all business/creative tools
- Logs all actions and user choices

**Main Functions:**
- Loads `interactive.sh` and `adaptive_learning.sh` libraries for UI and learning
- Loads all components via `edboigames/controller.sh`
- `main`: Delegates to the main menu in the controller
- Runs main menu if executed directly

**Example Usage:**  
Run the module to access all EdBoiGames business, creative, and automation tools from a single, adaptive menu.

**Integration Points:**
- Integrates with all EdBoiGames components via the controller
- Uses adaptive learning for personalized recommendations (if available)

**Accessibility & UX:**
- Banner, emoji, and clear language for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing libraries and components gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/automation_mastery_interactive_v2.sh

**Purpose:**  
Modular, interactive automation mastery suite (v2), providing access to all automation components via a unified controller and menu-driven interface.

**Key Features:**
- Loads all automation mastery components via a central controller
- Modular design for easy extension and maintenance
- Menu-driven interface for all automation tools and workflows
- Logs all actions and user choices

**Main Functions:**
- Loads and delegates to `automation_mastery/controller.sh` for all logic
- `main`: Delegates to the main menu in the controller
- Runs main menu if executed directly

**Example Usage:**  
Run the module to access all automation mastery tools and workflows from a single, modular menu.

**Integration Points:**
- Integrates with all automation mastery components via the controller
- Can be extended with new modules and workflows

**Accessibility & UX:**
- Banner, emoji, and clear language for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing controller/components gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/ai_playground.sh

**Purpose:**  
Sets up and manages the AI Playground, providing tools for local LLMs (Ollama), model recommendations, Stable Diffusion setup, and quick AI command shortcuts.

**Key Features:**
- Installs and manages Ollama for local LLMs
- Recommends models based on detected VRAM
- Provides setup options for Stable Diffusion (ComfyUI, Automatic1111, WebUI Forge)
- Creates a simple `ai` command for quick LLM access

**Main Functions:**
- `install_ollama`: Installs Ollama and enables its service
- `ollama_model_recommendations`: Suggests models based on GPU VRAM
- `setup_stable_diffusion`: Guides user through Stable Diffusion setup options
- `create_ai_shortcuts`: Creates a simple AI launcher script

**Example Usage:**  
Run the module to install Ollama, get model recommendations, set up Stable Diffusion, and create a quick AI command for local LLMs.

**Integration Points:**
- Integrates with Ollama and Stable Diffusion UIs
- Can be extended to support additional AI tools and models

**Accessibility & UX:**
- Emoji and clear language for each step
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and hardware gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/automation_mastery/business_automation.sh

**Purpose:**  
Business process automation component for Automation Mastery, providing guided automation for CRM, finance, marketing, project management, HR, e-commerce, and analytics.

**Key Features:**
- Menu-driven selection of business automation categories (CRM, finance, marketing, project management, HR, e-commerce, analytics)
- Detailed automation strategies and guides for each business area
- Actionable recommendations and workflow templates
- Integrates with assessment and recommendations components
- Logs all actions and user choices

**Main Functions:**
- `business_automation`: Main menu for selecting business automation category
- `crm_automation`, `financial_automation`, `marketing_automation`, `project_automation`, `hr_automation`, `ecommerce_automation`, `reporting_automation`: Category-specific automation functions

**Example Usage:**  
Run the component to receive tailored automation strategies and guides for your business needs and workflows.

**Integration Points:**
- Integrates with assessment, recommendations, and other automation components
- Can be extended with new business automation strategies and templates

**Accessibility & UX:**
- Emoji, clear language, and business-focused banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/automation_mastery/advanced_concepts.sh

**Purpose:**  
Advanced concepts component for Automation Mastery, providing guides and actionable strategies for APIs, webhooks, custom integrations, security, monitoring, and enterprise automation.

**Key Features:**
- Menu-driven selection of advanced automation topics (APIs, webhooks, scripting, databases, security, monitoring, performance, enterprise patterns)
- Detailed guides and actionable recommendations for each topic
- Actionable templates and code snippets for custom integrations
- Integrates with other automation components
- Logs all actions and user choices

**Main Functions:**
- `advanced_automation_concepts`: Main menu for selecting advanced topic
- `apis_and_integrations`, `webhooks_automation`, `custom_code_automation`, `database_integration`, `automation_security`, `monitoring_error_handling`, `performance_optimization`, `enterprise_patterns`: Topic-specific functions

**Example Usage:**  
Run the component to access advanced automation guides, templates, and strategies for custom and enterprise workflows.

**Integration Points:**
- Integrates with other automation mastery components
- Can be extended with new advanced topics and templates

**Accessibility & UX:**
- Emoji, clear language, and advanced banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

*This pattern can be continued for all other modular components (e.g., neurodivergent_strategies.sh, business_automation.sh, advanced_concepts.sh, etc.) as needed. For each, document purpose, features, main functions, usage, integration, accessibility, error handling, and extensibility.* 

### modules/edboigames/business_development.sh

**Purpose:**  
Business development component for EdBoiGames, providing tools and templates for partnership management, revenue analysis, and business operations.

**Key Features:**
- Guided setup for CRM, contact management, and business templates
- Partnership outreach and management tools
- Revenue tracking and analysis templates
- Actionable recommendations and feedback collection
- Integrates with adaptive learning and other toolkit components
- Logs all actions and user choices

**Main Functions:**
- `setup_business_development_tools`: Installs tools, creates templates, and sets up directories
- `analyze_revenue_streams`: Analyzes and optimizes revenue streams, offers AI-powered analysis
- `setup_partnership_tracker`: Manages partnership tracking and outreach

**Example Usage:**  
Run the component to set up business development tools, analyze revenue, and manage partnerships for EdBoiGames.

**Integration Points:**
- Integrates with adaptive learning and other EdBoiGames components
- Can be extended with new business development strategies and templates

**Accessibility & UX:**
- Emoji, clear language, and business-focused banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames/adaptive_detection.sh

**Purpose:**  
Adaptive detection component for EdBoiGames, dynamically detects user focus, preferences, and needs to personalize the toolkit experience.

**Key Features:**
- Detects user focus (business vs. content creation) based on behavior, feedback, and directory structure
- Detects specific user preferences (gaming, streaming, video editing, business automation, audio production)
- Integrates with adaptive learning and feedback systems
- Returns focus and preferences for use by other components

**Main Functions:**
- `detect_user_focus`: Determines primary user focus for adaptive UI and recommendations
- `detect_user_preferences`: Detects specific user needs and preferences

**Example Usage:**  
Run the component to personalize the EdBoiGames toolkit experience based on user focus and preferences.

**Integration Points:**
- Integrates with adaptive learning, feedback, and all EdBoiGames components
- Can be extended with new detection strategies

**Accessibility & UX:**
- Script-based, transparent logic for user trust
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing files and directories gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames/optimization.sh

**Purpose:**  
Optimization component for EdBoiGames, providing guides and actionable strategies for YouTube SEO, monetization, analytics, and channel growth.

**Key Features:**
- Menu-driven exploration of YouTube optimization factors (CTR, AVD, engagement, watch time, thumbnails, titles, analytics)
- Monetization strategies and optimization opportunities
- Actionable recommendations and feedback collection
- Integrates with other toolkit components
- Logs all actions and user choices

**Main Functions:**
- `explain_youtube_optimization`: Main guide for YouTube optimization and analytics
- Additional functions for monetization, analytics, and optimization

**Example Usage:**  
Run the component to receive guides and actionable strategies for optimizing YouTube channels and monetization.

**Integration Points:**
- Integrates with other EdBoiGames components
- Can be extended with new optimization strategies and templates

**Accessibility & UX:**
- Emoji, clear language, and optimization-focused banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames/video_production.sh

**Purpose:**  
Video production component for EdBoiGames, providing workflow guidance and setup for screen recording, editing, and publishing gaming content.

**Key Features:**
- Step-by-step guides for pre-production, recording, editing, and publishing
- Comparison and setup of game recording software (OBS, Bandicam, Shadowplay)
- Video editing fundamentals and technical specifications
- Actionable recommendations and feedback collection
- Integrates with other toolkit components
- Logs all actions and user choices

**Main Functions:**
- `explain_video_production`: Main guide for video production and editing
- `setup_screen_recording`: Sets up and compares game recording software

**Example Usage:**  
Run the component to receive workflow guidance and set up professional-quality video production for gaming content.

**Integration Points:**
- Integrates with other EdBoiGames components
- Can be extended with new video production strategies and templates

**Accessibility & UX:**
- Emoji, clear language, and video-focused banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames/software_installation.sh

**Purpose:**  
Software installation component for EdBoiGames, providing guided setup and comparison of video editing, audio, and screen recording software for content creators.

**Key Features:**
- Menu-driven comparison and setup of video editors (Shotcut, OpenShot, Kdenlive, DaVinci Resolve, Premiere Pro)
- Audio tools and screen recording software setup
- Actionable recommendations and feedback collection
- Integrates with other toolkit components
- Logs all actions and user choices

**Main Functions:**
- `setup_video_editing`: Main guide and installer for video editing software
- `install_shotcut`, `install_openshot`, `install_kdenlive`, `install_davinci_resolve`, `install_adobe_info`: Editor-specific setup functions
- Additional functions for audio and screen recording software

**Example Usage:**  
Run the component to compare, select, and install the best video, audio, and screen recording tools for your content creation needs.

**Integration Points:**
- Integrates with other EdBoiGames components
- Can be extended with new software setup guides and templates

**Accessibility & UX:**
- Emoji, clear language, and software-focused banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/edboigames/education.sh

**Purpose:**  
Education component for EdBoiGames, providing guides and actionable strategies for YouTube business basics, content strategy, and production.

**Key Features:**
- Step-by-step guides for YouTube business, content strategy, and production
- Revenue stream breakdowns and algorithm basics
- Actionable recommendations and feedback collection
- Integrates with other toolkit components
- Logs all actions and user choices

**Main Functions:**
- `explain_youtube_business`: Guide to YouTube business and revenue streams
- `explain_content_strategy`: Guide to content strategy and planning
- Additional functions for production and educational content

**Example Usage:**  
Run the component to receive educational guides and actionable strategies for building a successful YouTube business and content plan.

**Integration Points:**
- Integrates with other EdBoiGames components
- Can be extended with new educational guides and templates

**Accessibility & UX:**
- Emoji, clear language, and education-focused banners for engagement
- Menu-driven and script-based for minimal cognitive load
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/ai_playground_interactive.sh

**Purpose:**  
Interactive assistant for local AI tools, presenting mature open-source AI solutions, explaining pros/cons, logging user choices, and allowing open-ended input for further AI suggestions.

**Key Features:**
- Menu-driven selection of local AI tools (GPT4All, Llama.cpp, Ollama, Stable Diffusion WebUI, Jupyter Notebooks, etc.)
- Explains each tool's benefits, ADHD-friendly features, and learning curve
- Logs user choices and allows "other" for open-ended AI suggestions
- Integrates with Claude Code for advanced/other options

**Main Functions:**
- `ai_playground_interactive`: Main menu and workflow for tool selection and education
- Presents pros/cons, usage tips, and ADHD-friendly notes for each tool
- Logs user choices and invokes AI for custom needs

**Example Usage:**  
Run the module to choose and learn about the best local AI tools, with ADHD-friendly explanations and the option to ask for more via AI.

**Integration Points:**
- Integrates with all recommended AI tools and the Claude Code AI assistant
- Can be extended with new tools and workflows

**Accessibility & UX:**
- Emoji, color, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/defensive_cyber_interactive.sh

**Purpose:**  
Interactive assistant for defensive cybersecurity, providing ethical hacking, security testing, and professional-grade security tools with ADHD/dyslexia-friendly guidance.

**Key Features:**
- Menu-driven selection of mature security tools (Kali Linux suite, Wireshark, IDS, firewalls, etc.)
- Explains each tool's benefits, ethical use, and ADHD-friendly features
- Guides user through setup, usage, and learning resources
- Logs user choices and provides AI-powered security suggestions

**Main Functions:**
- `explain_defensive_cyber`: Main guide for defensive cybersecurity concepts and tools
- `install_kali_tools`: Installs and configures essential security tools
- Additional functions for network analysis, forensics, and AI-enhanced security

**Example Usage:**  
Run the module to set up a professional security testing environment, learn about ethical hacking, and access ADHD-friendly security guides.

**Integration Points:**
- Integrates with all recommended security tools and AI assistants
- Can be extended with new tools and workflows

**Accessibility & UX:**
- Security-themed banners, color, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/discord_mod_toolkit_interactive.sh

**Purpose:**  
Interactive assistant for Discord moderation, providing a comprehensive guide to community management, automation, and ADHD-friendly workflows.

**Key Features:**
- Menu-driven selection of moderation tools (MEE6, Carl-bot, Dyno, Discord.py bots, etc.)
- Explains each tool's benefits, ADHD-friendly features, and setup process
- Guides user through bot setup, server optimization, and analytics
- Logs user choices and provides AI-powered moderation strategies

**Main Functions:**
- `explain_discord_moderation`: Main guide for Discord moderation concepts
- `explain_discord_bots`: Overview of the Discord bot ecosystem
- `explain_adhd_moderation_strategies`: ADHD-specific moderation strategies
- Additional functions for automation, analytics, and event management

**Example Usage:**  
Run the module to learn about and set up Discord moderation tools, with ADHD-friendly explanations and automation strategies.

**Integration Points:**
- Integrates with all recommended Discord bots and AI assistants
- Can be extended with new tools and workflows

**Accessibility & UX:**
- Community-themed banners, color, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/clipboard_mastery_interactive.sh

**Purpose:**  
Interactive assistant for advanced clipboard management, integrating AI-powered features and ADHD/dyslexia-friendly workflows.

**Key Features:**
- Menu-driven setup and comparison of clipboard tools (CopyQ, etc.)
- AI integration for content detection, translation, summarization, and OCR
- Advanced formatting, unlimited history, global hotkeys, and cross-device sync
- Logs user choices and provides AI-powered clipboard strategies

**Main Functions:**
- `explain_clipboard_power`: Main guide for advanced clipboard management
- `install_copyq`: Installs and configures CopyQ clipboard manager
- Additional functions for AI integration and automation

**Example Usage:**  
Run the module to set up and master advanced clipboard management, with ADHD-friendly explanations and AI-powered features.

**Integration Points:**
- Integrates with CopyQ, AI assistants, and other productivity tools
- Can be extended with new clipboard tools and workflows

**Accessibility & UX:**
- Productivity-themed banners, color, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

### modules/kodi_setup_interactive.sh

**Purpose:**  
Interactive assistant for Kodi Debrid setup, providing a complete installer and configuration guide for high-quality streaming with ADHD/dyslexia-friendly guidance.

**Key Features:**
- Menu-driven setup for Kodi and premium debrid services (Real-Debrid, AllDebrid, Premiumize)
- Explains each service's benefits, legal considerations, and ADHD-friendly features
- Guides user through installation, configuration, and build selection
- Logs user choices and provides AI-powered streaming strategies

**Main Functions:**
- `explain_debrid`: Main guide for debrid services and streaming concepts
- `install_kodi`: Installs and configures Kodi
- `choose_build`: Guides user through build selection and setup
- Additional functions for troubleshooting and advanced configuration

**Example Usage:**  
Run the module to set up Kodi with premium debrid services, with ADHD-friendly explanations and streaming tips.

**Integration Points:**
- Integrates with Kodi, debrid services, and AI assistants
- Can be extended with new streaming tools and workflows

**Accessibility & UX:**
- Streaming-themed banners, color, and motivational language
- Menu-driven, low-cognitive-load interface
- Designed for ADHD/dyslexia-friendly workflows

**Error Handling & Recovery:**
- Handles missing dependencies and files gracefully
- Provides clear error messages and recovery steps
- Logs all actions for transparency

---

## Performance Monitoring & Optimization (New Section)

Bill Sloth now includes a real-time performance monitoring and optimization system, designed to help users identify resource usage patterns and bottlenecks in daily workflows. This system is implemented and integrated as follows:

### 1. Performance Monitoring Library
- **File:** `lib/performance_monitoring.sh`
- **Purpose:** Provides functions for real-time performance analysis and resource usage optimization.
- **Integration:** Sourced by core libraries (e.g., `lib/data_persistence.sh`) to enable performance tracking for key operations.

### 2. Integration with Data Persistence
- **File:** `lib/data_persistence.sh`
- **Integration Points:**
  - During initialization (`init_data_persistence`), performance monitoring is loaded and the initialization time is recorded using `capture_performance_snapshot`.
  - The `store_data` function tracks operation timing and records performance snapshots at the end of the function.
- **Effect:** Enables tracking of how long critical data operations take, helping to identify slowdowns or bottlenecks.

### 3. Performance Wrappers
- **File:** `lib/performance_wrappers.sh`
- **Purpose:** Provides lightweight wrappers to add performance monitoring to existing functions. (Implementation present, but not yet widely used across all modules.)

### 4. Performance Analysis Script
- **File:** `scripts/performance_analysis.sh`
- **Purpose:** Automates analysis of Bill Sloth system performance and provides optimization recommendations. Sources required libraries and can be invoked to review collected performance data.

### 5. Usage and Access
- Performance data is collected automatically during key operations (e.g., data persistence). Users and developers can run the analysis script to review system performance and receive actionable recommendations.
- **To run performance analysis:**
  ```bash
  bash scripts/performance_analysis.sh
  ```

### 6. Next Steps
- Expand integration of performance monitoring to additional modules and workflows using the wrappers library.
- Develop a user-facing dashboard or CLI summary for performance data.
- Continue to optimize modules based on real-world usage patterns and analysis results.

---

**Note:** All documentation above reflects features and integrations that are actually implemented in the codebase as of this update. Planned or discussed features are not included until merged and tested.