import 'package:afara_project/features/pages/resources/faq_section.dart';
import 'package:afara_project/features/pages/resources/identify.dart';
import 'package:afara_project/features/pages/resources/whitepapersection.dart';
import 'package:flutter/material.dart';
import 'package:afara_project/core/theme/app_theme.dart';

class Resources extends StatelessWidget {
  const Resources({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF191970), // #191970 at 100%
            const Color(0xFFCBEDFB), // #CBEDFB at 50%
            const Color(0xFFFFFFFF), // #FFFFFF at 0%
          ],
          begin: Alignment.topRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(context),
          IdentitySecuritySection(),
          const SizedBox(height: 20),
          _buildResourcesHub(),
          const SizedBox(height: 40),
          WhitepaperSection(),
          const SizedBox(height: 40),
          FaqSection(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// 1. Blue Header with Search
Widget _buildHeader(BuildContext context) {
  return Container(
    height: AppTheme.responsiveHeaderHeight(context),
    width: double.infinity,
    padding: AppTheme.responsivePadding(
      context,
    ).copyWith(top: AppTheme.spacingXXL, bottom: AppTheme.spacingXXL),
    /*decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF191970), // #191970 at 100%
          Color(0xFFCBEDFB), // #CBEDFB at 50%
          Color(0xFFFFFFFF), // #FFFFFF at 0%
        ],

        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),*/
    child: LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < AppTheme.mobileBreakpoint;
        return isMobile
            ? Column(
                children: [
                  _buildHeaderContent(context, isMobile: true),
                  _buildSearchBar(context),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildHeaderContent(context)),
                  Expanded(child: _buildImageAndSearch(context)),
                ],
              );
      },
    ),
  );
}

Widget _buildHeaderContent(BuildContext context, {bool isMobile = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Resources and\nEducation Hub", // Adjusted text for better readability against gradient
        style: TextStyle(
          color: Colors.white, // Darker text for contrast
          fontWeight: FontWeight.w800,
          fontSize: 55,

          letterSpacing: -0.02 * 96,
        ),
      ),
      const SizedBox(height: AppTheme.spacingLG),
      Text(
        "Comprehensive guides, tools, and support \nto help you maximize your identity security\n and get the most out of Afara.",
        style: TextStyle(
          fontFamily: 'Inter',
          fontWeight: FontWeight.w400, // Regular = 400
          fontStyle: FontStyle.normal,
          fontSize: 32,
          height: 1.4, // line-height 140%
          letterSpacing: -0.02 * 32, // -2% of 32px = -0.64
          color: Colors.white, // Darker text for contrast
        ),
      ),
    ],
  );
}

Widget _buildImageAndSearch(BuildContext context) {
  return Column(
    children: [
      Image.asset("lib/assets/images/Image_resources.png"),
      const SizedBox(height: 12),
      _buildSearchBar(context),
    ],
  );
}

Widget _buildSearchBar(BuildContext context) {
  final isMobile = MediaQuery.sizeOf(context).width < AppTheme.mobileBreakpoint;
  return Container(
    alignment: Alignment.bottomRight,
    padding: const EdgeInsets.symmetric(
      vertical: AppTheme.spacingLG,
      horizontal: AppTheme.spacingLG,
    ),
    width: isMobile
        ? double.infinity
        : 300, // Make search bar full width on mobile
    height: 80,
    decoration: ShapeDecoration(
      color: Colors.white, // Corrected color constructor
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      shadows: [
        BoxShadow(
          color: Colors.black, // Softer shadow
          blurRadius: 5,
          offset: const Offset(0, 3),
          spreadRadius: 0,
        ),
      ],
    ),
    child: const TextField(
      decoration: InputDecoration(
        hintText: "Search for tips",
        hintStyle: TextStyle(color: Colors.black54), // Consistent hint color
        prefixIcon: Icon(
          Icons.search,
          color: Colors.black54,
        ), // Consistent icon color
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 10),
      ),
    ),
  );
}

// 4. Resources Hub & Map Section
Widget _buildResourcesHub() {
  return LayoutBuilder(
    builder: (context, constraints) {
      final isMobile = constraints.maxWidth < AppTheme.mobileBreakpoint;
      return isMobile
          ? Column(
              children: [
                _buildResourcesHubContent(context),
                const SizedBox(height: AppTheme.spacingXXL),
                _buildMapSection(context),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(padding: AppTheme.responsivePadding(context)),
                _buildResourcesHubContent(context),
                const SizedBox(width: AppTheme.spacingLG),
                Expanded(child: _buildMapSection(context)),
              ],
            );
    },
  );
}

