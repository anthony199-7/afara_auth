import 'package:flutter/material.dart';
import 'package:afara_project/core/theme/app_theme.dart';

class IdentitySecuritySection extends StatelessWidget {
  const IdentitySecuritySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppTheme.responsiveMaxWidth(context),
      /*decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.50, 0.00),
          end: Alignment(-0.50, 1.00),
          colors: [
            Color(0xFFFFFFFF), // #FFFFFF at 0%
            Color.fromARGB(255, 177, 191, 235), // #CBEDFB at 50%
            Color(0xFF191970), // #191970 at 100%
          ],
        ),
      ),*/
      //padding: AppTheme.responsivePadding(context),
      child: Column(
        children: [
          _buildTabBar(context),
          const SizedBox(height: AppTheme.spacingMD),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppTheme.responsiveMaxWidth(context),
            ),
            child: Wrap(
              spacing: AppTheme.spacingLG,
              runSpacing: AppTheme.spacingXXL,
              alignment: WrapAlignment.center,
              children: [
                _ArticleCard(
                  image: Image.asset("lib/assets/images/identity_image2.png"),
                  category: "Identity and Security",
                  title:
                      "Why Identity Verification is Your First Line of Defense Against Fraud",
                ),
                _ArticleCard(
                  image: Image.asset("lib/assets/images/education.png"),
                  category: "Identity and Security",
                  title:
                      "Educating Users on Identity Safety: Afara's Approach to Awareness",
                ),
                _ArticleCard(
                  image: Image.asset("lib/assets/images/identity_image3.png"),
                  category: "Identity and Security",
                  title:
                      "Multi-Tenant Token Services: How Afara Protects Workflows",
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingXXL),
          Column(
            children: [
              Text(
                "View More",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color.fromARGB(255, 10, 7, 7),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Container(
                width: 80,
                height: 1,
                color: const Color.fromARGB(255, 19, 17, 17),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // REFACTORED TAB BAR
  Widget _buildTabBar(BuildContext context) {
    return Container(
      width: 650,
      //height: 50,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      padding: const EdgeInsets.all(5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              [
                "Identity Security",

                "Education",
                "Company News",
                "Industry News",
              ].map((tab) {
                bool isActive = tab == "Identity Security";
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingLG,
                  ),
                  // padding: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: isActive
                        ? const Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 84, 92, 184),
                              width: 3,
                            ),
                          )
                        : null,
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: AppTheme.fontSizeLG,
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w500,
                      color: isActive
                          ? const Color.fromARGB(255, 12, 11, 11)
                          : const Color.fromARGB(255, 136, 134, 134),
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final Widget image;
  final String category;
  final String title;

  const _ArticleCard({
    required this.image,
    required this.category,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final cardSize = AppTheme.responsiveCardSize(context);
    return SizedBox(
      width: cardSize.width,
      child: Column(
        children: [
          Container(
            height: cardSize.height,
            width: cardSize.width,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMD),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(aspectRatio: 1, child: image),
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSM,
                  ),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      color: const Color.fromARGB(255, 15, 15, 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
