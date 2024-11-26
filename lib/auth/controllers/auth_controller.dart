import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agape/auth/repository/auth_repository.dart';

class AuthController {
  final AuthRepository authRepository;

  AuthController(this.authRepository);

  Future<String> login(String email, String password) async {
    try {
      final response = await authRepository.loginUser({
        "email": email,
        "password": password,
      });
      return response;
    } catch (e) {
      rethrow; 
    }
  }

  Future<String> register(Map<String, dynamic> userData) async {
    try {
      final response = await authRepository.registerUser(userData);
      return response; 
    } catch (e) {
      rethrow; 
    }
  }
}

final authControllerProvider = Provider((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthController(authRepository);
});
