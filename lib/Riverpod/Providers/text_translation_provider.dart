import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Repositories/Translation/mock_translation_history_repository.dart';
import '../../Repositories/Translation/mock_translation_repository.dart';
import '../../Repositories/Translation/translation_history_repository.dart';
import '../../Repositories/Translation/translation_repository.dart';
import '../../Riverpod/Controllers/TextTranslationController/text_translation_controller.dart';
import '../../Riverpod/Controllers/TextTranslationController/text_translation_state.dart';
import '../../Services/Translation/mock_translation_history_service.dart';
import '../../Services/Translation/mock_translator_service.dart';
import '../../Services/Translation/translation_history_service.dart';
import '../../Services/Translation/translator_service.dart';

final translatorServiceProvider = Provider<TranslatorService>((ref) {
  return MockTranslatorService();
});

final translationRepositoryProvider = Provider<TranslationRepository>((ref) {
  return MockTranslationRepository(
    translatorService: ref.read(translatorServiceProvider),
  );
});

final translationHistoryServiceProvider =
    Provider<TranslationHistoryService>((ref) {
  return MockTranslationHistoryService();
});

final translationHistoryRepositoryProvider =
    Provider<TranslationHistoryRepository>((ref) {
  return MockTranslationHistoryRepository(
    service: ref.read(translationHistoryServiceProvider),
  );
});

final textTranslationControllerProvider =
    StateNotifierProvider<TextTranslationController, TextTranslationState>(
        (ref) {
  return TextTranslationController(
    repository: ref.read(translationRepositoryProvider),
    historyRepository: ref.read(translationHistoryRepositoryProvider),
  );
});
