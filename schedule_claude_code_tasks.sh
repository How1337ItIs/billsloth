#!/bin/bash
# schedule_claude_code_tasks.sh
# Wait 47 minutes for Claude Code credits to reset
sleep 2820  # 47 minutes

# 1. Full Codebase Audit & Prioritization
claude "Audit the entire Bill Sloth codebase (modules, bin, setup-scripts, lab.sh, systemd, etc). Identify the top 5 areas where improvements would most increase daily usefulness, reliability, and maintainability. For each, suggest the most mature, open-source, local-first solution or workflow, and explain why. For every suggestion, document your rationale and implementation details in Markdown for the developer, and indicate where to place the documentation (e.g., METHODS_LOG.md, module-level docs, or architecture files)."
sleep 300

# 2. Automated UX/Onboarding Polish
claude "Review lab.sh, bin/bill-sloth-ultimate, and self-executing-guide.md. Suggest concrete improvements to onboarding, daily workflow, and user feedback to make the system more motivating, forgiving, and maintainable. For each suggestion, document your rationale and implementation details in Markdown for the developer, and indicate where to place the documentation (e.g., METHODS_LOG.md, module-level docs, or architecture files)."
sleep 300

# 3. Setup Scripts & Robustness Review
claude "Review the setup-scripts directory. For each script, check for idempotency, error handling, and user feedback. Suggest improvements to make these scripts robust, self-healing, and easy to maintain. For each script reviewed or improved, document your rationale and implementation details in Markdown for the developer, and indicate where to place the documentation (e.g., METHODS_LOG.md, module-level docs, or architecture files)."
sleep 300

# 4. Self-Audit Loop Enhancement
claude "Read bin/audit_workflow and METHODS_LOG.md. Suggest ways to make the self-audit loop more proactive, so Bill is gently prompted to review and upgrade workflows at the right time, without being overwhelmed. For each suggestion, document your rationale and implementation details in Markdown for the developer, and indicate where to place the documentation (e.g., METHODS_LOG.md, module-level docs, or architecture files)."
sleep 300

# 5. Cypherpunk Badassery & ATHF Vibes Layer
claude "Suggest actionable, developer-focused ways to infuse the Bill Sloth system with more cypherpunk badassery, ATHF-inspired randomness and humor, and spontaneous, powerful, useful tools and vibes—while keeping it simple and welcoming. For each idea, provide rationale, implementation details, and example code or UI, and document your suggestions in Markdown for the developer, indicating where to place the documentation (e.g., METHODS_LOG.md, module-level docs, or architecture files)."
sleep 300

# 6. Daily Use Friction Audit
claude "Based on README.md and recent METHODS_LOG.md entries, identify any remaining points of friction or confusion in Bill's daily use of the system. For each, suggest the simplest, most maintainable fixes, and document your rationale and implementation details in Markdown for the developer, and indicate where to place the documentation (e.g., METHODS_LOG.md, module-level docs, or architecture files)." 