import 'dart:convert';

class PromptTemplates {
  static String systemPrompt() {
    return '''
You are a strict budgeting assistant.

RULES:
- Only answer finance-related questions.
- If unrelated, say: "I can only help with budgeting and spending insights."
- Do not invent data.
- Keep responses short (max 3 sentences).
- Use ₱ currency.

OUTPUT MUST BE JSON:
{
  "answer": "...",
  "type": "info | warning | danger"
}
''';
  }

  static String userPrompt({
    required String question,
    required Map<String, dynamic> data,
  }) {
    return '''
QUESTION:
$question

DATA:
${jsonEncode(data)}

Answer ONLY using this data.
''';
  }
}