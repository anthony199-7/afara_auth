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
              Color.fromARGB(255, 232, 232, 236), // Ultra dark blue bottom
            ],
          ),
        ),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              TopNavigation(),
              NavigationTabHeader(),
              MainVerificationSection(),
              MainFooter(),
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
      padding: const EdgeInsets.symmetric(vertical: 40),
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
          Container(width: 160, height: 3, color: Colors.white),
        ],
      ),
    );
  }
}

class MainVerificationSection extends StatelessWidget {
  const MainVerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 1000) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                LeftVerifyCard(),
                SizedBox(height: 40),
                RightVectorGraphic(),
              ],
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 5, child: LeftVerifyCard()),
                SizedBox(width: 40),
                Expanded(flex: 5, child: RightVectorGraphic()),
              ],
            ),
          );
        }
      },
    );
  }
}

// 6-Digit OTP Form Interface
class LeftVerifyCard extends StatelessWidget {
  const LeftVerifyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(130),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Verify Your Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Please enter the verification code\nsent to (xxx)-xxx-xx91',
            style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
          ),
          const SizedBox(height: 32),
          const Text(
            'Verification Code',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Row containing 6 standalone character boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (index) => _buildOtpBox(context, index == 0),
            ),
          ),

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              // For demo purposes, we directly navigate to the success page.
              // In a real app, you would validate the OTP before navigating, potentially using the email.
              context.goNamed('business-success');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBox(BuildContext context, bool first) {
    return SizedBox(
      width: 48,
      height: 48,
      child: TextFormField(
        autofocus: first,
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // Auto moves cursor to next box
          }
          if (value.isEmpty) {
            FocusScope.of(
              context,
            ).previousFocus(); // Backspace moves cursor back
          }
        },
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xff2b467d).withValues(alpha: 0.3),
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.white30),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
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
            Image.asset('assets/verification_illustration.png'),
            Opacity(
              opacity: 0.85,
              child: Container(
                padding: const EdgeInsets.all(24),
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
