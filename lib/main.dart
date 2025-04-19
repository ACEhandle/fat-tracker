import 'package:flutter/material.dart';

void main() {
  runApp(const FatTrackerApp());
}

class FatTrackerApp extends StatefulWidget {
  const FatTrackerApp({super.key});

  @override
  State<FatTrackerApp> createState() => _FatTrackerAppState();
}

class _FatTrackerAppState extends State<FatTrackerApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
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
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({super.key, required this.themeMode, required this.onThemeChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fat Tracker'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: onThemeChanged,
              ),
              const Icon(Icons.dark_mode),
              IconButton(
                icon: const Icon(Icons.login),
                tooltip: 'Sign In',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AuthDialog(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Fat Tracker!'),
      ),
    );
  }
}

class AuthDialog extends StatelessWidget {
  const AuthDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Sign In'),
      content: const Text('Credentials UI coming soon.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
