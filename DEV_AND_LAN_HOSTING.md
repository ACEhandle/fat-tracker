# Fat Tracker: Local Dev & LAN Hosting Instructions

## 1. Start the Flutter Dev Environment (with Hot Reload)

1. Open a terminal in the project root (`d:/quarry/code/projects/fat-tracker`).
2. Run:
   ```powershell
   flutter run -d chrome
   ```
   - This opens the app in Chrome with hot reload enabled (for local development only).
   - The app will be available at a random localhost port (e.g., http://localhost:61376).

---

## 2. Build the Flutter Web App for Hosting

1. In the project root, run:
   ```powershell
   flutter build web
   ```
   - This generates the latest static web build in `build/web`.

---

## 3. Start the Firebase Emulators for LAN Hosting

1. Make sure your `firebase.json` has:
   ```json
   "public": "build/web"
   ...
   "emulators": {
     ...
     "hosting": {
       "port": 5000,
       "host": "0.0.0.0"
     },
     ...
   }
   ```
2. In a separate terminal (outside VS Code is fine), run:
   ```powershell
   firebase emulators:start
   ```
   - This serves your app at http://localhost:5000 and http://<your-lan-ip>:5000 for any device on your LAN.

---

## 4. Update the LAN Version After Changes

1. After making changes and testing with hot reload, run:
   ```powershell
   flutter build web
   ```
2. Restart the Firebase emulators if you want the LAN version to update immediately:
   - Stop the emulators (Ctrl+C in the terminal running them)
   - Start again:
     ```powershell
     firebase emulators:start
     ```

---

## 5. Accessing the App

- **Local dev (hot reload):** Open the URL shown by `flutter run -d chrome` (e.g., http://localhost:61376)
- **LAN devices:** Open `http://<your-lan-ip>:5000` in a browser on any device on your network
  - Find your LAN IP with `ipconfig` (look for IPv4 Address)

---

**Tip:**
- You can run both the dev environment and LAN hosting at the same time.
- Only the LAN version needs a rebuild and emulator restart to update.

---

For more help, see README.md or ask Copilot!
