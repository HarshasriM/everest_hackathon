import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/app.dart';
import 'core/dependency_injection/di_setup.dart';
import 'core/theme/system_ui_manager.dart';

/// Main entry point of the SHE application
void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set up initial system UI overlay style (theme-aware)
  SystemUIManager.setupInitialSystemUI();

  // Setup dependency injection
  await setupDependencyInjection();

  // Run the app
  runApp(const SHEApp());
}
