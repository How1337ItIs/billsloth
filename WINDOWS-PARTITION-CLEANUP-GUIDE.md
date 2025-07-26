# 🪟 Windows-Based Ubuntu Partition Cleanup Guide

**Issue:** Ubuntu live environment crashes, can't use GParted  
**Solution:** Clean up old Ubuntu partitions from Windows before attempting reinstall  
**Goal:** Remove Ubuntu remnants so installer shows "alongside Windows" instead of "alongside Ubuntu"

---

## 🎯 **WINDOWS CLEANUP METHODS**

### **Method 1: Windows Disk Management (Built-in)**

#### **Step 1: Open Disk Management**
```
Option A - Right-click Start Menu:
✅ RIGHT-CLICK: Windows Start button
✅ SELECT: "Disk Management"

Option B - Run Dialog:
✅ PRESS: Windows + R
✅ TYPE: diskmgmt.msc
✅ PRESS: Enter

Option C - Search:
✅ CLICK: Start menu
✅ TYPE: "disk management"
✅ CLICK: "Create and format hard disk partitions"
```

#### **Step 2: Identify Ubuntu Partitions**
```
WHAT TO LOOK FOR:

✅ WINDOWS PARTITIONS (KEEP THESE):
- File System: NTFS
- Status: Healthy (Primary Partition)
- Usually labeled with drive letters (C:, etc.)

❌ UBUNTU PARTITIONS (DELETE THESE):
- File System: Shows as blank or "Unknown"
- No drive letter assigned
- May show as "Healthy (Primary Partition)" but no NTFS
- Typically multiple partitions without Windows labels

VISUAL CLUES:
- Ubuntu partitions often appear as 2-3 consecutive partitions
- One larger partition (ext4 - shows as unknown)
- One smaller partition (swap - shows as unknown)
- Located on the drive where you tried to install Ubuntu
```

#### **Step 3: Delete Ubuntu Partitions**
```
⚠️ CRITICAL SAFETY CHECK:
Before deleting ANY partition, verify:
✅ It's NOT labeled as NTFS
✅ It has NO drive letter (C:, D:, etc.)
✅ It's NOT your Windows system partition
✅ It's NOT the EFI System Partition (usually 100MB)

TO DELETE:
1. RIGHT-CLICK: On the Ubuntu partition (unknown filesystem)
2. SELECT: "Delete Volume"
3. CONFIRM: "Yes" to warning
4. RESULT: Partition becomes "Unallocated Space"

REPEAT: For each Ubuntu partition
```

---

### **Method 2: DiskPart Command Line (More Control)**

#### **Step 1: Open DiskPart as Administrator**
```
✅ PRESS: Windows + X
✅ SELECT: "Windows Terminal (Admin)" or "Command Prompt (Admin)"
✅ TYPE: diskpart
✅ PRESS: Enter
```

#### **Step 2: List and Select Disk**
```
DISKPART> list disk

  Disk ###  Status         Size     Free     Dyn  Gpt
  --------  -------------  -------  -------  ---  ---
  Disk 0    Online         465 GB   0 B           *
  Disk 1    Online         9313 GB  0 B           *

DISKPART> select disk 1
(Select the disk with Ubuntu partitions - likely your larger drive)

DISKPART> list partition

  Partition ###  Type              Size     Offset
  -------------  ----------------  -------  -------
  Partition 1    Primary           100 MB   1024 KB
  Partition 2    Primary           465 GB   101 MB
  Partition 3    Unknown           50 GB    466 GB   ← Ubuntu
  Partition 4    Unknown           8 GB     516 GB   ← Ubuntu swap
```

#### **Step 3: Delete Ubuntu Partitions**
```
⚠️ TRIPLE-CHECK partition numbers before deleting!

DISKPART> select partition 3
DISKPART> delete partition override

DISKPART> select partition 4  
DISKPART> delete partition override

DISKPART> exit
```

---

### **Method 3: Third-Party Tools (User-Friendly)**

