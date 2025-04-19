class UserProfile {
  final String uid;
  final String sex; // 'male' or 'female'
  final int age;
  final double heightCm;
  final double weightKg;
  final String activityLevel; // e.g., 'sedentary', 'light', 'moderate', 'active', 'very active'
  final String goal; // e.g., 'maintain', 'lose', 'gain'

  UserProfile({
    required this.uid,
    required this.sex,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.activityLevel,
    required this.goal,
  });

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'sex': sex,
    'age': age,
    'heightCm': heightCm,
    'weightKg': weightKg,
    'activityLevel': activityLevel,
    'goal': goal,
  };

  factory UserProfile.fromMap(Map<String, dynamic> map) => UserProfile(
    uid: map['uid'] ?? '',
    sex: map['sex'] ?? '',
    age: map['age'] ?? 0,
    heightCm: (map['heightCm'] ?? 0).toDouble(),
    weightKg: (map['weightKg'] ?? 0).toDouble(),
    activityLevel: map['activityLevel'] ?? '',
    goal: map['goal'] ?? 'maintain',
  );
}
