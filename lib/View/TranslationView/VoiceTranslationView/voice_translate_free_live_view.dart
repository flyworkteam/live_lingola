import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/Core/config/app_config.dart';
import 'package:lingola_app/Core/widgets/navigation/bottom_nav_item_tile.dart';
import 'package:lingola_app/Riverpod/Providers/current_user_provider.dart';
import 'package:lingola_app/l10n/app_localizations.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum _FreeStage { idle, listening, result }

class VoiceTranslateFreeLiveView extends ConsumerStatefulWidget {
  final String sourceLanguage;
  final String targetLanguage;

  const VoiceTranslateFreeLiveView({
    super.key,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  @override
  ConsumerState<VoiceTranslateFreeLiveView> createState() =>
      _VoiceTranslateFreeLiveViewState();
}

class _VoiceTranslateFreeLiveViewState
    extends ConsumerState<VoiceTranslateFreeLiveView> {
  _FreeStage _stage = _FreeStage.idle;

  final SpeechToText _speech = SpeechToText();

  bool _speechReady = false;
  bool _isSaving = false;
  bool _isTranslating = false;
  bool _translateOnManualStop = false;

  late String _leftLangCode;
  late String _rightLangCode;
  bool _isLeftSource = true;

  String _recognizedText = "";
  String _translatedText = "";

  int _translateRequestVersion = 0;
  String _lastSubmittedSource = "";

  @override
  void initState() {
    super.initState();

    _leftLangCode = _normalizeLanguageCode(widget.sourceLanguage);
    _rightLangCode = _normalizeLanguageCode(widget.targetLanguage);
    _isLeftSource = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initSpeech();
    });
  }

