import 'package:everest_hackathon/features/fake_call/presentations/incoming_call_screen.dart';
import 'package:everest_hackathon/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import 'fake_call_input_screen.dart';

class FakeCallScreen extends StatelessWidget {
  const FakeCallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FakeCallBloc, FakeCallState>(
      listener: (context, state) {
        if (state is IncomingCall) {
        //  context.push(AppRoutes.incoming);
        context.push(
  AppRoutes.incoming,
  extra: context.read<FakeCallBloc>(),
);


        }
      },
      child: BlocBuilder<FakeCallBloc, FakeCallState>(
        builder: (context, state) {
          String callerName = "Caller Details";
          String phoneNumber = "";
          int duration = 5;
          String statusText = "Set caller details to schedule a call";
          bool canSchedule = false;

          if (state is CallerSet) {
            callerName = state.name;
            phoneNumber = state.phone;
            duration = state.duration;
            statusText = "Ready to schedule call";
            canSchedule = true;
          } else if (state is CallScheduled) {
            callerName = state.name;
            phoneNumber = state.phone;
            duration = state.duration;
            statusText = "Call scheduled - incoming in $duration seconds";
            canSchedule = false;
          } else if (state is IncomingCall) {
            callerName = state.name;
            phoneNumber = state.phone;
            canSchedule = false;
          } else if (state is CallInProgress) {
            callerName = state.name;
            phoneNumber = state.phone;
            statusText = "Call in progress";
            canSchedule = false;
          } else if (state is CallEnded) {
            callerName = "Caller Details";
            phoneNumber = "";
            statusText = "Call ended. Set new details to schedule another call.";
            canSchedule = false;
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    "Fake Call",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2E384D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Schedule a fake call to help you exit uncomfortable situations",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // Caller Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:Theme.of(context).primaryColor,
                    
                      borderRadius: BorderRadius.circular(16),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color:  Theme.of(context).primaryColor,
                      //     blurRadius: 10,
                      //     offset: const Offset(0, 4),
                      //   ),
                      // ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.2),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 2,
                                  ),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      callerName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (phoneNumber.isNotEmpty) 
                                      Text(
                                        phoneNumber,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        statusText,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FakeCallInputScreen(),
                              ),
                            );
                            if (result != null) {
                              context.read<FakeCallBloc>().add(SetCallerDetails(
                                name: result['name'],
                                phone: result['phone'],
                                duration: result['duration'],
                              ));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  
                  // Schedule Button
                  Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: canSchedule 
                              ? const Color(0xFF4DC9B4).withOpacity(0.3)
                              : Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canSchedule 
                            ? Theme.of(context).primaryColor
                            : Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: canSchedule
                          ? () => context.read<FakeCallBloc>().add(ScheduleCall())
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.schedule,
                            color: Colors.white,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Schedule Fake Call",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Info Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: const Color(0xFF6B7AE6),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "How it works",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E384D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "• Set caller name and number\n"
                          "• Choose when the call should come\n"
                          "• Use it to exit uncomfortable situations safely",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Safety Message
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF4DC9B4).withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.security,
                          color: const Color(0xFF4DC9B4),
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Your safety is our priority. Use this feature responsibly.",
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color(0xFF2E384D),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}