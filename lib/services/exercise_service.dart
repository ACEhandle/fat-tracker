import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise.dart';

class ExerciseService {
  final FirebaseFirestore _firestore;

  ExerciseService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Fetch all exercises from Firestore
  Future<List<Exercise>> fetchExercises() async {
    try {
      final querySnapshot = await _firestore.collection('exercises').get();
      return querySnapshot.docs
          .map((doc) => Exercise.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching exercises: $e');
      return [];
    }
  }
}
