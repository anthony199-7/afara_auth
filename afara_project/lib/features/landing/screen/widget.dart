import 'package:flutter/material.dart';

class FeatureItem extends StatelessWidget {
  final String title;
  final String description;
  final String link;

  const FeatureItem({
    super.key,
    required this.title,
    required this.description,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 120,
          color: const Color(0xFFCBEDFB),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Color(0xFF3873AF),
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(description,
                  style: const TextStyle(fontSize: 18, height: 1.4)),
              const SizedBox(height: 10),
              Text(link,
                  style: const TextStyle(
                      color: Color(0xFF3873AF), fontSize: 18)),
            ],
          ),
        )
      ],
    );
  }
}

class StepItem extends StatelessWidget {
  final String number;
  final String title;
  final String desc;

  const StepItem({
    super.key,
    required this.number,
    required this.title,
    required this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: Color(0xFF3873AF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              Text(desc,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300)),
            ],
          ),
        )
      ],
    );
  }
}

