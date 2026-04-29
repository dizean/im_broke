import 'dart:convert';
import 'prompt_templates.dart';

class AIService {
  Future<Map<String, dynamic>> generateResponse({
    required String question,
    required Map<String, dynamic> context,
  }) async {
    final system = PromptTemplates.systemPrompt();
    final user = PromptTemplates.userPrompt(
      question: question,
      data: context,
    );

    final raw = await _mockAI(system, user);

    return _parse(raw);
  }

  // Replace later with OpenAI API
  Future<String> _mockAI(String system, String user) async {
    await Future.delayed(const Duration(milliseconds: 400));

    return jsonEncode({
      "answer":
          "You are still within budget but monitor spending closely.",
      "type": "info"
    });
  }

  Map<String, dynamic> _parse(String response) {
    try {
      return jsonDecode(response);
    } catch (_) {
      return {
        "answer": "Invalid AI response.",
        "type": "warning"
      };
    }
  }
}