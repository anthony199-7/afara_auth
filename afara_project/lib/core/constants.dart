class ApiConstants {
  static const String baseUrl = 'http://localhost:8082';
  static const String registerEndpoint = '/api/auth/register';
  static const String verifyOtpEndpoint = '/api/auth/verify-otp';
  static const String loginEndpoint = '/api/auth/login';
  static const String refreshEndpoint = '/api/auth/refresh';
  static const String logoutEndpoint = '/api/auth/logout';
  static const String profileEndpoint = '/api/me';
  static const String resendOtpEndpoint = '/api/auth/resend-otp';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String resetPasswordEndpoint = '/api/auth/reset-password';
}
