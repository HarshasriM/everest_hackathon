import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/location_sharing_service.dart';
import 'track_event.dart';
import 'track_state.dart';

/// BLoC for managing track/location functionality
class TrackBloc extends Bloc<TrackEvent, TrackState> {
  final LocationService _locationService;
  final LocationSharingService _locationSharingService;
  StreamSubscription<Position>? _positionSubscription;
  StreamSubscription<LocationSharingStatus>? _sharingStatusSubscription;

  TrackBloc({
    required LocationService locationService,
    required LocationSharingService locationSharingService,
  }) : _locationService = locationService,
       _locationSharingService = locationSharingService,
       super(const TrackState.initial()) {
    on<TrackEvent>((event, emit) async {
      await event.when(
        initialize: () => _onInitialize(emit),
        requestPermission: () => _onRequestPermission(emit),
        getCurrentLocation: () => _onGetCurrentLocation(emit),
        startLocationUpdates: () => _onStartLocationUpdates(emit),
        stopLocationUpdates: () => _onStopLocationUpdates(emit),
        updateLocation: (lat, lng, accuracy) =>
            _onUpdateLocation(emit, lat, lng, accuracy),
        fetchAddress: (lat, lng) => _onFetchAddress(emit, lat, lng),
        centerOnCurrentLocation: () => _onCenterOnCurrentLocation(emit),
        locationError: (message) => _onLocationError(emit, message),
        retry: () => _onRetry(emit),
        startLocationSharing: (duration) =>
            _onStartLocationSharing(emit, duration),
        stopLocationSharing: () => _onStopLocationSharing(emit),
        updateLocationSharingStatus: (isSharing, remainingTime) =>
            _onUpdateLocationSharingStatus(emit, isSharing, remainingTime),
      );
    });

    // Listen to location sharing status changes
    _sharingStatusSubscription = _locationSharingService.statusStream.listen((
      status,
    ) {
      add(
        TrackEvent.updateLocationSharingStatus(
          isSharing: status.isSharing,
          remainingTime: status.remainingTime,
        ),
      );
    });

  }

