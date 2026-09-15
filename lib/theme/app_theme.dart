import 'package:flutter/material.dart';

abstract final class AppColors {
  static const surface = Color(0xFFFFF8F4);
  static const surfaceLow = Color(0xFFFBF2EA);
  static const surfaceContainer = Color(0xFFF5ECE5);
  static const surfaceHigh = Color(0xFFF0E7DF);
  static const primary = Color(0xFFA33E06);
  static const primaryContainer = Color(0xFFF47A42);
  static const primaryFixed = Color(0xFFFFDBCD);
  static const secondary = Color(0xFF6E5E0D);
  static const tertiary = Color(0xFF00668A);
  static const text = Color(0xFF1F1B16);
  static const textMuted = Color(0xFF57423A);
  static const outline = Color(0xFF8B7268);
  static const error = Color(0xFFBA1A1A);
}

abstract final class AppTheme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      splashFactory: InkRipple.splashFactory,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surface,
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontSize: 36, height: 1.2, fontWeight: FontWeight.w800),
        headlineMedium: TextStyle(fontSize: 28, height: 1.25, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(fontSize: 22, height: 1.35, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 18, height: 1.4, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(fontSize: 16, height: 1.6),
        bodyMedium: TextStyle(fontSize: 14, height: 1.55),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
