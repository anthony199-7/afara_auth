import 'package:afara_project/features/auth/auth_providers.dart';
import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginOtpVerificationScreenPage extends StatelessWidget {
  final String email;

  const LoginOtpVerificationScreenPage({super.key, required this.email});

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
              Color.fromARGB(255, 230, 231, 235), // Ultra dark blue bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopNavigation(),
              const _NavigationTabs(),
              OtpVerificationScreen(email: email),
              const MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationTabs extends StatelessWidget {
  const _NavigationTabs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              TextButton(
                onPressed: () {},
                child: const Text(
                  'For Individuals',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 254, 254, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 160,
                height: 3,
                color: const Color.fromARGB(255, 250, 250, 248),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submitOtp() async {
    final code = _otpControllers.map((controller) => controller.text).join();
    if (code.length != 6) {
      _showMessage('Please enter the full 6-digit code.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final success = await ref
          .read(authNotifierProvider.notifier)
          .verifyLoginOtp(widget.email, code);
      if (!mounted) return;
      if (success) {
        _showMessage('OTP verified successfully.');
        context.go('/profile');
      } else {
        _showMessage(
          ref.read(authNotifierProvider).errorMessage ??
              'OTP verification failed. Please try again.',
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

  Future<void> _resendOtp() async {
    if (_cooldown > 0) return;
    if (widget.email.trim().isEmpty) {
      _showMessage(
        'We could not find the email for this verification request.',
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authServiceProvider).resendOtp(widget.email);
      _showMessage('A new OTP has been sent.');
      _startCooldown(30);
    } catch (e) {
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
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_cooldown <= 1) {
        timer.cancel();
        setState(() => _cooldown = 0);
      } else {
        setState(() => _cooldown -= 1);
      }
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 700),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: _buildOtpFormSection(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 100,
                vertical: 100,
              ),
              padding: const EdgeInsets.all(32),
              // color: const Color.fromARGB(255, 243, 152, 33),
              child: _buildIllustrationSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'OTP Verification',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Please enter the OTP Code sent to ${widget.email}',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: _resendOtp,
          child: const Text(
            'Send to email address',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Verification Code',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (index) => _buildOtpBox(index)),
        ),
        const SizedBox(height: 32),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          runSpacing: 12,
          children: [
            ElevatedButton(
              onPressed: _isLoading ? null : _submitOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 16,
                ),
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
                        color: Color(0xFF1B1B52),
                      ),
                    )
                  : const Text(
                      'Submit',
                      style: TextStyle(
                        color: Color(0xFF1B1B52),
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Didn't receive OTP Code?",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 2),
                GestureDetector(
                  onTap: _cooldown == 0 ? _resendOtp : null,
                  child: Text(
                    _cooldown > 0 ? 'Resend Code ($_cooldown)' : 'Resend Code',
                    style: TextStyle(
                      color: _cooldown > 0 ? Colors.white54 : Colors.white,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: _cooldown > 0
                          ? Colors.white54
                          : Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 44,
      height: 48,
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        style: const TextStyle(color: Colors.white, fontSize: 18),
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white70, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.white, width: 2),
          ),
          filled: true,
          fillColor: Colors.transparent,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _buildIllustrationSection() {
    return Container(
      height: 260,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.blueAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('lib/assets/computer_login.png'),

                fit: BoxFit.fill,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
