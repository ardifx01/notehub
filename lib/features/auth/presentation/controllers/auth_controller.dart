import 'package:flutter/foundation.dart'; // untuk debugPrint
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/models/user_model.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  final ImagePicker _picker = ImagePicker();

  /// State reactive
  var user = Rxn<UserModel>(); // null kalau belum login
  var fotoBaruPath = Rxn<String>(); // variabel untuk preview foto sementara
  var isLoading = false.obs;

  /// Cek apakah user sudah login
  bool get isLoggedIn => user.value != null;

  @override
  void onInit() {
    super.onInit();
    debugPrint(
        "🔄 AuthController onInit dipanggil untuk load user dari sharedpreferences");
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

  // Signup + auto login
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

  // --- Pilih foto dari galeri, return path file atau null
  Future<String?> pilihFoto() async {
    // minta permission storage / photos
    var status = await Permission.photos
        .request(); // atau Permission.storage untuk <android 13
    if (status.isGranted) {
      // bisa akses galeri
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      debugPrint("❌ Permission galeri ditolak");
      return null;
    }

    // buka galeri
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    return image.path;
  }

  /// --- pilih foto tapi belum upload
  Future<void> pilihFotoPreview() async {
    String? path = await pilihFoto();
    if (path != null) {
      fotoBaruPath.value = path; // simpan path sementara
    }
  }

  /// --- simpan perubahan ke backend
  Future<void> editUser(String nama, String email, String? password) async {
    if (user.value == null) return;

    isLoading.value = true;
    try {
      String? urlFoto;

      // kalau ada foto baru, upload dulu
      if (fotoBaruPath.value != null) {
        urlFoto =
            await authRepository.uploadFotoKeCloudinary(fotoBaruPath.value!);
      }

      // update backend
      await authRepository.editUser(
        user.value!.id,
        nama,
        email,
        urlFoto ?? user.value!.foto,
        password,
      );

      // update state lokal
      user.value = user.value!.copyWith(
        nama: nama,
        email: email,
        foto: urlFoto ?? user.value!.foto,
      );

      // reset path foto sementara
      fotoBaruPath.value = null;
    } catch (e) {
      debugPrint("❌ Gagal update user: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// --- Logout
  Future<void> logout() async {
    debugPrint("🚪 Logout dipanggil...");
    await authRepository.logout();
    user.value = null;
    debugPrint("✅ User berhasil logout (local data dihapus)");
  }
}
