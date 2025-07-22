# 🚀 BILL SLOTH SETUP GUIDE

## Hey Bill! Let's Get Your System Running 🦥

This guide will walk you through getting Bill Sloth on your Linux machine. Just copy and paste the commands - easy as that!

---

## Step 1: Open a Terminal

First, you need to open a terminal on your Linux machine:
- Press `Ctrl + Alt + T` on most Linux systems
- Or look for "Terminal" in your applications menu

---

## Step 2: Download Bill Sloth

Copy and paste this ENTIRE command into your terminal and press Enter:

```bash
cd ~ && git clone https://github.com/How1337ItIs/billsloth.git "bill sloth" && cd "bill sloth"
```

**What this does:**
- Goes to your home folder
- Downloads your Bill Sloth system
- Enters the Bill Sloth folder

**If you see an error** about git not being installed, run this first:
```bash
sudo apt install git
```

---

## Step 3: Make It Executable

Copy and paste this command:

```bash
chmod +x bill_command_center.sh onboard.sh
```

---

## Step 4: Start Bill Sloth! 🎉

Now the fun part! Run:

```bash
./bill_command_center.sh
```

**What happens next:**
1. Bill Sloth will check for required tools
2. If anything is missing, it will ask to install it
3. Just type `Y` and press Enter when asked
4. Let it install what it needs (this only happens once)

---

## Step 5: Set Up Your VRBO Automation

Once in the command center:
1. Press `v` for VRBO automation
2. Follow the questions about your properties
3. Bill Sloth will create custom automation for YOUR specific needs

---

## Troubleshooting

### "Command not found" errors
If you see this, just let Bill Sloth install the missing tools when it asks.

### "Permission denied" errors
Run this command:
```bash
chmod +x -R ~/bill\ sloth/
```

### Need to start over?
```bash
cd ~ && rm -rf "bill sloth" && git clone https://github.com/How1337ItIs/billsloth.git "bill sloth" && cd "bill sloth"
```

---

## Quick Daily Use

After setup, you can always start Bill Sloth with:
```bash
cd ~/bill\ sloth && ./bill_command_center.sh
```

Or create a shortcut:
```bash
echo 'alias bill="cd ~/bill\ sloth && ./bill_command_center.sh"' >> ~/.bashrc && source ~/.bashrc
```

Then just type `bill` from anywhere!

---

## Need Help?

If Claude Code is helping you:
- Show Claude this guide
- Claude can run these commands for you
- Just ask "Can you help me set up Bill Sloth?"

Remember: You're not "bad with computers" - you just haven't had the right tools yet! 🚀