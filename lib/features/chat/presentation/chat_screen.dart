import 'dart:async';

import 'package:everest_hackathon/core/services/gemini_service.dart';
import 'package:everest_hackathon/core/theme/color_scheme.dart';
import 'package:everest_hackathon/features/chat/presentation/widgets/animate_wave_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class ChatScreen extends StatefulWidget {
  final String apiKey;
  const ChatScreen({super.key, required this.apiKey});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  late GeminiService _geminiService;
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  bool _hasText = false;

  // Speech to Text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _recordingDuration = '0:00';
  Timer? _recordingTimer;
  int _recordingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _geminiService = GeminiService(widget.apiKey);
    _speech = stt.SpeechToText();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _scrollController.dispose();
    _recordingTimer?.cancel();
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (_hasText != hasText) {
      setState(() => _hasText = hasText);
    }
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || _isTyping) return;

    setState(() {
      _messages.add({'role': 'user', 'text': message});
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    try {
      final reply = await _geminiService.sendMessage(message);
      setState(() {
        _messages.add({'role': 'bot', 'text': reply});
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'bot',
          'text': 'Sorry, something went wrong. Please try again.',
        });
      });
    } finally {
      setState(() => _isTyping = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startRecordingTimer() {
    _recordingSeconds = 0;
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
        final minutes = _recordingSeconds ~/ 60;
        final seconds = _recordingSeconds % 60;
        _recordingDuration = '$minutes:${seconds.toString().padLeft(2, '0')}';
      });
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    setState(() {
      _recordingDuration = '0:00';
      _recordingSeconds = 0;
    });
  }

  Future<void> _startListening() async {
    // Dismiss keyboard first
    FocusScope.of(context).unfocus();

    // Wait for keyboard to close
    await Future.delayed(const Duration(milliseconds: 200));

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          _stopListening();
        }
      },
      onError: (error) {
        debugPrint("Speech error: $error");
        _stopListening();
        _showSnackBar('Error: Could not recognize speech');
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _startRecordingTimer();
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        },
      );
    } else {
      _showSnackBar('Speech recognition not available');
    }
  }

  void _stopListening() {
    _speech.stop();
    _stopRecordingTimer();
    setState(() => _isListening = false);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? cs.background : cs.background,
      appBar: _buildAppBar(theme, cs, isDark),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(cs, isDark)),
          _isListening ? _buildRecordingBar(cs, isDark) : _buildInputBar(cs, isDark),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorScheme cs, bool isDark) {
    final gradient = AppColorScheme.getPrimaryGradient(isDark);

    return AppBar(
      backgroundColor: cs.surface,
      elevation: 0,
      centerTitle: false,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.support_agent,
              color: theme.colorScheme.onPrimary,
              size: 24,
            ),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SHE Assistant",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: cs.onSurface,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            "Online • Ready to help",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: isDark ? AppColorScheme.getSafeGreen(isDark) : Colors.green,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [cs.surface.withOpacity(0.02), cs.surface.withOpacity(0.03)]
                  : [Colors.grey.shade200, Colors.grey.shade100, Colors.grey.shade200],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList(ColorScheme cs, bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator(cs);
        }

        final msg = _messages[index];
        final isUser = msg['role'] == 'user';
        return _buildMessageBubble(msg['text'] ?? '', isUser, cs, isDark);
      },
    );
  }

  Widget _buildTypingIndicator(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SpinKitThreeBounce(
          color: cs.primary,
          size: 20.0,
        ),
      ),
    );
  }

 Widget _buildMessageBubble(String text, bool isUser, ColorScheme cs, bool isDark) {
  // User bubble (right)
  final userBg = cs.primary;
  final userTextColor = cs.onPrimary;

  // Bot bubble (left) - make it more visible in dark mode
  final botBgLight = cs.surfaceContainerHighest; // light mode
  final botBgDark = cs.surface.withOpacity(0.06); // a slightly different shade in dark
  final botBg = isDark ? botBgDark : botBgLight;
  final botTextColor = cs.onSurface;

  final radius = BorderRadius.only(
    topLeft: const Radius.circular(16),
    topRight: const Radius.circular(16),
    bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
    bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
  );

  // add a border for dark mode to separate bubble from background
  final borderSide = isDark
      ? BorderSide(color: cs.onSurface.withOpacity(0.06), width: 1)
      : BorderSide(color: Colors.transparent, width: 0);

  final boxShadow = [
    BoxShadow(
      color: cs.shadow.withOpacity(isDark ? 0.04 : 0.06),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: isUser ? 8 : 8),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
      child: Material(
        color: Colors.transparent,
        elevation: isUser ? 0 : (isDark ? 2 : 0), // tiny elevation for bot in dark mode
        shadowColor: cs.shadow.withOpacity(0.06),
        borderRadius: radius,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          decoration: BoxDecoration(
            color: isUser ? userBg : botBg,
            borderRadius: radius,
            border: Border.fromBorderSide(borderSide),
            boxShadow: boxShadow,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isUser ? userTextColor : botTextColor,
              fontSize: 16,
              height: 1.3,
            ),
          ),
        ),
      ),
    ),
  );
}

  Widget _buildRecordingBar(ColorScheme cs, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: cs.inverseSurface,
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withOpacity(0.16),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Timer
            Text(
              _recordingDuration,
              style: TextStyle(
                color: cs.onInverseSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            // Animated Waveform
            Expanded(child: _buildWaveform(cs)),
            const SizedBox(width: 16),
            // Stop button
            GestureDetector(
              onTap: _stopListening,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: cs.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.stop,
                  color: cs.onPrimary,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveform(ColorScheme cs) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(40, (index) {
          return AnimatedWaveBar(
            delay: index * 50,
            color: cs.primary,
          );
        }),
      ),
    );
  }

  Widget _buildInputBar(ColorScheme cs, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.6) : Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(child: _buildTextField(cs, isDark)),
            const SizedBox(width: 10),
            _buildActionButton(cs, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(ColorScheme cs, bool isDark) {
    return TextField(
      controller: _controller,
      textInputAction: TextInputAction.send,
      onSubmitted: (_) => _sendMessage(),
      readOnly: _isListening, // Prevent keyboard when recording
      style: TextStyle(color: cs.onSurface),
      decoration: InputDecoration(
        hintText: "Ask something...",
        hintStyle: TextStyle(color: cs.onSurfaceVariant),
        filled: true,
        fillColor: isDark ? cs.surface.withOpacity(0.04) : cs.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? cs.onSurface.withOpacity(0.06) : Colors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? cs.onSurface.withOpacity(0.06) : Colors.transparent),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildActionButton(ColorScheme cs, bool isDark) {
    if (!_hasText) {
      return _buildVoiceButton(cs, isDark);
    }
    return _buildSendButton(cs, isDark);
  }

  Widget _buildVoiceButton(ColorScheme cs, bool isDark) {
    return GestureDetector(
      onLongPressStart: (_) => _startListening(),
      onLongPressEnd: (_) => _stopListening(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? cs.surface.withOpacity(0.06) : Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.mic_none, color: isDark ? cs.onSurface : Colors.grey, size: 28),
      ),
    );
  }

  Widget _buildSendButton(ColorScheme cs, bool isDark) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: cs.primary,
      child: IconButton(
        icon: Icon(Icons.send, color: cs.onPrimary),
        onPressed: _isTyping ? null : _sendMessage,
      ),
    );
  }
}
