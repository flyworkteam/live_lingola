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

class TextTranslationView extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const TextTranslationView({super.key, this.onBackToHome});

  @override
  State<TextTranslationView> createState() => _TextTranslationViewState();
}

class _TextTranslationViewState extends State<TextTranslationView> {
  static const int _charLimit = 2000;
static const String _baseUrl = "https://livelingolaapp.fly-work.com";

  final TextEditingController _sourceCtrl = TextEditingController(
    text: "Bugün hava çok güzel, biraz\nyürüyüş yapmak istiyorum.",
  );

  String _sourceLang = "Turkish";
  String _targetLang = "English";
  String _expert = "General";
  String _translatedText = "";

  bool _isTranslating = false;
  bool _isFavorite = false;
  bool _isSaveAnimating = false;

  int? _lastSavedTranslationId;
  bool _hasUnsavedResult = false;

  Timer? _debounce;
  Timer? _saveAnimTimer;

  String? get _firebaseUid => FirebaseAuth.instance.currentUser?.uid;

  final List<String> _experts = const [
    "General",
    "Auto-Selection",
    "Gourmet",
    "Shopping",
    "Business",
    "Travel",
    "Dating",
    "Games",
    "Health",
    "Law",
    "Art",
    "Finance",
    "Technology",
    "News",
  ];

  final List<LangItem> _langs = const [
    LangItem(name: "Turkish", flagAsset: "assets/images/flags/Turkish.png"),
    LangItem(name: "English", flagAsset: "assets/images/flags/English.png"),
    LangItem(name: "German", flagAsset: "assets/images/flags/German.png"),
    LangItem(name: "Italian", flagAsset: "assets/images/flags/Italian.png"),
    LangItem(name: "French", flagAsset: "assets/images/flags/French.png"),
    LangItem(name: "Spanish", flagAsset: "assets/images/flags/Spanish.png"),
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _runBackendTranslate(saveToHistory: false);
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
      _langs.firstWhere((e) => e.name == _sourceLang).flagAsset;

  String get _targetFlagAsset =>
      _langs.firstWhere((e) => e.name == _targetLang).flagAsset;

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
      final t = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = t;
      _isFavorite = false;
      _lastSavedTranslationId = null;
      _hasUnsavedResult = false;
    });

    _runBackendTranslate(saveToHistory: false);
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
          "source_language": _sourceLang,
          "target_language": _targetLang,
          "expert": _expert,
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
                            item: _langs[i],
                            active: forSource
                                ? _langs[i].name == _sourceLang
                                : _langs[i].name == _targetLang,
                            onTap: () {
                              setState(() {
                                if (forSource) {
                                  _sourceLang = _langs[i].name;
                                } else {
                                  _targetLang = _langs[i].name;
                                }
                                _isFavorite = false;
                                _lastSavedTranslationId = null;
                                _hasUnsavedResult = false;
                              });
                              _removeLangOverlay();
                              _runBackendTranslate(saveToHistory: false);
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
                    width: 160.w,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (int i = 0; i < _experts.length; i++) ...[
                          InkWell(
                            onTap: () {
                              setState(() {
                                _expert = _experts[i];
                                _isFavorite = false;
                                _lastSavedTranslationId = null;
                                _hasUnsavedResult = false;
                              });
                              _removeExpertOverlay();
                              _runBackendTranslate(saveToHistory: false);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              child: Text(
                                _experts[i],
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 26 / 12,
                                  color: _experts[i] == _expert
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
                              leftText: _sourceLang,
                              rightText: _targetLang,
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
                                            _expert,
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
                                TextTranslationExampleTile(
                                  title: l10n.exampleTextTitle1,
                                  subtitle: l10n.exampleTextSubtitle1,
                                  onMore: _showSaveMenu,
                                ),
                                SizedBox(height: 10.h),
                                TextTranslationExampleTile(
                                  title: l10n.exampleTextTitle2,
                                  subtitle: l10n.exampleTextSubtitle2,
                                  onMore: _showSaveMenu,
                                ),
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
