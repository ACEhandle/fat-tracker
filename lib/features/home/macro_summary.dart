import 'package:flutter/material.dart';
import '../../models/macro_targets.dart';

class MacroSummary extends StatelessWidget {
  final MacroTargets targets;
  const MacroSummary({super.key, required this.targets});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Daily Macro Targets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Calories: \\${targets.calories.toStringAsFixed(0)} kcal'),
            Text('Protein: \\${targets.protein.toStringAsFixed(0)} g'),
            Text('Carbs: \\${targets.carbs.toStringAsFixed(0)} g'),
            Text('Fat: \\${targets.fat.toStringAsFixed(0)} g'),
          ],
        ),
      ),
    );
  }
}
