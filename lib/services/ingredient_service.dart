import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ingredient.dart';
import '../models/food_item.dart';

class IngredientService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('ingredients');
  final CollectionReference _usdaCollection = FirebaseFirestore.instance.collection('usda_foods');

  Stream<List<Ingredient>> streamIngredients() {
    print('DEBUG IngredientService: streamIngredients() called');
    print('DEBUG: Firestore collection path: ${_collection.path}');
    return _collection.snapshots().map((snapshot) {
      print('DEBUG IngredientService: streamIngredients - snapshot received. Number of docs: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        print('DEBUG IngredientService: streamIngredients - snapshot.docs is empty.');
      }
      snapshot.docs.forEach((doc) {
        print('DEBUG IngredientService: streamIngredients - Processing doc ID: ${doc.id}, Data: ${doc.data()}');
      });
      try {
        final ingredients = snapshot.docs.map((doc) => Ingredient.fromFirestore(doc)).toList();
        print('DEBUG: Streamed ingredients: ${ingredients.map((i) => i.description).toList()}');
        return ingredients;
      } catch (e, stackTrace) {
        print('ERROR IngredientService: streamIngredients - Error mapping snapshot.docs: $e');
        print('StackTrace: $stackTrace');
        return []; // Return empty list on error
      }
    });
  }

  Future<List<Ingredient>> fetchIngredients() async {
    print('DEBUG IngredientService: fetchIngredients() called');
    try {
      final snapshot = await _collection.get();
      print('DEBUG IngredientService: fetchIngredients - snapshot received. Number of docs: ${snapshot.docs.length}');
      if (snapshot.docs.isEmpty) {
        print('DEBUG IngredientService: fetchIngredients - snapshot.docs is empty.');
      }
      snapshot.docs.forEach((doc) {
        print('DEBUG IngredientService: fetchIngredients - Processing doc ID: ${doc.id}, Data: ${doc.data()}');
      });
      final ingredients = snapshot.docs.map((doc) => Ingredient.fromFirestore(doc)).toList();
      print('DEBUG: Fetched ingredients: ${ingredients.map((i) => i.description).toList()}');
      return ingredients;
    } catch (e, stackTrace) {
      print('ERROR IngredientService: fetchIngredients - Error fetching or mapping: $e');
      print('StackTrace: $stackTrace');
      return []; // Return empty list on error
    }
  }

  Stream<List<FoodItem>> streamUsdaFoods() {
    return _usdaCollection.snapshots().map((snapshot) {
      final usdaFoods = snapshot.docs.map((doc) => FoodItem.fromFirestore(doc)).toList();
      print('DEBUG: Streamed USDA foods: ${usdaFoods.map((f) => f.name).toList()}');
      return usdaFoods;
    });
  }

  Future<List<FoodItem>> fetchUsdaFoods() async {
    final snapshot = await _usdaCollection.get();
    final usdaFoods = snapshot.docs.map((doc) => FoodItem.fromFirestore(doc)).toList();
    print('DEBUG: Fetched USDA foods: ${usdaFoods.map((f) => f.name).toList()}');
    return usdaFoods;
  }
}
