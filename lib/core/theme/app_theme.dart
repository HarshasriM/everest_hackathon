import 'package:flutter/material.dart';
import 'color_scheme.dart';

/// Application theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: AppColorScheme.lightColorScheme,
      fontFamily: 'Roboto',

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColorScheme.lightColorScheme.surface,
        foregroundColor: AppColorScheme.lightColorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: AppColorScheme.lightColorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorScheme.lightColorScheme.primary,
          foregroundColor: AppColorScheme.lightColorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorScheme.lightColorScheme.primary,
          minimumSize: const Size(double.infinity, 56),
          side: BorderSide(
            color: AppColorScheme.lightColorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorScheme.lightColorScheme.primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorScheme.lightColorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.outline,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColorScheme.lightColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.lightColorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: AppColorScheme.lightColorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          color: AppColorScheme.lightColorScheme.onSurfaceVariant.withOpacity(
            0.5,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColorScheme.lightColorScheme.surface,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorScheme.lightColorScheme.surface,
        selectedItemColor: AppColorScheme.lightColorScheme.primary,
        unselectedItemColor: AppColorScheme.lightColorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorScheme.lightColorScheme.primary,
        foregroundColor: AppColorScheme.lightColorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColorScheme.lightColorScheme.surface,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorScheme.lightColorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: AppColorScheme.lightColorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: AppColorScheme.lightColorScheme.surface,
        selectedTileColor: AppColorScheme.lightColorScheme.primaryContainer,
        iconColor: AppColorScheme.lightColorScheme.onSurfaceVariant,
        textColor: AppColorScheme.lightColorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.lightColorScheme.primary;
          }
          return AppColorScheme.lightColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.lightColorScheme.primaryContainer;
          }
          return AppColorScheme.lightColorScheme.surfaceContainerHighest;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.lightColorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(
          AppColorScheme.lightColorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.lightColorScheme.primary;
          }
          return AppColorScheme.lightColorScheme.outline;
        }),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColorScheme.lightColorScheme.outline.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColorScheme.lightColorScheme.onSurface,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: IconThemeData(
        color: AppColorScheme.lightColorScheme.primary,
        size: 24,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: AppColorScheme.darkColorScheme,
      fontFamily: 'Roboto',

      // App Bar Theme
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColorScheme.darkColorScheme.surface,
        foregroundColor: AppColorScheme.darkColorScheme.onSurface,
        titleTextStyle: TextStyle(
          color: AppColorScheme.darkColorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColorScheme.darkColorScheme.primary,
          foregroundColor: AppColorScheme.darkColorScheme.onPrimary,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColorScheme.darkColorScheme.primary,
          minimumSize: const Size(double.infinity, 56),
          side: BorderSide(
            color: AppColorScheme.darkColorScheme.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColorScheme.darkColorScheme.primary,
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorScheme.darkColorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColorScheme.darkColorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.outline.withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColorScheme.darkColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColorScheme.darkColorScheme.error,
            width: 2,
          ),
        ),
        labelStyle: TextStyle(
          color: AppColorScheme.darkColorScheme.onSurfaceVariant,
        ),
        hintStyle: TextStyle(
          color: AppColorScheme.darkColorScheme.onSurfaceVariant.withOpacity(
            0.5,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: AppColorScheme.darkColorScheme.surface,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColorScheme.darkColorScheme.surface,
        selectedItemColor: AppColorScheme.darkColorScheme.primary,
        unselectedItemColor: AppColorScheme.darkColorScheme.onSurfaceVariant,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColorScheme.darkColorScheme.primary,
        foregroundColor: AppColorScheme.darkColorScheme.onPrimary,
        elevation: 4,
        shape: const CircleBorder(),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: AppColorScheme.darkColorScheme.surface,
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColorScheme.darkColorScheme.inverseSurface,
        contentTextStyle: TextStyle(
          color: AppColorScheme.darkColorScheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        tileColor: AppColorScheme.darkColorScheme.surface,
        selectedTileColor: AppColorScheme.darkColorScheme.primaryContainer,
        iconColor: AppColorScheme.darkColorScheme.onSurfaceVariant,
        textColor: AppColorScheme.darkColorScheme.onSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.darkColorScheme.primary;
          }
          return AppColorScheme.darkColorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.darkColorScheme.primaryContainer;
          }
          return AppColorScheme.darkColorScheme.surfaceContainerHighest;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.darkColorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(
          AppColorScheme.darkColorScheme.onPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColorScheme.darkColorScheme.primary;
          }
          return AppColorScheme.darkColorScheme.outline;
        }),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColorScheme.darkColorScheme.outline.withOpacity(0.2),
        thickness: 1,
        space: 1,
      ),

      // Icon Theme
      iconTheme: IconThemeData(
        color: AppColorScheme.darkColorScheme.onSurface,
        size: 24,
      ),

      // Primary Icon Theme
      primaryIconTheme: IconThemeData(
        color: AppColorScheme.darkColorScheme.primary,
        size: 24,
      ),
    );
  }
}
