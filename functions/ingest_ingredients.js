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
const usdaJsonPath = path.join(__dirname, 'FoodData_Central_foundation_food_json_2025-04-24.json');
const collectionName = 'ingredients';
const usdaCollectionName = 'usda_foods';

function parseCsv() {
  const fileContent = fs.readFileSync(csvPath, 'utf8');
  return csv.parse(fileContent, {
    columns: true,
    skip_empty_lines: true,
  });
}

function parseUsdaJson() {
  console.log(`DEBUG: Attempting to read JSON file from: ${usdaJsonPath}`);
  if (!fs.existsSync(usdaJsonPath)) {
    console.error('ERROR: USDA JSON file not found. Please ensure the file exists in the functions directory.');
    return null;
  }
  try {
    const fileContent = fs.readFileSync(usdaJsonPath, 'utf8');
    const data = JSON.parse(fileContent);
    if (!data.FoundationFoods || !Array.isArray(data.FoundationFoods)) {
      console.error('ERROR: USDA JSON file does not contain a `FoundationFoods` array at the root.');
      return null;
    }
    console.log(`DEBUG: Successfully parsed JSON file with ${data.FoundationFoods.length} entries.`);
    return data.FoundationFoods;
  } catch (e) {
    console.error('ERROR: Failed to parse USDA JSON file. Ensure it contains valid JSON.', e);
    return null;
  }
}

function extractNutrients(nutrientArray) {
  // Map nutrient numbers to keys (e.g., calories, protein, etc.)
  const nutrientMap = {};
  for (const n of nutrientArray) {
    if (n.nutrient && n.amount !== undefined) {
      // Use nutrient name as key, lowercased and spaces replaced
      const key = n.nutrient.name.toLowerCase().replace(/\s+/g, '_');
      nutrientMap[key] = n.amount;
    }
  }
  return nutrientMap;
}

function extractPortions(portionArray) {
  if (!Array.isArray(portionArray)) return [];
  return portionArray.filter(p => p.modifier && p.gramWeight).map(p => ({
    measure: p.modifier,
    grams: p.gramWeight
  }));
}

async function clearIngredients() {
  const snapshot = await db.collection(collectionName).get();
  const batch = db.batch();
  snapshot.docs.forEach(doc => batch.delete(doc.ref));
  await batch.commit();
  console.log(`Cleared all documents from ${collectionName} collection.`); // Clarified log
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

async function ingestUsdaJson() {
  const data = parseUsdaJson();
  if (!data) return false;
  for (const food of data) {
    const docId = food.fdcId ? String(food.fdcId) : undefined;
    const cleanRow = {
      fdcId: food.fdcId,
      description: food.description,
      category: food.foodCategory?.description || '',
      nutrients: extractNutrients(food.foodNutrients || []),
      portions: extractPortions(food.foodPortions || [])
    };
    if (!cleanRow.nutrients.calories && cleanRow.nutrients.energy) {
      cleanRow.nutrients.calories = cleanRow.nutrients.energy;
    }
    try {
      if (docId) {
        await db.collection(collectionName).doc(docId).set(cleanRow, { merge: true });
        console.log(`Ingested: ${docId}`);
      } else {
        const ref = await db.collection(collectionName).add(cleanRow);
        console.log(`Ingested (auto-id): ${ref.id}`);
      }
    } catch (e) {
      console.error(`Failed to ingest: ${docId || cleanRow.description}`, e);
    }
  }
  console.log('USDA JSON ingredient ingestion complete!');
  return true;
}

async function ingestUsdaData() {
  const usdaData = parseUsdaJson();
  if (!usdaData) {
    console.error('ERROR: No USDA data to ingest.');
    return;
  }

  console.log(`DEBUG: Ingesting ${usdaData.length} USDA food items into Firestore.`);

  for (const foodItem of usdaData) {
    try {
      const docRef = db.collection(usdaCollectionName).doc(String(foodItem.fdcId));
      await docRef.set(foodItem);
      console.log(`DEBUG: Successfully ingested food item with FDC ID: ${foodItem.fdcId}`);
    } catch (e) {
      console.error(`ERROR: Failed to ingest food item with FDC ID: ${foodItem.fdcId}`, e);
    }
  }

  console.log('DEBUG: USDA data ingestion complete.');
}

// Clear the collection, then ingest
(async () => {
  await clearIngredients(); // Clears 'ingredients'
  const jsonIngested = await ingestUsdaJson(); // Ingests into 'ingredients'
  if (!jsonIngested) {
    console.error('USDA JSON file not found or failed to parse. Please place FoodData_Central_foundation_food_json_2025-04-24.json in the functions directory.');
    process.exit(1);
  }
  // await ingestUsdaData(); // Temporarily commented out
  console.log('Ingestion process focused on ingredients collection complete.');
})();