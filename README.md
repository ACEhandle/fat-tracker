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

## Next Steps
- Start with ingredients. Once working, expand to other data types (meals, workouts, inventory).

---
See `DEV_AND_LAN_HOSTING.md` for LAN hosting and deployment instructions.
