# Multi-User Profile Refactor Blueprint for Bill Sloth

## 1. High-Level Goals
- Support multiple users (e.g., Bill, Beefdog) with their own settings, modules, data, and UX.
- Minimize code duplication; maximize maintainability and shared improvements.
- Support both user-specific and shared modules, shortcuts, data, and context.
- Preserve privacy and separation of user data/configs/logs.

---

## 2. Core Design Decisions

### A. User Profile Detection
- On startup, detect the active user via:
  - Environment variable (e.g., `BILLSLOTH_USER=beefdog`)
  - Config file (e.g., `~/.bill-sloth/user_profile`)
  - Command-line flag (e.g., `lab.sh --user beefdog`)
  - Login prompt if not set

### B. User Profile Directory Structure
- Namespace all user-specific data, configs, logs, and modules:
  ```
  ~/.bill-sloth/users/bill/
  ~/.bill-sloth/users/beefdog/
  ```
- Shared data remains in `~/.bill-sloth/` or a global location.

### C. User-Specific Modules and Overrides
- Support user-specific versions of modules:
  - `modules/users/bill/productivity_suite_interactive.sh`
  - `modules/users/beefdog/productivity_suite_interactive.sh`
- At runtime, load the user-specific module if it exists, else fall back to the shared version.

### D. User-Specific Shortcuts and Aliases
- Support user-specific aliases:
  - `shortcuts/aliases_bill.sh`
  - `shortcuts/aliases_beefdog.sh`
- Source the correct file based on the active user.

### E. User-Specific Prompts/Context
- Support user-specific prompt/context files:
  - `prompts/claude_context_bill.md`
  - `prompts/claude_context_beefdog.md`
- Load the correct context for AI/LLM modules.

### F. User-Specific Persistent Data
- All logs, reminders, pattern learning, and SQLite DBs should be namespaced per user:
  - `~/.bill-sloth/users/bill/activity.log`
  - `~/.bill-sloth/users/beefdog/activity.log`
  - `~/.bill-sloth/users/bill/billsloth.db`

---

## 3. Refactor Steps (by Area)

### A. Entry Points and Launchers
- Refactor `lab.sh`, `bill-sloth-ultimate`, etc. to:
  - Detect/select the active user.
  - Export `BILLSLOTH_USER` for all subprocesses.
  - Pass user context to all module invocations.

### B. Module Loading Logic
- In all module launchers:
  - Check for a user-specific override in `modules/users/$USER/`.
  - If not found, use the shared module.

### C. Data, Logs, and Persistence
- Refactor all scripts that write to `~/.bill-sloth/` to write to `~/.bill-sloth/users/$USER/` instead.
- For SQLite, use a per-user DB file.

### D. Shortcuts and Aliases
- At shell init, source the correct aliases file for the active user.
- Consider a shared base aliases file, with user-specific overrides.

### E. Prompts and Context
- When invoking LLMs or AI modules, load the user-specific context file if it exists.

### F. Adaptive Learning and Pattern Tracking
- Ensure all adaptive learning, pattern tracking, and capability installation logic is namespaced per user.

### G. Tests and CI
- Update tests to run for multiple users.
- Add fixtures for user-specific data.

### H. Documentation and Onboarding
- Update onboarding docs to explain user profiles, how to add a new user, and how to customize modules/settings.

---

## 4. What to Do With Highly Bill-Specific Modules (e.g., EdBoiGames BD, VRBO Flows)

### **A. Options for Handling Bill-Specific Modules**

#### 1. **Move to User-Specific Module Directory**
- Relocate Bill-specific modules to `modules/users/bill/` (e.g., `modules/users/bill/edboigames_toolkit_interactive.sh`, `modules/users/bill/vacation_rental_manager_interactive.sh`).
- These modules are only loaded for Bill; Beefdog and others do not see them by default.
- **Pros:**
  - Clean separation; no confusion for other users.
  - Bill can continue to iterate on his unique workflows.
- **Cons:**
  - If another user wants to use/adapt these flows, they must copy or generalize them.

#### 2. **Parameterize and Generalize**
- Refactor modules to support user-specific configuration (e.g., `config.yaml` or environment variables).
- Move Bill-specific logic into config files or user profile data.
- **Pros:**
  - More maintainable if other users want similar workflows.
  - Reduces code duplication.
- **Cons:**
  - More complex refactor; may not be worth it for highly personal flows.

#### 3. **Hybrid Approach**
- Generalize common logic (e.g., property management, business development) into shared modules.
- Keep Bill-specific details (e.g., Guntersville Getaway, EdBoiGames branding) in user-specific config or submodules.
- **Pros:**
  - Shared improvements benefit all users.
  - Personalization is still possible.
- **Cons:**
  - Requires careful design to avoid over-complication.

### **B. Migration Strategy**
- **Step 1:** Identify all Bill-specific modules and scripts.
- **Step 2:** Move them to `modules/users/bill/`.
- **Step 3:** For each, decide:
  - Should this be generalized for other users?
  - Should it remain Bill-only?
- **Step 4:** For modules with generalizable logic, extract shared code to `modules/shared/` or a library, and keep user-specific details in config or user modules.
- **Step 5:** Update launchers to only show Bill-specific modules for Bill.
- **Step 6:** Document the rationale and structure in the GIGA DOC and onboarding guides.

### **C. Open Questions**
- Should there be a UI for users to "adopt" or "clone" another user's module as a starting point?
- How to handle updates to shared logic if user-specific modules diverge?
- Should user-specific modules be versioned separately?

### **D. Example Directory Structure**
```
modules/
  users/
    bill/
      edboigames_toolkit_interactive.sh
      vacation_rental_manager_interactive.sh
      ...
    beefdog/
      beefdog_special.sh
      ...
  shared/
    property_management_core.sh
    business_development_core.sh
    ...
```

---

## 5. Open Questions / Further Research
- User switching: runtime vs. session start?
- Shared vs. private data: how to handle permissions?
- User management UI: CLI/TUI for adding/removing users?
- Migration: scripts for moving existing data?
- Module inheritance: best practices for Bash/Python?
- Justfile/SQLite: global vs. per-user?
- Access control: multi-user on shared systems?

---

## 6. Implementation Phases
1. Design & Planning
2. Refactor Core Launchers
3. Refactor Modules
4. Refactor Data Persistence
5. Refactor Shortcuts, Prompts, and Context
6. Update Tests and Docs
7. Migration and Backward Compatibility
8. User Management Tools (Optional)

---

## 7. Further Research
- Best practices for multi-user Bash/Python CLI tools.
- How other open-source assistants (e.g., Home Assistant, JupyterHub) handle user profiles.
- Security and privacy models for multi-user local-first systems.

---

**This document is a living blueprint for the multi-user refactor of Bill Sloth. Update as new requirements, discoveries, or user needs emerge.** 