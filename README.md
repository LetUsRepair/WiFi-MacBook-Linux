# MacBook Broadcom Wireless Driver Setup (BCM4360)

An interactive, menu-driven Bash tool designed to streamline enabling Broadcom Wi-Fi cards on Apple MacBooks running Linux. 

Getting Broadcom Wi-Fi chipset controllers—specifically the **Broadcom Inc. BCM4360 802.11ac Dual Band Wireless Network Adapter**—working on Linux distributions can be notoriously difficult due to proprietary firmware requirements and kernel module conflicts. This project bundles the necessary driver firmware files alongside an automated interactive script, eliminating the need to manually copy firmware files or execute complex terminal commands.

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