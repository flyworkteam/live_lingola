import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final languageProvider =
    StateNotifierProvider<LanguageNotifier, Locale?>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<Locale?> {
  LanguageNotifier() : super(null) {
    loadLanguage();
  }

  static const String _languageCodeKey = 'selected_language_code';

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_languageCodeKey);

    if (code == null || code.isEmpty) {
      state = null; // sistem dili
      return;
    }

    state = Locale(code);
  }

  Future<void> setLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageCodeKey, code);
    state = Locale(code);
  }

  Future<void> useSystemLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_languageCodeKey);
    state = null; // tekrar sistem dili
  }
}
