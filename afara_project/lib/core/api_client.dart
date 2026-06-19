import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:afara_project/core/constants.dart';
import 'package:afara_project/core/local_storage.dart';

class ApiClient {
  late final Dio dio;
  final VoidCallback? onSessionExpired;

  ApiClient({this.onSessionExpired}) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await LocalStorage.getAccessToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          final path = error.requestOptions.path;
          final isAuthPath =
              path.contains('/api/auth/login') ||
              path.contains('/api/auth/refresh') ||
              path.contains('/api/auth/register') ||
              path.contains('/api/auth/verify-otp');

          if (error.response?.statusCode == 401 && !isAuthPath) {
            final refreshToken = await LocalStorage.getRefreshToken();
            if (refreshToken != null && refreshToken.isNotEmpty) {
              try {
                if (kDebugMode) {
                  print('Access token expired, attempting refresh...');
                }

                final refreshDio = Dio(
                  BaseOptions(baseUrl: ApiConstants.baseUrl),
                );
                final response = await refreshDio.post(
                  ApiConstants.refreshEndpoint,
                  data: {'refresh_token': refreshToken},
                );

                if (response.statusCode == 200 && response.data is Map) {
                  final data = response.data as Map<String, dynamic>;
                  final newAccessToken = data['access_token'] as String;
                  final newRefreshToken = data['refresh_token'] as String;

                  await LocalStorage.setAccessToken(newAccessToken);
                  await LocalStorage.setRefreshToken(newRefreshToken);

                  if (kDebugMode) {
                    print(
                      'Token refresh successful. Retrying original request.',
                    );
                  }

                  final options = error.requestOptions;
                  options.headers['Authorization'] = 'Bearer $newAccessToken';

                  final retryResponse = await dio.fetch(options);
                  return handler.resolve(retryResponse);
                }
              } catch (e) {
                if (kDebugMode) {
                  print('Token refresh failed: $e');
                }
                await LocalStorage.clear();
                onSessionExpired?.call();
                return handler.reject(error);
              }
            } else {
              await LocalStorage.clear();
              onSessionExpired?.call();
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
