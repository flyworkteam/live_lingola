import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final translationSourceLanguageProvider =
    StateNotifierProvider<TranslationSourceLanguageNotifier, String>((ref) {
  return TranslationSourceLanguageNotifier();
});

class TranslationSourceLanguageNotifier extends StateNotifier<String> {
  TranslationSourceLanguageNotifier() : super('en') {
    loadSourceLanguage();
  }

  static const String _sourceLanguageCodeKey =
      'selected_translation_source_language_code';

  Future<void> loadSourceLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_sourceLanguageCodeKey);

    if (code == null || code.isEmpty) {
      state = 'en';
      return;
    }

    state = code.toLowerCase();
  }

  Future<void> setSourceLanguage(String code) async {
    final normalized = code.trim().toLowerCase();
    if (normalized.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sourceLanguageCodeKey, normalized);
    state = normalized;
  }

  Future<void> resetSourceLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sourceLanguageCodeKey);
    state = 'en';
  }
}
