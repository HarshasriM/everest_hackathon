import 'package:everest_hackathon/features/chat/presentation/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/dependency_injection/di_container.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/bloc/auth_event.dart';
import '../features/auth/bloc/auth_state.dart';
import 'app_routes.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/otp_verification_screen.dart';
import '../features/auth/presentation/profile_setup_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/sos/presentation/sos_screen.dart';
import '../features/profile/presentation/profile_screen.dart';

/// App router configuration using go_router
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  
  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Splash Screen
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AuthBloc>(),
          child: const LoginScreen(),
        ),
      ),
      
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) {
          final phoneNumber = state.extra as String? ?? '';
          return BlocProvider.value(
            value: sl<AuthBloc>(),
            child: OtpVerificationScreen(phoneNumber: phoneNumber),
          );
        },
      ),
      
      GoRoute(
        path: AppRoutes.profileSetup,
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const ProfileSetupScreen(),
        ),
      ),
        // Nested routes
      GoRoute(
        path: AppRoutes.helpSupport,
        builder: (context, state) => const ChatScreen(apiKey: "AIzaSyBuB3oUOwBsxhkxrgN-TmAJ3Kild-V9LjQ"),
      ),
      GoRoute(
        path: AppRoutes.sos,
        builder: (context, state) => const SosScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      // Main App Routes
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      
      ),
    ],
    
    // Redirect logic based on authentication state
    redirect: (context, state) async {
      final authBloc = sl<AuthBloc>();
      final authState = authBloc.state;
      
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuth = state.matchedLocation.startsWith('/login') ||
                      state.matchedLocation.startsWith('/otp-verification');
      final isOnProfileSetup = state.matchedLocation.startsWith('/profile-setup');
      
      if (isOnSplash) {
        // Let splash screen handle navigation
        return null;
      }
      
      return authState.maybeWhen(
        unauthenticated: () {
          // User is not authenticated
          if (!isOnAuth) {
            return AppRoutes.login;
          }
          return null;
        },
        profileIncomplete: (_) {
          // User needs to complete profile
          if (!isOnProfileSetup) {
            return AppRoutes.profileSetup;
          }
          return null;
        },
        authenticated: (_, __) {
          // User is authenticated
          if (isOnAuth || isOnProfileSetup) {
            return AppRoutes.home;
          }
          return null;
        },
        orElse: () => null,
      );
    },
    
    // Error page
  );
}

/// Splash screen widget
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    // Add the auth bloc and check status
    final authBloc = sl<AuthBloc>();
    authBloc.add(const AuthEvent.checkAuthStatus());
    
    // Wait for auth check to complete
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Navigate based on auth state
    final state = authBloc.state;
    state.when(
      initial: () => context.go(AppRoutes.login),
      unauthenticated: () => context.go(AppRoutes.login),
      otpSending: () {},
      otpSent: (_, __) {},
      verifyingOtp: () {},
      authenticated: (_, __) => context.go(AppRoutes.home),
      profileIncomplete: (_) => context.go(AppRoutes.profileSetup),
      error: (_, __) => context.go(AppRoutes.login),
      loading: () {},
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shield_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 24),
            
            // App Name
            Text(
              'SHE',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Safety Help Emergency',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Error screen widget
class ErrorScreen extends StatelessWidget {
  final Exception? error;
  
  const ErrorScreen({super.key, this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'An unexpected error occurred',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
