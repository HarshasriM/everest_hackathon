import 'package:equatable/equatable.dart';
import '../../../data/models/sos_request_model.dart';

/// SOS States
abstract class SosState extends Equatable {
  const SosState();
  
  @override
  List<Object?> get props => [];
}

class SosInitial extends SosState {
  const SosInitial();
}

class SosCountdown extends SosState {
  final int remainingSeconds;
  
  const SosCountdown({required this.remainingSeconds});
  
  @override
  List<Object?> get props => [remainingSeconds];
}

class SosSending extends SosState {
  const SosSending();
}

class SosSuccess extends SosState {
  final SosResponseModel response;
  
  const SosSuccess({required this.response});
  
  @override
  List<Object?> get props => [response];
}

class SosError extends SosState {
  final String message;
  
  const SosError({required this.message});
  
  @override
  List<Object?> get props => [message];
}

class SosCancelled extends SosState {
  const SosCancelled();
}
