import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_state.dart';
import '../bloc/fake_call_event.dart';

class CallingScreen extends StatelessWidget {
  const CallingScreen({super.key});

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FakeCallBloc, FakeCallState>(
      listener: (context, state) {
        if (state is CallEnded) {
          if (Navigator.canPop(context)) Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: BlocBuilder<FakeCallBloc, FakeCallState>(
        builder: (context, state) {
          if (state is! CallInProgress) {
            return const Scaffold(
              backgroundColor: Colors.black,
              body: Center(child: CircularProgressIndicator(color: Colors.white)),
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
                  const Spacer(flex: 2),
                  const CircleAvatar(radius: 50, backgroundColor: Colors.grey, child: Icon(Icons.person, size: 50, color: Colors.white)),
                  const SizedBox(height: 20),
                  Text(name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(phone, style: const TextStyle(color: Colors.white70, fontSize: 18)),
                  const SizedBox(height: 8),
                  Text(_formatDuration(elapsed), style: const TextStyle(color: Colors.white70, fontSize: 16)),
                  const Spacer(flex: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildControlButton(icon: Icons.dialpad, label: "KeyPad"),
                        _buildControlButton(icon: Icons.mic_off, label: "Mute", isActive: false),
                        _buildControlButton(icon: Icons.volume_up, label: "Speaker", isActive: false),
                        _buildControlButton(icon: Icons.pause, label: "Hold", isActive: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => context.read<FakeCallBloc>().add(StopCall()),
                    child: Container(width: 70, height: 70, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red), child: const Icon(Icons.call_end, size: 30, color: Colors.white)),
                  ),
                  const SizedBox(height: 10),
                  const Text("End Call", style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControlButton({required IconData icon, required String label, bool isActive = false}) {
    return Column(
      children: [
        Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[800]!.withOpacity(0.7)),
          child: Icon(icon, color: isActive ? Colors.blue : Colors.white, size: 25),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: isActive ? Colors.blue : Colors.white, fontSize: 12)),
      ],
    );
  }
}
