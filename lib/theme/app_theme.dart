import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Colors from design system
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF8F9FA);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textMuted = Color(0xFF999999);
  static const Color accentTeal = Color(0xFF20B2AA);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentBlue = Color(0xFF4A90E2);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
  );

  static const LinearGradient overlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.transparent,
      Color(0x33000000),
      Color(0x99000000),
    ],
  );

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: primaryBlack,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: primaryBlack,
    height: 1.2,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryBlack,
    height: 1.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: primaryBlack,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: primaryBlack,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: textMuted,
    height: 1.2,
  );

  // Button Styles
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryBlack,
    foregroundColor: primaryWhite,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26),
    ),
    minimumSize: const Size(double.infinity, 52),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: lightGray,
    foregroundColor: primaryBlack,
    elevation: 0,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    minimumSize: const Size(0, 40),
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  );

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x1A000000),
    offset: Offset(0, 4),
    blurRadius: 12,
    spreadRadius: 0,
  );

  static const BoxShadow largeShadow = BoxShadow(
    color: Color(0x26000000),
    offset: Offset(0, 8),
    blurRadius: 25,
    spreadRadius: 0,
  );

  // Border Radius
  static const BorderRadius radiusSmall = BorderRadius.all(Radius.circular(8));
  static const BorderRadius radiusMedium = BorderRadius.all(Radius.circular(12));
  static const BorderRadius radiusLarge = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusXLarge = BorderRadius.all(Radius.circular(20));
  static const BorderRadius radius2XLarge = BorderRadius.all(Radius.circular(24));

  // Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryBlack,
        secondary: accentTeal,
        surface: primaryWhite,
        background: primaryWhite,
        onPrimary: primaryWhite,
        onSecondary: primaryWhite,
        onSurface: primaryBlack,
        onBackground: primaryBlack,
      ),
      scaffoldBackgroundColor: primaryWhite,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryWhite,
        foregroundColor: primaryBlack,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          color: primaryBlack,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: primaryButtonStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightGray,
        border: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusMedium,
          borderSide: const BorderSide(color: primaryBlack, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: textSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      cardTheme: const CardThemeData(
        color: primaryWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: radiusLarge),
        shadowColor: Color(0x1A000000),
      ),
    );
  }
}

// Animation Durations
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  // Animation Curves
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounceOut = Curves.bounceOut;
}

// Spacing
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}