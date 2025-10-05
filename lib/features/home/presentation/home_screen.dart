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

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<_BottomNavItem> _navItems = [
    _BottomNavItem(icon: Icons.home, label: 'Home'),
    _BottomNavItem(icon: Icons.map, label: 'Track'),
    _BottomNavItem(icon: Icons.emergency, label: 'SOS'),
    _BottomNavItem(icon: Icons.support_agent, label: 'Support'),
    _BottomNavItem(icon: Icons.person, label: 'Profile'),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            // Navigate to SOS screen
            context.push('/home/sos');
          } else if (index == 4) {
            // Navigate to Profile screen
            context.push('/home/profile');
          } else {
            setState(() => _selectedIndex = index);
          }
        },
        items: _navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
      floatingActionButton: _buildSosButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

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
          
          // Content
          SliverPadding(
            padding: EdgeInsets.all(AppConstants.defaultPadding.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Welcome Card
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back!',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your safety is our priority',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Quick Actions
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.w,
                  crossAxisSpacing: 16.w,
                  childAspectRatio: 1.2,
                  children: [
                    _buildFeatureCard(
                      icon: Icons.phone_in_talk,
                      title: 'Fake Call',
                      subtitle: 'Simulate incoming call',
                      color: Colors.purple,
                      onTap: () {},
                    ),
                    _buildFeatureCard(
                      icon: Icons.location_on,
                      title: 'Share Location',
                      subtitle: 'Share live location',
                      color: Colors.blue,
                      onTap: () {},
                    ),
                    _buildFeatureCard(
                      icon: Icons.local_hospital,
                      title: 'Helplines',
                      subtitle: 'Emergency contacts',
                      color: Colors.green,
                      onTap: () {},
                    ),
                    _buildFeatureCard(
                      icon: Icons.report,
                      title: 'Report',
                      subtitle: 'File a report',
                      color: Colors.orange,
                      onTap: () {},
                    ),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Safety Tips
                Text(
                  'Safety Tips',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: const Text('Personal Safety Tips'),
                    subtitle: const Text('Learn how to stay safe'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                ),
                
                SizedBox(height: 100.h), // Space for FAB
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackContent() {
    return const Center(
      child: Text('Track Me Feature - Coming Soon'),
    );
  }

  Widget _buildSosContent() {
    return const Center(
      child: Text('SOS Screen'),
    );
  }

  Widget _buildSupportContent() {
    return const Center(
      child: Text('Support & AI Assistant - Coming Soon'),
    );
  }

  Widget _buildProfileContent() {
    return const Center(
      child: Text('Profile Screen'),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSosButton() {
    return Container(
      width: 80.w,
      height: 80.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColorScheme.emergencyGradient,
        boxShadow: [
          BoxShadow(
            color: AppColorScheme.sosRedColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => context.push('/home/sos'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sos,
              size: 32.sp,
              color: Colors.white,
            ),
            Text(
              'SOS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final String label;

  _BottomNavItem({required this.icon, required this.label});
}
