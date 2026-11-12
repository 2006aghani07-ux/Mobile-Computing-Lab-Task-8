import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'features/splash/splash_screen.dart';

class CampusHubApp extends StatelessWidget {
  const CampusHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Hub',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      // Lab 07: the app now starts on the animated splash screen.
      home: const SplashScreen(),
    );
  }
}
