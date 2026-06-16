import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Brand colors derived from the design
    const Color primaryColor = Color(
      0xFF1E1F6B,
    ); // Dark blue for buttons and text

    final bool isMobile = MediaQuery.of(context).size.width < 768;
    final bool isTablet = MediaQuery.of(context).size.width < 1024;

    final double heroHeight = isMobile ? 500 : (isTablet ? 600 : 722);

    return SizedBox(
      // Responsive height for the hero section
      height: heroHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'lib/assets/images/Hero_img.png', // Your specified image path
            fit: BoxFit.cover, // Ensures the image covers the entire section
          ),

          // Content Overlay
          Align(
            alignment: isMobile ? Alignment.center : Alignment.centerRight,
            child: Container(
              // Restrict content width for better readability on wide screens
              constraints: BoxConstraints(
                maxWidth: isMobile
                    ? MediaQuery.of(context).size.width * 0.9
                    : MediaQuery.of(context).size.width * 0.5,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16.0 : 20.0,
                vertical: isMobile ? 16.0 : 0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Main Heading
                  Text(
                    'Your Gateway to Trusted and Secure Digital Access',
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isMobile ? 28 : (isTablet ? 36 : 48),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 1.40,
                      letterSpacing: -0.96,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sub-heading
                  Text(
                    'Protect your digital identity with enterprise grade security and seamless authentication',
                    textAlign: isMobile ? TextAlign.center : TextAlign.left,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: isMobile ? 16 : (isTablet ? 18 : 24),
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 1.40,
                      letterSpacing: -0.48,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Action Buttons
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Primary Button (Filled)
                        SizedBox(
                          width: isMobile ? double.infinity : 284,
                          height: 36,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle primary action (e.g., navigate to sign-up)
                              context.go("/auth/individual/register");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 20 : 40,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Sign Up for Personal Account',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isMobile ? 14 : 16,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -0.32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Secondary Button (Outlined)
                        SizedBox(
                          width: 284, // Fixed width for consistency
                          height: 36,
                          child: OutlinedButton(
                            onPressed: () {
                              context.go('/auth/business/register');
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                color: primaryColor,
                                width: 2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Get Started with Business Solutions',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF191970),
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                height: 1.40,
                                letterSpacing: -0.32,
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
          ),
        ],
      ),
    );
  }
}
