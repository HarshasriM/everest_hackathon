import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import '../../../core/theme/color_scheme.dart';

class InCallScreen extends StatefulWidget {
  const InCallScreen({super.key});

  @override
  State<InCallScreen> createState() => _InCallScreenState();
}

class _InCallScreenState extends State<InCallScreen> {
  Timer? _timer;
  int _callSeconds = 0;

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    // initialize timer from bloc if available
    final initial = context.read<FakeCallBloc>().state.maybeWhen(
          inCall: (_, __, ___, duration) => duration,
          orElse: () => 0,
        );
    _callSeconds = initial;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _callSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // reference image uploaded by user (local path)
    final uploadedImagePath = '/mnt/data/d7d8bce8-6ca0-463e-9a77-3d7c3ae01a47.png';

    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<FakeCallBloc, FakeCallState>(
        listener: (context, state) {
          state.maybeWhen(
            callEnded: () {
              _timer?.cancel();
              if (Navigator.of(context).mounted && Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
            },
            orElse: () {},
          );
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocBuilder<FakeCallBloc, FakeCallState>(
            builder: (context, state) {
              final callerName = state.callerName ?? 'Unknown';
              final callerNumber = state.callerNumber ?? '';
              final imagePath = state.callerImagePath;

              final displayDuration = _callSeconds;

              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final isDark = theme.brightness == Brightness.dark;

              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),

                    // duration
                    Text(
                      _formatDuration(displayDuration),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // caller name
                    Text(
                      callerName,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    // caller number
                    if (callerNumber.isNotEmpty)
                      Text(
                        'Phone $callerNumber',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                    SizedBox(height: 60.h),

                    // avatar circle (uses gradient in dark/light)
                    Container(
                      width: 140.w,
                      height: 140.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColorScheme.getPrimaryGradient(isDark),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.5)
                                : Colors.black.withOpacity(0.08),
                            blurRadius: isDark ? 8 : 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: (imagePath != null &&
                                imagePath.isNotEmpty &&
                                File(imagePath).existsSync())
                            ? Image.file(File(imagePath), fit: BoxFit.cover)
                            : Center(
                                child: Text(
                                  callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                                  style: TextStyle(
                                    fontSize: 64.sp,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                      ),
                    ),

                    const Spacer(),

                    // bottom control sheet
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.r),
                          topRight: Radius.circular(24.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.45)
                                : Colors.black.withOpacity(0.06),
                            blurRadius: isDark ? 30 : 20,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildCallControls(context),
                          SizedBox(height: 24.h),
                          InkWell(
                            onTap: () {
                              context.read<FakeCallBloc>().add(const FakeCallEvent.endCall());
                              _timer?.cancel();
                              if (Navigator.of(context).mounted && Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                            borderRadius: BorderRadius.circular(32.r),
                            child: Container(
                              width: 160.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                color: colorScheme.error,
                                borderRadius: BorderRadius.circular(32.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.error.withOpacity(isDark ? 0.14 : 0.12),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Icon(
                                Icons.call_end,
                                color: colorScheme.onError,
                                size: 28.sp,
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCallControls(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(icon: Icons.dialpad, label: 'Keypad', colorScheme: colorScheme, isDark: isDark),
        _buildControlButton(icon: Icons.mic, label: 'Mute', colorScheme: colorScheme, isDark: isDark),
        _buildControlButton(icon: Icons.volume_up, label: 'Speaker', colorScheme: colorScheme, isDark: isDark),
        _buildControlButton(icon: Icons.more_vert, label: 'More', colorScheme: colorScheme, isDark: isDark),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return Column(
      children: [
        Container(
          width: 65.w,
          height: 65.w,
          decoration: BoxDecoration(
            color: isDark ? colorScheme.surface : colorScheme.onPrimary.withOpacity(0.98),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.45) : Colors.black.withOpacity(0.08),
                blurRadius: isDark ? 10 : 8,
                offset: const Offset(0, 3),
              )
            ],
            border: Border.all(
              color: isDark ? colorScheme.onSurface.withOpacity(0.06) : Colors.transparent,
            ),
          ),
          child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 28.sp),
        ),
        SizedBox(height: 10.h),
        Text(
          label,
          style: TextStyle(fontSize: 13.sp, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
