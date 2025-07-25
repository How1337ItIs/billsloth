# 🚨 CLAUDE: READ THIS BEFORE TOUCHING ISO BUILDERS 🚨

## **YOU ARE ABOUT TO REPEAT KNOWN MISTAKES**

Previous Claude instances have created 15+ broken ISO builders by making THE SAME PowerShell syntax errors repeatedly.

## **❌ DO NOT DO THESE THINGS:**
1. Create "new" or "fixed" ISO builders
2. Use PowerShell here-strings with bash content (`@"...bash..."@`)
3. Put `&&` operators in WSL command strings
4. Ignore existing working patterns

## **✅ DO THIS INSTEAD:**
1. **READ** `POWERSHELL-WSL2-ANTI-PATTERNS.md` completely
2. **USE** `bill-sloth-RECOMMENDED-iso-builder.ps1` as base
3. **MODIFY** incrementally, not wholesale rewrite
4. **TEST** each WSL command individually first

## **🎯 THE WORKING APPROACH:**
```powershell
# Individual commands only - this works
wsl -d Ubuntu-22.04 bash -c "single_command"
wsl -d Ubuntu-22.04 bash -c "another_command"

# NOT complex here-strings - these always fail
```

## **📍 LOCAL UBUNTU ISO:**
- Available at: `C:\billsloth\ubuntu-22.04.5-desktop-amd64.iso`
- Use this to avoid network issues
- Extract and modify instead of live-build

## **⚠️ WARNING SIGNS YOU'RE REPEATING MISTAKES:**
- Writing `@"` with bash content
- Getting PowerShell parsing errors
- Creating new files instead of fixing existing ones
- Ignoring this documentation

**The cycle ends here. Follow the documented patterns.**