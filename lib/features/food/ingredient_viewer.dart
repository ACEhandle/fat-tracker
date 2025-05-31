import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/ingredient.dart';
import '../../services/ingredient_service.dart';

class IngredientViewer extends StatefulWidget {
  const IngredientViewer({super.key});

  @override
  State<IngredientViewer> createState() => _IngredientViewerState();
}

class _IngredientViewerState extends State<IngredientViewer> {
  final IngredientService _ingredientService = IngredientService();
  final List<Ingredient> _selected = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Search Ingredients',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: null,
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Ingredient>>(
            stream: _ingredientService.streamIngredients(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                print('Error in StreamBuilder: ${snapshot.error}'); // Add error logging
                return const Center(child: Text('Error loading ingredients.'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                print('StreamBuilder: No ingredients found or data is empty.'); // Add logging
                return const Center(child: Text('FAIL: No ingredients found.'));
              }

              // Data is available, display it
              final ingredients = snapshot.data!;
              print('${ingredients.length} ingredients loaded.'); // Log count
              return ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (context, index) {
                  final ingredient = ingredients[index];
                  // Basic display, can be enhanced later
                  return ListTile(
                    title: Text(ingredient.description),
                    subtitle: Text(ingredient.category ?? 'No category'),
                    onTap: () {
                      // Optional: Show detail dialog or add to selection
                      showDialog(
                        context: context,
                        builder: (_) => IngredientDetailDialog(ingredient: ingredient),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
        if (_selected.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.restaurant_menu),
              label: Text('Create Meal with ${_selected.length} Ingredients'),
              onPressed: () async {
                final mealNameController = TextEditingController();
                final result = await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Create Meal'),
                    content: TextField(
                      controller: mealNameController,
                      decoration: const InputDecoration(labelText: 'Meal Name'),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(mealNameController.text),
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                );
                if (!context.mounted) return;
                if (result != null && result.trim().isNotEmpty) {
                  // Save meal with name `result` and selected ingredients
                  final meal = {
                    'name': result.trim(),
                    'ingredientIds': _selected.map((i) => i.id).toList(),
                    'ingredientDescriptions': _selected.map((i) => i.description).toList(),
                    'createdAt': DateTime.now().toIso8601String(),
                  };
                  try {
                    await FirebaseFirestore.instance.collection('meals').add(meal);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Meal "$result" created with ${_selected.length} ingredients.')),
                    );
                    setState(() => _selected.clear());
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save meal: $e')),
                    );
                  }
                }
              },
            ),
          ),
      ],
    );
  }
}

class IngredientDetailDialog extends StatelessWidget {
  final Ingredient ingredient;
  const IngredientDetailDialog({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(ingredient.description),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (ingredient.category != null && ingredient.category!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('Category: ${ingredient.category!}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ...ingredient.nutrients.entries.map((e) =>
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Text('${e.key}: ${e.value}'),
              ),
            ),
          ],
        ),
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
