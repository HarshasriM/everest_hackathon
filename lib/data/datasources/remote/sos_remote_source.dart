import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/error/exceptions.dart';
import '../../models/sos_request_model.dart';
import "package:everest_hackathon/data/models/emergency_contact_api_model.dart";

/// SOS Remote Data Source
abstract class SosRemoteSource {
  Future<SosResponseModel> sendSosAlert(SosRequestModel request);
  Future<EmergencyContactsResponse> getEmergencyContacts(String userId);
}

/// Implementation of SOS Remote Data Source
class SosRemoteSourceImpl implements SosRemoteSource {
  final ApiClient _apiClient;

  SosRemoteSourceImpl(this._apiClient);

  @override
  Future<SosResponseModel> sendSosAlert(SosRequestModel request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.sendSosAlert,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        return SosResponseModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to send SOS alert',
          code: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(
          message: 'No internet connection available.',
        );
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode ?? 500;
        final message = e.response!.data?['message'] ?? 'Server error occurred';
        throw ServerException(message: message, code: statusCode);
      } else {
        throw const NetworkException(
          message: 'Network error occurred',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        code: 500,
      );
    }
  }

  @override
  Future<EmergencyContactsResponse> getEmergencyContacts(String userId) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.getEmergencyContacts(userId),
      );

      if (response.statusCode == 200) {
        return EmergencyContactsResponse.fromJson(response.data);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Failed to get emergency contacts',
          code: response.statusCode ?? 500,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkException(
          message: 'No internet connection available.',
        );
      } else if (e.response != null) {
        final statusCode = e.response!.statusCode ?? 500;
        final message = e.response!.data?['message'] ?? 'Server error occurred';
        throw ServerException(message: message, code: statusCode);
      } else {
        throw const NetworkException(
          message: 'Network error occurred',
        );
      }
    } catch (e) {
      throw ServerException(
        message: 'Unexpected error: ${e.toString()}',
        code: 500,
      );
    }
  }
}
