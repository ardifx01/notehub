import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; 
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/models/user_model.dart';
import 'package:notehub/features/note/presentation/controllers/note_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthController extends GetxController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  final ImagePicker _picker = ImagePicker();

  final noteController = Get.find<NoteController>();

  /// State reactive
  var user = Rxn<UserModel>(); // null kalau belum login
  var selectedUser = Rxn<UserModel>(); // User yang dipilih sementara
  var fotoBaruPath = Rxn<String>(); // variabel untuk preview foto sementara
  var isLoading = false.obs;

  /// Cek apakah user sudah login
  bool get isLoggedIn => user.value != null;

  // --- load user lokal dari SharedPreferences diawal app dibuka
  @override
  void onInit() {
    super.onInit();
    debugPrint(
        "🔄 AuthController onInit dipanggil untuk load user dari sharedpreferences");
    loadUser();
  }

  /// --- Load user dari local (SharedPreferences) saat app start
  Future<void> loadUser() async {
    isLoading.value = true;
    debugPrint("📥 loadUser: mencoba ambil user dari local storage...");
    try {
      final savedUser = await authRepository.getCurrentUser();
      if (savedUser != null) {
        debugPrint("✅ User ditemukan di local: ${savedUser.toJson()}");
        user.value = savedUser;
        noteController.fetchUserNotes(savedUser.id);
        noteController.fetchSavedNotes(savedUser.id);
      } else {
        debugPrint("⚠️ Tidak ada user tersimpan (belum login)");
        user.value = null;
      }
    } catch (e) {
      debugPrint("❌ Gagal load user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// --- Login
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    debugPrint("🔐 login dipanggil dengan email=$email");
    try {
      final loggedUser = await authRepository.login(email, password);
      debugPrint("✅ Login berhasil, user: ${loggedUser.toJson()}");
      user.value = loggedUser;

      // Fetch note user setelah login berhasil

      noteController.fetchUserNotes(loggedUser.id);
      noteController.fetchSavedNotes(loggedUser.id);
    } catch (e) {
      debugPrint("❌ Login gagal: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  // --- Signup + auto login
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

  Future<void> ambilUser(int userId) async {
    isLoading.value = true;
    debugPrint("🤣 Mulai ambil data user lain $userId");
    try {
      final userData = await authRepository.getUser(userId);
      debugPrint("✅ Ambil data user lain berhasil, user lain: ${userData.toJson()}");
      selectedUser.value = userData;
    } catch (e) {
      debugPrint("❌ Ambil data user gagal: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  /// --- Pilih foto dari galeri, simpan path sementara untuk preview
Future<void> pilihFotoPreview() async {
  PermissionStatus status;

  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    final sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      // Android 13 ke atas → pakai photos
      status = await Permission.photos.request();
    } else {
      // Android 12 ke bawah → pakai storage
      status = await Permission.storage.request();
    }
  } else if (Platform.isIOS) {
    status = await Permission.photos.request();
  } else {
    return; // platform lain tidak didukung
  }

  // cek status permission
  if (!status.isGranted) {
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
    debugPrint("❌ Permission galeri ditolak");
    return;
  }

  debugPrint("✅ Permission galeri diberikan");

  // buka galeri
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    // contoh kalau pakai RxString di GetX
    fotoBaruPath.value = image.path;
    debugPrint("📸 Path foto: ${image.path}");
  }
}
  /// --- Edit user (nama, email, foto, password)
  Future<void> editUsercon(
      String? nama, String? email, String? password) async {
    if (user.value == null) return;

    isLoading.value = true;
    try {
      final updatedUser = await authRepository.editUser(
        user.value!.id,
        nama?.isNotEmpty == true ? nama! : user.value!.nama,
        email?.isNotEmpty == true ? email! : user.value!.email,
        fotoBaruPath.value, // path foto dari preview
        password?.isNotEmpty == true ? password : null,
      );

      // update variabel user sekarang pakai hasil backend
      user.value = updatedUser;
      // reset path foto preview
      fotoBaruPath.value = null;
      debugPrint("✅ User berhasil diupdate: ${updatedUser.toJson()}");
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
