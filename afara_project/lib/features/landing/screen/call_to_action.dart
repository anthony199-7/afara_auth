import 'package:flutter/material.dart';

class CallToActionSection extends StatelessWidget {
  const CallToActionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE6EEF6), Color(0xFF3E6EA5), Color(0xFF1C1F7A)],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// TITLE
              Text(
                "Ready to Secure Your\nDigital Identity?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width < 800 ? 34 : 52,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              /// SUBTITLE
              Text(
                "Join thousands who trust Afara for their\nauthentication needs",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: width < 800 ? 16 : 22,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 40),

              /// OUTLINE BUTTON
              _outlineButton(),

              const SizedBox(height: 18),

              /// FILLED BUTTON
              _filledButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _outlineButton() {
    return Container(
      width: 320,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Text(
        "Secure Your Online Identity Today",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _filledButton() {
    return Container(
      width: 320,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: const Text(
        "Empower Your Enterprise with Afara",
        style: TextStyle(color: Color(0xFF1C1F7A), fontWeight: FontWeight.w600),
      ),
    );
  }
}
