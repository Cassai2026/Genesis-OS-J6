#!/usr/bin/env bash
# build-scripts/build_kernel.sh
# Fetches the Samsung Exynos 7870 kernel source for the Galaxy J6 (j6lte)
# and builds a privacy-hardened kernel image.
#
# Source: LineageOS kernel for samsung/j6lte
# https://github.com/LineageOS/android_kernel_samsung_exynos7870

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${REPO_ROOT}/out"
KERNEL_SRC="${OUT}/kernel_src"
DEFCONFIG_SRC="${REPO_ROOT}/kernel/defconfig/genesis_j6lte_defconfig"

KERNEL_REPO="https://github.com/LineageOS/android_kernel_samsung_exynos7870.git"
KERNEL_BRANCH="lineage-18.1"

CROSS_COMPILE="${CROSS_COMPILE:-aarch64-linux-gnu-}"
JOBS="${JOBS:-$(nproc)}"
ARCH="arm64"

echo "==> [kernel] Checking cross-compiler: ${CROSS_COMPILE}gcc"
if ! command -v "${CROSS_COMPILE}gcc" &>/dev/null; then
    echo "ERROR: Cross-compiler '${CROSS_COMPILE}gcc' not found."
    echo "       Install with: sudo apt install gcc-aarch64-linux-gnu"
    exit 1
fi

echo "==> [kernel] Fetching kernel source (${KERNEL_BRANCH})..."
mkdir -p "${KERNEL_SRC}"
if [ ! -d "${KERNEL_SRC}/.git" ]; then
    git clone --depth=1 --branch "${KERNEL_BRANCH}" "${KERNEL_REPO}" "${KERNEL_SRC}"
else
    git -C "${KERNEL_SRC}" fetch --depth=1 origin "${KERNEL_BRANCH}"
    git -C "${KERNEL_SRC}" checkout FETCH_HEAD
fi

echo "==> [kernel] Applying Genesis defconfig..."
cp "${DEFCONFIG_SRC}" "${KERNEL_SRC}/arch/${ARCH}/configs/genesis_j6lte_defconfig"

echo "==> [kernel] Applying out-of-tree patches..."
for patch in "${REPO_ROOT}/kernel/patches/"*.patch; do
    [ -f "${patch}" ] || continue
    echo "    Applying ${patch##*/}..."
    git -C "${KERNEL_SRC}" apply "${patch}"
done

echo "==> [kernel] Building (ARCH=${ARCH}, JOBS=${JOBS})..."
make -C "${KERNEL_SRC}" \
    ARCH="${ARCH}" \
    CROSS_COMPILE="${CROSS_COMPILE}" \
    genesis_j6lte_defconfig

make -C "${KERNEL_SRC}" \
    ARCH="${ARCH}" \
    CROSS_COMPILE="${CROSS_COMPILE}" \
    -j"${JOBS}" \
    Image.gz dtbs

echo "==> [kernel] Copying kernel image to ${OUT}/..."
mkdir -p "${OUT}"
cp "${KERNEL_SRC}/arch/${ARCH}/boot/Image.gz" "${OUT}/kernel-j6lte.gz"
cp "${KERNEL_SRC}/arch/${ARCH}/boot/dts/exynos"*j6*.dtb "${OUT}/" 2>/dev/null || true

echo "==> [kernel] Done. Output: ${OUT}/kernel-j6lte.gz"
