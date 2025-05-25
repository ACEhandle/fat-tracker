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

## Firestore Ingredient Data & Persistence

- Ingredient data is stored in the Firestore `ingredients` collection. If you see no values in the app, the collection is likely empty in your emulator.
- To avoid re-seeding data every time you restart the Firebase Emulator Suite, use the emulator's export/import feature:

### Persisting Emulator Data Between Sessions
1. **After seeding your data (e.g., after first import):**
   ```powershell
   firebase emulators:export ./emulator-data
   ```
2. **Start the emulator with persistence:**
   ```powershell
   firebase emulators:start --import=./emulator-data --export-on-exit
   ```
   - This will load your previous data and save changes on exit, so you only need to seed once.

- If you want to reset the data, delete the `./emulator-data` folder and repeat the seeding process.

---

## Troubleshooting & Known Issues (May 2025)

### 1. White Screen on iPhone or Mobile Browsers
- **Symptom:** App loads as a blank/white screen on iPhone or other mobile browsers.
- **Solution:**
  - Error logging has been added to `web/index.html`. Any JavaScript errors will now be displayed at the bottom of the screen in red text and saved to `localStorage` as `flutter_web_last_error`.
  - If you see a white screen, check for an error message at the bottom. If present, use it to debug or report the issue.

### 2. Emulator/Port Conflicts
- **Symptom:** Firebase emulators fail to start, or ports 8080/9000/5000 are in use.
- **Solution:**
  - Use Task Manager or `Get-Process -Id <PID>` and `Stop-Process -Id <PID>` in PowerShell to kill orphaned Java/Node processes.
  - See instructions above for checking port usage.

### 3. Rebuilding for LAN Hosting
- **Note:**
  - After editing `web/index.html` or any Dart code, always run `flutter build web` before restarting the Firebase emulator to ensure the latest code is served on the LAN.

### 4. Error Logging Script Location
- The error logging script is in `web/index.html` and is injected into the build output. If you update this script, rebuild the web app.

---

**Tip:**
- You can run both the dev environment and LAN hosting at the same time.
- Only the LAN version needs a rebuild and emulator restart to update.

---

For more help, see README.md or ask Copilot!
