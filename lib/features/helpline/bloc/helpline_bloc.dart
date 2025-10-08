import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:everest_hackathon/features/helpline/helpline_model.dart';

// Add these imports for your event and state files
import 'package:everest_hackathon/features/helpline/bloc/helpline_event.dart';
import 'package:everest_hackathon/features/helpline/bloc/helpline_state.dart';

class HelplineBloc extends Bloc<HelplineEvent, HelplineState> {
  HelplineBloc() : super(HelplineInitial()) {
    on<LoadHelplines>(_onLoadHelplines);
    on<CallHelpline>(_onCallHelpline);
  }

  void _onLoadHelplines(LoadHelplines event, Emitter<HelplineState> emit) {
    final helplines = [
      const Helpline(
        number: '112',
        name: 'National Helpline',
        icon: Icons.phone,
        color: Color(0xFFB8E6D5),
      ),
      const Helpline(
        number: '108',
        name: 'Ambulance',
        icon: Icons.local_hospital,
        color: Color(0xFFB8D4F1),
      ),
      const Helpline(
        number: '102',
        name: 'Pregnancy Medic',
        icon: Icons.pregnant_woman,
        color: Color(0xFFFFB8D4),
      ),
      const Helpline(
        number: '101',
        name: 'Fire Service',
        icon: Icons.local_fire_department,
        color: Color(0xFFFFF4B8),
      ),
      const Helpline(
        number: '100',
        name: 'Police',
        icon: Icons.local_police,
        color: Color(0xFFB8E1F1),
      ),
      const Helpline(
        number: '181',
        name: 'Women Helpline',
        icon: Icons.people,
        color: Color(0xFFF4F4B8),
      ),
      const Helpline(
        number: '1098',
        name: 'Child Helpline',
        icon: Icons.child_care,
        color: Color(0xFFB8E8F1),
      ),
    ];

    emit(HelplineLoaded(helplines));
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