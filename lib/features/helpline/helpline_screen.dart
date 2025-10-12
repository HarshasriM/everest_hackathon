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

  static const Color secondaryColor = Color(0xFF9C27B0);
  static const Color tertiaryColor = Color(0xFFFF5722);
  static const Color backgroundColor = Color(0xFFFAFAFC);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimaryColor = Color(0xFF1A1A2E);
  static const Color textSecondaryColor = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return BlocProvider(
      create: (_) => HelplineBloc()..add(LoadHelplines()),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: CustomAppBar(),
        body: BlocConsumer<HelplineBloc, HelplineState>(
          listener: (context, state) {
            if (state is HelplineError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: tertiaryColor,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HelplineLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              );
            }
            
            if (state is HelplineLoaded) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Professional Header Section
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
                          Row(
                            children: [
                            
                              
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Emergency Support',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: textPrimaryColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Available 24/7 for immediate assistance',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: textSecondaryColor,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: AppColorScheme.primaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColorScheme.primaryColor.withValues(alpha: 0.15),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: AppColorScheme.primaryColor,
                                  size: 17,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Tap any helpline to call instantly',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColorScheme.primaryColor.withValues(alpha: 0.9),
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

                  // Helplines List
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isLargeScreen ? 24 : 20,
                      vertical: 16,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final helpline = state.helplines[index];
                          final colors = [
                            [const Color(0xFFE0F2F1), AppColorScheme.primaryColor.withAlpha(180)],   // soft mint + deep teal
                            [const Color(0xFFD0F0F0), AppColorScheme.secondaryColor.withAlpha(180)], // light teal + teal-green
                            [const Color(0xFFE0F7FA), const Color(0xFF4D6A6D).withAlpha(200)],       // sky aqua + bright cyan
                            [const Color(0xFFE3F2FD), const Color(0xFF0277BD).withAlpha(180)],       // light blue + ocean blue
                          ];
                          final colorPair = colors[index % colors.length];

                          return TweenAnimationBuilder<double>(
                            duration: Duration(
                              milliseconds: 200 + (index * 80),
                            ),
                            tween: Tween(begin: 0.0, end: 1.0),
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
                                    color: colorPair[0],
                                    textColor: colorPair[1],
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

                  // Bottom Spacing
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),

                ],
              );
            }

            // Fallback for other states (including initial state)
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}