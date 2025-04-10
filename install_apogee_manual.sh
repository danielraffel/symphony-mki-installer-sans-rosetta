#!/bin/bash

###############################################################################
# Apogee Manual Installer Script (No Rosetta Required)
#
# This script installs Apogee Symphony software components manually, bypassing
# the official .pkg installer in order to avoid installing Rosetta 2 or other
# components you don’t want on your system.
#
# ✅ What This Script Does:
# - Installs Apogee Maestro 2.app to /Applications
# - Installs HAL plug-ins to /Library/Audio/Plug-Ins/HAL
# - Installs launch daemons to /Library/LaunchDaemons and loads them
# - Optionally installs ApogeePopup.bundle
# - Installs .kext files (if provided) to /Library/Extensions
# - Triggers macOS to detect and prompt for kext approval
# - Registers installed products in /Library/Preferences
#
# 🔐 macOS Security Requirements:
# To use kernel extensions (kexts) on Apple Silicon, you must enable
# **Reduced Security Mode** with user kext loading allowed:
#
# ▶️ How to enable Reduced Security Mode (Apple Silicon Macs):
# 1. Shutdown your Mac.
# 2. Press and hold the **Power button** until "Loading startup options" appears.
# 3. Click **Options**, then **Continue**.
# 4. From the **Utilities** menu, choose **Startup Security Utility**.
# 5. Select your system disk → Click **Security Policy...**
# 6. Choose:
#    - **Reduced Security**
#    - ✔️ "Allow user management of kernel extensions"
# 7. Restart your Mac normally.
#
# 📦 Folder Structure Required:
# This script expects a folder called `apogee_installer_files` alongside it:
#
#   .
#   ├── install_apogee_manual.sh
#   └── apogee_installer_files/
#       ├── Applications/
#       ├── Library/
#
# 🛠️ How to Run:
# 1. Open Terminal
# 2. Navigate to the script’s directory:
#      cd /path/to/this/script
# 3. Make the script executable (only once):
#      chmod +x install_apogee_manual.sh
# 4. Run the script:
#      ./install_apogee_manual.sh
#
# ⚠️ You’ll be prompted to restart at the end. After reboot:
# - Go to **System Settings > Privacy & Security**
# - Click **"Allow"** if prompted to approve Apogee software
#
# 🧹 Uninstalling:
# A matching script, `uninstall_apogee_manual.sh`, is provided to fully remove
# all installed files (apps, daemons, plug-ins, preferences, and extensions).
#
###############################################################################

# ⚙️ Script Settings
set -e  # Exit immediately if any command fails

# 📝 Log Output
# Logs all output (stdout and stderr) to both the Terminal and a log file.
# Optional: Use Desktop for easier access, or change to /var/log/ for system-wide logs
LOG="$HOME/Desktop/apogee_manual_install.log"

# Send all script output to both the terminal and the log file
exec > >(tee -a "$LOG") 2>&1

SOURCE_DIR="./apogee_installer_files"

# 1. Copy Maestro App
if [ -d "$SOURCE_DIR/Applications/Apogee Maestro 2.app" ]; then
    echo "Installing Apogee Maestro 2.app..."
    sudo cp -R "$SOURCE_DIR/Applications/Apogee Maestro 2.app" /Applications/
fi

# 2. Copy Apogee Registration App (if included)
if [ -d "$SOURCE_DIR/Applications/Utilities/ApogeeRegistration.app" ]; then
    echo "Installing ApogeeRegistration.app..."
    sudo mkdir -p /Applications/Utilities
    sudo cp -R "$SOURCE_DIR/Applications/Utilities/ApogeeRegistration.app" /Applications/Utilities/
fi

# 3. Install HAL Plug-ins
HAL_DEST="/Library/Audio/Plug-Ins/HAL/Apogee/Symphony Systems"
HAL_SOURCE="$SOURCE_DIR/Library/Audio/Plug-Ins/HAL/Apogee/Symphony Systems"
if [ -d "$HAL_SOURCE" ]; then
    echo "Installing HAL plug-ins..."
    sudo mkdir -p "$HAL_DEST"
    sudo cp -R "$HAL_SOURCE/"* "$HAL_DEST/"
fi

# 4. Install LaunchDaemons
DAEMON_SOURCE="$SOURCE_DIR/Library/LaunchDaemons"
if [ -d "$DAEMON_SOURCE" ]; then
    echo "Installing LaunchDaemons..."
    sudo cp "$DAEMON_SOURCE/"*.plist /Library/LaunchDaemons/
    for plist in /Library/LaunchDaemons/com.Symphony*.plist /Library/LaunchDaemons/com.usbApogeeDaemon.plist; do
        if [ -f "$plist" ]; then
            sudo launchctl load "$plist" || echo "Warning: failed to load $plist"
        fi
    done
fi

# 5. Install ApogeePopup.bundle (optional)
POPUP_SOURCE="$SOURCE_DIR/Library/Application Support/Apogee/ApogeePopup.bundle"
if [ -d "$POPUP_SOURCE" ]; then
    echo "Installing ApogeePopup.bundle..."
    sudo mkdir -p "/Library/Application Support/Apogee"
    sudo cp -R "$POPUP_SOURCE" "/Library/Application Support/Apogee/"
fi

# 6. Install System Extensions (if present and needed)
EXT_SOURCE="$SOURCE_DIR/Library/Extensions"
if [ -d "$EXT_SOURCE" ]; then
    echo "Installing kernel extensions..."
    sudo cp -R "$EXT_SOURCE/"*.kext /Library/Extensions/

    echo "🔧 Touching /Library/Extensions to notify macOS of new extensions..."
    sudo touch /Library/Extensions

    echo "✅ Kernel extensions copied."

    echo "⚠️  You may need to approve the Apogee extensions manually."
    echo "👉 After reboot, go to System Settings > Privacy & Security."
    echo "If you see a message saying that system software from 'Apogee' was blocked, click 'Allow'."
    echo ""

    read -p "Would you like to restart now to trigger the approval prompt? (y/n) " choice
    if [[ "$choice" =~ ^[Yy]$ ]]; then
        echo "🔁 Rebooting now..."
        sudo shutdown -r now
    else
        echo "🚨 Please remember to restart your Mac manually to complete the installation."
    fi
fi

# 7. Register installed products using PlistBuddy
PLIST="/Library/Preferences/com.apogee.productsInstalled.plist"
echo "Registering Symphony I/O and Symphony System in preferences..."
sudo /usr/libexec/PlistBuddy -c "Add :Symphony\ I/O string 'Symphony I/O'" "$PLIST" 2>/dev/null || \
sudo /usr/libexec/PlistBuddy -c "Set :Symphony\ I/O 'Symphony I/O'" "$PLIST"

sudo /usr/libexec/PlistBuddy -c "Add :Symphony\ System string 'Symphony System'" "$PLIST" 2>/dev/null || \
sudo /usr/libexec/PlistBuddy -c "Set :Symphony\ System 'Symphony System'" "$PLIST"

echo "Apogee installation completed."