import 'package:flutter/material.dart';

void main() {
  runApp(const FatTrackerApp());
}

class FatTrackerApp extends StatelessWidget {
  const FatTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fat Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fat Tracker'),
      ),
      body: const Center(
        child: Text('Welcome to Fat Tracker!'),
      ),
    );
  }
}
