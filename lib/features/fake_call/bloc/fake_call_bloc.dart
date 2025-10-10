import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/ringtone_service.dart';
import 'fake_call_event.dart';
import 'fake_call_state.dart';

/// BLoC for managing fake call functionality
class FakeCallBloc extends Bloc<FakeCallEvent, FakeCallState> {
  final RingtoneService _ringtoneService = RingtoneService();
  Timer? _countdownTimer;
  Timer? _callDurationTimer;
  
  FakeCallBloc() : super(const FakeCallState.initial()) {
    on<FakeCallEvent>(
      (event, emit) async {
        await event.when(
          initialize: () => _onInitialize(emit),
          setCallerName: (name) => _onSetCallerName(emit, name),
          setCallerNumber: (number) => _onSetCallerNumber(emit, number),
          setCallerImage: (imagePath) => _onSetCallerImage(emit, imagePath),
          setTimerDuration: (seconds) => _onSetTimerDuration(emit, seconds),
          saveCallerDetails: () => _onSaveCallerDetails(emit),
          startFakeCall: () => _onStartFakeCall(emit),
          cancelFakeCall: () => _onCancelFakeCall(emit),
          showIncomingCall: () => _onShowIncomingCall(emit),
          answerCall: () => _onAnswerCall(emit),
          declineCall: () => _onDeclineCall(emit),
          endCall: () => _onEndCall(emit),
          updateCallDuration: (seconds) => _onUpdateCallDuration(emit, seconds),
          reset: () => _onReset(emit),
        );
      },
    );
  }
  
  /// Initialize
  Future<void> _onInitialize(Emitter<FakeCallState> emit) async {
    emit(const FakeCallState.settingUp(
      callerName: '',
      callerNumber: '',
      callerImagePath: null,
      timerSeconds: 5,
    ));
  }
  
