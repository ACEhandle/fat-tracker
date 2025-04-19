class FoodItem {
  final String id;
  final String name;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  FoodItem({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'calories': calories,
        'protein': protein,
        'carbs': carbs,
        'fat': fat,
      };

  factory FoodItem.fromMap(Map<String, dynamic> map) => FoodItem(
        id: map['id'],
        name: map['name'],
        calories: map['calories'],
        protein: map['protein'],
        carbs: map['carbs'],
        fat: map['fat'],
      );
}
