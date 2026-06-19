import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalStorage {
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String emailKey = 'user_email';

  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> setAccessToken(String token) async {
    await _storage.write(key: accessTokenKey, value: token);
  }

  static Future<String?> getAccessToken() async {
    return _storage.read(key: accessTokenKey);
  }

  static Future<void> setRefreshToken(String token) async {
    await _storage.write(key: refreshTokenKey, value: token);
  }

  static Future<String?> getRefreshToken() async {
    return _storage.read(key: refreshTokenKey);
  }

  static Future<void> setEmail(String email) async {
    await _storage.write(key: emailKey, value: email);
  }

  static Future<String?> getEmail() async {
    return _storage.read(key: emailKey);
  }

  static Future<void> clear() async {
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: emailKey);
  }
}
