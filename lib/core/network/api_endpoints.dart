/// API endpoints for the SHE application
class ApiEndpoints {
  // Authentication
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';
  static const String logout = '/auth/logout';

  // User Management
  static const String getUserProfile = '/users/profile';
  static const String updateProfile = '/users/profile';
  static const String deleteAccount = '/users/delete';
  static const String uploadProfileImage = '/users/profile-image';

  // Emergency Contacts
  static const String getEmergencyContacts = '/contacts';
  static const String addEmergencyContact = '/contacts';
  static const String updateEmergencyContact = '/contacts/{id}';
  static const String deleteEmergencyContact = '/contacts/{id}';

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
