import 'package:flutter/material.dart';

class HowItWorksDemoSection extends StatelessWidget {
  const HowItWorksDemoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 1000;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 80,
        vertical: 60,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isMobile ? const _MobileLayout() : const _DesktopLayout(),
        ),
      ),
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Makes bothHowItWorksDemoSection
        children: [
          // LEFT COLUMN
          Expanded(
            child: Column(
              children: const [
                HowItWorksCard(
                  category: "HOW IT WORKS FOR INDIVIDUALS",
                  bgColor: Color(0xFFD6F1FF),
                ),
                SizedBox(height: 24),
                HowItWorksCard(
                  category: "HOW IT WORKS FOR BUSINESSES",
                  bgColor: Color(0xFFD6F1FF),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // RIGHT COLUMN
          Expanded(child: ServiceDemoCard()),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        HowItWorksCard(
          category: "HOW IT WORKS FOR INDIVIDUALS",
          bgColor: Color(0xFFD6F1FF),
        ),
        SizedBox(height: 24),
        HowItWorksCard(
          category: "HOW IT WORKS FOR BUSINESSES",
          bgColor: Color(0xFFD6F1FF),
        ),
        SizedBox(height: 24),
        ServiceDemoCard(),
      ],
    );
  }
}

class HowItWorksCard extends StatelessWidget {
  final String category;
  final Color bgColor;

  const HowItWorksCard({
    super.key,
    required this.category,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 12,
              letterSpacing: 0.5,
              color: Color(0xFF3A74B0),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Simple steps to secure\ndigital access",
            style: TextStyle(
              fontSize: 32,
              height: 1.1,
              fontWeight: FontWeight.w500,
              color: Color(0xFF192370),
            ),
          ),
          const SizedBox(height: 32),
          _buildStep(
            1,
            "Quick Registration",
            "Sign up with email and mobile verification",
          ),
          _buildStep(
            2,
            "Secure Your Profile",
            "Set up optional MFA for enhanced security",
          ),
          _buildStep(
            3,
            "Connect Platforms",
            "Use OpenID Connect for seamless third-party access",
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF3A74B0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                "$number",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceDemoCard extends StatelessWidget {
  const ServiceDemoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF88B2D7),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias, // Ensures image corners are rounded
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // IMAGE TOP HALF
          Expanded(
            flex: 6,
            child: Image.asset(
              "lib/assets/images/image2.png",
              fit: BoxFit.cover,
            ),
          ),
          // INFO BOTTOM HALF
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "SERVICE DEMONSTRATION",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Try out our Afara\nservice for yourself",
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.1,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF192370),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Experience our platform firsthand with a guided product demo that showcases how easy and secure identity management can be.",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF131163),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        "Open Now",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Learn More",
                        style: TextStyle(
                          color: Color(0xFF131163),
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
