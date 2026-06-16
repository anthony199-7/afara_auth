import 'package:flutter/material.dart';

class ComprehensiveIdentitySolutions extends StatelessWidget {
  const ComprehensiveIdentitySolutions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Global Header section from image_0e7197.png
          Text(
            'HOW WE HELP',
            style: TextStyle(
              color: Color(0xff2563eb),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Comprehensive Identity Solutions',
            style: TextStyle(
              color: Color(0xff1e1b4b),
              fontWeight: FontWeight.w800,
              fontSize: 42,
              letterSpacing: -0.5,
              fontFamily: 'Inter',
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Secure authentication for individuals and businesses',
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 60),

          // SECTION 1: B2C Solutions (image_0e7197.png)
          SolutionsSection(
            title: 'Business to Consumer\nSecurity Solutions',
            description:
                'Our B2C Security Solutions secure customer identities while enabling seamless digital access and delivering secure authentication and fraud prevention across web and mobile platforms.',
            actionButtonText: 'Individual Pricing Plans',
            features: [
              FeatureItemData(
                title: 'OpenID Authentication',
                subtitle: 'Secure customer sign-in for streamlined user login.',
                linkText: 'Explore OpenID Authentication',
                image: Image.asset(
                  'lib/assets/images/OpenID Authentication.png',
                ),
              ),
              FeatureItemData(
                title: 'Secure Account Access',
                subtitle:
                    'Strong account protection with minimal user friction.',
                linkText: 'Explore Account Access',
                image: Image.asset(
                  'lib/assets/images/Secure Account Access.png',
                ),
              ),
              FeatureItemData(
                title: 'Third-Party Platform\nCompatibility',
                subtitle: 'Easy integration with external platforms and apps.',
                linkText: 'Explore Platform Compatabillty',
                image: Image.asset(
                  'lib/assets/images/Third-Party Platform Compatibility.png',
                ),
              ),
            ],
          ),

          SizedBox(height: 80),
          Divider(color: Colors.black12, height: 1),
          SizedBox(height: 80),

          // SECTION 2: B2B Solutions (image_0e70e0.png)
          SolutionsSection(
            title: 'Business to Business\nSecurity Solutions',
            description:
                'Our B2B Security Solutions provide secure identity and access management for employees and partners, supporting SSO, MFA, and complex organizational structures to ensure trusted access while reducing administrative overhead.',
            actionButtonText: 'Business Pricing Plans',
            features: [
              FeatureItemData(
                title: 'Single Sign-On',
                subtitle:
                    'One login grants access to all connected applications.',
                linkText: 'Explore Single Sign-On',
                image: Image.asset('lib/assets/images/Single Sign-On.png'),
              ),
              FeatureItemData(
                title: 'Multi-Factor Authentication',
                subtitle: 'Extra verification for stronger account security.',
                linkText: 'Explore Account Access',
                image: Image.asset(
                  'lib/assets/images/multi-Factor Authenticatio.png',
                ),
              ),
              FeatureItemData(
                title: 'Multi-Tenant Secure\nToken Services',
                subtitle: 'Safely manage tokens across multiple organizations.',
                linkText: 'Explore Platform Compatabillty',
                image: Image.asset('lib/assets/images/image_0e70e0.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- REUSABLE FLEXIBLE COMPONENT GRID ---
class SolutionsSection extends StatelessWidget {
  final String title;
  final String description;
  final String actionButtonText;
  final List<FeatureItemData> features;

  const SolutionsSection({
    super.key,
    required this.title,
    required this.description,
    required this.actionButtonText,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 900;

        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left intro pillar block
            SizedBox(
              width: isMobile ? double.infinity : 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xff1e1b4b),
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile) const SizedBox(width: 40),
            if (isMobile) const SizedBox(height: 40),

            // Middle features block + right-most content segment combined
            Expanded(
              flex: isMobile ? 0 : 1,
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dual Sub-Feature List Column
                  Expanded(
                    flex: isMobile ? 0 : 5,
                    child: Column(
                      children: [
                        _buildFeatureRow(features[0]),
                        const SizedBox(height: 32),
                        if (features.length > 1) _buildFeatureRow(features[1]),
                      ],
                    ),
                  ),
                  if (!isMobile) const SizedBox(width: 40),
                  if (isMobile) const SizedBox(height: 32),

                  // Right Column: Third Feature Box & Interactive Pricing Trigger
                  Expanded(
                    flex: isMobile ? 0 : 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (features.length > 2) _buildFeatureRow(features[2]),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff3b71ca),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(220, 48),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            actionButtonText,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFeatureRow(FeatureItemData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Illustration
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: data.image,
          ),
        ),
        const SizedBox(width: 16),
        // Explanatory Text Content Block
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: const TextStyle(
                  color: Color(0xff3b71ca),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                data.subtitle,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.linkText,
                      style: const TextStyle(
                        color: Color(0xff3b71ca),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Color(0xff3b71ca),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Data Model to carry values safely across configurations
class FeatureItemData {
  final String title;
  final String subtitle;
  final String linkText;
  final Widget image;

  const FeatureItemData({
    required this.title,
    required this.subtitle,
    required this.linkText,
    required this.image,
  });
}
