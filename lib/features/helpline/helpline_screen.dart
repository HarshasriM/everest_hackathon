import 'package:everest_hackathon/core/theme/color_scheme.dart';
import 'package:everest_hackathon/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/helpline_bloc.dart';
import './bloc/helpline_event.dart';
import './bloc/helpline_state.dart';
import './helpline_card.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return BlocProvider(
      create: (_) => HelplineBloc()..add(LoadHelplines()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: const CustomAppBar(),
        body: BlocConsumer<HelplineBloc, HelplineState>(
          listener: (context, state) {
            if (state is HelplineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.error_outline, color: colorScheme.onError),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.onError,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: colorScheme.error,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HelplineLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
                ),
              );
            }

            if (state is HelplineLoaded) {
              // Theme-aware card colors
              final baseSurface = colorScheme.surface;

              final c1 = isDark
                  ? baseSurface.withOpacity(0.06)
                  : AppColorScheme.primaryColor.withValues(alpha: 0.08);

              final c2 = isDark
                  ? baseSurface.withOpacity(0.05)
                  : const Color(0xFFD0F0F0);

              final c3 = isDark
                  ? baseSurface.withOpacity(0.04)
                  : const Color(0xFFE0F7FA);

              final c4 = isDark
                  ? baseSurface.withOpacity(0.045)
                  : const Color(0xFFE3F2FD);

              final cardColors = [
                [c1, colorScheme.primary],
                [c2, colorScheme.secondary],
                [c3, colorScheme.primary],
                [c4, colorScheme.primary],
              ];

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // HEADER
                  SliverToBoxAdapter(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(
                        isLargeScreen ? 24 : 20,
                        24,
                        isLargeScreen ? 24 : 20,
                        8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Support',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Available 24/7 for immediate assistance',
                            style: TextStyle(
                              fontSize: 13,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // INFO BANNER
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? colorScheme.surface.withOpacity(0.07)
                                  : AppColorScheme.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? colorScheme.onSurface.withOpacity(0.06)
                                    : AppColorScheme.primaryColor.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: colorScheme.primary,
                                  size: 17,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Tap any helpline to call instantly',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.primary.withOpacity(0.95),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // HELPLINE LIST
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 24 : 20,
                      vertical: 16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final helpline = state.helplines[index];
                          final colors = cardColors[index % cardColors.length];

                          return TweenAnimationBuilder<double>(
                            duration: Duration(milliseconds: 200 + (index * 80)),
                            tween: Tween(begin: 0, end: 1),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 15 * (1 - value)),
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isLargeScreen ? 700 : double.infinity,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 14),
                                  child: HelplineCard(
                                    number: helpline.number,
                                    name: helpline.name,
                                    icon: helpline.icon,
                                    color: Colors.white,
                                    textColor: colors[1],
                                    onTap: () {
                                      context.read<HelplineBloc>().add(
                                            CallHelpline(helpline.number),
                                          );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: state.helplines.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 30)),
                ],
              );
            }

            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
            );
          },
        ),
      ),
    );
  }
}
