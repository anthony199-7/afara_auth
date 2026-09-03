import 'package:afara_project/features/auth/auth_providers.dart';
import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BusinessLoginPage extends ConsumerStatefulWidget {
  const BusinessLoginPage({super.key});

  @override
  ConsumerState<BusinessLoginPage> createState() => _BusinessLoginPageState();
}

class _BusinessLoginPageState extends ConsumerState<BusinessLoginPage> {
  final _orgUrlController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      _showMessage('Please enter both username and password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .login(username, password);

      if (!mounted) return;
      if (success) {
        context.go('/');
      } else {
        _showMessage(
          ref.read(authNotifierProvider).errorMessage ??
              'Login failed. Please try again.',
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
    _orgUrlController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopNavigation(),
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
                        isActive: false,
                        onTap: () => context.go('/auth/individual/login'),
                      ),
                      _mainTabButton(
                        'For Businesses',
                        isActive: true,
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
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(
                          color: const Color.fromARGB(
                            255,
                            255,
                            254,
                            254,
                          ).withValues(alpha: 0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sign In to Your Business Account',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isWide = constraints.maxWidth > 600;
                              return Column(
                                children: [
                                  if (isWide)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInputField(
                                            label: 'Organization URL',
                                            hint: 'Company Name',
                                            controller: _orgUrlController,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                          ),
                                          margin: const EdgeInsets.only(
                                            top: 28,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                            border: Border.all(
                                              color: Colors.white.withValues(
                                                alpha: 0.25,
                                              ),
                                            ),
                                            color: Colors.white.withValues(
                                              alpha: 0.04,
                                            ),
                                          ),
                                          child: DropdownButton<String>(
                                            value: 'afara.com',
                                            dropdownColor: const Color(
                                              0xFF222B69,
                                            ),
                                            icon: const Icon(
                                              Icons.keyboard_arrow_down,
                                              color: Color.fromARGB(
                                                255,
                                                253,
                                                253,
                                                253,
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255,
                                              ),
                                            ),
                                            underline: const SizedBox(),
                                            items: ['afara.com']
                                                .map(
                                                  (val) => DropdownMenuItem(
                                                    value: val,
                                                    child: Text(val),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (_) {},
                                          ),
                                        ),
                                      ],
                                    ),

                                  const SizedBox(height: 16),
                                  // Row 2: Username & Password Side-by-Side on Desktop
                                  if (isWide)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildInputField(
                                            label: 'Username',
                                            hint: 'Enter your username',
                                            controller: _usernameController,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildInputField(
                                            label: 'Password',
                                            hint: 'Enter your password',
                                            controller: _passwordController,
                                            obscure: true,
                                          ),
                                        ),
                                      ],
                                    )
                                  else ...[
                                    _buildInputField(
                                      label: 'Username',
                                      hint: 'Enter your username',
                                      controller: _usernameController,
                                    ),
                                    const SizedBox(height: 16),
                                    _buildInputField(
                                      label: 'Password',
                                      hint: 'Enter your password',
                                      controller: _passwordController,
                                      obscure: true,
                                    ),
                                  ],

                                  const SizedBox(height: 28),
                                  SizedBox(
                                    width: isWide ? 180 : double.infinity,
                                    height: 46,
                                    child: ElevatedButton(
                                      onPressed: _isLoading
                                          ? null
                                          : _submitLogin,
                                      style: ElevatedButton.styleFrom(
                                        // backgroundColor: Colors.white,
                                        foregroundColor: const Color(
                                          0xFF13184E,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: Color(0xFF13184E),
                                              ),
                                            )
                                          : const Text('Continue'),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  _formFooterLink(
                                    'Need help signing in?',
                                    onTap: () => context.go(
                                      '/auth/business/forgot-password',
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _formFooterLink(
                                    'New Afara customer? Sign up for free',
                                    onTap: () =>
                                        context.go('/auth/business/register'),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
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
              color: isActive
                  ? const Color.fromARGB(255, 13, 12, 105)
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive
                ? Colors.white
                : Colors.white.withValues(alpha: 0.5),
            fontSize: 22,
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
    bool obscure = false,
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
              color: Colors.white.withValues(alpha: 0.4),
              fontSize: 14,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.04),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.25),
              ),
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
          color: const Color.fromARGB(
            255,
            253,
            252,
            252,
          ).withValues(alpha: 0.8),
          fontSize: 13,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
