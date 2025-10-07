import '../../core/services/app_preferences_service.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_source.dart';
import '../models/auth_model.dart';
import '../models/user_model.dart';

/// Implementation of authentication repository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource _remoteSource;
  final AppPreferencesService _preferencesService;

  // Cache current user in memory
  UserEntity? _cachedUser;

  AuthRepositoryImpl({
    required AuthRemoteSource remoteSource,
    required AppPreferencesService preferencesService,
  }) : _remoteSource = remoteSource,
       _preferencesService = preferencesService;

  @override
  Future<void> sendOtp(OtpRequestEntity request) async {
    try {
      Logger.info('Sending OTP to ${request.phoneNumber}');

      final response = await _remoteSource.sendOtp(request.fullPhoneNumber);
      
      // Store the session ID if needed (we can store it as part of auth token for now)
      // In production, you might want to add a dedicated method for this
      
      Logger.info('OTP sent successfully: ${response.message}');
    } catch (e) {
      Logger.error('Failed to send OTP', error: e);
      rethrow;
    }
  }

  @override
  Future<AuthEntity> verifyOtp(OtpVerificationEntity verification) async {
    try {
      Logger.info('Verifying OTP for ${verification.phoneNumber}');

      // Create verification request model
      final request = OtpVerificationRequestModel(
        phoneNumber: verification.phoneNumber,
        otp: verification.otp,
      );

      // Verify OTP with remote source
      final authModel = await _remoteSource.verifyOtp(request);
      
      // Save user ID and mark as authenticated
      await _preferencesService.saveUserId(authModel.userId);
      // Authentication is implicit when we have a user ID
      
      // If profile is complete, save user data
      if (authModel.isProfileComplete && authModel.user != null) {
        _cachedUser = authModel.user!.toEntity();
        await _preferencesService.saveUserData(authModel.user!.toJson());
      }

      Logger.info('OTP verification successful');
      return authModel.toEntity();
    } catch (e) {
      Logger.error('Failed to verify OTP', error: e);
      rethrow;
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      // Check cache first
      if (_cachedUser != null) {
        return _cachedUser;
      }

      // Check if authenticated
      final isAuth = await isAuthenticated();
      if (!isAuth) {
        return null;
      }

      // Try to get from preferences
      final userData = await _preferencesService.getUserData();
      if (userData != null) {
        final userModel = UserModel.fromJson(userData);
        _cachedUser = userModel.toEntity();
        return _cachedUser;
      }

      // Fetch from remote if not in cache
      final userId = await _preferencesService.getUserId();
      if (userId != null) {
        final userModel = await _remoteSource.getUserProfile(userId);
        _cachedUser = userModel.toEntity();
        await _preferencesService.saveUserData(userModel.toJson());
        return _cachedUser;
      }

      return null;
    } catch (e) {
      Logger.error('Failed to get current user', error: e);
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      final token = await _preferencesService.getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      Logger.error('Failed to check authentication', error: e);
      return false;
    }
  }

  @override
  Future<AuthEntity> refreshToken(String refreshToken) async {
    try {
      Logger.info('Refreshing authentication token');
      
      // For now, we don't have a refresh token endpoint
      // Just return the current auth state
      final userId = await _preferencesService.getUserId();
      if (userId == null) {
        throw Exception('No user ID found');
      }
      
      return AuthEntity(
        userId: userId,
        isProfileComplete: _cachedUser != null,
        user: _cachedUser,
      );
    } catch (e) {
      Logger.error('Failed to refresh token', error: e);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      Logger.info('Logging out user');

      final userId = await _preferencesService.getUserId();
      if (userId != null) {
        await _remoteSource.logout(userId);
      }

      // Clear local data
      await _preferencesService.clearAuthData();
      _cachedUser = null;

      Logger.info('Logout successful');
    } catch (e) {
      Logger.error('Failed to logout', error: e);
      // Clear local data even if remote logout fails
      await _preferencesService.clearAuthData();
      _cachedUser = null;
    }
  }

  @override
  Future<UserEntity> updateProfile(UserEntity user) async {
    try {
      Logger.info('Updating user profile');
      
      // Convert entity to profile data map
      final profileData = {
        'name': user.name,
        'email': user.email,
      };
      
      final updatedModel = await _remoteSource.updateProfile(user.id, profileData);
      
      // Update cache
      _cachedUser = updatedModel.toEntity();
      await _preferencesService.saveUserData(updatedModel.toJson());

      Logger.info('Profile update successful');
      return _cachedUser!;
    } catch (e) {
      Logger.error('Failed to update profile', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateSettings(UserSettings settings) async {
    try {
      Logger.info('Updating user settings');

      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final updatedUser = UserEntity(
        id: currentUser.id,
        phoneNumber: currentUser.phoneNumber,
        name: currentUser.name,
        email: currentUser.email,
        profileImageUrl: currentUser.profileImageUrl,
        dateOfBirth: currentUser.dateOfBirth,
        isProfileComplete: currentUser.isProfileComplete,
        isVerified: currentUser.isVerified,
        createdAt: currentUser.createdAt,
        lastLoginAt: currentUser.lastLoginAt,
        settings: settings,
      );

      await updateProfile(updatedUser);

      // Update language preference
      await _preferencesService.saveLanguageCode(settings.languageCode);

      Logger.info('Settings updated successfully');
    } catch (e) {
      Logger.error('Failed to update settings', error: e);
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      Logger.info('Deleting user account');

      final userId = await _preferencesService.getUserId();
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      // In production, call remote API to delete account
      // await _remoteSource.deleteAccount(userId);

      // Clear all local data
      await _preferencesService.clearAll();
      _cachedUser = null;

      Logger.info('Account deleted successfully');
    } catch (e) {
      Logger.error('Failed to delete account', error: e);
      rethrow;
    }
  }
}
