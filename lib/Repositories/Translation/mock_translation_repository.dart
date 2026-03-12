import '../../Services/Translation/translator_service.dart';
import 'translation_repository.dart';

class MockTranslationRepository implements TranslationRepository {
  final TranslatorService translatorService;

  MockTranslationRepository({
    required this.translatorService,
  });

  @override
  Future<String> translateText({
    required String text,
    required String sourceLanguageCode,
    required String targetLanguageCode,
    required String expert,
  }) async {
    return translatorService.translate(
      text: text,
      sourceLanguageCode: sourceLanguageCode,
      targetLanguageCode: targetLanguageCode,
      expert: expert,
    );
  }
}
