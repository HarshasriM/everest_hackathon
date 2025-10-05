import 'package:get_it/get_it.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Service locator helper class
class DIContainer {
  static GetIt get instance => sl;
  
  /// Check if a dependency is registered
  static bool isRegistered<T extends Object>({String? instanceName}) {
    return sl.isRegistered<T>(instanceName: instanceName);
  }
  
  /// Reset all dependencies (useful for testing)
  static Future<void> reset() async {
    await sl.reset();
  }
}
