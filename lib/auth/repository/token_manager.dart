import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  static Future<void> setAccessToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  static Future<void> deleteAccessToken() async {
    await _storage.delete(key: 'access_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  static Future<void> setRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  static Future<void> deleteRefreshToken() async {
    await _storage.delete(key: 'refresh_token');
  }
}
