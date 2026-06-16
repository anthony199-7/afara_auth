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
        child: const SingleChildScrollView(
          child: Column(
            children: [
              TopNavigation(),
              _NavigationTabs(), // Renamed to avoid conflict
              MainVerificationSection(),
              MainFooter(),
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
  const MainVerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1000,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  VerificationInputCard(),
                  SizedBox(height: 50),
                  SecurityIllustration(),
                ],
              );
            } else {
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 11, child: VerificationInputCard()),
                  SizedBox(width: 40),
                  Expanded(flex: 9, child: SecurityIllustration()),
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
class VerificationInputCard extends StatelessWidget {
  const VerificationInputCard({super.key});

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
          const Text(
            'Please enter the verification code\nsent to (xxx)-xxx-xx91',
            style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
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

          // 6-Digit input segment matching image_0edda2.png
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (index) => _buildOtpField(context, index),
            ),
          ),
          const SizedBox(height: 36),

          // Submission Action Button
          SizedBox(
            width: 140,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(
                  'individual-login',
                ); // Assuming login after verification
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
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

  Widget _buildOtpField(BuildContext context, int index) {
    return SizedBox(
      width: 44,
      height: 52,
      child: TextFormField(
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
            FocusScope.of(context).nextFocus();
          }
          if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
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
            // Standalone Person Vector Simulation
            Positioned(
              right: 40,
              bottom: 12,
              child: Column(
                children: [
                  // Floating Thought Bubble Key
                  Transform.translate(
                    offset: const Offset(-20, -10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xff3b82f6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.vpn_key,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.accessibility_new,
                    size: 160,
                    color: Color(0xff3b82f6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
