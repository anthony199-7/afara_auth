import 'package:afara_project/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class IndividualPricing extends StatelessWidget {
  const IndividualPricing({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3873AF),
            Color(0xFFCBEDFB), // #CBEDFB at 50%
            Color(0xFFFFFFFF), // #FFFFFF at 0%/ Pure white backdrop core
          ],
        ),
      ),
      child: const SingleChildScrollView(
        child: Column(
          children: [
            // TopNavigation(),
            NavigationTabs(),

            PricingMatrixHeader(),
            SizedBox(height: 20),
            PricingCardsSection(),
            SizedBox(height: 80),
            SupportCTASection(),
            SizedBox(height: 60),
            FaqAndAppSection(),
            SizedBox(height: 60),
            // MainFooter(),
          ],
        ),
      ),
    );
  }
}

class NavigationTabs extends StatelessWidget {
  const NavigationTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = AppTheme.isMobile(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              TextButton(
                onPressed: () => context.go('/pricing/individual'),
                child: const Text(
                  'For Individuals',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: isMobile ? 100 : 160,
                height: 3,
                color: const Color.fromARGB(255, 29, 20, 83),
              ),
            ],
          ),

          const SizedBox(width: 40),
          TextButton(
            onPressed: () => context.go('/pricing/business'),
            child: const Text(
              'For Businesses',
              style: TextStyle(color: Colors.white70, fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

// --- 2. PRICING HERO SEGMENT ---
class PricingMatrixHeader extends StatelessWidget {
  const PricingMatrixHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Find your perfect plan',

          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: Color(0xff12235a),
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Protect your online identity and enhance your personal security',

          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

class PricingCardsSection extends StatelessWidget {
  const PricingCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppTheme.responsivePageWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildPricingCard(
                        title: 'Free',
                        price: '\$0',
                        features: const [
                          'Basic OpenID authentication',
                          'Up to 3 connected service accounts',
                          'Email support agent',
                          'Standard security elements',
                        ],
                        isPremium: false,
                        buttonText: 'Get Started',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildPricingCard(
                        title: 'Premium',
                        price: '\$8',
                        features: const [
                          'Advanced MFA options',
                          'Unlimited enterprise services',
                          'Behavioral analytics metrics',
                          'Activity monitoring log',
                        ],
                        isPremium: false,
                        buttonText: 'Upgrade Now',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required List<String> features,
    required bool isPremium,
    required String buttonText,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPremium ? const Color(0xff3b82f6) : Colors.black12,
              width: isPremium ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              if (isPremium)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Text(
                    price,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff0f172a),
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff0f172a),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      '/month',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              const SizedBox(height: 24),
              ...features.map(
                (feat) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check,
                        size: 15,
                        color: Color(0xff2563eb),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          feat,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: isPremium
                    ? OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xff2563eb)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Color(0xff2563eb),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2563eb),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        child: Text(
                          buttonText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              if (isPremium) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: () {},
                  child: const Text(
                    'Contact sales for customized plans',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (isPremium)
          Positioned(
            top: -14,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffeff6ff),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Popular',
                  style: TextStyle(
                    color: Color(0xff2563eb),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// --- 3. DIAGONAL CUT SUPPORT CTA SECTION ---
class SupportCTASection extends StatelessWidget {
  const SupportCTASection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppTheme.responsivePageWidth(context),
        height: AppTheme.isMobile(context) ? null : 408,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            /* BoxShadow(
              color: Colors.black,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),*/
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 700;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              children: [
                Expanded(
                  flex: isWide ? 5 : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Not sure which plan is\nright for you?',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff1e3a8a),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Our expert team is ready to help you implement the perfect identity solution.',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xff1e3a8a),
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 49,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Contact Support',
                            style: TextStyle(
                              color: Color(0xff1e3a8a),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: isWide ? 5 : 0,
                  child: Container(
                    height: isWide ? 280 : 280,
                    width: double.infinity,
                    color: Colors.white,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Safe placeholder representation of the operational portrait image inside image_e882e9.png
                        Container(
                          color: const Color(0xff224a7d).withValues(alpha: 0.1),
                          child: Image.asset(
                            'lib/assets/images/individual_pricig.png',

                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isWide)
                          Positioned(
                            //left: -1,
                            top: 0,
                            bottom: 0,
                            child: CustomPaint(
                              size: const Size(40, 300),
                              painter: DiagonalCutPainter(),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class DiagonalCutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// --- 4. FAQ BLOCK & MOBILE APP ADVERTISEMENT ROW ---
class FaqAndAppSection extends StatelessWidget {
  const FaqAndAppSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppTheme.responsivePageWidth(context),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isWide = constraints.maxWidth > 800;
            return Flex(
              direction: isWide ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: isWide ? 6 : 0, child: const FaqBlock()),
                SizedBox(width: isWide ? 50 : 0, height: isWide ? 0 : 50),
                Expanded(flex: isWide ? 4 : 0, child: const MobileAppAdCard()),
              ],
            );
          },
        ),
      ),
    );
  }
}

class FaqBlock extends StatelessWidget {
  const FaqBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xff12235a),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Quick answers to common questions',
          style: TextStyle(color: Colors.black, fontSize: 15),
        ),
        const SizedBox(height: 32),
        Container(height: 1, color: Colors.black12),
        const SizedBox(height: 8),
        _buildFaqItem('How do I set up my personal Afara account?', true),
        _buildFaqItem('How do I set up my personal Afara account?', true),
        _buildFaqItem('How do I set up my personal Afara account?', true),
      ],
    );
  }

  Widget _buildFaqItem(String question, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                question,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Color(0xff1e3a8a),
                ),
              ),
              Icon(
                isExpanded ? Icons.remove : Icons.add,
                size: 16,
                color: Colors.black45,
              ),
            ],
          ),
          if (isExpanded) ...[
            const SizedBox(height: 10),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi nec tusnon metes pretium ullamcorper. Maecenas cursus neque sapien, et feugiat justo sceler.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                height: 1.4,
                letterSpacing: 0.1,
              ),
            ),
          ],
          const SizedBox(height: 14),
          const Divider(color: Colors.black12, height: 1),
        ],
      ),
    );
  }
}

class MobileAppAdCard extends StatelessWidget {
  const MobileAppAdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: const Color(0xffe0f2fe).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MOBILE APP',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Color(0xff0284c7),
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Protection you can count on',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xff1e3a8a),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Fast and simple—get the utmost convenience with our secure app',
            style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Download the Afara secure app.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                _buildMockStoreButton(
                  Icons.apple,
                  'Download on the',
                  'App Store',
                ),
                const SizedBox(height: 10),
                _buildMockStoreButton(
                  Icons.play_arrow,
                  'GET IT ON',
                  'Google Play',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockStoreButton(IconData icon, String subtitle, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white60, fontSize: 9),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
