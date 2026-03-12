import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Models/Translation/ai_expert_option_model.dart';
import '../../../Models/Translation/language_option_model.dart';
import '../../../Models/Translation/translation_history_item_model.dart';
import '../../../Repositories/Translation/translation_history_repository.dart';
import '../../../Repositories/Translation/translation_repository.dart';
import 'text_translation_state.dart';

class TextTranslationController extends StateNotifier<TextTranslationState> {
  final TranslationRepository repository;
  final TranslationHistoryRepository historyRepository;

  TextTranslationController({
    required this.repository,
    required this.historyRepository,
  }) : super(TextTranslationState.initial());

  void setSourceText(String value) {
    state = state.copyWith(sourceText: value);
  }

  void setSourceLanguage(LanguageOptionModel language) {
    state = state.copyWith(sourceLanguage: language);
  }

  void setTargetLanguage(LanguageOptionModel language) {
    state = state.copyWith(targetLanguage: language);
  }

  void setExpert(AiExpertOptionModel expert) {
    state = state.copyWith(selectedExpert: expert);
  }

  void swapLanguages() {
    state = state.copyWith(
      sourceLanguage: state.targetLanguage,
      targetLanguage: state.sourceLanguage,
    );
  }

  Future<void> translate() async {
    state = state.copyWith(isLoading: true);

    final translated = await repository.translateText(
      text: state.sourceText,
      sourceLanguageCode: state.sourceLanguage.code,
      targetLanguageCode: state.targetLanguage.code,
      expert: state.selectedExpert.title,
    );

    state = state.copyWith(
      translatedText: translated,
      isLoading: false,
    );
  }

  Future<void> saveCurrentTranslationToHistory() async {
    final source = state.sourceText.trim();
    final translated = state.translatedText.trim();

    if (source.isEmpty || translated.isEmpty) return;

    final item = TranslationHistoryItemModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      sourceText: source,
      translatedText: translated,
      sourceLanguageCode: state.sourceLanguage.code,
      sourceLanguageName: state.sourceLanguage.name,
      targetLanguageCode: state.targetLanguage.code,
      targetLanguageName: state.targetLanguage.name,
      expert: state.selectedExpert.title,
      isFavorite: false,
      createdAt: DateTime.now(),
    );

    await historyRepository.saveHistoryItem(item: item);
    await loadHistory();
    await loadFavorites();
  }

  Future<void> loadHistory() async {
    state = state.copyWith(isHistoryLoading: true);

    final items = await historyRepository.getHistory();

    state = state.copyWith(
      historyItems: items,
      isHistoryLoading: false,
    );
  }

  Future<void> loadFavorites() async {
    final items = await historyRepository.getFavorites();
    state = state.copyWith(favoriteItems: items);
  }

  Future<void> toggleFavorite(String id) async {
    final all = state.historyItems;
    final current = all.firstWhere((e) => e.id == id);

    await historyRepository.updateFavoriteStatus(
      id: id,
      isFavorite: !current.isFavorite,
    );

    await loadHistory();
    await loadFavorites();
  }

  Future<void> deleteHistoryItem(String id) async {
    await historyRepository.deleteHistoryItem(id: id);
    await loadHistory();
    await loadFavorites();
  }

  Future<void> clearHistory() async {
    await historyRepository.clearHistory();
    await loadHistory();
    await loadFavorites();
  }

  Future<void> clearFavorites() async {
    await historyRepository.clearFavorites();
    await loadHistory();
    await loadFavorites();
  }

  void loadExample(int index) {
    if (index < 0 || index >= state.examples.length) return;

    final example = state.examples[index];

    state = state.copyWith(
      sourceText: example.translatedText,
      translatedText: example.sourceText,
    );
  }
}
