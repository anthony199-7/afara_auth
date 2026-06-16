import 'package:afara_project/router/app_router.dart';
import 'package:flutter/material.dart';


import 'package:afara_project/core/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services

  runApp(const AfaraApp());
}

class AfaraApp extends StatelessWidget {
  const AfaraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Afara',
      theme: AppTheme.themeData,
      routerConfig: AppRouter.router,
    );
  }
}
