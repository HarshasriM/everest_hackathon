import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../core/dependency_injection/di_container.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/system_ui_manager.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../routes/app_router.dart';

/// Root application widget
class SHEApp extends StatefulWidget {
  const SHEApp({super.key});

  @override
  State<SHEApp> createState() => _SHEAppState();
}

class _SHEAppState extends State<SHEApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Update system UI when platform brightness changes
    SystemUIManager.onThemeChanged(ThemeMode.system);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X design size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [BlocProvider(create: (_) => sl<AuthBloc>())],
          child: MaterialApp.router(
            title: 'SHE - Safety Help Emergency',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}
