// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:afara_project/features/auth/auth_providers.dart';
import 'package:afara_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:afara_project/shared/navbar.dart';
import 'package:afara_project/shared/footer.dart';

class LoginIndividual extends ConsumerStatefulWidget {
  const LoginIndividual({super.key});

  @override
  ConsumerState<LoginIndividual> createState() => _LoginIndividualState();
}

class _LoginIndividualState extends ConsumerState<LoginIndividual> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Please enter both email and password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .login(email, password);
      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);

      if (authState.isOtpRequired && authState.email != null) {
        context.goNamed(
          'individual-login-verification',
          queryParameters: {'email': authState.email!},
        );
        return;
      }

      if (success) {
        context.go('/');
      } else {
        _showMessage(
          authState.errorMessage ?? 'Login failed. Please try again.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppTheme.isMobile(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopNavigation(),
            // MAIN HERO / BODY CONTENT WITH GRADIENT BACKGROUND
            Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 70,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,

                  colors: [Color(0xFFCBEDFB), Color(0xFF191970)],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _mainTabButton(
                        'For Individuals',
                        isActive: true,
                        onTap: () => context.go('/auth/individual/login'),
                      ),
                      _mainTabButton(
                        'For Businesses',
                        isActive: false,
                        onTap: () => context.go('/auth/business/login'),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.9),
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 850),
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            253,
                            253,
                            253,
                          ).withOpacity(0.9),
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign In to Your Individual Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              bool isWide = constraints.maxWidth > 600;
                              if (isWide) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Email Address',
                                        hint: 'Enter your email',
                                        controller: _emailController,
                                        obscure: false,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: _buildInputField(
                                        label: 'Password',
                                        hint: 'Enter your password',
                                        controller: _passwordController,
                                        obscure: true,
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return Column(
                                  children: [
                                    _buildInputField(
                                      label: 'Email Address',
                                      hint: 'Enter your email',
                                      controller: _emailController,
                                      obscure: false,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInputField(
                                      label: 'Password',
                                      hint: 'Enter your password',
                                      controller: _passwordController,
                                      obscure: true,
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: isMobile ? double.infinity : 180,
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _submitLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF162A63),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF162A63),
                                      ),
                                    )
                                  : const Text('Continue'),
                            ),
                          ),
                          const SizedBox(height: 16),

                          const SizedBox(height: 24),
                          _formFooterLink(
                            'Forgot Password?',
                            onTap: () =>
                                context.go('/auth/individual/forgot-password'),
                          ),
                          const SizedBox(height: 8),
                          _formFooterLink(
                            'New Afara customer? Sign up for free',
                            onTap: () =>
                                context.go('/auth/individual/register'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const MainFooter(),
          ],
        ),
      ),
    );
  }

  Widget _mainTabButton(
    String title, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? const Color(0xFF162A63) : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
            fontSize: 26,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool obscure,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.04),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.25)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formFooterLink(String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 13,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
