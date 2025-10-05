import '../entities/auth_entity.dart';
import '../entities/user_entity.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Send OTP to phone number
  Future<void> sendOtp(OtpRequestEntity request);
  
  /// Verify OTP and authenticate user
  Future<AuthEntity> verifyOtp(OtpVerificationEntity verification);
  
  /// Get current authenticated user
  Future<UserEntity?> getCurrentUser();
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Refresh authentication token
  Future<AuthEntity> refreshToken(String refreshToken);
  
  /// Logout user
  Future<void> logout();
  
  /// Update user profile
  Future<UserEntity> updateProfile(UserEntity user);
  
  /// Add emergency contact
  Future<void> addEmergencyContact(EmergencyContactEntity contact);
  
  /// Remove emergency contact
  Future<void> removeEmergencyContact(String contactId);
  
  /// Update emergency contact
  Future<void> updateEmergencyContact(EmergencyContactEntity contact);
  
  /// Get emergency contacts
  Future<List<EmergencyContactEntity>> getEmergencyContacts();
  
  /// Update user settings
  Future<void> updateSettings(UserSettings settings);
  
  /// Delete user account
  Future<void> deleteAccount();
}
