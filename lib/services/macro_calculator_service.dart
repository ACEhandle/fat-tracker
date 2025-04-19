import '../models/user_profile.dart';
import '../models/macro_targets.dart';

class MacroCalculatorService {
  // Mifflin-St Jeor Equation
  static double calculateBMR(UserProfile profile) {
    if (profile.sex == 'male') {
      return 10 * profile.weightKg + 6.25 * profile.heightCm - 5 * profile.age + 5;
    } else {
      return 10 * profile.weightKg + 6.25 * profile.heightCm - 5 * profile.age - 161;
    }
  }

  static double activityMultiplier(String activityLevel) {
    switch (activityLevel) {
      case 'sedentary':
        return 1.2;
      case 'light':
        return 1.375;
      case 'moderate':
        return 1.55;
      case 'active':
        return 1.725;
      case 'very active':
        return 1.9;
      default:
        return 1.2;
    }
  }

  static MacroTargets calculateMacros(UserProfile profile) {
    final bmr = calculateBMR(profile);
    final tdee = bmr * activityMultiplier(profile.activityLevel);
    double calories = tdee;
    if (profile.goal == 'lose') calories -= 500;
    if (profile.goal == 'gain') calories += 500;
    // Example macros: 30% protein, 40% carbs, 30% fat
    final protein = (calories * 0.3) / 4;
    final carbs = (calories * 0.4) / 4;
    final fat = (calories * 0.3) / 9;
    return MacroTargets(
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
    );
  }
}
