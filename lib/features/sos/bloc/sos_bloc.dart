import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sos/send_sos_alert_usecase.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/contact_storage_service.dart';
import '../../../core/services/app_preferences_service.dart';
import '../../../domain/entities/sos_entity.dart';
import 'sos_event.dart';
import 'sos_state.dart';

/// SOS BLoC for managing SOS alert functionality
class SosBloc extends Bloc<SosEvent, SosState> {
  final SendSosAlertUseCase _sendSosAlertUseCase;
  final LocationService _locationService;
  final ContactStorageService _contactStorageService;
  final AppPreferencesService _preferencesService;
  Timer? _countdownTimer;
  static const int _countdownDuration = 3; // 3 seconds countdown

  SosBloc(
    this._sendSosAlertUseCase,
    this._locationService,
    this._contactStorageService,
    this._preferencesService,
  ) : super(const SosInitial()) {
    on<SosStartCountdown>(_onStartCountdown);
    on<SosCancelCountdown>(_onCancelCountdown);
    on<SosCountdownTick>(_onCountdownTick);
    on<SosSendAlert>(_onSendAlert);
    on<SosReset>(_onReset);
  }

  @override
  Future<void> close() {
    _countdownTimer?.cancel();
    return super.close();
  }

  Future<void> _onStartCountdown(
    SosStartCountdown event,
    Emitter<SosState> emit,
  ) async {
    // Cancel any existing timer
    _countdownTimer?.cancel();
    
    emit(const SosCountdown(remainingSeconds: _countdownDuration));
    
    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        final remaining = _countdownDuration - timer.tick;
        if (remaining > 0) {
          add(SosCountdownTick(remaining));
        } else {
          timer.cancel();
          _countdownTimer = null;
          add(const SosSendAlert(
            username: '',
            phoneNumbers: [],
            location: null, // Location will be fetched in _onSendAlert
          ));
        }
      },
    );
  }

  void _onCancelCountdown(
    SosCancelCountdown event,
    Emitter<SosState> emit,
  ) {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    emit(const SosCancelled());
    
    // Reset to initial state after a brief delay
    Timer(const Duration(seconds: 2), () {
      if (!isClosed) {
        add(const SosReset());
      }
    });
  }

  void _onCountdownTick(
    SosCountdownTick event,
    Emitter<SosState> emit,
  ) {
    emit(SosCountdown(remainingSeconds: event.remainingSeconds));
  }

  Future<void> _onSendAlert(
    SosSendAlert event,
    Emitter<SosState> emit,
  ) async {
    emit(const SosSending());

    try {
      // Use provided location or get current location with high accuracy for emergency
      LocationEntity locationEntity;
      
      if (event.location != null) {
        // Use the provided location
        locationEntity = event.location!;
      } else {
        // Get current location
        final location = await _locationService.getCurrentPosition();
        
        if (location == null) {
          // If GPS fails, emit error instead of using default coordinates
          emit(const SosError(message: 'Unable to get your location. Please enable GPS and try again.'));
          return;
        } else {
          locationEntity = LocationEntity(
            latitude: location.latitude,
            longitude: location.longitude,
            accuracy: location.accuracy,
            timestamp: DateTime.now(),
          );
          
          // Get address for better location context
          try {
            final address = await _locationService.getAddressFromCoordinates(
              location.latitude, 
              location.longitude
            );
            locationEntity = LocationEntity(
              latitude: location.latitude,
              longitude: location.longitude,
              accuracy: location.accuracy,
              timestamp: DateTime.now(),
              address: address,
            );
          } catch (e) {
            // If address lookup fails, continue with coordinates only
            print('Address lookup failed: $e');
          }
        }
      }

      // Get current user ID and data
      final userId = await _preferencesService.getUserId();
      
      if (userId == null) {
        emit(const SosError(message: 'User not authenticated. Please login again.'));
        return;
      }
      
      // Get user's phone number for the SOS message
      final userPhoneNumber = await _preferencesService.getUserPhoneNumber();
      String username = userPhoneNumber ?? "Emergency User"; // Use phone number or fallback

      final result = await _sendSosAlertUseCase(
        username: username,
        phoneNumbers: [], // Will be fetched from API
        location: locationEntity,
        userId: userId,
      );

      result.fold(
        (failure) => emit(SosError(message: failure.message)),
        (response) => emit(SosSuccess(response: response)),
      );
    } catch (e) {
      emit(SosError(message: 'Failed to send SOS alert: ${e.toString()}'));
    }
  }

  void _onReset(
    SosReset event,
    Emitter<SosState> emit,
  ) {
    emit(const SosInitial());
  }

}
