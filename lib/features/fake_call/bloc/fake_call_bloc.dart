import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/ringtone_service.dart';
import '../../fake_call/data/fake_call_local_storage.dart';
import 'fake_call_event.dart';
import 'fake_call_state.dart';

class FakeCallBloc extends Bloc<FakeCallEvent, FakeCallState> {
  final RingtoneService _ringtoneService = RingtoneService();
  final FakeCallLocalStorage localStorage;

  Timer? _countdownTimer;
  Timer? _callDurationTimer;

  // Internal fields to keep current values across state variants
  String _callerName = '';
  String _callerNumber = '';
  String? _callerImagePath;
  int _timerSeconds = 5;

  FakeCallBloc(this.localStorage) : super(const FakeCallState.initial()) {
    on<FakeCallEvent>((event, emit) async {
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
    });
  }

  // ----------------------------------------------------
  // INITIALIZE (load saved caller details)
  // ----------------------------------------------------
  Future<void> _onInitialize(Emitter<FakeCallState> emit) async {
    final saved = await localStorage.getCallerDetails();

    if (saved != null) {
      _callerName = saved['name'] as String;
      _callerNumber = saved['number'] as String;
      _callerImagePath = saved['image'] as String?;
      _timerSeconds = (saved['timer'] as int?) ?? 5;

      emit(FakeCallState.detailsSaved(
        callerName: _callerName,
        callerNumber: _callerNumber,
        callerImagePath: _callerImagePath,
        timerSeconds: _timerSeconds,
      ));
    } else {
      // keep internal defaults but emit settingUp
      _callerName = '';
      _callerNumber = '';
      _callerImagePath = null;
      _timerSeconds = 5;

      emit(const FakeCallState.settingUp(
        callerName: '',
        callerNumber: '',
        callerImagePath: null,
        timerSeconds: 5,
      ));
    }
  }

  // ----------------------------------------------------
  // SETTERS — update internal fields and emit settingUp
  // ----------------------------------------------------
  Future<void> _onSetCallerName(
      Emitter<FakeCallState> emit, String name) async {
    _callerName = name;
    emit(FakeCallState.settingUp(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  Future<void> _onSetCallerNumber(
      Emitter<FakeCallState> emit, String number) async {
    _callerNumber = number;
    emit(FakeCallState.settingUp(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  Future<void> _onSetCallerImage(
      Emitter<FakeCallState> emit, String? image) async {
    _callerImagePath = image;
    emit(FakeCallState.settingUp(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  Future<void> _onSetTimerDuration(
      Emitter<FakeCallState> emit, int seconds) async {
    _timerSeconds = seconds;
    emit(FakeCallState.settingUp(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  // ----------------------------------------------------
  // SAVE CALLER DETAILS (persist and emit detailsSaved)
  // ----------------------------------------------------
  Future<void> _onSaveCallerDetails(Emitter<FakeCallState> emit) async {
    // Validate
    if (_callerName.trim().isEmpty || _callerNumber.trim().isEmpty) {
      emit(const FakeCallState.error(
        message: "Please enter caller name and number",
      ));
      return;
    }

    // Persist
    await localStorage.saveCallerDetails(
      name: _callerName,
      number: _callerNumber,
      imagePath: _callerImagePath,
      timer: _timerSeconds,
    );

    // Emit saved state
    emit(FakeCallState.detailsSaved(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  // ----------------------------------------------------
  // START FAKE CALL
  // ----------------------------------------------------
  Future<void> _onStartFakeCall(Emitter<FakeCallState> emit) async {
    _countdownTimer?.cancel();

    // Use internal fields (most recent)
    final name = _callerName;
    final number = _callerNumber;
    final image = _callerImagePath;
    final timerSeconds = _timerSeconds;

    if (name.isEmpty || number.isEmpty) {
      emit(const FakeCallState.error(
        message: "Please set caller details first",
      ));
      return;
    }

    emit(FakeCallState.waiting(
      callerName: name,
      callerNumber: number,
      callerImagePath: image,
      remainingSeconds: timerSeconds,
    ));

    _countdownTimer = Timer(Duration(seconds: timerSeconds), () {
      add(const FakeCallEvent.showIncomingCall());
    });
  }

  // ----------------------------------------------------
  // CANCEL FAKE CALL
  // ----------------------------------------------------
  Future<void> _onCancelFakeCall(Emitter<FakeCallState> emit) async {
    _countdownTimer?.cancel();

    // Restore to saved/details state (use internal fields which hold latest)
    emit(FakeCallState.detailsSaved(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  // ----------------------------------------------------
  // INCOMING CALL
  // ----------------------------------------------------
  Future<void> _onShowIncomingCall(Emitter<FakeCallState> emit) async {
    await _ringtoneService.playRingtone();

    emit(FakeCallState.incomingCall(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
    ));
  }

  // ----------------------------------------------------
  // ANSWER CALL
  // ----------------------------------------------------
  Future<void> _onAnswerCall(Emitter<FakeCallState> emit) async {
    await _ringtoneService.stopRingtone();
    _callDurationTimer?.cancel();

    emit(FakeCallState.inCall(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      callDurationSeconds: 0,
    ));

    int duration = 0;
    _callDurationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      duration++;
      add(FakeCallEvent.updateCallDuration(seconds: duration));
    });
  }

  // ----------------------------------------------------
  // DECLINE CALL
  // ----------------------------------------------------
  Future<void> _onDeclineCall(Emitter<FakeCallState> emit) async {
    _countdownTimer?.cancel();
    await _ringtoneService.stopRingtone();

    // Keep saved details
    emit(FakeCallState.detailsSaved(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  // ----------------------------------------------------
  // END CALL
  // ----------------------------------------------------
  Future<void> _onEndCall(Emitter<FakeCallState> emit) async {
    _callDurationTimer?.cancel();
    await _ringtoneService.stopRingtone();

    // Keep saved details after the call ends
    emit(FakeCallState.detailsSaved(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      timerSeconds: _timerSeconds,
    ));
  }

  // ----------------------------------------------------
  // UPDATE CALL DURATION
  // ----------------------------------------------------
  Future<void> _onUpdateCallDuration(
      Emitter<FakeCallState> emit, int seconds) async {
    // Stay in inCall state with updated duration
    emit(FakeCallState.inCall(
      callerName: _callerName,
      callerNumber: _callerNumber,
      callerImagePath: _callerImagePath,
      callDurationSeconds: seconds,
    ));
  }

  // ----------------------------------------------------
  // RESET
  // DOES NOT CLEAR SAVED CALLER DETAILS
  // ----------------------------------------------------
  Future<void> _onReset(Emitter<FakeCallState> emit) async {
    _countdownTimer?.cancel();
    _callDurationTimer?.cancel();

    final saved = await localStorage.getCallerDetails();

    if (saved != null) {
      _callerName = saved['name'] as String;
      _callerNumber = saved['number'] as String;
      _callerImagePath = saved['image'] as String?;
      _timerSeconds = (saved['timer'] as int?) ?? 5;

      emit(FakeCallState.detailsSaved(
        callerName: _callerName,
        callerNumber: _callerNumber,
        callerImagePath: _callerImagePath,
        timerSeconds: _timerSeconds,
      ));
    } else {
      _callerName = '';
      _callerNumber = '';
      _callerImagePath = null;
      _timerSeconds = 5;

      emit(const FakeCallState.settingUp(
        callerName: '',
        callerNumber: '',
        callerImagePath: null,
        timerSeconds: 5,
      ));
    }
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
