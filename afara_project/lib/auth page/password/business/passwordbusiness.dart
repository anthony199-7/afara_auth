import 'package:afara_project/core/api_client.dart';
import 'package:afara_project/features/auth/auth_service.dart';
import 'package:afara_project/shared/footer.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessPassword extends StatelessWidget {
  final String email;
  final String role;

  const BusinessPassword({super.key, required this.email, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xff4c75a3), Color(0xff12235a), Color(0xffefeff1)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BusinessPasswordContent(email: email, role: role),
              const MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class BusinessPasswordContent extends StatefulWidget {
  final String email;
  final String role;

  const BusinessPasswordContent({
    super.key,
    required this.email,
    required this.role,
  });

  @override
  State<BusinessPasswordContent> createState() =>
      _BusinessPasswordContentState();
}

class _BusinessPasswordContentState extends State<BusinessPasswordContent> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool _isLoading = false;

  Future<void> _registerUser() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _retypePasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      _showMessage('Please enter and confirm your password.');
      return;
    }

    if (password != confirmPassword) {
      _showMessage('Passwords do not match.');
      return;
    }

    if (password.length < 12) {
      _showMessage('Password must be at least 12 characters.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = AuthService(ApiClient());
      await authService.register(widget.email, password);
      if (!mounted) return;
      _showMessage('Account created. Please verify your email.');
      context.goNamed(
        'business-verification',
        queryParameters: {'email': widget.email},
      );
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
    _passwordController.dispose();
    _retypePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the loading state from the provider

    return Center(
      child: Container(
        width: 950,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Prominent verified message header
            const Text(
              'Set Your Password', // Changed text
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 40),

            // Password setup card module
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white24, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Create your password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Responsive side-by-side setup row
                  LayoutBuilder(
                    builder: (context, inputConstraints) {
                      if (inputConstraints.maxWidth < 600) {
                        return Column(
                          children: [
                            _buildPasswordField(
                              'Password',
                              'Password',
                              _passwordController,
                            ),
                            const SizedBox(height: 16),
                            _buildPasswordField(
                              'Retype Password',
                              'Retype Password',
                              _retypePasswordController,
                            ),
                          ],
                        );
                      } else {
                        return Row(
                          children: [
                            Expanded(
                              child: _buildPasswordField(
                                'Password',
                                'Password',
                                _passwordController,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildPasswordField(
                                'Retype Password',
                                'Retype Password',
                                _retypePasswordController,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),

                  // Verification criteria text details
                  const Text(
                    'Password must be at least twelve (12) characters long',
                    style: TextStyle(color: Colors.white60, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      'Suggest a password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Card submit controller
                  SizedBox(
                    width: 160,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _registerUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xff12235a),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xff12235a),
                              ),
                            )
                          : const Text(
                              'Submit',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String title,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: true,
          obscuringCharacter: '•',
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
            filled: true,
            fillColor: const Color(0xff2b467d).withValues(alpha: 0.15),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

// --- 1. GLOBAL NAVIGATION ARCHITECTURE ---
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Micro Top Utilities Strip
        Container(
          color: const Color(0xff224a7d),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'For Individuals',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'For Businesses',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: Colors.white,
                ),
                label: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        // Primary White Top Header
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          child: Row(
            children: [
              const Icon(
                Icons.change_history,
                color: Color(0xff1a237e),
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'AFARA',
                style: TextStyle(
                  color: Color(0xff1a237e),
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Features',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Resources',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Pricing',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff121858),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff1a237e), width: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: Color(0xff1a237e)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
