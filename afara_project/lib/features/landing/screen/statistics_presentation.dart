import 'package:flutter/material.dart';

class StatisticsPresentation extends StatelessWidget {
  const StatisticsPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 768;
    final bool isDesktop = MediaQuery.of(context).size.width > 1100;
    const Color navyColor = Color(0xFF1E1F6B);
    const Color accentBlue = Color(0xFF3B77B1);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : (isDesktop ? 60 : 30),
        vertical: isMobile ? 60 : 100,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side: Text Content
                Expanded(
                  flex: 4,
                  child: _buildContent(navyColor, accentBlue, isMobile),
                ),
                const SizedBox(width: 60),
                // Right Side: Stats Grid
                Expanded(flex: 6, child: _buildStatsGrid(accentBlue, isMobile)),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContent(navyColor, accentBlue, isMobile),
                const SizedBox(height: 60),
                _buildStatsGrid(accentBlue, isMobile),
              ],
            ),
    );
  }

  // Helper for the text content on the left
  Widget _buildContent(Color navy, Color blue, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "OUR TRUE VALUE",
          style: TextStyle(
            color: blue,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Measurable\nperformance\nbacked by real-\nworld usage",
          style: TextStyle(
            color: navy,
            fontSize: isMobile ? 32 : 54,
            fontWeight: FontWeight.bold,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Our platform delivers measurable results that demonstrate its effectiveness and reliability at every level. Our IDaaS solutions not only meet compliance standards but also drive trust and confidence across digital ecosystems.",
          style: TextStyle(
            fontSize: isMobile ? 14 : 18,
            color: Colors.black87,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Why choose Afara",
                  style: TextStyle(
                    color: blue,
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: blue),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Helper for the stats columns - responsive grid
  Widget _buildStatsGrid(Color blue, bool isMobile) {
    return isMobile
        ? Column(
            children: [
              _buildStatItem(
                "50k+",
                "Active Users",
                "Trusted by over fifty thousand active users, our platform delivers secure and seamless identity management at scale.",
              ),
              const SizedBox(height: 30),
              _buildStatItem(
                "99.9%",
                "Uptime",
                "Guaranteed high availability with continuous monitoring and redundant systems to keep services online.",
              ),
              const SizedBox(height: 30),
              _buildStatItem(
                "200+",
                "Organizations",
                "Serving diverse sectors and industries, supporting enterprise-level security and compliance needs.",
              ),
              const SizedBox(height: 30),
              _buildStatItem(
                "24/7",
                "Support",
                "Round-the-clock customer support to assist with implementation, troubleshooting, and optimization.",
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildStatItem(
                  "50k+",
                  "Active Users",
                  "Trusted by over fifty thousand active users, our platform delivers secure and seamless identity management at scale.",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatItem(
                  "99.9%",
                  "Uptime",
                  "Guaranteed high availability with continuous monitoring and redundant systems to keep services online.",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatItem(
                  "200+",
                  "Organizations",
                  "Serving diverse sectors and industries, supporting enterprise-level security and compliance needs.",
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatItem(
                  "24/7",
                  "Support",
                  "Round-the-clock customer support to assist with implementation, troubleshooting, and optimization.",
                ),
              ),
            ],
          );
  }

  Widget _buildStatItem(String value, String label, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
