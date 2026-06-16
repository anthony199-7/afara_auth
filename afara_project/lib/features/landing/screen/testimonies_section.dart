import 'package:flutter/material.dart';

class TestimonialsSection extends StatelessWidget {
  const TestimonialsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int columns = 4;
    if (width < 1000) columns = 2;
    if (width < 700) columns = 1;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width < 900 ? 20 : 80,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TOP ROW
          width < 500
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Title(),
                    const SizedBox(height: 20),
                    const _ViewAllButton(),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Expanded(child: _Title()),
                    _ViewAllButton(),
                  ],
                ),

          const SizedBox(height: 50),

          /// GRID
          GridView.count(
            crossAxisCount: columns,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),

            children: const [
              TestimonialCard(
                role: "IT DIRECTOR, TECHCORP",
                name: "JOHN DOE",
                text:
                    "Afara streamlined our authentication process and improved security across all our applications.",
                button: "Read Case Study",
              ),
              TestimonialCard(
                role: "",
                name: "MARY SMITH",
                text:
                    "As an individual user, I appreciate the balance between personal security and convenience.",
                button: "Find Out More",
              ),
              TestimonialCard(
                role: "CTO, DATAFLOW",
                name: "JANE DAVIS",
                text:
                    "Afara simplified identity management for our teams while strengthening security.",
                button: "Read Case Study",
              ),
              TestimonialCard(
                role: "",
                name: "JAMES WILLIAMS",
                text:
                    "Afara makes managing my accounts feel seamless and trustworthy across platforms.",
                button: "Find Out More",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Trusted by organizations and industries worldwide",
      style: TextStyle(fontSize: 48, fontWeight: FontWeight.w500, height: 1.2),
    );
  }
}

class _ViewAllButton extends StatelessWidget {
  const _ViewAllButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF191970),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        "View All Stories",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
      ),
    );
  }
}

class TestimonialCard extends StatelessWidget {
  final String role;
  final String name;
  final String text;
  final String button;

  const TestimonialCard({
    super.key,
    required this.role,
    required this.name,
    required this.text,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.grey.withOpacity(.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (role.isNotEmpty)
            Text(
              role,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),

          const SizedBox(height: 6),

          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 14),

          Expanded(
            child: SingleChildScrollView(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Learn more",
            style: const TextStyle(
              color: Color(0xFF191970),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF191970), width: 2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              button,
              style: const TextStyle(
                color: Color(0xFF191970),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
