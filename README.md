# 🪟 Windows 11 Upgrade Script

PowerShell script that automates a **silent in-place upgrade to Windows 11 25H2 (build 26000+)** using a local ISO image.  
Includes a batch launcher to elevate privileges automatically and start the upgrade process with a single click.

---

## ⚙️ Features

- Detects current Windows version and skips upgrade if already on 25H2 or newer  
- Validates presence of the ISO file (`C:\windows11.iso`)  
- Creates installation and logging directories (`C:\Install\Win11Upgrade`)  
- Verifies administrator privileges before proceeding  
- Mounts and unmounts the ISO automatically  
- Runs Windows Setup silently with upgrade parameters  
- Logs all operations and results  

---

## 📁 Repository Structure

Windows11-Upgrade-Automation/

│
├── script.ps1 # Main PowerShell upgrade logic
├── run.bat # Launcher that starts script.ps1 with admin rights
├── README.md # Documentation (this file)
└── LICENSE # MIT license

---

## 🚀 Usage

### 1. Prepare the ISO
Place your Windows 11 25H2 ISO image at: C:\windows11.iso

### 2. Download the Scripts
Clone or download this repository to your computer (e.g., Desktop).

### 3. Run the Batch File
Double-click:
It will automatically:
- launch PowerShell,
- bypass execution policy,
- elevate privileges (UAC prompt),
- execute the `script.ps1` file.

### 4. Logs
Logs are stored in:
C:\Install\Win11Upgrade\Windows11Upgrade_<timestamp>.log

---

## 🧾 Example Output

Checking system version...

Mounting ISO: C:\windows11.iso

ISO mounted on drive: E:

Starting Windows 11 upgrade...

Upgrade process has started.


---

## 🧰 Requirements

- Windows 10 or older Windows 11 build  
- Administrator privileges  
- Local Windows 11 25H2 ISO image at `C:\windows11.iso`  
- PowerShell 5.1 or newer  

---

## 🧑‍💻 License

This project is licensed under the [MIT License](./LICENSE).

****


