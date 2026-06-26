import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color background = Color(0xFFF9F9F9);
  static const Color inkBlack = Color(0xFF111111);
  static const Color midnightNavy = Color(0xFF0B192C);
  static const Color softBorder = Color(0xFFE5E5E5);
  static const Color footerText = Color(0xFF666666);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.light(
        primary: inkBlack,
        secondary: midnightNavy,
        surface: Colors.white,
        onSurface: inkBlack,
        outline: softBorder,
      ),
      dividerTheme: const DividerThemeData(
        color: softBorder,
        thickness: 1,
        space: 1,
      ),
      textTheme: TextTheme(
        // H1 Title (Cormorant Garamond, uppercase, light/regular, wide letterSpacing)
        displayLarge: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          fontSize: 36,
          letterSpacing: 4.0,
          color: midnightNavy,
        ),
        // Brand logo (Cormorant Garamond, uppercase, light/regular, wide letterSpacing)
        displayMedium: GoogleFonts.cormorantGaramond(
          fontWeight: FontWeight.w300,
          fontSize: 28,
          letterSpacing: 5.0,
          color: inkBlack,
        ),
        // Slogan (Inter, italic, clean)
        displaySmall: GoogleFonts.inter(
          fontWeight: FontWeight.w300,
          fontSize: 14,
          fontStyle: FontStyle.italic,
          color: footerText,
        ),
        // Sub-titles / Card Titles (Inter)
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 18,
          letterSpacing: 1.0,
          color: inkBlack,
        ),
        // Body (Inter)
        bodyLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 15,
          height: 1.6,
          color: inkBlack,
        ),
        bodyMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 13,
          height: 1.5,
          color: footerText,
        ),
        // Labels & Footer details
        labelLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 1.0,
          color: Colors.white,
        ),
        labelMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w400,
          fontSize: 10,
          letterSpacing: 7.5,
          color: footerText,
        ),
        labelSmall: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 2.0,
          color: inkBlack,
        ),
      ),
      // Sharp rectangular buttons (borderRadius: BorderRadius.zero)
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: inkBlack,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: inkBlack,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
      ),
    );
  }
}
