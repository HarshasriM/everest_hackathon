import 'package:everest_hackathon/features/chat/presentation/chat_screen.dart';
import 'package:everest_hackathon/features/fake_call/bloc/fake_call_bloc.dart';
import 'package:everest_hackathon/features/fake_call/presentations/fake_call_input_screen.dart';
import 'package:everest_hackathon/features/fake_call/presentations/fake_call_screen.dart';
import 'package:everest_hackathon/features/fake_call/presentations/incoming_call_screen.dart';
import 'package:everest_hackathon/features/helpline/helpline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/dependency_injection/di_container.dart';
import '../core/services/app_preferences_service.dart';
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
        path: '${AppRoutes.otpVerification}',
        builder: (context, state) {
          // Get phone number from query parameters or extra
          final phoneNumber = state.uri.queryParameters['phone'] ?? 
                             (state.extra as String? ?? '');
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

      //fake call
       GoRoute(
        path: AppRoutes.fake,
        builder: (context, state) => BlocProvider.value(
          value: FakeCallBloc(),
          child:  FakeCallScreen(),
        ),
      ),
      GoRoute(
  path: AppRoutes.incoming,
  builder: (context, state) {
    final bloc = state.extra as FakeCallBloc;
    return BlocProvider.value(
      value: bloc,
      child: const IncomingCallScreen(),
    );
  },
),
//helpline 
GoRoute(
        path: AppRoutes.helpline,
        builder: (context, state) => BlocProvider.value(
          value: FakeCallBloc(),
          child:  HelplineScreen(),
        ),
      ),

      
        // Nested routes

      // Nested routes

      GoRoute(
        path: AppRoutes.helpSupport,
        builder: (context, state) =>
            const ChatScreen(apiKey: "AIzaSyBuB3oUOwBsxhkxrgN-TmAJ3Kild-V9LjQ"),
      ),
      GoRoute(
        path: AppRoutes.fakecallInput,
        builder:(context,state) => FakeCallInputScreen()
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
        builder: (context, state) => BlocProvider.value(
          value: sl<AuthBloc>(),
          child: const HomeScreen(),
        ),
      ),
    ],

    // Redirect logic based on authentication state
    redirect: (context, state) async {
      final authBloc = sl<AuthBloc>();
      final authState = authBloc.state;

      final isOnSplash = state.matchedLocation == '/splash';
      final isOnAuth =
          state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/otp-verification');
      final isOnProfileSetup = state.matchedLocation.startsWith(
        '/profile-setup',
      );

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

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isCheckingAuth = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
    _animationController.forward();
    _checkAuthStatus();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _checkAuthStatus() async {
    try {

      // Get the auth bloc
      final authBloc = sl<AuthBloc>();
      
      // First check if we have stored credentials
      final preferencesService = sl<AppPreferencesService>();
      final hasStoredAuth = await preferencesService.validateStoredAuth();
      
      if (hasStoredAuth) {
        
        
        // If we have stored auth, navigate to home immediately
        // This ensures we don't get stuck at the splash screen
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.go(AppRoutes.home);
          return; // Exit early to avoid waiting for auth check
        }
      }
      
      // Trigger auth status check
      authBloc.add(const AuthEvent.checkAuthStatus());
  
      // Wait for the auth check to complete with a minimum splash duration
      await Future.wait([
        Future.delayed(const Duration(milliseconds: 1000)),
        _waitForAuthState(authBloc),
      ]);
  
      if (!mounted) return;
  
      // Navigate based on auth state
      final state = authBloc.state;
      state.when(
        initial: () => _navigateToLogin(),
        unauthenticated: () => _navigateToLogin(),
        otpSending: () => _navigateToLogin(),
        otpSent: (_, __) => _navigateToLogin(),
        verifyingOtp: () => _navigateToLogin(),
        authenticated: (user, __) {
       
          // Navigate immediately to avoid getting stuck
          context.go(AppRoutes.home);
        },
        profileIncomplete: (user) {
      
          // Navigate immediately to avoid getting stuck
          context.go(AppRoutes.profileSetup);
        },
        error: (message, __) {
         
          _navigateToLogin();
        },
        loading: () {
          // If still loading after waiting, go to login as fallback
          _navigateToLogin();
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      if (mounted) {
       
        await Future.delayed(const Duration(seconds: 1));
        _navigateToLogin();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });
      }
    }
  }
  
  Future<void> _waitForAuthState(AuthBloc authBloc) async {
    // Wait for auth state to resolve from initial/loading
    int attempts = 0;
    while (attempts < 10) { // Max 1 second (10 * 100ms) - shorter timeout
      final state = authBloc.state;
      if (!state.maybeWhen(
        initial: () => true,
        loading: () => true,
        orElse: () => false,
      )) {
        break;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      attempts++;
    }
  }
  
  void _navigateToLogin() {
    if (mounted) {
  
      // Navigate immediately without delay
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with animation
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: _isCheckingAuth ? 120 : 140,
                height: _isCheckingAuth ? 120 : 140,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.shield_outlined,
                  size: _isCheckingAuth ? 80 : 90,
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
              
              // Loading indicator with status
              Column(
                children: [
                  if (_isCheckingAuth)
                    const CircularProgressIndicator()
                
                ],
              ),
            ],
          ),
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