#### **Option A: MiniTool Partition Wizard (Free)**
```
1. DOWNLOAD: From minitool.com
2. INSTALL: Run installer as Administrator
3. LAUNCH: MiniTool Partition Wizard
4. IDENTIFY: Ubuntu partitions (ext4/linux-swap)
5. RIGHT-CLICK: Each Ubuntu partition
6. SELECT: "Delete"
7. CLICK: "Apply" button to commit changes
```

#### **Option B: EaseUS Partition Master (Free)**
```
Similar process to MiniTool:
- Better visual interface
- Clear partition type labels
- Undo functionality
```

---

## 🔍 **VERIFICATION AFTER CLEANUP**

### **Check in Disk Management:**
```
✅ Ubuntu partitions gone
✅ Shows as "Unallocated Space"
✅ Windows partitions intact
✅ System still boots to Windows
```

### **Optional: Expand Windows Partition**
```
If you want to reclaim space:
1. RIGHT-CLICK: Windows partition next to unallocated space
2. SELECT: "Extend Volume"
3. FOLLOW: Wizard to add unallocated space to Windows

OR leave unallocated for Ubuntu installation
```

---

## 🚀 **AFTER CLEANUP - RETRY UBUNTU INSTALLATION**

### **Boot Fixes to Try:**
```
Since Ubuntu crashed before, try these boot parameters:

1. BOOT: From Ubuntu USB
2. PRESS: 'e' when GRUB menu appears
3. ADD: These parameters after "quiet splash"

ASUS-SPECIFIC FIX:
nomodeset acpi=off acpi_osi=Linux

ALTERNATIVE FIXES:
- nomodeset nouveau.modeset=0 (NVIDIA issues)
- nomodeset radeon.modeset=0 (AMD issues)
- mem=4G (memory issues)

4. PRESS: Ctrl+X to boot with parameters
```

### **Expected Result:**
```
✅ Ubuntu boots without crash
✅ Installer shows "Install Ubuntu alongside Windows Boot Manager"
✅ No more "alongside Ubuntu" option
✅ Clean dual-boot installation possible
```

---

## 🆘 **IF UBUNTU STILL CRASHES**

### **Alternative Approach 1: Different Ubuntu Version**
```
Try Ubuntu 22.04.5 LTS instead of 24.04:
- More stable with older hardware
- Better driver support
- Download from ubuntu.com/download
```

### **Alternative Approach 2: Different Boot Mode**
```
In BIOS/UEFI:
✅ Try: Disable Secure Boot
✅ Try: Enable CSM/Legacy Support
✅ Try: Disable Fast Boot
✅ Try: Change SATA mode to AHCI
```

### **Alternative Approach 3: Minimal Installation**
```
Try Ubuntu Server first:
1. Install Ubuntu Server (text-based, more stable)
2. Add desktop later: sudo apt install ubuntu-desktop
3. Less likely to crash during installation
```

---

## 📋 **QUICK SUMMARY FOR BILL**

### **From Windows:**
1. **Open:** Disk Management (right-click Start → Disk Management)
2. **Find:** Partitions without drive letters (Ubuntu remnants)
3. **Delete:** Each non-NTFS partition carefully
4. **Verify:** Only "Unallocated Space" remains where Ubuntu was
5. **Retry:** Ubuntu installation with boot parameters

### **Boot Parameters for ASUS:**
```
nomodeset acpi=off acpi_osi=Linux
```

---

## ⚠️ **FINAL SAFETY REMINDER**

```
🚨 NEVER DELETE:
- NTFS partitions (Windows data)
- Partitions with drive letters (C:, D:, etc.)
- EFI System Partition (boot files)
- Recovery partitions

✅ ONLY DELETE:
- Partitions showing as "Unknown" filesystem
- Partitions without drive letters
- Confirmed Ubuntu/Linux partitions
```

**🎯 After cleanup, Ubuntu installer should properly detect Windows and offer clean dual-boot setup.**