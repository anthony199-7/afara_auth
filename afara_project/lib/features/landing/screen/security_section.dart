import 'package:flutter/material.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          // MAIN TITLE
          const Text(
            "Security and Compliance",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1D2671), // Deep Navy
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Industry-leading certifications and protocols",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF333333),
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 64),

          // GRID OF CARDS
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Wrap(
              spacing: 20,
              runSpacing: 40,
              alignment: WrapAlignment.center,
              children: [
                _SecurityCard(
                  image: Image.asset('lib/assets/images/trophy.png'),
                  title: "ISO 27001\nCertified",
                  richDesc: const TextSpan(
                    text: "Certified to the ",
                    children: [
                      TextSpan(
                        text: "ISO 27001",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            " standard, our platform follows strict information security management practices to protect your data.",
                      ),
                    ],
                  ),
                  buttonText: "Read More",
                ),
                _SecurityCard(
                  image: Image.asset('lib/assets/images/padlock.png'),
                  title: "SOC 2\nCompliant",
                  richDesc: const TextSpan(
                    text: "",
                    children: [
                      TextSpan(
                        text: "SOC 2 Compliance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            " ensures our systems meet rigorous criteria for security, availability, and confidentiality.",
                      ),
                    ],
                  ),
                  buttonText: "Get Report",
                ),
                _SecurityCard(
                  image: Image.asset('lib/assets/images/padlock.png'),
                  title: "256-bit\nEncryption",
                  richDesc: const TextSpan(
                    text: "All data is secured with ",
                    children: [
                      TextSpan(
                        text: "256-bit Encryption",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            ", providing strong protection both in transit and at rest.",
                      ),
                    ],
                  ),
                  buttonText: "See How",
                ),
                _SecurityCard(
                  image: Image.asset('lib/assets/images/shield.png'),
                  title: "GDPR\nCompliant",
                  richDesc: const TextSpan(
                    text: "Our platform adheres to ",
                    children: [
                      TextSpan(
                        text: "GDPR Compliance",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text:
                            " requirements, safeguarding personal data and supporting user privacy rights.",
                      ),
                    ],
                  ),
                  buttonText: "Learn More",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  final Widget image;
  final String title;
  final TextSpan richDesc;
  final String buttonText;

  const _SecurityCard({
    required this.image,
    required this.title,
    required this.richDesc,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Column(
        children: [
          // THE WHITE BOX (Contains Image and Title)
          Container(
            height: 250,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Center(child: image)),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF444444),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // DESCRIPTION (Outside the box)
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF666666),
                height: 1.5,
              ),
              children: [richDesc],
            ),
          ),

          const SizedBox(height: 20),

          // ACTION BUTTON
          // ACTION BUTTON (FIXED)
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(
              4,
            ), // Prevents square splash on corners
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ), // Binds splash area
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Constrains Row size to content
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    buttonText,
                    style: const TextStyle(
                      color: Color(0xFF4A90E2),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Color(0xFF4A90E2),
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
