import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/validators.dart';
import '../../../shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

/// Profile setup screen for new users
class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final state = context.read<AuthBloc>().state;
    state.maybeWhen(
      profileIncomplete: (user) {
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
      },
      authenticated: (user, _) {
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
      },
      orElse: () {},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSaveProfile() {
    if (_formKey.currentState?.validate() ?? false) {
      // Update profile
      context.read<AuthBloc>().add(
        AuthEvent.updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim().isEmpty 
              ? null 
              : _emailController.text.trim(),
        ),
      );
    }
  }

  void _handleCompleteSetup() {
    // Only name is required
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    _saveAndComplete();
  }
  
  void _saveAndComplete() {
    // Save profile first
    _handleSaveProfile();
    
    // Then complete setup
    context.read<AuthBloc>().add(const AuthEvent.completeProfileSetup());
    context.go(AppRoutes.home);
  }

  void _handleSkip() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _handleSkip,
            child: Text(
              'Skip',
              style: TextStyle(
                color: _isLoading 
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                    : Theme.of(context).colorScheme.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          state.when(
            initial: () {},
            unauthenticated: () {
              context.go('/login');
            },
            otpSending: () {},
            otpSent: (phoneNumber, resendCooldown) {},
            verifyingOtp: () {},
            authenticated: (user, isNewUser) {
              setState(() => _isLoading = false);
              context.go('/home');
            },
            profileIncomplete: (user) {
              setState(() {
                _isLoading = false;
              });
            },
            error: (message, phoneNumber) {
              setState(() => _isLoading = false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            loading: () {
              setState(() => _isLoading = true);
            },
          );
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Welcome Icon
                    Center(
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_outline,
                          size: 40.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24.h),
                    
                    // Title
                    Text(
                      'Welcome!',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Let\'s get to know you better',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    
                    SizedBox(height: 48.h),
                    
                    // Name Field (Required)
                    TextFormField(
                      controller: _nameController,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'Enter your full name',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      validator: Validators.validateName,
                      textCapitalization: TextCapitalization.words,
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Email Field (Optional)
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email (Optional)',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    
                    SizedBox(height: 48.h),
                    
                    // Complete Setup Button
                    PrimaryButton(
                      text: 'Complete Setup',
                      onPressed: _isLoading ? null : _handleCompleteSetup,
                      isLoading: _isLoading,
                    ),
                    
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
