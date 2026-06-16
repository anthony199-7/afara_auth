import 'package:flutter/material.dart';

class EducationalResourcesSection extends StatelessWidget {
  const EducationalResourcesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1232),
          decoration: BoxDecoration(
            color: const Color(0xFF3873AF),
            borderRadius: BorderRadius.circular(25),
          ),
          child: isMobile ? _mobileLayout() : _desktopLayout(),
        ),
      ),
    );
  }

  /// DESKTOP
  Widget _desktopLayout() {
    return Row(
      children: [
        /// LEFT CONTENT
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 70),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "OUR EDUCATIONAL RESOURCES",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  "Comprehensive guides, tools, and support to help you maximize your identity security and get the most out of Afara",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w300,
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 40),

                /// BUTTON 1
                _whiteButton("Frequently Asked Questions"),

                const SizedBox(height: 20),

                /// BUTTON 2
                _outlineButton("Resources Hub"),
              ],
            ),
          ),
        ),

        /// RIGHT IMAGE
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Image.asset(
              "lib/assets/images/source_image.png",
              height: 600,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  /// MOBILE
  Widget _mobileLayout() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: Image.asset(
            "lib/assets/images/source_image.png",
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const Text(
                "OUR EDUCATIONAL RESOURCES",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Comprehensive guides, tools, and support to help you maximize your identity security and get the most out of Afara",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 30),
              _whiteButton("Frequently Asked Questions"),
              const SizedBox(height: 16),
              _outlineButton("Resources Hub"),
            ],
          ),
        ),
      ],
    );
  }

  Widget _whiteButton(String text) {
    return Container(
      height: 60,
      width: 320,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF191970),
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _outlineButton(String text) {
    return Container(
      height: 60,
      width: 320,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }
}
