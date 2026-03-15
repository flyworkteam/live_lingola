import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/Core/widgets/common/app_card.dart';
import 'package:lingola_app/Core/widgets/common/dropdown_card.dart';
import 'package:lingola_app/Core/widgets/common/tap_outside_to_close.dart';
import 'package:lingola_app/Core/widgets/text_translation/example_tile.dart';
import 'package:lingola_app/Core/widgets/text_translation/lang_bar.dart';
import 'package:lingola_app/Core/widgets/text_translation/lang_row.dart';
import 'package:lingola_app/Core/widgets/text_translation/models.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class _TextExampleItem {
  final String title;
  final String subtitle;

  const _TextExampleItem({
    required this.title,
    required this.subtitle,
  });
}

class TextTranslationView extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const TextTranslationView({super.key, this.onBackToHome});

  @override
  State<TextTranslationView> createState() => _TextTranslationViewState();
}

class _TextTranslationViewState extends State<TextTranslationView> {
  static const int _charLimit = 2000;
  static const String _baseUrl = 'http://127.0.0.1:4000';

  final TextEditingController _sourceCtrl = TextEditingController(
    text: "Bugün hava çok güzel, biraz\nyürüyüş yapmak istiyorum.",
  );

  String _sourceLangCode = "tr";
  String _targetLangCode = "en";
  String _expertKey = "general";
  String _translatedText = "";

  bool _isTranslating = false;
  bool _isFavorite = false;
  bool _isSaveAnimating = false;

  int? _lastSavedTranslationId;
  bool _hasUnsavedResult = false;

  Timer? _debounce;
  Timer? _saveAnimTimer;

  List<_TextExampleItem> _examples = const [];

  String? get _firebaseUid => FirebaseAuth.instance.currentUser?.uid;

  final List<String> _experts = const [
    "general",
    "autoSelection",
    "gourmet",
    "shopping",
    "business",
    "travel",
    "dating",
    "games",
    "health",
    "law",
    "art",
    "finance",
    "technology",
    "news",
  ];

  final List<LangItem> _langs = const [
    LangItem(name: "tr", flagAsset: "assets/images/flags/Turkish.png"),
    LangItem(name: "en", flagAsset: "assets/images/flags/English.png"),
    LangItem(name: "de", flagAsset: "assets/images/flags/German.png"),
    LangItem(name: "it", flagAsset: "assets/images/flags/Italian.png"),
    LangItem(name: "fr", flagAsset: "assets/images/flags/French.png"),
    LangItem(name: "es", flagAsset: "assets/images/flags/Spanish.png"),
    LangItem(name: "ru", flagAsset: "assets/images/flags/Russian.png"),
    LangItem(name: "pt", flagAsset: "assets/images/flags/Portuguese.png"),
    LangItem(name: "ko", flagAsset: "assets/images/flags/Korean.png"),
    LangItem(name: "hi", flagAsset: "assets/images/flags/Hindi.png"),
    LangItem(name: "ja", flagAsset: "assets/images/flags/Japanese.png"),
  ];

  final LayerLink _langBarLink = LayerLink();
  final LayerLink _sourceLangLink = LayerLink();
  final LayerLink _targetLangLink = LayerLink();
  final LayerLink _expertLink = LayerLink();

  OverlayEntry? _langOverlay;
  OverlayEntry? _expertOverlay;

  @override
  void initState() {
    super.initState();
    _sourceCtrl.addListener(_handleSourceChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      _setRandomFallbackExamples();
      await _runBackendTranslate(saveToHistory: false);
      unawaited(_loadDynamicExamples());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _saveAnimTimer?.cancel();
    _removeLangOverlay();
    _removeExpertOverlay();
    _sourceCtrl.removeListener(_handleSourceChanged);
    _sourceCtrl.dispose();
    super.dispose();
  }

  void _handleSourceChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<bool> _handleBack() async {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
      return false;
    }
    return true;
  }

  int get _sourceLength => _sourceCtrl.text.length;

  String get _sourceFlagAsset =>
      _langs.firstWhere((e) => e.name == _sourceLangCode).flagAsset;

  String get _targetFlagAsset =>
      _langs.firstWhere((e) => e.name == _targetLangCode).flagAsset;

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

