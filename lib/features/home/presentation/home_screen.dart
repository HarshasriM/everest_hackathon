import 'package:everest_hackathon/features/contacts/presentation/contacts_screen.dart';
import 'package:everest_hackathon/features/track/presentation/track_screen.dart';
import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:everest_hackathon/features/helpline/helpline_screen.dart';
import 'package:everest_hackathon/features/fake_call/presentation/fake_call_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_scheme.dart';

/// Home screen with SOS button and main features
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Bottom navigation item model
class _NavItem {
  final IconData icon;
  final String label;

  _NavItem({required this.icon, required this.label});
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Navigation items (without SOS which will be in the middle)
  final List<_NavItem> _navItems = [
    _NavItem(icon: Icons.my_location, label: 'Track Me'),
    _NavItem(icon: Icons.contacts, label: 'Contacts'),
    _NavItem(icon: Icons.call, label: 'FakeCall'),
    _NavItem(icon: Icons.headset_mic, label: 'Helpline'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildTrackContent(),
          _buildFriendsContent(),
          _buildSosContent(),
          _buildFakeCallContent(),
          _buildHelplineContent(),
        ],
      ),
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // First two items
          _buildNavItem(0, 0),
          _buildNavItem(1, 1),

          // SOS button in the middle
          _buildNavSosButton(),

          // Last two items (index 2 and 3 in navItems, but 3 and 4 in screen stack)
          _buildNavItem(2, 3),
          _buildNavItem(3, 4),
        ],
      ),
    );
  }

  // Build individual nav item
  Widget _buildNavItem(int navIndex, int screenIndex) {
    return InkWell(
      onTap: () {
       
        setState(() => _selectedIndex = screenIndex);
        // }
      },
      child: SizedBox(
        width: 70.w,
        height: 70.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _navItems[navIndex].icon,
              color: _selectedIndex == screenIndex
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            SizedBox(height: 4.h),
            Text(
              _navItems[navIndex].label,
              style: TextStyle(
                fontSize: 12.sp,
                color: _selectedIndex == screenIndex
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build SOS button for the nav bar
  Widget _buildNavSosButton() {
    return SizedBox(
      width: 70.w,
      height: 70.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: 75.w,
            height: 75.w,
            margin: EdgeInsets.only(bottom: 3.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColorScheme.emergencyGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColorScheme.sosRedColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: InkWell(
              onTap: () => context.push(AppRoutes.sos),
              borderRadius: BorderRadius.circular(30.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.sos, size: 36.sp, color: Colors.white),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Track content with Google Maps
  Widget _buildTrackContent() {
    return const TrackScreen();
  }

  Widget _buildFriendsContent() {
    return const ContactsScreen();
  }

  Widget _buildSosContent() {
    return const Center(child: Text('SOS Content'));
  }

  Widget _buildFakeCallContent() {
    return const FakeCallScreen();
  }

  Widget _buildHelplineContent() {
    return const  HelplineScreen();
  }
}
