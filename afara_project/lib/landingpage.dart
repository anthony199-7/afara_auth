import 'package:afara_project/features/landing/screen/call_to_action.dart';
import 'package:afara_project/features/landing/screen/comprehensive_identitysolutions.dart';
import 'package:afara_project/features/landing/screen/educational_resources.dart';
import 'package:afara_project/features/landing/screen/hero.dart';
import 'package:afara_project/features/landing/screen/how_it_works.dart';
import 'package:afara_project/features/landing/screen/security_section.dart';
import 'package:afara_project/features/landing/screen/statistics_presentation.dart';
import 'package:afara_project/features/landing/screen/testimonies_section.dart';
//import 'package:afara_project/shared/navbar.dart';

import 'package:flutter/material.dart';

class Landingpage extends StatelessWidget {
  const Landingpage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        HeroSection(),
        ComprehensiveIdentitySolutions(),
        HowItWorksDemoSection(),
        TestimonialsSection(),
        StatisticsPresentation(),
        SecuritySection(),
        EducationalResourcesSection(),
        CallToActionSection(),
      ],
    );
  }
}
