import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const canvas = Color(0xFFF5F1EA);
  static const surface = Color(0xFFFFFCF6);
  static const ink = Color(0xFF18211E);
  static const muted = Color(0xFF66706B);
  static const line = Color(0xFFD8CCBC);
  static const primary = Color(0xFF274C46);
  static const accent = Color(0xFFC66A3D);
  static const success = Color(0xFF5B7F5B);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: canvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ).copyWith(
        primary: primary,
        secondary: accent,
        surface: surface,
        onSurface: ink,
      ),
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme.copyWith(
        displayLarge: GoogleFonts.dmSerifDisplay(
          color: ink,
          fontSize: 52,
          height: 0.95,
          letterSpacing: -0.8,
        ),
        displayMedium: GoogleFonts.dmSerifDisplay(
          color: ink,
          fontSize: 42,
          height: 0.98,
          letterSpacing: -0.6,
        ),
        headlineMedium: GoogleFonts.dmSerifDisplay(
          color: ink,
          fontSize: 34,
          height: 1,
        ),
        titleLarge: const TextStyle(
          color: ink,
          fontSize: 24,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.4,
        ),
        titleMedium: const TextStyle(
          color: ink,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(
          color: ink,
          fontSize: 16,
          height: 1.55,
        ),
        bodyMedium: const TextStyle(
          color: muted,
          fontSize: 14,
          height: 1.5,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: line),
        ),
      ),
      dividerColor: line,
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: line),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        labelStyle: const TextStyle(
          color: ink,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.82),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        labelStyle: const TextStyle(color: muted),
        hintStyle: const TextStyle(color: muted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: primary, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: accent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(22),
          borderSide: const BorderSide(color: accent, width: 1.4),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: ink,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: const BorderSide(color: line),
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: ink,
        contentTextStyle: const TextStyle(color: Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
