import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agape/auth/repository/token_manager.dart';

import 'package:path/path.dart';

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

  Future<String> createRecord(Map<String, dynamic> recordData) async {
    final url = Uri.parse('$baseUrl/api/disability-records/');
    final token = await TokenManager.getAccessToken();

    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      "Authorization": token != null ? "Bearer $token" : "",
    });

    void processNestedMap(String parentKey, Map<String, dynamic> map) {
      map.forEach((key, value) async {
        final fullKey = parentKey.isNotEmpty ? '$parentKey.$key' : key;
        if (value is File) {
          request.files
              .add(await http.MultipartFile.fromPath(fullKey, value.path));
        } else if (value is Map<String, dynamic>) {
          processNestedMap(fullKey, value);
        } else {
          request.fields[fullKey] = value.toString();
        }
      });
    }

    recordData.forEach((key, value) async {
      if (value is File) {
      } else if (value is Map) {
        request.fields[key] = jsonEncode(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    if (recordData['profile_image'] != null &&
        recordData['profile_image'] is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'profile_image', recordData['profile_image'].path),
      );
    }
    if (recordData['kebele_id_image'] != null &&
        recordData['kebele_id_image'] is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'kebele_id_image', recordData['kebele_id_image'].path),
      );
    }
    if (recordData['warrant'] != null &&
        recordData['warrant'] is Map &&
        recordData['warrant']['id_image'] != null &&
        recordData['warrant']['id_image'] is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'warrant_id_image',
          (recordData['warrant']['id_image'] as File).path,
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 201) {
      return "Disability record created successfully";
    } else {
      final errorResponse = jsonDecode(responseBody);
      final errorMessage = errorResponse['detail'] ?? errorResponse.toString();
      throw Exception(errorMessage);
    }
  }

  // Update a disability record by ID (assuming PUT is used)
  Future<String> updateRecord(
      String id, Map<String, dynamic> recordData) async {
    final url = Uri.parse('$baseUrl/api/disability-records/$id/');
    final token = await TokenManager.getAccessToken();

    final request = http.MultipartRequest('PUT', url);

    request.headers.addAll({
      "Authorization": token != null ? "Bearer $token" : "",
    });

    void processNestedMap(String parentKey, Map<String, dynamic> map) {
      map.forEach((key, value) async {
        final fullKey = parentKey.isNotEmpty ? '$parentKey.$key' : key;
        if (value is File) {
          request.files
              .add(await http.MultipartFile.fromPath(fullKey, value.path));
        } else if (value is Map<String, dynamic>) {
          processNestedMap(fullKey, value);
        } else {
          request.fields[fullKey] = value.toString();
        }
      });
    }

    recordData.forEach((key, value) async {
      if (value is File) {
      } else if (value is Map) {
        request.fields[key] = jsonEncode(value);
      } else {
        request.fields[key] = value.toString();
      }
    });

    if (recordData['profile_image'] != null &&
        recordData['profile_image'] is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'profile_image', recordData['profile_image'].path),
      );
    }
    if (recordData['kebele_id_image'] != null &&
        recordData['kebele_id_image'] is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'kebele_id_image', recordData['kebele_id_image'].path),
      );
    }
    if (recordData['warrant'] != null &&
        recordData['warrant'] is Map &&
        recordData['warrant']['id_image'] != null &&
        recordData['warrant']['id_image'] is File) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'warrant_id_image',
          (recordData['warrant']['id_image'] as File).path,
        ),
      );
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return "Disability record updated successfully";
    } else {
      final errorResponse = jsonDecode(responseBody);
      final errorMessage = errorResponse['detail'] ?? errorResponse.toString();
      throw Exception(errorMessage);
    }
  }

  // filter records by query
  Future<List<Map<String, dynamic>>> filterRecords({
    String? gender,
    String? region,
    String? equipmentType,
    String? month,
    int? year,
  }) async {
    final filters = <String, String?>{
      'gender': gender,
      'region': region,
      'equipment_type': equipmentType,
      'month': month,
      'year': year?.toString(),
    };

    final queryString = filters.entries
        .where((entry) => entry.value != null && entry.value!.isNotEmpty)
        .map((entry) => "${entry.key}=${Uri.encodeComponent(entry.value!)}")
        .join('&');

    final url =
        Uri.parse('$baseUrl/api/disability-records/filter/?$queryString');
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

  Future<List<Map<String, dynamic>>> searchRecords(String query) async {
    final url = Uri.parse('$baseUrl/api/disability-records/?search=$query');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    print(response.body);
    print(response.statusCode);

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

  // stats

  Future<Map<String, dynamic>> getStats() async {
    final url = Uri.parse('$baseUrl/api/stats/');
    final token = await TokenManager.getAccessToken();
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": token != null ? "Bearer $token" : "",
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data == null || data is! Map) {
        throw Exception('Stats data is not available or invalid');
      }

      return Map<String, dynamic>.from(data);
    } else {
      throw Exception(
          jsonDecode(response.body)['detail'] ?? 'Error fetching stats');
    }
  }
}
