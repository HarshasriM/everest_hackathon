import 'package:equatable/equatable.dart';
import '../../../domain/entities/sos_entity.dart';

/// SOS Events
abstract class SosEvent extends Equatable {
  const SosEvent();
  
  @override
  List<Object?> get props => [];
}

class SosStartCountdown extends SosEvent {
  const SosStartCountdown();
}

class SosCancelCountdown extends SosEvent {
  const SosCancelCountdown();
}

class SosCountdownTick extends SosEvent {
  final int remainingSeconds;
  
  const SosCountdownTick(this.remainingSeconds);
  
  @override
  List<Object?> get props => [remainingSeconds];
}

class SosSendAlert extends SosEvent {
  final String username;
  final List<String> phoneNumbers;
  final LocationEntity location;
  
  const SosSendAlert({
    required this.username,
    required this.phoneNumbers,
    required this.location,
  });
  
  @override
  List<Object?> get props => [username, phoneNumbers, location];
}

class SosReset extends SosEvent {
  const SosReset();
}
