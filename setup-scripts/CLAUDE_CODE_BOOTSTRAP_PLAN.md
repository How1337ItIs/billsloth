# Claude Code Bootstrap & Ubiquity Plan for Bill Sloth

## Purpose
Ensure that the Claude Code CLI is reliably available, authenticated, and usable in all relevant user and system contexts for the Bill Sloth system. This is critical for fallback automation, self-audit, and interactive workflows.

---

## 1. **Onboarding Flow (First Run Experience)**
- On first run (or if Claude Code is missing/unconfigured), Bill Sloth should:
  1. **Detect** if `claude` CLI is installed and in `$PATH`.
  2. **Detect** if `claude` is authenticated (e.g., `claude whoami` returns success).
  3. **If missing or unauthenticated:**
     - Prompt Bill with a clear, ADHD/dyslexia-friendly message.
     - Offer to install `claude` automatically (using `pip install --user claude-cli` or latest method).
     - If install fails, provide step-by-step manual instructions.
     - Prompt Bill to run `claude login` and walk through authentication interactively.
     - Confirm success and log the result.
  4. **If all else fails:**
     - Offer to open a help page or support link.
     - Log the error and provide troubleshooting steps.

- **Implementation:**
  - This onboarding should be triggered by the main launcher, onboarding script, and any setup script that requires Claude Code.
  - Claude Code itself should be used to walk Bill through the process ("meta-onboarding") if possible, e.g., by prompting: "Hi Bill! Let's get Claude Code set up so I can help you everywhere."

---

## 2. **Technical Checks (All Contexts)**
- **User Shells:**
  - Ensure `claude` is in `$PATH` (add `~/.local/bin` to `.bashrc`, `.zshrc`, etc. if needed).
- **Sudo/Root Contexts:**
  - Prefer running Claude Code as the invoking user: `sudo -u $SUDO_USER claude ...`.
  - Optionally, install Claude Code system-wide for root if needed (not recommended for security).
- **Systemd Services:**
  - Set `User=bill` in unit files.
  - Set `Environment=PATH=/home/bill/.local/bin:/usr/local/bin:/usr/bin:/bin` as needed.
- **Cron Jobs:**
  - Use full path to `claude` or ensure cron's environment includes the correct `$PATH`.
  - Prefer running as the user, not root.

---

## 3. **Automated Checks & Remediation**
- Add a function to onboarding and setup scripts:
  ```bash
  ensure_claude_code() {
    if ! command -v claude &>/dev/null; then
      echo "Claude Code CLI not found. Installing..."
      pip install --user claude-cli || sudo pip install claude-cli
    fi
    if ! claude whoami &>/dev/null; then
      echo "Claude Code CLI not authenticated. Please run: claude login"
      exit 1
    fi
    echo "✅ Claude Code CLI is installed and authenticated."
  }
  ```
- Call this function at the start of onboarding, and in any script that relies on Claude Code.

---

## 4. **Documentation & User Guidance**
- Add a section to onboarding guide and README:
  - "Bill Sloth requires Claude Code CLI to be installed and authenticated for all users and contexts. Run `just ensure-claude` to check and fix."
- Provide troubleshooting steps and a FAQ for common issues (e.g., network, permissions, quota).

---

## 5. **Fallback & Logging**
- If Claude Code is missing or not authenticated:
  - Log a warning and provide clear, actionable instructions.
  - Offer to retry or skip the step.
- If running in a non-interactive context (systemd, cron), log the error and suggest running the onboarding script manually.

---

## 6. **Optional: `just ensure-claude` Command**
- Add a `justfile` command to automate the check and fix process.

---

## 7. **Summary Table**
| Context      | What to Check/Do                                      |
|--------------|------------------------------------------------------|
| User shell   | `claude` in PATH, authenticated                      |
| Sudo/root    | Use `sudo -u $SUDO_USER claude ...` or install for root |
| Systemd      | Set `User=bill`, set PATH, check `claude` available  |
| Cron         | Use full path, run as user, check PATH               |

---

## 8. **Meta-Onboarding Example (Claude Code Walkthrough)**
- If `claude` is missing or not authenticated, Bill Sloth should:
  1. Print: "Hi Bill! I need Claude Code to help you everywhere. Let's set it up together."
  2. Offer to install automatically, or provide copy-paste instructions.
  3. Prompt for `claude login` and explain what to expect.
  4. Confirm success and celebrate with ASCII art or a friendly message.

---

## 9. **Future-Proofing**
- Monitor for changes in Claude Code installation/authentication methods.
- Update onboarding and setup scripts as needed.
- Consider supporting other LLM CLIs as fallback in the future.

---

## 10. **Implementation Status**
- [ ] Plan written (this file)
- [ ] Onboarding script updated
- [ ] Setup scripts updated
- [ ] `justfile` command added
- [ ] Documentation updated
- [ ] Meta-onboarding flow implemented 