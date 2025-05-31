console.log(`Initial FIRESTORE_EMULATOR_HOST: ${process.env.FIRESTORE_EMULATOR_HOST}`);
const admin = require('firebase-admin');
const fs = require('fs');
const path = require('path');

// COLLECTION_NAME
const COLLECTION_NAME = 'exercises';

// Initialize Firebase Admin SDK
try {
    admin.initializeApp({
        projectId: 'local-fattracker',
    });
    console.log("Firebase Admin SDK initialized for local development.");
} catch (error) {
    if (error.code === 'app/duplicate-app') {
        console.log("Firebase Admin SDK already initialized.");
        admin.app();
    } else {
        console.error("Firebase Admin SDK initialization error:", error);
        process.exit(1);
    }
}

const db = admin.firestore();

// Check if running with Firebase Emulator
if (process.env.FIRESTORE_EMULATOR_HOST) {
    console.log(`Connecting to Firestore emulator at ${process.env.FIRESTORE_EMULATOR_HOST}`);
    db.settings({
        host: process.env.FIRESTORE_EMULATOR_HOST,
        ssl: false
    });
} else {
    console.log("FIRESTORE_EMULATOR_HOST not set. Connecting to production Firestore or default.");
}

// Try a simple test write before doing anything else
async function testWrite() {
    try {
        console.log("Testing Firestore connection with a simple write...");
        const testDocRef = db.collection('test').doc('test-doc');
        await testDocRef.set({ test: true, timestamp: admin.firestore.FieldValue.serverTimestamp() });
        console.log("Test write successful! Connection to Firestore is working.");
        
        // Verify by reading it back
        const testDoc = await testDocRef.get();
        if (testDoc.exists) {
            console.log("Test read successful! Document exists:", testDoc.data());
        } else {
            console.log("Test read failed: Document does not exist.");
        }
    } catch (error) {
        console.error("Test write/read failed with error:", error);
    }
}

async function ingestWgerExercisesSimple() {
    await testWrite();  // First test the connection
    
    console.log("Starting simplified exercise ingestion...");
    
    const filePath = path.join(__dirname, 'wger_exercises_api_data.json');
    let exerciseData;

    try {
        const fileContent = fs.readFileSync(filePath, 'utf8');
        exerciseData = JSON.parse(fileContent);
        console.log(`Read data from ${filePath}`);
        
        // If exerciseData is an array, use it directly
        // If it's an object with results, use results
        if (Array.isArray(exerciseData)) {
            console.log(`Data is an array with ${exerciseData.length} items`);
        } else if (exerciseData.results && Array.isArray(exerciseData.results)) {
            console.log(`Data has a results array with ${exerciseData.results.length} items`);
            exerciseData = exerciseData.results;
        } else {
            console.error("Unexpected data structure:", typeof exerciseData);
            console.log("Keys in data:", Object.keys(exerciseData));
            return;
        }
    } catch (error) {
        console.error(`Error reading or parsing ${filePath}:`, error);
        return;
    }

    // Just try to write the first 5 exercises directly, one by one
    let successCount = 0;
    
    for (let i = 0; i < Math.min(5, exerciseData.length); i++) {
        const exercise = exerciseData[i];
        
        if (!exercise.id) {
            console.log(`Exercise at index ${i} doesn't have an ID, skipping`);
            continue;
        }
        
        console.log(`Processing exercise ${i+1}/${Math.min(5, exerciseData.length)}: ID ${exercise.id}, Name: ${exercise.name || 'unnamed'}`);
        
        const processedExercise = {
            wger_id: exercise.id,
            name: exercise.name || 'Unnamed Exercise',
            description: exercise.description || '',
            category: exercise.category?.name || 'Uncategorized',
            test_field: `test-${Date.now()}`, // To ensure we have a unique field value
        };
        
        try {
            const docRef = db.collection(COLLECTION_NAME).doc(`test-${exercise.id}`);
            console.log(`Attempting to write exercise ${exercise.id} to Firestore...`);
            await docRef.set(processedExercise);
            console.log(`Successfully wrote exercise ${exercise.id} to Firestore`);
            successCount++;
        } catch (error) {
            console.error(`Failed to write exercise ${exercise.id} to Firestore:`, error);
        }
    }
    
    console.log(`Simple ingestion complete. Successfully wrote ${successCount} out of 5 exercises.`);
}

// Run the ingestion
ingestWgerExercisesSimple().catch(error => {
    console.error("Unhandled error during ingestion:", error);
    process.exit(1);
}).then(() => {
    console.log("Script completed.");
    // Don't exit immediately to allow async operations to complete
    setTimeout(() => process.exit(0), 1000);
});
