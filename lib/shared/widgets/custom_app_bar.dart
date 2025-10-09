import 'package:everest_hackathon/core/theme/color_scheme.dart';
import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Custom AppBar for SHE - Woman Safety Application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  final VoidCallback? onLanguageTap;
  final String? selectedLanguage;

  const CustomAppBar({
    super.key,
    this.onLanguageTap,
    this.selectedLanguage = 'EN',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              // Profile Icon
              _AppBarIconButton(
                icon: Icons.person,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.profile);
                },
                tooltip: 'Profile',
              ),
              const SizedBox(width: 20),
              // App Title
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColorScheme.primaryGradient.createShader(bounds),
                  child: const Text(
                    'SHE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              // Language Switcher
              _LanguageSwitcher(
                selectedLanguage: selectedLanguage!,
                onTap: onLanguageTap,
              ),
              const SizedBox(width: 16),
              // AI Assistant Icon
              _AppBarIconButton(
                icon: Icons.smart_toy_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.helpSupport);
                },
                tooltip: 'AI Assistant',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);
}

/// Simple Icon Button for AppBar
class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;

  const _AppBarIconButton({
    required this.icon,
    this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: Icon(
              icon,
              size: 26,
              color: AppColorScheme.primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Language Switcher
class _LanguageSwitcher extends StatelessWidget {
  final String selectedLanguage;
  final VoidCallback? onTap;

  const _LanguageSwitcher({
    required this.selectedLanguage,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Change Language',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            print('Language switcher tapped - Current: $selectedLanguage');
            onTap?.call();
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColorScheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.language_rounded,
                  color: AppColorScheme.primaryColor,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  selectedLanguage,
                  style: const TextStyle(
                    color: AppColorScheme.primaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
