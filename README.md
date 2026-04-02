# Genesis-OS-J6

A privacy-first, bloat-free Android-based operating system for the **Samsung Galaxy J6** (SM-J600F/G/GN — codename `j6lte`, Exynos 7870).

Genesis OS replaces the stock Samsung/Android OS, preserves your personal data, and removes every tracker, telemetry service, and piece of bloatware shipped by the manufacturer.

---

## Goals

| Goal | Status |
|------|--------|
| Privacy-hardened kernel (Exynos 7870) | 🚧 In Progress |
| De-bloated AOSP userspace | 🚧 In Progress |
| Personal-data migration/restore tool | 📋 Planned |
| Web-USB / ADB one-click installer | 📋 Planned |

---

## Device Compatibility

| Device | Codename | SoC | Android Base |
|--------|----------|-----|--------------|
| Samsung Galaxy J6 (SM-J600F/G/GN) | `j6lte` | Exynos 7870 | LineageOS 18.1 (Android 11) |

---

## Quick Build

### Prerequisites

- Ubuntu 20.04 or later (or WSL2)
- `git`, `repo`, `make`, `adb`, `fastboot`
- Android build dependencies: `build-essential`, `python3`, `libssl-dev`, `bc`, `curl`, `zip`
- ARM cross-compiler: `gcc-arm-linux-gnueabihf`, `gcc-aarch64-linux-gnu`

Install all at once:

```bash
sudo apt update && sudo apt install -y \
  git curl zip unzip build-essential bc libssl-dev \
  python3 python3-pip \
  gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu \
  adb fastboot
```

### Build

```bash
# Clone this repo
git clone https://github.com/Cassai2026/Genesis-OS-J6.git
cd Genesis-OS-J6

# Fetch kernel source, build, and assemble rootfs
make all

# Or step by step:
make kernel      # Build the kernel
make rootfs      # Assemble the root filesystem
make debloat     # Strip trackers and bloatware
make package     # Zip into a flashable image
```

The final flashable ZIP is written to `out/genesis-os-j6lte-<version>.zip`.

---

## Flashing

See **[docs/flashing_j6.md](docs/flashing_j6.md)** for a step-by-step guide to unlock the bootloader, flash a custom recovery (TWRP), and install Genesis OS.

---

## Project Layout

```
Genesis-OS-J6/
├── Makefile                   # Top-level build coordinator
├── build-scripts/
│   ├── build_kernel.sh        # Fetch and build the J6 kernel
│   ├── build_rootfs.sh        # Fetch LineageOS sources and assemble rootfs
│   └── debloat.sh             # Remove trackers and bloatware from the image
├── kernel/
│   ├── README.md              # Kernel source notes and patch guide
│   ├── defconfig/
│   │   └── genesis_j6lte_defconfig  # Privacy-hardened kernel config
│   └── patches/               # Out-of-tree security and privacy patches
├── userspace/
│   └── init/
│       └── init.genesis.rc    # Genesis-specific init script
├── docs/
│   ├── GETTING_STARTED.md
│   └── flashing_j6.md
└── out/                       # Build output (git-ignored)
```

---

## Contributing

PRs welcome. Please open an issue first to discuss large changes.

## License

GPL-2.0 — see [LICENSE](LICENSE).
