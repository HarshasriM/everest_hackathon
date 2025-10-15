import 'package:dartz/dartz.dart';
import '../../domain/entities/sos_entity.dart';
import '../../domain/repositories/sos_repository.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/utils/result.dart';
import '../datasources/remote/sos_remote_source.dart';
import '../models/sos_request_model.dart';

/// Implementation of SOS Repository
class SosRepositoryImpl implements SosRepository {
  final SosRemoteSource _remoteSource;

  SosRepositoryImpl(this._remoteSource);

  @override
  Future<SosEntity> triggerSos({
    required LocationEntity location,
    required SosType type,
    String? message,
    List<String>? mediaUrls,
  }) async {
    // This method will be implemented when we have user data and contacts
    throw UnimplementedError('triggerSos not implemented yet');
  }

  /// Send SOS Alert with specific parameters
  Future<Result<SosResponseModel>> sendSosAlert({
    required String username,
    required List<String> phoneNumbers,
    required LocationEntity location,
    required String userId,
  }) async {
    try {
      final locationString = location.address ?? 
          'Lat: ${location.latitude}, Lng: ${location.longitude}\n${location.googleMapsUrl}';
      
      // Fetch emergency contacts from API
      final contactsResponse = await _remoteSource.getEmergencyContacts(userId);
      
      if (!contactsResponse.success || contactsResponse.data.isEmpty) {
        return Left(ServerFailure(message: 'No emergency contacts found. Please add contacts first.'));
      }
      
      // Extract phone numbers from emergency contacts
      final emergencyPhoneNumbers = contactsResponse.data
          .map((contact) => contact.phoneNumber)
          .toList();
      
      final request = SosRequestModel(
        username: username,
        phoneNumbers: emergencyPhoneNumbers,
        location: locationString,
      );

      final response = await _remoteSource.sendSosAlert(request);
      return Right(response);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<void> cancelSos(String sosId) async {
    // Implementation for canceling SOS
    throw UnimplementedError('cancelSos not implemented yet');
  }

  @override
  Future<void> updateSosStatus(String sosId, SosStatus status) async {
    // Implementation for updating SOS status
    throw UnimplementedError('updateSosStatus not implemented yet');
  }

  @override
  Future<SosEntity?> getActiveSos() async {
    // Implementation for getting active SOS
    throw UnimplementedError('getActiveSos not implemented yet');
  }

  @override
  Future<List<SosEntity>> getSosHistory() async {
    // Implementation for getting SOS history
    throw UnimplementedError('getSosHistory not implemented yet');
  }

  @override
  Future<SosEntity> getSosById(String sosId) async {
    // Implementation for getting SOS by ID
    throw UnimplementedError('getSosById not implemented yet');
  }

  @override
  Future<void> shareLiveLocation(LocationEntity location) async {
    // Implementation for sharing live location
    throw UnimplementedError('shareLiveLocation not implemented yet');
  }

  @override
  Future<void> stopLocationSharing() async {
    // Implementation for stopping location sharing
    throw UnimplementedError('stopLocationSharing not implemented yet');
  }

  @override
  Future<List<LocationEntity>> getNearbyPoliceStations(LocationEntity currentLocation) async {
    // Implementation for getting nearby police stations
    throw UnimplementedError('getNearbyPoliceStations not implemented yet');
  }

  @override
  Future<List<LocationEntity>> getNearbyHospitals(LocationEntity currentLocation) async {
    // Implementation for getting nearby hospitals
    throw UnimplementedError('getNearbyHospitals not implemented yet');
  }

  @override
  Future<List<LocationEntity>> getNearbySafeSpaces(LocationEntity currentLocation) async {
    // Implementation for getting nearby safe spaces
    throw UnimplementedError('getNearbySafeSpaces not implemented yet');
  }

  @override
  Future<void> updateSosLocation(String sosId, LocationEntity location) async {
    // Implementation for updating SOS location
    throw UnimplementedError('updateSosLocation not implemented yet');
  }

  @override
  Future<void> addMediaToSos(String sosId, List<String> mediaUrls) async {
    // Implementation for adding media to SOS
    throw UnimplementedError('addMediaToSos not implemented yet');
  }
}
