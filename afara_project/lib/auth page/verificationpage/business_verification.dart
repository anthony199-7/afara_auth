import 'dart:async';

import 'package:afara_project/core/api_client.dart';
import 'package:afara_project/core/theme/app_theme.dart';
import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:afara_project/features/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class VerificationPage extends StatelessWidget {
  final String email;

  const VerificationPage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4c75a3), // Light steel blue top
              Color(0xff12235a), // Deep dark navy middle
              Color.fromARGB(255, 232, 232, 236), // Ultra dark blue bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopNavigation(),
              const NavigationTabHeader(),
              MainVerificationSection(email: email),
              const MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. FOR BUSINESSES PAGE INDICATOR
class NavigationTabHeader extends StatelessWidget {
  const NavigationTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),

      child: Column(
        children: [
          const Text(
            'For Businesses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(width: 160, height: 2, color: Colors.white),
        ],
      ),
    );
  }
}

// 3. RESPONSIVE VERIFICATION CARD & VECTOR SECTION
class MainVerificationSection extends StatelessWidget {
  final String email;

  const MainVerificationSection({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppTheme.responsivePageWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 1000) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VerificationInputCard(email: email),
                  const SizedBox(height: 40),
                  const RightVectorGraphic(),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 11,
                    child: VerificationInputCard(email: email),
                  ),
                  const SizedBox(width: 40),
                  Expanded(flex: 5, child: RightVectorGraphic()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

// Left Verification Module Card
class VerificationInputCard extends StatefulWidget {
  final String email;

  const VerificationInputCard({super.key, required this.email});

  @override
  State<VerificationInputCard> createState() => _VerificationInputCardState();
}

class _VerificationInputCardState extends State<VerificationInputCard> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submitOtp() async {
    final code = _controllers.map((c) => c.text).join();
    final normalizedEmail = widget.email.trim().toLowerCase();

    if (normalizedEmail.isEmpty) {
      _showMessage(
        'Email is missing. Please return to registration and try again.',
      );
      return;
    }

    if (code.length != 6) {
      _showMessage('Please enter the full 6-digit code.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = AuthService(ApiClient());
      await authService.verifyOtp(normalizedEmail, code);
      if (!mounted) return;
      _showMessage('Account verified successfully.');
      context.goNamed('individual-login');
    } catch (e) {
      if (!mounted) return;
      _showMessage(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _startCooldown(int seconds) {
    _timer?.cancel();
    setState(() => _cooldown = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return timer.cancel();
      if (_cooldown <= 1) {
        timer.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown -= 1);
      }
    });
  }

  Future<void> _resendOtp() async {
    if (_cooldown > 0) return;
    final normalizedEmail = widget.email.trim().toLowerCase();
    if (normalizedEmail.isEmpty) {
      _showMessage(
        'We could not find the email for this verification request.',
      );
      return;
    }
    setState(() => _isLoading = true);
    try {
      final authService = AuthService(ApiClient());
      await authService.resendOtp(normalizedEmail);
      _showMessage('If an account exists, a new OTP was sent');
      _startCooldown(30);
    } catch (e) {
      _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(120),
      margin: const EdgeInsets.all(120),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color.fromARGB(255, 253, 253, 253),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verify Your Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Please enter the verification code\nsent to ${widget.email}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Verification Code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) => _buildOtpField(index)),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
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
                        color: Color(0xff12235a),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: _cooldown == 0 && !_isLoading ? _resendOtp : null,
            child: Text(
              _cooldown == 0 ? 'Resend OTP' : 'Resend in $_cooldown s',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextFormField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff2b467d).withValues(alpha: 0.2),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// Right Hand Vector Artwork Placeholder
class RightVectorGraphic extends StatelessWidget {
  const RightVectorGraphic({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // If you have your vector illustration added inside assets, swap this Icon block out with:
            Image.asset("lib/assets/images/verification.png"),
            Opacity(
              opacity: 0.85,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer structural base ring matching the design footprint
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: 260,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(260, 12),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        /*Icon(
                          Icons.lock_person_outlined,
                          size: 180,
                          color: Colors.blue[200],
                        ),*/
                        const SizedBox(height: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
