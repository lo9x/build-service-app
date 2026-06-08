import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _sand = Color(0xFFF6F0E8);
  static const _clay = Color(0xFFD7C4AF);
  static const _ink = Color(0xFF1F2522);
  static const _moss = Color(0xFF556B5D);
  static const _coral = Color(0xFFBF6D55);
  static const _card = Color(0xFFFFFCF7);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: _sand,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _moss,
        brightness: Brightness.light,
      ).copyWith(
        primary: _moss,
        secondary: _coral,
        surface: _card,
      ),
    );

    return base.copyWith(
      textTheme: GoogleFonts.manropeTextTheme(base.textTheme).copyWith(
        displayLarge: const TextStyle(
          color: _ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        headlineMedium: const TextStyle(
          color: _ink,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.7,
        ),
        titleLarge: const TextStyle(
          color: _ink,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: const TextStyle(
          color: _ink,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          color: Color(0xFF4E5852),
          height: 1.45,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: _ink,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardTheme(
        color: _card,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: const BorderSide(color: _clay, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _card,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _clay),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _clay),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: _moss, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _ink,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        side: const BorderSide(color: _clay),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
