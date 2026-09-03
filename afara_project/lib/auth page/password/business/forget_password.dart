import 'package:afara_project/core/api_client.dart';
import 'package:afara_project/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String userType;
  const ForgotPasswordPage({super.key, required this.userType});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return _showMessage('Please enter your email');
    setState(() => _isLoading = true);
    try {
      final authService = AuthService(ApiClient());
      await authService.forgotPassword(email);
      if (!mounted) return;
      _showMessage('If an account exists, an OTP was sent to the email');
      // Navigate to individual verification route with email query
      context.go('/auth/individual/verification?email=$email');
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.userType == 'business'
        ? 'Business Password Recovery'
        : 'Individual Password Recovery';
    final loginRoute = widget.userType == 'business'
        ? '/auth/business/login'
        : '/auth/individual/login';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF162A63),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Enter your email address to receive a verification code to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 220,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF162A63),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send Code'),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => context.go(loginRoute),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF162A63),
                ),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
