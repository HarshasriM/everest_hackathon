import 'package:everest_hackathon/core/theme/color_scheme.dart';
import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// Custom AppBar for SHE - Woman Safety Application
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({
    super.key,
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
