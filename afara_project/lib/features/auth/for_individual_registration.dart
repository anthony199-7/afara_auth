import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

class IndividualRegistration extends StatelessWidget {
  const IndividualRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff4c75a3), // Light steel blue top
              Color(0xff12235a), // Deep dark navy middle
              Color.fromARGB(255, 239, 239, 241), // Ultra dark blue bottom
            ],
          ),
        ),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              TopNavigation(),
              _NavigationTabs(), // Renamed to avoid conflict
              MainContentSection(),
              MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

// Renamed to avoid conflict with other files if they have a similar class name
class _NavigationTabs extends StatelessWidget {
  const _NavigationTabs();

  @override
  Widget build(BuildContext context) {
    // Since this is a business registration page, business is selected
    const bool isBusinessSelected = false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _navTab("For Individuals", !isBusinessSelected, () {
                context.go('/auth/individual/register');
              }),
              const SizedBox(width: 50),
              _navTab("For Businesses", isBusinessSelected, () {
                context.go('/auth/business/register');
              }),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(height: 1, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// --- 2. MAIN LAYOUT RESPONSE (SPLIT BLOCK GRID) ---
class MainContentSection extends StatelessWidget {
  const MainContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1100,
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FeatureMarketingList(),
                  const SizedBox(height: 50),
                  RegistrationCardForm(),
                ],
              );
            } else {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(flex: 11, child: FeatureMarketingList()),
                  SizedBox(width: 60),
                  Expanded(flex: 10, child: RegistrationCardForm()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

// Left side: Core propositions checklist
class FeatureMarketingList extends StatelessWidget {
  const FeatureMarketingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          'Start securing\nyour personal\naccounts for free',
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Easily integrate with all platforms',
          style: TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 40),
        _buildFeatureItem('OpenID authentication'),
        _buildFeatureItem('Connect services to your personal account'),
        _buildFeatureItem('Direct email support and enhanced privacy support'),
        _buildFeatureItem('Standard security features and activity monitoring'),
        _buildFeatureItem(
          'Secure account access to all connected applications',
        ),
        _buildFeatureItem('Multi-factor verification for extra security'),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check, color: Colors.white, size: 20),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.white12),
        ],
      ),
    );
  }
}

// Right side: Interactive onboarding form layout
class RegistrationCardForm extends StatelessWidget {
  RegistrationCardForm({super.key});

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Your Personal\nAccount Today',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Signed up already? ',
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              InkWell(
                onTap: () {},
                child: const Text(
                  'Log in here',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Form Row: First Name & Last Name
          Row(
            children: [
              Expanded(
                child: _buildLabelledTextField('First Name*', 'First Name'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLabelledTextField('Last Name*', 'Last Name'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Form Row: E-mail & Phone Number
          Row(
            children: [
              Expanded(
                child: _buildLabelledTextField(
                  'E-mail*',
                  'Email',
                  _emailController,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildLabelledTextField('Phone Number*', 'Phone Number'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dropdown: Country/Region
          const Text(
            'Country/Region*',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xff2b467d).withValues(alpha: 0.2),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white30),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            dropdownColor: const Color(0xff12235a),
            hint: const Text(
              'Select Country',
              style: TextStyle(color: Colors.white38, fontSize: 14),
            ),
            items:
                [
                      'United States',
                      'United Kingdom',
                      'Canada',
                      'Nigeria',
                      'Germany',
                    ]
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 32),

          // Submission Button
          SizedBox(
            width: 160,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(
                  'individual-password',
                  extra: {'email': _emailController.text, 'role': 'user'},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff12235a),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelledTextField(
    String label,
    String hint, [
    TextEditingController? controller,
  ]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label.replaceAll('*', ''),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            children: const [
              TextSpan(
                text: '*',
                style: TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Added controller to text field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
            filled: true,
            fillColor: const Color(0xff2b467d).withValues(alpha: 0.2),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white30),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _navTab(String label, bool isActive, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    hoverColor: Colors.transparent,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white70,
            fontSize: 22,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 4,
          width: isActive ? 140 : 0,
          decoration: BoxDecoration(
            color: const Color(0xFF191970),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ),
  );
}
