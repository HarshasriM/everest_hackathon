import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/logger.dart';

/// Service for managing app preferences and local storage
/// Uses flutter_secure_storage for sensitive data and SharedPreferences for non-sensitive data
class AppPreferencesService {
  static final AppPreferencesService _instance = AppPreferencesService._internal();
  factory AppPreferencesService() => _instance;
  AppPreferencesService._internal();

  // Storage instances
  late FlutterSecureStorage _secureStorage;
  bool _initialized = false;
  
  // In-memory fallback storage
  final Map<String, dynamic> _memoryStorage = {};

  // Keys for secure storage (sensitive data)
  static const String _keyAuthToken = 'auth_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserData = 'user_data';
  static const String _keyTokenExpiry = 'token_expiry';
  
  // Keys for shared preferences (non-sensitive data)
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
    
    try {
      // Initialize secure storage with basic options
      _secureStorage = const FlutterSecureStorage(
        aOptions: AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );
      
      // Test secure storage by writing and reading a test value
      try {
        await _secureStorage.write(key: 'test_key', value: 'test_value');
        final testValue = await _secureStorage.read(key: 'test_key');
        await _secureStorage.delete(key: 'test_key');
        
        if (testValue != 'test_value') {
          throw Exception('Secure storage validation failed');
        }
      } catch (e) {
        Logger.error('Secure storage validation failed', error: e);
        throw e; // Re-throw to be caught by outer try-catch
      }
      
      _initialized = true;
      Logger.info('AppPreferencesService initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize AppPreferencesService', error: e);
      // Initialize with default secure storage if options fail
      try {
        _secureStorage = const FlutterSecureStorage();
        _initialized = true;
        Logger.info('AppPreferencesService initialized with fallback secure storage');
      } catch (e) {
        Logger.error('Failed to initialize fallback secure storage', error: e);
        // We'll continue with memory storage only
        _initialized = true;
        Logger.info('AppPreferencesService initialized with memory storage only');
      }
    }
  }

  // Ensure initialization
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }

  // Authentication - Secure Storage Methods
  Future<void> saveAuthToken(String token) async {
    try {
      await _ensureInitialized();
      await _secureStorage.write(key: _keyAuthToken, value: token);
      // Also save token expiry (24 hours from now)
      final expiry = DateTime.now().add(const Duration(hours: 24)).toIso8601String();
      await _secureStorage.write(key: _keyTokenExpiry, value: expiry);
      Logger.info('Auth token saved successfully');
    } catch (e) {
      Logger.error('Failed to save auth token', error: e);
      rethrow;
    }
  }

  Future<String?> getAuthToken() async {
    try {
      await _ensureInitialized();
      
      // Check if token exists
      final token = await _secureStorage.read(key: _keyAuthToken);
      if (token == null) return null;
      
      // Check if token is expired
      final expiryStr = await _secureStorage.read(key: _keyTokenExpiry);
      if (expiryStr != null) {
        final expiry = DateTime.parse(expiryStr);
        if (DateTime.now().isAfter(expiry)) {
          Logger.info('Auth token expired, clearing auth data');
          await clearAuthData();
          return null;
        }
      }
      
      return token;
    } catch (e) {
      Logger.error('Failed to get auth token', error: e);
      // If there's an error reading the token (corrupted data), clear it
      await clearAuthData();
      return null;
    }
  }

  Future<void> saveRefreshToken(String token) async {
    try {
      await _ensureInitialized();
      await _secureStorage.write(key: _keyRefreshToken, value: token);
    } catch (e) {
      Logger.error('Failed to save refresh token', error: e);
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      await _ensureInitialized();
      return await _secureStorage.read(key: _keyRefreshToken);
    } catch (e) {
      Logger.error('Failed to get refresh token', error: e);
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    try {
      await _ensureInitialized();
      await _secureStorage.write(key: _keyUserId, value: userId);
      // When saving user ID, also create an auth token
      // This is a simple implementation - in production, use JWT or similar
      final token = 'auth_${userId}_${DateTime.now().millisecondsSinceEpoch}';
      await saveAuthToken(token);
    } catch (e) {
      Logger.error('Failed to save user ID', error: e);
      rethrow;
    }
  }

  Future<String?> getUserId() async {
    try {
      await _ensureInitialized();
      return await _secureStorage.read(key: _keyUserId);
    } catch (e) {
      Logger.error('Failed to get user ID', error: e);
      return null;
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _ensureInitialized();
      final jsonStr = jsonEncode(userData);
      await _secureStorage.write(key: _keyUserData, value: jsonStr);
    } catch (e) {
      Logger.error('Failed to save user data', error: e);
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    try {
      await _ensureInitialized();
      final data = await _secureStorage.read(key: _keyUserData);
      if (data != null && data.isNotEmpty) {
        return jsonDecode(data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      Logger.error('Failed to get user data', error: e);
      // If data is corrupted, clear it
      await _secureStorage.delete(key: _keyUserData);
      return null;
    }
  }

  Future<void> clearAuthData() async {
    try {
      await _ensureInitialized();
      await _secureStorage.delete(key: _keyAuthToken);
      await _secureStorage.delete(key: _keyRefreshToken);
      await _secureStorage.delete(key: _keyUserId);
      await _secureStorage.delete(key: _keyUserData);
      await _secureStorage.delete(key: _keyTokenExpiry);
      Logger.info('Auth data cleared successfully');
    } catch (e) {
      Logger.error('Failed to clear auth data', error: e);
      // Try to delete all secure storage if individual deletes fail
      try {
        await _secureStorage.deleteAll();
      } catch (e) {
        Logger.error('Failed to delete all secure storage', error: e);
      }
    }
  }

  Future<bool> get isAuthenticated async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  // App Settings - Memory storage (non-sensitive)
  Future<void> saveLanguageCode(String languageCode) async {
    await _ensureInitialized();
    _memoryStorage[_keyLanguageCode] = languageCode;
  }

  Future<String> getLanguageCode() async {
    await _ensureInitialized();
    return _memoryStorage[_keyLanguageCode] as String? ?? 'en';
  }

  Future<void> saveThemeMode(String themeMode) async {
    await _ensureInitialized();
    _memoryStorage[_keyThemeMode] = themeMode;
  }

  Future<String> getThemeMode() async {
    await _ensureInitialized();
    return _memoryStorage[_keyThemeMode] as String? ?? 'system';
  }

  Future<void> setFirstLaunch(bool isFirstLaunch) async {
    await _ensureInitialized();
    _memoryStorage[_keyFirstLaunch] = isFirstLaunch;
  }

  Future<bool> isFirstLaunch() async {
    await _ensureInitialized();
    return _memoryStorage[_keyFirstLaunch] as bool? ?? true;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _ensureInitialized();
    _memoryStorage[_keyBiometricEnabled] = enabled;
  }

  Future<bool> isBiometricEnabled() async {
    await _ensureInitialized();
    return _memoryStorage[_keyBiometricEnabled] as bool? ?? false;
  }

  Future<void> setLocationPermission(bool granted) async {
    await _ensureInitialized();
    _memoryStorage[_keyLocationPermission] = granted;
  }

  Future<bool> hasLocationPermission() async {
    await _ensureInitialized();
    return _memoryStorage[_keyLocationPermission] as bool? ?? false;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    await _ensureInitialized();
    _memoryStorage[_keyNotificationEnabled] = enabled;
  }

  Future<bool> isNotificationEnabled() async {
    await _ensureInitialized();
    return _memoryStorage[_keyNotificationEnabled] as bool? ?? true;
  }

  Future<void> setOnboardingCompleted(bool completed) async {
    await _ensureInitialized();
    _memoryStorage[_keyOnboardingCompleted] = completed;
  }

  Future<bool> isOnboardingCompleted() async {
    await _ensureInitialized();
    return _memoryStorage[_keyOnboardingCompleted] as bool? ?? false;
  }

  Future<void> savePanicButtonPosition(Map<String, double> position) async {
    await _ensureInitialized();
    _memoryStorage[_keyPanicButtonPosition] = position;
  }

  Future<Map<String, double>?> getPanicButtonPosition() async {
    try {
      await _ensureInitialized();
      final data = _memoryStorage[_keyPanicButtonPosition];
      if (data != null) {
        if (data is Map) {
          return Map<String, double>.from(data);
        } else if (data is String) {
          final decoded = jsonDecode(data);
          return Map<String, double>.from(decoded);
        }
      }
      return null;
    } catch (e) {
      Logger.error('Failed to get panic button position', error: e);
      return null;
    }
  }

  // Clear all preferences
  Future<void> clearAll() async {
    try {
      await _ensureInitialized();
      // Clear secure storage
      try {
        await _secureStorage.deleteAll();
      } catch (e) {
        Logger.error('Failed to clear secure storage', error: e);
      }
      // Clear memory storage
      _memoryStorage.clear();
      Logger.info('All preferences cleared');
    } catch (e) {
      Logger.error('Failed to clear all preferences', error: e);
      // Ensure memory storage is cleared even if there's an error
      _memoryStorage.clear();
    }
  }

  // Validate stored authentication
  Future<bool> validateStoredAuth() async {
    try {
      await _ensureInitialized();
      
      // Check if we have both token and user ID
      final token = await getAuthToken();
      final userId = await getUserId();
      
      if (token == null || userId == null) {
        return false;
      }
      
      // Check if we have user data
      final userData = await getUserData();
      if (userData == null) {
        // Try to fetch from server if we have userId
        // This will be handled by the repository
        return true;
      }
      
      return true;
    } catch (e) {
      Logger.error('Failed to validate stored auth', error: e);
      return false;
    }
  }

  // Debug helper
  Future<void> printAllPreferences() async {
    if (kDebugMode) {
      await _ensureInitialized();
      print('=== App Preferences ===');
      print('--- Secure Storage ---');
      try {
        final allSecure = await _secureStorage.readAll();
        allSecure.forEach((key, value) {
          if (key.contains('token') || key.contains('password')) {
            print('$key: [REDACTED]');
          } else {
            print('$key: $value');
          }
        });
      } catch (e) {
        print('Error reading secure storage: $e');
      }
      
      print('--- Memory Storage ---');
      _memoryStorage.forEach((key, value) {
        if (key.contains('token') || key.contains('password')) {
          print('$key: [REDACTED]');
        } else {
          print('$key: $value');
        }
      });
      print('====================');
    }
  }
}
