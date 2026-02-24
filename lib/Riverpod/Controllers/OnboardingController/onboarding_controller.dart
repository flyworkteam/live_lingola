import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TranslationUsage {
  daily,
  business,
  learning,
  travel,
  entertainment,
  other
}

class LanguageOption {
  final String code;
  final String name;
  final String flag; // emoji
  const LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}

enum AppFeature { accurate, easy, privacy, teach, all }

class OnboardingState {
  final int pageIndex;

  final TranslationUsage? usage;
  final String fromLangCode;
  final String toLangCode;

  final bool isSelectingFrom;

  final bool? usedAiBefore;
  final AppFeature? feature;

  final double createProgress; // 0..1
  final bool profileCreated;
  final bool languageConfigured;
  final bool aiPrepared;

  const OnboardingState({
    this.pageIndex = 0,
    this.usage,
    this.fromLangCode = 'tr',
    this.toLangCode = 'en',
    this.isSelectingFrom = true, // default From
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
    String? fromLangCode,
    String? toLangCode,
    bool? isSelectingFrom,
    bool? usedAiBefore,
    AppFeature? feature,
    double? createProgress,
    bool? profileCreated,
    bool? languageConfigured,
    bool? aiPrepared,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      usage: usage ?? this.usage,
      fromLangCode: fromLangCode ?? this.fromLangCode,
      toLangCode: toLangCode ?? this.toLangCode,
      isSelectingFrom: isSelectingFrom ?? this.isSelectingFrom,
      usedAiBefore: usedAiBefore ?? this.usedAiBefore,
      feature: feature ?? this.feature,
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
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(),
);

class OnboardingController extends StateNotifier<OnboardingState> {
  Timer? _timer;

  OnboardingController() : super(const OnboardingState());

  void setPage(int index) => state = state.copyWith(pageIndex: index);

  void setUsage(TranslationUsage v) => state = state.copyWith(usage: v);

  void setSelectingFrom(bool v) => state = state.copyWith(isSelectingFrom: v);

  void setFromLang(String code) => state = state.copyWith(fromLangCode: code);

  void setToLang(String code) => state = state.copyWith(toLangCode: code);

  void swapLang() => state = state.copyWith(
        fromLangCode: state.toLangCode,
        toLangCode: state.fromLangCode,
      );

  void setUsedAiBefore(bool v) => state = state.copyWith(usedAiBefore: v);

  void setFeature(AppFeature v) => state = state.copyWith(feature: v);

  void startCreating() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (t) {
      final next = (state.createProgress + 0.02).clamp(0.0, 1.0);
      final p = next;

      state = state.copyWith(
        createProgress: p,
        profileCreated: p >= 0.34,
        languageConfigured: p >= 0.67,
        aiPrepared: p >= 0.92,
      );

      if (p >= 1.0) t.cancel();
    });
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
