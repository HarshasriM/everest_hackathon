import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:everest_hackathon/features/helpline/helpline_model.dart';
// part of 'helpline_bloc.dart';
abstract class HelplineState extends Equatable {
  const HelplineState();

  @override
  List<Object> get props => [];
}

class HelplineInitial extends HelplineState {
  @override
  List<Object> get props => [];
}

class HelplineLoading extends HelplineState {
  @override
  List<Object> get props => [];
}

class HelplineLoaded extends HelplineState {
  final List<Helpline> helplines;

  const HelplineLoaded(this.helplines);

  @override
  List<Object> get props => [helplines];
}

class HelplineCalling extends HelplineState {
  final String number;

  const HelplineCalling(this.number);

  @override
  List<Object> get props => [number];
}

class HelplineError extends HelplineState {
  final String message;

  const HelplineError(this.message);

  @override
  List<Object> get props => [message];
}