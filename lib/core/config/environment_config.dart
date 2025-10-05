/// Environment configuration for different deployment modes
/// Contains base URLs, API keys, and other environment-specific settings
class EnvironmentConfig {
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static const bool isProduction = environment == 'production';
  static const bool isDevelopment = environment == 'development';
  static const bool isStaging = environment == 'staging';

  // API Base URLs
  static String get baseUrl {
    switch (environment) {
      case 'production':
        return 'https://api.she-safety.com';
      case 'staging':
        return 'https://staging-api.she-safety.com';
      default:
        return 'https://dev-api.she-safety.com';
    }
  }

  // Google Maps API Key (Replace with actual key)
  static const String googleMapsApiKey = 'YOUR_GOOGLE_MAPS_API_KEY';

  // Emergency Services Numbers
  static const String emergencyPolice = '100';
  static const String emergencyAmbulance = '108';
  static const String womenHelpline = '1091';
  static const String childHelpline = '1098';

  // Timeouts
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // OTP Configuration
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 5;
  static const int otpResendDelaySeconds = 30;

  // Location Settings
  static const double defaultLatitude = 28.6139; // Delhi
  static const double defaultLongitude = 77.2090;
  static const double mapZoomLevel = 14.0;

  // Feature Flags
  static const bool enableAIAssistant = true;
  static const bool enableFakeCall = true;
  static const bool enableLiveTracking = true;
  static const bool enableOfflineMode = true;

  // App Version
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;
}
