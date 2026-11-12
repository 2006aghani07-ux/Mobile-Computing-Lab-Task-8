import 'package:flutter/material.dart';

/// Colour palette that matches the Campus Hub screenshots.
class AppColors {
  static const primary = Color(0xFF5B47E0);
  static const violet = Color(0xFF8A6BFF);
  static const coral = Color(0xFFFF7A5C);
  static const teal = Color(0xFF14B8A6);
  static const background = Color(0xFFF4F1FE);
  static const drawer = Color(0xFFF5F0FA);
  static const ink = Color(0xFF1D1B3A);
}

class AppTheme {
  /// Purple -> violet -> coral gradient used on the drawer header,
  /// the home banner and the splash screen.
  static const LinearGradient gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primary, AppColors.violet, AppColors.coral],
    stops: [0.0, 0.5, 1.0],
  );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          foregroundColor: AppColors.ink,
          titleTextStyle: TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: AppColors.drawer),
        navigationBarTheme: const NavigationBarThemeData(
          indicatorColor: Color(0xFFE3DCFF),
          labelTextStyle: WidgetStatePropertyAll(
            TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          ),
        ),
      );
}
