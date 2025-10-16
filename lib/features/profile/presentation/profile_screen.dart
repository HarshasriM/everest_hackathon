import 'package:everest_hackathon/core/theme/color_scheme.dart';
import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:everest_hackathon/core/dependency_injection/di_container.dart';
import 'package:everest_hackathon/core/services/app_preferences_service.dart';
import 'package:everest_hackathon/core/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:everest_hackathon/features/auth/bloc/auth_bloc.dart';
import 'package:everest_hackathon/features/auth/bloc/auth_event.dart';
import 'package:everest_hackathon/features/auth/bloc/auth_state.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F6),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Load phone number from preferences; fall back to the hardcoded number
            FutureBuilder<String?>(
              future: DIContainer.instance
                  .get<AppPreferencesService>()
                  .getUserPhoneNumber(),
              builder: (context, snapshot) {
                final phone = snapshot.connectionState == ConnectionState.done
                    ? (snapshot.data ?? '+91 9392235952')
                    : '+91 9392235952';
                return ProfileHeader(
                  phoneNumber: "${phone.substring(0, 3)} ${phone.substring(3)}",
                );

              },
            ),
            const SizedBox(height: 20),
            ProfileActionButtons(),
            const SizedBox(height: 20),
            const SettingsCard(),
            const SizedBox(height: 250),
            const AppVersionFooter(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Reusable Header Widget
class ProfileHeader extends StatelessWidget {
  final String phoneNumber;

  const ProfileHeader({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColorScheme.primaryColor.withAlpha(64),
            const Color(0xFFF0F0F6),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          const Text(
            'Your Account',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            phoneNumber,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

// Reusable Action Buttons Widget
class ProfileActionButtons extends StatelessWidget {
  const ProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ActionButton(
            icon: Icons.edit,
            label: 'Edit Profile',
            color: Colors.pink,
            onTap: () {
              context.push(
                AppRoutes.profileSetup,
                extra: {'isEditMode': true, 'useProfileBloc': true},
              );
            },
          ),
          ActionButton(
            icon: Icons.contacts,
            label: 'Contacts',
            color: Colors.purple,
            onTap: () {
              context.push(AppRoutes.emergencyContacts);
            },
          ),
          ActionButton(
            icon: Icons.headset_mic,
            label: 'Help',
            color: Colors.deepOrange,
            onTap: () {
              context.push(AppRoutes.helpSupport);
            },
          ),
        ],
      ),
    );
  }
}

// Reusable Action Button Widget
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Card Widget
class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingItem(
            icon: Icons.logout_outlined,
            title: 'Logout',
            iconColor: const Color(0xFF4B2E83),
            onTap: () => _showLogoutDialog(context),
          ),
          const DottedDivider(),
          SettingItem(
            icon: Icons.delete_forever_outlined,
            title: 'Delete account',
            iconColor: Colors.redAccent,
            onTap: () => _showDeleteAccountDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    _showConfirmationDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      confirmColor: Colors.red,
      onConfirm: () => _performLogout(context),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    _showConfirmationDialog(
      context: context,
      title: 'Delete account',
      content:
          'Your account will be deleted permanently. Are you sure you want to proceed?',
      confirmText: 'Ok',
      confirmColor: Colors.red,
      onConfirm: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account will be deleted within 7 working days'),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    Color? confirmColor,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => ConfirmationDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
      ),
    );
  }

  void _performLogout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final appPreferences = DIContainer.instance.get<AppPreferencesService>();
    final authBloc = BlocProvider.of<AuthBloc>(context);

    appPreferences
        .clearAuthData()
        .then((_) {
          Logger.info('User ID and session data cleared from app preferences');
          authBloc.add(const AuthEvent.logout());

          authBloc.stream.listen((state) {
            state.maybeWhen(
              unauthenticated: () {
                Navigator.of(context, rootNavigator: true).pop();
                context.go(AppRoutes.login);
              },
              orElse: () {},
            );
          });
        })
        .catchError((error) {
          Logger.error('Error during logout', error: error);
          Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout failed. Please try again.')),
          );
        });
  }
}

// Reusable Setting Item Widget
class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const SettingItem({
    super.key,
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: iconColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF7D6CA0),
            ),
          ],
        ),
      ),
    );
  }
}

// Reusable Dotted Divider Widget
class DottedDivider extends StatelessWidget {
  const DottedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 4.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Color(0xFFDDDDDD)),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

// Reusable Confirmation Dialog Widget
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final Color? confirmColor;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          child: Text(confirmText, style: TextStyle(color: confirmColor)),
        ),
      ],
    );
  }
}

// Reusable App Version Footer Widget
class AppVersionFooter extends StatelessWidget {
  final String version;

  const AppVersionFooter({super.key, this.version = '1.0.0'});

  @override
  Widget build(BuildContext context) {
    return Text(
      'App version $version',
      style: const TextStyle(color: Colors.grey, fontSize: 14),
    );
  }
}
