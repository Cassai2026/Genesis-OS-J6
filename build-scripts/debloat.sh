#!/usr/bin/env bash
# build-scripts/debloat.sh
# Removes Samsung/Google bloatware, telemetry services, and trackers
# from the assembled system image at out/system/.
#
# Only packages listed in REMOVE_LIST are deleted; everything else is kept.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SYSTEM="${REPO_ROOT}/out/system"

if [ ! -d "${SYSTEM}" ]; then
    echo "ERROR: ${SYSTEM} not found — run 'make rootfs' first."
    exit 1
fi

# ---------------------------------------------------------------------------
# Packages to remove (Samsung bloat + Google telemetry + ad frameworks)
# ---------------------------------------------------------------------------
REMOVE_LIST=(
    # Samsung bixby / voice
    "Bixby"
    "BixbyVision"
    "BixbyVoice"
    "VoiceServiceClient"
    # Samsung Pay / wallet
    "SamsungPay"
    "SamsungWallet"
    # Samsung analytics / telemetry
    "SamsungAnalytics"
    "SPDClient"
    "DiagMonAgent"
    "ELMAgent"
    "HiddenNetworkPolicy"
    # Google telemetry & GMS core trackers
    "GoogleCrashHandler"
    "GooglePartnerSetup"
    "GoogleBackupTransport"
    "GoogleFeedback"
    "GoogleOneTimeInitializer"
    "PrebuiltGmsCorePi"
    # Facebook pre-installs
    "FBInstaller"
    "FBAppManager"
    "Flipboard"
    # Knox security enforcement
    "KnoxAttestationAgent"
    "KnoxSetupWizardClient"
    # Ad / tracking SDKs
    "IAPService"
    "Superuser"
)

echo "==> [debloat] Scanning ${SYSTEM} for bloatware..."

removed=0
for pkg in "${REMOVE_LIST[@]}"; do
    # Search app dirs: priv-app, app
    for dir in "${SYSTEM}/priv-app" "${SYSTEM}/app"; do
        target="${dir}/${pkg}"
        if [ -d "${target}" ]; then
            echo "    Removing ${target}"
            rm -rf "${target}"
            removed=$((removed + 1))
        fi
    done
done

# Remove residual OTA / carrier update packages
find "${SYSTEM}/app" -maxdepth 1 -name "*Carrier*" -exec rm -rf {} + 2>/dev/null || true
find "${SYSTEM}/app" -maxdepth 1 -name "*Sprint*"  -exec rm -rf {} + 2>/dev/null || true
find "${SYSTEM}/app" -maxdepth 1 -name "*Verizon*" -exec rm -rf {} + 2>/dev/null || true

# Disable Samsung device-health agent (reports usage data)
DHAGENT="${SYSTEM}/priv-app/DeviceHealthSoftware"
[ -d "${DHAGENT}" ] && { rm -rf "${DHAGENT}"; removed=$((removed + 1)); }

echo "==> [debloat] Removed ${removed} package(s)."
echo "==> [debloat] Done."
