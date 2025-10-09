import 'package:everest_hackathon/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './bloc/helpline_bloc.dart';
import './bloc/helpline_event.dart';
import './bloc/helpline_state.dart';
import './helpline_card.dart';

class HelplineScreen extends StatelessWidget {
  const HelplineScreen({super.key});

  static const Color primaryColor = Color(0xFFE91E63); // Pink
  static const Color secondaryColor = Color(0xFF9C27B0); // Purple
  static const Color tertiaryColor = Color(0xFFFF5722); // Orange
  static const Color backgroundColor = Color(0xFFFEF7FF);
  static const Color surfaceColor = Color(0xFFFFFFFF);

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
                      const SizedBox(width: 8),
                      Expanded(child: Text(state.message)),
                    ],
                  ),
                  backgroundColor: tertiaryColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is HelplineLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    ...List.generate(state.helplines.length, (index) {
                      final helpline = state.helplines[index];
                      final colors = [
                        [const Color(0xFFFFF0F6), primaryColor],
                        [const Color(0xFFF3E5F5), secondaryColor],
                        [const Color(0xFFFFF3E0), tertiaryColor],
                        [const Color(0xFFE8F5E9), Colors.green],
                      ];
                      final colorPair = colors[index % colors.length];

                      return Center(
                        child: SizedBox(
                          width: isLargeScreen ? 600 : size.width * 0.9,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
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
                      );
                    }),
                    const SizedBox(height: 100),
                  ],
                ),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: secondaryColor,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading helplines...',
                    style: TextStyle(
                      color: secondaryColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
