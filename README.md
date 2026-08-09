# MacBook Broadcom Wireless Driver Setup (BCM4360)

An interactive, menu-driven Bash tool designed to streamline enabling Broadcom Wi-Fi cards on Apple MacBooks running Linux. 

Getting Broadcom Wi-Fi chipset controllers—specifically the **Broadcom Inc. BCM4360 802.11ac Dual Band Wireless Network Adapter**—working on Linux distributions can be notoriously difficult due to proprietary firmware requirements and kernel module conflicts. This project bundles the necessary driver firmware files alongside an automated interactive script, eliminating the need to manually copy firmware files or execute complex terminal commands.

---
<!--
YouTube video link coming here
-->
---
## Features

* **Interactive Menu System:** Keyboard-driven terminal interface (using arrow keys and enter) for simple navigation.
* **Automated Firmware Deployment:** Copies bundled `b43` firmware files to `/lib/firmware/b43` and handles module reloading (`modprobe`).
* **Clean Rollback/Removal:** Safely unloads the `b43` kernel module and strips installed firmware files if initialization fails.
* **Fallback Installation:** Automatically fetches matching Linux kernel headers, `linux-image` packages, and `broadcom-sta-dkms` (`wl` driver) via `apt` if `b43` is unsupported by your chipset variant.
---
## Prerequisites
* **Hardware:** Apple MacBook with an internal Broadcom wireless card (e.g., `BCM4360`).
* **OS / Kernel:** Linux distribution using `apt` package management (Debian, Ubuntu, Linux Mint, Pop!_OS, etc.).
* **Privileges:** Root / `sudo` access to manage system kernel modules and firmware directories.

Verify your hardware model prior to running by executing:
```bash
lspci -nn | grep -i network
```
## Installation & Usage

1.  **Clone the Repository:** Ensure you clone the full repository so that the bundled `b43` firmware directory is present.
```bash
    git clone [https://github.com/LetUsRepair/WiFi-MacBook-Linux.git](https://github.com/LetUsRepair/WiFi-MacBook-Linux.git)
    cd WiFi-MacBook-Linux
``` 
2.  **Make the Script Executable:**
```bash
    chmod +x install-b43.sh 
```
3.  **Run the Interactive Setup:** The script must be run with root privileges to write to `/lib/firmware/` and manipulate kernel modules.
```bash
    sudo ./install-b43.sh
```
## Workflow Overview
When you launch `install-b43.sh`, an interactive menu presents the following options:
```plaintext
=== Linux/MacBook b43 Menu ===
Use UP/DOWN arrow keys, ENTER to select.

 >  Install and try with b43 drivers
    Remove b43 drivers
    Update wl and dkms
    Quit
```
-   **Option 1: Install and try with b43 drivers**
    -   Verifies the presence of the `./b43` repository folder.
    -   Creates `/lib/firmware/b43/` and copies the firmware payload.
    -   Reloads the `b43` kernel module.
        
-   **Option 2: Remove b43 drivers**
    -   Unloads the `b43` kernel module (`modprobe -rv b43`).
    -   Removes `/lib/firmware/b43` cleanly. Use this if `b43` causes instability or fails to load your interface.
        
-   **Option 3: Update wl and dkms**
    -   Runs an `apt` routine to dynamically detect your running kernel version, install matching `linux-headers`, and set up `broadcom-sta-dkms` (the proprietary `wl` driver alternative).
        
-   **Option 4: Quit**
    -   Restores terminal cursor visibility and exits cleanly.

## Directory Structure
```plaintext.
├── b43/               # Directory containing extraction/firmware binaries
├── install-b43.sh     # Interactive deployment script
└── README.md          # Project documentation
```

## Troubleshooting
-   **Missing Driver Directory Error:** If selecting option 1 returns `Driver directory not found`, ensure you are executing the script directly from the root of the cloned repository folder containing the `b43/` subdirectory.
    
-   **Intermittent Connection / No Interface:** If the `b43` module succeeds in loading but no wireless interface appears, use Option 2 to purge the `b43` firmware, then run Option 3 to build and load `broadcom-sta-dkms` instead.

## Contributing
Pull requests, improvements to the menu interface, or additional chipset firmware support are welcome. Please open an issue first to discuss intended changes.
