import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:everest_hackathon/features/helpline/helpline_model.dart';

// Add these imports for your event and state files
import 'package:everest_hackathon/features/helpline/bloc/helpline_event.dart';
import 'package:everest_hackathon/features/helpline/bloc/helpline_state.dart';
import 'package:everest_hackathon/features/helpline/data/helpline_data.dart';

class HelplineBloc extends Bloc<HelplineEvent, HelplineState> {
  HelplineBloc() : super(HelplineInitial()) {
    on<LoadHelplines>(_onLoadHelplines);
    on<CallHelpline>(_onCallHelpline);
  }

void _onLoadHelplines(LoadHelplines event, Emitter<HelplineState> emit) {
  print("Loaded helplines: $helplineList");
  emit(HelplineLoaded(helplineList));
}

  Future<void> _onCallHelpline(
      CallHelpline event, Emitter<HelplineState> emit) async {
    try {
      emit(HelplineCalling(event.number));
      
      final Uri phoneUri = Uri(scheme: 'tel', path: event.number);
      
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        emit(const HelplineError('Could not launch phone dialer'));
      }
      
      // Reload helplines after attempting to call
      add(LoadHelplines());
    } catch (e) {
      emit(HelplineError('Error: ${e.toString()}'));
      add(LoadHelplines());
    }
  }
}