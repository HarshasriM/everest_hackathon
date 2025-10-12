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
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.95),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColorScheme.primaryColor.withOpacity(0.08),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              // Profile Button with Avatar Style
              _AppBarIconButton(
                icon: Icons.person,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.profile);
                },
                tooltip: 'Profile',
                isAvatar: true,
              ),
              const SizedBox(width: 16),
              
              // App Title with Enhanced Styling
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColorScheme.primaryGradient.createShader(bounds),
                      child: const Text(
                        'SHE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                          height: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Stay Safe, Stay Strong',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              
              // AI Assistant with Badge
              _AppBarIconButton(
                icon: Icons.support_agent,
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push(AppRoutes.helpSupport);
                },
                tooltip: 'AI Assistant',
                showBadge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

/// Enhanced Icon Button for AppBar
class _AppBarIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final String tooltip;
  final bool isAvatar;
  final bool showBadge;

  const _AppBarIconButton({
    required this.icon,
    this.onTap,
    required this.tooltip,
    this.isAvatar = false,
    this.showBadge = false,
  });

  @override
  State<_AppBarIconButton> createState() => _AppBarIconButtonState();
}

class _AppBarIconButtonState extends State<_AppBarIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: widget.isAvatar
                      ? AppColorScheme.primaryGradient
                      : LinearGradient(
                          colors: [
                            AppColorScheme.primaryColor.withOpacity(0.1),
                            AppColorScheme.primaryColor.withOpacity(0.05),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: widget.isAvatar
                        ? Colors.transparent
                        : AppColorScheme.primaryColor.withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColorScheme.primaryColor.withOpacity(0.15),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  widget.icon,
                  size: 24,
                  color: widget.isAvatar
                      ? Colors.white
                      : AppColorScheme.primaryColor,
                ),
              ),
              // Online/Active Badge
              if (widget.showBadge)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00E676), Color(0xFF00C853)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00E676).withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}