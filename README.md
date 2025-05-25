# Fat Tracker

## Project Overview
Fat Tracker is a cross-platform nutrition, workout, and inventory management app with Firebase sync and Google Calendar integration. This project is scaffolded with Flutter for the frontend and uses Firebase for authentication, Firestore, and local emulation during development.

## Progress & Scaffolding
- **Flutter app**: Main page with light/dark mode toggle and placeholder for authentication dialog.
- **Firebase Emulator Suite**: Configured for Auth, Firestore, Functions, Database, and Hosting.
- **Hosting**: Serves the Flutter web build from `build/web` using Firebase Hosting emulator.
- **Project structure**: Features, models, services, and widgets directories scaffolded for modular development.
- **Linting**: Uses `flutter_lints` for code quality.

## How to Run the Dev Environment (from Cold Boot)
1. **Install dependencies**
   ```sh
   flutter pub get
   cd functions && npm install && cd ..
   ```
2. **Build the Flutter web app**
   ```sh
   flutter build web
   ```
3. **Start the Firebase Emulator Suite**
   ```sh
   firebase emulators:start
   ```
   - The app will be served at [http://localhost:5000](http://localhost:5000) (or the port specified in `firebase.json`).
   - Emulator UI: [http://localhost:4000](http://localhost:4000)
4. **Run the Flutter app for web (hot reload/dev)**
   ```sh
   flutter run -d chrome
   ```
   - For development, you can use hot reload in Chrome or Edge.

## Potential Next Steps
- ~~Implement authentication UI and connect to Firebase Auth.~~ (Completed: Auth emulator and sign-in flow are integrated for local development.)
- Build out CRUD interfaces for food, meals, inventory, and workouts.
- Integrate Firestore for persistent data storage.
- Add Google Calendar API integration for workout/meal scheduling.
- Write unit and widget tests for core features.
- Set up CI/CD for automated builds and deploys (optional).
- Polish UI/UX and add responsive design for mobile/web.

---
For any issues or questions, see the code comments or open an issue.
