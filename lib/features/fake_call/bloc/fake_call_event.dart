import 'package:equatable/equatable.dart';

abstract class FakeCallEvent extends Equatable {
  const FakeCallEvent();
  @override
  List<Object?> get props => [];
}

class SetCallerDetails extends FakeCallEvent {
  final String name;
  final String phone;
  final int duration;

  const SetCallerDetails({required this.name, required this.phone, required this.duration});

  @override
  List<Object?> get props => [name, phone, duration];
}

class ScheduleCall extends FakeCallEvent {}

class StartIncomingCall extends FakeCallEvent {}

class AcceptCall extends FakeCallEvent {}

class StopCall extends FakeCallEvent {}

class ResetCall extends FakeCallEvent {}

class CallTimerTick extends FakeCallEvent {
  final int elapsedSeconds;

  const CallTimerTick({required this.elapsedSeconds});

  @override
  List<Object?> get props => [elapsedSeconds];
}