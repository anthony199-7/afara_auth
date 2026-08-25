import 'package:flutter/material.dart';

/// The Main Footer Navigation
class MainFooter extends StatelessWidget {
  const MainFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = MediaQuery.of(context).size.width < 900
        ? 20
        : 100;
    final double verticalPadding = MediaQuery.of(context).size.width < 900
        ? 40
        : 80;

    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return Container(
      color: const Color(0xFF191970),
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        //horizontal: horizontalPadding,
      ),
      child: Column(
        children: [
          Wrap(
            // Wrap ensures it looks good on mobile by stacking columns
            spacing: 80,
            runSpacing: 40,
            alignment: WrapAlignment.spaceBetween,
            children: [
              // Brand & Newsletter Section
              SizedBox(
                width: isMobile ? screenWidth * 0.9 : 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AFARA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -1.28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Stay Connected',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Row(
                      children: [
                        SocialIcon(),
                        SocialIcon(),
                        SocialIcon(),
                        SocialIcon(),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const NewsletterSignup(),
                  ],
                ),
              ),

              // Links Columns
              const FooterColumn(
                title: 'Starting with Afara',
                links: ['About Afara', 'Pricing', 'Live Demo', 'Free Trial'],
              ),
              const FooterColumn(
                title: 'Help and Support',
                links: ['Help and Support', 'Contact Us', 'Learning Resources'],
              ),
              const FooterColumn(
                title: 'Quick Links',
                links: ['About Us', 'Privacy Policy', 'Terms of Service'],
              ),
            ],
          ),
          const Divider(color: Colors.white24, height: 100),
          const Text(
            '© 2026 Obiveri Limited. All rights reserved.\nAfara - Your trusted identity verification partner',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }
}

/// Reusable Widget for Footer Link Groups
class FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const FooterColumn({super.key, required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              link,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}

class SocialIcon extends StatelessWidget {
  const SocialIcon({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        color: Color(0xFF737373),
        shape: BoxShape.circle,
      ),
    );
  }
}

class NewsletterSignup extends StatelessWidget {
  const NewsletterSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Enter your email',
            filled: true,
            fillColor: const Color(0xFFB4B4B4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
            onPressed: () {},
            child: const Text('Subscribe to Newsletter'),
          ),
        ),
      ],
    );
  }
}