  /// Set caller name
  Future<void> _onSetCallerName(Emitter<FakeCallState> emit, String name) async {
    state.maybeWhen(
      settingUp: (currentName, number, image, timer) {
        emit(FakeCallState.settingUp(
          callerName: name,
          callerNumber: number,
          callerImagePath: image,
          timerSeconds: timer,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Set caller number
  Future<void> _onSetCallerNumber(Emitter<FakeCallState> emit, String number) async {
    state.maybeWhen(
      settingUp: (name, currentNumber, image, timer) {
        emit(FakeCallState.settingUp(
          callerName: name,
          callerNumber: number,
          callerImagePath: image,
          timerSeconds: timer,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Set caller image
  Future<void> _onSetCallerImage(Emitter<FakeCallState> emit, String? imagePath) async {
    state.maybeWhen(
      settingUp: (name, number, currentImage, timer) {
        emit(FakeCallState.settingUp(
          callerName: name,
          callerNumber: number,
          callerImagePath: imagePath,
          timerSeconds: timer,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Set timer duration
  Future<void> _onSetTimerDuration(Emitter<FakeCallState> emit, int seconds) async {
    state.maybeWhen(
      settingUp: (name, number, image, currentTimer) {
        emit(FakeCallState.settingUp(
          callerName: name,
          callerNumber: number,
          callerImagePath: image,
          timerSeconds: seconds,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Save caller details
  Future<void> _onSaveCallerDetails(Emitter<FakeCallState> emit) async {
    state.maybeWhen(
      settingUp: (name, number, image, timer) {
        if (name.isEmpty || number.isEmpty) {
          emit(const FakeCallState.error(
            message: 'Please enter caller name and number',
          ));
          return;
        }
        
        emit(FakeCallState.detailsSaved(
          callerName: name,
          callerNumber: number,
          callerImagePath: image,
          timerSeconds: timer,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Start fake call
  Future<void> _onStartFakeCall(Emitter<FakeCallState> emit) async {
     _countdownTimer?.cancel();
    
    final currentState = state;
    final name = currentState.callerName ?? '';
    final number = currentState.callerNumber ?? '';
    final image = currentState.callerImagePath;
    
    int timerSeconds = 5;
    currentState.maybeWhen(
      detailsSaved: (n, num, img, timer) {
        timerSeconds = timer;
      },
      orElse: () {},
    );
    
    if (name.isEmpty || number.isEmpty) {
      emit(const FakeCallState.error(
        message: 'Please set caller details first',
      ));
      return;
    }
    
    emit(FakeCallState.waiting(
      callerName: name,
      callerNumber: number,
      callerImagePath: image,
      remainingSeconds: timerSeconds,
    ));
    
    // Start countdown timer
    print('FakeCall: Starting timer with $timerSeconds seconds');
    _countdownTimer = Timer(Duration(seconds: timerSeconds), () {
      print('FakeCall: Timer finished - showing incoming call');
      add(const FakeCallEvent.showIncomingCall());
    });
  }
  
  /// Cancel fake call
  Future<void> _onCancelFakeCall(Emitter<FakeCallState> emit) async {
     _countdownTimer?.cancel();
    
    state.maybeWhen(
      waiting: (name, number, image, remaining) {
        emit(FakeCallState.detailsSaved(
          callerName: name,
          callerNumber: number,
          callerImagePath: image,
          timerSeconds: 5,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Show incoming call
  Future<void> _onShowIncomingCall(Emitter<FakeCallState> emit) async {
    final currentState = state;
    final name = currentState.callerName ?? '';
    final number = currentState.callerNumber ?? '';
    final image = currentState.callerImagePath;
    
    // Play ringtone
    await _ringtoneService.playRingtone();
    
    emit(FakeCallState.incomingCall(
      callerName: name,
      callerNumber: number,
      callerImagePath: image,
    ));
  }
  
  /// Answer call
  Future<void> _onAnswerCall(Emitter<FakeCallState> emit) async {
     _callDurationTimer?.cancel();
    
    // Stop ringtone
    await _ringtoneService.stopRingtone();
    
    final currentState = state;
    final name = currentState.callerName ?? '';
    final number = currentState.callerNumber ?? '';
    final image = currentState.callerImagePath;
    
    emit(FakeCallState.inCall(
      callerName: name,
      callerNumber: number,
      callerImagePath: image,
      callDurationSeconds: 0,
    ));
    
    // Start call duration timer
    int duration = 0;
    _callDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration++;
      add(FakeCallEvent.updateCallDuration(seconds: duration));
    });
  }
  
  /// Decline call
  Future<void> _onDeclineCall(Emitter<FakeCallState> emit) async {
     _countdownTimer?.cancel();
    
    // Stop ringtone
    await _ringtoneService.stopRingtone();
    
    emit(const FakeCallState.callEnded());
  }
  
  /// End call
  Future<void> _onEndCall(Emitter<FakeCallState> emit) async {
     _callDurationTimer?.cancel();
    emit(const FakeCallState.callEnded());
  }
  
  /// Update call duration
  Future<void> _onUpdateCallDuration(Emitter<FakeCallState> emit, int seconds) async {
    state.maybeWhen(
      inCall: (name, number, image, _) {
        emit(FakeCallState.inCall(
          callerName: name,
          callerNumber: number,
          callerImagePath: image,
          callDurationSeconds: seconds,
        ));
      },
      orElse: () {},
    );
  }
  
  /// Reset to initial state
  Future<void> _onReset(Emitter<FakeCallState> emit) async {
     _countdownTimer?.cancel();
     _callDurationTimer?.cancel();
    
    emit(const FakeCallState.settingUp(
      callerName: '',
      callerNumber: '',
      callerImagePath: null,
      timerSeconds: 5,
    ));
  }
  
  @override
  Future<void> close() async {
     _countdownTimer?.cancel();
     _callDurationTimer?.cancel();
    await _ringtoneService.stopRingtone();
    _ringtoneService.dispose();
    return super.close();
  }
}
