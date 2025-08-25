import 'package:notehub/features/auth/models/user_model.dart';

abstract class AuthRepository {
  /// Sign up, balikin userId dari backend
  Future<UserModel> signUp(String username, String email, String password);

  /// Login, balikin user model
  Future<UserModel> login(String email, String password);

  /// Logout, hapus data user lokal
  Future<void> logout();

  /// Cek user sekarang (dari SharedPreferences)
  Future<UserModel?> getCurrentUser();

  /// Update user
  Future<void> editUser(int userId, String nama, String email, String foto);
}