// ignore_for_file: unrelated_type_equality_checks

import 'package:afara_project/features/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class MainNavigation extends ConsumerWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = MediaQuery.sizeOf(context).width < 900;
    final authState = ref.watch(authNotifierProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: isMobile
          ? _MobileNav(isLoggedIn: authState.isAuthenticated)
          : _DesktopNav(isLoggedIn: authState.isAuthenticated),
    );
  }
}

////////////////////////////////////////////////////////////
/// DESKTOP NAV
////////////////////////////////////////////////////////////

class _DesktopNav extends StatelessWidget {
  final bool isLoggedIn;

  const _DesktopNav({required this.isLoggedIn});

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
            errorBuilder: (context, error, stackTrace) => SizedBox(
              height: 50,
              width: 150,
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 28,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 8),
                  Text('Afara', style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
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

        if (!isLoggedIn) ...[
          PrimaryButton(
            "Get Started",
            onTap: () => context.go('/auth/individual/register'),
          ),
          const SizedBox(width: 16),
          OutlineButtonWidget(
            "Login",
            onTap: () => context.go('/auth/individual/login'),
          ),
          const SizedBox(width: 16),
        ] else
          const _ProfileMenu(),
      ],
    );
  }
}

////////////////////////////////////////////////////////////
/// MOBILE NAV
////////////////////////////////////////////////////////////

class _MobileNav extends StatelessWidget {
  final bool isLoggedIn;

  const _MobileNav({required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'lib/assets/images/afara_primary logo copy.png',
          height: 40,
          errorBuilder: (context, error, stackTrace) => Row(
            children: [
              const Icon(
                Icons.account_balance,
                size: 28,
                color: Color(0xFF191970),
              ),
              const SizedBox(width: 8),
              Text('Afara', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const SizedBox(width: 16),
        const Spacer(),
        if (isLoggedIn)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => context.go('/profile'),
              child: const Icon(Icons.account_circle, color: Color(0xFF191970)),
            ),
          )
        else
          const _MobileMenu(),
      ],
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'feature') {
          context.go('/');
        } else if (value == 'price') {
          context.go('/pricing/individual');
        } else if (value == 'resources') {
          context.go('/resources');
        }
      },
      offset: const Offset(0, 40),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'feature',
          padding: EdgeInsets.zero,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.dashboard_outlined,
                  size: 20,
                  color: Color(0xFF191970),
                ),
                const SizedBox(width: 12),
                Text(
                  'Features',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF191970),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'price',
          padding: EdgeInsets.zero,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.attach_money_outlined,
                  size: 20,
                  color: Color(0xFF191970),
                ),
                const SizedBox(width: 12),
                Text(
                  'Pricing',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF191970),
                  ),
                ),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          value: 'resources',
          padding: EdgeInsets.zero,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.library_books_outlined,
                  size: 20,
                  color: Color(0xFF191970),
                ),
                const SizedBox(width: 12),
                Text(
                  'Resources',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF191970),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF191970),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.menu, color: Colors.white),
      ),
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

class _ProfileMenu extends ConsumerWidget {
  const _ProfileMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final email = authState.userProfile?['email'] ?? 'Profile';

    return PopupMenuButton<String>(
      icon: const Icon(Icons.account_circle, color: Color(0xFF191970)),
      tooltip: 'Profile options',
      onSelected: (value) async {
        if (value == 'profile') {
          context.go('/profile');
        } else if (value == 'settings') {
          context.go('/profile');
        } else if (value == 'logout') {
          await ref.read(authNotifierProvider.notifier).logout();
          if (context.mounted) {
            context.go('/');
          }
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person_outline, size: 18),
              const SizedBox(width: 8),
              Text(email),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout, size: 18),
              SizedBox(width: 8),
              Text('Logout'),
            ],
          ),
        ),
      ],
    );
  }
}
