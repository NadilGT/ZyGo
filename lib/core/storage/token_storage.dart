import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' show FlutterSecureStorage;

import '../constants/api_constants.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _key = "auth_token";

  static final Dio _dio = Dio(
    BaseOptions(baseUrl: ApiConstants.baseURL),
  );

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _key, value: token);
  }

  static Future<String?> getToken() async {
    return _storage.read(key: _key);
  }

  static Future<void> clear() async {
    await _storage.delete(key: _key);
  }

  // ⭐ SIMPLE REFRESH HERE
  static Future<bool> refreshToken() async {
    try {
      final token = await getToken();

      final response = await _dio.post(
        "/auth/refresh",
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final newToken = response.data["token"];

      await saveToken(newToken);

      return true;
    } catch (e) {
      await clear();
      return false;
    }
  }
}
