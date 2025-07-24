# PowerShell Script Encoding Issues

## Problem
Scripts downloaded from GitHub have character encoding problems when run on Windows:
- Unicode characters (✅❌⚠️) cause parser errors
- String interpolation with GB units fails
- Path separators cause issues

## Affected Files
- `ubuntu-installer-prep.ps1` - Multiple syntax errors
- `bill-sloth-custom-iso-creator.ps1` - Encoding corruption

## Errors Seen
```
Unexpected token 'GB' in expression or statement
Missing closing ')' in expression
Unexpected token 'Enter' in expression
```

## Solutions Needed
1. Save scripts with UTF-8 BOM encoding
2. Test special characters on Windows PowerShell
3. Escape path separators properly
4. Use simpler ASCII output for compatibility

## Workaround
Created `simple-bill-sloth-usb.ps1` with ASCII-only output that works.

## Next Steps
- Fix encoding in main repository
- Add Windows compatibility testing
- Consider PowerShell Core vs Windows PowerShell differences