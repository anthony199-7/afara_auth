import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BusinessPricingPage extends StatelessWidget {
  const BusinessPricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF3873AF),
                    Color(0xFFCBEDFB), // #CBEDFB at 50%
                    Color(
                      0xFFFFFFFF,
                    ), // #FFFFFF at 0%// Pure white backdrop core
                  ],
                ),
              ),
              child: const SingleChildScrollView(
                child: Column(
                  children: [
                    TopNavigation(),
                    NavigationTabs(),
                    PricingHeroHeader(),
                    PricingMatrixGrid(),
                    SupportBannerSection(),
                    FAQAndMobilePromoSection(),
                    MainFooter(),
                  ],
                ),
              ),
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () => context.go('/pricing/individual'),
            child: const Text(
              'For Individuals',
              style: TextStyle(color: Colors.white70, fontSize: 24),
            ),
          ),
          const SizedBox(width: 40),
          Column(
            children: [
              TextButton(
                onPressed: () => context.go('/pricing/business'),
                child: const Text(
                  'For Businesses',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 160,
                height: 3,
                color: const Color.fromARGB(255, 29, 20, 83),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// --- 2. PRICING HERO SECTION ---
class PricingHeroHeader extends StatelessWidget {
  const PricingHeroHeader({super.key});

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
          'Secure your business organization and employee accounts',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}

// --- 3. THREE-COLUMN PRICING MATRIX ---
class PricingMatrixGrid extends StatelessWidget {
  const PricingMatrixGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1100,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return const Column(
                children: [
                  PricingCard(
                    tier: 'Company',
                    price: '\$12',
                    features: [
                      'Multi-tenant documentation',
                      'Multi-factor authentication',
                      'Step Sign-In',
                      'Behavior Risk management',
                    ],
                    buttonText: 'Sign Up',
                  ),
                  SizedBox(height: 40),
                  PricingCard(
                    tier: 'Organization',
                    price: '\$35',
                    isPopular: true,
                    features: [
                      'Multi-tenant documentation',
                      'Multi-factor authentication',
                      'Step Sign-In',
                      'Behavior Risk management',
                    ],
                    buttonText: 'Sign Up',
                    hasContactLink: true,
                  ),
                  SizedBox(height: 40),
                  PricingCard(
                    tier: 'Enterprise',
                    price: 'Custom',
                    isEnterprise: true,
                    features: [
                      'Multi-tenant documentation',
                      'Multi-factor authentication',
                      'Step Sign-In',
                      'Behavior Risk management',
                    ],
                    buttonText: 'Request a Quote',
                  ),
                ],
              );
            } else {
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PricingCard(
                      tier: 'Company',
                      price: '\$12',
                      features: [
                        'Multi-tenant documentation',
                        'Multi-factor authentication',
                        'Step Sign-In',
                        'Behavior Risk management',
                      ],
                      buttonText: 'Sign Up',
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: PricingCard(
                      tier: 'Organization',
                      price: '\$35',
                      isPopular: true,
                      features: [
                        'Multi-tenant documentation',
                        'Multi-factor authentication',
                        'Step Sign-In',
                        'Behavior Risk management',
                      ],
                      buttonText: 'Sign Up',
                      hasContactLink: true,
                    ),
                  ),
                  SizedBox(width: 24),
                  Expanded(
                    child: PricingCard(
                      tier: 'Enterprise',
                      price: 'Custom',
                      isEnterprise: true,
                      features: [
                        'Multi-tenant documentation',
                        'Multi-factor authentication',
                        'Step Sign-In',
                        'Behavior Risk management',
                      ],
                      buttonText: 'Request a Quote',
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String tier;
  final String price;
  final List<String> features;
  final String buttonText;
  final bool isPopular;
  final bool isEnterprise;
  final bool hasContactLink;

  const PricingCard({
    super.key,
    required this.tier,
    required this.price,
    required this.features,
    required this.buttonText,
    this.isPopular = false,
    this.isEnterprise = false,
    this.hasContactLink = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(32, 40, 32, 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isPopular ? const Color(0xff3b82f6) : Colors.black12,
              width: isPopular ? 2 : 1,
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
                tier,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              if (isEnterprise)
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
                child: isEnterprise
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
              if (hasContactLink) ...[
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
        if (isPopular)
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

// --- 4. CONSULTATION & SUPPORT ASSISTANCE BANNER ---
class SupportBannerSection extends StatelessWidget {
  const SupportBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1050,
        margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 750) {
                return Column(children: _buildBannerContents(isColumn: true));
              } else {
                return Row(children: _buildBannerContents(isColumn: false));
              }
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBannerContents({required bool isColumn}) {
    final textWidget = Expanded(
      flex: isColumn ? 0 : 5,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Not sure which plan is\nright for you?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xff1e3a8a),
                height: 1.2,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Our expert team is ready to help you\nimplement the perfect identity solution.',
              style: TextStyle(fontSize: 14, color: Colors.black, height: 1.4),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xff1e3a8a), width: 1.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
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
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final imageWidget = Expanded(
      flex: isColumn ? 0 : 5,
      child: Container(
        height: isColumn ? 220 : 260,
        width: isColumn ? double.infinity : null,
        color: Colors
            .grey[300], // Background simulation block matching team meeting from image_e4a243.png
        child: const Stack(
          fit: StackFit.expand,
          children: [
            Image(
              image: AssetImage('lib/assets/images/business_pricing.png'),
              fit: BoxFit.cover,
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black12, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return isColumn ? [imageWidget, textWidget] : [textWidget, imageWidget];
  }
}

// --- 5. DETAILED FAQ & MOBILE APP DOWNLOAD SECTION ---
class FAQAndMobilePromoSection extends StatelessWidget {
  const FAQAndMobilePromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 1050,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        margin: const EdgeInsets.only(bottom: 60),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 850) {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FAQColumnModule(),
                  SizedBox(height: 60),
                  MobilePromoCardModule(),
                ],
              );
            } else {
              return const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 11, child: FAQColumnModule()),
                  SizedBox(width: 40),
                  Expanded(flex: 9, child: MobilePromoCardModule()),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class FAQColumnModule extends StatelessWidget {
  const FAQColumnModule({super.key});

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
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(height: 32),
        _buildAccordionItem('How do I set up my personal Afara account?', true),
        _buildAccordionItem('How do I set up my personal Afara account?', true),
        _buildAccordionItem('How do I set up my personal Afara account?', true),
      ],
    );
  }

  Widget _buildAccordionItem(String title, bool isExpanded) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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

class MobilePromoCardModule extends StatelessWidget {
  const MobilePromoCardModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Protection you can\ncount on',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xff1e3a8a),
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Fast and simple; get the utmost\nconvenience with our secure app.',
            style: TextStyle(fontSize: 14, color: Colors.black, height: 1.4),
          ),
          const SizedBox(height: 32),

          // Badge Action Grid matching image_e4a243.png
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Text(
                  'Download the State Mobile App',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
                const SizedBox(height: 16),
                _buildMockBadgeButton(
                  Icons.apple,
                  'Download on the',
                  'App Store',
                ),
                const SizedBox(height: 10),
                _buildMockBadgeButton(
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

  Widget _buildMockBadgeButton(
    IconData logo,
    String label,
    String primaryText,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(logo, color: Colors.white, size: 24),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 8),
              ),
              Text(
                primaryText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
