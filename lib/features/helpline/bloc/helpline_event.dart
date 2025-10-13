import 'package:equatable/equatable.dart';

abstract class HelplineEvent extends Equatable {
  const HelplineEvent();

  @override
  List<Object> get props => [];
}

class LoadHelplines extends HelplineEvent {
  @override
  List<Object> get props => [];
}

class CallHelpline extends HelplineEvent {
  final String number;

  const CallHelpline(this.number);

  @override
  List<Object> get props => [number];
}
