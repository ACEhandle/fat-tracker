// INGESTION SCRIPT: Run with `node functions/ingest_ingredients.js`
// This script reads a CSV of ingredients and uploads them to Firestore (emulator or production)
// Place your CSV as 'functions/ingredients.csv'

// Force Firestore Admin SDK to use the emulator
process.env.FIRESTORE_EMULATOR_HOST = process.env.FIRESTORE_EMULATOR_HOST || "localhost:8080";

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parse/sync');

// Initialize Firebase Admin SDK
admin.initializeApp({
  projectId: "local-fattracker"
});
const db = admin.firestore();
db.settings({ host: process.env.FIRESTORE_EMULATOR_HOST, ssl: false });

const csvPath = path.join(__dirname, 'ingredients.csv');
const collectionName = 'ingredients';

function parseCsv() {
  const fileContent = fs.readFileSync(csvPath, 'utf8');
  return csv.parse(fileContent, {
    columns: true,
    skip_empty_lines: true,
  });
}

async function clearIngredients() {
  const snapshot = await db.collection(collectionName).get();
  const batch = db.batch();
  snapshot.docs.forEach(doc => batch.delete(doc.ref));
  await batch.commit();
  console.log('Cleared all documents from ingredients collection.');
}

async function ingest() {
  const rows = parseCsv();
  for (const row of rows) {
    // Use a unique ID, e.g., Nutrient Data Bank Number or Description
    const docId = row['Nutrient Data Bank Number'] || row['Description'] || undefined;
    // Remove empty fields
    const cleanRow = Object.fromEntries(Object.entries(row).filter(([k, v]) => v !== undefined && v !== ''));
    // Add reference amount if not present
    if (!cleanRow.ReferenceAmount) {
      cleanRow.ReferenceAmount = "100g";
    }
    console.log('Parsed row:', cleanRow); // Debug: show each row being ingested
    try {
      if (docId !== undefined) {
        await db.collection(collectionName).doc(docId).set(cleanRow, { merge: true });
        console.log(`Ingested: ${docId}`);
      } else {
        const ref = await db.collection(collectionName).add(cleanRow);
        console.log(`Ingested (auto-id): ${ref.id}`);
      }
    } catch (e) {
      console.error(`Failed to ingest: ${docId || cleanRow['Description']}`, e);
    }
  }
  console.log('Ingredient ingestion complete!');
}

// Clear the collection, then ingest
(async () => {
  await clearIngredients();
  await ingest();
})();