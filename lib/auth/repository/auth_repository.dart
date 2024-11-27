import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

class AuthRepository {
  final String baseUrl = "https://agape-project.vercel.app";

  Future<String> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/register/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 201) {
      return "User registered successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error registering user');
    }
  }

  Future<String> loginUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/login/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        if (data['data'] != null &&
            (data['data']['refresh'] != null ||
                data['data']['access'] != null)) {
          return "Login successful";
        } else {
          throw Exception(data['detail'] ?? 'Invalid email or password');
        }
      } catch (e) {
        throw Exception('Invalid JSON response from server');
      }
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'invalid credentials');
    }
  }

  Future<String> sendPasswordResetEmail(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/reset-password/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return "Password reset link sent to your email";
    } else {
      throw Exception(jsonDecode(response.body)['detail'] ??
          'Error sending password reset link');
    }
  }

  Future<String> verifyOTP(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/verify-otp/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['message'];
        } else {
          return "OTP verification failed";
        }
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return data['detail'] ?? "Bad request, please try again";
      } else if (response.statusCode == 404) {
        return "OTP verification endpoint not found";
      } else {
        final data = jsonDecode(response.body);
        return data['detail'] ?? "Error verifying OTP";
      }
    } catch (e) {
      return "Failed to verify OTP. Please check your internet connection.";
    }
  }

  Future<String> setNewPassword(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/set-new-password/');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(userData),
      );
      print(response.body);
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? "Password successfully updated";
      } else {
        return "Failed to set new password: ${response.reasonPhrase}";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }
}
