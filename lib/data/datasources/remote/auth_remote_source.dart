import 'dart:math';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/logger.dart';
import '../../models/auth_model.dart';
import '../../models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteSource {
  Future<OtpResponseModel> sendOtp(String phoneNumber);
  Future<AuthModel> verifyOtp(OtpVerificationRequestModel request);
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> updateProfile(UserModel user);
  Future<AuthModel> refreshToken(String refreshToken);
  Future<void> logout(String userId);
}

/// Implementation of authentication remote data source
class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient _apiClient;

  AuthRemoteSourceImpl(this._apiClient);

  @override
  Future<OtpResponseModel> sendOtp(String phoneNumber) async {
    try {
      // For demo purposes, we'll simulate the API call
      Logger.network('Sending OTP to $phoneNumber');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // In production, uncomment this:
      // final response = await _apiClient.post(
      //   ApiEndpoints.sendOtp,
      //   data: {'phoneNumber': phoneNumber},
      // );
      // return OtpResponseModel.fromJson(response.data);
      
      // Mock response
      return const OtpResponseModel(
        success: true,
        message: 'OTP sent successfully',
        requestId: 'mock_request_123',
        expiresInSeconds: 300,
        resendAfterSeconds: 30,
      );
    } catch (e) {
      Logger.error('Error sending OTP', error: e);
      throw Exception('Failed to send OTP: $e');
    }
  }

  @override
  Future<AuthModel> verifyOtp(OtpVerificationRequestModel request) async {
    try {
      Logger.network('Verifying OTP for ${request.phoneNumber}');
      
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      // For demo: Accept OTP "123456" as valid
      if (request.otp != '123456') {
        throw Exception('Invalid OTP. Use 123456 for demo.');
      }
      
      // In production, uncomment this:
      // final response = await _apiClient.post(
      //   ApiEndpoints.verifyOtp,
      //   data: request.toJson(),
      // );
      // return AuthModel.fromJson(response.data);
      
      // Mock response - check if user exists
      final isNewUser = !_mockUserDatabase.containsKey(request.phoneNumber);
      final userId = 'user_${Random().nextInt(10000)}';
      
      if (isNewUser) {
        // Create new user in mock database
        _mockUserDatabase[request.phoneNumber] = UserModel(
          id: userId,
          phoneNumber: request.phoneNumber,
          name: '',
          createdAt: DateTime.now(),
          settings: UserSettingsModel.defaults(),
        );
      }
      
      return AuthModel(
        userId: isNewUser ? userId : _mockUserDatabase[request.phoneNumber]!.id,
        accessToken: 'mock_access_token_${Random().nextInt(100000)}',
        refreshToken: 'mock_refresh_token_${Random().nextInt(100000)}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        isNewUser: isNewUser,
      );
    } catch (e) {
      Logger.error('Error verifying OTP', error: e);
      throw Exception('Failed to verify OTP: $e');
    }
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      Logger.network('Fetching user profile for $userId');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In production, uncomment this:
      // final response = await _apiClient.get(
      //   ApiEndpoints.getUserProfile,
      // );
      // return UserModel.fromJson(response.data);
      
      // Mock response - find user by ID
      final user = _mockUserDatabase.values.firstWhere(
        (u) => u.id == userId,
        orElse: () => UserModel(
          id: userId,
          phoneNumber: '9999999999',
          name: 'Demo User',
          email: 'demo@she-app.com',
          createdAt: DateTime.now(),
          settings: UserSettingsModel.defaults(),
          emergencyContacts: [
            const EmergencyContactModel(
              id: 'contact_1',
              name: 'Emergency Contact 1',
              phoneNumber: '8888888888',
              relationship: 'Parent',
              isPrimary: true,
            ),
          ],
        ),
      );
      
      return user;
    } catch (e) {
      Logger.error('Error fetching user profile', error: e);
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      Logger.network('Updating user profile for ${user.id}');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In production, uncomment this:
      // final response = await _apiClient.put(
      //   ApiEndpoints.updateProfile,
      //   data: user.toJson(),
      // );
      // return UserModel.fromJson(response.data);
      
      // Mock update - store in memory
      _mockUserDatabase[user.phoneNumber] = user;
      
      return user;
    } catch (e) {
      Logger.error('Error updating user profile', error: e);
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<AuthModel> refreshToken(String refreshToken) async {
    try {
      Logger.network('Refreshing token');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // In production, uncomment this:
      // final response = await _apiClient.post(
      //   ApiEndpoints.refreshToken,
      //   data: {'refreshToken': refreshToken},
      // );
      // return AuthModel.fromJson(response.data);
      
      // Mock response
      return AuthModel(
        userId: 'user_123',
        accessToken: 'new_mock_access_token_${Random().nextInt(100000)}',
        refreshToken: 'new_mock_refresh_token_${Random().nextInt(100000)}',
        expiresAt: DateTime.now().add(const Duration(hours: 24)),
        isNewUser: false,
      );
    } catch (e) {
      Logger.error('Error refreshing token', error: e);
      throw Exception('Failed to refresh token: $e');
    }
  }

  @override
  Future<void> logout(String userId) async {
    try {
      Logger.network('Logging out user $userId');
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      // In production, uncomment this:
      // await _apiClient.post(
      //   ApiEndpoints.logout,
      //   data: {'userId': userId},
      // );
      
      // Clear local cache/tokens
      return;
    } catch (e) {
      Logger.error('Error during logout', error: e);
      throw Exception('Failed to logout: $e');
    }
  }
}

// Mock in-memory database for demo
final Map<String, UserModel> _mockUserDatabase = {};