  String _localizedExpertName(AppLocalizations l10n, String key) {
    switch (key) {
      case 'general':
        return l10n.expertGeneral;
      case 'autoSelection':
        return l10n.expertAutoSelection;
      case 'gourmet':
        return l10n.expertGourmet;
      case 'shopping':
        return l10n.expertShopping;
      case 'business':
        return l10n.expertBusiness;
      case 'travel':
        return l10n.expertTravel;
      case 'dating':
        return l10n.expertDating;
      case 'games':
        return l10n.expertGames;
      case 'health':
        return l10n.expertHealth;
      case 'law':
        return l10n.expertLaw;
      case 'art':
        return l10n.expertArt;
      case 'finance':
        return l10n.expertFinance;
      case 'technology':
        return l10n.expertTechnology;
      case 'news':
        return l10n.expertNews;
      default:
        return key;
    }
  }

  String _backendExpertName(String key) {
    switch (key) {
      case 'general':
        return 'General';
      case 'autoSelection':
        return 'Auto-Selection';
      case 'gourmet':
        return 'Gourmet';
      case 'shopping':
        return 'Shopping';
      case 'business':
        return 'Business';
      case 'travel':
        return 'Travel';
      case 'dating':
        return 'Dating';
      case 'games':
        return 'Games';
      case 'health':
        return 'Health';
      case 'law':
        return 'Law';
      case 'art':
        return 'Art';
      case 'finance':
        return 'Finance';
      case 'technology':
        return 'Technology';
      case 'news':
        return 'News';
      default:
        return key;
    }
  }

  List<_TextExampleItem> _fallbackExamples(AppLocalizations l10n) {
    final isTurkishSource = _sourceLangCode == 'tr';

    return [
      _TextExampleItem(
        title: l10n.exampleTextTitle1,
        subtitle: l10n.exampleTextSubtitle1,
      ),
      _TextExampleItem(
        title: l10n.exampleTextTitle2,
        subtitle: l10n.exampleTextSubtitle2,
      ),
      _TextExampleItem(
        title: isTurkishSource
            ? "En yakın metro istasyonu nerede?"
            : "Where is the nearest metro station?",
        subtitle: isTurkishSource
            ? "Where is the nearest metro station?"
            : "En yakın metro istasyonu nerede?",
      ),
      _TextExampleItem(
        title: isTurkishSource
            ? "Bunu daha resmi şekilde yazar mısın?"
            : "Can you rewrite this more formally?",
        subtitle: isTurkishSource
            ? "Can you rewrite this more formally?"
            : "Bunu daha resmi şekilde yazar mısın?",
      ),
      _TextExampleItem(
        title: isTurkishSource
            ? "İki kişilik masa ayırtmak istiyorum."
            : "I would like to reserve a table for two.",
        subtitle: isTurkishSource
            ? "I would like to reserve a table for two."
            : "İki kişilik masa ayırtmak istiyorum.",
      ),
      _TextExampleItem(
        title: isTurkishSource
            ? "Bu ürünün fiyatı ne kadar?"
            : "How much does this product cost?",
        subtitle: isTurkishSource
            ? "How much does this product cost?"
            : "Bu ürünün fiyatı ne kadar?",
      ),
    ];
  }

  void _setRandomFallbackExamples() {
    final l10n = AppLocalizations.of(context)!;
    final pool = List<_TextExampleItem>.from(_fallbackExamples(l10n));
    pool.shuffle();

    setState(() {
      _examples = pool.take(2).toList();
    });
  }

