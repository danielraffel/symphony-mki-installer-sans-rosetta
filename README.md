# 🎛️ Apogee Symphony I/O MKI Manual Installer (No Rosetta)

This project provides a manual install and uninstall workflow for Apogee’s Symphony I/O MKI software that bypasses the official legacy installer, which still requires Rosetta 2 on Apple Silicon Macs and relies on a no-longer-supported interface. This script-based approach allows you to install the necessary components without installing Rosetta.

⚠️ This is not an official installer. This is a user-maintained workaround.
Use at your own risk. No files from Apogee are distributed in this repo.

---

## 📦 Repo Structure

```
├── apogee_installer_files/       # You’ll put extracted Apogee files here
├── install_apogee_manual.sh      # Manual installer script (tested)
└── uninstall_apogee_manual.sh    # Manual uninstaller script (not yet tested)
```

---

## ✅ What This Does

This script replicates the behavior of Apogee’s official `.pkg` installer, including:

- Installing `Apogee Maestro 2.app`
- Installing HAL plug-ins
- Registering background daemons
- Placing system extensions in `/Library/Extensions`
- Prompting macOS to show the **“Allow”** button for Apogee extensions
- Avoiding Rosetta installation and any unnecessary software

---

## 📥 Setup Instructions
Before running the installer script, you'll need to manually extract the original Apogee software files from the official installer package.
These steps are required because the Apogee `.pkg` installer is built for Rosetta. By extracting the necessary files yourself, you avoid installing Rosetta and retain full control over what gets added to your system.

### 🛠️ Step 1: Clone This Repository

First, clone this repo to your local machine:

```bash
git clone https://github.com/danielraffel/symphony-mki-installer-sans-rosetta.git
cd symphony-mki-installer-sans-rosetta
```

This will create a folder called symphony-mki-installer-sans-rosetta containing:
- install_apogee_manual.sh – the main installer script
- uninstall_apogee_manual.sh – optional uninstaller
- apogee_installer_files/ – where you’ll place extracted Apogee files in the next step

### Step 2. Download the official Apogee installer:   
   **Apogee Symphony I/O MKI – Legacy Product Installer v5.5**

   - [📦 Download Official DMG here](https://22712264.fs1.hubspotusercontent-na1.net/hubfs/22712264/Software%20Installers/Symphony%20IO/SymphonyIO_Release_5.5.dmg)  
   - Also available under [Legacy Installers](https://apogeedigital.com/download-files/)

<a href="https://22712264.fs1.hubspotusercontent-na1.net/hubfs/22712264/Software%20Installers/Symphony%20IO/SymphonyIO_Release_5.5.dmg">
  <img width="164" alt="Download Symphony 5.5" src="https://github.com/user-attachments/assets/c07e70d3-cc03-4bc6-aa59-df5fe08aef92" />
</a>

### Step 3. Extract Files from the Installer .pkg Using Suspicious Package
1. Download [Suspicious Package](https://www.mothersruin.com/software/SuspiciousPackage/)
2. Open the DMG and right-click on Symphony Software Installer.pkg
3. Select Open With > Suspicious Package
4. Switch to the All Files tab
5. Drag both the `Applications` and `Library` folders into your local `apogee_installer_files` folder (in this repo)

 <img width="1022" alt="Screenshot 2025-04-10 at 11 44 01 AM" src="https://github.com/user-attachments/assets/78211c87-a056-4efa-b016-8965eb9df2ce" />

⚠️ Note: This repo does not include Apogee’s software.

---
## 🖥️ How to Install

Pre-install: Enable Reduced Security (required by official Apogee software installer too)

1. Shutdown your Mac  
2. Press and hold the **Power** button → click **Options > Continue**  
3. Open **Startup Security Utility**  
4. Select your main disk → click **Security Policy**  
5. Choose:
   - ✅ **Reduced Security**
   - ✅ **"Allow user management of kernel extensions"**

<a href="https://github.com/user-attachments/assets/b910e721-ed59-4799-b228-d7fa5c5024a7">
  <img src="https://github.com/user-attachments/assets/b910e721-ed59-4799-b228-d7fa5c5024a7" alt="Startup Security Utility Screenshot" width="25%" />
</a>

---

## ⌨️ Run the script

```bash
cd /path/to/repo
chmod +x install_apogee_manual.sh
./install_apogee_manual.sh
```

When prompted open System Settings > Privacy & Security and click `Allow` when prompted to approve Apogee’s system software.

<img src="https://github.com/user-attachments/assets/0f9685f3-6d72-432d-8b43-65a6531c05fc" alt="image 1" width="20%" />
<br />
<a href="https://github.com/user-attachments/assets/c45138ba-5165-459c-88bf-9b654159d9d8">
  <img src="https://github.com/user-attachments/assets/c45138ba-5165-459c-88bf-9b654159d9d8" alt="image" width="40%" />
</a>

**macOS will display many windows - select Open or OK where prompted:**
- “System Extension Blocked”
- “Legacy System Extension”
- “Background Items Added”

<img src="https://github.com/user-attachments/assets/343e493e-681e-4b4e-8994-d0821f5cf3a3" alt="image 2" width="20%" />
<img src="https://github.com/user-attachments/assets/be80dc68-f292-445f-bae0-ed65585d715b" alt="image 3" width="20%" />
<img src="https://github.com/user-attachments/assets/c21e64f0-187b-411a-a793-dc68f41a51b1" alt="image 4" width="20%" />
<img src="https://github.com/user-attachments/assets/753e1ffe-89ef-4bf2-aa1b-526a7adea1f2" alt="image 5" width="20%" />
<img src="https://github.com/user-attachments/assets/cdfdd9cb-9248-4eca-963e-7c8bd3f3a54f" alt="image 6" width="20%" />

All of these are expected if the installer completed correctly.

You’ll be prompted to reboot — this is expected.

---

## 🔁 How to Uninstall

Not yet fully tested — use at your own risk, but the logic mirrors the installer.

```
chmod +x uninstall_apogee_manual.sh
./uninstall_apogee_manual.sh
```
---

## ⚠️ Disclaimer

**This project is not affiliated with or endorsed by Apogee Electronics.**
All rights, trademarks, and copyrights for:
- Symphony I/O
- Apogee Maestro
- And all related software belong to © Copyright - Apogee Electronics Corp.

This tool is provided as-is with no warranties. Use at your own risk.

---

## 📖 License

MIT License — You’re free to use, modify, and share this script.
Please do not use this to redistribute Apogee’s proprietary files.
