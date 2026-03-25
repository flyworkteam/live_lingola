import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
  static final FlutterTts _tts = FlutterTts();

  static bool _isInitialized = false;
  static bool _isSpeaking = false;

  static Future<void> init({
    Function()? onStart,
    Function()? onComplete,
    Function()? onCancel,
    Function(String)? onError,
  }) async {
    if (_isInitialized) return;

    await _tts.setSharedInstance(true);
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.defaultMode,
    );

    await _tts.setVolume(1.0);

    await _tts.setSpeechRate(0.42);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() {
      _isSpeaking = true;
      onStart?.call();
    });

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onComplete?.call();
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
      onCancel?.call();
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      onError?.call(msg);
    });

    _isInitialized = true;
  }

  static Future<void> speak({
    required String text,
    required String languageCode,
  }) async {
    if (text.trim().isEmpty) return;

    try {
      if (_isSpeaking) {
        await _tts.stop();
      }

      await _tts.setLanguage(languageCode);

      await _setBestVoice(languageCode);

      await _tts.speak(text);
    } catch (e) {
      if (kDebugMode) {
        print("TTS SPEAK ERROR: $e");
      }
    }
  }

  static Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (e) {
      if (kDebugMode) {
        print("TTS STOP ERROR: $e");
      }
    }
  }

  static String resolveLanguageCode(String code) {
    switch (code) {
      case "tr":
        return "tr-TR";
      case "en":
        return "en-US";
      case "de":
        return "de-DE";
      case "fr":
        return "fr-FR";
      case "es":
        return "es-ES";
      case "it":
        return "it-IT";
      case "ru":
        return "ru-RU";
      case "ja":
        return "ja-JP";
      case "ko":
        return "ko-KR";
      case "hi":
        return "hi-IN";
      case "pt":
        return "pt-PT";
      default:
        return "en-US";
    }
  }

  static Future<void> _setBestVoice(String languageCode) async {
    try {
      final voices = await _tts.getVoices;

      if (voices is List) {
        final match = voices.firstWhere(
          (v) =>
              v is Map &&
              v["locale"] != null &&
              v["locale"].toString().toLowerCase().startsWith(
                    languageCode.split("-").first.toLowerCase(),
                  ),
          orElse: () => null,
        );

        if (match != null && match is Map) {
          await _tts.setVoice({
            "name": match["name"],
            "locale": match["locale"],
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("VOICE SELECT ERROR: $e");
      }
    }
  }
}
