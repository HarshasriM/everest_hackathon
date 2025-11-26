import 'package:flutter/material.dart';

/// Application color scheme (based on #005368)
class AppColorScheme {
  // Brand Colors
  static const Color primaryColor = Color(
    0xFF005368,
  ); // Deep teal - Safety & Trust
  static const Color secondaryColor = Color(
    0xFF008C8C,
  ); // Teal-green - Support & Calm
  static const Color tertiaryColor = Color(
    0xFFFF7043,
  ); // Orange - Alert/Emergency

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
    surfaceContainerHighest: Color(0xFFDCE4E4),
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
    surfaceContainerHighest: Color(0xFF3F4A4A),
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

  // Semantic Colors (Light Mode)
  static const Color successColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFFFB300);
  static const Color infoColor = Color(0xFF0288D1);

  // Semantic Colors (Dark Mode)
  static const Color successColorDark = Color(0xFF4CAF50);
  static const Color warningColorDark = Color(0xFFFFC107);
  static const Color infoColorDark = Color(0xFF42A5F5);

  // SOS Emergency Colors
  static const Color sosRedColor = Color(0xFFFF3B30);
  static const Color sosOrangeColor = Color(0xFFFF9500);

  // Light Mode Gradients
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

  // Dark Mode Gradients
  static const LinearGradient primaryGradientDark = LinearGradient(
    colors: [Color(0xFF79D2E2), Color(0xFF66D1C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient emergencyGradientDark = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFFB347)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Surface Gradients for Cards and Containers
  static const LinearGradient lightSurfaceGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FBFB)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkSurfaceGradient = LinearGradient(
    colors: [Color(0xFF1A2F2F), Color(0xFF0D1A1A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Safe Zone Colors (Light Mode)
  static const Color safeGreen = Color(0xFF00C853);
  static const Color cautionYellow = Color(0xFFFFD600);
  static const Color dangerRed = Color(0xFFD50000);

  // Safe Zone Colors (Dark Mode)
  static const Color safeGreenDark = Color(0xFF4CAF50);
  static const Color cautionYellowDark = Color(0xFFFFC107);
  static const Color dangerRedDark = Color(0xFFFF5252);

  // Theme-aware gradient getter
  static LinearGradient getPrimaryGradient(bool isDark) {
    return isDark ? primaryGradientDark : primaryGradient;
  }

  static LinearGradient getEmergencyGradient(bool isDark) {
    return isDark ? emergencyGradientDark : emergencyGradient;
  }

  static LinearGradient getSurfaceGradient(bool isDark) {
    return isDark ? darkSurfaceGradient : lightSurfaceGradient;
  }

  // Theme-aware safe zone colors
  static Color getSafeGreen(bool isDark) {
    return isDark ? safeGreenDark : safeGreen;
  }

  static Color getCautionYellow(bool isDark) {
    return isDark ? cautionYellowDark : cautionYellow;
  }

  static Color getDangerRed(bool isDark) {
    return isDark ? dangerRedDark : dangerRed;
  }

  // Theme-aware semantic colors
  static Color getSuccessColor(bool isDark) {
    return isDark ? successColorDark : successColor;
  }

  static Color getWarningColor(bool isDark) {
    return isDark ? warningColorDark : warningColor;
  }

  static Color getInfoColor(bool isDark) {
    return isDark ? infoColorDark : infoColor;
  }

  // Additional gradient utilities for enhanced theming
  static LinearGradient getSuccessGradient(bool isDark) {
    final baseColor = getSuccessColor(isDark);
    return LinearGradient(
      colors: [
        baseColor,
        isDark ? const Color(0xFF66BB6A) : const Color(0xFF1B5E20),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getWarningGradient(bool isDark) {
    final baseColor = getWarningColor(isDark);
    return LinearGradient(
      colors: [
        baseColor,
        isDark ? const Color(0xFFFFD54F) : const Color(0xFFFF8F00),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getInfoGradient(bool isDark) {
    final baseColor = getInfoColor(isDark);
    return LinearGradient(
      colors: [
        baseColor,
        isDark ? const Color(0xFF64B5F6) : const Color(0xFF0277BD),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  // Card and container gradients for enhanced depth
  static LinearGradient getCardGradient(bool isDark) {
    return isDark
        ? const LinearGradient(
            colors: [Color(0xFF1E3A3A), Color(0xFF0F2020)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF5F8F8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }

  // Elevated surface gradient for floating elements
  static LinearGradient getElevatedSurfaceGradient(bool isDark) {
    return isDark
        ? const LinearGradient(
            colors: [Color(0xFF2A4040), Color(0xFF1A3030)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFF0F4F4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );
  }
}
