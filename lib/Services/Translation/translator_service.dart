abstract class TranslatorService {
  Future<String> translate({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
    required String expert,
  });
}
