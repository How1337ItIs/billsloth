# PowerShell Script Issues Assessment - Dual Boot Wizards

**Date:** July 24, 2025  
**Affected Scripts:** 
- `wsl2-to-native-transition-wizard.ps1`
- `maximum-automation-wizard.ps1`
**Issue Type:** Unicode/Encoding Parse Errors  
**Severity:** Critical - Scripts Cannot Execute

## Problem Summary

Both dual boot wizard scripts fail to execute due to PowerShell parse errors caused by Unicode character encoding issues. The scripts contain emoji and special Unicode characters that are being corrupted during file operations, causing syntax errors.

## Specific Parse Errors

### `wsl2-to-native-transition-wizard.ps1`
```powershell
# Error Examples:
At line 75: Unexpected token '}' in expression or statement
At line 110: Write-Host "�o. Found optimal ISO: $($bestISO.Name) ($isoSizeGB GB)"  # Corrupted emoji
At line 114: Write-Host "�s��,?  No Ubuntu ISOs found locally"  # Corrupted warning icon
At line 141: "8GB+ required" - '+' operator parsing failure
```

### `maximum-automation-wizard.ps1`
```powershell
# Error Examples:
At line 62: The hash literal was incomplete (SecureBootUEFI issue)
At line 130-135: Switch statement syntax errors with manufacturer detection
At line 162: Unexpected token '}' - function closure issues
```

## Root Cause Analysis

### Primary Issues
1. **Unicode Emoji Corruption:** Emoji characters (✅, ⚠️, 🔍, etc.) are being corrupted during Git operations or file encoding changes
2. **UTF-8 vs UTF-16 BOM Issues:** PowerShell expects specific encoding for special characters
3. **CRLF vs LF Line Endings:** Mixed line endings causing parser confusion
4. **Hash Table Syntax:** Incomplete hash literals in system detection functions

### Secondary Issues
1. **Switch Statement Malformation:** Manufacturer detection switch has syntax errors
2. **Function Closure Problems:** Missing or extra braces in function definitions
3. **String Interpolation Conflicts:** Unicode characters breaking PowerShell string parsing

## Impact Assessment

### Current Status
- ❌ **Both wizards completely non-functional**
- ❌ **Cannot proceed with automated dual boot setup**
- ❌ **Manual intervention required for all steps**

### Bill's Specific Impact
- **System Ready:** ASUS system with 32GB RAM, 27TB storage, 3 Ubuntu ISOs available
- **Manual Fallback:** Can proceed manually but loses automation benefits
- **WSL2 Preservation:** WSL2 Ubuntu 22.04 remains intact as requested

## Technical Analysis by Script Section

### WSL2 Transition Wizard Issues

**Lines 70-76:** Function closure syntax errors
```powershell
# Current (broken):
    }
    catch {
        Write-Host "ℹ️  WSL2 not detected..." # Unicode corruption
        return "none"
    }
}  # Extra closing brace causing parse error
```

**Lines 105-115:** Emoji corruption in status messages
```powershell
# Current (broken):
Write-Host "�o. Found optimal ISO..." # Should be "✅ Found optimal ISO..."
Write-Host "�s��,?  No Ubuntu ISOs..." # Should be "⚠️  No Ubuntu ISOs..."
```

**Line 141:** Operator parsing failure
```powershell
# Current (broken):
"8GB+ required"  # '+' treated as operator, not string content
# Should be: "8GB or more required" or escaped properly
```

### Maximum Automation Wizard Issues

**Line 62:** Hash table syntax error
```powershell
# Current (broken):
...SetupMode).Bytes[0] -eq 0 } catch { "Unknown" }  # Missing hash closure
# Affects: $systemIntel hash table initialization
```

**Lines 130-135:** Switch statement malformation
```powershell
# Current (broken):
"ASUS" { "F2 or Del" }  # Missing switch context
"Dell" { "F12 or F2" }  # Orphaned case statements
# Should be: Proper switch($manufacturer) structure
```

## Recommended Dev Fixes

### Priority 1: Immediate Fixes
1. **Re-encode all files as UTF-8 with BOM** using proper text editor
2. **Replace all emoji with ASCII equivalents** or escape properly
3. **Fix hash table syntax** in system detection functions
4. **Repair switch statement structure** for manufacturer detection

### Priority 2: Structural Improvements
5. **Standardize line endings** to CRLF for Windows PowerShell
6. **Validate function closures** - check all brace matching
7. **Test string interpolation** with special characters
8. **Add encoding headers** to PowerShell files

### Priority 3: Robustness Enhancements  
9. **Add error handling** for encoding issues
10. **Create ASCII-only fallback versions** of critical functions
11. **Implement character validation** before string operations

## Immediate Workaround Strategy

### For Bill's Dual Boot Setup
1. **Manual ISO Detection:** Use existing Ubuntu 24.04.2 ISOs in Downloads
2. **Manual USB Creation:** Use Rufus directly with found ISOs
3. **Manual Partitioning:** Use E: drive (8.2TB free) for Ubuntu installation
4. **Manual Boot Setup:** Configure ASUS UEFI for dual boot

### Script-Independent Approach
```powershell
# Working commands for immediate use:
Get-ChildItem "$env:USERPROFILE\Downloads\*ubuntu*.iso"  # Find ISOs
Get-CimInstance Win32_LogicalDisk | Where {$_.DriveType -eq 2}  # Find USB drives  
Get-CimInstance Win32_LogicalDisk | Where {$_.DeviceID -eq "E:"}  # Check E: drive space
```

## Testing Requirements Post-Fix

### Validation Checklist
- [ ] **Parse Test:** `powershell -File script.ps1 -WhatIf` (syntax only)
- [ ] **Encoding Test:** Verify Unicode characters display correctly
- [ ] **Function Test:** Test each major function independently  
- [ ] **Integration Test:** Full wizard execution with test parameters
- [ ] **System Test:** Execute on Bill's specific ASUS configuration

### Test Parameters for Bill's System
```powershell
# Test with Bill's exact parameters:
-TargetDrive E -UbuntuSizeGB 500 -FastMode
# System profile: ASUS, 32GB RAM, AMD CPU, UEFI boot
```

## Development Environment Notes

### Character Encoding Requirements
- **PowerShell ISE:** UTF-8 with BOM (recommended)
- **VS Code:** Set encoding to UTF-8 with BOM for .ps1 files
- **Git:** Configure core.autocrlf=true for Windows development
- **Editor:** Ensure Unicode support enabled

### Testing Environment
- **Windows 10/11:** Primary target platform
- **PowerShell 5.1:** Minimum version requirement  
- **Administrator Rights:** Required for disk operations
- **UEFI System:** Primary boot configuration type

## Conclusion

Both scripts have solid logical structure and comprehensive functionality but are blocked by fundamental encoding issues. The functionality needed for Bill's dual boot setup is present but inaccessible due to parse errors.

**Estimated Fix Time:** 2-4 hours for experienced PowerShell developer  
**Risk Level:** Low - issues are purely syntactic, not logical  
**User Impact:** High - complete automation blockage until resolved

The scripts represent significant automation value once encoding issues are resolved. Manual fallback procedures can proceed immediately while dev addresses these technical issues.