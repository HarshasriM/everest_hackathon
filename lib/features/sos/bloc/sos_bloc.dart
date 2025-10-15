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
  static const int _countdownDuration = 5; // 5 seconds countdown

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
          add( SosSendAlert(
            username: '',
            phoneNumbers: [],
            location: LocationEntity(latitude: 12.9, longitude: 18.9, timestamp: DateTime(2025)),
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
      // Get current location
      final location = await _locationService.getCurrentPosition();
      
      LocationEntity locationEntity;
      if (location == null) {
        // Use default location if GPS is not available
        locationEntity = LocationEntity(
          latitude: 0.0,
          longitude: 0.0,
          timestamp: DateTime.now(),
        );
      } else {
        locationEntity = LocationEntity(
          latitude: location.latitude,
          longitude: location.longitude,
          accuracy: location.accuracy,
          timestamp: DateTime.now(),
        );
      }

      // Get current user ID
      final userId = await _preferencesService.getUserId();
      
      if (userId == null) {
        emit(const SosError(message: 'User not authenticated. Please login again.'));
        return;
      }
      
      // Use a default username or get from user profile
      const username = "Emergency User"; // TODO: Get from user profile

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
