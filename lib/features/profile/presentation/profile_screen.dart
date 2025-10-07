import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/dependency_injection/di_container.dart';
import '../../../core/utils/constants.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/widgets/section_title.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../auth/bloc/auth_state.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () {
                // TODO: Navigate to settings
              },
            ),
          ],
        ),
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.maybeWhen(
              unauthenticated: () {
                // Navigate to login after successful logout
                context.go(AppRoutes.login);
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final user = state.maybeWhen(
                authenticated: (user, _) => user,
                profileIncomplete: (user) => user,
                orElse: () => null,
              );
              
              if (user == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppConstants.defaultPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Header
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50.r,
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                          child: Text(
                            user.name.isNotEmpty 
                                ? user.name[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 36.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          user.phoneNumber,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // Personal Information
                  SectionTitle(title: 'Personal Information'),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            icon: Icons.email_outlined,
                            title: 'Email',
                            value: user.email ?? 'Not set',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // App Settings
                  SectionTitle(title: 'App Settings'),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            context,
                            icon: Icons.language,
                            title: 'Language',
                            value: _getLanguageName(user.settings.languageCode),
                            showArrow: true,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            context,
                            icon: Icons.notifications_outlined,
                            title: 'Notifications',
                            value: user.settings.notificationsEnabled ? 'On' : 'Off',
                            showArrow: true,
                          ),
                          _buildDivider(),
                          _buildInfoRow(
                            context,
                            icon: Icons.shield_outlined,
                            title: 'Biometric Lock',
                            value: user.settings.biometricLock ? 'On' : 'Off',
                            showArrow: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24.h),
                  
                  // Account Actions
                  SectionTitle(title: 'Account'),
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        children: [
                          _buildActionRow(
                            context,
                            icon: Icons.edit_outlined,
                            title: 'Edit Profile',
                            onTap: () {
                              context.go(AppRoutes.profileSetup);
                            },
                          ),
                          _buildDivider(),
                          _buildActionRow(
                            context,
                            icon: Icons.contact_phone_outlined,
                            title: 'Emergency Contacts',
                            onTap: () {
                              // TODO: Navigate to emergency contacts
                            },
                          ),
                          _buildDivider(),
                          _buildActionRow(
                            context,
                            icon: Icons.logout,
                            title: 'Logout',
                            color: Theme.of(context).colorScheme.error,
                            onTap: () {
                              _showLogoutDialog(context);
                            },
                          ),
                          _buildDivider(),
                          _buildActionRow(
                            context,
                            icon: Icons.delete_outline,
                            title: 'Delete Account',
                            color: Theme.of(context).colorScheme.error,
                            onTap: () {
                              _showDeleteAccountDialog(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 32.h),
                  
                  // App Version
                  Center(
                    child: Text(
                      'Version ${AppConstants.appVersion}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            );
            },
          ),
        ),
      ),
    );
  }
  
  String _getLanguageName(String code) {
    return AppConstants.languageNames[code] ?? 'English';
  }
  
  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool showArrow = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24.sp,
            color: Theme.of(context).colorScheme.primary,
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
  
  Widget _buildActionRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDivider() {
    return Divider(height: 1.h);
  }
  
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthEvent.logout());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(const AuthEvent.deleteAccount());
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
