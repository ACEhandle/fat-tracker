import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingredient.dart';

class IngredientService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('ingredients');

  Stream<List<Ingredient>> streamIngredients() {
    return _collection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => Ingredient.fromFirestore(doc)).toList()
    );
  }

  Future<List<Ingredient>> fetchIngredients() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => Ingredient.fromFirestore(doc)).toList();
  }
}
