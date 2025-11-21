import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';

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
          backgroundColor: Colors.white,
          body: BlocBuilder<FakeCallBloc, FakeCallState>(
            builder: (context, state) {
              final callerName = state.callerName ?? 'Unknown';
              final callerNumber = state.callerNumber ?? '';
              final imagePath = state.callerImagePath;

              final displayDuration = _callSeconds;

              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      _formatDuration(displayDuration),
                      style: TextStyle(
                        fontSize: 18.sp,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    Text(
                      callerName,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8.h),

                    if (callerNumber.isNotEmpty)
                      Text(
                        'Phone $callerNumber',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),

                    SizedBox(height: 60.h),

                    Container(
                      width: 140.w,
                      height: 140.w,
                      decoration: const BoxDecoration(
                        color: Color(0xFF80DEEA),
                        shape: BoxShape.circle,
                      ),
                      child: (imagePath != null && imagePath.isNotEmpty && File(imagePath).existsSync())
                          ? ClipOval(child: Image.file(File(imagePath), fit: BoxFit.cover))
                          : Center(
                              child: Text(
                                callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                                style: TextStyle(fontSize: 64.sp, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                            ),
                    ),

                    const Spacer(),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: 35.h, horizontal: 20.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F0F6),
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildCallControls(context),
                          SizedBox(height: 30.h),
                          InkWell(
                            onTap: () {
                              context.read<FakeCallBloc>().add(const FakeCallEvent.endCall());
                              _timer?.cancel();
                              if (Navigator.of(context).mounted && Navigator.of(context).canPop()) {
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              width: 160.w,
                              height: 56.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD32F2F),
                                borderRadius: BorderRadius.circular(32.r),
                                boxShadow: [
                                  BoxShadow(color: const Color(0xFFD32F2F).withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 2)),
                                ],
                              ),
                              child: Center(child: Icon(Icons.call_end, color: Colors.white, size: 28.sp)),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildControlButton(Icons.dialpad, 'Keypad'),
        _buildControlButton(Icons.mic, 'Mute'),
        _buildControlButton(Icons.volume_up, 'Speaker'),
        _buildControlButton(Icons.more_vert, 'More'),
      ],
    );
  }

  Widget _buildControlButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 65.w,
          height: 65.w,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Icon(icon, color: Colors.grey[800], size: 28.sp),
        ),
        SizedBox(height: 10.h),
        Text(label, style: TextStyle(fontSize: 13.sp, color: Colors.grey[700], fontWeight: FontWeight.w500)),
      ],
    );
  }
}
