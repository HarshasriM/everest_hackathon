import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/dependency_injection/di_container.dart' as di;
import 'package:everest_hackathon/core/theme/color_scheme.dart';
import '../../../core/utils/constants.dart';
import '../../../routes/app_routes.dart';
import '../bloc/sos_bloc.dart';
import '../bloc/sos_event.dart';
import '../bloc/sos_state.dart';

/// SOS emergency screen
class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

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

class _SosScreenState extends State<SosScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _holdAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _holdAnimation;

  Timer? _holdTimer;
  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _holdAnimationController = AnimationController(
      duration: const Duration(seconds: 1), // 1 second hold
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

    _holdAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _holdAnimationController,
      curve: Curves.linear,
    ));

    _holdAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startCountdown();
        _resetHold();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _holdAnimationController.dispose();
    _holdTimer?.cancel();
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surface,
        icon: Icon(
          Icons.check_circle,
          color: AppColorScheme.successColor,
          size: 64.sp,
        ),
        title: Text(
          'SOS Alert Sent',
          style: TextStyle(color: cs.onSurface),
        ),
        content: Text(
          message,
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.pop();
            },
            child: Text(
              'OK',
              style: TextStyle(color: cs.primary),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    final lowercaseMessage = message.toLowerCase();
    final isEmergencyContactsError =
        lowercaseMessage.contains('emergency contacts') ||
            lowercaseMessage.contains('no contacts') ||
            lowercaseMessage.contains('contacts found') ||
            lowercaseMessage.contains('add contacts') ||
            lowercaseMessage.contains('no emergency contacts found');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cs.surface,
        icon: Icon(
          isEmergencyContactsError ? Icons.contacts : Icons.error,
          color:
              isEmergencyContactsError ? Colors.orange : AppColorScheme.sosRedColor,
          size: 64.sp,
        ),
        title: Text(
          isEmergencyContactsError ? 'No Emergency Contacts' : 'Failed to Send SOS',
          style: TextStyle(color: cs.onSurface),
        ),
        content: Text(
          message,
          style: TextStyle(color: cs.onSurfaceVariant),
        ),
        actions: [
          if (isEmergencyContactsError) ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.push(AppRoutes.emergencyContacts);
              },
              child: Text(
                'Add Emergency Contacts',
                style: TextStyle(color: cs.primary),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SosBloc>().add(const SosReset());
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
          ] else ...[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<SosBloc>().add(const SosReset());
              },
              child: Text(
                'Try Again',
                style: TextStyle(color: cs.primary),
              ),
            ),
          ],
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
          _showSuccessDialog(
            'Emergency alerts sent successfully to ${state.response.results.length} contacts',
          );
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
          final theme = Theme.of(context);
          final cs = theme.colorScheme;
          final isCountingDown = state is SosCountdown;
          final isSending = state is SosSending;
          final isActive = isCountingDown || isSending;

          return Scaffold(
            backgroundColor:
                isActive ? Colors.black : theme.scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text(
                'Emergency SOS',
                style: TextStyle(
                  color: isActive ? Colors.white : cs.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor:
                  isActive ? AppColorScheme.sosRedColor : theme.scaffoldBackgroundColor,
              foregroundColor: isActive ? Colors.white : cs.onSurface,
              elevation: 0,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: _buildStatusDisplay(state)),
                        SizedBox(height: 48.h),
                        Center(child: _buildSosButton(state)),
                        SizedBox(height: 48.h),
                        Center(child: _buildInstructions(state)),
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
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (state is SosInitial) {
      return Column(
        children: [
          Icon(
            Icons.warning,
            size: 80.sp,
            color: AppColorScheme.sosRedColor,
          ),
          SizedBox(height: 32.h),
          Text(
            'Emergency SOS',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.onSurface,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Press and hold the SOS button for 1\nsecond to send an emergency alert to\nyour contacts',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else if (state is SosCountdown) {
      return Column(
        children: [
          Text(
            'SENDING SOS IN',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColorScheme.sosRedColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 48.h),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Container(
                width: 120.w,
                height: 120.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColorScheme.sosRedColor,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    '${state.remainingSeconds}',
                    style: TextStyle(
                      fontSize: 48.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColorScheme.sosRedColor,
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
            style: theme.textTheme.headlineSmall?.copyWith(
              color: AppColorScheme.sosRedColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Getting your location and notifying contacts',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
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
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColorScheme.warningColor,
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _startHold() {
    if (_isHolding) return;
    setState(() {
      _isHolding = true;
    });
    _holdAnimationController.forward();
  }

  void _resetHold() {
    setState(() {
      _isHolding = false;
    });
    _holdAnimationController.reset();
  }

  Widget _buildSosButton(SosState state) {
    final isCountingDown = state is SosCountdown;
    final isSending = state is SosSending;
    final isActive = isCountingDown || isSending;

    return GestureDetector(
      onLongPressStart: (_) {
        if (!isActive) {
          _startHold();
        }
      },
      onLongPressEnd: (_) {
        if (_isHolding && !isActive) {
          _resetHold();
        }
      },
      onLongPressCancel: () {
        if (_isHolding && !isActive) {
          _resetHold();
        }
      },
      onTap: () {
        if (isActive) {
          _cancelSos();
        }
      },
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _holdAnimation]),
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              if (_isHolding)
                SizedBox(
                  width: 220.w,
                  height: 220.h,
                  child: CircularProgressIndicator(
                    value: _holdAnimation.value,
                    strokeWidth: 6,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                ),
              Container(
                width: 200.w,
                height: 200.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isActive
                        ? [Colors.red, Colors.orange]
                        : _isHolding
                            ? [
                                Colors.red.withOpacity(0.8),
                                Colors.orange.withOpacity(0.8)
                              ]
                            : [Colors.orange, Colors.red],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: Center(
                    child: isActive && isCountingDown
                        ? Icon(
                            Icons.close,
                            size: 80.sp,
                            color: Colors.white,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'SOS',
                                style: TextStyle(
                                  fontSize: 48.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                              if (!isActive && !_isHolding)
                                Text(
                                  'SOS',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInstructions(SosState state) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (state is SosInitial) {
      // keeping it empty for minimal initial screen, as you had
      return const SizedBox.shrink();
    } else if (state is SosCountdown) {
      return Padding(
        padding: EdgeInsets.only(top: 32.h),
        child: Text(
          'Tap the button to cancel',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      );
    } else if (state is SosSending) {
      return Text(
        'Please wait while we send your emergency alerts...',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: cs.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      );
    } else if (state is SosCancelled) {
      return Text(
        'Emergency alert was cancelled successfully',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: AppColorScheme.warningColor,
        ),
        textAlign: TextAlign.center,
      );
    }
    return const SizedBox.shrink();
  }
}
