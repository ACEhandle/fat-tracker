import 'package:flutter/material.dart';
import '../../services/workout_service.dart';

class WorkoutLoggingModal extends StatelessWidget {
  const WorkoutLoggingModal({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController typeController = TextEditingController();
    final TextEditingController durationController = TextEditingController();
    final TextEditingController caloriesController = TextEditingController();
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Log Workout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        TextField(
          controller: typeController,
          decoration: const InputDecoration(labelText: 'Workout Type'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: durationController,
          decoration: const InputDecoration(labelText: 'Duration (minutes)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: caloriesController,
          decoration: const InputDecoration(labelText: 'Calories Burned'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final workout = {
                  'type': typeController.text,
                  'duration': int.tryParse(durationController.text) ?? 0,
                  'calories': int.tryParse(caloriesController.text) ?? 0,
                  'timestamp': DateTime.now(),
                };
                await WorkoutService().addWorkout(workout);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
