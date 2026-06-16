// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class TopNavigation extends StatelessWidget {
  const TopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [_TopBar(), MainNavigation()],
      ),
    );
  }
}

////////////////////////////////////////////////////////////
/// TOP BLUE BAR
////////////////////////////////////////////////////////////

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    

    return Container(
      color: const Color(0xFF3873AF),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      height: 35,
      child: Row(
        children: [
          const SizedBox(width: 12),

          /// left links
          Row(
            children: const [
              _NavItem("For Individuals", route: '/auth/individual/register'),
              SizedBox(width: 20),
              SizedBox(width: 20),
              _NavItem("For Businesses", route: '/auth/business/register'),
            ],
          ),

          const Spacer(),

          /// login
         
        ],
      ),
    );
    
  }
}

////////////////////////////////////////////////////////////
/// MAIN NAV
////////////////////////////////////////////////////////////

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: isMobile ? _MobileNav() : _DesktopNav(),
    );
  }
}

////////////////////////////////////////////////////////////
/// DESKTOP NAV
////////////////////////////////////////////////////////////

class _DesktopNav extends StatelessWidget {
  const _DesktopNav();

  @override
  Widget build(BuildContext context) {
    

    return Row(
      children: [
        /// LOGO → landing
        InkWell(
          onTap: () => context.go("/"),
          child: Image.asset(
            'lib/assets/images/afara_primary logo copy.png',
            height: 50,
          ),
        ),

        const SizedBox(width: 60),

        /// menu
        const _NavItems("Features", route: "/"),
        const SizedBox(width: 32),

        const _NavItems("Resources", route: "/resources"),
        const SizedBox(width: 32),

        const _NavItems("Pricing", route: "/pricing/individual"),

        const Spacer(),

        /// buttons
        PrimaryButton("Get Started", onTap: () => context.go('/auth/individual/register')),
        const SizedBox(width: 16),
        OutlineButtonWidget("Login", onTap: () => context.go('/auth/individual/login')),
        const SizedBox(width: 16),
       
        ]
      ,
    );
  }
}

////////////////////////////////////////////////////////////
/// MOBILE NAV
////////////////////////////////////////////////////////////

class _MobileNav extends StatelessWidget {
  const _MobileNav();

  @override
  Widget build(BuildContext context) {
  

    return Row(
      children: [
        const Image(
          image: AssetImage('lib/assets/images/afara_primary logo copy.png'),
          height: 40,
        ),
        const SizedBox(width: 16),

        const Spacer(),
      
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => context.go('/profile'),
              child: const Icon(Icons.account_circle, color: Color(0xFF191970)),
            ),
          ),
        IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// WIDGETS
////////////////////////////////////////////////////////////

class _NavItem extends StatelessWidget {
  final String title;
  final String route;

  const _NavItem(this.title, {required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 248, 246, 246),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const PrimaryButton(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF191970),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class OutlineButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const OutlineButtonWidget(this.text, {super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: const Color(0xFF191970)),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF191970),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NavItems extends StatelessWidget {
  final String title;
  final String route;

  const _NavItems(this.title, {required this.route});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      child: Text(
        title,
        style: const TextStyle(
          color: Color.fromARGB(255, 12, 12, 12),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
