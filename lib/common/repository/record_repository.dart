import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agape/auth/repository/token_manager.dart';

final disabilityRecordRepositoryProvider =
    Provider((ref) => DisabilityRecordRepository());

class DisabilityRecordRepository {
  final String baseUrl = "https://agape-project.vercel.app";

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final url = Uri.parse('$baseUrl/api/disability-records/');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final records = data['results']?['data'];

      if (records == null || records is! List) {
        throw Exception('Disability record data is not available or invalid');
      }

      return List<Map<String, dynamic>>.from(records);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching records');
    }
  }

  // Get disability record by ID
  Future<Map<String, dynamic>> getRecordById(String id) async {
    final url = Uri.parse('$baseUrl/api/disability-records/$id/');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    if (response.statusCode == 200) {
      final record = jsonDecode(response.body);
      if (record == null || record is! Map) {
        throw Exception('Disability record data is not available or invalid');
      }

      return Map<String, dynamic>.from(record);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching record');
    }
  }

  // Create a new disability record (assuming POST is used)
  Future<String> createRecord(Map<String, dynamic> recordData) async {
    final url = Uri.parse('$baseUrl/api/disability-records/');
    final token = await TokenManager.getAccessToken();
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json", 
        "Authorization": token != null ? "Bearer $token" : "",
      },
      body: jsonEncode(recordData),
    );

    print(response.body);

    if (response.statusCode == 201) {
      return "Disability record created successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error creating record');
    }
  }

  // Update a disability record by ID (assuming PUT is used)
  Future<String> updateRecord(
      String id, Map<String, dynamic> recordData) async {
    final url = Uri.parse('$baseUrl/api/disability-records/$id/');
    final token = await TokenManager.getAccessToken();

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
      body: jsonEncode(recordData),
    );

    if (response.statusCode == 200) {
      return "Disability record updated successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error updating record');
    }
  }

  // Delete a disability record by ID (assuming DELETE is used)
  Future<String> deleteRecord(String id) async {
    final url = Uri.parse('$baseUrl/api/disability-records/$id/');
    final token = await TokenManager.getAccessToken();
    final response = await http.delete(url, headers: {
      "Content-Type": "application/json",
      "Authorization": token != null ? "Bearer $token" : "",
    });

    if (response.statusCode == 200) {
      return "Record deleted successfully";
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error deleting user');
    }
  }
}
