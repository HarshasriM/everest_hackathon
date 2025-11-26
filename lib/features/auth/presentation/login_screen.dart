import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../../../routes/app_routes.dart';
import '../bloc/auth_state.dart';

/// Login screen with phone number input
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      // Remove any formatting from phone number
      final phoneNumber = _phoneController.text.replaceAll(RegExp(r'\D'), '');
      
      context.read<AuthBloc>().add(
        AuthEvent.sendOtp(phoneNumber: phoneNumber),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.maybeWhen(
            otpSending: () {
              setState(() {
                _isLoading = true;
              });
            },
            otpSent: (phoneNumber, resendCooldown) {
              setState(() {
                _isLoading = false;
              });
              // Make sure we're passing the phone number correctly
              final phone = phoneNumber.trim();
              debugPrint('Navigating to OTP screen with phone: $phone');
              context.go('${AppRoutes.otpVerification}?phone=$phone', extra: phone);
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
                padding: EdgeInsets.all(AppConstants.defaultPadding.w),
                child: Form(
                  key: _formKey,
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 
                          MediaQuery.of(context).padding.top - 
                          AppConstants.defaultPadding.h * 2,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 40.h),
                        
                        // Logo and Title
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 100.w,
                                height: 100.h,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.shield_outlined,
                                  size: 60.sp,
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Text(
                                AppConstants.appName,
                                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                AppConstants.appFullName,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                AppConstants.appTagline,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 60.h),
                        
                        // Welcome Text
                        Text(
                          'Welcome!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Enter your phone number to get started',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        
                        SizedBox(height: 32.h),
                        
                        // Phone Number Input
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          enabled: !_isLoading,
                          autofillHints: const [AutofillHints.telephoneNumberLocal],
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: 'Enter phone number',
                            prefixIcon: const Icon(Icons.phone_outlined),
                            prefixText: '+91 ',
                            counterText: '',
                          ),
                          onChanged: (value) {
                            if (value.length == 10) {
                              _handleSendOtp();
                            }
                          },
                          validator: Validators.validatePhoneNumber,
                          onFieldSubmitted: (_) => _handleSendOtp(),
                        ),
                        
                        SizedBox(height: 24.h),
                        
                        // Send OTP Button
                        PrimaryButton(
                          text: 'Send OTP',
                          onPressed: _isLoading ? null : _handleSendOtp,
                          isLoading: _isLoading,
                        ),
                        
                        SizedBox(height: 40.h),
                        
                        // Terms and Privacy
                        Center( 
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Text.rich(
                              TextSpan(
                                text: 'By continuing, you agree to our\n',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(text: ' and '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
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
}
