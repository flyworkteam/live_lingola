import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/Core/config/app_config.dart';
import 'package:lingola_app/Core/widgets/voice_translate/voice_lang_bar.dart';
import 'package:lingola_app/Core/widgets/voice_translate/voice_text_card.dart';
import 'package:lingola_app/Core/widgets/voice_translate/voice_top_bar.dart';
import 'package:lingola_app/Riverpod/Providers/current_user_provider.dart';
import 'package:lingola_app/l10n/app_localizations.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum ProStage { empty, listening, result }

class VoiceTranslateProLiveView extends ConsumerStatefulWidget {
  final String sourceLanguage;
  final String targetLanguage;

  const VoiceTranslateProLiveView({
    super.key,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  ConsumerState<VoiceTranslateProLiveView> createState() =>
      _VoiceTranslateProLiveViewState();
}

class _VoiceTranslateProLiveViewState
    extends ConsumerState<VoiceTranslateProLiveView> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _speechReady = false;
  bool _isListening = false;
  bool _isSaving = false;
  bool _isFavorite = false;
  bool _isCopyActive = false;
  bool _isSpeaking = false;
  bool _isFinalizing = false;

  int? _lastSavedTranslationId;

  Timer? _copyTimer;
  Timer? _translateDebounce;
  Timer? _silenceTimer;

  late String _sourceLangCode;
  late String _targetLangCode;

  String _liveSourceText = '';
  String _liveTranslatedText = '';

  int _liveTranslateRequestId = 0;
  int _finalTranslateRequestId = 0;

  String _lastTranslatedSource = '';
  String _lastSubmittedSource = '';

  @override
  void initState() {
    super.initState();

    _sourceLangCode = _normalizeLanguageCode(widget.sourceLanguage);
    _targetLangCode = _normalizeLanguageCode(widget.targetLanguage);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initSpeech();
      await _initTts();
    });
  }

  @override
  void didUpdateWidget(covariant VoiceTranslateProLiveView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sourceLanguage != widget.sourceLanguage ||
        oldWidget.targetLanguage != widget.targetLanguage) {
      setState(() {
        _sourceLangCode = _normalizeLanguageCode(widget.sourceLanguage);
        _targetLangCode = _normalizeLanguageCode(widget.targetLanguage);

        _liveSourceText = '';
        _liveTranslatedText = '';
        _lastTranslatedSource = '';
        _lastSubmittedSource = '';
        _lastSavedTranslationId = null;
        _isFavorite = false;
        _isSpeaking = false;
        _isSaving = false;
        _isListening = false;
        _isFinalizing = false;
      });
    }
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _translateDebounce?.cancel();
    _silenceTimer?.cancel();
    _speech.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  ProStage get _stage {
    if (_isListening) return ProStage.listening;
    if (_liveSourceText.trim().isNotEmpty ||
        _liveTranslatedText.trim().isNotEmpty) {
      return ProStage.result;
    }
    return ProStage.empty;
  }

  String _normalizeLanguageCode(String value) {
    final v = value.trim().toLowerCase();

    switch (v) {
      case 'tr':
      case 'turkish':
      case 'türkçe':
      case 'turkce':
        return 'tr';
      case 'en':
      case 'english':
      case 'ingilizce':
        return 'en';
      case 'de':
      case 'german':
      case 'almanca':
      case 'deutsch':
        return 'de';
      case 'fr':
      case 'french':
      case 'fransızca':
      case 'fransizca':
        return 'fr';
      case 'es':
      case 'spanish':
      case 'ispanyolca':
      case 'español':
      case 'espanol':
        return 'es';
      case 'it':
      case 'italian':
      case 'italyanca':
      case 'italiano':
        return 'it';
      case 'ru':
      case 'russian':
      case 'rusça':
      case 'rusca':
        return 'ru';
      case 'pt':
      case 'portuguese':
      case 'portekizce':
        return 'pt';
      case 'ko':
      case 'korean':
      case 'korece':
        return 'ko';
      case 'hi':
      case 'hindi':
        return 'hi';
      case 'ja':
      case 'japanese':
      case 'japonca':
        return 'ja';
      default:
        return 'en';
    }
  }

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

  String _backendLanguageName(String code) {
    switch (code) {
      case 'tr':
        return 'Turkish';
      case 'en':
        return 'English';
      case 'de':
        return 'German';
      case 'it':
        return 'Italian';
      case 'fr':
        return 'French';
      case 'ja':
        return 'Japanese';
      case 'es':
        return 'Spanish';
      case 'ru':
        return 'Russian';
      case 'pt':
        return 'Portuguese';
      case 'ko':
        return 'Korean';
      case 'hi':
        return 'Hindi';
      default:
        return code;
    }
  }

  String _speechLocaleIdForLanguageCode(String code) {
    switch (code) {
      case 'tr':
        return 'tr_TR';
      case 'en':
        return 'en_US';
      case 'de':
        return 'de_DE';
      case 'fr':
        return 'fr_FR';
      case 'es':
        return 'es_ES';
      case 'it':
        return 'it_IT';
      case 'ru':
        return 'ru_RU';
      case 'pt':
        return 'pt_PT';
      case 'ko':
        return 'ko_KR';
      case 'hi':
        return 'hi_IN';
      case 'ja':
        return 'ja_JP';
      default:
        return 'en_US';
    }
  }

  String _ttsLocaleForLanguageCode(String code) {
    switch (code) {
      case 'tr':
        return 'tr-TR';
      case 'en':
        return 'en-US';
      case 'de':
        return 'de-DE';
      case 'fr':
        return 'fr-FR';
      case 'es':
        return 'es-ES';
      case 'it':
        return 'it-IT';
      case 'ru':
        return 'ru-RU';
      case 'pt':
        return 'pt-PT';
      case 'ko':
        return 'ko-KR';
      case 'hi':
        return 'hi-IN';
      case 'ja':
        return 'ja-JP';
      default:
        return 'en-US';
    }
  }

  String _flagAssetForLanguageCode(String code) {
    switch (code) {
      case 'tr':
        return 'assets/images/flags/Turkish.png';
      case 'en':
        return 'assets/images/flags/English.png';
      case 'de':
        return 'assets/images/flags/German.png';
      case 'fr':
        return 'assets/images/flags/French.png';
      case 'es':
        return 'assets/images/flags/Spanish.png';
      case 'it':
        return 'assets/images/flags/Italian.png';
      case 'ru':
        return 'assets/images/flags/Russian.png';
      case 'pt':
        return 'assets/images/flags/Portuguese.png';
      case 'ko':
        return 'assets/images/flags/Korean.png';
      case 'hi':
        return 'assets/images/flags/Hindi.png';
      case 'ja':
        return 'assets/images/flags/Japanese.png';
      default:
        return 'assets/images/flags/English.png';
    }
  }

  Future<void> _initSpeech() async {
    try {
      final ready = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: (error) {
          debugPrint('VOICE SPEECH ERROR: $error');
          if (!mounted) return;
          setState(() {
            _isListening = false;
          });
        },
        debugLogging: false,
      );

      if (!mounted) return;
      setState(() {
        _speechReady = ready;
      });

      debugPrint('VOICE SPEECH READY: $_speechReady');
    } catch (e) {
      debugPrint('VOICE SPEECH INIT ERROR: $e');
      if (!mounted) return;
      setState(() {
        _speechReady = false;
      });
    }
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.awaitSpeakCompletion(true);
      await _flutterTts.setSpeechRate(0.45);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _flutterTts.setStartHandler(() {
        if (!mounted) return;
        setState(() {
          _isSpeaking = true;
        });
      });

      _flutterTts.setCompletionHandler(() {
        if (!mounted) return;
        setState(() {
          _isSpeaking = false;
        });
      });

      _flutterTts.setCancelHandler(() {
        if (!mounted) return;
        setState(() {
          _isSpeaking = false;
        });
      });

      _flutterTts.setErrorHandler((message) {
        debugPrint('VOICE TTS ERROR: $message');
        if (!mounted) return;
        setState(() {
          _isSpeaking = false;
        });
      });
    } catch (e) {
      debugPrint('VOICE TTS INIT ERROR: $e');
    }
  }

  void _onSpeechStatus(String status) {
    debugPrint('VOICE PRO SPEECH STATUS: $status');

    if (!mounted) return;

    if (status == 'done' || status == 'notListening') {
      if (_isListening) {
        setState(() {
          _isListening = false;
        });
      }
    }
  }

  String? _currentFirebaseUid() {
    final user = ref.read(currentUserProvider);
    final uid = user?['firebase_uid']?.toString().trim();
    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  Widget _buildTranslatingLabel() {
    final t = AppLocalizations.of(context)!;

    return Text(
      t.translating,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 10.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: const Color(0xFF0A70FF),
      ),
    );
  }

  int? _extractTranslationId(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data["translation_id"] is int) return data["translation_id"] as int;
      if (data["id"] is int) return data["id"] as int;

      if (data["data"] is Map<String, dynamic>) {
        final inner = data["data"] as Map<String, dynamic>;
        if (inner["translation_id"] is int) {
          return inner["translation_id"] as int;
        }
        if (inner["id"] is int) return inner["id"] as int;
      }
    }
    return null;
  }

  String _extractTranslatedText(dynamic data, String sourceFallback) {
    if (data is Map<String, dynamic>) {
      if (data["translated_text"] is String &&
          (data["translated_text"] as String).trim().isNotEmpty) {
        return data["translated_text"] as String;
      }

      if (data["translatedText"] is String &&
          (data["translatedText"] as String).trim().isNotEmpty) {
        return data["translatedText"] as String;
      }

      if (data["translation"] is String &&
          (data["translation"] as String).trim().isNotEmpty) {
        return data["translation"] as String;
      }

      if (data["data"] is Map<String, dynamic>) {
        final inner = data["data"] as Map<String, dynamic>;

        if (inner["translated_text"] is String &&
            (inner["translated_text"] as String).trim().isNotEmpty) {
          return inner["translated_text"] as String;
        }

        if (inner["translatedText"] is String &&
            (inner["translatedText"] as String).trim().isNotEmpty) {
          return inner["translatedText"] as String;
        }

        if (inner["translation"] is String &&
            (inner["translation"] as String).trim().isNotEmpty) {
          return inner["translation"] as String;
        }
      }
    }

    return sourceFallback;
  }

  Future<void> _tapMic() async {
    final t = AppLocalizations.of(context)!;

    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    if (!_speechReady) {
      await _initSpeech();
    }

    if (!_speechReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.microphonePermissionRequired)),
      );
      return;
    }

    if (_isListening) {
      _translateDebounce?.cancel();
      _silenceTimer?.cancel();

      setState(() {
        _isListening = false;
      });

      try {
        await _speech.stop();
      } catch (e) {
        debugPrint('VOICE PRO STOP ERROR: $e');
      }

      if (_liveSourceText.trim().isNotEmpty) {
        await _finalizeTranslationAndSpeak();
      }
      return;
    }

    setState(() {
      _isListening = true;
      _isSaving = false;
      _isFavorite = false;
      _isCopyActive = false;
      _isSpeaking = false;
      _lastSavedTranslationId = null;
      _liveSourceText = '';
      _liveTranslatedText = '';
      _lastTranslatedSource = '';
      _lastSubmittedSource = '';
      _isFinalizing = false;
    });

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: _speechLocaleIdForLanguageCode(_sourceLangCode),
        listenFor: const Duration(minutes: 5),
        pauseFor: const Duration(seconds: 10),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
      );
    } catch (e) {
      debugPrint('VOICE PRO LISTEN ERROR: $e');
      if (!mounted) return;
      setState(() {
        _isListening = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final recognized = result.recognizedWords.trim();

    if (!mounted || recognized.isEmpty) return;

    setState(() {
      _liveSourceText = recognized;
    });

    _queueLiveTranslate();

    _silenceTimer?.cancel();
    _silenceTimer = Timer(const Duration(milliseconds: 1500), () {
      if (!_isListening) return;
      _finalizeTranslationAndSpeak();
    });

    if (result.finalResult) {
      _translateDebounce?.cancel();
      _silenceTimer?.cancel();
      _finalizeTranslationAndSpeak();
    }
  }

  void _queueLiveTranslate() {
    _translateDebounce?.cancel();
    _translateDebounce = Timer(
      const Duration(milliseconds: 450),
      _translateLiveText,
    );
  }

  Future<void> _translateLiveText() async {
    final firebaseUid = _currentFirebaseUid();
    final sourceText = _liveSourceText.trim();

    if (firebaseUid == null || sourceText.isEmpty) return;
    if (sourceText == _lastTranslatedSource) return;
    if (_isFinalizing) return;

    final requestId = ++_liveTranslateRequestId;

    if (mounted) {
      setState(() {});
    }

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/translate/text"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "firebase_uid": firebaseUid,
          "source_text": sourceText,
          "source_language": _backendLanguageName(_sourceLangCode),
          "target_language": _backendLanguageName(_targetLangCode),
          "expert": "Pro",
          "translation_type": "voice",
          "save_to_history": false,
        }),
      );

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (!mounted) return;
      if (requestId != _liveTranslateRequestId) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final translatedText = _extractTranslatedText(data, sourceText);

        setState(() {
          _liveTranslatedText = translatedText;
          _lastTranslatedSource = sourceText;
        });
      } else {
        debugPrint('VOICE PRO LIVE TRANSLATE STATUS: ${response.statusCode}');
        debugPrint('VOICE PRO LIVE TRANSLATE BODY: ${response.body}');
      }
    } catch (e) {
      debugPrint('VOICE PRO LIVE TRANSLATE ERROR: $e');
    } finally {
      if (mounted && requestId == _liveTranslateRequestId) {
        setState(() {});
      }
    }
  }

  Future<void> _finalizeTranslationAndSpeak() async {
    final firebaseUid = _currentFirebaseUid();
    final sourceText = _liveSourceText.trim();

    if (firebaseUid == null || sourceText.isEmpty) return;
    if (_isFinalizing) return;

    _translateDebounce?.cancel();
    _silenceTimer?.cancel();

    if (_isListening) {
      try {
        await _speech.stop();
      } catch (e) {
        debugPrint('VOICE PRO STOP BEFORE FINALIZE ERROR: $e');
      }

      if (mounted) {
        setState(() {
          _isListening = false;
        });
      }
    }

    if (sourceText == _lastSubmittedSource &&
        _liveTranslatedText.trim().isNotEmpty) {
      await _speakTranslatedText();
      return;
    }

    _isFinalizing = true;
    final requestId = ++_finalTranslateRequestId;
    _lastSubmittedSource = sourceText;

    if (mounted) {
      setState(() {
        _isSaving = true;
      });
    }

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/translate/text"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "firebase_uid": firebaseUid,
          "source_text": sourceText,
          "source_language": _backendLanguageName(_sourceLangCode),
          "target_language": _backendLanguageName(_targetLangCode),
          "expert": "Pro",
          "translation_type": "voice",
          "save_to_history": true,
        }),
      );

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (!mounted) return;
      if (requestId != _finalTranslateRequestId) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final translatedText = _extractTranslatedText(data, sourceText);
        final savedId = _extractTranslationId(data);

        setState(() {
          _liveTranslatedText = translatedText;
          _lastTranslatedSource = sourceText;
          _isSaving = false;
          if (savedId != null) {
            _lastSavedTranslationId = savedId;
          }
        });

        await _speakTranslatedText();
      } else {
        debugPrint('VOICE PRO FINAL TRANSLATE STATUS: ${response.statusCode}');
        debugPrint('VOICE PRO FINAL TRANSLATE BODY: ${response.body}');
        if (mounted) {
          setState(() {
            _isSaving = false;
          });
        }
      }
    } catch (e) {
      debugPrint('VOICE PRO FINAL TRANSLATE ERROR: $e');
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    } finally {
      _isFinalizing = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _copyTranslatedText(String text) async {
    final t = AppLocalizations.of(context)!;

    if (text.trim().isEmpty) return;

    await Clipboard.setData(ClipboardData(text: text));

    _copyTimer?.cancel();

    if (!mounted) return;
    setState(() {
      _isCopyActive = true;
    });

    _copyTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isCopyActive = false;
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.translationCopied)),
    );
  }

  Future<void> _speakTranslatedText() async {
    final text = _liveTranslatedText.trim();

    if (text.isEmpty) return;

    try {
      if (_isListening) {
        await _speech.stop();
        if (mounted) {
          setState(() {
            _isListening = false;
          });
        }
      }

      if (_isSpeaking) {
        await _flutterTts.stop();
      }

      await _flutterTts.stop();
      await _flutterTts.setLanguage(_ttsLocaleForLanguageCode(_targetLangCode));
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('VOICE PRO TTS SPEAK ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Voice playback failed')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    final t = AppLocalizations.of(context)!;

    if (_lastSavedTranslationId == null) {
      if (_liveSourceText.trim().isNotEmpty &&
          _liveTranslatedText.trim().isNotEmpty) {
        await _finalizeTranslationAndSpeak();
      }
    }

    if (_lastSavedTranslationId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.translationMustBeSavedFirst)),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/translate/favorite"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "translation_id": _lastSavedTranslationId,
          "is_favorite": !_isFavorite,
        }),
      );

      debugPrint('VOICE PRO FAVORITE STATUS: ${response.statusCode}');
      debugPrint('VOICE PRO FAVORITE BODY: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        setState(() {
          _isFavorite = !_isFavorite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? t.addedToFavorites : t.removedFromFavorites,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.favoriteUpdateFailed)),
        );
      }
    } catch (e) {
      debugPrint('VOICE PRO FAVORITE ERROR: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.favoriteUpdateFailed)),
      );
    }
  }

  Future<void> _swapLanguages() async {
    if (_isListening) return;

    if (_isSpeaking) {
      await _flutterTts.stop();
    }

    setState(() {
      final oldSource = _sourceLangCode;
      _sourceLangCode = _targetLangCode;
      _targetLangCode = oldSource;

      _liveSourceText = '';
      _liveTranslatedText = '';
      _lastTranslatedSource = '';
      _lastSubmittedSource = '';
      _lastSavedTranslationId = null;
      _isFavorite = false;
      _isSpeaking = false;
      _isSaving = false;
      _isListening = false;
      _isFinalizing = false;
    });
  }

  void _selectSourceLanguage() {
    if (_isListening) return;
  }

  void _selectTargetLanguage() {
    if (_isListening) return;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    ref.watch(currentUserProvider);

    final bottomPad = MediaQuery.of(context).padding.bottom;
    final stage = _stage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.2, -1.0),
                  end: const Alignment(-0.2, 1.0),
                  colors: [
                    const Color(0xFF0A70FF),
                    const Color(0xFF03B7FF),
                    const Color(0xFFEFF2F9).withValues(alpha: 0.72),
                    const Color(0xFFEFF2F9).withValues(alpha: 0.0),
                  ],
                  stops: const [0.0043, 0.2741, 0.575, 0.9957],
                ),
              ),
            ),
          ),
          Positioned(
            left: -150.w,
            top: 450.h,
            child: IgnorePointer(
              child: SizedBox(
                width: 680.w,
                height: 680.h,
                child: _isListening
                    ? Lottie.asset(
                        'assets/animations/Light-blue-orbit.json',
                        repeat: true,
                        fit: BoxFit.contain,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: VoiceTopBar(
                    title: t.realTimeTranslation,
                    onBack: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 51.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: VoiceLangBar(
                    leftFlagAsset: _flagAssetForLanguageCode(_sourceLangCode),
                    leftText: _localizedLanguageName(t, _sourceLangCode),
                    rightFlagAsset: _flagAssetForLanguageCode(_targetLangCode),
                    rightText: _localizedLanguageName(t, _targetLangCode),
                    onSwap: _swapLanguages,
                    onLeftTap: _selectSourceLanguage,
                    onRightTap: _selectTargetLanguage,
                  ),
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      children: [
                        if (stage != ProStage.empty) ...[
                          VoiceTextCard(
                            label: _localizedLanguageName(
                              t,
                              _sourceLangCode,
                            ).toUpperCase(),
                            text: _liveSourceText,
                            showBottomIcons: false,
                          ),
                          SizedBox(height: 12.h),
                          if (_liveTranslatedText.trim().isEmpty)
                            VoiceTextCard(
                              labelWidget: _buildTranslatingLabel(),
                              label: "",
                              text: "",
                              showBottomIcons: false,
                              showEmptyPlaceholder: true,
                            )
                          else
                            _TranslationResultCard(
                              isSaving: _isSaving,
                              translatedText: _liveTranslatedText,
                              isFavorite: _isFavorite,
                              isCopyActive: _isCopyActive,
                              onCopyTap: () =>
                                  _copyTranslatedText(_liveTranslatedText),
                              onFavoriteTap: _toggleFavorite,
                              onSpeakTap: _speakTranslatedText,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20.h + bottomPad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _VoiceMicButton(
                        onTap: _tapMic,
                        isListening: _isListening,
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 20.h,
                        child: _isListening
                            ? Text(
                                t.listening,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TranslationResultCard extends StatelessWidget {
  final bool isSaving;
  final String translatedText;
  final bool isFavorite;
  final bool isCopyActive;
  final VoidCallback onCopyTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onSpeakTap;

  const _TranslationResultCard({
    required this.isSaving,
    required this.translatedText,
    required this.isFavorite,
    required this.isCopyActive,
    required this.onCopyTap,
    required this.onFavoriteTap,
    required this.onSpeakTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140B2B6B),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isSaving ? t.saving : t.translation.toUpperCase(),
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6,
              color: const Color(0xFF0A70FF),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            translatedText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 22 / 16,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: onCopyTap,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  scale: isCopyActive ? 1.1 : 1.0,
                  child: SvgPicture.asset(
                    AppAssets.icCopy,
                    width: 18.sp,
                    height: 18.sp,
                    colorFilter: ColorFilter.mode(
                      isCopyActive
                          ? const Color(0xFF0A70FF)
                          : const Color(0xFFCBD5E1),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: onFavoriteTap,
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 180),
                  scale: isFavorite ? 1.08 : 1.0,
                  child: Icon(
                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                    size: 22.sp,
                    color: isFavorite
                        ? const Color(0xFFF59E0B)
                        : const Color(0xFFCBD5E1),
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: onSpeakTap,
                child: Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A70FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.icSes,
                      width: 18.sp,
                      height: 18.sp,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VoiceMicButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isListening;

  const _VoiceMicButton({
    required this.onTap,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 84.w,
        height: 84.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isListening ? const Color(0xFF0A70FF) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            AppAssets.icMicrophone,
            width: 50.w,
            height: 50.w,
            colorFilter: ColorFilter.mode(
              isListening ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