  @override
  void didUpdateWidget(covariant VoiceTranslateFreeLiveView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.sourceLanguage != widget.sourceLanguage ||
        oldWidget.targetLanguage != widget.targetLanguage) {
      setState(() {
        _leftLangCode = _normalizeLanguageCode(widget.sourceLanguage);
        _rightLangCode = _normalizeLanguageCode(widget.targetLanguage);
        _isLeftSource = true;
        _stage = _FreeStage.idle;
        _recognizedText = "";
        _translatedText = "";
        _lastSubmittedSource = "";
        _translateOnManualStop = false;
      });
    }
  }

  @override
  void dispose() {
    _speech.cancel();
    super.dispose();
  }

  bool get _isListening => _stage == _FreeStage.listening;

  String get _sourceLangCode => _isLeftSource ? _leftLangCode : _rightLangCode;
  String get _targetLangCode => _isLeftSource ? _rightLangCode : _leftLangCode;

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

  String? _currentFirebaseUid() {
    final user = ref.read(currentUserProvider);
    final uid = user?['firebase_uid']?.toString().trim();
    if (uid == null || uid.isEmpty) return null;
    return uid;
  }

  int? _currentUserId() {
    final user = ref.read(currentUserProvider);
    final rawId = user?['id'];
    if (rawId is int) return rawId;
    return int.tryParse('${rawId ?? ''}');
  }

  Future<void> _initSpeech() async {
    try {
      final ready = await _speech.initialize(
        onStatus: _onSpeechStatus,
        onError: (error) {
          debugPrint('VOICE FREE SPEECH ERROR: $error');
          if (!mounted) return;
          setState(() {
            _stage = _FreeStage.idle;
            _translateOnManualStop = false;
          });
        },
        debugLogging: false,
      );

      if (!mounted) return;
      setState(() {
        _speechReady = ready;
      });

      debugPrint('VOICE FREE SPEECH READY: $_speechReady');
    } catch (e) {
      debugPrint('VOICE FREE INIT ERROR: $e');
      if (!mounted) return;
      setState(() {
        _speechReady = false;
      });
    }
  }

  void _onSpeechStatus(String status) {
    debugPrint('VOICE FREE SPEECH STATUS: $status');

    if (!mounted) return;

    if (status == 'done' || status == 'notListening') {
      final shouldTranslate = _translateOnManualStop;
      final hasSource = _recognizedText.trim().isNotEmpty;

      setState(() {
        _stage = _FreeStage.idle;
      });

      if (shouldTranslate && hasSource) {
        _translateOnManualStop = false;
        _translateCurrentText(saveToHistory: true);
      } else {
        _translateOnManualStop = false;
      }
    }
  }

  Future<void> _toggleMic() async {
    final l10n = AppLocalizations.of(context)!;

    if (!_speechReady) {
      await _initSpeech();
    }

    if (!_speechReady) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.microphonePermissionRequired),
        ),
      );
      return;
    }

    if (_isListening) {
      setState(() {
        _stage = _FreeStage.idle;
        _translateOnManualStop = true;
      });

      await _speech.stop();
      return;
    }

    setState(() {
      _stage = _FreeStage.listening;
      _recognizedText = "";
      _translatedText = "";
      _lastSubmittedSource = "";
      _translateOnManualStop = false;
    });

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: _speechLocaleIdForLanguageCode(_sourceLangCode),
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
      );
    } catch (e) {
      debugPrint('VOICE FREE LISTEN ERROR: $e');
      if (!mounted) return;
      setState(() {
        _stage = _FreeStage.idle;
        _translateOnManualStop = false;
      });
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    final recognized = result.recognizedWords.trim();

    if (!mounted || recognized.isEmpty) return;

    setState(() {
      _recognizedText = recognized;
    });
  }

  Future<void> _translateCurrentText({required bool saveToHistory}) async {
    final firebaseUid = _currentFirebaseUid();
    final userId = _currentUserId();
    final sourceText = _recognizedText.trim();

    if (sourceText.isEmpty) return;
    if (firebaseUid == null && userId == null) return;
    if (_isTranslating) return;
    if (_lastSubmittedSource == sourceText) return;

    final requestVersion = ++_translateRequestVersion;
    _lastSubmittedSource = sourceText;
    _isTranslating = true;

    try {
      final payload = {
        if (userId != null) "user_id": userId,
        if (firebaseUid != null) "firebase_uid": firebaseUid,
        "source_text": sourceText,
        "source_language": _backendLanguageName(_sourceLangCode),
        "target_language": _backendLanguageName(_targetLangCode),
        "expert": "General",
        "translation_type": "voice",
        "save_to_history": saveToHistory,
      };

      debugPrint(
        'VOICE FREE TRANSLATE URL: ${AppConfig.baseUrl}/translate/text',
      );
      debugPrint('VOICE FREE TRANSLATE PAYLOAD: ${jsonEncode(payload)}');

      if (saveToHistory && mounted) {
        setState(() => _isSaving = true);
      }

      final response = await http.post(
        Uri.parse("${AppConfig.baseUrl}/translate/text"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint('VOICE FREE TRANSLATE STATUS: ${response.statusCode}');
      debugPrint('VOICE FREE TRANSLATE BODY: ${response.body}');

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (!mounted || requestVersion != _translateRequestVersion) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final translated = _extractTranslatedText(data, sourceText);

        setState(() {
          _translatedText = translated;
          _stage = _FreeStage.result;
        });
      } else {
        final errorMessage = _extractErrorMessage(data);
        debugPrint('VOICE FREE TRANSLATE SERVER ERROR: $errorMessage');

        setState(() {
          _translatedText = "";
          _stage = _FreeStage.result;
        });

        if (mounted && errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      }
    } catch (e) {
      debugPrint('VOICE FREE TRANSLATE ERROR: $e');
    } finally {
      _isTranslating = false;
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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

  String _extractErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final error = data["error"];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }

      if (data["message"] is String &&
          (data["message"] as String).trim().isNotEmpty) {
        return (data["message"] as String).trim();
      }
    }
    return "Translation failed";
  }

  void _selectLeftLanguage() {
    if (_isListening) return;

    setState(() {
      _isLeftSource = true;
      _stage = _FreeStage.idle;
      _recognizedText = "";
      _translatedText = "";
      _lastSubmittedSource = "";
      _translateOnManualStop = false;
    });
  }

  void _selectRightLanguage() {
    if (_isListening) return;

    setState(() {
      _isLeftSource = false;
      _stage = _FreeStage.idle;
      _recognizedText = "";
      _translatedText = "";
      _lastSubmittedSource = "";
      _translateOnManualStop = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(currentUserProvider);
    final l10n = AppLocalizations.of(context)!;

    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final bottomNavReserve = 62.h + 20.h + bottomPad;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF3F6FB)),
          ),
          Column(
            children: [
              SizedBox(height: topPad + 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  height: 44.h,
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.pop(context),
                        child: SizedBox(
                          width: 40.w,
                          height: 40.w,
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
                            l10n.voiceTranslateTitle,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 51.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.voiceTranslateSubtitle,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F0FF),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        l10n.tryNow,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A70FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                height: 112.h,
                width: double.infinity,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        height: 2.h,
                        color: const Color(0xFF0A70FF),
                      ),
                    ),
                    if (_isListening)
                      Positioned(
                        left: -10.w,
                        right: -10.w,
                        bottom: 0,
                        child: SizedBox(
                          height: 30.h,
                          child: Lottie.asset(
                            'assets/animations/wave-wave.json',
                            repeat: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                  child: Column(
                    children: [
                      if (_stage == _FreeStage.listening) ...[
                        Text(
                          l10n.listening,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _recognizedText.isEmpty ? "..." : _recognizedText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ] else if (_stage == _FreeStage.result) ...[
                        Text(
                          _isSaving
                              ? l10n.savingResult
                              : l10n.translationResults,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _translatedText.isEmpty ? "-" : _translatedText,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ] else ...[
                        const Spacer(),
                        const Spacer(),
                      ],
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            color: const Color(0xFF0A70FF),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.icMicrophone,
                              width: 14.w,
                              height: 14.w,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0A70FF),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              l10n.realTimeTranslation,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0A70FF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14.h),
                      _UnifiedLangBar(
                        height: 74.h,
                        isListening: _isListening,
                        isLeftSource: _isLeftSource,
                        leftLanguage:
                            _localizedLanguageName(l10n, _leftLangCode),
                        rightLanguage:
                            _localizedLanguageName(l10n, _rightLangCode),
                        onSelectLeft: _selectLeftLanguage,
                        onSelectRight: _selectRightLanguage,
                        onMicTap: _toggleMic,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _isListening
                            ? l10n.tapToTranslateNow
                            : l10n.selectLanguageToSpeak,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      SizedBox(height: bottomNavReserve),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: 2,
              onTap: (_) {},
              homeAsset: AppAssets.navHome,
              chatAsset: AppAssets.navChat,
              micAsset: AppAssets.navMic,
              cameraAsset: AppAssets.navCamera,
              outerBottomPadding: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnifiedLangBar extends StatelessWidget {
  final double height;
  final bool isListening;
  final bool isLeftSource;
  final String leftLanguage;
  final String rightLanguage;
  final VoidCallback onSelectLeft;
  final VoidCallback onSelectRight;
  final VoidCallback onMicTap;

  const _UnifiedLangBar({
    required this.height,
    required this.isListening,
    required this.isLeftSource,
    required this.leftLanguage,
    required this.rightLanguage,
    required this.onSelectLeft,
    required this.onSelectRight,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0A70FF);
    const dark = Color(0xFF0F172A);

    final isLeftActive = isListening && isLeftSource;
    final isRightActive = isListening && !isLeftSource;

    final r = 16.r;

    final double micSize = 84.w;
    final double micSlotW = 96.w;

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;

          final double micLeft = (w - micSize) / 2;
          final double micCenter = w / 2;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r),
                  child: Container(color: Colors.white),
                ),
              ),
              if (isLeftActive)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: micCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: Container(color: blue),
                  ),
                ),
              if (isRightActive)
                Positioned(
                  left: micCenter,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: Container(color: blue),
                  ),
                ),
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onSelectLeft,
                        child: Center(
                          child: Text(
                            leftLanguage,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isLeftActive ? Colors.white : dark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: micSlotW),
                    Expanded(
                      child: InkWell(
                        onTap: onSelectRight,
                        child: Center(
                          child: Text(
                            rightLanguage,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isRightActive ? Colors.white : dark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: micLeft,
                child: InkWell(
                  onTap: onMicTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: micSize,
                    height: micSize,
                    decoration: BoxDecoration(
                      color: isListening ? blue : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F0B2B6B),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Center(
                      child: isListening
                          ? Icon(
                              Icons.stop_rounded,
                              size: 34.sp,
                              color: Colors.white,
                            )
                          : SvgPicture.asset(
                              AppAssets.icMicrophone,
                              width: 30.w,
                              height: 30.w,
                              colorFilter: const ColorFilter.mode(
                                dark,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