  Future<void> _loadDynamicExamples() async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/chat/text-examples"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "source_language": _backendLanguageName(_sourceLangCode),
          "target_language": _backendLanguageName(_targetLangCode),
          "expert": _backendExpertName(_expertKey),
          "count": 2,
        }),
      );

      final dynamic data =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final rawList = data is Map<String, dynamic> ? data["examples"] : null;

        if (rawList is List) {
          final items = rawList
              .map((e) {
                if (e is! Map<String, dynamic>) return null;

                final title = (e["title"] ?? "").toString().trim();
                final subtitle = (e["subtitle"] ?? "").toString().trim();

                if (title.isEmpty || subtitle.isEmpty) return null;

                return _TextExampleItem(
                  title: title,
                  subtitle: subtitle,
                );
              })
              .whereType<_TextExampleItem>()
              .toList();

          if (!mounted) return;

          if (items.isNotEmpty) {
            setState(() {
              _examples = items.take(2).toList();
            });
          } else {
            _setRandomFallbackExamples();
          }
        } else {
          _setRandomFallbackExamples();
        }
      } else {
        _setRandomFallbackExamples();
      }
    } catch (e) {
      debugPrint("TEXT EXAMPLES ERROR: $e");
      if (!mounted) return;
      _setRandomFallbackExamples();
    }
  }

  Future<void> _applyExample(String text) async {
    setState(() {
      _sourceCtrl.text = text;
      _sourceCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: _sourceCtrl.text.length),
      );
      _isFavorite = false;
      _lastSavedTranslationId = null;
      _hasUnsavedResult = false;
    });

    await _runBackendTranslate(saveToHistory: false);
  }

  void _triggerSaveIconAnimation() {
    _saveAnimTimer?.cancel();

    if (!mounted) return;
    setState(() {
      _isSaveAnimating = true;
    });

    _saveAnimTimer = Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() {
        _isSaveAnimating = false;
      });
    });
  }

  void _scheduleTranslate() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 650), () {
      _runBackendTranslate(saveToHistory: false);
    });
  }

  void _swapLang() {
    _removeLangOverlay();
    _removeExpertOverlay();

    setState(() {
      final temp = _sourceLangCode;
      _sourceLangCode = _targetLangCode;
      _targetLangCode = temp;
      _isFavorite = false;
      _lastSavedTranslationId = null;
      _hasUnsavedResult = false;
    });

    _setRandomFallbackExamples();
    _runBackendTranslate(saveToHistory: false);
    unawaited(_loadDynamicExamples());
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    final text = data?.text?.trim();

    if (text == null || text.isEmpty) return;

    final trimmed =
        text.length > _charLimit ? text.substring(0, _charLimit) : text;

    setState(() {
      _sourceCtrl.text = trimmed;
      _sourceCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: _sourceCtrl.text.length),
      );
      _isFavorite = false;
      _lastSavedTranslationId = null;
      _hasUnsavedResult = false;
    });

    await _runBackendTranslate(saveToHistory: false);
  }

  Future<void> _copyTranslatedText() async {
    final l10n = AppLocalizations.of(context)!;

    if (_translatedText.trim().isEmpty) return;

    await Clipboard.setData(ClipboardData(text: _translatedText));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.translationCopied)),
    );
  }

  Future<void> _runBackendTranslate({required bool saveToHistory}) async {
    final l10n = AppLocalizations.of(context)!;
    final source = _sourceCtrl.text.trim();

    if ((_firebaseUid ?? "").isEmpty) {
      if (!mounted) return;
      setState(() {
        _isTranslating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noLoggedInUser)),
      );
      return;
    }

    if (source.isEmpty) {
      setState(() {
        _translatedText = "";
        _isTranslating = false;
        _hasUnsavedResult = false;
        _lastSavedTranslationId = null;
        _isFavorite = false;
      });
      return;
    }

    setState(() {
      _isTranslating = true;
    });

    try {
      debugPrint("TEXT TRANSLATE UID: $_firebaseUid");
      debugPrint("TEXT TRANSLATE URL: $_baseUrl/translate/text");

      final response = await http.post(
        Uri.parse("$_baseUrl/translate/text"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "firebase_uid": _firebaseUid,
          "source_text": source,
          "source_language": _backendLanguageName(_sourceLangCode),
          "target_language": _backendLanguageName(_targetLangCode),
          "expert": _backendExpertName(_expertKey),
          "translation_type": "text",
          "save_to_history": saveToHistory,
        }),
      );

      final dynamic data =
          response.body.isNotEmpty ? jsonDecode(response.body) : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final translated = _extractTranslatedText(data, source);
        final savedId = _extractTranslationId(data);

        if (!mounted) return;

        setState(() {
          _translatedText = translated;
          _isTranslating = false;
          _hasUnsavedResult = !saveToHistory;
          if (saveToHistory && savedId != null) {
            _lastSavedTranslationId = savedId;
          }
          if (saveToHistory) {
            _hasUnsavedResult = false;
          }
        });
      } else {
        _applyBackendFailure(source);
      }
    } catch (e) {
      debugPrint("TEXT TRANSLATE ERROR: $e");
      _applyBackendFailure(source);
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
      }
    }

    return sourceFallback;
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

  void _applyBackendFailure(String source) {
    if (!mounted) return;

    setState(() {
      _translatedText = source;
      _isTranslating = false;
      _hasUnsavedResult = true;
    });
  }

  Future<void> _saveCurrentTranslation() async {
    final l10n = AppLocalizations.of(context)!;

    await _runBackendTranslate(saveToHistory: true);
    _triggerSaveIconAnimation();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.savedToHistory)),
    );
  }

  Future<void> _toggleFavorite() async {
    final l10n = AppLocalizations.of(context)!;

    if (_translatedText.trim().isEmpty) return;

    if (_lastSavedTranslationId == null || _hasUnsavedResult) {
      await _runBackendTranslate(saveToHistory: true);
    }

    if (_lastSavedTranslationId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.couldNotSaveTranslationFirst)),
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        setState(() {
          _isFavorite = !_isFavorite;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite ? l10n.addedToFavorites : l10n.removedFromFavorites,
            ),
          ),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.favoriteRouteNotReady)),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.favoriteRouteNotReady)),
      );
    }
  }

  void _removeLangOverlay() {
    _langOverlay?.remove();
    _langOverlay = null;
  }

  void _removeExpertOverlay() {
    _expertOverlay?.remove();
    _expertOverlay = null;
  }

  void _toggleLangDropdown({required bool forSource}) {
    final l10n = AppLocalizations.of(context)!;

    _removeExpertOverlay();

    if (_langOverlay != null) {
      _removeLangOverlay();
      return;
    }

    _langOverlay = OverlayEntry(
      builder: (_) {
        return TapOutsideToClose(
          onClose: _removeLangOverlay,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.transparent)),
              CompositedTransformFollower(
                link: _langBarLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomCenter,
                followerAnchor: Alignment.topCenter,
                offset: Offset(0, 10.h),
                child: Material(
                  color: Colors.transparent,
                  child: DropdownCard(
                    width: 358.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < _langs.length; i++) ...[
                          TextTranslationLangRow(
                            item: LangItem(
                              name:
                                  _localizedLanguageName(l10n, _langs[i].name),
                              flagAsset: _langs[i].flagAsset,
                            ),
                            active: forSource
                                ? _langs[i].name == _sourceLangCode
                                : _langs[i].name == _targetLangCode,
                            onTap: () {
                              setState(() {
                                if (forSource) {
                                  _sourceLangCode = _langs[i].name;
                                } else {
                                  _targetLangCode = _langs[i].name;
                                }
                                _isFavorite = false;
                                _lastSavedTranslationId = null;
                                _hasUnsavedResult = false;
                              });
                              _removeLangOverlay();
                              _setRandomFallbackExamples();
                              _runBackendTranslate(saveToHistory: false);
                              unawaited(_loadDynamicExamples());
                            },
                          ),
                          if (i != _langs.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: const Color(0xFFE9EEF7),
                              indent: 18.w,
                              endIndent: 18.w,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_langOverlay!);
  }

  void _toggleExpertDropdown() {
    final l10n = AppLocalizations.of(context)!;

    _removeLangOverlay();

    if (_expertOverlay != null) {
      _removeExpertOverlay();
      return;
    }

    _expertOverlay = OverlayEntry(
      builder: (_) {
        return TapOutsideToClose(
          onClose: _removeExpertOverlay,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.transparent)),
              CompositedTransformFollower(
                link: _expertLink,
                showWhenUnlinked: false,
                targetAnchor: Alignment.bottomRight,
                followerAnchor: Alignment.topRight,
                offset: Offset(0, 10.h),
                child: Material(
                  color: Colors.transparent,
                  child: DropdownCard(
                    width: 180.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < _experts.length; i++) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                _expertKey = _experts[i];
                                _isFavorite = false;
                                _lastSavedTranslationId = null;
                                _hasUnsavedResult = false;
                              });
                              _removeExpertOverlay();
                              _setRandomFallbackExamples();
                              _runBackendTranslate(saveToHistory: false);
                              unawaited(_loadDynamicExamples());
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              child: Text(
                                _localizedExpertName(l10n, _experts[i]),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 26 / 12,
                                  color: _experts[i] == _expertKey
                                      ? const Color(0xFF0A70FF)
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                            ),
                          ),
                          if (i != _experts.length - 1)
                            Divider(
                              height: 1,
                              thickness: 1,
                              color: const Color(0xFFE9EEF7),
                              indent: 14.w,
                              endIndent: 14.w,
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_expertOverlay!);
  }

  void _showSaveMenu(Offset globalPos) async {
    final l10n = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      context: context,
      color: Colors.white,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      position: RelativeRect.fromRect(
        Rect.fromLTWH(globalPos.dx, globalPos.dy, 1, 1),
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem<String>(
          value: "save",
          height: 42.h,
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F0FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.bookmark_border_rounded,
                  size: 18.sp,
                  color: const Color(0xFF0A70FF),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                l10n.save,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0A70FF),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (result == "save") {
      await _saveCurrentTranslation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final topPad = MediaQuery.of(context).padding.top;
    final bottomReserve = 62.h + 20.h + 22.h;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _handleBack();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
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
            Column(
              children: [
                SizedBox(height: topPad + 8.h),
                Padding(
                  padding: EdgeInsets.only(
                    top: 83.h - topPad - 8.h,
                    left: 16.w,
                    right: 16.w,
                  ),
                  child: SizedBox(
                    height: 26.h,
                    child: Row(
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () {
                            if (widget.onBackToHome != null) {
                              widget.onBackToHome!();
                            }
                          },
                          child: Container(
                            width: 24.w,
                            height: 24.w,
                            color: Colors.transparent,
                            child: Center(
                              child: SvgPicture.asset(
                                AppAssets.icBack,
                                width: 24.w,
                                height: 24.w,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              l10n.textTranslationTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w500,
                                height: 26 / 20,
                                letterSpacing: 0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 24.w),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 51.h),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(16.w, 0, 16.w, bottomReserve),
                      child: Column(
                        children: [
                          CompositedTransformTarget(
                            link: _langBarLink,
                            child: TextTranslationLangBar(
                              sourceLink: _sourceLangLink,
                              targetLink: _targetLangLink,
                              sourceFlagAsset: _sourceFlagAsset,
                              targetFlagAsset: _targetFlagAsset,
                              leftText:
                                  _localizedLanguageName(l10n, _sourceLangCode),
                              rightText:
                                  _localizedLanguageName(l10n, _targetLangCode),
                              onLeftTap: () =>
                                  _toggleLangDropdown(forSource: true),
                              onRightTap: () =>
                                  _toggleLangDropdown(forSource: false),
                              onSwap: _swapLang,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      l10n.sourceLanguageLabel,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.circular(999.r),
                                      onTap: _pasteFromClipboard,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 6.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE7F0FF),
                                          borderRadius:
                                              BorderRadius.circular(999.r),
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              AppAssets.icPaste,
                                              width: 14.sp,
                                              height: 14.sp,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Color(0xFF0A70FF),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              l10n.paste,
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
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                TextField(
                                  controller: _sourceCtrl,
                                  maxLines: 4,
                                  maxLength: _charLimit,
                                  onChanged: (_) => _scheduleTranslate(),
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 22 / 16,
                                    letterSpacing: 0,
                                    color: const Color(0xFF0F172A),
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    counterText: '',
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.circular(999.r),
                                      onTap: _saveCurrentTranslation,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 220),
                                        curve: Curves.easeOut,
                                        child: SvgPicture.asset(
                                          AppAssets.icDocument,
                                          width: 18.sp,
                                          height: 18.sp,
                                          colorFilter: ColorFilter.mode(
                                            _isSaveAnimating
                                                ? const Color(0xFF0A70FF)
                                                : const Color(0xFF94A3B8),
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '$_sourceLength / $_charLimit',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.translationLabel,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                    color: const Color(0xFF0A70FF),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  _isTranslating
                                      ? l10n.translating
                                      : _translatedText,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 22 / 16,
                                    letterSpacing: 0,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Row(
                                  children: [
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.circular(999.r),
                                      onTap: _copyTranslatedText,
                                      child: SvgPicture.asset(
                                        AppAssets.icCopy,
                                        width: 18.sp,
                                        height: 18.sp,
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFCBD5E1),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    InkWell(
                                      borderRadius:
                                          BorderRadius.circular(999.r),
                                      onTap: _toggleFavorite,
                                      child: SvgPicture.asset(
                                        AppAssets.icFav,
                                        width: 20.sp,
                                        height: 20.sp,
                                        colorFilter: ColorFilter.mode(
                                          _isFavorite
                                              ? const Color(0xFF0A70FF)
                                              : const Color(0xFFCBD5E1),
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          AppCard(
                            child: Row(
                              children: [
                                Text(
                                  l10n.aiExpertsTitle,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    height: 26 / 13,
                                    letterSpacing: 0,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                const Spacer(),
                                CompositedTransformTarget(
                                  link: _expertLink,
                                  child: InkWell(
                                    onTap: _toggleExpertDropdown,
                                    borderRadius: BorderRadius.circular(10.r),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 6.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            _localizedExpertName(
                                              l10n,
                                              _expertKey,
                                            ),
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0A70FF),
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            size: 20.sp,
                                            color: const Color(0xFF0A70FF),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.examplesLabel,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.6,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                for (int i = 0; i < _examples.length; i++) ...[
                                  GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () =>
                                        _applyExample(_examples[i].title),
                                    child: TextTranslationExampleTile(
                                      title: _examples[i].title,
                                      subtitle: _examples[i].subtitle,
                                      onMore: _showSaveMenu,
                                    ),
                                  ),
                                  if (i != _examples.length - 1)
                                    Divider(
                                      height: 18.h,
                                      thickness: 1,
                                      color: const Color(0xFFD9E1EF),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
