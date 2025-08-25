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
  Future<UserModel> signUp(String username, String email, String password) async {
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

  // Edit user
  Future<void> editUser(
      int userId, String nama, String email, String foto) async {
    final response = await apiClient.put('/user/$userId', {
      "nama": nama,
      "email": email,
      "foto": foto,
    });

    if (response['message'] != "User updated") {
      throw Exception("Gagal update user");
    }
  }
}
