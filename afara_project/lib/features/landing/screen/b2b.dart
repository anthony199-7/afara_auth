import 'package:afara_project/features/landing/screen/widget.dart';
import 'package:flutter/material.dart';

class BusinessToBusinessFeatures extends StatelessWidget {
  const BusinessToBusinessFeatures({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 24 : 100, vertical: 60),
      child: isMobile
          ? Column(children: _buildContent())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _buildContent(),
            ),
    );
  }

  List<Widget> _buildContent() {
    return [
      Expanded(
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "Business to Business ",
                    style: TextStyle(
                        color: Color(0xFF191970),
                        fontSize: 36,
                        fontWeight: FontWeight.w300)),
                TextSpan(
                    text: "Security Solutions",
                    style: TextStyle(fontSize: 36)),
              ]),
            ),
            SizedBox(height: 20),
            Text(
              "Our B2B Security Solutions provide secure identity and access management for employees and partners, supporting SSO, MFA, and complex organizational structures.",
              style: TextStyle(fontSize: 18, height: 1.6),
            ),
          ],
        ),
      ),
      const SizedBox(width: 40),
      const Expanded(
        flex: 5,
        child: Column(
          children: [
            FeatureItem(
              title: "Single Sign-On",
              description:
                  "One login grants access to all connected applications.",
              link: "Explore Single Sign-On ➔",
            ),
            SizedBox(height: 40),
            FeatureItem(
              title: "Multi-Factor Authentication",
              description:
                  "Extra verification for stronger account security.",
              link: "Explore MFA ➔",
            ),
          ],
        ),
      ),
    ];
  }
}
