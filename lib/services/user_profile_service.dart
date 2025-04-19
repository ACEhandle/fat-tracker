import '../models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserProfileService {
  static const _userProfileKey = 'user_profile';

  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_userProfileKey, jsonEncode(profile.toMap()));
  }

  Future<UserProfile?> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_userProfileKey);
    if (str == null) return null;
    final map = jsonDecode(str) as Map<String, dynamic>;
    return UserProfile.fromMap(map);
  }
}
