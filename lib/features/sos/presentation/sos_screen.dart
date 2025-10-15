import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../core/utils/constants.dart';
import '../../../core/dependency_injection/di_container.dart' as di;
import '../bloc/sos_bloc.dart';
import '../bloc/sos_event.dart';
import '../bloc/sos_state.dart';

/// SOS emergency screen
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenWrapper extends StatelessWidget {
  const _SosScreenWrapper();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SosBloc>(),
      child: const SosScreen(),
    );
  }
}

class _SosScreenState extends State<SosScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    context.read<SosBloc>().add(const SosStartCountdown());
    _animationController.repeat(reverse: true);
  }

  void _cancelSos() {
    context.read<SosBloc>().add(const SosCancelCountdown());
    _animationController.stop();
    _animationController.reset();
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.check_circle,
          color: AppColorScheme.successColor,
          size: 64.sp,
        ),
        title: const Text('SOS Alert Sent'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(
          Icons.error,
          color: AppColorScheme.sosRedColor,
          size: 64.sp,
        ),
        title: const Text('Failed to Send SOS'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SosBloc>().add(const SosReset());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SosBloc, SosState>(
      listener: (context, state) {
        if (state is SosSuccess) {
          _animationController.stop();
          _animationController.reset();
          _showSuccessDialog('Emergency alerts sent successfully to ${state.response.results.length} contacts');
        } else if (state is SosError) {
          _animationController.stop();
          _animationController.reset();
          _showErrorDialog(state.message);
        } else if (state is SosCancelled) {
          _animationController.stop();
          _animationController.reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('SOS Alert Cancelled'),
              backgroundColor: AppColorScheme.warningColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: BlocBuilder<SosBloc, SosState>(
        builder: (context, state) {
          final isCountingDown = state is SosCountdown;
          final isSending = state is SosSending;
          final isActive = isCountingDown || isSending;
          
          return Scaffold(
            backgroundColor: isActive
                ? AppColorScheme.sosRedColor.withOpacity(0.05)
                : Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text('Emergency SOS'),
              backgroundColor: isActive
                  ? AppColorScheme.sosRedColor
                  : null,
              foregroundColor: isActive ? Colors.white : null,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(AppConstants.defaultPadding.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 
                          AppBar().preferredSize.height - 
                          MediaQuery.of(context).padding.top - 
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Status Display
                        _buildStatusDisplay(state),
                        
                        SizedBox(height: 48.h),
                        
                        // SOS Button
                        _buildSosButton(state),
                        
                        SizedBox(height: 48.h),
                        
                        // Instructions
                        _buildInstructions(state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusDisplay(SosState state) {
    if (state is SosInitial) {
      return Column(
        children: [
          Icon(
            Icons.shield_outlined,
            size: 80.sp,
            color: AppColorScheme.primaryColor,
          ),
          SizedBox(height: 24.h),
          Text(
            'Emergency SOS',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColorScheme.primaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Tap the SOS button to send emergency alerts\nto your trusted contacts',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (state is SosCountdown) {
      return Column(
        children: [
          Text(
            'SENDING SOS ALERT IN',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColorScheme.sosRedColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 32.h),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColorScheme.sosRedColor,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColorScheme.sosRedColor.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '${state.remainingSeconds}',
                      style: TextStyle(
                        fontSize: 72.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColorScheme.sosRedColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else if (state is SosSending) {
      return Column(
        children: [
          SizedBox(
            width: 60.w,
            height: 60.h,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(
                AppColorScheme.sosRedColor,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Sending Emergency Alerts...',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColorScheme.sosRedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Getting your location and notifying contacts',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (state is SosCancelled) {
      return Column(
        children: [
          Icon(
            Icons.cancel_outlined,
            size: 80.sp,
            color: AppColorScheme.warningColor,
          ),
          SizedBox(height: 24.h),
          Text(
            'SOS Alert Cancelled',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColorScheme.warningColor,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildSosButton(SosState state) {
    final isCountingDown = state is SosCountdown;
    final isSending = state is SosSending;
    final isActive = isCountingDown || isSending;
    
    return GestureDetector(
      onTap: isActive ? _cancelSos : _startCountdown,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: isActive ? _scaleAnimation.value : 1.0,
            child: Container(
              width: 220.w,
              height: 220.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isActive 
                    ? AppColorScheme.emergencyGradient
                    : AppColorScheme.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: (isActive 
                        ? AppColorScheme.sosRedColor 
                        : AppColorScheme.primaryColor).withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(110.r),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isActive ? Icons.cancel : Icons.sos,
                          size: 100.sp,
                          color: Colors.white,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          isActive ? 'CANCEL' : 'SOS',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2,
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
    );
  }

  Widget _buildInstructions(SosState state) {
    if (state is SosInitial) {
      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColorScheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColorScheme.primaryColor.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColorScheme.primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'How it works:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColorScheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                _buildInstructionItem('1. Tap the SOS button'),
                _buildInstructionItem('2. 5-second countdown begins'),
                _buildInstructionItem('3. Location shared with contacts'),
                _buildInstructionItem('4. Emergency alerts sent via SMS'),
              ],
            ),
          ),
        ],
      );
    } else if (state is SosCountdown) {
      return Text(
        'Tap CANCEL to stop the alert',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColorScheme.sosRedColor,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      );
    } else if (state is SosSending) {
      return Text(
        'Please wait while we send your emergency alerts...',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      );
    } else if (state is SosCancelled) {
      return Text(
        'Emergency alert was cancelled successfully',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: AppColorScheme.warningColor,
        ),
        textAlign: TextAlign.center,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInstructionItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Icon(
            Icons.check_circle_outline,
            size: 16.sp,
            color: AppColorScheme.successColor,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

}

// Export the wrapper as the main widget
class SosScreenPage extends StatelessWidget {
  const SosScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SosBloc>(),
      child: const SosScreen(),
    );
  }
}
