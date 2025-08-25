import 'package:notehub/features/auth/data/auth_localdatasource.dart';
import 'package:notehub/features/auth/data/auth_remotedatasource.dart';
import 'package:notehub/features/auth/domain/auth_repository.dart';
import 'package:notehub/features/auth/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<UserModel> signUp(String username, String email, String password) async {
    return await remoteDataSource.signUp(username, email, password);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    await localDataSource.saveUser(user); // simpan ke lokal
    return user;
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearUser();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return await localDataSource.getUser();
  }

  @override
  Future<void> editUser(int userId, String nama, String email, String foto) async {
    await remoteDataSource.editUser(userId, nama, email, foto);

    // update data lokal juga (biar konsisten)
    final updatedUser = UserModel(
      id: userId,
      nama: nama,
      email: email,
      foto: foto,
    );
    await localDataSource.saveUser(updatedUser);
  }
}
