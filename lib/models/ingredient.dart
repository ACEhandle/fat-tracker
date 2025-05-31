import 'package:cloud_firestore/cloud_firestore.dart';

class Ingredient {
  final String id;
  final String description;
  final String? category;
  final Map<String, dynamic> nutrients;

  Ingredient({
    required this.id,
    required this.description,
    this.category,
    required this.nutrients,
  });

  factory Ingredient.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; // Allow data to be potentially null

    print('DEBUG Ingredient.fromFirestore: doc.id = ${doc.id}');
    if (data == null) {
      print('DEBUG Ingredient.fromFirestore: data for doc.id ${doc.id} is null');
      // Decide how to handle null data, e.g., throw error or return a default/empty Ingredient
      // For now, let's throw to make it obvious if this happens.
      throw Exception('Document data is null for id: ${doc.id}');
    }
    print('DEBUG Ingredient.fromFirestore: raw data for doc.id ${doc.id} = $data');

    try {
      final description = data['description'] as String? ?? '';
      final category = data['category'] as String?;
      final nutrientsData = data['nutrients'];

      print('DEBUG Ingredient.fromFirestore: description = $description, category = $category');
      print('DEBUG Ingredient.fromFirestore: nutrientsData type = ${nutrientsData.runtimeType}, value = $nutrientsData');

      Map<String, dynamic> nutrientsMap;
      if (nutrientsData is Map) {
        nutrientsMap = Map<String, dynamic>.from(nutrientsData);
      } else if (nutrientsData == null) {
        print('DEBUG Ingredient.fromFirestore: nutrientsData is null for doc.id ${doc.id}, defaulting to empty map.');
        nutrientsMap = {};
      } else {
        print('ERROR Ingredient.fromFirestore: nutrientsData for doc.id ${doc.id} is not a Map, it is ${nutrientsData.runtimeType}. Defaulting to empty map.');
        nutrientsMap = {}; // Or handle as an error
      }

      return Ingredient(
        id: doc.id,
        description: description,
        category: category,
        nutrients: nutrientsMap,
      );
    } catch (e, stackTrace) {
      print('ERROR Ingredient.fromFirestore: Failed to parse document ${doc.id}');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      // Re-throw or return a specific error object / null as appropriate
      // For now, re-throwing to ensure it's visible.
      rethrow;
    }
  }
}
