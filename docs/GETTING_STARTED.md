# Getting Started with Genesis OS (Galaxy J6)

## What You Need

| Item | Notes |
|------|-------|
| Samsung Galaxy J6 | SM-J600F, SM-J600G, or SM-J600GN |
| Linux PC or WSL2 | Ubuntu 20.04+ recommended |
| USB cable | USB-A to micro-USB |
| ~30 GB free disk space | For kernel + rootfs sources |

## 1 — Install Build Dependencies

```bash
sudo apt update && sudo apt install -y \
  git curl zip unzip python3 python3-pip bc \
  build-essential libssl-dev flex bison \
  gcc-aarch64-linux-gnu \
  adb fastboot simg2img
```

Install `repo`:
```bash
curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
```

## 2 — Clone Genesis OS

```bash
git clone https://github.com/Cassai2026/Genesis-OS-J6.git
cd Genesis-OS-J6
```

## 3 — Build

```bash
# Full build (kernel → rootfs → debloat → launcher → package)
make all

# Or step by step:
make kernel      # ~20 min
make rootfs      # ~2–4 hours (downloads ~200 GB of sources first time)
make debloat
make launcher    # Bundles Genesis-Mobile PWA as system app
make package     # Produces out/genesis-os-j6lte-<date>.zip
```

The flashable ZIP lands in `out/`.

## 4 — Flash

Follow **[flashing_j6.md](flashing_j6.md)** to put Genesis OS on the device.

## 5 — First Boot

On first boot the **Genesis Mobile Sovereign HUD** launches automatically as
the home screen. It connects to the CassAI mesh network and displays the
15-Pillar live dashboard.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `aarch64-linux-gnu-gcc: not found` | `sudo apt install gcc-aarch64-linux-gnu` |
| `repo: command not found` | Add `~/bin` to PATH: `export PATH=~/bin:$PATH` |
| Build fails with Java error | `sudo apt install openjdk-11-jdk` |
| Device not detected | Enable Developer Options → USB Debugging |
