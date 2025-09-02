import 'dart:convert';
import 'package:notehub/features/auth/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDataSource {
  // Buat key
  static const String _keyUser = "auth_user";

  // Simpan user ke sharedpreferences lokal
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }
  
  // Ambil suer dari sharedpreferences lokal
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    if (userJson == null) return null;
    return UserModel.fromJson(jsonDecode(userJson));
  }

  // Hapus user di sharedpreferences lokal
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUser);
  }
}
