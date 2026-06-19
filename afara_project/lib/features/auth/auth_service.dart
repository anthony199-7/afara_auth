import 'package:dio/dio.dart';
import "package:afara_project/core/api_client.dart";
import "package:afara_project/core/constants.dart";
import "package:afara_project/core/local_storage.dart";

class AuthService {
  final ApiClient _apiClient;
  AuthService(this._apiClient);
  Future<void> register(String email, String password) async {
    try {
      await _apiClient.dio.post(
        ApiConstants.registerEndpoint,
        data: {'email': email, 'password': password},
      );
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<void> verifyOtp(String email, String code) async {
    try {
      await _apiClient.dio.post(
        ApiConstants.verifyOtpEndpoint,
        data: {'email': email, 'code': code},
      );
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.loginEndpoint,
        data: {'email': email, 'password': password},
      );

      final data = response.data as Map<String, dynamic>;
      final accessToken = data['access_token'] as String;
      final refreshToken = data['refresh_token'] as String;
      await LocalStorage.setAccessToken(accessToken);
      await LocalStorage.setRefreshToken(refreshToken);
      await LocalStorage.setEmail(email);
      return data;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  Future<void> logout() async {
    try {
      final refreshToken = await LocalStorage.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _apiClient.dio.post(
          ApiConstants.logoutEndpoint,
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (_) {
      // Even if API logout fails, we want to proceed with local logout
    } finally {
      await LocalStorage.clear();
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.profileEndpoint);
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _parseError(e);
    }
  }

  String _parseError(DioException e) {
    if (e.response != null && e.response!.data != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('error')) {
        return data['error'].toString();
      }
    }
    return e.message ?? 'An unexpected error occurred';
  }
}
