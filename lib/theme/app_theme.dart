import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF2563EB);
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);
  static const success = Color(0xFF16A34A);
  static const danger = Color(0xFFDC2626);
}

final lightTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2563EB),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0F172A),
    onSurfaceVariant: Color(0xFF64748B),
    outline: Color(0xFFE2E8F0),
    error: Color(0xFFDC2626),
    tertiary: Color(0xFF16A34A),
  ),
  scaffoldBackgroundColor: const Color(0xFFF8FAFC),
);

final darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF60A5FA),
    surface: Color(0xFF0F172A),
    onSurface: Color(0xFFF8FAFC),
    onSurfaceVariant: Color(0xFF94A3B8),
    outline: Color(0xFF334155),
    error: Color(0xFFF87171),
    tertiary: Color(0xFF4ADE80),
  ),
  scaffoldBackgroundColor: Color.fromARGB(255, 0, 6, 32),
);

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

class AppSpacing {
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;
}
