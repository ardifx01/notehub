import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notehub/core/network/api_client.dart';
import 'package:notehub/features/auth/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  // Login: backend balikin {"message": "...", "user": {...}}
  Future<UserModel> login(String email, String password) async {
    final response = await apiClient.post('/login', {
      "email": email,
      "password": password,
    });

    if (response['user'] != null) {
      return UserModel.fromJson(response['user']);
    } else {
      throw Exception(response['message'] ?? "Login gagal");
    }
  }

  // Signup: backend balikin {"message": "User created", "id": 1}
  Future<UserModel> signUp(
      String username, String email, String password) async {
    final response = await apiClient.post('/signup', {
      "nama": username,
      "email": email,
      "password": password,
    });

    if (response['user'] != null) {
      return UserModel.fromJson(response['user']);
    } else {
      throw Exception(response['message'] ?? "Signup gagal");
    }
  }

  // ==============================
  // ✏️ EDIT USER
  // ==============================
  Future<void> editUser(int userId, String nama, String email, String? foto,
      String? password) async {
    final body = {"nama": nama, "email": email};
    if (foto != null && foto.isNotEmpty) body["foto"] = foto;
    if (password != null && password.isNotEmpty) body["password"] = password;

    final response = await apiClient.put('/user/$userId', body);
    if (response['message'] != "User updated")
      throw Exception("Gagal update user");
  }

  // ==============================
  // 📤 UPLOAD FOTO
  // ==============================
  Future<String> uploadFotoKeCloudinary(String pathFile) async {
    const cloudName = "dgtvpcslj"; // ganti sesuai cloudinary
    const uploadPreset = "profile_pictures"; // ganti sesuai preset

    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', pathFile));

    final response = await request.send();
    final body = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = json.decode(body);
      return data['secure_url']; // URL untuk DB
    } else {
      throw Exception("Gagal upload foto: $body");
    }
  }
}
