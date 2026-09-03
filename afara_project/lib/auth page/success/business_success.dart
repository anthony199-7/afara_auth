import 'package:afara_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';

class BusinessSuccessPage extends StatelessWidget {
  const BusinessSuccessPage({super.key});

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
              Color.fromARGB(255, 236, 237, 243), // Ultra dark blue bottom
            ],
          ),
        ),
        child: const SingleChildScrollView(
          child: Column(
            children: [
              TopNavigation(),
              NavigationTabHeader(),
              MainSuccessSection(),
              MainFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

//

// 2. FOR BUSINESSES PAGE INDICATOR
class NavigationTabHeader extends StatelessWidget {
  const NavigationTabHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppTheme.isMobile(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text(
            'For Businesses',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: isMobile ? 100 : 160,
            height: 3,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

// 3. RESPONSIVE MAIN SECTION
class MainSuccessSection extends StatelessWidget {
  const MainSuccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return const Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              children: [
                LeftNotificationCard(),
                SizedBox(height: 40),
                RightFeaturesContent(),
              ],
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 100, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: LeftNotificationCard()),
                SizedBox(width: 60),
                Expanded(flex: 5, child: RightFeaturesContent()),
              ],
            ),
          );
        }
      },
    );
  }
}

// Left side: Success / Check email notification card
class LeftNotificationCard extends StatelessWidget {
  const LeftNotificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Check Your Email',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Your Phone Number\nhas been verified!',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Check your email to set your\npassword and verify your account',
            style: TextStyle(fontSize: 15, color: Colors.white60, height: 1.4),
          ),
          SizedBox(
            height: 120,
          ), // Matches the tall aspect ratio of the image card
        ],
      ),
    );
  }
}

// Right side: Employee account creation & checkmarks
class RightFeaturesContent extends StatelessWidget {
  const RightFeaturesContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Employee\naccount creation\nwith Afara',
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xff1a237e),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Learn More',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const SizedBox(height: 40),
        _buildCheckmarkItem('Basic OpenID authentication'),
        _buildCheckmarkItem('Up to three connected services'),
        _buildCheckmarkItem('Direct email support'),
        _buildCheckmarkItem('Standard security features'),
        _buildCheckmarkItem('Single sign-in to all connected applications'),
        _buildCheckmarkItem('Multi-factor verification for extra security'),
      ],
    );
  }

  Widget _buildCheckmarkItem(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check, color: Colors.white70, size: 18),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }
}
