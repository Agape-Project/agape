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
}