Widget _buildResourcesHubContent(BuildContext context) {
  return Container(
    width: AppTheme.responsiveHubWidth(context),
    constraints: const BoxConstraints(minHeight: 500),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppTheme.borderRadiusLG),
      boxShadow: [
        BoxShadow(
          // Softer shadow
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 4,
          offset: const Offset(0, 4),
          spreadRadius: 1,
        ),
      ],
    ),
    padding: AppTheme.responsivePadding(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Resources Hub", // Adjusted text style
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            height: 1.40,
            letterSpacing: -0.72,
          ),
        ),
        const SizedBox(height: AppTheme.spacingXXL),
        const ResourceHubItem(
          // Renamed to avoid conflict with data model
          title: 'Complete Resource Center',
          tag: 'HUB',
          description: 'All resources in one place',
        ),
        const ResourceHubItem(
          // Renamed to avoid conflict with data model
          title: 'Getting Started Guide',
          tag: 'GUIDE',
          description: '5 min read',
        ),
        const ResourceHubItem(
          // Renamed to avoid conflict with data model
          title: 'Identity Best Practices',
          tag: 'GUIDE',
          description: 'Updated weekly',
        ),
      ],
    ),
  );
}

Widget _buildMapSection(BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text(
        'Securing clients\nacross the world', // Adjusted text style
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.w900,
          color: Colors.white, // Using theme color
          height: 1.1,
        ),
      ),
      const SizedBox(height: AppTheme.spacingXXL),
      LayoutBuilder(
        builder: (context, constraints) {
          final gridWidth = constraints.maxWidth < 400 ? 250.0 : 300.0;
          return SizedBox(
            width: gridWidth,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: AppTheme.spacingSM,
              crossAxisSpacing: AppTheme.spacingSM,
              children: List.generate(
                4,
                (index) => Container(
                  decoration: BoxDecoration(
                    // Using theme color
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(
                      AppTheme.borderRadiusSM,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ],
  );
}

class ResourceHubItem extends StatelessWidget {
  // Renamed to avoid conflict
  final String title;
  final String tag;
  final String description;

  const ResourceHubItem({
    // Renamed to avoid conflict
    super.key,
    required this.title,
    required this.tag,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title, // Adjusted text style
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppTheme.spacingSM),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSM,
                vertical: AppTheme.spacingXS,
              ),
              decoration: BoxDecoration(
                color: const Color(0x7FB4B4B4),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusSM),
              ),
              child: Text(
                tag,
                style: Theme.of(context).textTheme.labelSmall,
              ), // Adjusted text style
            ),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: Text(
                description, // Adjusted text style
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.black),
                overflow: TextOverflow.ellipsis, // Ensure text truncation
              ),
            ),
            const Icon(Icons.arrow_forward, size: 20),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppTheme.spacingLG),
          child: Divider(color: Colors.black12),
        ),
      ],
    );
  }
}

/* 5. Whitepaper Horizontal List
Widget _buildWhitepaperSection() {
  return SizedBox(
    height: 300,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 80),
      children: [
        _whitepaperCard(
          "Our Whitepapers",
          "12 Documents",
          Image.asset("lib/assets/images/Hero_img.png"),
        ),
        const SizedBox(width: 10),
        _whitepaperCard(
          "Webinars",
          "5 Videos",
          Image.asset("lib/assets/images/image2.png"),
        ),
        const SizedBox(width: 10),
        _whitepaperCard(
          "Webinars",
          "5 Videos",
          Image.asset("lib/assets/images/webinar.png"),
        ),
        const SizedBox(width: 10),
        _whitepaperCard(
          "Webinars",
          "5 Videos",
          Image.asset("lib/assets/images/webinar.png"),
        ),
        const SizedBox(width: 10),
        _whitepaperCard(
          "Webinars",
          "5 Videos",
          Image.asset("lib/assets/images/webinar.png"),
        ),
        const SizedBox(width: 10),
        _whitepaperCard(
          "Webinars",
          "5 Videos",
          Image.asset("lib/assets/images/webinar.png"),
        ),
        const SizedBox(width: 10),
      ],
    ),
  );
}

Widget _whitepaperCard(String title, String subtitle, Widget image) {
  return Container(
    width: 500,
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 245, 243, 243),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(40),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: const TextStyle(color: Color.fromARGB(179, 20, 20, 20)),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Color.fromARGB(255, 36, 35, 35),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
}
  );*/
