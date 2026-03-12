import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TranslationUsage {
  daily,
  business,
  learning,
  travel,
  entertainment,
  other,
}

enum AppFeature {
  accurate,
  easy,
  privacy,
  teach,
  all,
}

class LanguageOption {
  final String code;
  final String name;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}

class OnboardingState {
  final int pageIndex;

  final TranslationUsage? usage;
  final String fromLangCode;
  final String toLangCode;

  final bool isSelectingFrom;

  final bool? usedAiBefore;
  final AppFeature? feature;

  final double createProgress;
  final bool profileCreated;
  final bool languageConfigured;
  final bool aiPrepared;

  const OnboardingState({
    this.pageIndex = 0,
    this.usage,
    this.fromLangCode = 'tr',
    this.toLangCode = 'en',
    this.isSelectingFrom = true,
    this.usedAiBefore,
    this.feature,
    this.createProgress = 0.0,
    this.profileCreated = false,
    this.languageConfigured = false,
    this.aiPrepared = false,
  });

  OnboardingState copyWith({
    int? pageIndex,
    TranslationUsage? usage,
    bool clearUsage = false,
    String? fromLangCode,
    String? toLangCode,
    bool? isSelectingFrom,
    bool? usedAiBefore,
    bool clearUsedAiBefore = false,
    AppFeature? feature,
    bool clearFeature = false,
    double? createProgress,
    bool? profileCreated,
    bool? languageConfigured,
    bool? aiPrepared,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      usage: clearUsage ? null : (usage ?? this.usage),
      fromLangCode: fromLangCode ?? this.fromLangCode,
      toLangCode: toLangCode ?? this.toLangCode,
      isSelectingFrom: isSelectingFrom ?? this.isSelectingFrom,
      usedAiBefore:
          clearUsedAiBefore ? null : (usedAiBefore ?? this.usedAiBefore),
      feature: clearFeature ? null : (feature ?? this.feature),
      createProgress: createProgress ?? this.createProgress,
      profileCreated: profileCreated ?? this.profileCreated,
      languageConfigured: languageConfigured ?? this.languageConfigured,
      aiPrepared: aiPrepared ?? this.aiPrepared,
    );
  }

  bool get canGoNext {
    switch (pageIndex) {
      case 0:
        return usage != null;
      case 1:
        return fromLangCode.isNotEmpty && toLangCode.isNotEmpty;
      case 2:
        return usedAiBefore != null;
      case 3:
        return feature != null;
      default:
        return true;
    }
  }

  LanguageOption? get fromLanguage =>
      kLanguages.where((e) => e.code == fromLangCode).firstOrNull;

  LanguageOption? get toLanguage =>
      kLanguages.where((e) => e.code == toLangCode).firstOrNull;

  String get usageKey {
    switch (usage) {
      case TranslationUsage.daily:
        return 'daily_communication';
      case TranslationUsage.business:
        return 'business_world';
      case TranslationUsage.learning:
        return 'language_learning';
      case TranslationUsage.travel:
        return 'travel';
      case TranslationUsage.entertainment:
        return 'entertainment';
      case TranslationUsage.other:
        return 'other';
      case null:
        return '';
    }
  }

  String get usageLabel {
    switch (usage) {
      case TranslationUsage.daily:
        return 'Daily Communication';
      case TranslationUsage.business:
        return 'Business World';
      case TranslationUsage.learning:
        return 'Language Learning';
      case TranslationUsage.travel:
        return 'Travel';
      case TranslationUsage.entertainment:
        return 'Entertainment';
      case TranslationUsage.other:
        return 'Other';
      case null:
        return '';
    }
  }

  String get usedAiBeforeKey {
    if (usedAiBefore == null) return '';
    return usedAiBefore! ? 'yes' : 'no';
  }

  String get usedAiBeforeLabel {
    if (usedAiBefore == null) return '';
    return usedAiBefore! ? 'Yes' : 'No';
  }

  String get featureKey {
    switch (feature) {
      case AppFeature.accurate:
        return 'accurate_translation';
      case AppFeature.easy:
        return 'easy_to_use';
      case AppFeature.privacy:
        return 'privacy_protection';
      case AppFeature.teach:
        return 'teach_me_a_language';
      case AppFeature.all:
        return 'all_of_them';
      case null:
        return '';
    }
  }

