import 'package:equatable/equatable.dart';
import 'package:everest_hackathon/features/helpline/helpline_model.dart';
// part of 'helpline_bloc.dart';

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
