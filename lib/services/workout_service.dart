import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutService {
  final CollectionReference _collection = FirebaseFirestore.instance.collection('workouts');

  Stream<List<Map<String, dynamic>>> streamWorkouts() {
    return _collection.snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList()
    );
  }

  Future<List<Map<String, dynamic>>> fetchWorkouts() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  Future<void> addWorkout(Map<String, dynamic> workout) async {
    await _collection.add(workout);
  }
}
