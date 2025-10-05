import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_scheme.dart';
import '../../../core/utils/constants.dart';

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
    _NavItem(icon: Icons.home, label: 'Home'),
    _NavItem(icon: Icons.map, label: 'Track'),
    _NavItem(icon: Icons.support_agent, label: 'Support'),
    _NavItem(icon: Icons.person, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildHomeContent(),
          _buildTrackContent(),
          _buildSosContent(),
          _buildSupportContent(),
          _buildProfileContent(),
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
        if (screenIndex == 3) { // Support
          // Navigate to chat screen using the existing route
          context.push(AppRoutes.helpSupport);
        } else if (screenIndex == 4) { // Profile
          context.push(AppRoutes.profile);
        } else {
          setState(() => _selectedIndex = screenIndex);
        }
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
            width: 60.w,
            height: 60.w,
            margin: EdgeInsets.only(top: 5.h),
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
                  Icon(
                    Icons.sos,
                    size: 24.sp,
                    color: Colors.white,
                  ),
                  Text(
                    'SOS',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Content for each tab
  Widget _buildHomeContent() {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            title: const Text('SHE - Safety Help Emergency'),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          
          // Emergency Contacts Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Contacts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  // Emergency contacts cards would go here
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      'Add your emergency contacts here',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Quick Actions Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickActionItem(Icons.call, 'Call'),
                      _buildQuickActionItem(Icons.message, 'Message'),
                      _buildQuickActionItem(Icons.location_on, 'Location'),
                      _buildQuickActionItem(Icons.camera_alt, 'Camera'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Safety Tips Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppConstants.defaultPadding.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Safety Tips',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16.h),
                  // Safety tips cards would go here
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                      ),
                    ),
                    child: Text(
                      'Safety tips and guidelines will appear here',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 30.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  // Placeholder content for other tabs
  Widget _buildTrackContent() {
    return const Center(child: Text('Track Content'));
  }

  Widget _buildSosContent() {
    return const Center(child: Text('SOS Content'));
  }

  Widget _buildSupportContent() {
    return const Center(child: Text('Support Content'));
  }

  Widget _buildProfileContent() {
    return const Center(child: Text('Profile Content'));
  }
}
