# Dev & LAN Hosting

## LAN Hosting Setup

- LAN hosting is configured in `firebase.json`.
- Start emulators with:
  ```pwsh
  firebase emulators:start
  ```
- App and Emulator UI will be available on your LAN at the ports specified in `firebase.json`.

## Hiccups & Solutions

- **LAN not accessible:**
  - Ensure your firewall allows the specified ports.
  - Use the correct LAN IP address.
- **Emulator not serving app:**
  - Confirm `firebase.json` has correct `hosting` and `emulators` config.
  - Rebuild Flutter web app if changes are not reflected.

---
For dev environment and CSV ingestion, see `README.md`.
