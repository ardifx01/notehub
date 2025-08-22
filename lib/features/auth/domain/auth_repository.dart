abstract class AuthRepository {
  Future<void> signUp(String username, String email, String password);
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<bool> isAuthenticated();
}