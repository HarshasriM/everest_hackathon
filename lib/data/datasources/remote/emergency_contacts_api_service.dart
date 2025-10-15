import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/logger.dart';
import '../../models/emergency_contact_api_model.dart';
import 'package:dio/dio.dart';

/// Remote data source for emergency contacts API operations
class EmergencyContactsApiService {
  final ApiClient _apiClient;

  EmergencyContactsApiService({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// Retry mechanism for API calls
  Future<T> _retryApiCall<T>(
    Future<T> Function() apiCall, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
  }) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        return await apiCall();
      } catch (e) {
        attempts++;
        if (attempts >= maxRetries) {
          rethrow;
        }
        
        // Only retry on network errors, not on client errors (4xx)
        if (e is DioException) {
          if (e.response?.statusCode != null && 
              e.response!.statusCode! >= 400 && 
              e.response!.statusCode! < 500) {
            rethrow; // Don't retry client errors
          }
        }
        
        Logger.warning('API call failed, retrying... Attempt $attempts/$maxRetries');
        await Future.delayed(delay * attempts); // Exponential backoff
      }
    }
    throw Exception('Max retries exceeded');
  }

  /// Get all emergency contacts for a user
  Future<List<EmergencyContactApiModel>> getEmergencyContacts(String userId) async {
    return await _retryApiCall(() async {
      Logger.info('Fetching emergency contacts for user: $userId');
      
      final response = await _apiClient.get(
        ApiEndpoints.getEmergencyContacts(userId),
      );

      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = EmergencyContactsResponse.fromJson(response.data);
        
        if (apiResponse.success) {
          Logger.info('Successfully fetched ${apiResponse.data.length} emergency contacts');
          return apiResponse.data;
        } else {
          throw Exception(apiResponse.message ?? 'Failed to fetch emergency contacts');
        }
      } else {
        throw Exception('Invalid response from server');
      }
    });
  }

  /// Add a new emergency contact
  Future<EmergencyContactApiModel> addEmergencyContact({
    required String userId,
    required String name,
    required String phoneNumber,
    required String relationship,
  }) async {
    try {
      Logger.info('Adding emergency contact: $name for user: $userId');
      
      final request = AddEmergencyContactRequest(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        relationship: relationship,
      );

      final response = await _apiClient.post(
        ApiEndpoints.addEmergencyContact,
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = EmergencyContactResponse.fromJson(response.data);
        
        if (apiResponse.success && apiResponse.data != null) {
          Logger.info('Successfully added emergency contact: ${apiResponse.message}');
          return apiResponse.data!;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      Logger.error('Failed to add emergency contact', error: e);
      rethrow;
    }
  }

  /// Update an existing emergency contact
  Future<EmergencyContactApiModel> updateEmergencyContact({
    required String userId,
    required String contactId,
    required String name,
    required String phoneNumber,
    required String relationship,
  }) async {
    try {
      Logger.info('Updating emergency contact: $contactId for user: $userId');
      
      final request = UpdateEmergencyContactRequest(
        name: name,
        phoneNumber: phoneNumber,
        relationship: relationship,
      );

      final response = await _apiClient.put(
        ApiEndpoints.updateEmergencyContact(userId, contactId),
        data: request.toJson(),
      );

      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = EmergencyContactResponse.fromJson(response.data);
        
        if (apiResponse.success && apiResponse.data != null) {
          Logger.info('Successfully updated emergency contact: ${apiResponse.message}');
          return apiResponse.data!;
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      Logger.error('Failed to update emergency contact', error: e);
      rethrow;
    }
  }

  /// Delete an emergency contact
  Future<void> deleteEmergencyContact({
    required String userId,
    required String contactId,
  }) async {
    try {
      Logger.info('Deleting emergency contact: $contactId for user: $userId');
      
      final response = await _apiClient.delete(
        ApiEndpoints.deleteEmergencyContact(userId, contactId),
      );

      if (response.statusCode == 200 && response.data != null) {
        final apiResponse = EmergencyContactResponse.fromJson(response.data);
        
        if (apiResponse.success) {
          Logger.info('Successfully deleted emergency contact: ${apiResponse.message}');
        } else {
          throw Exception(apiResponse.message);
        }
      } else {
        throw Exception('Invalid response from server');
      }
    } catch (e) {
      Logger.error('Failed to delete emergency contact', error: e);
      rethrow;
    }
  }
}
