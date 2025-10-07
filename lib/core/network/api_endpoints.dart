/// API endpoints for the SHE application
class ApiEndpoints {
  // Authentication
  static const String sendOtp = '/api/auth/send-otp';
  static const String verifyOtp = '/api/auth/verify-otp';
  static const String refreshToken = '/api/auth/refresh-token';
  static const String logout = '/api/auth/logout';

  // User Management
  static String getUserProfile(String userId) => '/api/users/$userId';
  static String updateProfile(String userId) => '/api/users/$userId';
  static const String deleteAccount = '/api/users/delete';
  static const String uploadProfileImage = '/api/users/profile-image';

  // SOS
  static const String triggerSos = '/sos/trigger';
  static const String cancelSos = '/sos/cancel';
  static const String getSosHistory = '/sos/history';
  static const String getSosStatus = '/sos/status/{id}';

  // Location
  static const String updateLocation = '/location/update';
  static const String shareLocation = '/location/share';
  static const String stopLocationSharing = '/location/stop';
  static const String getNearbyPoliceStations = '/location/nearby/police';
  static const String getNearbyHospitals = '/location/nearby/hospitals';
  static const String getNearbyHelpCenters = '/location/nearby/help-centers';

  // Reports
  static const String createReport = '/reports';
  static const String getReports = '/reports';
  static const String getReportById = '/reports/{id}';
  static const String updateReport = '/reports/{id}';
  static const String deleteReport = '/reports/{id}';

  // Safety Tips
  static const String getSafetyTips = '/safety-tips';
  static const String getSafetyTipById = '/safety-tips/{id}';

  // AI Assistant
  static const String chatWithNiya = '/ai/chat';
  static const String getAiSuggestions = '/ai/suggestions';

  // Helplines
  static const String getHelplines = '/helplines';
  static const String getHelplinesByCategory = '/helplines/{category}';

  // Feedback
  static const String submitFeedback = '/feedback';
  static const String getFeedbackHistory = '/feedback/history';

  // Notifications
  static const String registerDeviceToken = '/notifications/register';
  static const String getNotifications = '/notifications';
  static const String markNotificationRead = '/notifications/{id}/read';
}
