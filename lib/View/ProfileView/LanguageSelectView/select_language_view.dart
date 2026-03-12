import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Core/Utils/assets.dart';
import '../../../Riverpod/Providers/app_locale_provider.dart';

class SelectLanguageView extends ConsumerStatefulWidget {
  const SelectLanguageView({super.key});

  @override
  ConsumerState<SelectLanguageView> createState() => _SelectLanguageViewState();
}

class _SelectLanguageViewState extends ConsumerState<SelectLanguageView> {
  late int _selected;

  final List<_Lang> _langs = const [
    _Lang("Turkish", "assets/images/flags/Turkish.png", "🇹🇷"),
    _Lang("English", "assets/images/flags/English.png", "🇬🇧"),
    _Lang("German", "assets/images/flags/German.png", "🇩🇪"),
    _Lang("Italian", "assets/images/flags/Italian.png", "🇮🇹"),
    _Lang("French", "assets/images/flags/French.png", "🇫🇷"),
    _Lang("Japanese", "assets/images/flags/Japanese.png", "🇯🇵"),
    _Lang("Spanish", "assets/images/flags/Spanish.png", "🇪🇸"),
    _Lang("Russian", "assets/images/flags/Russian.png", "🇷🇺"),
    _Lang("Korean", "assets/images/flags/Korean.png", "🇰🇷"),
    _Lang("Hindi", "assets/images/flags/Hindi.png", "🇮🇳"),
    _Lang("Portuguese", "assets/images/flags/Portuguese.png", "🇵🇹"),
  ];

  @override
  void initState() {
    super.initState();
    _selected = 1;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final locale = ref.read(appLocaleProvider);
    final currentCode = locale.languageCode.toLowerCase();

    final index = _langs.indexWhere(
      (e) => e.locale.languageCode.toLowerCase() == currentCode,
    );

    if (index != -1) {
      _selected = index;
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(fontFamily: 'Poppins')),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  String _localizedLanguageTitle(AppLocalizations t, String title) {
    switch (title) {
      case "Turkish":
        return t.languageTurkish;
      case "English":
        return t.languageEnglish;
      case "German":
        return t.languageGerman;
      case "Italian":
        return t.languageItalian;
      case "French":
        return t.languageFrench;
      case "Japanese":
        return t.languageJapanese;
      case "Spanish":
        return t.languageSpanish;
      case "Russian":
        return t.languageRussian;
      case "Korean":
        return t.languageKorean;
      case "Hindi":
        return t.languageHindi;
      case "Portuguese":
        return t.languagePortuguese;
      default:
        return title;
    }
  }

  Future<void> _applyLanguage() async {
    final t = AppLocalizations.of(context)!;
    final selectedLang = _langs[_selected];

    await ref.read(appLocaleProvider.notifier).setLocale(selectedLang.locale);

    if (!mounted) return;

    _toast(
      t.appLanguageChangedTo(
        _localizedLanguageTitle(t, selectedLang.title),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(18.w, 10.h, 18.w, 0),
              child: Column(
                children: [
                  _TopBar(
                    title: t.selectLanguage,
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  SizedBox(height: 18.h),
                  Expanded(
                    child: ListView.separated(
                      padding: EdgeInsets.only(bottom: (54.h + 16.h)),
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      itemCount: _langs.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, i) {
                        final l = _langs[i];
                        final selected = _selected == i;

                        return _LangPill(
                          title: _localizedLanguageTitle(t, l.title),
                          flagAsset: l.asset,
                          fallbackEmoji: l.emoji,
                          selected: selected,
                          onTap: () => setState(() => _selected = i),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 18.w,
              right: 18.w,
              bottom: 20,
              child: SizedBox(
                height: 54.h,
                child: ElevatedButton(
                  onPressed: _applyLanguage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1677FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                  ),
                  child: Text(
                    t.next,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
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

class _Lang {
  final String title;
  final String asset;
  final String emoji;
  final Locale locale;

  const _Lang(
    this.title,
    this.asset,
    this.emoji, {
    Locale? locale,
  }) : locale = locale ??
            (title == "Turkish"
                ? const Locale('tr')
                : title == "English"
                    ? const Locale('en')
                    : title == "German"
                        ? const Locale('de')
                        : title == "Italian"
                            ? const Locale('it')
                            : title == "French"
                                ? const Locale('fr')
                                : title == "Japanese"
                                    ? const Locale('ja')
                                    : title == "Spanish"
                                        ? const Locale('es')
                                        : title == "Russian"
                                            ? const Locale('ru')
                                            : title == "Korean"
                                                ? const Locale('ko')
                                                : title == "Hindi"
                                                    ? const Locale('hi')
                                                    : title == "Portuguese"
                                                        ? const Locale('pt')
                                                        : const Locale('en'));
}

class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const _TopBar({
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.icBack,
                  width: 24.sp,
                  height: 24.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0F172A),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  height: 26 / 20,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}

class _LangPill extends StatelessWidget {
  final String title;
  final String flagAsset;
  final String fallbackEmoji;
  final bool selected;
  final VoidCallback onTap;

  const _LangPill({
    required this.title,
    required this.flagAsset,
    required this.fallbackEmoji,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFF1677FF) : const Color(0xFFE2E8F0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28.r),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(color: borderColor, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 28.w,
              height: 20.h,
              child: Image.asset(
                flagAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    fallbackEmoji,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 15.sp,
                fontWeight: FontWeight.w300,
                height: 1.0,
                color: selected
                    ? const Color(0xFF1677FF)
                    : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
