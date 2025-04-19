// INGESTION SCRIPT: Run with `node functions/ingest_ingredients.js`
// This script reads a CSV of ingredients and uploads them to Firestore (emulator or production)
// Place your CSV as 'functions/ingredients.csv'

const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');
const csv = require('csv-parse/sync');

// Initialize Firebase Admin SDK (connects to emulator if running locally)
admin.initializeApp();
const db = admin.firestore();
if (process.env.FIRESTORE_EMULATOR_HOST) {
  db.settings({ host: process.env.FIRESTORE_EMULATOR_HOST, ssl: false });
}

const csvPath = path.join(__dirname, 'ingredients.csv');
const collectionName = 'ingredients';

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
    // Use Nutrient Data Bank Number or Description as ID if available
    const docId = row['Nutrient Data Bank Number'] || row['Description'] || undefined;
    // Remove empty fields and keep all data
    const cleanRow = Object.fromEntries(Object.entries(row).filter(([k, v]) => v !== undefined && v !== ''));
    try {
      if (docId) {
        await db.collection(collectionName).doc(docId).set(cleanRow, { merge: true });
      } else {
        await db.collection(collectionName).add(cleanRow);
      }
      console.log(`Ingested: ${docId || cleanRow['Description']}`);
    } catch (e) {
      console.error(`Failed to ingest: ${docId || cleanRow['Description']}`, e);
    }
  }
  console.log('Ingestion complete!');
}

ingest();