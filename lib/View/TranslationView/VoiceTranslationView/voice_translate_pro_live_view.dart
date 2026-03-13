import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:lingola_app/Core/widgets/voice_translate/voice_lang_bar.dart';
import 'package:lingola_app/Core/widgets/voice_translate/voice_text_card.dart';
import 'package:lingola_app/Core/widgets/voice_translate/voice_top_bar.dart';
import 'package:lingola_app/Core/Utils/assets.dart';
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
    extends ConsumerState<VoiceTranslateProLiveView>
    with TickerProviderStateMixin {
static const String _baseUrl = "https://livelingolaapp.fly-work.com";

  late final AnimationController _waveCtrl;
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _speechReady = false;
  bool _isListening = false;
  bool _isSaving = false;
  bool _isFavorite = false;
  bool _isCopyActive = false;
  bool _isSpeaking = false;

  int? _lastSavedTranslationId;
  Timer? _copyTimer;
  Timer? _translateDebounce;

  late String _sourceLanguage;
  late String _targetLanguage;

  String _liveSourceText = '';
  String _liveTranslatedText = '';

  int _translateRequestVersion = 0;
  String _lastTranslatedSource = '';

  @override
  void initState() {
    super.initState();

    _sourceLanguage = widget.sourceLanguage;
    _targetLanguage = widget.targetLanguage;

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20000),
    )..repeat();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initSpeech();
      await _initTts();
    });
  }

  @override
  void dispose() {
    _copyTimer?.cancel();
    _translateDebounce?.cancel();
    _waveCtrl.dispose();
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
    debugPrint('VOICE SPEECH STATUS: $status');

    if (!mounted) return;

    if (status == 'done' || status == 'notListening') {
      final wasListening = _isListening;
      final hasText = _liveSourceText.trim().isNotEmpty;

      setState(() {
        _isListening = false;
      });

      if (wasListening && hasText) {
        _translateDebounce?.cancel();
        _translateCurrentText(saveToHistory: true);
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
    return AnimatedBuilder(
      animation: _waveCtrl,
      builder: (context, child) {
        final t = AppLocalizations.of(context)!;
        final dots = ((_waveCtrl.value * 100) % 4).toInt();
        final dotText = "." * dots;
        return Text(
          "${t.translating}$dotText",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: const Color(0xFF0A70FF),
          ),
        );
      },
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

  String _speechLocaleIdForLanguage(String language) {
    switch (language) {
      case 'Turkish':
        return 'tr_TR';
      case 'English':
        return 'en_US';
      case 'German':
        return 'de_DE';
      case 'French':
        return 'fr_FR';
      case 'Spanish':
        return 'es_ES';
      case 'Italian':
        return 'it_IT';
      default:
        return 'tr_TR';
    }
  }

  String _ttsLocaleForLanguage(String language) {
    switch (language) {
      case 'Turkish':
        return 'tr-TR';
      case 'English':
        return 'en-US';
      case 'German':
        return 'de-DE';
      case 'French':
        return 'fr-FR';
      case 'Spanish':
        return 'es-ES';
      case 'Italian':
        return 'it-IT';
      default:
        return 'en-US';
    }
  }

  String _flagAssetForLanguage(String language) {
    switch (language) {
      case 'Turkish':
        return 'assets/images/flags/Turkish.png';
      case 'English':
        return 'assets/images/flags/English.png';
      case 'German':
        return 'assets/images/flags/German.png';
      case 'French':
        return 'assets/images/flags/French.png';
      case 'Spanish':
        return 'assets/images/flags/Spanish.png';
      case 'Italian':
        return 'assets/images/flags/Italian.png';
      default:
        return 'assets/images/flags/Turkish.png';
    }
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
        SnackBar(
          content: Text(t.microphonePermissionRequired),
        ),
      );
      return;
    }

    if (_isListening) {
      await _speech.stop();
      return;
    }

    setState(() {
      _isListening = true;
      _isSaving = false;
      _isFavorite = false;
      _isCopyActive = false;
      _lastSavedTranslationId = null;
      _liveSourceText = '';
      _liveTranslatedText = '';
      _lastTranslatedSource = '';
    });

    try {
      await _speech.listen(
        onResult: _onSpeechResult,
        localeId: _speechLocaleIdForLanguage(_sourceLanguage),
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
      );
    } catch (e) {
      debugPrint('VOICE LISTEN ERROR: $e');
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

    _queueTranslate(saveToHistory: false);

    if (result.finalResult) {
      _translateDebounce?.cancel();
      _translateCurrentText(saveToHistory: true);
    }
  }

  void _queueTranslate({required bool saveToHistory}) {
    _translateDebounce?.cancel();
    _translateDebounce = Timer(
      const Duration(milliseconds: 450),
      () => _translateCurrentText(saveToHistory: saveToHistory),
    );
  }

  Future<void> _translateCurrentText({required bool saveToHistory}) async {
    final firebaseUid = _currentFirebaseUid();
    final sourceText = _liveSourceText.trim();

    if (firebaseUid == null || sourceText.isEmpty) return;
    if (!saveToHistory && sourceText == _lastTranslatedSource) return;

    final requestVersion = ++_translateRequestVersion;

    if (saveToHistory && mounted) {
      setState(() {
        _isSaving = true;
      });
    }

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/translate/text"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "firebase_uid": firebaseUid,
          "source_text": sourceText,
          "source_language": _sourceLanguage,
          "target_language": _targetLanguage,
          "expert": "Pro",
          "translation_type": "voice",
          "save_to_history": saveToHistory,
        }),
      );

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (!mounted || requestVersion != _translateRequestVersion) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final translatedText = _extractTranslatedText(data, sourceText);
        final savedId = _extractTranslationId(data);

        setState(() {
          _liveTranslatedText = translatedText;
          _lastTranslatedSource = sourceText;
          _isSaving = false;
          if (saveToHistory && savedId != null) {
            _lastSavedTranslationId = savedId;
          }
        });
      } else {
        debugPrint('VOICE TRANSLATE STATUS: ${response.statusCode}');
        debugPrint('VOICE TRANSLATE BODY: ${response.body}');
        setState(() {
          _isSaving = false;
        });
      }
    } catch (e) {
      debugPrint('VOICE TRANSLATE ERROR: $e');
      if (!mounted) return;
      setState(() {
        _isSaving = false;
      });
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
      }

      if (_isSpeaking) {
        await _flutterTts.stop();
        return;
      }

      await _flutterTts.stop();
      await _flutterTts.setLanguage(_ttsLocaleForLanguage(_targetLanguage));
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('VOICE TTS SPEAK ERROR: $e');
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
        await _translateCurrentText(saveToHistory: true);
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
        Uri.parse("$_baseUrl/translate/favorite"),
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
      final oldSource = _sourceLanguage;
      _sourceLanguage = _targetLanguage;
      _targetLanguage = oldSource;

      _liveSourceText = '';
      _liveTranslatedText = '';
      _lastTranslatedSource = '';
      _lastSavedTranslationId = null;
      _isFavorite = false;
      _isSpeaking = false;
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
            left: (-130).w,
            top: (600).h,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: 43.37 * math.pi / 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isListening)
                      CustomPaint(
                        size: Size(611.6457.w, 643.0121.h),
                        painter: VoiceWavePainter(
                          animation: _waveCtrl,
                          color: const Color(0xFF0B84FF),
                          layerCount: 6,
                        ),
                      ),
                    CustomPaint(
                      size: Size(611.6457.w, 643.0121.h),
                      painter: _OvalStrokePainter(
                        color: const Color(0xFF0B84FF),
                        strokeWidth: 2.5,
                        isListening: _isListening,
                        animation: _waveCtrl,
                      ),
                    ),
                  ],
                ),
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
                    leftFlagAsset: _flagAssetForLanguage(_sourceLanguage),
                    leftText: _sourceLanguage,
                    rightFlagAsset: _flagAssetForLanguage(_targetLanguage),
                    rightText: _targetLanguage,
                    onSwap: () => _swapLanguages(),
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
                            label: _sourceLanguage.toUpperCase(),
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
                              onCopyTap: () => _copyTranslatedText(
                                _liveTranslatedText,
                              ),
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

class VoiceWavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final int layerCount;

  VoiceWavePainter({
    required this.animation,
    required this.color,
    this.layerCount = 4,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < layerCount; i++) {
      final double progress = (animation.value + (i / layerCount)) % 1.0;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withValues(alpha: opacity * 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 + (1 - progress) * 2;
      final Path path = Path();
      final double waveCount = 7.0 + i;
      final double waveAmplitude = 15.w * (1 - progress);
      final double baseRadiusX = (size.width / 2) + (progress * 100.w);
      final double baseRadiusY = (size.height / 2) + (progress * 100.w);
      for (double angle = 0; angle <= 360; angle += 2) {
        final double radian = angle * math.pi / 180;
        final double displacement = math.sin(
              (radian * waveCount) + (animation.value * 2 * math.pi) + i,
            ) *
            waveAmplitude;
        final double x =
            center.dx + (baseRadiusX + displacement) * math.cos(radian);
        final double y =
            center.dy + (baseRadiusY + displacement) * math.sin(radian);
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) => true;
}

class _OvalStrokePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isListening;
  final Animation<double>? animation;

  _OvalStrokePainter({
    required this.color,
    required this.strokeWidth,
    this.isListening = false,
    this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
    if (!isListening || animation == null) {
      canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    } else {
      final center = Offset(size.width / 2, size.height / 2);
      final Path path = Path();
      const double waveCount = 10.0;
      final double waveAmplitude = 6.w;
      for (double angle = 0; angle <= 360; angle += 1) {
        final double radian = angle * math.pi / 180;
        final double displacement =
            math.sin((radian * waveCount) + (animation!.value * 2 * math.pi)) *
                waveAmplitude;
        final double x =
            center.dx + (size.width / 2 + displacement) * math.cos(radian);
        final double y =
            center.dy + (size.height / 2 + displacement) * math.sin(radian);
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OvalStrokePainter oldDelegate) => true;
}
