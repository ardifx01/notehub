import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:notehub/core/const/config.dart';
import 'package:notehub/features/auth/models/user_model.dart';

class AuthRemoteDataSource {
  final String baseUrl = Config.base_URL;

  // ==============================
  // LOGIN
  // ==============================
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['user'] != null) {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? "Login gagal");
    }
  }

  // ==============================
  // SIGNUP
  // ==============================
  Future<UserModel> signUp(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/signup'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "nama": username,
        "email": email,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['user'] != null) {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? "Signup gagal");
    }
  }

  // ==============================
  // EDIT USER
  // ==============================
  Future<UserModel> editUser(
    int userId,
    String nama,
    String email,
    String? password,
    String? fotoPath,
  ) async {
    final fields = {
      "nama": nama,
      "email": email,
    };

    if (password != null && password.isNotEmpty) {
      fields["password"] = password;
    }

    if (fotoPath != null && fotoPath.isNotEmpty) {
      final file = File(fotoPath);
      final fotoUrl = await uploadFotoKeCloudinary(file);
      fields["foto"] = fotoUrl;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/user/$userId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(fields),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['message'] == "User updated") {
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception(data['message'] ?? "Gagal update user");
    }
  }

  // ==============================
  // UPLOAD FOTO KE CLOUDINARY
  // ==============================
  Future<String> uploadFotoKeCloudinary(File file) async {
    const cloudName = Config.cloudinary_cloud_name;
    const uploadPreset = Config.cloudinary_upload_preset;

    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    var request = http.MultipartRequest("POST", url);
    request.fields["upload_preset"] = uploadPreset;
    request.files.add(await http.MultipartFile.fromPath("file", file.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      final data = jsonDecode(resBody);
      return data["secure_url"];
    } else {
      throw Exception("Gagal upload foto ke Cloudinary: $resBody");
    }
  }

  Future<UserModel> getUser(int userId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/user/$userId"),
      headers: {"Content-Type": "application/json"},
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? "Gagal ambil data user $userId");
    }
  }
}
