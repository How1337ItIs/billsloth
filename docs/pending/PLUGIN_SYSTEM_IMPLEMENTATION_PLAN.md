# Bill Sloth Setup Script System Implementation Plan

## Purpose

The setup script system will provide a library of pre-built, reusable installer and configuration scripts for common tools, workflows, and system tasks. This will:
- Save Claude Code tokens by avoiding on-the-fly script generation for routine tasks
- Improve reliability and consistency of installations/configurations
- Make the system more user-friendly and extensible
- Allow users and contributors to add new setup scripts for their favorite tools

---

## Directory Structure

```
setup-scripts/
  install_obs.sh
  install_docker.sh
  install_filebot.sh
  configure_vpn.sh
  setup_kanboard.sh
  ...
  list_setup_scripts.sh
  SETUP_SCRIPT_SYSTEM_IMPLEMENTATION_PLAN.md
```

---

## Setup Script Conventions
- Each script should be:
  - **Idempotent** (safe to run multiple times)
  - **Self-documenting** (prints what it does, usage, and options)
  - **Detects if already installed/configured**
  - **Logs actions and errors**
- Example header:
  ```bash
  #!/bin/bash
  # Setup Script: install_obs.sh
  # Installs and configures OBS Studio for Bill Sloth
  set -e
  ```
- Each setup script should print a summary of what it will do before making changes.

---

## Setup Script Discovery and Menu
- `list_setup_scripts.sh` will list all available setup scripts with descriptions.
- Optionally, add a menu to `lab.sh` or `bill_command_center.sh` to let users pick setup scripts to run.

---

## Setup Script Invocation
- Setup scripts can be invoked directly by Claude Code, by modules, or by the user:
  ```bash
  bash setup-scripts/install_obs.sh
  ```
- Modules should check for tool presence and invoke the setup script if needed.

---

## Integration Points
- Claude Code: When asked to install/configure a tool, check for a matching setup script and run it.
- Modules: Use setup scripts for dependency installation/configuration.
- Onboarding: Offer to run recommended setup scripts during setup.

---

## Roadmap for Initial Setup Scripts
1. **install_obs.sh** — Streaming setup
2. **install_docker.sh** — Container support
3. **install_filebot.sh** — Media management
4. **setup_kanboard.sh** — Kanban/project management
5. **configure_vpn.sh** — Privacy/safety
6. **install_nodejs.sh** — For Claude Code, etc.
7. **install_copyq.sh** — Clipboard manager
8. **install_glances.sh** — System health monitoring
9. **install_voice2json.sh** — Voice/intent recognition
10. **install_jellyfin.sh** — Media streaming

---

## Example Setup Script: install_obs.sh
```bash
#!/bin/bash
# Setup Script: install_obs.sh
# Installs and configures OBS Studio for Bill Sloth
set -e

if command -v obs &>/dev/null; then
  echo "✅ OBS Studio is already installed."
  exit 0
fi

echo "🔧 Installing OBS Studio..."
sudo add-apt-repository ppa:obsproject/obs-studio -y
sudo apt update
sudo apt install -y obs-studio v4l2loopback-dkms

echo "✅ OBS Studio installation complete."
```

---

## Refactor Existing Installer Logic from Modules

To avoid redundancy and ensure all installer/configuration logic is centralized, the following steps should be taken:

1. **Identify installer functions in modules** (e.g., OBS in `streaming_setup.sh`, VPN in `privacy_tools.sh`).
2. **Move these functions to standalone setup scripts** in the `setup-scripts/` directory.
3. **Update the original modules** to call the corresponding setup script instead of containing their own install logic.
4. **Document this policy**: All new installer/configuration logic should be implemented as setup scripts, not in modules.

### Modules/Functions to Refactor:
- `modules/streaming_setup.sh`: `install_obs` → `setup-scripts/install_obs.sh`
- `modules/privacy_tools.sh`: `install_vpn_tools` → `setup-scripts/configure_vpn.sh`
- Any future installer logic in modules should be implemented as a setup script.

This will keep the system DRY, maintainable, and token-efficient.

---

## Next Steps
1. Create the `setup-scripts/` directory if it does not exist.
2. Add the initial set of setup scripts as listed above.
3. Write `list_setup_scripts.sh` to enumerate and describe available setup scripts.
4. Update onboarding and modules to use setup scripts where appropriate.
5. Document the setup script system in the GIGA DOC and onboarding guides.
6. Encourage contributions of new setup scripts.

---

**This plan will be updated as the setup script system evolves.** 