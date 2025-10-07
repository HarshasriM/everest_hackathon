/// Application constants
class AppConstants {
  // App Info
  static const String appName = 'SHE';
  static const String appFullName = 'Safety Help Emergency';
  static const String appTagline = 'Your safety, Our Priority';
  static const String appVersion = '1.0.0';
  
  // Durations
  static const Duration splashDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration otpResendDelay = Duration(seconds: 30);
  static const Duration sosButtonDelay = Duration(seconds: 3);
  static const Duration locationUpdateInterval = Duration(seconds: 10);
  
  // Sizes
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;
  static const double iconSize = 24.0;
  static const double avatarRadius = 40.0;
  
  // Emergency Messages
  static const String defaultSosMessage = 'EMERGENCY! I need help. My current location is: ';
  static const String sosMessageTemplate = 'SOS Alert from {name}. Location: {location}. Time: {time}';
  
  // Supported Languages
  static const List<String> supportedLanguages = <String>[
    'en',
    'hi',
    'te',
    'kn',
  ];
  static const Map<String, String> languageNames = <String, String>{
    'en': 'English',
    'hi': 'हिंदी',
    'te': 'తెలుగు',
    'kn': 'ಕನ್ನಡ',
  };
  
  // Report categories
  static const List<String> reportCategories = <String>[
    'Harassment',
    'Stalking',
    'Domestic Violence',
    'Eve Teasing',
    'Cybercrime',
    'Workplace Harassment',
    'Other',
  ];
  
  // Helpline categories
  static const Map<String, List<Map<String, String>>> helplines = <String, List<Map<String, String>>>{
    'Emergency': <Map<String, String>>[
      {'name': 'Police', 'number': '100'},
      {'name': 'Women Helpline', 'number': '1091'},
      {'name': 'Emergency Response', 'number': '112'},
    ],
    'Support': <Map<String, String>>[
      {'name': 'NCW Helpline', 'number': '7827170170'},
      {'name': 'Child Helpline', 'number': '1098'},
      {'name': 'Domestic Violence', 'number': '181'},
    ],
    'Medical': <Map<String, String>>[
      {'name': 'Ambulance', 'number': '108'},
      {'name': 'Medical Helpline', 'number': '104'},
    ],
  };
  
  // Fake call options
  static const List<Map<String, String>> fakeCallOptions = <Map<String, String>>[
    {'name': 'Mom', 'delay': '5'},
    {'name': 'Dad', 'delay': '10'},
    {'name': 'Boss', 'delay': '15'},
    {'name': 'Doctor', 'delay': '30'},
    {'name': 'Police Station', 'delay': '60'},
  ];
  
  // Safety tips categories
  static const List<String> safetyTipCategories = <String>[
    'Personal Safety',
    'Travel Safety',
    'Online Safety',
    'Home Safety',
    'Workplace Safety',
    'Emergency Preparedness',
  ];
  
  // Map markers
  static const String userMarker = 'assets/markers/user_location.png';
  static const String policeMarker = 'assets/markers/police_station.png';
  static const String hospitalMarker = 'assets/markers/hospital.png';
  static const String safeSpaceMarker = 'assets/markers/safe_space.png';
  
  // Asset paths
  static const String logoPath = 'assets/images/logo.png';
  static const String onboardingImage1 = 'assets/images/onboarding_1.png';
  static const String onboardingImage2 = 'assets/images/onboarding_2.png';
  static const String onboardingImage3 = 'assets/images/onboarding_3.png';
  static const String sosButtonImage = 'assets/images/sos_button.png';
  
  // Error messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection. Please check your network.';
  static const String timeoutError = 'Request timed out. Please try again.';
  static const String locationError = 'Unable to get your location. Please enable location services.';
  static const String permissionError = 'Permission denied. Please grant the required permissions.';
}
