import 'package:flutter/material.dart';

/// Application color scheme
class AppColorScheme {
  // Brand Colors
  static const Color primaryColor = Color(0xFFE91E63); // Pink - Safety & Empowerment
  static const Color secondaryColor = Color(0xFF9C27B0); // Purple - Support
  static const Color tertiaryColor = Color(0xFFFF5722); // Orange - Alert/Emergency
  
  // Light Theme Colors
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFFFD9E3),
    onPrimaryContainer: Color(0xFF3E001F),
    secondary: secondaryColor,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFF3D9FF),
    onSecondaryContainer: Color(0xFF2B0052),
    tertiary: tertiaryColor,
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFDBCF),
    onTertiaryContainer: Color(0xFF380D00),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFFFFBFF),
    onSurface: Color(0xFF201A1C),
    surfaceVariant: Color(0xFFF4DDE2),
    onSurfaceVariant: Color(0xFF524347),
    outline: Color(0xFF847377),
    outlineVariant: Color(0xFFD7C1C6),
    inverseSurface: Color(0xFF352F30),
    onInverseSurface: Color(0xFFFAEEEF),
    inversePrimary: Color(0xFFFFB1C8),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: primaryColor,
  );
  
  // Dark Theme Colors
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFFB1C8),
    onPrimary: Color(0xFF660033),
    primaryContainer: Color(0xFF8E004A),
    onPrimaryContainer: Color(0xFFFFD9E3),
    secondary: Color(0xFFE6B4FF),
    onSecondary: Color(0xFF470080),
    secondaryContainer: Color(0xFF6200A7),
    onSecondaryContainer: Color(0xFFF3D9FF),
    tertiary: Color(0xFFFFB59D),
    onTertiary: Color(0xFF5D1A00),
    tertiaryContainer: Color(0xFF852400),
    onTertiaryContainer: Color(0xFFFFDBCF),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF201A1C),
    onSurface: Color(0xFFEBE0E1),
    surfaceVariant: Color(0xFF524347),
    onSurfaceVariant: Color(0xFFD7C1C6),
    outline: Color(0xFF9F8C91),
    outlineVariant: Color(0xFF524347),
    inverseSurface: Color(0xFFEBE0E1),
    onInverseSurface: Color(0xFF352F30),
    inversePrimary: primaryColor,
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
    surfaceTint: Color(0xFFFFB1C8),
  );
  
  // Semantic Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color infoColor = Color(0xFF2196F3);
  
  // SOS Emergency Colors
  static const Color sosRedColor = Color(0xFFFF0000);
  static const Color sosOrangeColor = Color(0xFFFF6B00);
  
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
