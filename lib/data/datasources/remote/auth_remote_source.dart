import '../../../core/network/api_client.dart';
import '../../../core/utils/logger.dart';
import '../../models/auth_model.dart';
import '../../models/user_model.dart';
import '../../models/profile_update_request.dart';

/// Remote data source for authentication
abstract class AuthRemoteSource {
  Future<OtpSendResponseModel> sendOtp(String phoneNumber);
  Future<AuthModel> verifyOtp(OtpVerificationRequestModel request);
  Future<UserModel> getUserProfile(String userId);
  Future<UserModel> updateProfile(
    String userId,
    Map<String, dynamic> profileData,
  );
  Future<UserModel> updateProfileWithRequest(
    String userId,
    ProfileUpdateRequest request,
  );
  Future<void> logout(String userId);
}

/// Implementation of authentication remote data source
class AuthRemoteSourceImpl implements AuthRemoteSource {
  final ApiClient _apiClient;

  AuthRemoteSourceImpl(this._apiClient);

  @override
  Future<OtpSendResponseModel> sendOtp(String phoneNumber) async {
    try {
      Logger.network('Sending OTP to $phoneNumber');

      final response = await _apiClient.post(
        '/api/auth/send-otp',
        data: {'phoneNumber': phoneNumber},
      );

      // Debug: Log the response data
      Logger.debug('OTP Response Status: ${response.statusCode}');
      Logger.debug('OTP Response: ${response.data}');
      Logger.debug('Response type: ${response.data.runtimeType}');

      // Check if the request was successful
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.data}');
      }

      // Ensure response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        // Try to handle string responses
        if (response.data is String) {
          // If it's a string, try to create a basic response
          return OtpSendResponseModel(
            message: 'OTP sent successfully',
            sid: DateTime.now().millisecondsSinceEpoch.toString(),
          );
        }
        throw Exception(
          'Invalid response format: expected Map but got ${response.data.runtimeType}',
        );
      }

      return OtpSendResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } catch (e) {
      Logger.error('Error sending OTP', error: e);
      // If it's already an Exception, rethrow it
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to send OTP: $e');
    }
  }

  @override
  Future<AuthModel> verifyOtp(OtpVerificationRequestModel request) async {
    try {
      Logger.network('Verifying OTP for ${request.phoneNumber}');
      Logger.debug('OTP Verification Request: ${request.toJson()}');

      final response = await _apiClient.post(
        '/api/auth/verify-otp',
        data: request.toJson(),
      );

      // Debug: Log the response data
      Logger.debug('OTP Verification Response Status: ${response.statusCode}');
      Logger.debug('OTP Verification Response: ${response.data}');
      Logger.debug('Response type: ${response.data.runtimeType}');

      // Check if the request was successful
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.data}');
      }

      // Ensure response.data is a Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid response format: expected Map but got ${response.data.runtimeType}',
        );
      }

      return AuthModel.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      Logger.error('Error verifying OTP', error: e);
      // If it's already an Exception, rethrow it
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to verify OTP: $e');
    }
  }

  @override
  Future<UserModel> getUserProfile(String userId) async {
    try {
      Logger.network('Fetching user profile for $userId');

      final response = await _apiClient.get('/api/users/$userId');

      // The API returns the user object directly or wrapped in a response
      final userData = response.data['user'] ?? response.data;
      return UserModel.fromJson(userData);
    } catch (e) {
      Logger.error('Error fetching user profile', error: e);
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  @override
  Future<UserModel> updateProfile(
    String userId,
    Map<String, dynamic> profileData,
  ) async {
    try {
      Logger.network('Updating user profile for $userId');

      final response = await _apiClient.put(
        '/api/users/$userId',
        data: profileData,
      );

      // The API returns the updated user object
      final userData = response.data['user'] ?? response.data;
      return UserModel.fromJson(userData);
    } catch (e) {
      Logger.error('Error updating user profile', error: e);
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<UserModel> updateProfileWithRequest(
    String userId,
    ProfileUpdateRequest request,
  ) async {
    try {
      Logger.network('Updating user profile for $userId with request model');
      Logger.debug('Profile update request: ${request.toJson()}');

      // Validate the request
      if (!request.isValid) {
        throw Exception('Invalid profile data: ${request.nameError}');
      }

      if (request.emailError != null) {
        throw Exception('Invalid email: ${request.emailError}');
      }

      final response = await _apiClient.put(
        '/api/users/$userId',
        data: request.toJson(),
      );

      Logger.debug('Profile update response: ${response.data}');

      // Check if the request was successful
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.data}');
      }

      // The API returns the updated user object
      final userData = response.data['user'] ?? response.data;
      return UserModel.fromJson(userData);
    } catch (e) {
      Logger.error('Error updating user profile with request', error: e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Failed to update user profile: $e');
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
