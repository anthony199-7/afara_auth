import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Colors matching the design
    const Color buttonBlue = Color(0xFF1D5293);
    const Color buttonOutline = Color(0xFF3897F0);

    final bool isMobile = MediaQuery.of(context).size.width < 768;
    final bool isTablet = MediaQuery.of(context).size.width < 1024;

    final double heroHeight = isMobile ? 500 : (isTablet ? 600 : 722);

    return SizedBox(
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'lib/assets/images/background_image.png',
            fit: BoxFit.cover,
            width: double.infinity,
          ),

          // Content Overlay
          Align(
            alignment: isMobile ? Alignment.center : Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: isMobile
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.width * 0.52,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 40.0,
                vertical: isMobile ? 16.0 : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main Heading
                  Text(
                    'Your Gateway toTrusted\nand Secure Digital Access',
                    textAlign: isMobile ? TextAlign.center : TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : (isTablet ? 36 : 46),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sub-heading
                  Text(
                    'Protect your digital identity with enterprise grade\n security and seamless authentication',
                    textAlign: isMobile ? TextAlign.center : TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: isMobile ? 14 : (isTablet ? 16 : 18),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Primary Button (Filled)
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: isMobile ? double.infinity : 320,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/auth/individual/register');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                103,
                                1,
                                12,
                                77,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Sign Up for Personal Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: isMobile ? double.infinity : 320,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              context.go('/auth/individual/login');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.white),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            child: const Text(
                              'Get Started with Business Solutions',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Secondary Button (Outlined)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
