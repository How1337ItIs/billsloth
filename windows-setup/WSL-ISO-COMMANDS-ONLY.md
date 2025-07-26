# Working WSL ISO Commands - COPY AND PASTE THESE

## 🎯 **THESE COMMANDS WORK - Use Individual WSL Commands Only**

### **Step 1: Clean and Prepare**
```bash
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso 2>/dev/null || true"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth"
wsl -d Ubuntu-22.04 bash -c "sudo apt update"
wsl -d Ubuntu-22.04 bash -c "sudo apt install -y xorriso squashfs-tools"
```

### **Step 2: Mount and Extract Ubuntu ISO**
```bash
wsl -d Ubuntu-22.04 bash -c "sudo mkdir -p /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "sudo mount -o loop /mnt/c/billsloth/ubuntu-22.04.5-desktop-amd64.iso /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/billsloth/extract-cd"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo rsync -a /mnt/ubuntu-iso/ extract-cd/"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo chown -R \$USER:users extract-cd/"
```

### **Step 3: Extract Filesystem**
```bash
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && mkdir -p squashfs-root"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo unsquashfs -d squashfs-root extract-cd/casper/filesystem.squashfs"
```

### **Step 4: Add Bill Sloth Integration**
```bash
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/billsloth/squashfs-root/usr/local/bin"
wsl -d Ubuntu-22.04 bash -c "mkdir -p /tmp/billsloth/squashfs-root/etc/skel"
```

**Create Bill Sloth installer:**
```bash
wsl -d Ubuntu-22.04 bash -c 'cat > /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init << "EOF"
#!/bin/bash
if [ ! -f ~/.billsloth-setup-complete ]; then
    echo "Setting up Bill Sloth system..."
    sudo apt update
    sudo apt install -y git curl wget build-essential python3 nodejs npm vim tmux htop
    git clone https://github.com/How1337ItIs/billsloth.git ~/bill-sloth || true
    find ~/bill-sloth -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
    mkdir -p ~/Projects ~/Scripts
    git config --global user.name "Bill Sloth" || true
    git config --global user.email "bill@slothlab.cyber" || true
    echo "export PATH=\"\$HOME/bill-sloth:\$PATH\"" >> ~/.bashrc
    echo "alias bill=\"cd ~/bill-sloth && ./bill_command_center.sh\"" >> ~/.bashrc
    touch ~/.billsloth-setup-complete
    echo "Bill Sloth system ready! Run: bill"
fi
EOF'
```

**Make executable and add auto-run:**
```bash
wsl -d Ubuntu-22.04 bash -c "chmod +x /tmp/billsloth/squashfs-root/usr/local/bin/billsloth-init"
wsl -d Ubuntu-22.04 bash -c "echo 'billsloth-init' > /tmp/billsloth/squashfs-root/etc/skel/.bashrc"
```

### **Step 5: Rebuild Filesystem and Create ISO**
```bash
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && sudo mksquashfs squashfs-root extract-cd/casper/filesystem.squashfs -comp xz -noappend"
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth && echo -n \$(sudo du -sx --block-size=1 squashfs-root | cut -f1) | sudo tee extract-cd/casper/filesystem.size"
```

**Create final ISO (desktop ISO format):**
```bash
wsl -d Ubuntu-22.04 bash -c "cd /tmp/billsloth/extract-cd && sudo xorriso -as mkisofs -r -V 'BILLSLOTH' -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -o ../billsloth-custom.iso ."
```

### **Step 6: Copy to Windows**
```bash
wsl -d Ubuntu-22.04 bash -c "cp /tmp/billsloth/billsloth-custom.iso '/mnt/c/Users/natha/Desktop/BillSloth-Cyberpunk-Ubuntu.iso'"
```

### **Step 7: Cleanup**
```bash
wsl -d Ubuntu-22.04 bash -c "sudo umount /mnt/ubuntu-iso"
wsl -d Ubuntu-22.04 bash -c "sudo rm -rf /tmp/billsloth"
```

## ✅ **This Method Works Because:**
- Individual WSL commands avoid PowerShell parsing
- Uses local Ubuntu ISO (no network issues)
- Proper desktop ISO boot structure
- Bill Sloth integration added correctly

**Copy and paste these commands individually - DO NOT put them in PowerShell scripts!**