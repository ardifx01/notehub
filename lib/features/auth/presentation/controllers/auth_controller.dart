import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; // untuk debugPrint
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
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
  // Future<void> pilihFotoPreview() async {
  //   // minta permission storage / photos
  //   var status =
  //       await Permission.storage.request(); // atau Permission.photos untuk iOS
  //   if (status.isGranted) {
  //     debugPrint("✅ Permission galeri diberikan");
  //   } else if (status.isPermanentlyDenied) {
  //     openAppSettings();
  //     return;
  //   } else {
  //     debugPrint("❌ Permission galeri ditolak");
  //     return;
  //   }

  //   // buka galeri
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     // crop gambar menjadi 1:1
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: image.path,
  //       aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
  //       uiSettings: [
  //         AndroidUiSettings(
  //           toolbarTitle: 'Crop Foto',
  //           lockAspectRatio: true,
  //         ),
  //         IOSUiSettings(
  //           title: 'Crop Foto',
  //           aspectRatioLockEnabled: true,
  //         ),
  //       ],
  //     );

  //     if (croppedFile != null) {
  //       fotoBaruPath.value = croppedFile.path; // simpan path hasil crop
  //     }
  //   }
  // }

 Future<void> pilihFotoPreview() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      // android 13 ke atas pakai photos, 12 ke bawah pakai storage
      if (Platform.version.contains('13') ||
          Platform.version.contains('14') ||
          Platform.version.contains('15')) {
        status = await Permission.photos.request();
      } else {
        status = await Permission.storage.request();
      }
    } else if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      return; // platform lain tidak didukung
    }

    // cek status permission
    if (!status.isGranted) {
      if (status.isPermanentlyDenied) openAppSettings();
      debugPrint("❌ Permission galeri ditolak");
      return;
    }

    debugPrint("✅ Permission galeri diberikan");

    // buka galeri
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      fotoBaruPath.value = image.path; // simpan path sementara
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
        fotoBaruPath.value,
        password?.isNotEmpty == true ? password : null,
      );

      // update state lokal pakai hasil backend (sudah url Cloudinary)
      user.value = updatedUser;

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
