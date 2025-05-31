const fs = require('fs');
const path = require('path');

// Path to the JSON file
const filePath = path.join(__dirname, 'FoodData_Central_foundation_food_json_2025-04-24.json');

// Additional debug logs to verify the file path and file existence
console.log('Debug: File path is', filePath);

fs.access(filePath, fs.constants.F_OK, (err) => {
    if (err) {
        console.error('Debug: File does not exist or cannot be accessed:', err);
        return;
    }
    console.log('Debug: File exists. Proceeding to read the file.');

    // Read and log the contents of the JSON file
    fs.readFile(filePath, 'utf8', (err, data) => {
        if (err) {
            console.error('Error reading the file:', err);
            return;
        }

        try {
            const jsonData = JSON.parse(data);
            console.log('JSON Data:', jsonData);
        } catch (parseErr) {
            console.error('Error parsing JSON:', parseErr);
        }
    });
});
