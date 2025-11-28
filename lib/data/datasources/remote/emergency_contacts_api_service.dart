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

        Logger.warning(
          'API call failed, retrying... Attempt $attempts/$maxRetries',
        );
        await Future.delayed(delay * attempts); // Exponential backoff
      }
    }
    throw Exception('Max retries exceeded');
  }

  /// Get all emergency contacts for a user
  Future<List<EmergencyContactApiModel>> getEmergencyContacts(
    String userId,
  ) async {
    return await _retryApiCall(() async {
      Logger.info('Fetching emergency contacts for user: $userId');

      final response = await _apiClient.get(
        ApiEndpoints.getEmergencyContacts(userId),
      );

      Logger.debug('Get contacts response status: ${response.statusCode}');
      Logger.debug('Get contacts response data: ${response.data}');
      Logger.debug(
        'Get contacts response data type: ${response.data.runtimeType}',
      );

      if (response.statusCode == 200 && response.data != null) {
        try {
          final apiResponse = EmergencyContactsResponse.fromJson(response.data);

          if (apiResponse.success) {
            Logger.info(
              'Successfully fetched ${apiResponse.data.length} emergency contacts',
            );
            return apiResponse.data;
          } else {
            final errorMsg =
                apiResponse.message ?? 'Failed to fetch emergency contacts';
            throw Exception(errorMsg);
          }
        } catch (parseError) {
          Logger.error('Failed to parse API response', error: parseError);
          Logger.debug('Raw response data: ${response.data}');
          throw Exception('Invalid response format from server');
        }
      } else {
        Logger.error('Invalid response status: ${response.statusCode}');
        throw Exception(
          'Invalid response from server (Status: ${response.statusCode})',
        );
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

      Logger.debug('Add response status: ${response.statusCode}');
      Logger.debug('Add response data: ${response.data}');
      Logger.debug('Add response data type: ${response.data.runtimeType}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        try {
          final apiResponse = EmergencyContactResponse.fromJson(response.data);

          if (apiResponse.success && apiResponse.data != null) {
            Logger.info(
              'Successfully added emergency contact: ${apiResponse.message}',
            );
            return apiResponse.data!;
          } else {
            throw Exception(
              apiResponse.message.isNotEmpty
                  ? apiResponse.message
                  : 'Failed to add emergency contact',
            );
          }
        } catch (parseError) {
          Logger.error('Failed to parse add response', error: parseError);
          Logger.debug('Raw response: ${response.data}');
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception(
          'Invalid response from server (Status: ${response.statusCode})',
        );
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
      Logger.info(
        'Updating emergency contact - contactId: "$contactId", userId: "$userId"',
      );
      if (contactId.isEmpty || userId.isEmpty) {
        throw Exception(
          'Cannot update: contactId or userId is empty (contactId: "$contactId", userId: "$userId")',
        );
      }

      final request = UpdateEmergencyContactRequest(
        name: name,
        phoneNumber: phoneNumber,
        relationship: relationship,
      );

      final endpoint = ApiEndpoints.updateEmergencyContact(userId, contactId);
      Logger.info('Update endpoint: $endpoint');
      final response = await _apiClient.put(
        endpoint, 
        data: request.toJson());

      Logger.debug('Update response status: ${response.statusCode}');
      Logger.debug('Update response data: ${response.data}');
      Logger.debug('Update response data type: ${response.data.runtimeType}');

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        try {
          final apiResponse = EmergencyContactResponse.fromJson(response.data);

          if (apiResponse.success && apiResponse.data != null) {
            Logger.info(
              'Successfully updated emergency contact: ${apiResponse.message}',
            );
            return apiResponse.data!;
          } else {
            // Handle case where success is false but we still got 200 (e.g., Twilio unverified number)
            final errorMessage = apiResponse.message.isNotEmpty
                ? apiResponse.message
                : 'Failed to update emergency contact';
            throw Exception(errorMessage);
          }
        } catch (parseError) {
          Logger.error('Failed to parse update response', error: parseError);
          Logger.debug('Raw response: ${response.data}');
          throw Exception('Invalid response format from server');
        }
      } else {
        throw Exception(
          'Invalid response from server (Status: ${response.statusCode})',
        );
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
      Logger.info(
        'Deleting emergency contact - contactId: "$contactId", userId: "$userId"',
      );
      if (contactId.isEmpty || userId.isEmpty) {
        throw Exception(
          'Cannot delete: contactId or userId is empty (contactId: "$contactId", userId: "$userId")',
        );
      }

      final endpoint = ApiEndpoints.deleteEmergencyContact(userId, contactId);
      Logger.info('Delete endpoint: $endpoint');
      final response = await _apiClient.delete(endpoint);

      Logger.debug('Delete response status: ${response.statusCode}');
      Logger.debug('Delete response data: ${response.data}');
      Logger.debug('Delete response data type: ${response.data.runtimeType}');

      if ((response.statusCode == 200 || response.statusCode == 204) &&
          response.data != null) {
        try {
          final apiResponse = EmergencyContactResponse.fromJson(response.data);

          if (apiResponse.success) {
            Logger.info(
              'Successfully deleted emergency contact: ${apiResponse.message}',
            );
          } else {
            throw Exception(
              apiResponse.message.isNotEmpty
                  ? apiResponse.message
                  : 'Failed to delete emergency contact',
            );
          }
        } catch (parseError) {
          Logger.error('Failed to parse delete response', error: parseError);
          Logger.debug('Raw response: ${response.data}');
          throw Exception('Invalid response format from server');
        }
      } else if (response.statusCode == 204) {
        // No content response is also valid for delete
        Logger.info('Successfully deleted emergency contact (no content)');
      } else {
        throw Exception(
          'Invalid response from server (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      Logger.error('Failed to delete emergency contact', error: e);
      rethrow;
    }
  }
}
