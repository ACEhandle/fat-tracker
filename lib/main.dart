import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/food/ingredient_viewer.dart';
import 'features/meals/meal_builder.dart';
import 'features/home/home_dashboard.dart';
import 'models/ingredient.dart';
import 'services/ingredient_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'dummy-api-key', // Keep as is or use a valid one if you have it
        authDomain: 'dummy-auth-domain', // Keep as is or use a valid one
        projectId: 'local-fattracker', // CHANGED
        storageBucket: 'dummy-storage-bucket', // Keep as is
        messagingSenderId: 'dummy-messaging-sender-id', // Keep as is
        appId: 'dummy-app-id', // Keep as is
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  // Always connect to Firestore emulator in dev
  print('Connecting to Firestore emulator at localhost:8080'); // Add log
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
  print('Firestore emulator connected.'); // Add log

  runApp(const FatTrackerApp());
}

class FatTrackerApp extends StatefulWidget {
  const FatTrackerApp({super.key});

  @override
  State<FatTrackerApp> createState() => _FatTrackerAppState();
}

class _FatTrackerAppState extends State<FatTrackerApp> {
  ThemeMode _themeMode = ThemeMode.system;
  User? _user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fat Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      themeMode: _themeMode,
      home: HomePage(
        themeMode: _themeMode,
        onThemeChanged: _toggleTheme,
        user: _user,
        onSignOut: _signOut,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeChanged;
  final User? user;
  final VoidCallback onSignOut;

  const HomePage({super.key, required this.themeMode, required this.onThemeChanged, required this.user, required this.onSignOut});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<String> _pageTitles = [
    'Home', 'Meals', 'Ingredients', 'Calendar', 'Workouts', 'Profile'
  ];

  @override
  Widget build(BuildContext context) {
    final ingredientService = IngredientService();
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: widget.themeMode == ThemeMode.dark,
                onChanged: widget.onThemeChanged,
              ),
              const Icon(Icons.dark_mode),
              widget.user == null
                  ? IconButton(
                      icon: const Icon(Icons.login),
                      tooltip: 'Sign In',
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AuthDialog(),
                        );
                      },
                    )
                  : Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(widget.user?.displayName ?? widget.user?.email ?? 'User'),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          tooltip: 'Sign Out',
                          onPressed: widget.onSignOut,
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeDashboard(),
          FutureBuilder<List<Ingredient>>(
            future: ingredientService.fetchIngredients(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final ingredients = snapshot.data ?? [];
              return MealBuilder(availableIngredients: ingredients);
            },
          ),
          const IngredientViewer(),
          const Center(child: Text('Calendar (coming soon)')),
          const Center(child: Text('Workouts (coming soon)')),
          const Center(child: Text('Profile (coming soon)')),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (idx) => setState(() => _selectedIndex = idx),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Meals'),
          BottomNavigationBarItem(icon: Icon(Icons.kitchen), label: 'Ingredients'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workouts'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleAuthProvider googleProvider = GoogleAuthProvider();
      await FirebaseAuth.instance.signInWithPopup(googleProvider);
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign In'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.account_circle),
            label: const Text('Sign in with Google'),
            onPressed: _signInWithGoogle,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
