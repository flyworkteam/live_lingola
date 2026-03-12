import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appLocaleProvider =
    StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
  return AppLocaleNotifier()..loadSavedLocale();
});

class AppLocaleNotifier extends StateNotifier<Locale> {
  AppLocaleNotifier() : super(const Locale('en'));

  static const String _storageKey = 'app_locale_code';

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);

    if (code == null || code.trim().isEmpty) {
      state = const Locale('en');
      return;
    }

    state = Locale(code);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
  }

  Future<void> setByLanguageName(String language) async {
    switch (language.toLowerCase()) {
      case 'turkish':
        await setLocale(const Locale('tr'));
        break;
      case 'english':
        await setLocale(const Locale('en'));
        break;
      case 'german':
        await setLocale(const Locale('de'));
        break;
      case 'italian':
        await setLocale(const Locale('it'));
        break;
      case 'french':
        await setLocale(const Locale('fr'));
        break;
      case 'spanish':
        await setLocale(const Locale('es'));
        break;
      case 'japanese':
        await setLocale(const Locale('ja'));
        break;
      case 'russian':
        await setLocale(const Locale('ru'));
        break;
      case 'korean':
        await setLocale(const Locale('ko'));
        break;
      case 'hindi':
        await setLocale(const Locale('hi'));
        break;
      case 'portuguese':
        await setLocale(const Locale('pt'));
        break;
      default:
        await setLocale(const Locale('en'));
    }
  }
}
