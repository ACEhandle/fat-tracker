import 'package:flutter/material.dart';
import '../../models/ingredient.dart';

class MealBuilder extends StatefulWidget {
  final List<Ingredient> availableIngredients;
  const MealBuilder({super.key, required this.availableIngredients});

  @override
  State<MealBuilder> createState() => _MealBuilderState();
}

class _MealBuilderState extends State<MealBuilder> {
  final List<_MealIngredient> _mealIngredients = [];
  final _formKey = GlobalKey<FormState>();
  Ingredient? _selectedIngredient;
  double _amount = 100;
  String _unit = 'g';

  void _addIngredient() {
    if (_selectedIngredient != null && _amount > 0) {
      setState(() {
        _mealIngredients.add(_MealIngredient(
          ingredient: _selectedIngredient!,
          amount: _amount,
          unit: _unit,
        ));
      });
    }
  }

  Map<String, double> _calculateTotals() {
    final totals = <String, double>{};
    for (final mi in _mealIngredients) {
      final factor = mi.unit == 'g' ? mi.amount / 100.0 : 1.0; // Assume nutrients per 100g
      mi.ingredient.nutrients.forEach((k, v) {
        final value = double.tryParse(v.toString()) ?? 0.0;
        totals[k] = (totals[k] ?? 0) + value * factor;
      });
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final totals = _calculateTotals();
    final calories = (totals['Data.Carbohydrate'] != null && totals['Data.Protein'] != null && totals['Data.Fat.Total Lipid'] != null)
        ? (totals['Data.Carbohydrate']! * 4 + totals['Data.Protein']! * 4 + totals['Data.Fat.Total Lipid']! * 9).toStringAsFixed(0)
        : '0';
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<Ingredient>(
                        value: _selectedIngredient,
                        items: widget.availableIngredients.map((i) => DropdownMenuItem(
                          value: i,
                          child: Text(i.description),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedIngredient = v),
                        decoration: const InputDecoration(labelText: 'Ingredient'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: _amount.toString(),
                        decoration: const InputDecoration(labelText: 'Amount'),
                        keyboardType: TextInputType.number,
                        onChanged: (v) => _amount = double.tryParse(v) ?? 100,
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: _unit,
                      items: const [
                        DropdownMenuItem(value: 'g', child: Text('g')),
                        DropdownMenuItem(value: 'piece', child: Text('piece')),
                        // Add more units as needed
                      ],
                      onChanged: (v) => setState(() => _unit = v ?? 'g'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addIngredient,
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _mealIngredients.length,
                  itemBuilder: (context, idx) {
                    final mi = _mealIngredients[idx];
                    return ListTile(
                      title: Text('${mi.ingredient.description}'),
                      subtitle: Text('${mi.amount} ${mi.unit}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => setState(() => _mealIngredients.removeAt(idx)),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Meal Macros', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Calories: $calories kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Protein: ${totals['Data.Protein']?.toStringAsFixed(1) ?? '0'} g', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Fat: ${totals['Data.Fat.Total Lipid']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('  Saturated: ${totals['Data.Fat.Saturated Fat']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('  Monounsaturated: ${totals['Data.Fat.Monosaturated Fat']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('  Polyunsaturated: ${totals['Data.Fat.Polysaturated Fat']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('Carbs: ${totals['Data.Carbohydrate']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('Fiber: ${totals['Data.Fiber']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('Sugar: ${totals['Data.Sugar Total']?.toStringAsFixed(1) ?? '0'} g'),
                  Text('Sodium: ${totals['Data.Major Minerals.Sodium']?.toStringAsFixed(1) ?? '0'} mg'),
                  // Add more nutrients as needed
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MealIngredient {
  final Ingredient ingredient;
  final double amount;
  final String unit;
  _MealIngredient({required this.ingredient, required this.amount, required this.unit});
}
