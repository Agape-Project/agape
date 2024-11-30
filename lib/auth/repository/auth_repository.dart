import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final storage = FlutterSecureStorage();

class AuthRepository {
  final String baseUrl = "https://agape-project.vercel.app";

  Future<String> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/register/');
    final token = await storage.read(key: 'access_token');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
      body: jsonEncode(userData),
    );
    if (response.statusCode == 201) {
      return "User registered successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error registering user');
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final url = Uri.parse('$baseUrl/api/users/');
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final users = data['results']?['data'];

      if (users == null || users is! List) {
        throw Exception('Users data is not available or invalid');
      }

      return List<Map<String, dynamic>>.from(users);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching users');
    }
  }

//get user by id
  Future<Map<String, dynamic>> getUserById(String id) async {
    final url = Uri.parse('$baseUrl/api/users/$id');
    final token = await storage.read(key: 'access_token');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      final user = data['data'];

      if (user == null || user is! Map) {
        throw Exception('User data is not available or invalid');
      }

      return Map<String, dynamic>.from(user);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching user');
    }
  }

// update user

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
            (data['data']['access'] != null ||
                data['data']['refresh'] != null)) {
          await storage.write(
              key: 'access_token', value: data['data']['access']);
          await storage.write(
              key: 'refresh_token', value: data['data']['refresh']);

          return "Login successful";
        } else {
          throw Exception(data['detail'] ?? 'Invalid email or password');
        }
      } catch (e) {
        throw Exception('Invalid JSON response from server: $e');
      }
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Invalid credentials');
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
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? "OTP verification successful";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? "Error verifying OTP");
    }
  }

  Future<String> setNewPassword(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/set-new-password/');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? "Password successfully updated";
    } else {
      throw Exception("Failed to set new password: ${response.reasonPhrase}");
    }
  }
  // update user by id

  Future<String> updateUser(String id, Map<String, dynamic> userData) async {
    final url = Uri.parse(
        '$baseUrl/api/users/$id/'); 
    final token = await storage.read(key: "access_token");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return "User updated successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error updating user');
    }
  }

  Future<String> logoutUser() async {
    final url = Uri.parse('$baseUrl/api/auth/logout/');
    final token = await storage.read(key: 'access_token');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');
      return "Logout successful";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error logging out');
    }
  }
}