  String get featureLabel {
    switch (feature) {
      case AppFeature.accurate:
        return 'Accurate Translation';
      case AppFeature.easy:
        return 'Easy To Use';
      case AppFeature.privacy:
        return 'Privacy Protection';
      case AppFeature.teach:
        return 'Teach Me A Language';
      case AppFeature.all:
        return 'All Of Them';
      case null:
        return '';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'pageIndex': pageIndex,
      'usage': usageKey,
      'fromLangCode': fromLangCode,
      'toLangCode': toLangCode,
      'isSelectingFrom': isSelectingFrom,
      'usedAiBefore': usedAiBefore,
      'feature': featureKey,
      'createProgress': createProgress,
      'profileCreated': profileCreated,
      'languageConfigured': languageConfigured,
      'aiPrepared': aiPrepared,
    };
  }

  factory OnboardingState.initial() => const OnboardingState();
}

class OnboardingController extends StateNotifier<OnboardingState> {
  Timer? _timer;

  OnboardingController() : super(OnboardingState.initial());

  void setPage(int index) {
    state = state.copyWith(pageIndex: index);
  }

  void nextPage() {
    state = state.copyWith(pageIndex: state.pageIndex + 1);
  }

  void previousPage() {
    final nextIndex = state.pageIndex > 0 ? state.pageIndex - 1 : 0;
    state = state.copyWith(pageIndex: nextIndex);
  }

  void setUsage(TranslationUsage v) {
    state = state.copyWith(usage: v);
  }

  void clearUsage() {
    state = state.copyWith(clearUsage: true);
  }

  void setSelectingFrom(bool v) {
    state = state.copyWith(isSelectingFrom: v);
  }

  void setFromLang(String code) {
    state = state.copyWith(fromLangCode: code);
  }

  void setToLang(String code) {
    state = state.copyWith(toLangCode: code);
  }

  void selectLanguage(String code) {
    if (state.isSelectingFrom) {
      state = state.copyWith(fromLangCode: code);
    } else {
      state = state.copyWith(toLangCode: code);
    }
  }

  void swapLang() {
    state = state.copyWith(
      fromLangCode: state.toLangCode,
      toLangCode: state.fromLangCode,
    );
  }

  void setUsedAiBefore(bool v) {
    state = state.copyWith(usedAiBefore: v);
  }

  void clearUsedAiBefore() {
    state = state.copyWith(clearUsedAiBefore: true);
  }

  void setFeature(AppFeature v) {
    state = state.copyWith(feature: v);
  }

  void clearFeature() {
    state = state.copyWith(clearFeature: true);
  }

  void startCreating() {
    _timer?.cancel();

    state = state.copyWith(
      createProgress: 0.0,
      profileCreated: false,
      languageConfigured: false,
      aiPrepared: false,
    );

    _timer = Timer.periodic(const Duration(milliseconds: 120), (t) {
      final next = (state.createProgress + 0.02).clamp(0.0, 1.0);
      final p = next;

      state = state.copyWith(
        createProgress: p,
        profileCreated: p >= 0.34,
        languageConfigured: p >= 0.67,
        aiPrepared: p >= 0.92,
      );

      if (p >= 1.0) {
        t.cancel();
      }
    });
  }

  void resetAll() {
    _timer?.cancel();
    state = OnboardingState.initial();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

const kLanguages = <LanguageOption>[
  LanguageOption(code: 'tr', name: 'Turkish', flag: '🇹🇷'),
  LanguageOption(code: 'en', name: 'English', flag: '🇬🇧'),
  LanguageOption(code: 'de', name: 'German', flag: '🇩🇪'),
  LanguageOption(code: 'it', name: 'Italian', flag: '🇮🇹'),
  LanguageOption(code: 'fr', name: 'French', flag: '🇫🇷'),
  LanguageOption(code: 'ja', name: 'Japanese', flag: '🇯🇵'),
  LanguageOption(code: 'es', name: 'Spanish', flag: '🇪🇸'),
  LanguageOption(code: 'ru', name: 'Russian', flag: '🇷🇺'),
  LanguageOption(code: 'ko', name: 'Korean', flag: '🇰🇷'),
  LanguageOption(code: 'hi', name: 'Hindi', flag: '🇮🇳'),
  LanguageOption(code: 'pt', name: 'Portuguese', flag: '🇵🇹'),
];

extension _FirstOrNullExtension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
