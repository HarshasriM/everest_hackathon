import '../entities/sos_entity.dart';

/// SOS repository interface
abstract class SosRepository {
  /// Trigger SOS alert
  Future<SosEntity> triggerSos({
    required LocationEntity location,
    required SosType type,
    String? message,
    List<String>? mediaUrls,
  });
  
  /// Cancel active SOS alert
  Future<void> cancelSos(String sosId);
  
  /// Update SOS status
  Future<void> updateSosStatus(String sosId, SosStatus status);
  
  /// Get active SOS alert
  Future<SosEntity?> getActiveSos();
  
  /// Get SOS history
  Future<List<SosEntity>> getSosHistory();
  
  /// Get SOS by ID
  Future<SosEntity> getSosById(String sosId);
  
  /// Share live location
  Future<void> shareLiveLocation(LocationEntity location);
  
  /// Stop location sharing
  Future<void> stopLocationSharing();
  
  /// Get nearby police stations
  Future<List<LocationEntity>> getNearbyPoliceStations(LocationEntity currentLocation);
  
  /// Get nearby hospitals
  Future<List<LocationEntity>> getNearbyHospitals(LocationEntity currentLocation);
  
  /// Get nearby safe spaces
  Future<List<LocationEntity>> getNearbySafeSpaces(LocationEntity currentLocation);
  
  /// Send location update for active SOS
  Future<void> updateSosLocation(String sosId, LocationEntity location);
  
  /// Add media to SOS alert
  Future<void> addMediaToSos(String sosId, List<String> mediaUrls);
  
  /// Test emergency contacts (send test alert)
  Future<void> testEmergencyContacts();
}
