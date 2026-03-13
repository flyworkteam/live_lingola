import 'dart:convert';

import 'package:http/http.dart' as http;

class LingolaChatSession {
  final List<Map<String, dynamic>> history;

  LingolaChatSession({
    List<Map<String, dynamic>>? history,
  }) : history = history ?? [];
}

class GeminiService {
  GeminiService._();

  static final GeminiService instance = GeminiService._();

  static const String _baseUrl = 'https://livelingolaapp.fly-work.com';
  static const String _systemPrompt = '''
You are Lingola AI, a helpful assistant inside a language learning and translation app.

Rules:
- Be concise, clear, and friendly.
- If the user asks for travel help, give practical suggestions.
- If the user asks for translation, provide the translation first.
- If the user asks grammar questions, explain simply.
- Do not use unnecessary markdown.
''';

  LingolaChatSession startChat() {
    return LingolaChatSession(
      history: [
        {
          'role': 'system',
          'text': _systemPrompt,
        },
      ],
    );
  }

  Future<String> sendMessage({
    required LingolaChatSession chat,
    required String message,
  }) async {
    final userMessage = {
      'role': 'user',
      'text': message,
    };

    final requestHistory = [
      ...chat.history,
      userMessage,
    ];

    final response = await http.post(
      Uri.parse('$_baseUrl/chat/message'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'history': requestHistory,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(_extractErrorMessage(response.body));
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final text = (data['reply'] ?? '').toString().trim();

    if (text.isEmpty) {
      throw Exception('Empty response from chat service.');
    }

    chat.history.add(userMessage);
    chat.history.add({
      'role': 'model',
      'text': text,
    });

    return text;
  }

  String _extractErrorMessage(String body) {
    try {
      final Map<String, dynamic> data = jsonDecode(body);
      final error = data['error'];

      if (error is Map<String, dynamic>) {
        final message = error['message'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }

      if (error is String && error.isNotEmpty) {
        return error;
      }

      return body;
    } catch (_) {
      return body;
    }
  }
}
