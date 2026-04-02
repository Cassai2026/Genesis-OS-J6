# Flashing Genesis OS — Samsung Galaxy J6

## ⚠️ Warnings

- Unlocking the bootloader **wipes all data**. Back up your device first.
- This process voids the Samsung warranty.
- Only supports SM-J600F / SM-J600G / SM-J600GN.

---

## Step 1 — Back Up Personal Data

Before you begin, back up photos, contacts, and documents to a PC or cloud
storage. The bootloader unlock in Step 3 performs a factory reset.

---

## Step 2 — Enable Developer Options & OEM Unlock

1. Settings → About Phone → tap **Build Number** 7 times  
2. Settings → Developer Options → enable **OEM Unlocking**  
3. Settings → Developer Options → enable **USB Debugging**

---

## Step 3 — Unlock the Bootloader

1. Power off the device.  
2. Hold **Volume Down + Bixby + Power** to enter Download Mode.  
3. Press **Volume Up** to confirm ("Long press Volume Up to unlock").  
4. The device reboots, resets, and re-enters Android. This wipes all data.

---

## Step 4 — Install TWRP Custom Recovery

Download the latest TWRP image for j6lte:

```
https://twrp.me/samsung/samsunggalaxyj6.html
```

Flash via Odin (Windows) or Heimdall (Linux/macOS):

**Linux / macOS (Heimdall):**
```bash
sudo apt install heimdall-flash     # or: brew install heimdall

# Boot into Download Mode (Vol Down + Bixby + Power)
heimdall flash --RECOVERY twrp-j6lte.img --no-reboot
```

**Windows (Odin):**
1. Open Odin, connect the phone in Download Mode.
2. Click **AP**, select `twrp-j6lte.img`.
3. Uncheck **Auto Reboot**, click **Start**.

---

## Step 5 — Boot into TWRP

Hold **Volume Up + Bixby + Power** immediately after flashing.

---

## Step 6 — Wipe & Flash Genesis OS

Inside TWRP:

1. **Wipe** → Advanced Wipe → select **Dalvik / ART Cache, Cache, Data, System** → Swipe to wipe.
2. **Install** → navigate to `genesis-os-j6lte-<date>.zip` (copy it to SD card or use MTP) → Swipe to install.
3. **Reboot → System**.

---

## Step 7 — First Boot

First boot takes 3–5 minutes. The **Genesis Mobile Sovereign HUD** launches
automatically as the home screen and initiates a mesh handshake.

---

## ADB Sideload (alternative to SD card)

```bash
# In TWRP: Advanced → ADB Sideload → Swipe to Start Sideload
adb sideload out/genesis-os-j6lte-<date>.zip
```
