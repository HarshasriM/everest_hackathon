import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

import '../../../core/utils/validators.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../routes/app_routes.dart';
import '../../../data/models/profile_update_request.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../core/utils/logger.dart';

// Auth imports
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

// Profile imports
import '../bloc/bloc/profile_bloc.dart';
import '../bloc/bloc/profile_event.dart';
import '../bloc/bloc/profile_state.dart';

/// Consolidated profile setup screen for new users
/// Supports both AuthBloc and ProfileBloc workflows
class ProfileSetupScreen extends StatefulWidget {
  final bool useProfileBloc;
  final bool isEditMode;
  
  const ProfileSetupScreen({
    super.key,
    this.useProfileBloc = false,
    this.isEditMode = false,
  });

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  ProfileBloc? _profileBloc;
  final _preferencesService = AppPreferencesService();
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    try {
      // Get userId from preferences service
      _currentUserId = await _preferencesService.getUserId();
      
      // Always initialize ProfileBloc since we're using it for API calls
      _profileBloc = GetIt.instance<ProfileBloc>();
      
      Logger.info('ProfileBloc initialized successfully');
      
      // Trigger rebuild after ProfileBloc is initialized
      if (mounted) {
        setState(() {});
      }
      
      // Always try to load profile data from backend if userId is available
      if (_currentUserId != null) {
        _loadProfileData();
      } else {
        _loadAuthData();
      }
    } catch (e) {
      Logger.error('Failed to initialize ProfileSetupScreen', error: e);
      if (mounted) {
        _showSnackBar('Failed to initialize profile setup. Please try again.', Colors.red);
      }
    }
  }

  void _loadAuthData() {
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

  void _loadProfileData() {
    if (_profileBloc != null && _currentUserId != null) {
      _profileBloc!.add(ProfileEvent.loadProfile(_currentUserId!));
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _profileBloc?.close();
    super.dispose();
  }

  Future<void> _handleSaveProfile() async {
    Logger.info('Starting profile save process');
    
    if (_formKey.currentState?.validate() ?? false) {
      // Ensure we have the current userId
      if (_currentUserId == null) {
        Logger.info('Getting userId from preferences');
        _currentUserId = await _preferencesService.getUserId() ?? 'sdkcjnsakjdcnksjadncj';
      }
      
      Logger.info('Current userId: $_currentUserId, useProfileBloc: ${widget.useProfileBloc}');
      
      if (_currentUserId != null ) {
        Logger.info('Using ProfileBloc to update profile');
        
        final request = ProfileUpdateRequest(
          name: _nameController.text.trim(),
          email: _emailController.text.trim().isEmpty 
              ? null 
              : _emailController.text.trim(),
        );
        _profileBloc!.add(
          ProfileEvent.updateProfile(
            userId: _currentUserId!,
            request: request,
          ),
        );
    
      } else {
        Logger.error('No userId available for profile update');
        // No userId available - show error
        setState(() => _isLoading = false);
        _showSnackBar('Unable to save profile. Please try logging in again.', Colors.red);
      }
    } else {
      Logger.warning('Form validation failed');
      // Form validation failed - stop loading
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCompleteSetup() async {
    // Validate form first
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    
    // Check if name is provided (required field)
    if (_nameController.text.trim().isEmpty) {
      _showSnackBar('Please enter your name', Colors.orange);
      return;
    }
    
    // Set loading state and save profile
    setState(() => _isLoading = true);
    await _handleSaveProfile();
  }
  

  void _handleSkip() {
    context.go(AppRoutes.home);
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _ProfileSetupAppBar(
        isLoading: _isLoading,
        onSkip: _handleSkip,
        showSkip: !widget.isEditMode,
        title: widget.isEditMode ? 'Edit Profile' : 'Complete Your Profile',
      ),
      body: _profileBloc == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : BlocProvider.value(
              value: _profileBloc!,
              child: _ProfileBlocBody(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                isLoading: _isLoading,
                onCompleteSetup: _handleCompleteSetup,
                onLoadingChanged: (loading) => setState(() => _isLoading = loading),
                onDataLoaded: (name, email) {
                  _nameController.text = name;
                  _emailController.text = email ?? '';
                },
                onLoadAuthDataFallback: _loadAuthData,
              ),
            ),
    );
  }
}

// Reusable AppBar Widget
class _ProfileSetupAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoading;
  final VoidCallback onSkip;
  final bool showSkip;
  final String title;

  const _ProfileSetupAppBar({
    required this.isLoading,
    required this.onSkip,
    this.showSkip = true,
    this.title = 'Complete Your Profile',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      actions: showSkip ? [
        TextButton(
          onPressed: isLoading ? null : onSkip,
          child: Text(
            'Skip',
            style: TextStyle(
              color: isLoading 
                  ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3)
                  : Theme.of(context).colorScheme.primary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 8.w),
      ] : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Reusable Profile Form Widget
class _ProfileFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onCompleteSetup;
  final Widget? additionalContent;

  const _ProfileFormContent({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.isLoading,
    required this.onCompleteSetup,
    this.additionalContent,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WelcomeHeader(),
              SizedBox(height: 48.h),
              if (additionalContent != null) ...[additionalContent!, SizedBox(height: 20.h)],
              _NameField(controller: nameController, enabled: !isLoading),
              SizedBox(height: 20.h),
              _EmailField(controller: emailController, enabled: !isLoading),
              SizedBox(height: 48.h),
              PrimaryButton(
                text: 'Complete Setup',
                onPressed: isLoading ? null : onCompleteSetup,
                isLoading: isLoading,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}

// Welcome Header Widget
class _WelcomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
      ],
    );
  }
}

// Name Field Widget
class _NameField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _NameField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
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
    );
  }
}

// Email Field Widget
class _EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;

  const _EmailField({required this.controller, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
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
    );
  }
}


// ProfileBloc Body Widget
class _ProfileBlocBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onCompleteSetup;
  final ValueChanged<bool> onLoadingChanged;
  final Function(String name, String? email) onDataLoaded;
  final VoidCallback onLoadAuthDataFallback;

  const _ProfileBlocBody({
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.isLoading,
    required this.onCompleteSetup,
    required this.onLoadingChanged,
    required this.onDataLoaded,
    required this.onLoadAuthDataFallback,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        state.when(
          initial: () => onLoadingChanged(false),
          loading: () => onLoadingChanged(true),
          loaded: (user) {
            onLoadingChanged(false);
            onDataLoaded(user.name, user.email);
          },
          updated: (user, message) {
            onLoadingChanged(false);
            onDataLoaded(user.name, user.email);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
              ),
            );
            Future.delayed(const Duration(milliseconds: 1000), () {
              if (context.mounted) {
                context.go(AppRoutes.home);
              }
            });
          },
          error: (message) {
            onLoadingChanged(false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            // Fallback to auth data if profile loading fails
            onLoadAuthDataFallback();
          },
        );
      },
      builder: (context, state) {
        final loadingIndicator = state.maybeWhen(
          loading: () => Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: const CircularProgressIndicator(),
            ),
          ),
          orElse: () => null,
        );

        return _ProfileFormContent(
          formKey: formKey,
          nameController: nameController,
          emailController: emailController,
          isLoading: isLoading,
          onCompleteSetup: onCompleteSetup,
          additionalContent: loadingIndicator,
        );
      },
    );
  }
}
