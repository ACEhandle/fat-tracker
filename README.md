# Fat Tracker

## Quickstart: Dev Environment Setup

1. Install dependencies:
   ```pwsh
   flutter pub get
   cd functions; npm install; cd ..
   ```
2. Build Flutter web app:
   ```pwsh
   flutter build web
   ```
3. Start Firebase Emulator Suite:
   ```pwsh
   firebase emulators:start
   ```
   - App: http://localhost:5000
   - Emulator UI: http://localhost:4000
4. Run Flutter app for web (hot reload):
   ```pwsh
   flutter run -d chrome
   ```

## CSV Ingestion: Ingredients

- Use `functions/ingredients.csv` as your template.
- Required columns: `Description`, `Category`, `Nutrient Data Bank Number`, `Calories` (or `kcal`).
- Place your CSV at `functions/ingredients.csv`.
- Ingest with:
  ```pwsh
  node functions/ingest_ingredients.js
  ```
- Data should appear in the app and Firestore Emulator UI.

## Troubleshooting & Hiccups

- **Emulator data not visible:**
  - Ensure projectId is `local-fattracker` in both the ingestion script and emulator config.
  - Restart emulators after config changes.
- **Ingredients not showing in app:**
  - Confirm `Calories` column exists and is populated.
  - Check for typos in CSV headers.
  - Verify app and script use the same emulator/project.
- **Ingestion script errors:**
  - Check for missing required columns or malformed CSV.

## Firebase Emulator & Flutter Integration: Lessons Learned

Connecting a Flutter application to the Firebase Emulator Suite for local development and data ingestion involves several key configuration points. Here's a summary of what was crucial for successful integration:

1.  **Emulator Setup (`firebase.json`):**
    *   Ensure your `firebase.json` correctly configures the Firestore emulator, especially the port (default `8080`).
    *   **Crucially, specify a `firestore.rules` file** within the `emulators.firestore` configuration. This allows you to define permissive rules for local development, bypassing restrictive default rules that might block access.
        ```json
        {
          "firestore": {
            "rules": "firestore.rules" // Essential for emulator access
          },
          "emulators": {
            "auth": { "port": 9099 },
            "firestore": { "port": 8080 }, // Default Firestore port
            "ui": { "enabled": true, "port": 4000 }, // Emulator UI
            "hosting": { "port": 5000 }
          }
        }
        ```

2.  **Firestore Rules (`firestore.rules`):**
    *   For local development, create a `firestore.rules` file with permissive rules to avoid access issues. A common setup is:
        ```
        rules_version = '2';
        service cloud.firestore {
          match /databases/{database}/documents {
            // Allow read/write access to all documents for development
            match /{document=**} {
              allow read, write: if true;
            }
          }
        }
        ```
    *   **Remember to restart the emulators** after creating or modifying `firebase.json` or `firestore.rules` for the changes to take effect. Restarting the emulator will clear existing data unless persistence is configured.

3.  **Flutter App Configuration (`lib/main.dart`):**
    *   Initialize Firebase: `WidgetsFlutterBinding.ensureInitialized(); await Firebase.initializeApp(...);`
    *   **Point Firestore to the Emulator:** After Firebase initialization, explicitly tell Firestore to use the emulator:
        ```dart
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        ```
    *   **Project ID Consistency (for Web):** When using Firebase for web (`kIsWeb`), ensure the `projectId` in `FirebaseOptions` matches the `projectId` used by your emulator and ingestion scripts (e.g., `"local-fattracker"`). While dummy API keys can be used for emulator-only development, a consistent `projectId` helps avoid potential mismatches.
        ```dart
        if (kIsWeb) {
          await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: 'dummy-api-key',
              authDomain: 'dummy-auth-domain',
              projectId: 'local-fattracker', // Match emulator/script projectId
              // ... other options
            ),
          );
        } else {
          await Firebase.initializeApp(); // For mobile
        }
        ```

4.  **Node.js Ingestion Script (`functions/*.js`):**
    *   **Emulator Host Environment Variable:** Set `process.env.FIRESTORE_EMULATOR_HOST = "localhost:8080";` *before* initializing the Firebase Admin SDK.
    *   **Admin SDK Initialization:** Initialize `firebase-admin` with a specific `projectId` that matches your emulator setup (e.g., `"local-fattracker"`).
        ```javascript
        admin.initializeApp({
          projectId: "local-fattracker" // Consistent Project ID
        });
        const db = admin.firestore();
        // Optional: Explicitly set settings if FIRESTORE_EMULATOR_HOST isn't picked up
        // db.settings({ host: "localhost:8080", ssl: false });
        ```
    *   **Data Ingestion Logic:** Ensure your script correctly targets the desired collection (e.g., `ingredients`) and that the data structure being ingested matches what the Flutter app expects (field names, data types).

5.  **Troubleshooting Workflow:**
    *   **Verify Data in Emulator UI:** Always check the Firestore Emulator UI (default `http://localhost:4000`) to confirm that data is actually being written to the correct collections and documents by your ingestion script.
    *   **Check Security Rules:** If data is in the emulator but not appearing in the app, security rules are a primary suspect. The Emulator UI also has a "Rules" tab to test them.
    *   **Console Logs are Key:** Add detailed logging in both your Flutter app (especially in service layers and model parsing) and your ingestion script to trace the data flow and identify where issues occur (e.g., connection, data parsing, empty snapshots).
    *   **Restart Everything:** When in doubt, stop the Flutter app, stop the emulators, restart the emulators, re-run the ingestion script, and then re-run the Flutter app. This ensures all components are using the latest configurations and data.

By following these points, you can establish a reliable local development environment for Flutter with Firebase, allowing for efficient data ingestion and testing.

## Next Steps
- Start with ingredients. Once working, expand to other data types (meals, workouts, inventory).

---
See `DEV_AND_LAN_HOSTING.md` for LAN hosting and deployment instructions.
