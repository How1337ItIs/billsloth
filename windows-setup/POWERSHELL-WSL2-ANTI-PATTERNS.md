# PowerShell + WSL2 Anti-Patterns - MANDATORY READING FOR CLAUDE

## 🚨 **CRITICAL: This document prevents repeated failures in ISO building**

Every time a Claude instance works on Bill Sloth ISO builders, they make THE SAME MISTAKES repeatedly. This document prevents that cycle.

## **❌ ANTI-PATTERNS - NEVER DO THESE**

### 1. **PowerShell Here-Strings with Bash Content - FORBIDDEN**
```powershell
# ❌ WRONG - PowerShell parses the bash content
$command = @"
bash_command && another_command
echo "text with (parentheses)"
"`
```

**Why it fails:** PowerShell interprets `&&`, `()`, backticks, and quotes before WSL2 sees them.

**✅ CORRECT PATTERN:**
```powershell
wsl -d Ubuntu-22.04 bash -c "single_bash_command_only"
wsl -d Ubuntu-22.04 bash -c "next_bash_command"
```

### 2. **Complex Multi-Command Bash Strings - FORBIDDEN**
```powershell
# ❌ WRONG - Parsing nightmare
wsl bash -c "cd /tmp && mkdir test && echo 'done'"
```

**✅ CORRECT:**
```powershell
wsl bash -c "cd /tmp"
wsl bash -c "mkdir test" 
wsl bash -c "echo 'done'"
```

### 3. **Backticks in WSL Commands - FORBIDDEN**
```powershell
# ❌ WRONG - PowerShell interprets backticks
wsl bash -c "chown -R `$USER:group file"
```

**✅ CORRECT:**
```powershell
wsl bash -c "chown -R \$USER:group file"
```

### 4. **Parentheses in Echo Statements - PROBLEMATIC**
```powershell
# ❌ PROBLEMATIC - PowerShell parsing issues
wsl bash -c "echo 'Tools (git, python, node)'"
```

**✅ SAFER:**
```powershell
wsl bash -c "echo 'Tools: git, python, node'"
```

## **🔄 THE REPEATED FAILURE CYCLE**

**Observed pattern across multiple sessions:**
1. Create new ISO builder
2. Use here-strings with bash content
3. Get PowerShell parsing errors
4. Try to "fix" with more complex escaping
5. Create another "fixed" version
6. **NEVER LEARN FROM EXISTING WORKING VERSIONS**
7. Repeat cycle

## **✅ WORKING PATTERNS - USE THESE**

### **Template for WSL2 Commands:**
```powershell
# Individual commands only
wsl -d Ubuntu-22.04 mkdir -p /path/to/dir
wsl -d Ubuntu-22.04 bash -c "cd /path && simple_command"
wsl -d Ubuntu-22.04 bash -c "echo 'simple text only'"
```

### **File Creation in WSL2:**
```powershell
# Create files line by line - RELIABLE
wsl -d Ubuntu-22.04 bash -c 'echo "#!/bin/bash" > /path/script.sh'
wsl -d Ubuntu-22.04 bash -c 'echo "command1" >> /path/script.sh'  
wsl -d Ubuntu-22.04 bash -c 'echo "command2" >> /path/script.sh'
wsl -d Ubuntu-22.04 chmod +x /path/script.sh
```

## **🎯 ISO BUILDER SPECIFIC RULES**

### **MANDATORY: Before Creating New ISO Builder**
1. **READ** `bill-sloth-RECOMMENDED-iso-builder.ps1` first
2. **COPY** its exact command structure  
3. **MODIFY** incrementally, not wholesale replacement
4. **TEST** each WSL command individually

### **Local Ubuntu ISO Usage:**
```powershell
# ✅ CORRECT local ISO approach
$LocalUbuntuISO = "C:\billsloth\ubuntu-22.04.5-desktop-amd64.iso"
$wslISOPath = $LocalUbuntuISO -replace '^([A-Z]):', '/mnt/$1' -replace '\\', '/' | ForEach-Object { $_.ToLower() }

wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop '$wslISOPath' /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/extract && cd /tmp && rsync -a /mnt/ubuntu-iso/ extract/"
```

## **🚫 WHAT NOT TO CREATE**

- **No new "simplified" versions** - use existing working ones
- **No here-string rewrites** - they always fail
- **No "fixed" versions** - fix the original incrementally  
- **No bypassing PowerShell** - the whole point is Windows→WSL2 flow

## **✅ DEBUGGING APPROACH**

When WSL commands fail:
1. Run the EXACT command manually in WSL2 first
2. If it works in WSL2, the issue is PowerShell parsing
3. Simplify the PowerShell string, don't make it more complex
4. Use individual commands instead of combined ones

## **📋 CHECKLIST FOR ANY ISO BUILDER WORK**

Before touching ANY ISO builder:
- [ ] Read this document completely
- [ ] Examine `bill-sloth-RECOMMENDED-iso-builder.ps1` structure
- [ ] Identify what needs changing (don't rewrite everything)
- [ ] Test WSL commands individually first
- [ ] Use established patterns only

## **🔥 EMERGENCY RULE**

**If you catch yourself writing `@"` or `@'` for WSL commands, STOP IMMEDIATELY.**
**Use individual `wsl bash -c "command"` calls instead.**

This pattern has failed EVERY SINGLE TIME across multiple sessions.

## **📊 SUCCESS METRICS**

- `bill-sloth-RECOMMENDED-iso-builder.ps` structure = WORKS (with fixes)
- Local Ubuntu ISO approach = WORKS
- Individual WSL commands = WORKS  
- WSL2 Ubuntu-22.04 environment = WORKS
- live-build process = WORKS (when packages available)

**The pieces work. The integration is where failures happen due to PowerShell syntax issues.**