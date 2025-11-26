import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Manages system UI overlay styles for different themes
class SystemUIManager {
  /// Updates system UI overlay style based on theme brightness
  static void updateSystemUIOverlay(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;
    
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        // Status bar
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        
        // Navigation bar
        systemNavigationBarColor: isDark 
            ? const Color(0xFF0D1A1A) // Dark surface color
            : Colors.white,
        systemNavigationBarIconBrightness: isDark 
            ? Brightness.light 
            : Brightness.dark,
        systemNavigationBarDividerColor: isDark
            ? const Color(0xFF3F4A4A)
            : const Color(0xFFDCE4E4),
      ),
    );
  }

  /// Sets up initial system UI overlay style
  static void setupInitialSystemUI() {
    // Get system brightness to set initial overlay
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    updateSystemUIOverlay(brightness);
  }

  /// Updates system UI when theme changes
  static void onThemeChanged(ThemeMode themeMode) {
    final brightness = switch (themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };
    
    updateSystemUIOverlay(brightness);
  }
}
