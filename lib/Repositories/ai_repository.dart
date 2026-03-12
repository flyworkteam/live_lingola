import '../Services/AI/gemini_service.dart';

class AiRepository {
  final GeminiService _geminiService;

  AiRepository(this._geminiService);

  LingolaChatSession startChat() {
    return _geminiService.startChat();
  }

  Future<String> sendMessage({
    required LingolaChatSession chat,
    required String text,
  }) async {
    return _geminiService.sendMessage(
      chat: chat,
      message: text,
    );
  }
}
