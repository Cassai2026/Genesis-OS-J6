#!/usr/bin/env bash
# build-scripts/build_rootfs.sh
# Fetches LineageOS 18.1 sources for j6lte and assembles a minimal rootfs,
# then bundles the Genesis-Mobile PWA launcher as a system app.
#
# Full AOSP/LineageOS source trees are large (~200 GB).  This script sets up
# the repo manifest and syncs only the packages required for a j6lte build.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${REPO_ROOT}/out"
LOS_SRC="${OUT}/lineage_src"
JOBS="${JOBS:-$(nproc)}"

MANIFEST_URL="https://github.com/LineageOS/android.git"
MANIFEST_BRANCH="lineage-18.1"

# ---- prerequisites --------------------------------------------------------
for cmd in repo java python3 curl zip; do
    if ! command -v "${cmd}" &>/dev/null; then
        echo "ERROR: '${cmd}' is required but not installed."
        exit 1
    fi
done

# ---- initialise repo manifest ----------------------------------------------
echo "==> [rootfs] Initialising LineageOS ${MANIFEST_BRANCH} manifest..."
mkdir -p "${LOS_SRC}"
cd "${LOS_SRC}"

if [ ! -f ".repo/manifest.xml" ]; then
    repo init \
        -u "${MANIFEST_URL}" \
        -b "${MANIFEST_BRANCH}" \
        --depth=1 \
        --no-clone-bundle
fi

echo "==> [rootfs] Syncing sources (this takes a while)..."
repo sync -c -j"${JOBS}" --force-sync --no-clone-bundle --no-tags

# ---- device-specific sources -----------------------------------------------
echo "==> [rootfs] Fetching j6lte device tree and vendor blobs..."
# Use LineageOS' breakfast script to pull device + vendor trees
source build/envsetup.sh
breakfast j6lte 2>&1 | tail -20

# ---- custom kernel image ---------------------------------------------------
KERNEL_IMG="${OUT}/kernel-j6lte.gz"
if [ -f "${KERNEL_IMG}" ]; then
    echo "==> [rootfs] Injecting Genesis kernel image..."
    TARGET_KERNEL_DIR="${LOS_SRC}/device/samsung/j6lte/prebuilt"
    mkdir -p "${TARGET_KERNEL_DIR}"
    cp "${KERNEL_IMG}" "${TARGET_KERNEL_DIR}/kernel"
fi

# ---- build -----------------------------------------------------------------
echo "==> [rootfs] Building LineageOS for j6lte..."
croot
brunch j6lte 2>&1 | tee "${OUT}/build_rootfs.log"

# Copy output system image for later steps
SYSTEM_IMG="$(find "${LOS_SRC}/out/target/product/j6lte" -name "system.img" 2>/dev/null | head -1)"
if [ -n "${SYSTEM_IMG}" ]; then
    cp "${SYSTEM_IMG}" "${OUT}/system.img"
    echo "==> [rootfs] system.img → ${OUT}/system.img"
fi

# Explode system.img into a directory for further patching
mkdir -p "${OUT}/system"
if command -v simg2img &>/dev/null; then
    simg2img "${OUT}/system.img" "${OUT}/system_raw.img"
    sudo mount -o loop "${OUT}/system_raw.img" "${OUT}/system" 2>/dev/null || \
        echo "WARN: Could not mount system image — copy files manually."
fi

echo "==> [rootfs] Done."
