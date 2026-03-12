import '../../../Models/Translation/ai_expert_option_model.dart';
import '../../../Models/Translation/language_option_model.dart';
import '../../../Models/Translation/translation_example_model.dart';
import '../../../Models/Translation/translation_history_item_model.dart';

class TextTranslationState {
  final List<LanguageOptionModel> languages;
  final List<AiExpertOptionModel> experts;
  final List<TranslationExampleModel> examples;

  final List<TranslationHistoryItemModel> historyItems;
  final List<TranslationHistoryItemModel> favoriteItems;

  final LanguageOptionModel sourceLanguage;
  final LanguageOptionModel targetLanguage;
  final AiExpertOptionModel selectedExpert;

  final String sourceText;
  final String translatedText;

  final bool isLoading;
  final bool isHistoryLoading;

  const TextTranslationState({
    required this.languages,
    required this.experts,
    required this.examples,
    required this.historyItems,
    required this.favoriteItems,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.selectedExpert,
    required this.sourceText,
    required this.translatedText,
    required this.isLoading,
    required this.isHistoryLoading,
  });

  TextTranslationState copyWith({
    List<LanguageOptionModel>? languages,
    List<AiExpertOptionModel>? experts,
    List<TranslationExampleModel>? examples,
    List<TranslationHistoryItemModel>? historyItems,
    List<TranslationHistoryItemModel>? favoriteItems,
    LanguageOptionModel? sourceLanguage,
    LanguageOptionModel? targetLanguage,
    AiExpertOptionModel? selectedExpert,
    String? sourceText,
    String? translatedText,
    bool? isLoading,
    bool? isHistoryLoading,
  }) {
    return TextTranslationState(
      languages: languages ?? this.languages,
      experts: experts ?? this.experts,
      examples: examples ?? this.examples,
      historyItems: historyItems ?? this.historyItems,
      favoriteItems: favoriteItems ?? this.favoriteItems,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      selectedExpert: selectedExpert ?? this.selectedExpert,
      sourceText: sourceText ?? this.sourceText,
      translatedText: translatedText ?? this.translatedText,
      isLoading: isLoading ?? this.isLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
    );
  }

  factory TextTranslationState.initial() {
    const languages = [
      LanguageOptionModel(code: 'tr', name: 'Turkish', flag: '🇹🇷'),
      LanguageOptionModel(code: 'en', name: 'English', flag: '🇬🇧'),
      LanguageOptionModel(code: 'de', name: 'German', flag: '🇩🇪'),
      LanguageOptionModel(code: 'it', name: 'Italian', flag: '🇮🇹'),
      LanguageOptionModel(code: 'fr', name: 'French', flag: '🇫🇷'),
      LanguageOptionModel(code: 'es', name: 'Spain', flag: '🇪🇸'),
    ];

    const experts = [
      AiExpertOptionModel(title: 'General'),
      AiExpertOptionModel(title: 'Auto-Selection'),
      AiExpertOptionModel(title: 'Gourmet'),
      AiExpertOptionModel(title: 'Shopping'),
      AiExpertOptionModel(title: 'Business'),
      AiExpertOptionModel(title: 'Travel'),
      AiExpertOptionModel(title: 'Dating'),
      AiExpertOptionModel(title: 'Games'),
      AiExpertOptionModel(title: 'Health'),
      AiExpertOptionModel(title: 'Law'),
      AiExpertOptionModel(title: 'Art'),
      AiExpertOptionModel(title: 'Finance'),
      AiExpertOptionModel(title: 'Technology'),
      AiExpertOptionModel(title: 'News'),
    ];

    const examples = [
      TranslationExampleModel(
        sourceText: 'The weather is so nice today;\nI want to go for a walk.',
        translatedText: 'Bugün hava çok güzel; yürüyüşe çıkmak istiyorum.',
      ),
      TranslationExampleModel(
        sourceText: 'It’s a beautiful day; I think I’ll take a stroll.',
        translatedText: 'Harika bir gün; sanırım kısa bir yürüyüş yapacağım.',
      ),
    ];

    return TextTranslationState(
      languages: languages,
      experts: experts,
      examples: examples,
      historyItems: const [],
      favoriteItems: const [],
      sourceLanguage: languages[0],
      targetLanguage: languages[1],
      selectedExpert: experts[0],
      sourceText: 'Bugün hava çok güzel, biraz\n yürüyüş yapmak istiyorum.',
      translatedText:
          'The weather is very nice today,\nI want to go for a walk.',
      isLoading: false,
      isHistoryLoading: false,
    );
  }
}
