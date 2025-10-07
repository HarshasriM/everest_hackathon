import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/constants.dart';
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
  final _addressController = TextEditingController();
  String? _selectedBloodGroup;
  bool _isLoading = false;

  final List<String> _bloodGroups = [
    'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'
  ];

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
        _addressController.text = user.address ?? '';
        _selectedBloodGroup = user.bloodGroup;
      },
      authenticated: (user, _) {
        _nameController.text = user.name;
        _emailController.text = user.email ?? '';
        _addressController.text = user.address ?? '';
        _selectedBloodGroup = user.bloodGroup;
      },
      orElse: () {},
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
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
          address: _addressController.text.trim().isEmpty 
              ? null 
              : _addressController.text.trim(),
          bloodGroup: _selectedBloodGroup,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
        automaticallyImplyLeading: false,
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
              padding: EdgeInsets.all(AppConstants.defaultPadding.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Progress Indicator
                    LinearProgressIndicator(
                      value: _calculateProgress(),
                      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    
                    // Title
                    Text(
                      'Complete Your Profile',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Help us personalize your safety experience',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Personal Information Section
                    Text(
                      'Personal Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    // Name Field (Required)
                    TextFormField(
                      controller: _nameController,
                      enabled: !_isLoading,
                      decoration: const InputDecoration(
                        labelText: 'Full Name *',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: Validators.validateName,
                      textCapitalization: TextCapitalization.words,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Email Field (Optional)
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email (Optional)',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: Validators.validateEmail,
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Blood Group Dropdown (Optional)
                    DropdownButtonFormField<String>(
                      value: _selectedBloodGroup,
                      decoration: const InputDecoration(
                        labelText: 'Blood Group (Optional)',
                        prefixIcon: Icon(Icons.bloodtype_outlined),
                      ),
                      items: _bloodGroups.map((group) {
                        return DropdownMenuItem(
                          value: group,
                          child: Text(group),
                        );
                      }).toList(),
                      onChanged: _isLoading 
                          ? null 
                          : (value) => setState(() => _selectedBloodGroup = value),
                    ),
                    
                    SizedBox(height: 16.h),
                    
                    // Address Field (Optional)
                    TextFormField(
                      controller: _addressController,
                      enabled: !_isLoading,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Address (Optional)',
                        hintText: 'Enter your address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                        alignLabelWithHint: true,
                      ),
                    ),
                    
                    SizedBox(height: 32.h),
                    
                    // Action Buttons
                    PrimaryButton(
                      text: 'Complete Setup',
                      onPressed: _isLoading ? null : _handleCompleteSetup,
                      isLoading: _isLoading,
                    ),
                    
                    SizedBox(height: 12.h),
                    
                    TextButton(
                      onPressed: _isLoading ? null : () => context.go(AppRoutes.home),
                      child: const Text('skip'),
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
  
  double _calculateProgress() {
    double progress = 0.0;
    
    // Name (required - 70%)
    if (_nameController.text.trim().isNotEmpty) {
      progress += 0.7;
    }
    
    // Optional fields (30%)
    double optionalProgress = 0.0;
    int optionalFieldCount = 0;
    
    // Email
    if (_emailController.text.trim().isNotEmpty) {
      optionalProgress += 1;
      optionalFieldCount++;
    }
    
    // Blood Group
    if (_selectedBloodGroup != null) {
      optionalProgress += 1;
      optionalFieldCount++;
    }
    
    // Address
    if (_addressController.text.trim().isNotEmpty) {
      optionalProgress += 1;
      optionalFieldCount++;
    }
    
    // Calculate the average progress for optional fields
    if (optionalFieldCount > 0) {
      progress += 0.3 * (optionalProgress / optionalFieldCount);
    }
    
    return progress;
  }
}
