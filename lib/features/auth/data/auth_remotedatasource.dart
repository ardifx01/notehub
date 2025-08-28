import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:notehub/core/const/config.dart';
import 'package:notehub/core/network/api_client.dart';
import 'package:notehub/features/auth/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  // ==============================
  // Login
  // ==============================
  // note: backend balikin {"message": "...", "user": {...}}
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


  // ==============================
  // SIGNUP
  // ==============================
  // note: backend balikin {"message": "User created", "id": 1}
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
  // EDIT USER
  // ==============================
  // note: backend balikin {"message": "User updated", "user": {...}}
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
      final fotoUrl = await uploadFotoKeCloudinary(file); // upload ke Cloudinary dan dapatkan URL
      fields["foto"] = fotoUrl;
    }
    
    // Simpan perubahan nama, email, password ke database backend termasuk url foto dari Cloudinary
    final response = await apiClient.put("/user/$userId", fields); 

    if (response['message'] != "User updated") {
      throw Exception("Gagal update user");
    }

    // parsing data user baru dari backend
    return UserModel.fromJson(response['user']);
  }


  // ==============================
  // UPLOAD FOTO PROFILE KE CLOUDINARY
  // ==============================
  // note: balikin URL foto dari Cloudinary
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
}
