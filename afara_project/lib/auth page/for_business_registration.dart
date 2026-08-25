import 'package:afara_project/core/theme/app_theme.dart';

import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class BusinessRegistrationPage1 extends StatelessWidget {
  const BusinessRegistrationPage1({super.key});

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
              Color.fromARGB(255, 251, 251, 253), // Ultra dark blue bottom
            ],
          ),
        ),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              TopNavigation(),
              _NavigationTabs(),
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
    const bool isBusinessSelected = true;

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

// 3. MAIN SPLIT CONTENT SECTION (RESPONSIVE)
class MainContentSection extends StatelessWidget {
  const MainContentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppTheme.isMobile(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen width is small (Mobile/Tablet), stack columns vertically. Otherwise, place side-by-side.
        if (constraints.maxWidth < 900) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const LeftFeatureContent(),
                const SizedBox(height: 40),
                RightFormCard(),
              ],
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 100,
              vertical: 40,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 5, child: LeftFeatureContent()),
                const SizedBox(width: 60),
                Expanded(flex: 5, child: RightFormCard()),
              ],
            ),
          );
        }
      },
    );
  }
}

// Left side: Text features list
class LeftFeatureContent extends StatelessWidget {
  const LeftFeatureContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Start securing\nyour business\norganization',
          style: TextStyle(
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.bold,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Easily integrate with all platforms',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 40),
        _buildFeatureItem('Basic OpenID authentication'),
        _buildFeatureItem('Up to three connected services'),
        _buildFeatureItem('Direct email support'),
        _buildFeatureItem('Standard security features'),
        _buildFeatureItem('Single sign-in to all connected applications'),
        _buildFeatureItem('Multi-factor verification for extra security'),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.white, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

// Right side: Registration form container
class RightFormCard extends StatelessWidget {
  RightFormCard({super.key});
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Start Your Free\nBusiness Trial Today',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Signed up already? ',
                  style: TextStyle(color: Colors.white, fontSize: 13),
                ),
                InkWell(
                  onTap: () {
                    context.go('/auth/business/login');
                  },
                  child: const Text(
                    'Log In here',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'First Name*',
                    'First Name',
                    _firstNameController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Last Name*',
                    'Last Name',
                    _lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField('E-mail*', 'Email', _emailController),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Phone Number*',
                    'Phone Number',
                    TextEditingController(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdownField('Country/Region*'),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 6,
                  child: _buildTextField(
                    'Domain*',
                    'Organization',
                    TextEditingController(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 4,
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed(
                        'business-password',
                        extra: {
                          'email': _emailController.text,
                          'role': 'admin',
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        // Added controller to text field
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white, fontSize: 14),
            filled: true,
            fillColor: const Color(0xff2b467d).withValues(alpha: 0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xff2b467d).withValues(alpha: 0.4),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),
          hint: const Text(
            'Select Country',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          items: ['United States', 'United Kingdom', 'Nigeria', 'Canada']
              .map(
                (label) => DropdownMenuItem(value: label, child: Text(label)),
              )
              .toList(),
          onChanged: (value) {},
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
            color: isActive ? Colors.white : Colors.white,
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
            color: const Color.fromARGB(255, 252, 252, 253),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    ),
  );
}
