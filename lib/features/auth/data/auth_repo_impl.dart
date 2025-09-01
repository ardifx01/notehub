import 'dart:io';

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
  Future<UserModel> signUp(
      String username, String email, String password) async {
    return await remoteDataSource.signUp(username, email, password);
  }

  @override
  Future<UserModel> login(String email, String password) async {
    final user = await remoteDataSource.login(email, password);
    await localDataSource.saveUser(user); // simpan ke lokal
    return user;
  }

  @override
  Future<UserModel> getUser(int userId) async {
    final user = await remoteDataSource.getUser(userId);
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
  Future<UserModel> editUser(
    int userId,
    String nama,
    String email,
    String? foto,
    String? password,
  ) async {
    final updatedUser = await remoteDataSource.editUser(
      userId,
      nama,
      email,
      password,
      foto,
    );

    // simpan ke lokal
    await localDataSource.saveUser(updatedUser);
    return updatedUser;
  }

  @override
  Future<String> uploadFotoKeCloudinary(File pathFile) async {
    return await remoteDataSource.uploadFotoKeCloudinary(pathFile);
  }
}
