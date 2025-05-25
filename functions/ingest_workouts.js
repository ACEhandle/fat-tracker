// Ingest workouts from a CSV file into Firestore (emulator or production)
// Usage: node functions/ingest_workouts.js

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parse/sync');

// Initialize Firebase Admin SDK
admin.initializeApp();
const db = admin.firestore();
if (process.env.FIRESTORE_EMULATOR_HOST) {
  db.settings({ host: process.env.FIRESTORE_EMULATOR_HOST, ssl: false });
}

const csvPath = path.join(__dirname, 'workouts.csv'); // Place your exported workouts CSV here
const collectionName = 'workouts';

function parseCsv() {
  const fileContent = fs.readFileSync(csvPath, 'utf8');
  return csv.parse(fileContent, {
    columns: true,
    skip_empty_lines: true,
  });
}

async function ingest() {
  const rows = parseCsv();
  for (const row of rows) {
    // Use a unique ID, e.g., exercise name or a provided ID
    const docId = row['ID'] || row['Exercise'] || undefined;
    // Remove empty fields
    const cleanRow = Object.fromEntries(Object.entries(row).filter(([k, v]) => v !== undefined && v !== ''));
    try {
      if (docId) {
        await db.collection(collectionName).doc(docId).set(cleanRow, { merge: true });
      } else {
        await db.collection(collectionName).add(cleanRow);
      }
      console.log(`Ingested: ${docId || cleanRow['Exercise']}`);
    } catch (e) {
      console.error(`Failed to ingest: ${docId || cleanRow['Exercise']}`, e);
    }
  }
  console.log('Workout ingestion complete!');
}

ingest();
