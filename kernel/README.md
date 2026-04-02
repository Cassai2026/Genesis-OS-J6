# Genesis OS — Kernel (Samsung Galaxy J6 / j6lte)

## Source

| Item | Value |
|------|-------|
| SoC | Samsung Exynos 7870 (ARM Cortex-A53 octa-core) |
| Architecture | arm64 |
| Android base | LineageOS 18.1 (Android 11) |
| Kernel tree | [LineageOS/android_kernel_samsung_exynos7870](https://github.com/LineageOS/android_kernel_samsung_exynos7870) |
| Branch | `lineage-18.1` |
| Cross-compiler | `aarch64-linux-gnu-` (GCC 9+) |

## Privacy-Hardened Config

The Genesis defconfig (`defconfig/genesis_j6lte_defconfig`) is based on the
LineageOS default config with the following changes:

| Option | Value | Reason |
|--------|-------|--------|
| `CONFIG_SECURITY_SELINUX` | `y` | Enforce SELinux |
| `CONFIG_SECURITY_SELINUX_BOOTPARAM` | `n` | Prevent disabling at boot |
| `CONFIG_IKCONFIG_PROC` | `n` | Hide kernel config from /proc |
| `CONFIG_KPROBES` | `n` | Prevent in-kernel tracing |
| `CONFIG_BPF_SYSCALL` | `n` | Reduce kernel attack surface |
| `CONFIG_USERFAULTFD` | `n` | Mitigate UAF exploits |
| `CONFIG_PROC_VMCORE` | `n` | Disable crash dump (prevents memory leaks) |
| `CONFIG_NETFILTER_XT_MATCH_OWNER` | `y` | Per-app firewall support |
| `CONFIG_IPV6` | `y` | IPv6 mesh support for Spider-Web protocol |

## Manual Build

```bash
# Install toolchain
sudo apt install gcc-aarch64-linux-gnu

# Clone kernel source
git clone --depth=1 -b lineage-18.1 \
  https://github.com/LineageOS/android_kernel_samsung_exynos7870.git kernel_src

# Apply Genesis config
cp defconfig/genesis_j6lte_defconfig kernel_src/arch/arm64/configs/

# Build
cd kernel_src
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- genesis_j6lte_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- -j$(nproc) Image.gz dtbs
```

Output: `arch/arm64/boot/Image.gz`

## Applying Patches

Place `.patch` files in `kernel/patches/`. The build script applies them in
alphabetical order via `git apply`. Use the naming convention:

```
0001-description.patch
0002-description.patch
```

Generate a patch from a commit:
```bash
git -C kernel_src format-patch -1 <commit-sha> -o ../kernel/patches/
```
