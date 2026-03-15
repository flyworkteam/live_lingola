import 'package:lingola_app/Core/widgets/text_translation/models.dart';
import 'package:lingola_app/Core/widgets/text_translation/text_translation_models.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

String localizedLanguageName(AppLocalizations l10n, String code) {
  switch (code) {
    case 'tr':
      return l10n.languageTurkish;
    case 'en':
      return l10n.languageEnglish;
    case 'de':
      return l10n.languageGerman;
    case 'it':
      return l10n.languageItalian;
    case 'fr':
      return l10n.languageFrench;
    case 'ja':
      return l10n.languageJapanese;
    case 'es':
      return l10n.languageSpanish;
    case 'ru':
      return l10n.languageRussian;
    case 'pt':
      return l10n.languagePortuguese;
    case 'ko':
      return l10n.languageKorean;
    case 'hi':
      return l10n.languageHindi;
    default:
      return code;
  }
}

String backendLanguageName(String code) {
  switch (code) {
    case 'tr':
      return 'Turkish';
    case 'en':
      return 'English';
    case 'de':
      return 'German';
    case 'it':
      return 'Italian';
    case 'fr':
      return 'French';
    case 'ja':
      return 'Japanese';
    case 'es':
      return 'Spanish';
    case 'ru':
      return 'Russian';
    case 'pt':
      return 'Portuguese';
    case 'ko':
      return 'Korean';
    case 'hi':
      return 'Hindi';
    default:
      return code;
  }
}

String localizedExpertName(AppLocalizations l10n, String key) {
  switch (key) {
    case 'general':
      return l10n.expertGeneral;
    case 'autoSelection':
      return l10n.expertAutoSelection;
    case 'gourmet':
      return l10n.expertGourmet;
    case 'shopping':
      return l10n.expertShopping;
    case 'business':
      return l10n.expertBusiness;
    case 'travel':
      return l10n.expertTravel;
    case 'dating':
      return l10n.expertDating;
    case 'games':
      return l10n.expertGames;
    case 'health':
      return l10n.expertHealth;
    case 'law':
      return l10n.expertLaw;
    case 'art':
      return l10n.expertArt;
    case 'finance':
      return l10n.expertFinance;
    case 'technology':
      return l10n.expertTechnology;
    case 'news':
      return l10n.expertNews;
    default:
      return key;
  }
}

String backendExpertName(String key) {
  switch (key) {
    case 'general':
      return 'General';
    case 'autoSelection':
      return 'Auto-Selection';
    case 'gourmet':
      return 'Gourmet';
    case 'shopping':
      return 'Shopping';
    case 'business':
      return 'Business';
    case 'travel':
      return 'Travel';
    case 'dating':
      return 'Dating';
    case 'games':
      return 'Games';
    case 'health':
      return 'Health';
    case 'law':
      return 'Law';
    case 'art':
      return 'Art';
    case 'finance':
      return 'Finance';
    case 'technology':
      return 'Technology';
    case 'news':
      return 'News';
    default:
      return key;
  }
}

List<TextExampleItem> fallbackExamples({
  required AppLocalizations l10n,
  required String sourceLangCode,
}) {
  final isTurkishSource = sourceLangCode == 'tr';

  return [
    TextExampleItem(
      title: l10n.exampleTextTitle1,
      subtitle: l10n.exampleTextSubtitle1,
    ),
    TextExampleItem(
      title: l10n.exampleTextTitle2,
      subtitle: l10n.exampleTextSubtitle2,
    ),
    TextExampleItem(
      title: isTurkishSource
          ? "En yakın metro istasyonu nerede?"
          : "Where is the nearest metro station?",
      subtitle: isTurkishSource
          ? "Where is the nearest metro station?"
          : "En yakın metro istasyonu nerede?",
    ),
    TextExampleItem(
      title: isTurkishSource
          ? "Bunu daha resmi şekilde yazar mısın?"
          : "Can you rewrite this more formally?",
      subtitle: isTurkishSource
          ? "Can you rewrite this more formally?"
          : "Bunu daha resmi şekilde yazar mısın?",
    ),
    TextExampleItem(
      title: isTurkishSource
          ? "İki kişilik masa ayırtmak istiyorum."
          : "I would like to reserve a table for two.",
      subtitle: isTurkishSource
          ? "I would like to reserve a table for two."
          : "İki kişilik masa ayırtmak istiyorum.",
    ),
    TextExampleItem(
      title: isTurkishSource
          ? "Bu ürünün fiyatı ne kadar?"
          : "How much does this product cost?",
      subtitle: isTurkishSource
          ? "How much does this product cost?"
          : "Bu ürünün fiyatı ne kadar?",
    ),
  ];
}

const List<String> textTranslateExperts = [
  "general",
  "autoSelection",
  "gourmet",
  "shopping",
  "business",
  "travel",
  "dating",
  "games",
  "health",
  "law",
  "art",
  "finance",
  "technology",
  "news",
];

const List<LangItem> textTranslateLangs = [
  LangItem(name: "tr", flagAsset: "assets/images/flags/Turkish.png"),
  LangItem(name: "en", flagAsset: "assets/images/flags/English.png"),
  LangItem(name: "de", flagAsset: "assets/images/flags/German.png"),
  LangItem(name: "it", flagAsset: "assets/images/flags/Italian.png"),
  LangItem(name: "fr", flagAsset: "assets/images/flags/French.png"),
  LangItem(name: "es", flagAsset: "assets/images/flags/Spanish.png"),
  LangItem(name: "ru", flagAsset: "assets/images/flags/Russian.png"),
  LangItem(name: "pt", flagAsset: "assets/images/flags/Portuguese.png"),
  LangItem(name: "ko", flagAsset: "assets/images/flags/Korean.png"),
  LangItem(name: "hi", flagAsset: "assets/images/flags/Hindi.png"),
  LangItem(name: "ja", flagAsset: "assets/images/flags/Japanese.png"),
];
