enum Unit {
  gram,
  milligram,
  ounce,
  tablespoon,
  teaspoon,
  cup,
  piece, // fallback for things like eggs, bananas, etc.
}

extension UnitConversion on Unit {
  String get label {
    switch (this) {
      case Unit.gram: return 'g';
      case Unit.milligram: return 'mg';
      case Unit.ounce: return 'oz';
      case Unit.tablespoon: return 'tbsp';
      case Unit.teaspoon: return 'tsp';
      case Unit.cup: return 'cup';
      case Unit.piece: return 'piece';
    }
  }

  /// Conversion to grams (rough estimates where needed)
  double toGrams(double value) {
    switch (this) {
      case Unit.gram: return value;
      case Unit.milligram: return value / 1000;
      case Unit.ounce: return value * 28.35;
      case Unit.tablespoon: return value * 15;
      case Unit.teaspoon: return value * 5;
      case Unit.cup: return value * 240;
      case Unit.piece: return value * 50; // egg default
    }
  }
}
