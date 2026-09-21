import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF7C3AED),
  scaffoldBackgroundColor: const Color(0xFF0F0E17),
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF1A1929),
    primary: Color(0xFF7C3AED),
    secondary: Color(0xFF10B981),
    error: Color(0xFFEF4444),
  ),
  cardTheme: CardTheme(
    color: const Color(0xFF252438),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 0,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    centerTitle: false,
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1A1929),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF7C3AED),
      foregroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFF7C3AED),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
);

class StatusColors {
  static const green = Color(0xFF10B981);
  static const yellow = Color(0xFFF59E0B);
  static const red = Color(0xFFEF4444);
}
