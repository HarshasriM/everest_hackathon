import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fake_call_event.dart';
import 'fake_call_state.dart';

class FakeCallBloc extends Bloc<FakeCallEvent, FakeCallState> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  
  // Store caller details as instance variables
  String _callerName = "";
  String _phoneNumber = "";
  int _duration = 0;

  FakeCallBloc() : super(FakeCallInitial()) {
    on<SetCallerDetails>((event, emit) {
      _callerName = event.name;
      _phoneNumber = event.phone;
      _duration = event.duration;
      emit(CallerSet(name: _callerName, phone: _phoneNumber, duration: _duration));
    });

    // on<ScheduleCall>((event, emit) {
    //   emit(CallScheduled(name: _callerName, phone: _phoneNumber, duration: _duration));
      
    //   // Schedule the incoming call
    //   Timer(Duration(seconds: _duration), () {
    //     add(StartIncomingCall());
    //   });
    // });

    on<ScheduleCall>((event, emit) {
  emit(CallScheduled(name: _callerName, phone: _phoneNumber, duration: _duration));
  
  _timer?.cancel();
  _timer = Timer(Duration(seconds: _duration), () {
    add(StartIncomingCall());
  });
});


    on<StartIncomingCall>((event, emit) {
       print("IncomingCall emitted with $_callerName ($_phoneNumber)");
      emit(IncomingCall(name: _callerName, phone: _phoneNumber));
    });

    on<AcceptCall>((event, emit) {
      _elapsedSeconds = 0;
      emit(CallInProgress(
        elapsedSeconds: _elapsedSeconds, 
        name: _callerName, 
        phone: _phoneNumber
      ));
      
      // Start call timer
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _elapsedSeconds++;
        add(CallTimerTick(elapsedSeconds: _elapsedSeconds));
      });
    });

    on<CallTimerTick>((event, emit) {
      emit(CallInProgress(
        elapsedSeconds: event.elapsedSeconds, 
        name: _callerName, 
        phone: _phoneNumber
      ));
    });

    on<StopCall>((event, emit) {
      _timer?.cancel();
      _elapsedSeconds = 0;
      emit(CallEnded());
    });

    on<ResetCall>((event, emit) {
      _timer?.cancel();
      _elapsedSeconds = 0;
      _callerName = "";
      _phoneNumber = "";
      _duration = 0;
      emit(FakeCallInitial());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}