  /// Initialize location services
  Future<void> _onInitialize(Emitter<TrackState> emit) async {
    try {
      emit(
        const TrackState.loading(message: 'Initializing location services...'),
      );

      // Check if location services are enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const TrackState.locationServiceDisabled());
        return;
      }

      // Check permissions
      LocationPermission permission = await _locationService.checkPermission();
      LocationPermissionStatus permissionStatus = _mapPermissionStatus(
        permission,
      );

      if (permission == LocationPermission.denied) {
        emit(TrackState.permissionDenied(permissionStatus: permissionStatus));
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        emit(
          TrackState.permissionDenied(
            permissionStatus: permissionStatus,
            message:
                'Location permission permanently denied. Please enable in settings.',
          ),
        );
        return;
      }

      // Get current location
      add(const TrackEvent.getCurrentLocation());
    } catch (e) {
      emit(
        TrackState.error(
          message: 'Failed to initialize location services',
          details: e.toString(),
          canRetry: true,
        ),
      );
    }
  }

  /// Request location permission
  Future<void> _onRequestPermission(Emitter<TrackState> emit) async {
    try {
      emit(const TrackState.checkingPermission());

      LocationPermission permission = await _locationService
          .requestPermission();
      LocationPermissionStatus permissionStatus = _mapPermissionStatus(
        permission,
      );

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        emit(
          TrackState.permissionDenied(
            permissionStatus: permissionStatus,
            message: permission == LocationPermission.deniedForever
                ? 'Location permission permanently denied. Please enable in settings.'
                : 'Location permission is required to show your location.',
          ),
        );
        return;
      }

      // Permission granted, get current location
      add(const TrackEvent.getCurrentLocation());
    } catch (e) {
      emit(
        TrackState.error(
          message: 'Failed to request location permission',
          details: e.toString(),
          canRetry: true,
        ),
      );
    }
  }

  /// Get current location
  Future<void> _onGetCurrentLocation(Emitter<TrackState> emit) async {
    try {
      emit(const TrackState.loading(message: 'Getting your location...'));

      Position? position = await _locationService.getCurrentPosition();
      if (position == null) {
        emit(
          const TrackState.noLocation(
            message: 'Unable to get your current location',
          ),
        );
        return;
      }

      // Emit location loaded state with placeholder address
      emit(
        TrackState.locationLoaded(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
          address: 'Getting address...',
          timestamp: position.timestamp,
          isLocationEnabled: true,
          isListeningToUpdates: false,
          isLocationSharing: false,
          locationSharingRemainingTime: null,
        ),
      );

      // Fetch address for the location
      add(
        TrackEvent.fetchAddress(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

      // Start location updates
      add(const TrackEvent.startLocationUpdates());
    } catch (e) {
      emit(
        TrackState.error(
          message: 'Failed to get current location',
          details: e.toString(),
          canRetry: true,
        ),
      );
    }
  }

  /// Start location updates
  Future<void> _onStartLocationUpdates(Emitter<TrackState> emit) async {
    try {
      // Cancel existing subscription
      await _positionSubscription?.cancel();

      _positionSubscription = _locationService.getPositionStream().listen(
        (Position position) {
          add(
            TrackEvent.updateLocation(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracy: position.accuracy,
            ),
          );
        },
        onError: (error) {
          add(TrackEvent.locationError(message: error.toString()));
        },
      );

      // Update state to indicate listening to updates
      state.maybeWhen(
        locationLoaded:
            (
              lat,
              lng,
              acc,
              addr,
              timestamp,
              enabled,
              _,
              sharing,
              remainingTime,
            ) {
              emit(
                TrackState.locationLoaded(
                  latitude: lat,
                  longitude: lng,
                  accuracy: acc,
                  address: addr,
                  timestamp: timestamp,
                  isLocationEnabled: enabled,
                  isListeningToUpdates: true,
                  isLocationSharing: sharing,
                  locationSharingRemainingTime: remainingTime,
                ),
              );
            },
        orElse: () {},
      );
    } catch (e) {
      emit(
        TrackState.error(
          message: 'Failed to start location updates',
          details: e.toString(),
          canRetry: true,
        ),
      );
    }
  }

  /// Stop location updates
  Future<void> _onStopLocationUpdates(Emitter<TrackState> emit) async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;

    // Update state to indicate not listening to updates
    state.maybeWhen(
      locationLoaded:
          (lat, lng, acc, addr, timestamp, enabled, _, sharing, remainingTime) {
            emit(
              TrackState.locationLoaded(
                latitude: lat,
                longitude: lng,
                accuracy: acc,
                address: addr,
                timestamp: timestamp,
                isLocationEnabled: enabled,
                isListeningToUpdates: false,
                isLocationSharing: sharing,
                locationSharingRemainingTime: remainingTime,
              ),
            );
          },
      locationUpdating:
          (
            lat,
            lng,
            acc,
            addr,
            timestamp,
            enabled,
            _,
            __,
            sharing,
            remainingTime,
          ) {
            emit(
              TrackState.locationLoaded(
                latitude: lat,
                longitude: lng,
                accuracy: acc,
                address: addr,
                timestamp: timestamp,
                isLocationEnabled: enabled,
                isListeningToUpdates: false,
                isLocationSharing: sharing,
                locationSharingRemainingTime: remainingTime,
              ),
            );
          },
      orElse: () {},
    );
  }

  /// Update location with new position
  Future<void> _onUpdateLocation(
    Emitter<TrackState> emit,
    double lat,
    double lng,
    double accuracy,
  ) async {
    final currentState = state;

    // Only update if we have a significant change in location
    if (currentState.hasLocation) {
      final currentLat = currentState.latitude!;
      final currentLng = currentState.longitude!;

      double distance = _locationService.calculateDistance(
        currentLat,
        currentLng,
        lat,
        lng,
      );

      // Only update if moved more than 10 meters
      if (distance < 10) {
        return;
      }
    }

    final currentAddress = currentState.address ?? 'Getting address...';

    emit(
      TrackState.locationUpdating(
        latitude: lat,
        longitude: lng,
        accuracy: accuracy,
        address: currentAddress,
        timestamp: DateTime.now(),
        isLocationEnabled: true,
        isListeningToUpdates: true,
        isLocationSharing: currentState.isLocationSharing,
        locationSharingRemainingTime: currentState.locationSharingRemainingTime,
      ),
    );

    // Fetch new address
    add(TrackEvent.fetchAddress(latitude: lat, longitude: lng));
  }

  /// Fetch address for coordinates
  Future<void> _onFetchAddress(
    Emitter<TrackState> emit,
    double lat,
    double lng,
  ) async {
    try {
      final currentState = state;

      // Show address loading state if we have location data
      if (currentState.hasLocation) {
        emit(
          TrackState.addressLoading(
            latitude: lat,
            longitude: lng,
            accuracy: currentState.accuracy ?? 0.0,
            timestamp: DateTime.now(),
            isLocationEnabled: currentState.isLocationEnabled,
            isListeningToUpdates: currentState.isListeningToUpdates,
            isLocationSharing: currentState.isLocationSharing,
            locationSharingRemainingTime:
                currentState.locationSharingRemainingTime,
          ),
        );
      }

      String address = await _locationService.getAddressFromCoordinates(
        lat,
        lng,
      );

      // Update state with new address
      currentState.maybeWhen(
        addressLoading:
            (
              latitude,
              longitude,
              accuracy,
              timestamp,
              enabled,
              listening,
              _,
              sharing,
              remainingTime,
            ) {
              emit(
                TrackState.locationLoaded(
                  latitude: latitude,
                  longitude: longitude,
                  accuracy: accuracy,
                  address: address,
                  timestamp: timestamp,
                  isLocationEnabled: enabled,
                  isListeningToUpdates: listening,
                  isLocationSharing: sharing,
                  locationSharingRemainingTime: remainingTime,
                ),
              );
            },
        locationUpdating:
            (
              latitude,
              longitude,
              accuracy,
              _,
              timestamp,
              enabled,
              listening,
              updateMessage,
              sharing,
              remainingTime,
            ) {
              emit(
                TrackState.locationLoaded(
                  latitude: latitude,
                  longitude: longitude,
                  accuracy: accuracy,
                  address: address,
                  timestamp: timestamp,
                  isLocationEnabled: enabled,
                  isListeningToUpdates: listening,
                  isLocationSharing: sharing,
                  locationSharingRemainingTime: remainingTime,
                ),
              );
            },
        locationLoaded:
            (
              latitude,
              longitude,
              accuracy,
              _,
              timestamp,
              enabled,
              listening,
              sharing,
              remainingTime,
            ) {
              emit(
                TrackState.locationLoaded(
                  latitude: latitude,
                  longitude: longitude,
                  accuracy: accuracy,
                  address: address,
                  timestamp: timestamp,
                  isLocationEnabled: enabled,
                  isListeningToUpdates: listening,
                  isLocationSharing: sharing,
                  locationSharingRemainingTime: remainingTime,
                ),
              );
            },
        orElse: () {},
      );
    } catch (e) {
      // Don't emit error for address fetching, just keep the old address
      print('Failed to fetch address: $e');
    }
  }

  /// Center on current location (handled by UI)
  Future<void> _onCenterOnCurrentLocation(Emitter<TrackState> emit) async {
    // This event is mainly for UI to listen to and center the map
    // The actual centering is handled by the UI layer
  }

  /// Handle location error
  Future<void> _onLocationError(
    Emitter<TrackState> emit,
    String message,
  ) async {
    emit(TrackState.error(message: message, canRetry: true));
  }

  /// Retry location operations
  Future<void> _onRetry(Emitter<TrackState> emit) async {
    add(const TrackEvent.initialize());
  }

  /// Map Geolocator permission to our enum
  LocationPermissionStatus _mapPermissionStatus(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.granted;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unknown;
    }
  }

  /// Start location sharing
  Future<void> _onStartLocationSharing(
    Emitter<TrackState> emit,
    Duration duration,
  ) async {
    try {
      if (!state.hasLocation) {
        emit(
          const TrackState.error(
            message: 'Location not available for sharing',
            canRetry: true,
          ),
        );
        return;
      }

      await _locationSharingService.startLocationSharing(
        latitude: state.latitude!,
        longitude: state.longitude!,
        address: state.address ?? 'Unknown location',
        duration: duration,
      );
    } catch (e) {
      emit(
        TrackState.error(
          message: 'Failed to start location sharing',
          details: e.toString(),
          canRetry: true,
        ),
      );
    }
  }

  /// Stop location sharing
  Future<void> _onStopLocationSharing(Emitter<TrackState> emit) async {
    try {
      await _locationSharingService.stopLocationSharing();
    } catch (e) {
      emit(
        TrackState.error(
          message: 'Failed to stop location sharing',
          details: e.toString(),
          canRetry: false,
        ),
      );
    }
  }

  /// Update location sharing status
  Future<void> _onUpdateLocationSharingStatus(
    Emitter<TrackState> emit,
    bool isSharing,
    Duration? remainingTime,
  ) async {
    // Update the current state with new sharing status
    state.maybeWhen(
      locationLoaded:
          (lat, lng, acc, addr, timestamp, enabled, listening, _, __) {
            emit(
              TrackState.locationLoaded(
                latitude: lat,
                longitude: lng,
                accuracy: acc,
                address: addr,
                timestamp: timestamp,
                isLocationEnabled: enabled,
                isListeningToUpdates: listening,
                isLocationSharing: isSharing,
                locationSharingRemainingTime: remainingTime,
              ),
            );
          },
      locationUpdating:
          (
            lat,
            lng,
            acc,
            addr,
            timestamp,
            enabled,
            listening,
            updateMessage,
            _,
            __,
          ) {
            emit(
              TrackState.locationUpdating(
                latitude: lat,
                longitude: lng,
                accuracy: acc,
                address: addr,
                timestamp: timestamp,
                isLocationEnabled: enabled,
                isListeningToUpdates: listening,
                updateMessage: updateMessage,
                isLocationSharing: isSharing,
                locationSharingRemainingTime: remainingTime,
              ),
            );
          },
      addressLoading:
          (lat, lng, acc, timestamp, enabled, listening, message, _, __) {
            emit(
              TrackState.addressLoading(
                latitude: lat,
                longitude: lng,
                accuracy: acc,
                timestamp: timestamp,
                isLocationEnabled: enabled,
                isListeningToUpdates: listening,
                message: message,
                isLocationSharing: isSharing,
                locationSharingRemainingTime: remainingTime,
              ),
            );
          },
      orElse: () {},
    );
  }

  
  @override
  Future<void> close() async {
    await _positionSubscription?.cancel();
    await _sharingStatusSubscription?.cancel();
    _locationService.dispose();
    _locationSharingService.dispose();
    return super.close();
  }
}
