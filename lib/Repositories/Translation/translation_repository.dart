abstract class TranslationRepository {
  Future<String> translateText({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
    required String expert,
  });
}
