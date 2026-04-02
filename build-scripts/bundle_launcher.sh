#!/usr/bin/env bash
# build-scripts/bundle_launcher.sh
# Copies the Genesis-Mobile PWA launcher into the system image.
#
# The launcher lives in launcher/index.html and is installed as a privileged
# system WebView app under system/app/GenesisMobile/ so it loads on first boot.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${REPO_ROOT}/out"
SYSTEM_APP_DIR="${OUT}/system/app/GenesisMobile"
LAUNCHER_SRC="${REPO_ROOT}/launcher"

echo "==> Bundling Genesis-Mobile launcher into system image..."

# Create the destination directory inside the assembled system image
mkdir -p "${SYSTEM_APP_DIR}"

# Copy the self-contained PWA
cp -r "${LAUNCHER_SRC}/." "${SYSTEM_APP_DIR}/"

# Write a minimal Android app manifest so the system recognises the WebView wrapper
cat > "${SYSTEM_APP_DIR}/AndroidManifest.xml" <<'MANIFEST'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="global.cassai.genesis.mobile"
    android:versionCode="1"
    android:versionName="1.0">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />

    <application
        android:label="Genesis Mobile"
        android:icon="@mipmap/ic_launcher"
        android:theme="@android:style/Theme.NoTitleBar.Fullscreen">

        <activity
            android:name=".MainActivity"
            android:exported="true">
            <intent-filter>
                <!-- Mark as the HOME launcher so it appears on first boot -->
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.HOME" />
                <category android:name="android.intent.category.DEFAULT" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
MANIFEST

echo "==> Genesis-Mobile launcher bundled to ${SYSTEM_APP_DIR}"
