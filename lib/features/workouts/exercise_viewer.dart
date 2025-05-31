import 'package:flutter/material.dart';
import '../../models/exercise.dart';
import '../../services/exercise_service.dart';

class ExerciseViewer extends StatefulWidget {
  const ExerciseViewer({super.key});

  @override
  _ExerciseViewerState createState() => _ExerciseViewerState();
}

class _ExerciseViewerState extends State<ExerciseViewer> {
  final ExerciseService _exerciseService = ExerciseService();
  late Future<List<Exercise>> _exercisesFuture;

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _exerciseService.fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No exercises found.'));
          } else {
            final exercises = snapshot.data!;
            return ListView.builder(
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final exercise = exercises[index];
                return ListTile(
                  title: Text(exercise.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${exercise.category}'),
                      if (exercise.primaryMuscles.isNotEmpty)
                        Text('Primary Muscles: ${exercise.primaryMuscles.join(', ')}'),
                    ],
                  ),
                  isThreeLine: true,
                );
              },
            );
          }
        },
      ),
    );
  }
}
