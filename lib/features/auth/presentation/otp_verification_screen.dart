import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../core/config/environment_config.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// OTP verification screen
class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  
  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  int _resendCooldown = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Log the phone number for debugging
    debugPrint('OTP Screen initialized with phone: ${widget.phoneNumber}');
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendCooldown = 30);
    
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendCooldown--;
          if (_resendCooldown <= 0) {
            timer.cancel();
          }
        });
      }
    });
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text;
    if (otp.length == EnvironmentConfig.otpLength) {
      // Make sure we have a valid phone number
      final phoneNumber = widget.phoneNumber.trim();
      if (phoneNumber.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number is missing. Please go back and try again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      context.read<AuthBloc>().add(
        AuthEvent.verifyOtp(
          phoneNumber: phoneNumber,
          otp: otp,
        ),
      );
    }
  }

  void _handleResendOtp() {
    
    final phoneNumber = widget.phoneNumber.trim();
    if (_resendCooldown <= 0) {
      context.read<AuthBloc>().add(AuthEvent.resendOtp(
        phoneNumber:phoneNumber
      ));
      _startResendTimer();
    }
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50.w,
      height: 56.h,
      textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
        width: 2,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      color: Theme.of(context).colorScheme.primaryContainer,
      border: Border.all(
        color: Theme.of(context).colorScheme.primary,
      ),
    );

    final errorPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(
        color: Theme.of(context).colorScheme.error,
      ),
    );
    // Format phone number for display
    final formattedPhone = widget.phoneNumber.isEmpty ? 'Unknown' : widget.phoneNumber;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            otpSent: (phoneNumber, resendCooldown) {
              setState(() {
                _resendCooldown = resendCooldown;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('OTP sent successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            verifyingOtp: () {
              setState(() {
                _isLoading = true;
              });
            },
            authenticated: (user, isNewUser) {
              setState(() {
                _isLoading = false;
              });
              context.go(AppRoutes.home);
            },
            profileIncomplete: (user) {
              setState(() {
                _isLoading = false;
              });
              context.go(AppRoutes.profileSetup);
            },
            error: (message, phoneNumber) {
              setState(() {
                _isLoading = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            loading: () {
              setState(() {
                _isLoading = true;
              });
            },
            orElse: () {
              setState(() {
                _isLoading = false;
              });
            },
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 
                        MediaQuery.of(context).padding.top - 
                        AppConstants.defaultPadding * 2,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
        
                      // Icon
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            size: 40.sp,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                  
                      SizedBox(height: 32.h),
                      
                      // Title
                      Text(
                        'Enter OTP',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      SizedBox(height: 8.h),
                      
                      // Subtitle
                      Text(
                        'We\'ve sent a 6-digit code to',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        '+91 $formattedPhone',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  
                      SizedBox(height: 40.h),
                      
                      // OTP Input
                      Center(
                        child: Pinput(
                          controller: _otpController,
                          length: EnvironmentConfig.otpLength,
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          errorPinTheme: errorPinTheme,
                          showCursor: true,
                          enabled: !_isLoading,
                          onCompleted: (_) => _handleVerifyOtp(),
                          validator: (value) => Validators.validateOTP(value),
                        ),
                      ),
                      
                      SizedBox(height: 24.h),
                      
                      // Resend OTP
                      Center(
                        child: TextButton(
                          onPressed: _resendCooldown <= 0 && !_isLoading
                              ? _handleResendOtp
                              : null,
                          child: Text(
                            _resendCooldown > 0
                                ? 'Resend OTP in $_resendCooldown seconds'
                                : 'Resend OTP',
                            style: TextStyle(
                              color: _resendCooldown > 0
                                  ? Theme.of(context).colorScheme.onSurfaceVariant
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                  
                      SizedBox(height: 40.h),
                      
                      // Verify Button
                      PrimaryButton(
                        text: 'Verify',
                        onPressed: _isLoading ? null : _handleVerifyOtp,
                        isLoading: _isLoading,
                      ),
                      
                      SizedBox(height: 40.h),
                      
                      // Help Text
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Column(
                            children: [
                              Text(
                                'Didn\'t receive the code?',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              Text(
                                'Check your SMS inbox',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
