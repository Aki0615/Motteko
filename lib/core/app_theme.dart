import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color primaryBlue = Color(0xFF1A237E); // Deep Blue
  static const Color accentMint = Color(0xFF69F0AE); // Mint Green
  static const Color accentCoral = Color(0xFFFFAB91); // Coral Orange

  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);

  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E1E1E);

  static const Color textLight = Color(0xFF2C3E50);
  static const Color textDark = Color(0xFFECF0F1);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3949AB), Color(0xFF1A237E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white54, Colors.white24],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Text Styles
  static TextTheme _buildTextTheme(ThemeData base) {
    return GoogleFonts.notoSansJpTextTheme(base.textTheme).copyWith(
      displayLarge: GoogleFonts.notoSansJp(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      displayMedium: GoogleFonts.notoSansJp(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textLight,
      ),
      bodyLarge: GoogleFonts.notoSansJp(fontSize: 16, color: textLight),
      bodyMedium: GoogleFonts.notoSansJp(fontSize: 14, color: textLight),
    );
  }

  // Light Theme
  static ThemeData lightTheme() {
    final ThemeData base = ThemeData.light();
    return base.copyWith(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryBlue,
        secondary: accentMint,
        tertiary: accentCoral,
      ),
      textTheme: _buildTextTheme(base),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceLight,
      ),
    );
  }

  // Dark Theme (Optional for now, but good to have prepared)
  static ThemeData darkTheme() {
    final ThemeData base = ThemeData.dark();
    return base.copyWith(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryBlue,
        secondary: accentMint,
        tertiary: accentCoral,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.notoSansJpTextTheme(
        base.textTheme,
      ).apply(bodyColor: textDark, displayColor: textDark),
      useMaterial3: true,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: surfaceDark,
      ),
    );
  }
}
