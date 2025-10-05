import 'dart:convert';
import 'package:flutter/foundation.dart';

/// Service for managing app preferences and local storage
/// Uses in-memory storage for this demo (replace with SharedPreferences in production)
class AppPreferencesService {
  static final AppPreferencesService _instance = AppPreferencesService._internal();
  factory AppPreferencesService() => _instance;
  AppPreferencesService._internal();

  // In-memory storage for demo (replace with SharedPreferences)
  final Map<String, dynamic> _storage = {};
  bool _initialized = false;

  // Keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _keyEmergencyContacts = 'emergency_contacts';
  static const String _keyLanguageCode = 'language_code';
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyFirstLaunch = 'first_launch';
  static const String _keyBiometricEnabled = 'biometric_enabled';
  static const String _keyLocationPermission = 'location_permission';
  static const String _keyNotificationEnabled = 'notification_enabled';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyPanicButtonPosition = 'panic_button_position';

  Future<void> init() async {
    if (_initialized) return;
    // In production, initialize SharedPreferences here
    // final prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // Authentication
  Future<void> saveAuthToken(String token) async {
    _storage[_keyAuthToken] = token;
  }

  Future<String?> getAuthToken() async {
    return _storage[_keyAuthToken] as String?;
  }

  Future<void> saveRefreshToken(String token) async {
    _storage[_keyRefreshToken] = token;
  }

  Future<String?> getRefreshToken() async {
    return _storage[_keyRefreshToken] as String?;
  }

  Future<void> saveUserId(String userId) async {
    _storage[_keyUserId] = userId;
  }

  Future<String?> getUserId() async {
    return _storage[_keyUserId] as String?;
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    _storage[_keyUserData] = jsonEncode(userData);
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final data = _storage[_keyUserData] as String?;
    if (data != null) {
      return jsonDecode(data) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearAuthData() async {
    _storage.remove(_keyAuthToken);
    _storage.remove(_keyRefreshToken);
    _storage.remove(_keyUserId);
    _storage.remove(_keyUserData);
  }

  Future<bool> get isAuthenticated async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // Emergency Contacts
  Future<void> saveEmergencyContacts(List<Map<String, dynamic>> contacts) async {
    _storage[_keyEmergencyContacts] = jsonEncode(contacts);
  }

  Future<List<Map<String, dynamic>>> getEmergencyContacts() async {
    final data = _storage[_keyEmergencyContacts] as String?;
    if (data != null) {
      final decoded = jsonDecode(data);
      return List<Map<String, dynamic>>.from(decoded);
    }
    return [];
  }

  // App Settings
  Future<void> saveLanguageCode(String languageCode) async {
    _storage[_keyLanguageCode] = languageCode;
  }

  Future<String> getLanguageCode() async {
    return _storage[_keyLanguageCode] as String? ?? 'en';
  }

  Future<void> saveThemeMode(String themeMode) async {
    _storage[_keyThemeMode] = themeMode;
  }

  Future<String> getThemeMode() async {
    return _storage[_keyThemeMode] as String? ?? 'system';
  }

  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    _storage[_keyFirstLaunch] = isFirstLaunch;
  }

  Future<bool> isFirstLaunch() async {
    return _storage[_keyFirstLaunch] as bool? ?? true;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    _storage[_keyBiometricEnabled] = enabled;
  }

  Future<bool> isBiometricEnabled() async {
    return _storage[_keyBiometricEnabled] as bool? ?? false;
  }

  Future<void> setLocationPermission(bool granted) async {
    _storage[_keyLocationPermission] = granted;
  }

  Future<bool> hasLocationPermission() async {
    return _storage[_keyLocationPermission] as bool? ?? false;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    _storage[_keyNotificationEnabled] = enabled;
  }

  Future<bool> isNotificationEnabled() async {
    return _storage[_keyNotificationEnabled] as bool? ?? true;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    _storage[_keyOnboardingCompleted] = completed;
  }

  Future<bool> isOnboardingCompleted() async {
    return _storage[_keyOnboardingCompleted] as bool? ?? false;
  }

  Future<void> savePanicButtonPosition(Map<String, double> position) async {
    _storage[_keyPanicButtonPosition] = jsonEncode(position);
  }

  Future<Map<String, double>?> getPanicButtonPosition() async {
    final data = _storage[_keyPanicButtonPosition] as String?;
    if (data != null) {
      final decoded = jsonDecode(data);
      return Map<String, double>.from(decoded);
    }
    return null;
  }

  // Clear all preferences
  Future<void> clearAll() async {
    _storage.clear();
  }

  // Debug helper
  void printAllPreferences() {
    if (kDebugMode) {
      print('=== App Preferences ===');
      _storage.forEach((key, value) {
        print('$key: $value');
      });
      print('====================');
    }
  }
}
