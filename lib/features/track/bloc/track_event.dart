import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_event.freezed.dart';

/// Events for Track BLoC
@freezed
class TrackEvent with _$TrackEvent {
  /// Initialize location services and check permissions
  const factory TrackEvent.initialize() = _Initialize;

  /// Request location permission
  const factory TrackEvent.requestPermission() = _RequestPermission;

  /// Get current location
  const factory TrackEvent.getCurrentLocation() = _GetCurrentLocation;

  /// Start listening to location updates
  const factory TrackEvent.startLocationUpdates() = _StartLocationUpdates;

  /// Stop listening to location updates
  const factory TrackEvent.stopLocationUpdates() = _StopLocationUpdates;

  /// Update location with new position
  const factory TrackEvent.updateLocation({
    required double latitude,
    required double longitude,
    required double accuracy,
  }) = _UpdateLocation;

  /// Fetch address for given coordinates
  const factory TrackEvent.fetchAddress({
    required double latitude,
    required double longitude,
  }) = _FetchAddress;

  /// Center map on current location
  const factory TrackEvent.centerOnCurrentLocation() = _CenterOnCurrentLocation;

  /// Handle location service error
  const factory TrackEvent.locationError({required String message}) =
      _LocationError;

  /// Retry location operations
  const factory TrackEvent.retry() = _Retry;

  /// Start sharing live location
  const factory TrackEvent.startLocationSharing({required Duration duration}) =
      _StartLocationSharing;

  /// Stop sharing live location
  const factory TrackEvent.stopLocationSharing() = _StopLocationSharing;

  /// Update location sharing status
  const factory TrackEvent.updateLocationSharingStatus({
    required bool isSharing,
    Duration? remainingTime,
  }) = _UpdateLocationSharingStatus;
}
