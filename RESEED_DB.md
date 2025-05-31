# Re-seeding the Database

When restarting the Firebase emulator, you may need to re-seed the database with ingredients and workouts/exercises. Follow these steps:

## Steps to Re-seed the Database

1. **Start the Firebase Emulator**:
   ```bash
   firebase emulators:start
   ```

2. **Run the Ingestion Scripts**:
   Navigate to the `functions` directory and run the following commands:
   ```bash
   node ingest_ingredients.js
   node ingest_wger_exercises.js
   ```

3. **Verify Data in Firestore**:
   - Open the Firebase Emulator UI.
   - Check the `ingredients` and `workouts` collections to ensure data is present.

## Notes
- Ensure the Firestore emulator is running before executing the ingestion scripts.
- If you encounter any issues, check the logs for errors and resolve them accordingly.
