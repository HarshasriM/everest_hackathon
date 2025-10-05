import 'package:freezed_annotation/freezed_annotation.dart';

part 'track_state.freezed.dart';

/// Location permission status
enum LocationPermissionStatus {
  unknown,
  granted,
  denied,
  deniedForever,
  restricted,
}

/// Location service status
enum LocationServiceStatus { unknown, enabled, disabled }

/// States for Track BLoC
@freezed
class TrackState with _$TrackState {
  /// Initial state
  const factory TrackState.initial() = _Initial;

  /// Loading state
  const factory TrackState.loading({
    @Default('Initializing...') String message,
  }) = _Loading;

  /// Permission checking state
  const factory TrackState.checkingPermission() = _CheckingPermission;

  /// Permission denied state
  const factory TrackState.permissionDenied({
    required LocationPermissionStatus permissionStatus,
    @Default('Location permission is required') String message,
  }) = _PermissionDenied;

  /// Location service disabled state
  const factory TrackState.locationServiceDisabled({
    @Default('Location services are disabled') String message,
  }) = _LocationServiceDisabled;

  /// Location loaded successfully
  const factory TrackState.locationLoaded({
    required double latitude,
    required double longitude,
    required double accuracy,
    required String address,
    required DateTime timestamp,
    @Default(true) bool isLocationEnabled,
    @Default(false) bool isListeningToUpdates,
  }) = _LocationLoaded;

  /// Location updating state (when getting new location)
  const factory TrackState.locationUpdating({
    required double latitude,
    required double longitude,
    required double accuracy,
    required String address,
    required DateTime timestamp,
    @Default(true) bool isLocationEnabled,
    @Default(true) bool isListeningToUpdates,
    @Default('Updating location...') String updateMessage,
  }) = _LocationUpdating;

  /// Address loading state
  const factory TrackState.addressLoading({
    required double latitude,
    required double longitude,
    required double accuracy,
    required DateTime timestamp,
    @Default(true) bool isLocationEnabled,
    @Default(false) bool isListeningToUpdates,
    @Default('Getting address...') String message,
  }) = _AddressLoading;

  /// Error state
  const factory TrackState.error({
    required String message,
    String? details,
    @Default(false) bool canRetry,
  }) = _Error;

  /// No location available state
  const factory TrackState.noLocation({
    @Default('Unable to get location') String message,
  }) = _NoLocation;
}

/// Extension to get common properties
extension TrackStateExtension on TrackState {
  /// Check if state has location data
  bool get hasLocation => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) =>
        true,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            true,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        true,
    orElse: () => false,
  );

  /// Get current latitude if available
  double? get latitude => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) => lat,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            lat,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        lat,
    orElse: () => null,
  );

  /// Get current longitude if available
  double? get longitude => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) => lng,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            lng,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        lng,
    orElse: () => null,
  );

  /// Get current accuracy if available
  double? get accuracy => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) => acc,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            acc,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        acc,
    orElse: () => null,
  );

  /// Get current address if available
  String? get address => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) =>
        addr,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            addr,
    orElse: () => null,
  );

  /// Check if location is enabled
  bool get isLocationEnabled => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) =>
        enabled,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            enabled,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        enabled,
    orElse: () => false,
  );

  /// Check if listening to location updates
  bool get isListeningToUpdates => maybeWhen(
    locationLoaded: (lat, lng, acc, addr, timestamp, enabled, listening) =>
        listening,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            listening,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        listening,
    orElse: () => false,
  );

  /// Check if state is loading
  bool get isLoading => maybeWhen(
    loading: (message) => true,
    checkingPermission: () => true,
    locationUpdating:
        (lat, lng, acc, addr, timestamp, enabled, listening, updateMessage) =>
            true,
    addressLoading: (lat, lng, acc, timestamp, enabled, listening, message) =>
        true,
    orElse: () => false,
  );

  /// Check if state is error
  bool get isError => maybeWhen(
    error: (message, details, canRetry) => true,
    permissionDenied: (permissionStatus, message) => true,
    locationServiceDisabled: (message) => true,
    noLocation: (message) => true,
    orElse: () => false,
  );
}
