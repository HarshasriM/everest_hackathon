import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

  Future<String> sendMessage(String message) async {
    try {
      final response = await _model.generateContent([Content.text(message)]);
      return response.text ?? "I'm here to help, but I didn’t catch that.";
    } catch (e) {
      return "Error: $e";
    }
  }
}
