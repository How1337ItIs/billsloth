# Bill Sloth Troubleshooting Guide

## PowerShell Script Issues

### Issue 1: Export-ModuleMember Error

**Problem:**
The `automated-rufus-addon.ps1` script fails when run directly with:
```
Export-ModuleMember : The Export-ModuleMember cmdlet can only be called from inside a module.
```

**Root Cause:**
The script contains `Export-ModuleMember` commands at the end, which only work when the script is saved as a `.psm1` module file, not when executed directly as a `.ps1` script.

**Solution:**
Remove the `Export-ModuleMember` line or restructure as a proper PowerShell module.

### Issue 2: USB Drive Detection Problems

**Problem:**
The USB drive detection logic fails to find drives, showing "Select USB drive number (0--1)" but no drives listed.

**Root Cause:**
The WMI query `$_.DriveType -eq 2 -and $_.Size -gt 4GB` is too restrictive and may not detect all USB drives correctly.

**Solutions:**
1. Expand drive type detection to include specific drive letters
2. Lower size threshold from 4GB to 1GB
3. Add manual drive specification option

### Fixed Scripts Created

#### 1. fixed-usb-creator.ps1
- Removed Export-ModuleMember commands
- Improved USB drive detection
- Added manual drive selection fallback

#### 2. simple-usb-creator.ps1
- Simplified approach for specific drive (H:)
- Direct Rufus integration
- Clear user instructions

## Testing Environment
- Windows 10/11
- PowerShell 5.1
- 256GB USB drive on H: with "Ubuntu" label
- Ubuntu ISO: `C:\Users\Sloth\Downloads\Ubuntu.iso`

## Recommendations for Main Repository

1. **Convert to Module Structure**: Move functions to `.psm1` file with proper module manifest
2. **Improve Drive Detection**: Use more robust USB drive identification
3. **Add Error Handling**: Better user feedback when drives aren't detected
4. **Simplify User Experience**: Reduce command-line complexity for users with accessibility needs

## User Accessibility Notes

This troubleshooting session highlighted the need for:
- Simple copy-paste commands for users with dyslexia
- Clear error messages
- Fallback options when automation fails
- Step-by-step visual guidance

## Files Modified/Created

- `fixed-usb-creator.ps1` - Working version without module export errors
- `simple-usb-creator.ps1` - Simplified version for specific drive
- `TROUBLESHOOTING.md` - This documentation

## Next Steps

1. Integrate fixes into main `automated-rufus-addon.ps1`
2. Add comprehensive error handling
3. Create user-friendly wrapper scripts
4. Add automated testing for different Windows configurations