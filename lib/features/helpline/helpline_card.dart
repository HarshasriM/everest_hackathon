import 'package:flutter/material.dart';
import 'package:everest_hackathon/core/theme/color_scheme.dart';

class HelplineCard extends StatefulWidget {
  final String number;
  final String name;
  final IconData icon;
  final Color color; // suggested tint (from screen)
  final Color textColor;
  final VoidCallback onTap;

  const HelplineCard({
    Key? key,
    required this.number,
    required this.name,
    required this.icon,
    required this.color,
    this.textColor = const Color(0xFFE91E63),
    required this.onTap,
  }) : super(key: key);

  @override
  State<HelplineCard> createState() => _HelplineCardState();
}

class _HelplineCardState extends State<HelplineCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Choose sensible colors that adapt to the theme.
    // widget.color is a suggested tint from the parent; fall back to primary if it's transparent.
    final tint = widget.color;
    final primary = cs.primary;
    final onSurface = cs.onSurface;
    final onSurfaceVariant = cs.onSurfaceVariant;

    // textColor param is preserved but prefer theme primary/onPrimary for accessibility
    final effectiveTextColor = widget.textColor == const Color(0xFFE91E63)
        ? primary
        : widget.textColor;

    // card background: in dark mode use surface (slightly elevated),
    // in light mode keep near-white with subtle gradient using the tint.
    final cardDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: isDark ? cs.surface : null,
      gradient: isDark
          ? LinearGradient(
              colors: [
                cs.surface.withOpacity(0.95),
                cs.surface.withOpacity(0.90),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tint.withOpacity(0.14),
                tint.withOpacity(0.06),
              ],
            ),
      border: Border.all(
        color: isDark ? cs.onSurface.withOpacity(0.06) : const Color(0xFFE5E7EB),
        width: 1.2,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withOpacity(0.45) : Colors.black.withOpacity(0.04),
          blurRadius: isDark ? 16 : 16,
          offset: const Offset(0, 6),
        ),
        // subtle colored glow using primary to retain brand feel
        BoxShadow(
          color: effectiveTextColor.withOpacity(isDark ? 0.06 : 0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );

    // Icon container for left icon. Use primary tint in dark mode but preserve contrast.
    final iconContainerDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      gradient: isDark
          ? LinearGradient(
              colors: [
                primary.withOpacity(0.12),
                primary.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : LinearGradient(
              colors: [
                effectiveTextColor.withOpacity(0.95),
                effectiveTextColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
    );

    // Number pill decoration
    final numberPillDecoration = BoxDecoration(
      color: isDark ? primary.withOpacity(0.12) : effectiveTextColor.withOpacity(0.12),
      borderRadius: BorderRadius.circular(6),
    );

    // Call button style
    final callButtonDecoration = BoxDecoration(
      color: isDark ? cs.surface.withOpacity(0.06) : cs.surface,
      borderRadius: BorderRadius.circular(40),
      border: Border.all(color: cs.onSurface.withOpacity(0.06)),
    );

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: cardDecoration,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: widget.onTap,
              splashColor: effectiveTextColor.withOpacity(0.08),
              highlightColor: effectiveTextColor.withOpacity(0.04),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    // Icon Container
                    Container(
                      width: 40,
                      height: 40,
                      decoration: iconContainerDecoration,
                      child: Icon(
                        widget.icon,
                        color: isDark ? primary  : Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Text Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            widget.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                              letterSpacing: -0.3,
                              height: 1.28,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Number pill
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: numberPillDecoration,
                                child: Text(
                                  widget.number,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? primary : effectiveTextColor,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Call Button
                    Container(
                      width: 44,
                      height: 44,
                      decoration: callButtonDecoration,
                      child: Icon(
                        Icons.phone_rounded,
                        color: primary,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
