import 'package:afara_project/auth page/business_login.dart';
import 'package:afara_project/auth page/password/business/individualpassword.dart';

import 'package:afara_project/auth page/success/business_success.dart';
import 'package:afara_project/auth page/for_business_registration.dart';
import 'package:afara_project/auth page/for_individual_registration.dart';
import 'package:afara_project/auth page/individuals_login.dart';
import 'package:afara_project/auth page/password/business/passwordbusiness.dart';
import 'package:afara_project/auth page/password/business/forget_password.dart';
import 'package:afara_project/auth page/verificationpage/business_verification.dart';
import 'package:afara_project/auth%20page/login_verification/login_verification.dart';
import 'package:afara_project/auth%20page/verificationpage/verification_personal.dart';

import 'package:afara_project/features/auth/profile_screen.dart';

import 'package:afara_project/features/pages/pricing/bussiness_pricing.dart';
import 'package:afara_project/features/pages/pricing/individual_pricing.dart';
import 'package:afara_project/features/pages/resources/education_resources.dart';
import 'package:afara_project/landingpage.dart';
import 'package:afara_project/shared/footer.dart';
import 'package:afara_project/shared/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',

    // This makes the router reactive to auth state changes
    routes: [
      ShellRoute(
        // The builder provides the 'child' which represents the current page
        builder: (context, state, child) {
          return Scaffold(
            body: Column(
              children: [
                const TopNavigation(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(children: [child, const MainFooter()]),
                  ),
                ),
              ],
            ),
          );
        },
        routes: [
          // Landing Route
          GoRoute(
            path: '/',
            name: 'landing',
            builder: (context, state) => const Landingpage(),
          ),

          // Pricing Route
          GoRoute(
            path: '/pricing/individual',
            name: 'individual-pricing',
            builder: (context, state) => const IndividualPricing(),
          ),

          // Resources Route
          GoRoute(
            path: '/resources',
            name: 'resources',
            builder: (context, state) => const Resources(),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        path: '/pricing/business',
        name: 'business-pricing',
        builder: (context, state) => const BusinessPricingPage(),
      ),

      // Auth Routes - Moved OUTSIDE ShellRoute per mission requirements
      // Auth group: use a ShellRoute so nested auth pages render their
      // children correctly (prevents lifecycle/mounting issues).
      ShellRoute(
        builder: (context, state, child) => child,
        routes: [
          GoRoute(
            path: '/auth',
            builder: (context, state) => const Landingpage(),
            routes: [
              GoRoute(
                path: 'individual/login',
                name: 'individual-login',
                builder: (context, state) => const LoginIndividual(),
              ),
              GoRoute(
                path: 'individual/register',
                name: 'individual-register',
                builder: (context, state) => const IndividualRegistration(),
              ),
              GoRoute(
                path: 'individual/verification',
                name: 'individual-verification',
                builder: (context, state) {
                  final email = state.uri.queryParameters['email'] ?? '';
                  return IndividualVerificationPage(email: email);
                },
              ),
              GoRoute(
                path: 'individual/password',
                name: 'individual-password',
                builder: (context, state) {
                  final extra = state.extra as Map<String, String>;
                  return IndividualPassword(
                    email: extra['email']!,
                    role: extra['role']!,
                  );
                },
              ),
              GoRoute(
                path: 'individual/business-password-link',
                name: 'individual-business-password-link',
                builder: (context, state) {
                  final extra = state.extra as Map<String, String>;
                  return BusinessPassword(
                    email: extra['email']!,
                    role: extra['role']!,
                  );
                },
              ),
              GoRoute(
                path: 'individual/forgot-password',
                name: 'individual-forgot-password',
                builder: (context, state) =>
                    const ForgotPasswordPage(userType: 'individual'),
              ),
              GoRoute(
                path: 'business/forgot-password',
                name: 'business-forgot-password',
                builder: (context, state) =>
                    const ForgotPasswordPage(userType: 'business'),
              ),
              GoRoute(
                path: 'business/password',
                name: 'business-password',
                builder: (context, state) {
                  final extra = state.extra as Map<String, String>;
                  return BusinessPassword(
                    email: extra['email']!,
                    role: extra['role']!,
                  );
                },
              ),
              GoRoute(
                path: 'business/login',
                name: 'business-login',
                builder: (context, state) => BusinessLoginPage(),
              ),
              GoRoute(
                path: 'business/register',
                name: 'business-register',
                builder: (context, state) => BusinessRegistrationPage1(),
              ),
              GoRoute(
                path: 'business/verification',
                name: 'business-verification',
                builder: (context, state) {
                  final email = state.uri.queryParameters['email'] ?? '';
                  return VerificationPage(email: email);
                },
              ),
              GoRoute(
                path: 'business/business-success',
                name: 'business-success',
                builder: (context, state) => const BusinessSuccessPage(),
              ),

              GoRoute(
                path: 'individual/login-verification',
                name: 'individual-login-verification',
                builder: (context, state) {
                  final email = state.uri.queryParameters['email'] ?? '';
                  return LoginOtpVerificationScreenPage(email: email);
                },
              ),
            ],
          ),
        ],
      ),

      // Comprehensive Legacy Redirects based on ARCHITECTURE_REFACTORING.md
      GoRoute(
        path: '/personal-registration',
        redirect: (context, state) => '/auth/individual/register',
      ),
      GoRoute(
        path: '/individual-login',
        redirect: (context, state) => '/auth/individual/login',
      ),
      GoRoute(
        path: '/bussiness-singup',
        redirect: (context, state) => '/auth/business/register',
      ),
      GoRoute(
        path: '/bussiness-login',
        redirect: (context, state) => '/auth/business/login',
      ),
      GoRoute(
        path: '/verificationpage',
        redirect: (context, state) => '/auth/business/verification',
      ),
      GoRoute(
        path: '/PersonalVerification',
        redirect: (context, state) => '/auth/individual/verification',
      ),
    ],
  );
}
