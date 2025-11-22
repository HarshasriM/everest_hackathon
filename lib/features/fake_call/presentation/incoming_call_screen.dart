import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import 'in_call_screen.dart';

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
          backgroundColor: Colors.grey[100],
          body: BlocBuilder<FakeCallBloc, FakeCallState>(
            builder: (context, state) {
             final callerName = state.callerName ?? 'Unknown';
             final callerNumber = state.callerNumber ?? '';

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
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        callerNumber.isNotEmpty ? "Phone $callerNumber" : "",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[700],
                        ),
                      ),

                      const Spacer(),

                      /// Message Button
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.message_outlined, size: 20.sp, color: Colors.grey[700]),
                            SizedBox(width: 8.w),
                            Text(
                              "Message",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: 60.h),
                      _buildCallActions(),
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
  Widget _buildCallActions() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE8E8E8),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Decline",
                  style: TextStyle(
                    color: Colors.red[700],
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
                    color: Colors.green[700],
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          Center(
            child: GestureDetector(
              onHorizontalDragEnd: (details) {
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
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
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
