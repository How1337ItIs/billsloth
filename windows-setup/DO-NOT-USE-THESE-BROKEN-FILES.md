# 🚨 DO NOT USE THESE BROKEN ISO BUILDERS 🚨

## ⛔ **THESE FILES ARE BROKEN - DO NOT RUN THEM**

### **PowerShell Files with Unfixable Syntax Errors:**
- `bill-sloth-LOCAL-iso-builder.ps1` ❌ BROKEN
- `bill-sloth-LOCAL-iso-builder-FIXED.ps1` ❌ BROKEN  
- `bill-sloth-WORKING-local-iso.ps1` ❌ BROKEN
- `bill-sloth-broken-package-install.ps1` ❌ BROKEN
- `bill-sloth-broken-package-install-v2.ps1` ❌ BROKEN
- Any other PowerShell ISO builder ❌ BROKEN

### **Why They're Broken:**
1. PowerShell parsing errors with `&&` operators
2. Encoding issues with special characters
3. Here-string syntax conflicts
4. Backtick interpretation problems

## ✅ **WHAT TO USE INSTEAD:**

### **For Creating Bill Sloth ISO:**
**Use individual WSL commands only:**
```bash
# Clean start
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth"

# Install tools
wsl -d Ubuntu-22.04 bash -c "sudo apt update"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y xorriso squashfs-tools"

# Mount and extract
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop /mnt/c/billsloth/ubuntu-22.04.5-desktop-amd64.iso /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/billsloth/extract-cd"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo rsync -a /mnt/ubuntu-iso/ extract-cd/"

# Continue with individual commands...
```

## 🚫 **NEVER DO THESE:**
- Don't run any PowerShell ISO builder scripts
- Don't try to "fix" the PowerShell syntax errors
- Don't create new "working" versions
- Don't use here-strings with bash content

## ✅ **ALWAYS DO THIS:**
- Use individual WSL commands
- Follow the documented working pattern
- Read `WORKING-ISO-SOLUTION.md` for the complete sequence

**The PowerShell scripts cannot be fixed. Use manual WSL commands only.**