import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import 'calling_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  const IncomingCallScreen({super.key});

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isDisposed = false;

  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _playRingtone();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0.0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
  }

  void _playRingtone() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource("sounds/ringtone.mp3"));
    } catch (e) {
      print("Error playing ringtone: $e");
    }
  }

  void _stopRingtone() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      print("Error stopping ringtone: $e");
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _animationController.dispose();
    _stopRingtone();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _declineCall(BuildContext context) {
    if (!_isDisposed) {
      _stopRingtone();
      context.read<FakeCallBloc>().add(StopCall());

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.pop(context);
      });
    }
  }

  void _acceptCall(BuildContext context) {
    if (!_isDisposed) {
      _stopRingtone();
      context.read<FakeCallBloc>().add(AcceptCall());

      // Navigate safely after frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<FakeCallBloc>(),
              child:const CallingScreen(),
                          ),
          ),
          );
        }
      });
    }
  }

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.red,
      Colors.indigo,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
    ];
    if (name.isEmpty) return Colors.grey;
    int index = name.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FakeCallBloc, FakeCallState>(
      builder: (context, state) {
        String callerName = "Unknown Caller";
        String phoneNumber = "Unknown Number";

        if (state is IncomingCall) {
          callerName = state.name;
          phoneNumber = state.phone;
        } else if (state is CallScheduled) {
          callerName = state.name;
          phoneNumber = state.phone;
        } else if (state is CallerSet) {
          callerName = state.name;
          phoneNumber = state.phone;
        } else if (state is CallInProgress) {
          callerName = state.name;
          phoneNumber = state.phone;
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1a1a1a), Colors.black],
                    ),
                  ),
                ),
                Column(
                  children: [
                    const Spacer(flex: 2),
                    // Caller Avatar
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.green.withOpacity(0.5), width: 3),
                          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)],
                        ),
                        child: CircleAvatar(
                          backgroundColor: _getAvatarColor(callerName),
                          child: Text(
                            callerName.isNotEmpty ? callerName[0].toUpperCase() : '?',
                            style: const TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Caller Info
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          const Text(
                            "Incoming Call",
                            style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w300),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            callerName,
                            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w400),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            phoneNumber,
                            style: const TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    // Action Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionButton(icon: Icons.call_end, label: "Decline", color: Colors.red, onTap: () => _declineCall(context)),
                          _buildActionButton(icon: Icons.call, label: "Accept", color: Colors.green, onTap: () => _acceptCall(context)),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 15, spreadRadius: 5)]),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
