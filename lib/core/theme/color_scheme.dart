import 'package:flutter/material.dart';

/// Application color scheme (based on #005368)
class AppColorScheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFF005368); // Deep teal - Safety & Trust
  static const Color secondaryColor = Color(0xFF008C8C); // Teal-green - Support & Calm
  static const Color tertiaryColor = Color(0xFFFF7043); // Orange - Alert/Emergency

  // Light Theme Colors
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFC2E7EB),
    onPrimaryContainer: Color(0xFF001F24),
    secondary: secondaryColor,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFB2EBE0),
    onSecondaryContainer: Color(0xFF00201E),
    tertiary: tertiaryColor,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFFD7C5),
    onTertiaryContainer: Color(0xFF3B0A00),
    error: Color(0xFFBA1A1A),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF8FBFB),
    onSurface: Color(0xFF102021),
    surfaceVariant: Color(0xFFDCE4E4),
    onSurfaceVariant: Color(0xFF3F4A4A),
    outline: Color(0xFF707C7C),
    outlineVariant: Color(0xFFC2CCCC),
    inverseSurface: Color(0xFF283233),
    onInverseSurface: Color(0xFFE0F1F1),
    inversePrimary: Color(0xFF79D2E2),
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: primaryColor,
  );

  // Dark Theme Colors
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF79D2E2),
    onPrimary: Color(0xFF003640),
    primaryContainer: Color(0xFF004D58),
    onPrimaryContainer: Color(0xFFC2E7EB),
    secondary: Color(0xFF66D1C1),
    onSecondary: Color(0xFF003731),
    secondaryContainer: Color(0xFF005049),
    onSecondaryContainer: Color(0xFFB2EBE0),
    tertiary: Color(0xFFFFB59B),
    onTertiary: Color(0xFF5E1B00),
    tertiaryContainer: Color(0xFF852400),
    onTertiaryContainer: Color(0xFFFFD7C5),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0D1A1A),
    onSurface: Color(0xFFE0F1F1),
    surfaceVariant: Color(0xFF3F4A4A),
    onSurfaceVariant: Color(0xFFC2CCCC),
    outline: Color(0xFF889393),
    outlineVariant: Color(0xFF3F4A4A),
    inverseSurface: Color(0xFFE0F1F1),
    onInverseSurface: Color(0xFF283233),
    inversePrimary: primaryColor,
    shadow: Colors.black,
    scrim: Colors.black,
    surfaceTint: Color(0xFF79D2E2),
  );

  // Semantic Colors
  static const Color successColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFFFB300);
  static const Color infoColor = Color(0xFF0288D1);

  // SOS Emergency Colors
  static const Color sosRedColor = Color(0xFFFF3B30);
  static const Color sosOrangeColor = Color(0xFFFF9500);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradient = LinearGradient(
    colors: [sosRedColor, sosOrangeColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Safe Zone Colors
  static const Color safeGreen = Color(0xFF00C853);
  static const Color cautionYellow = Color(0xFFFFD600);
  static const Color dangerRed = Color(0xFFD50000);
}
