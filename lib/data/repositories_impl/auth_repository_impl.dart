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

      if (!response.success) {
        throw Exception(response.message);
      }

      Logger.info('OTP sent successfully');
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
        deviceId: verification.deviceId,
        deviceName: verification.deviceName,
        fcmToken: verification.fcmToken,
      );

      // Verify OTP with remote source
      final authModel = await _remoteSource.verifyOtp(request);

      // Save authentication data
      await _preferencesService.saveAuthToken(authModel.accessToken);
      await _preferencesService.saveRefreshToken(authModel.refreshToken);
      await _preferencesService.saveUserId(authModel.userId);

      // If new user, fetch/create profile
      if (authModel.isNewUser) {
        Logger.info('New user detected, creating profile');
      } else {
        // Fetch existing user profile
        final userModel = await _remoteSource.getUserProfile(authModel.userId);
        _cachedUser = userModel.toEntity();
        await _preferencesService.saveUserData(userModel.toJson());
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

      final authModel = await _remoteSource.refreshToken(refreshToken);

      // Update stored tokens
      await _preferencesService.saveAuthToken(authModel.accessToken);
      await _preferencesService.saveRefreshToken(authModel.refreshToken);

      Logger.info('Token refresh successful');
      return authModel.toEntity();
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

      final userModel = UserModel.fromEntity(user);
      final updatedModel = await _remoteSource.updateProfile(userModel);

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
  Future<void> addEmergencyContact(EmergencyContactEntity contact) async {
    try {
      Logger.info('Adding emergency contact');

      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Add contact to list
      final updatedContacts = [...currentUser.emergencyContacts, contact];
      final updatedUser = UserEntity(
        id: currentUser.id,
        phoneNumber: currentUser.phoneNumber,
        name: currentUser.name,
        email: currentUser.email,
        profileImageUrl: currentUser.profileImageUrl,
        dateOfBirth: currentUser.dateOfBirth,
        bloodGroup: currentUser.bloodGroup,
        address: currentUser.address,
        emergencyContacts: updatedContacts,
        isProfileComplete: currentUser.isProfileComplete,
        isVerified: currentUser.isVerified,
        createdAt: currentUser.createdAt,
        lastLoginAt: currentUser.lastLoginAt,
        settings: currentUser.settings,
      );

      await updateProfile(updatedUser);

      // Also save to preferences for offline access
      final contactsList = await _preferencesService.getEmergencyContacts();
      contactsList.add({
        'id': contact.id,
        'name': contact.name,
        'phoneNumber': contact.phoneNumber,
        'relationship': contact.relationship,
        'isPrimary': contact.isPrimary,
        'canReceiveSosAlerts': contact.canReceiveSosAlerts,
        'canTrackLocation': contact.canTrackLocation,
        'email': contact.email,
      });
      await _preferencesService.saveEmergencyContacts(contactsList);

      Logger.info('Emergency contact added successfully');
    } catch (e) {
      Logger.error('Failed to add emergency contact', error: e);
      rethrow;
    }
  }

  @override
  Future<void> removeEmergencyContact(String contactId) async {
    try {
      Logger.info('Removing emergency contact $contactId');

      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Remove contact from list
      final updatedContacts = currentUser.emergencyContacts
          .where((c) => c.id != contactId)
          .toList();

      final updatedUser = UserEntity(
        id: currentUser.id,
        phoneNumber: currentUser.phoneNumber,
        name: currentUser.name,
        email: currentUser.email,
        profileImageUrl: currentUser.profileImageUrl,
        dateOfBirth: currentUser.dateOfBirth,
        bloodGroup: currentUser.bloodGroup,
        address: currentUser.address,
        emergencyContacts: updatedContacts,
        isProfileComplete: currentUser.isProfileComplete,
        isVerified: currentUser.isVerified,
        createdAt: currentUser.createdAt,
        lastLoginAt: currentUser.lastLoginAt,
        settings: currentUser.settings,
      );

      await updateProfile(updatedUser);

      Logger.info('Emergency contact removed successfully');
    } catch (e) {
      Logger.error('Failed to remove emergency contact', error: e);
      rethrow;
    }
  }

  @override
  Future<void> updateEmergencyContact(EmergencyContactEntity contact) async {
    try {
      Logger.info('Updating emergency contact ${contact.id}');

      final currentUser = await getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      // Update contact in list
      final updatedContacts = currentUser.emergencyContacts.map((c) {
        return c.id == contact.id ? contact : c;
      }).toList();

      final updatedUser = UserEntity(
        id: currentUser.id,
        phoneNumber: currentUser.phoneNumber,
        name: currentUser.name,
        email: currentUser.email,
        profileImageUrl: currentUser.profileImageUrl,
        dateOfBirth: currentUser.dateOfBirth,
        bloodGroup: currentUser.bloodGroup,
        address: currentUser.address,
        emergencyContacts: updatedContacts,
        isProfileComplete: currentUser.isProfileComplete,
        isVerified: currentUser.isVerified,
        createdAt: currentUser.createdAt,
        lastLoginAt: currentUser.lastLoginAt,
        settings: currentUser.settings,
      );

      await updateProfile(updatedUser);

      Logger.info('Emergency contact updated successfully');
    } catch (e) {
      Logger.error('Failed to update emergency contact', error: e);
      rethrow;
    }
  }

  @override
  Future<List<EmergencyContactEntity>> getEmergencyContacts() async {
    try {
      // Try to get from current user
      final currentUser = await getCurrentUser();
      if (currentUser != null) {
        return currentUser.emergencyContacts;
      }

      // Fallback to preferences for offline access
      final contactsList = await _preferencesService.getEmergencyContacts();
      return contactsList.map((data) {
        return EmergencyContactEntity(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          phoneNumber: data['phoneNumber'] ?? '',
          relationship: data['relationship'] ?? '',
          isPrimary: data['isPrimary'] ?? false,
          canReceiveSosAlerts: data['canReceiveSosAlerts'] ?? true,
          canTrackLocation: data['canTrackLocation'] ?? false,
          email: data['email'],
        );
      }).toList();
    } catch (e) {
      Logger.error('Failed to get emergency contacts', error: e);
      return [];
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
        bloodGroup: currentUser.bloodGroup,
        address: currentUser.address,
        emergencyContacts: currentUser.emergencyContacts,
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
