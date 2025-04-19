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
    final data = doc.data() as Map<String, dynamic>;
    return Ingredient(
      id: doc.id,
      description: data['Description'] ?? '',
      category: data['Category'],
      nutrients: Map<String, dynamic>.from(data)..removeWhere((k, v) => k == 'Description' || k == 'Category'),
    );
  }
}
