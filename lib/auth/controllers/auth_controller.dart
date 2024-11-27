import 'package:flutter/material.dart';
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

  Future<String> sendPasswordResetEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final response = await authRepository.sendPasswordResetEmail({
        "email": email,
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> verifyOTP(String email, String otp) async {
    try {
      final response =
          await authRepository.verifyOTP({"email": email, "otp": otp});
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> setNewPassword(String email, String password, String password2) async {
    try {
      final response = await authRepository
          .setNewPassword({
            "email": email,
            "password": password, 
            "password2": password2
        });
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
