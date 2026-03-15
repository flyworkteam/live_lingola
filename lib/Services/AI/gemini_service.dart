import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/config/app_config.dart';

class LingolaChatSession {
  final List<Map<String, dynamic>> history;

  LingolaChatSession({
    List<Map<String, dynamic>>? history,
  }) : history = history ?? [];
}

class GeminiService {
  GeminiService._();

  static final GeminiService instance = GeminiService._();

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

    final uri = Uri.parse('${AppConfig.baseUrl}/chat/message');

    try {
      final response = await http
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'history': requestHistory,
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(_extractErrorMessage(response.body));
      }

      final Map<String, dynamic> data = jsonDecode(response.body);

      final reply = (data['reply'] ?? '').toString().trim();

      if (reply.isEmpty) {
        throw Exception('Empty response from chat service.');
      }

      chat.history.add(userMessage);
      chat.history.add({
        'role': 'model',
        'text': reply,
      });

      return reply;
    } on TimeoutException {
      throw Exception('Chat request timed out.');
    } catch (e) {
      throw Exception('Chat failed: $e');
    }
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
