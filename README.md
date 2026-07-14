# WiFi Guardian

A cross-platform desktop application that scans nearby Wi-Fi networks, scores
their safety, and warns you about common wireless threats before you connect.

Built with **Python + PyQt6**.

## Features

- **Scan & list networks** — SSID, signal strength, security type, BSSID, and
  the network you are currently connected to. Auto-refreshes (default every 10s).
- **Safety scoring (0–10)** combining:
  - Security type (WPA3=10, WPA2=8, WPA=5, WEP=2, Open=0)
  - Signal strength (+1 strong / −1 weak)
  - Duplicate-SSID / Evil-Twin penalty (−3)
  - Weak cipher flag (TKIP / no encryption, −2)
- **Visual indicators** — 🟢 green (8–10), 🟡 yellow (4–7), 🔴 red (0–3) plus a
  per-network safety badge and a detailed score breakdown.
- **Real-time protection**
  - Auto-warn when connected to an unsafe (red) network.
  - Evil-Twin / spoof detection (your SSID appears from a new MAC).
  - Deauth / sudden-disconnect detection.
- **Manual diagnostics** — ping, DNS-hijack check (vs 8.8.8.8), gateway port
  scan, SSL/TLS checks, captive-portal detection, LAN device estimate (ARP).
- **Network details** — protocol/cipher, channel & band, vendor (OUI lookup),
  historical sightings.
- **Logging & history** — SQLite store of every sighting with timestamps,
  trusted/untrusted marking, CSV/JSON export.
- **Settings** — auto-scan toggle, scan interval, dark/light theme, risk
  thresholds, and per-feature protection toggles.

## Install (from source)

```bash
pip install -r requirements.txt
```

## Run (from source)

```bash
python main.py
```

## Build a standalone executable

A packaged Windows executable is produced with PyInstaller (no Python install
needed to run it):

```bash
pip install pyinstaller
build.bat
```

The result is `dist/WiFiGuardian/WiFiGuardian.exe` — a self-contained app you
can copy to any Windows machine. Settings, history DB, and any `oui.txt` live
in `%APPDATA%\WiFiGuardian`.

## Platform notes

- **Windows**: uses `netsh wlan`. Run from a normal or admin prompt; scanning
  works without admin, full BSSID details are best with an admin shell.
- **Linux**: uses `nmcli` (NetworkManager) — install it on Debian/Ubuntu with
  `sudo apt install network-manager`.
- **macOS**: uses the `airport` utility (some fields may be limited).

## Limitations / honesty

- True OS-level *"block the connect"* and *"intercept a connect attempt"* hooks
  are not available from user-space Python. WiFi Guardian instead **detects
  what you are connected to after the fact** and warns immediately if it is
  unsafe or if a spoof/deauth event is observed. The "auto-block unsafe
  networks" setting logs the intent; enforcement depends on OS support.
- Vendor lookup ships with a small built-in OUI table. Drop a full IEEE
  `oui.txt` into the app data directory (see Settings / logs path) for
  comprehensive vendor names.
- DNS hijack detection compares your system resolver to a raw query against
  8.8.8.8; it is a heuristic, not a guarantee.

## Project layout

```
wifi-guardian/
  main.py              entry point
  requirements.txt
  src/
    config.py          constants + data models
    scanner.py         cross-platform Wi-Fi scanning
    safety.py          risk scoring engine
    vendor.py          OUI / vendor lookup
    tests.py           ping / dns / port / ssl / captive / arp
    logger.py          history + CSV/JSON export
    settings.py        persistent settings
    protection.py      real-time threat monitor
  ui/
    main_window.py     main window
    worker.py          background scan thread
    details_panel.py   selected-network details
    settings_dialog.py
    tools_dialog.py    diagnostics
    log_view.py        history viewer
```
