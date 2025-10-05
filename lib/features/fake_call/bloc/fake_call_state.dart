import 'package:equatable/equatable.dart';

abstract class FakeCallState extends Equatable {
  const FakeCallState();
  @override
  List<Object?> get props => [];
}

class FakeCallInitial extends FakeCallState {}

class CallerSet extends FakeCallState {
  final String name;
  final String phone;
  final int duration;

  const CallerSet({required this.name, required this.phone, required this.duration});

  @override
  List<Object?> get props => [name, phone, duration];
}

class CallScheduled extends FakeCallState {
  final String name;
  final String phone;
  final int duration;

  const CallScheduled({required this.name, required this.phone, required this.duration});

  @override
  List<Object?> get props => [name, phone, duration];
}

class CallInProgress extends FakeCallState {
  final int elapsedSeconds;
  final String name;
  final String phone;

  const CallInProgress({required this.elapsedSeconds, required this.name, required this.phone});

  @override
  List<Object?> get props => [elapsedSeconds, name, phone];
}

class IncomingCall extends FakeCallState {
  final String name;
  final String phone;

  const IncomingCall({required this.name, required this.phone});

  @override
  List<Object?> get props => [name, phone];
}

class CallEnded extends FakeCallState {}
