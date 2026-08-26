import 'package:afara_project/core/api_client.dart';
import 'package:afara_project/features/auth/auth_service.dart';
import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
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
              Color.fromARGB(255, 230, 231, 235), // Ultra dark blue bottom
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const TopNavigation(),
              const _NavigationTabs(),
              MainVerificationSection(email: email),
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
      padding: const EdgeInsets.symmetric(vertical: 40),
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
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Container(width: 160, height: 3, color: Colors.white),
            ],
          ),
          const SizedBox(width: 40),
          TextButton(
            onPressed: () {},
            child: const Text(
              'For Businesses',
              style: TextStyle(color: Colors.white60, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. MAIN CONTENT RESPONSE LAYOUT ---
class MainVerificationSection extends StatelessWidget {
  final String email;

  const MainVerificationSection({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1000,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VerificationInputCard(email: email),
                  const SizedBox(height: 50),
                  const SecurityIllustration(),
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
                  const Expanded(flex: 9, child: SecurityIllustration()),
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

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _submitOtp() async {
    final code = _controllers.map((c) => c.text).join();
    if (code.length != 6) {
      _showMessage('Please enter the full 6-digit code.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final authService = AuthService(ApiClient());
      await authService.verifyOtp(widget.email, code);
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

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24, width: 1),
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
          const SizedBox(height: 12),
          Text(
            'Please enter the verification code\nsent to ${widget.email}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
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
          const SizedBox(height: 36),
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

// Right Identity Illustration Simulation Component
class SecurityIllustration extends StatelessWidget {
  const SecurityIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 320,
        width: double.infinity,
        margin: null,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Bottom floor shadow oval representation
            Positioned(
              bottom: 0,
              child: Container(
                width: 280,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  borderRadius: const BorderRadius.all(
                    Radius.elliptical(280, 18),
                  ),
                ),
              ),
            ),
            // Floating UI Mock Interface Card
            Positioned(
              left: 20,
              bottom: 40,
              child: Container(
                width: 140,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xff578ef7),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 10),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: Image(
                        image: AssetImage(
                          'assets/verification_illustration.png',
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(width: 80, height: 8, color: Colors.white70),
                    const SizedBox(height: 8),
                    Container(
                      width: 80,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.lock_open,
                        color: Color(0xff578ef7),
                        size: 16,
                      ),
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
