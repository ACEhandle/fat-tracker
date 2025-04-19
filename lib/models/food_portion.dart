import 'food_item.dart';
import 'unit.dart';

class FoodPortion {
  final FoodItem item;
  final double amount;
  final Unit unit;

  FoodPortion({
    required this.item,
    required this.amount,
    required this.unit,
  });

  double get grams => unit.toGrams(amount);

  double get calories => (grams / 100) * item.calories;
  double get protein => (grams / 100) * item.protein;
  double get carbs => (grams / 100) * item.carbs;
  double get fat => (grams / 100) * item.fat;

  Map<String, dynamic> toMap() => {
        'item': item.toMap(),
        'amount': amount,
        'unit': unit.name,
      };

  factory FoodPortion.fromMap(Map<String, dynamic> map) => FoodPortion(
        item: FoodItem.fromMap(map['item']),
        amount: map['amount'],
        unit: Unit.values.byName(map['unit']),
      );
}
