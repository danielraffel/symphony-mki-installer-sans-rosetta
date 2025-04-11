#!/bin/bash

###############################################################################
# Apogee Manual Uninstaller Script
#
# This script cleanly removes all components installed by the
# `install_apogee_manual.sh` script — ideal for:
# - Uninstalling without using Apogee’s .pkg uninstaller
# - Fully removing Apogee software without Rosetta
# - Cleaning up a manual install or test environment
#
# 🧹 What This Script Removes:
# - Apogee Maestro 2.app from /Applications
# - ApogeeRegistration.app from /Applications/Utilities
# - HAL plug-ins from /Library/Audio/Plug-Ins/HAL/Apogee
# - ApogeePopup.bundle from /Library/Application Support/Apogee/
# - Kernel extensions (kexts) such as Symphony64.kext from /Library/Extensions/
# - LaunchDaemons from /Library/LaunchDaemons/ and unloads them
# - Installed product preferences from /Library/Preferences/com.apogee.productsInstalled.plist
#
# 🔐 macOS Considerations:
# - If any of the installed `.kext` files were approved via System Settings,
#   they may still appear in your system's security database even after removal.
# - You may need to reboot after uninstalling to fully remove their effects.
#
# 🛠️ How to Run:
# 1. Open Terminal
# 2. Navigate to the script’s directory:
#      cd /path/to/this/script
# 3. Make the script executable (only once):
#      chmod +x uninstall_apogee_manual.sh
# 4. Run the script:
#      ./uninstall_apogee_manual.sh
#
# 💡 Tip:
# You can run this even if the Apogee installer wasn't completed —
# it will safely ignore anything that doesn’t exist.
#
###############################################################################

# ⚙️ Script Settings
set -e  # Exit immediately if any command fails

# 📝 Log Output
# Logs all output (stdout and stderr) to both the Terminal and a log file.
# Optional: Use Desktop for easier access, or change to /var/log/ for system-wide logs
LOG="$HOME/Desktop/apogee_manual_uninstall.log"

# Send all script output to both the terminal and the log file
exec > >(tee -a "$LOG") 2>&1

echo "Starting Apogee manual uninstall..."

# 1. Remove Application
if [ -d "/Applications/Apogee Maestro 2.app" ]; then
    echo "Removing Apogee Maestro 2.app..."
    sudo rm -rf "/Applications/Apogee Maestro 2.app"
fi

# 2. Remove HAL Plug-ins
HAL_PATH="/Library/Audio/Plug-Ins/HAL/Apogee/Symphony Systems"
if [ -d "$HAL_PATH" ]; then
    echo "Removing HAL plug-ins..."
    sudo rm -rf "$HAL_PATH"
fi

# 3. Unload and Remove LaunchDaemons
for plist in \
    /Library/LaunchDaemons/com.SymphonyDaemon.plist \
    /Library/LaunchDaemons/com.SymphonyIOUSBDaemon.plist \
    /Library/LaunchDaemons/com.usbApogeeDaemon.plist; do
    if [ -f "$plist" ]; then
        echo "Unloading and removing $plist..."
        sudo launchctl bootout system "$plist" 2>/dev/null || true
        sudo rm "$plist"
    fi
done

# 4. Remove ApogeePopup.bundle
POPUP_PATH="/Library/Application Support/Apogee/ApogeePopup.bundle"
if [ -d "$POPUP_PATH" ]; then
    echo "Removing ApogeePopup.bundle..."
    sudo rm -rf "$POPUP_PATH"
fi

# 5. Remove System Extensions (kexts)
for ext in \
    /Library/Extensions/Symphony64.kext \
    /Library/Extensions/SymphonyIOUSBOverideDriver.kext \
    /Library/Extensions/Symphony64Thunderbridge.kext; do
    if [ -d "$ext" ]; then
        echo "Removing $ext..."
        sudo rm -rf "$ext"
    fi
done

echo "Touching Extensions to update system cache..."
sudo touch /Library/Extensions

# 6. Remove product registration plist keys
PLIST="/Library/Preferences/com.apogee.productsInstalled.plist"
if [ -f "$PLIST" ]; then
    echo "Cleaning up product registration plist..."
    sudo /usr/libexec/PlistBuddy -c "Delete :Symphony\ I/O" "$PLIST" 2>/dev/null || true
    sudo /usr/libexec/PlistBuddy -c "Delete :Symphony\ System" "$PLIST" 2>/dev/null || true

    # If the plist is empty now, delete it
    if [[ "$(plutil -p "$PLIST" 2>/dev/null)" == "{}" ]]; then
        echo "Deleting empty plist..."
        sudo rm "$PLIST"
    fi
fi

echo "Apogee manual uninstall complete."
