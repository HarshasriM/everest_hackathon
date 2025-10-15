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

  // Location
  static const String updateLocation = '/location/update';
  static const String shareLocation = '/location/share';
  static const String stopLocationSharing = '/location/stop';
  static const String getNearbyPoliceStations = '/location/nearby/police';
  static const String getNearbyHospitals = '/location/nearby/hospitals';
  static const String getNearbyHelpCenters = '/location/nearby/help-centers';

  // Emergency Contacts
  static String getEmergencyContacts(String userId) => '/api/users/get-emergency-contacts/$userId';
  static const String addEmergencyContact = '/api/users/add-emergency-contact';
  static String updateEmergencyContact(String userId, String contactId) => '/api/users/update/$userId/$contactId';
  static String deleteEmergencyContact(String userId, String contactId) => '/api/users/delete/$userId/$contactId';

  // Helplines
  static const String getHelplines = '/helplines';
  static const String getHelplinesByCategory = '/helplines/{category}';

}
