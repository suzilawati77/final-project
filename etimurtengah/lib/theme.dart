// ══════════════════════════════════════════════════════════════════
// FAIL STARTER — salin ke:  lib/theme.dart
// Tema warna KPT (navy + emas) — KptTheme.navy / KptTheme.gold.
// (Jangan taip dari kosong — salin terus ke projek anda.)
// ══════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

/// Tema aplikasi eTT Mobile.
///
/// NOTA: e-Timur Tengah (eTT) / KPT tiada palet warna rasmi yang diterbitkan.
/// Navy + emas di bawah adalah **pilihan reka bentuk (design choice)** untuk
/// bahan latihan ini, bukan warna korporat rasmi KPT.
class KptTheme {
  KptTheme._();

  static const Color navy = Color(0xFF1A2B5C);
  static const Color gold = Color(0xFFD4A017);
  static const Color bgLight = Color(0xFFF5F6FA);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: navy,
      primary: navy,
      secondary: gold,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bgLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        clipBehavior: Clip.antiAlias,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.bold, color: KptTheme.navy),
        titleMedium: TextStyle(fontWeight: FontWeight.w600, color: KptTheme.navy),
      ),
    );
  }
}