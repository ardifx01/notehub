import 'package:flutter/foundation.dart'; // untuk debugPrint
import 'package:get/get.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/models/user_model.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  /// State reactive
  var user = Rxn<UserModel>(); // null kalau belum login
  var isLoading = false.obs;

  /// Cek apakah user sudah login
  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    debugPrint("🔄 AuthController onInit dipanggil untuk load user dari sharedpreferences");
    loadUser();
  }

  /// Load user dari local (SharedPreferences) saat app start
  Future<void> loadUser() async {
    isLoading.value = true;
    debugPrint("📥 loadUser: mencoba ambil user dari local storage...");
    try {
      final savedUser = await authRepository.getCurrentUser();
      if (savedUser != null) {
        debugPrint("✅ User ditemukan di local: ${savedUser.toJson()}");
      } else {
        debugPrint("⚠️ Tidak ada user tersimpan (belum login)");
      }
      user.value = savedUser;
    } catch (e) {
      debugPrint("❌ Gagal load user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    debugPrint("🔐 login dipanggil dengan email=$email");
    try {
      final loggedUser = await authRepository.login(email, password);
      debugPrint("✅ Login berhasil, user: ${loggedUser.toJson()}");
      user.value = loggedUser;
    } catch (e) {
      debugPrint("❌ Login gagal: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Signup + auto login
  Future<void> signUp(String nama, String email, String password) async {
    isLoading.value = true;
    debugPrint("📝 signUp dipanggil: nama=$nama, email=$email");
    try {
      final newUser = await authRepository.signUp(nama, email, password);
      debugPrint("✅ Signup berhasil, user: ${newUser.toJson()}");
      user.value = newUser;
    } catch (e) {
      debugPrint("❌ Signup gagal: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Edit user profile
  Future<void> editUser(String nama, String email, String foto) async {
    if (user.value == null) {
      debugPrint("⚠️ editUser dipanggil tapi tidak ada user login");
      return;
    }

    isLoading.value = true;
    debugPrint("✏️ Mengupdate user ${user.value!.id}");
    try {
      await authRepository.editUser(user.value!.id, nama, email, foto);

      // update di state
      user.value = user.value!.copyWith(
        nama: nama,
        email: email,
        foto: foto,
      );
      debugPrint("✅ User berhasil diupdate: ${user.value!.toJson()}");
    } catch (e) {
      debugPrint("❌ Gagal update user: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    debugPrint("🚪 Logout dipanggil...");
    await authRepository.logout();
    user.value = null;
    debugPrint("✅ User berhasil logout (local data dihapus)");
  }
}
