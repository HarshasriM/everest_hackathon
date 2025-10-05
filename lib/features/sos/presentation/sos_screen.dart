import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../core/utils/constants.dart';

/// SOS emergency screen
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  Timer? _countdownTimer;
  int _countdown = 5;
  bool _isActivated = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    setState(() {
      _isActivated = true;
      _countdown = 5;
    });
    
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown <= 0) {
          timer.cancel();
          _sendSosAlert();
        }
      });
    });
  }

  void _cancelSos() {
    _countdownTimer?.cancel();
    setState(() {
      _isActivated = false;
      _countdown = 5;
    });
  }

  void _sendSosAlert() {
    // TODO: Implement actual SOS alert sending
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('SOS Alert Sent!'),
        backgroundColor: Colors.green,
      ),
    );
    
    // Navigate back after sending
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isActivated 
          ? AppColorScheme.sosRedColor.withOpacity(0.1)
          : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        backgroundColor: _isActivated 
            ? AppColorScheme.sosRedColor
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppConstants.defaultPadding.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Instructions
              if (!_isActivated) ...[
                Icon(
                  Icons.warning_amber_rounded,
                  size: 64.sp,
                  color: AppColorScheme.warningColor,
                ),
                SizedBox(height: 24.h),
                Text(
                  'Emergency SOS',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Press and hold the SOS button for 3 seconds to send an emergency alert to your contacts',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
              ],
              
              // Countdown Display
              if (_isActivated) ...[
                Text(
                  'SENDING SOS IN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColorScheme.sosRedColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24.h),
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColorScheme.sosRedColor,
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$_countdown',
                      style: TextStyle(
                        fontSize: 64.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColorScheme.sosRedColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
              ],
              
              // SOS Button
              GestureDetector(
                onLongPress: _isActivated ? null : _startCountdown,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isActivated ? _scaleAnimation.value : 1.0,
                      child: Container(
                        width: 200.w,
                        height: 200.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColorScheme.emergencyGradient,
                          boxShadow: [
                            BoxShadow(
                              color: AppColorScheme.sosRedColor.withOpacity(0.4),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(100.r),
                            onTap: _isActivated ? _cancelSos : null,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _isActivated ? Icons.cancel : Icons.sos,
                                    size: 80.sp,
                                    color: Colors.white,
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    _isActivated ? 'CANCEL' : 'SOS',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              SizedBox(height: 48.h),
              
              // Quick Actions
              if (!_isActivated)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildQuickAction(
                      icon: Icons.phone,
                      label: 'Call Police',
                      onTap: () {},
                    ),
                    _buildQuickAction(
                      icon: Icons.location_on,
                      label: 'Share Location',
                      onTap: () {},
                    ),
                    _buildQuickAction(
                      icon: Icons.camera_alt,
                      label: 'Record',
                      onTap: () {},
                    ),
                  ],
                ),
              
              // Cancel Instructions
              if (_isActivated) ...[
                Text(
                  'Tap the button to cancel',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onTap,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
