import 'package:afara_project/features/landing/screen/widget.dart';
import 'package:flutter/material.dart';

class BusinessToConsumerFeatures extends StatelessWidget {
  const BusinessToConsumerFeatures({super.key});

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
                    text: "Business to Consumer ",
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
              "Our B2C Security Solutions secure customer identities while enabling seamless digital access and delivering secure authentication and fraud prevention across web and mobile platforms.",
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
              title: "OpenID Authentication",
              description:
                  "Secure customer sign-in for streamlined user login.",
              link: "Explore OpenID Authentication ➔",
            ),
            SizedBox(height: 40),
            FeatureItem(
              title: "Secure Account Access",
              description:
                  "Strong account protection with minimal user friction.",
              link: "Explore Account Access ➔",
            ),
          ],
        ),
      ),
    ];
  }
}
