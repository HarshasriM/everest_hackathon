import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';

class CallingScreen extends StatefulWidget {
  @override
  _CallingScreenState createState() => _CallingScreenState();
}

class _CallingScreenState extends State<CallingScreen> {
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isHold = false;

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _toggleHold() {
    setState(() {
      _isHold = !_isHold;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FakeCallBloc, FakeCallState>(
      listener: (context, state) {
        if (state is CallEnded) {
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: BlocBuilder<FakeCallBloc, FakeCallState>(
        builder: (context, state) {
          if (state is! CallInProgress) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.popUntil(context, (route) => route.isFirst);
            });
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }

          final name = state.name;
          final phone = state.phone;
          final elapsed = state.elapsedSeconds;

          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  // Top spacer
                  const Spacer(flex: 2),
                  
                  // Caller Avatar
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person, 
                      size: 50, 
                      color: Colors.white
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Caller Name
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Phone Number
                  Text(
                    phone,
                    style: const TextStyle(
                      color: Colors.white70, 
                      fontSize: 18,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Call Duration
                  Text(
                    _formatDuration(elapsed),
                    style: const TextStyle(
                      color: Colors.white70, 
                      fontSize: 16,
                    ),
                  ),
                  
                  // Middle spacer
                  const Spacer(flex: 3),
                  
                  // Call control buttons - Single row with more options
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildCallControlButton(
                          icon: Icons.dialpad,
                          label: "KeyPad",
                          onTap: () {
                            // TODO: Implement dialpad
                          },
                        ),
                        _buildCallControlButton(
                          icon: Icons.mic_off,
                          activeIcon: Icons.mic,
                          label: "Mute",
                          isActive: _isMuted,
                          onTap: _toggleMute,
                        ),
                        _buildCallControlButton(
                          icon: Icons.volume_up,
                          label: "Speaker",
                          isActive: _isSpeakerOn,
                          onTap: _toggleSpeaker,
                        ),
                        
                        
                        _buildCallControlButton(
                          icon: Icons.pause,
                          activeIcon: Icons.play_arrow,
                          label: "Hold",
                          isActive: _isHold,
                          onTap: _toggleHold,
                        ),
                        // _buildCallControlButton(
                        //   icon: Icons.add_call,
                        //   label: "Add Call",
                        //   onTap: () {
                        //     // TODO: Implement add call
                        //   },
                        // ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // End Call Button
                  GestureDetector(
                    onTap: () {
                      context.read<FakeCallBloc>().add(StopCall());
                    },
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.call_end, 
                        size: 30, 
                        color: Colors.white
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  const Text(
                    "End Call", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCallControlButton({
    required IconData icon,
    IconData? activeIcon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[800]!.withOpacity(0.7),
          ),
          child: IconButton(
            icon: Icon(
              isActive ? (activeIcon ?? icon) : icon,
              color: isActive ? Colors.blue : Colors.white,
              size: 25,
            ),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.white,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}