import 'package:freezed_annotation/freezed_annotation.dart';

part 'fake_call_event.freezed.dart';

/// Events for FakeCall BLoC
@freezed
class FakeCallEvent with _$FakeCallEvent {
  /// Initialize fake call
  const factory FakeCallEvent.initialize() = _Initialize;
  
  /// Set caller name
  const factory FakeCallEvent.setCallerName({
    required String name,
  }) = _SetCallerName;
  
  /// Set caller number
  const factory FakeCallEvent.setCallerNumber({
    required String number,
  }) = _SetCallerNumber;
  
  /// Set caller image path
  const factory FakeCallEvent.setCallerImage({
    required String? imagePath,
  }) = _SetCallerImage;
  
  /// Set timer duration
  const factory FakeCallEvent.setTimerDuration({
    required int seconds,
  }) = _SetTimerDuration;
  
  /// Save caller details
  const factory FakeCallEvent.saveCallerDetails() = _SaveCallerDetails;
  
  /// Start fake call timer
  const factory FakeCallEvent.startFakeCall() = _StartFakeCall;
  
  /// Cancel fake call
  const factory FakeCallEvent.cancelFakeCall() = _CancelFakeCall;
  
  /// Show incoming call
  const factory FakeCallEvent.showIncomingCall() = _ShowIncomingCall;
  
  /// Answer call
  const factory FakeCallEvent.answerCall() = _AnswerCall;
  
  /// Decline call
  const factory FakeCallEvent.declineCall() = _DeclineCall;
  
  /// End call
  const factory FakeCallEvent.endCall() = _EndCall;
  
  /// Update call duration
  const factory FakeCallEvent.updateCallDuration({
    required int seconds,
  }) = _UpdateCallDuration;
  
  /// Reset to initial state
  const factory FakeCallEvent.reset() = _Reset;
}
