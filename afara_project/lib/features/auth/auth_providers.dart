import 'package:afara_project/core/api_client.dart';
import 'package:afara_project/core/local_storage.dart';
import 'package:afara_project/features/auth/auth_service.dart';
import 'package:afara_project/features/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});

class AuthNotifier extends Notifier<AuthState> {
  late final AuthService _authService;

  @override
  AuthState build() {
    _authService = ref.watch(authServiceProvider);
    checkAuthStatus();
    return AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    final token = await LocalStorage.getAccessToken();
    if (token == null || token.isEmpty) {
      state = AuthState.unauthenticated();
      return;
    }

    state = AuthState.loading();
    try {
      final profile = await _authService.getProfile();
      state = AuthState.authenticated(profile);
    } catch (_) {
      state = AuthState.unauthenticated();
    }
  }

  Future<bool> register(String email, String password) async {
    state = AuthState.loading();
    try {
      await _authService.register(email, password);
      state = AuthState.otpRequired(email);
      return true;
    } catch (e) {
      state = AuthState.error(e.toString());
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String code) async {
    state = AuthState.loading();
    try {
      await _authService.verifyOtp(email, code);
      state = AuthState.unauthenticated();
      return true;
    } catch (e) {
      state = AuthState.error(e.toString(), email: email);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    state = AuthState.loading();
    try {
      await _authService.login(email, password);
      final profile = await _authService.getProfile();
      state = AuthState.authenticated(profile);
      return true;
    } catch (e) {
      final message = e.toString();
      if (message.contains('not yet verified') || message.contains('OTP')) {
        state = AuthState.otpRequired(email);
      } else {
        state = AuthState.error(message);
      }
      return false;
    }
  }

  void clearSession() {
    state = AuthState.unauthenticated();
  }

  Future<void> logout() async {
    state = AuthState.loading();
    await _authService.logout();
    state = AuthState.unauthenticated();
  }
}

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
