import 'package:freezed_annotation/freezed_annotation.dart';

part 'fake_call_state.freezed.dart';

/// States for FakeCall BLoC
@freezed
class FakeCallState with _$FakeCallState {
  /// Initial state
  const factory FakeCallState.initial() = _Initial;
  
  /// Setting up caller details
  const factory FakeCallState.settingUp({
    required String callerName,
    required String callerNumber,
    String? callerImagePath,
    required int timerSeconds,
  }) = _SettingUp;
  
  /// Caller details saved
  const factory FakeCallState.detailsSaved({
    required String callerName,
    required String callerNumber,
    String? callerImagePath,
    required int timerSeconds,
  }) = _DetailsSaved;
  
  /// Waiting for fake call (timer running)
  const factory FakeCallState.waiting({
    required String callerName,
    required String callerNumber,
    String? callerImagePath,
    required int remainingSeconds,
  }) = _Waiting;
  
  /// Incoming call (ringing)
  const factory FakeCallState.incomingCall({
    required String callerName,
    required String callerNumber,
    String? callerImagePath,
  }) = _IncomingCall;
  
  /// Call answered (in call)
  const factory FakeCallState.inCall({
    required String callerName,
    required String callerNumber,
    String? callerImagePath,
    required int callDurationSeconds,
  }) = _InCall;
  
  /// Call ended
  const factory FakeCallState.callEnded() = _CallEnded;
  
  /// Error state
  const factory FakeCallState.error({
    required String message,
  }) = _Error;
}

/// Extension to get common properties
extension FakeCallStateExtension on FakeCallState {
  /// Check if caller details are set
  bool get hasCallerDetails => maybeWhen(
    settingUp: (name, number, image, timer) => name.isNotEmpty && number.isNotEmpty,
    detailsSaved: (name, number, image, timer) => true,
    waiting: (name, number, image, remaining) => true,
    incomingCall: (name, number, image) => true,
    inCall: (name, number, image, duration) => true,
    orElse: () => false,
  );
  
  /// Get caller name
  String? get callerName => maybeWhen(
    settingUp: (name, number, image, timer) => name,
    detailsSaved: (name, number, image, timer) => name,
    waiting: (name, number, image, remaining) => name,
    incomingCall: (name, number, image) => name,
    inCall: (name, number, image, duration) => name,
    orElse: () => null,
  );
  
  /// Get caller number
  String? get callerNumber => maybeWhen(
    settingUp: (name, number, image, timer) => number,
    detailsSaved: (name, number, image, timer) => number,
    waiting: (name, number, image, remaining) => number,
    incomingCall: (name, number, image) => number,
    inCall: (name, number, image, duration) => number,
    orElse: () => null,
  );
  
  /// Get caller image path
  String? get callerImagePath => maybeWhen(
    settingUp: (name, number, image, timer) => image,
    detailsSaved: (name, number, image, timer) => image,
    waiting: (name, number, image, remaining) => image,
    incomingCall: (name, number, image) => image,
    inCall: (name, number, image, duration) => image,
    orElse: () => null,
  );
  
  /// Check if in waiting state
  bool get isWaiting => maybeWhen(
    waiting: (name, number, image, remaining) => true,
    orElse: () => false,
  );
  
  /// Check if incoming call
  bool get isIncomingCall => maybeWhen(
    incomingCall: (name, number, image) => true,
    orElse: () => false,
  );
  
  /// Check if in call
  bool get isInCall => maybeWhen(
    inCall: (name, number, image, duration) => true,
    orElse: () => false,
  );
}
