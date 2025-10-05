import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';
import 'calling_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> with SingleTickerProviderStateMixin {
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

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
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
      Navigator.pop(context);
    }
  }

  void _acceptCall(BuildContext context) {
    if (!_isDisposed) {
      _stopRingtone();
      context.read<FakeCallBloc>().add(AcceptCall());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CallingScreen()),
      );
    }
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
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                // Background with gradient
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1a1a1a),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
                
                // Animated background circles
                // Positioned(
                //   top: -100,
                //   right: -100,
                //   child: ScaleTransition(
                //     scale: _pulseAnimation,
                //     child: Container(
                //       width: 300,
                //       height: 300,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.green.withOpacity(0.1),
                //       ),
                //     ),
                //   ),
                // ),
                
                // Positioned(
                //   bottom: -150,
                //   left: -100,
                //   child: ScaleTransition(
                //     scale: _pulseAnimation,
                //     child: Container(
                //       width: 400,
                //       height: 400,
                //       decoration: BoxDecoration(
                //         shape: BoxShape.circle,
                //         color: Colors.blue.withOpacity(0.05),
                //       ),
                //     ),
                //   ),
                // ),

                Column(
                  children: [
                    const Spacer(flex: 2),
                    
                    // Caller Avatar with pulse animation
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.green.withOpacity(0.5),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person, 
                            size: 60, 
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Caller Information with slide animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Text(
                            "Incoming Call", 
                            style: TextStyle(
                              color: Colors.white70, 
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 25),
                          Text(
                            callerName, 
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 32, 
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            phoneNumber, 
                            style: TextStyle(
                              color: Colors.white70, 
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 10),
                         
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
                          // Decline Button
                          _buildActionButton(
                            icon: Icons.call_end,
                            label: "Decline",
                            color: Colors.red,
                            onTap: () => _declineCall(context),
                            isDecline: true,
                          ),
                          
                          // Accept Button
                          _buildActionButton(
                            icon: Icons.call,
                            label: "Accept",
                            color: Colors.green,
                            onTap: () => _acceptCall(context),
                            isDecline: false,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 1),
                    
                    // Swipe up hint (like real phones)
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.0, 0.5),
                        end: const Offset(0.0, 0.2),
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      )),
                      child: Column(
                        children: [
                          Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white.withOpacity(0.5),
                            size: 30,
                          ),
                          Text(
                            "Swipe up to answer",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Status bar time (like real phone)
                // Positioned(
                //   top: 0,
                //   left: 0,
                //   right: 0,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 8),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Icon(
                //           Icons.lock,
                //           color: Colors.white.withOpacity(0.7),
                //           size: 16,
                //         ),
                //         const SizedBox(width: 8),
                //         StreamBuilder(
                //           stream: Stream.periodic(const Duration(seconds: 1)),
                //           builder: (context, snapshot) {
                //             return Text(
                //               _getCurrentTime(),
                //               style: TextStyle(
                //                 color: Colors.white.withOpacity(0.7),
                //                 fontSize: 16,
                //                 fontWeight: FontWeight.w400,
                //               ),
                //             );
                //           },
                //         ),
                //       ],
                //     ),
                  // ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    required bool isDecline,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 15,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 32,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}