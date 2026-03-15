import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lingola_app/Riverpod/Providers/onboarding_preferences_provider.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class OnboardingFlowView2 extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const OnboardingFlowView2({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  String _localizedLanguageName(AppLocalizations l10n, String code) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(onboardingControllerProvider);
    final c = ref.read(onboardingControllerProvider.notifier);

    final bottomPad = 18.h;
    final bottomCtaSpace = (51 + bottomPad + 12).h;

    void handleNext() {
      if (!s.canGoNext) return;
      onNext();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomCtaSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: SizedBox(
                          height: 44.h,
                          child: TextButton(
                            onPressed: onBack,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF9AA4B2),
                              padding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            child: Text(
                              l10n.back,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 69.h),
                    SizedBox(
                      key: const ValueKey('onboarding_title'),
                      width: 255.w,
                      child: Text(
                        l10n.onboardingFlow2Title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          height: 30 / 24,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    SizedBox(
                      width: 341.w,
                      child: Text(
                        l10n.onboardingFlow2Subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 15.sp,
                          height: 1.2,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    _FromToSegmentFigma(
                      fromText: l10n.from,
                      toText: l10n.to,
                      isFrom: s.isSelectingFrom,
                      onFromTap: () => c.setSelectingFrom(true),
                      onToTap: () => c.setSelectingFrom(false),
                    ),
                    SizedBox(height: 40.h),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.fromLTRB(36.w, 0, 36.w, 0),
                        itemCount: kLanguages.length,
                        separatorBuilder: (_, __) => SizedBox(height: 12.h),
                        itemBuilder: (_, i) {
                          final lang = kLanguages[i];

                          final selected = s.isSelectingFrom
                              ? lang.code == s.fromLangCode
                              : lang.code == s.toLangCode;

                          return _LanguagePill(
                            flagAsset: lang.flagAsset,
                            name: _localizedLanguageName(l10n, lang.code),
                            selected: selected,
                            onTap: () {
                              if (s.isSelectingFrom) {
                                c.setFromLang(lang.code);
                              } else {
                                c.setToLang(lang.code);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 0, 36.w, bottomPad),
                  child: SizedBox(
                    width: 321.w,
                    height: 51.h,
                    child: ElevatedButton(
                      onPressed: s.canGoNext ? handleNext : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0A70FF),
                        disabledBackgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        l10n.next,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FromToSegmentFigma extends StatelessWidget {
  final bool isFrom;
  final String fromText;
  final String toText;
  final VoidCallback onFromTap;
  final VoidCallback onToTap;

  const _FromToSegmentFigma({
    required this.isFrom,
    required this.fromText,
    required this.toText,
    required this.onFromTap,
    required this.onToTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 253.w,
      height: 37.h,
      child: Container(
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEF0),
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(
            color: const Color(0xFFD9D9DE),
            width: 0.w,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onFromTap,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        isFrom ? const Color(0xFFFFFFFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          fromText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                            height: 1.0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onToTap,
                child: Container(
                  decoration: BoxDecoration(
                    color:
                        !isFrom ? const Color(0xFFFFFFFF) : Colors.transparent,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          toText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.sp,
                            height: 1.0,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String flagAsset;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.flagAsset,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFF0A70FF) : const Color(0xFFDFDFDF);
    final borderWidth = selected ? 2.w : 1.w;
    final textColor =
        selected ? const Color(0xFF0A70FF) : const Color(0xFF000000);

    return SizedBox(
      width: 321.w,
      height: 51.h,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Row(
              children: [
                Image.asset(
                  flagAsset,
                  width: 24.w,
                  height: 18.h,
                  fit: BoxFit.cover,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String flagAsset;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flagAsset,
  });
}

const List<LanguageOption> kLanguages = [
  LanguageOption(
    code: 'tr',
    name: 'Turkish',
    flagAsset: 'assets/images/flags/Turkish.png',
  ),
  LanguageOption(
    code: 'en',
    name: 'English',
    flagAsset: 'assets/images/flags/English.png',
  ),
  LanguageOption(
    code: 'de',
    name: 'German',
    flagAsset: 'assets/images/flags/German.png',
  ),
  LanguageOption(
    code: 'it',
    name: 'Italian',
    flagAsset: 'assets/images/flags/Italian.png',
  ),
  LanguageOption(
    code: 'fr',
    name: 'French',
    flagAsset: 'assets/images/flags/French.png',
  ),
  LanguageOption(
    code: 'ja',
    name: 'Japanese',
    flagAsset: 'assets/images/flags/Japanese.png',
  ),
  LanguageOption(
    code: 'es',
    name: 'Spanish',
    flagAsset: 'assets/images/flags/Spanish.png',
  ),
  LanguageOption(
    code: 'ru',
    name: 'Russian',
    flagAsset: 'assets/images/flags/Russian.png',
  ),
  LanguageOption(
    code: 'pt',
    name: 'Portuguese',
    flagAsset: 'assets/images/flags/Portuguese.png',
  ),
  LanguageOption(
    code: 'ko',
    name: 'Korean',
    flagAsset: 'assets/images/flags/Korean.png',
  ),
  LanguageOption(
    code: 'hi',
    name: 'Hindi',
    flagAsset: 'assets/images/flags/Hindi.png',
  ),
];
