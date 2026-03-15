import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  TextToSpeechService._();

  static final FlutterTts _tts = FlutterTts();

  static Future<void> init({
    VoidCallback? onStart,
    VoidCallback? onComplete,
    VoidCallback? onCancel,
    void Function(String message)? onError,
  }) async {
    await _tts.setSharedInstance(true);
    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.45);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      onStart?.call();
    });

    _tts.setCompletionHandler(() {
      onComplete?.call();
    });

    _tts.setCancelHandler(() {
      onCancel?.call();
    });

    _tts.setErrorHandler((message) {
      onError?.call(message);
    });
  }

  static Future<void> speak({
    required String text,
    required String languageCode,
  }) async {
    await _tts.stop();
    await _tts.setLanguage(languageCode);
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }

  static String resolveLanguageCode(String code) {
    switch (code) {
      case 'tr':
        return 'tr-TR';
      case 'en':
        return 'en-US';
      case 'de':
        return 'de-DE';
      case 'it':
        return 'it-IT';
      case 'fr':
        return 'fr-FR';
      case 'ja':
        return 'ja-JP';
      case 'es':
        return 'es-ES';
      case 'ru':
        return 'ru-RU';
      case 'pt':
        return 'pt-PT';
      case 'ko':
        return 'ko-KR';
      case 'hi':
        return 'hi-IN';
      default:
        return 'en-US';
    }
  }
}
