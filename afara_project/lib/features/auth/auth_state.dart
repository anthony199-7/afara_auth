enum AuthStatus {
  initial,
  loading,
  unauthenticated,
  otpVerificationRequired,
  authenticated,
  error,
}
class AuthState {
  final AuthStatus status;
  final String? email;
  final String? errorMessage;
  final Map<String, dynamic>? userProfile;
  const AuthState({
    required this.status,
    this.email,
    this.errorMessage,
    this.userProfile,
  });
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isOtpRequired => status == AuthStatus.otpVerificationRequired;
  bool get isError => status == AuthStatus.error;
  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);
  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.unauthenticated() => const AuthState(status: AuthStatus.unauthenticated);
  
  factory AuthState.otpRequired(String email) => AuthState(
        status: AuthStatus.otpVerificationRequired,
        email: email,
      );
      
  factory AuthState.authenticated(Map<String, dynamic> profile) => AuthState(
        status: AuthStatus.authenticated,
        userProfile: profile,
      );
      
  factory AuthState.error(String message, {String? email}) => AuthState(
        status: AuthStatus.error,
        errorMessage: message,
        email: email,
      );
  AuthState copyWith({
    AuthStatus? status,
    String? email,
    String? errorMessage,
    Map<String, dynamic>? userProfile,
  }) {
    return AuthState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
