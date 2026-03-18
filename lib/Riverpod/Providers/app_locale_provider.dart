import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final appLocaleProvider =
    StateNotifierProvider<AppLocaleNotifier, Locale?>((ref) {
  return AppLocaleNotifier()..loadInitialLocale();
});

class AppLocaleNotifier extends StateNotifier<Locale?> {
  AppLocaleNotifier() : super(null);

  String? _currentUserId;

  static const List<String> _supportedLanguageCodes = [
    'tr',
    'en',
    'de',
    'it',
    'fr',
    'es',
    'ja',
    'ru',
    'ko',
    'hi',
    'pt',
  ];

  static const String _globalStorageKey = 'app_locale_code';

  String _storageKeyForUser(String userId) => 'app_locale_code_$userId';

  Locale _deviceLocaleOrFallback() {
    final deviceLocale = PlatformDispatcher.instance.locale;
    final code = deviceLocale.languageCode.toLowerCase();

    if (_supportedLanguageCodes.contains(code)) {
      return Locale(code);
    }

    return const Locale('en');
  }

  bool _isSupportedCode(String? code) {
    if (code == null || code.trim().isEmpty) return false;
    return _supportedLanguageCodes.contains(code.toLowerCase());
  }

  Future<void> loadInitialLocale() async {
    final prefs = await SharedPreferences.getInstance();

    final globalCode = prefs.getString(_globalStorageKey);

    if (_isSupportedCode(globalCode)) {
      state = Locale(globalCode!.toLowerCase());
      return;
    }

    final fallback = _deviceLocaleOrFallback();
    state = fallback;
    await prefs.setString(_globalStorageKey, fallback.languageCode);
  }

  Future<void> loadForUser(String userId) async {
    _currentUserId = userId;

    final prefs = await SharedPreferences.getInstance();

    final userCode = prefs.getString(_storageKeyForUser(userId));
    if (_isSupportedCode(userCode)) {
      final locale = Locale(userCode!.toLowerCase());
      state = locale;
      await prefs.setString(_globalStorageKey, locale.languageCode);
      return;
    }

    final globalCode = prefs.getString(_globalStorageKey);
    if (_isSupportedCode(globalCode)) {
      final locale = Locale(globalCode!.toLowerCase());
      state = locale;
      await prefs.setString(_storageKeyForUser(userId), locale.languageCode);
      return;
    }

    final fallback = _deviceLocaleOrFallback();
    state = fallback;
    await prefs.setString(_globalStorageKey, fallback.languageCode);
    await prefs.setString(_storageKeyForUser(userId), fallback.languageCode);
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_globalStorageKey, locale.languageCode);

    final userId = _currentUserId;
    if (userId != null && userId.isNotEmpty) {
      await prefs.setString(_storageKeyForUser(userId), locale.languageCode);
    }
  }

  Future<void> clearLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final systemLocale = _deviceLocaleOrFallback();

    state = systemLocale;
    await prefs.setString(_globalStorageKey, systemLocale.languageCode);

    final userId = _currentUserId;
    if (userId != null && userId.isNotEmpty) {
      await prefs.setString(
        _storageKeyForUser(userId),
        systemLocale.languageCode,
      );
    }
  }

  void clearOnLogout() {
    _currentUserId = null;
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
