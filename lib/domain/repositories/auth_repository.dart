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
  
  /// Delete user account
  Future<void> deleteAccount();
}
