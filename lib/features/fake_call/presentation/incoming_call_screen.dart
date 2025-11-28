import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import 'in_call_screen.dart';
import '../../../core/theme/color_scheme.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({super.key});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  late FakeCallBloc fakeCallBloc;

  @override
  void initState() {
    super.initState();
    fakeCallBloc = context.read<FakeCallBloc>();
  }

  @override
  Widget build(BuildContext context) {
    // uploaded local image path (for quick preview/testing)
    const uploadedImagePath = '/mnt/data/d7d8bce8-6ca0-463e-9a77-3d7c3ae01a47.png';

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          fakeCallBloc.add(const FakeCallEvent.declineCall());
        }
      },
      child: BlocListener<FakeCallBloc, FakeCallState>(
        listenWhen: (prev, curr) => true,
        listener: (context, state) {
          if (!mounted) return;

          state.maybeWhen(
            inCall: (name, number, image, duration) {
              /// SAFE navigation
              Future.microtask(() {
                if (!mounted) return;
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: fakeCallBloc,
                      child: const InCallScreen(),
                    ),
                  ),
                );
              });
            },
            callEnded: () {
              Future.microtask(() {
                if (!mounted) return;
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                }
              });
            },
            orElse: () {},
          );
        },
        child: Scaffold(
          // theme-aware scaffold color
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: BlocBuilder<FakeCallBloc, FakeCallState>(
            builder: (context, state) {
              final callerName = state.callerName ?? 'Unknown';
              final callerNumber = state.callerNumber ?? '';
              final imagePath = state.callerImagePath;
              final theme = Theme.of(context);
              final colorScheme = theme.colorScheme;
              final isDark = theme.brightness == Brightness.dark;

              // helper: resolved image (uploaded local preview fallback)
              final resolvedImagePath = (imagePath != null && imagePath.isNotEmpty)
                  ? imagePath
                  : (File(uploadedImagePath).existsSync() ? uploadedImagePath : null);

              return SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
                  child: Column(
                    children: [
                      SizedBox(height: 60.h),

                      Text(
                        callerName,
                        style: TextStyle(
                          fontSize: 36.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        callerNumber.isNotEmpty ? "Phone $callerNumber" : "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),

                      const Spacer(),

                      /// Message Button (themed)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.06),
                              blurRadius: isDark ? 10 : 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.message_outlined, size: 20.sp, color: colorScheme.onSurfaceVariant),
                            SizedBox(width: 8.w),
                            Text(
                              "Message",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 60.h),

                      // caller avatar / preview card
                      // Container(
                      //   padding: EdgeInsets.all(18.w),
                      //   decoration: BoxDecoration(
                      //     color: colorScheme.surface,
                      //     borderRadius: BorderRadius.circular(20.r),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color: isDark ? Colors.black.withOpacity(0.45) : Colors.black.withOpacity(0.06),
                      //         blurRadius: isDark ? 18 : 12,
                      //         offset: const Offset(0, 6),
                      //       ),
                      //     ],
                      //   ),
                      //   child: Row(
                      //     children: [
                      //       // avatar circle
                      //       Container(
                      //         width: 72.w,
                      //         height: 72.w,
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           gradient: AppColorScheme.getPrimaryGradient(isDark),
                      //           boxShadow: [
                      //             BoxShadow(
                      //               color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.08),
                      //               blurRadius: 8,
                      //               offset: const Offset(0, 4),
                      //             ),
                      //           ],
                      //         ),
                      //         child: ClipOval(
                      //           child: resolvedImagePath != null && File(resolvedImagePath).existsSync()
                      //               ? Image.file(File(resolvedImagePath), fit: BoxFit.cover)
                      //               : Center(
                      //                   child: Text(
                      //                     callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                      //                     style: TextStyle(
                      //                       fontSize: 28.sp,
                      //                       fontWeight: FontWeight.bold,
                      //                       color: colorScheme.onPrimary,
                      //                     ),
                      //                   ),
                      //                 ),
                      //         ),
                      //       ),

                            // SizedBox(width: 16.w),

                            // // name + number block
                            // Expanded(
                            //   child: Column(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     children: [
                            //       Text(
                            //         callerName,
                            //         style: TextStyle(
                            //           fontSize: 18.sp,
                            //           fontWeight: FontWeight.w600,
                            //           color: colorScheme.onSurface,
                            //         ),
                            //       ),
                            //       SizedBox(height: 6.h),
                            //       Text(
                            //         callerNumber.isNotEmpty ? callerNumber : 'Unknown number',
                            //         style: TextStyle(
                            //           fontSize: 14.sp,
                            //           color: colorScheme.onSurfaceVariant,
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),

                            // small action (decline icon)
                            // IconButton(
                            //   onPressed: () => fakeCallBloc.add(const FakeCallEvent.declineCall()),
                            //   icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
                      //       // ),
                      //     ],
                      //   ),
                      // ),

                      // SizedBox(height: 40.h),

                      // Swipe control (themed)
                      _buildCallActions(colorScheme, isDark),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// Swipe Decline / Answer
  Widget _buildCallActions(ColorScheme colorScheme, bool isDark) {
    final declineColor = Colors.redAccent;
    final answerColor = Colors.greenAccent.shade700;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.02), // subtle background
        borderRadius: BorderRadius.circular(50.r),
        border: Border.all(color: colorScheme.onSurface.withOpacity(0.04)),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Text(
                  "Decline",
                  style: TextStyle(
                    color: declineColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Answer",
                  style: TextStyle(
                    color: answerColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // draggable button center
          Center(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity == null) return;
                if (details.primaryVelocity! < 0) {
                  fakeCallBloc.add(const FakeCallEvent.declineCall());
                } else if (details.primaryVelocity! > 0) {
                  fakeCallBloc.add(const FakeCallEvent.answerCall());
                }
              },
              onTap: () {
                fakeCallBloc.add(const FakeCallEvent.answerCall());
              },
              child: Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  color: answerColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: answerColor.withOpacity(isDark ? 0.28 : 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(Icons.call, color: Colors.white, size: 30.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
