import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/dependency_injection/di_container.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import 'caller_details_screen.dart';
import 'incoming_call_screen.dart';

/// Fake Call screen - Main screen
class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<FakeCallBloc>()..add(const FakeCallEvent.initialize()),
      child: const _FakeCallScreenContent(),
    );
  }
}

class _FakeCallScreenContent extends StatelessWidget {
  const _FakeCallScreenContent();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FakeCallBloc, FakeCallState>(
      listener: (context, state) {
        state.maybeWhen(
          incomingCall: (name, number, image) {
            // Navigate to incoming call screen
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<FakeCallBloc>(),
                  child: const IncomingCallScreen(),
                ),
                fullscreenDialog: true,
              ),
            );
          },

          // callEnded is ignored here (handled elsewhere)
          callEnded: () {},
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message), backgroundColor: Colors.red),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          appBar: const CustomAppBar(),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    'Fake Call',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      // subtle in dark, strong in light
                      color: colorScheme.onSurface.withOpacity(isDark ? 0.92 : 0.95),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Place a fake phone call and pretend you are talking to someone.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Caller Details Card
                  _buildCallerDetailsCard(context, state),

                  const Spacer(),

                  // Get a call button
                  _buildGetCallButton(context, state),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallerDetailsCard(BuildContext context, FakeCallState state) {
    String? savedName;
    String? savedNumber;

    // Read caller details from all relevant states
    state.maybeWhen(
      settingUp: (name, number, image, timer) {
        savedName = name;
        savedNumber = number;
      },
      detailsSaved: (name, number, image, timer) {
        savedName = name;
        savedNumber = number;
      },
      waiting: (name, number, image, remaining) {
        savedName = name;
        savedNumber = number;
      },
      incomingCall: (name, number, image) {
        savedName = name;
        savedNumber = number;
      },
      inCall: (name, number, image, duration) {
        savedName = name;
        savedNumber = number;
      },
      callEnded: () {
        // Keep previous details
      },
      orElse: () {},
    );

    final hasDetails = (savedName != null && savedName!.isNotEmpty);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<FakeCallBloc>(),
              child: const CallerDetailsScreen(),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: colorScheme.surface, // adapts for theme
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(isDark ? 0.35 : 0.06),
              blurRadius: isDark ? 8 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasDetails ? savedName! : 'Caller Details',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    hasDetails ? (savedNumber ?? '') : 'Set caller details',
                    style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.edit, color: colorScheme.primary, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildGetCallButton(BuildContext context, FakeCallState state) {
    final canStartCall = state.maybeWhen(
      settingUp: (name, number, image, timer) => true,
      detailsSaved: (name, number, image, timer) => true,
      waiting: (name, number, image, remaining) => true,
      incomingCall: (name, number, image) => true,
      inCall: (name, number, image, duration) => true,
      orElse: () => false,
    );

    final isWaiting = state.maybeWhen(
      waiting: (name, number, image, remaining) => true,
      orElse: () => false,
    );

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Button background (use primary, but slightly muted in dark)
    final buttonColor = colorScheme.primary;
    final buttonShadowColor = colorScheme.primary.withOpacity(isDark ? 0.18 : 0.3);

    return Center(
      child: Container(
        width: 200.w,
        height: 52.h,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: canStartCall
              ? [
                  BoxShadow(
                    color: buttonShadowColor,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: canStartCall && !isWaiting
                ? () {
                    context
                        .read<FakeCallBloc>()
                        .add(const FakeCallEvent.startFakeCall());
                  }
                : null,
            borderRadius: BorderRadius.circular(28.r),
            child: Center(
              child: isWaiting
                  ? state.maybeWhen(
                      waiting: (name, number, image, remaining) => Text(
                        'Calling in ${remaining}s...',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      orElse: () => const SizedBox(),
                    )
                  : Text(
                      'Get a call',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
