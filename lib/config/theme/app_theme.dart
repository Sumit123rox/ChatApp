import 'package:flutter/material.dart';

class AppTheme {
  // Define the primary color
  static const primaryColor = Color(0xff692960);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: 'Lufga',

    // Colors
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: Color(0xFF8E8E93),
      surface: Colors.white,
      onSurface: Colors.black,
      // Adding complementary colors that work well with #acdde0
      tertiary: Color(0xFF7CBEC2),
      // Slightly darker shade for depth
      onPrimary:
          Colors.black87, // Dark text on primary color for better contrast
    ),

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: Colors.black),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: primaryColor.withValues(alpha: 0.1),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: primaryColor),
      ),
      hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
    ),

    // Message Bubbles
    cardTheme: CardTheme(
      color: primaryColor.withValues(alpha: 0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // Icons
    iconTheme: const IconThemeData(color: Colors.black87, size: 24),

    // Text Themes
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: 'Lufga',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
        fontFamily: 'Lufga',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.black87,
        fontFamily: 'Lufga',
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        color: Colors.grey,
        fontFamily: 'Lufga',
      ),
    ),

    // Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.black87,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Lufga',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
