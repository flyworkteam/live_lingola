import 'translator_service.dart';

class MockTranslatorService implements TranslatorService {
  @override
  Future<String> translate({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
    required String expert,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (text.trim().isEmpty) return '';

    if (text.trim() ==
            "Bugün hava çok güzel, biraz\n yürüyüş yapmak istiyorum." ||
        text.trim() ==
            "Bugün hava çok güzel, biraz yürüyüş yapmak istiyorum.") {
      return "The weather is very nice today,\nI want to go for a walk.";
    }

    return "[Mock Translation][$expert] $text";
  }
}
