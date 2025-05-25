import 'package:flutter/material.dart';
import '../../models/macro_targets.dart';
import 'macro_summary.dart';
import '../food/ingredient_viewer.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final todayMacros = MacroTargets(
      calories: 1800,
      protein: 120,
      carbs: 200,
      fat: 60,
    ); // Replace with real data/services as needed
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MacroSummary(targets: todayMacros),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.fastfood),
                  label: const Text('Log Food / Add Meal'),
                  onPressed: () {
                    // Show ingredient viewer as a modal bottom sheet for both food logging and meal creation
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: SizedBox(
                          height: 600,
                          child: IngredientViewer(),
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Workout'),
                  onPressed: () {
                    // TODO: Implement workout logging modal
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Today\'s Meals', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Breakfast: Oatmeal & Berries'),
                subtitle: const Text('Calories: 350, Protein: 12g'),
                trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Lunch: Chicken Salad'),
                subtitle: const Text('Calories: 500, Protein: 35g'),
                trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Today\'s Workouts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: const Text('Morning Run'),
                subtitle: const Text('Duration: 30 min, Calories: 250'),
                trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
