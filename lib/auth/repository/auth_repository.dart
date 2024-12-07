// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'package:agape/auth/repository/token_manager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final userProvider = StateProvider<Map<String, dynamic>>((ref) => {});

class AuthRepository {
  final String baseUrl = "https://agape-project.vercel.app";

  Future<String> registerUser(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/auth/register/');
    final token = await TokenManager.getAccessToken();
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

// get current user info
  Future<Map<String, dynamic>> getCurrentUser() async {
    final url = Uri.parse('$baseUrl/api/auth/profile/');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      if (user == null || user is! Map) {
        throw Exception('User data is not available or invalid');
      }
      return Map<String, dynamic>.from(user);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching user');
    }
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final url = Uri.parse('$baseUrl/api/users/');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );
     // Log the response status code and body
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

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
    final url = Uri.parse('$baseUrl/api/users/$id/');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      if (user == null || user is! Map) {
        throw Exception('User data is not available or invalid');
      }

      return Map<String, dynamic>.from(user);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching user');
    }
  }

  // block and unblock user by id patch request
  Future<String> blockUnblockUser(String id) async {
    final url = Uri.parse('$baseUrl/api/users/$id/block/');
    final token = await TokenManager.getAccessToken();
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );
    if (response.statusCode == 200) {
      return "User blocked successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error blocking user');
    }
  }

  // delete user by id
  Future<String> deleteUser(String id) async {
    final url = Uri.parse('$baseUrl/api/users/$id/delete/');
    final token = await TokenManager.getAccessToken();
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": token != null ? "Bearer $token" : "",
    });
    if (response.statusCode == 204 || response.statusCode == 200) {
      return "User deleted successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error deleting user');
    }
  }

// login user
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
        final accessToken = data['data']?['access'];
        final refreshToken = data['data']?['refresh'];

        if (data['data'] != null &&
            (data['data']['access'] != null ||
                data['data']['refresh'] != null)) {
          await TokenManager.setAccessToken(accessToken);
          await TokenManager.setRefreshToken(refreshToken);
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

  // update user password
  Future<String> updatePassword(
      String id, Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/api/users/$id/update-password/');
    final token = await TokenManager.getAccessToken();
    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? "Password successfully updated";
    } else {
      throw Exception("Failed to update password: ${response.reasonPhrase}");
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
    final url = Uri.parse('$baseUrl/api/users/$id/');
    final token = await TokenManager.getAccessToken();

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
    final token = await TokenManager.getAccessToken();
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );
    if (response.statusCode == 205) {
      await TokenManager.deleteAccessToken();
      await TokenManager.deleteRefreshToken();
      return "Logout successful";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error logging out');
    }
  }
}
