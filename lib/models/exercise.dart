class Exercise {
  final String id;
  final String name;
  final String description;
  final String category;
  final List<String> primaryMuscles;
  final List<String> secondaryMuscles;
  final List<String> equipment;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.equipment,
  });

  // Factory method to create an Exercise object from Firestore data
  factory Exercise.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Exercise(
      id: documentId,
      name: data['name'] ?? 'Unnamed Exercise',
      description: data['description'] ?? '',
      category: data['category'] ?? 'Uncategorized',
      primaryMuscles: List<String>.from(data['muscles_primary'] ?? []),
      secondaryMuscles: List<String>.from(data['muscles_secondary'] ?? []),
      equipment: List<String>.from(data['equipment'] ?? []),
    );
  }
}
