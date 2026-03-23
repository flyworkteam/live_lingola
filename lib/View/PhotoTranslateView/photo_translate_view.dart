import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

import '../../Core/Utils/assets.dart';
import '../../Core/config/app_config.dart';
import '../../Core/widgets/photo_translate/photo_scan_frame.dart';
import '../../Core/widgets/photo_translate/photo_translate_lang_bar.dart';
import '../../Core/widgets/photo_translate/photo_translate_top_bar.dart';
import '../../Riverpod/Providers/current_user_provider.dart';

class PhotoTranslateView extends ConsumerStatefulWidget {
  final VoidCallback? onBackToHome;

  const PhotoTranslateView({super.key, this.onBackToHome});

  @override
  ConsumerState<PhotoTranslateView> createState() => _PhotoTranslateViewState();
}

class _PhotoTranslateViewState extends ConsumerState<PhotoTranslateView> {
  final List<_LangItem> _langs = const [
    _LangItem(code: "tr", flagAsset: "assets/images/flags/Turkish.png"),
    _LangItem(code: "en", flagAsset: "assets/images/flags/English.png"),
    _LangItem(code: "de", flagAsset: "assets/images/flags/German.png"),
    _LangItem(code: "it", flagAsset: "assets/images/flags/Italian.png"),
    _LangItem(code: "fr", flagAsset: "assets/images/flags/French.png"),
    _LangItem(code: "ja", flagAsset: "assets/images/flags/Japanese.png"),
    _LangItem(code: "es", flagAsset: "assets/images/flags/Spanish.png"),
    _LangItem(code: "ru", flagAsset: "assets/images/flags/Russian.png"),
    _LangItem(code: "ko", flagAsset: "assets/images/flags/Korean.png"),
    _LangItem(code: "hi", flagAsset: "assets/images/flags/Hindi.png"),
    _LangItem(code: "pt", flagAsset: "assets/images/flags/Portuguese.png"),
  ];

  String _sourceLangCode = "tr";
  String _targetLangCode = "en";

  final GlobalKey _langBarKey = GlobalKey();
  OverlayEntry? _langOverlay;
  bool? _overlayForSource;

  final ImagePicker _picker = ImagePicker();

  File? _selectedImageFile;
  bool _isPickingImage = false;
  bool _isProcessing = false;

  List<PhotoTranslatedBlock> _translatedBlocks = [];
  ImageProvider? _originalImageProvider;
  ImageProvider? _translatedImageProvider;

  _LangItem _find(String code) =>
      _langs.firstWhere((e) => e.code == code, orElse: () => _langs.first);

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
      case 'ja':
        return l10n.languageJapanese;
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
      case 'ja':
        return 'Japanese';
      default:
        return code;
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

  void _swapLanguages() {
    setState(() {
      final temp = _sourceLangCode;
      _sourceLangCode = _targetLangCode;
      _targetLangCode = temp;
    });

    if (_selectedImageFile != null && !_isProcessing) {
      _handlePickedFile(_selectedImageFile!);
    }
  }

  void _closeOverlay() {
    _langOverlay?.remove();
    _langOverlay = null;
    _overlayForSource = null;
  }

  void _toggleDropdown({required bool forSource}) {
    final l10n = AppLocalizations.of(context)!;

    if (_langOverlay != null && _overlayForSource == forSource) {
      _closeOverlay();
      return;
    }

    final barCtx = _langBarKey.currentContext;
    if (barCtx == null) return;

    final RenderBox barBox = barCtx.findRenderObject() as RenderBox;
    final barPos = barBox.localToGlobal(Offset.zero);
    final barSize = barBox.size;

    _overlayForSource = forSource;
    _langOverlay = OverlayEntry(
      builder: (_) => _TapOutsideToClose(
        onClose: _closeOverlay,
        child: Stack(
          children: [
            Positioned.fill(child: Container(color: Colors.transparent)),
            Positioned(
              left: barPos.dx,
              top: barPos.dy + barSize.height + 10.h,
              width: barSize.width,
              child: Material(
                color: Colors.transparent,
                child: _DropdownCard(
                  width: barSize.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < _langs.length; i++) ...[
                        _LangRow(
                          item: _langs[i],
                          title: _localizedLanguageName(l10n, _langs[i].code),
                          active: forSource
                              ? _langs[i].code == _sourceLangCode
                              : _langs[i].code == _targetLangCode,
                          onTap: () {
                            setState(() {
                              if (forSource) {
                                _sourceLangCode = _langs[i].code;
                                if (_sourceLangCode == _targetLangCode) {
                                  _targetLangCode = _langs
                                      .firstWhere(
                                        (e) => e.code != _sourceLangCode,
                                        orElse: () => _langs.first,
                                      )
                                      .code;
                                }
                              } else {
                                _targetLangCode = _langs[i].code;
                                if (_sourceLangCode == _targetLangCode) {
                                  _sourceLangCode = _langs
                                      .firstWhere(
                                        (e) => e.code != _targetLangCode,
                                        orElse: () => _langs.first,
                                      )
                                      .code;
                                }
                              }
                            });

                            _closeOverlay();

                            if (_selectedImageFile != null && !_isProcessing) {
                              _handlePickedFile(_selectedImageFile!);
                            }
                          },
                        ),
                        if (i != _langs.length - 1)
                          const Divider(
                            height: 1,
                            color: Color(0xFFE9EEF7),
                            indent: 14,
                            endIndent: 14,
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_langOverlay!);
  }

  Future<void> _pickFromGallery() async {
    final l10n = AppLocalizations.of(context)!;

    if (_isPickingImage || _isProcessing) return;
    _isPickingImage = true;

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      if (file == null) return;

      await _handlePickedFile(File(file.path));
    } on PlatformException catch (e) {
      if (e.code != 'multiple_request') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.galleryAccessFailed(e.message ?? e.code),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.galleryAccessFailed('$e'))),
      );
    } finally {
      _isPickingImage = false;
    }
  }

  Future<void> _pickFromCamera() async {
    final l10n = AppLocalizations.of(context)!;

    if (_isPickingImage || _isProcessing) return;
    _isPickingImage = true;

    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (file == null) return;

      await _handlePickedFile(File(file.path));
    } on PlatformException catch (e) {
      if (e.code != 'multiple_request') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.cameraAccessFailed(e.message ?? e.code),
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.cameraAccessFailed('$e'))),
      );
    } finally {
      _isPickingImage = false;
    }
  }

  ImageProvider? _buildImageProviderFromBase64(String? rawValue) {
    final value = (rawValue ?? '').trim();
    if (value.isEmpty) return null;

    try {
      final normalized = value.contains(',') ? value.split(',').last : value;
      final bytes = base64Decode(normalized);
      return MemoryImage(bytes);
    } catch (e) {
      debugPrint("IMAGE BASE64 PARSE ERROR: $e");
      return null;
    }
  }

  ImageProvider? _buildTranslatedImageProvider(dynamic data) {
    if (data is! Map<String, dynamic>) return null;

    final base64String =
        (data['translated_image_base64'] ?? '').toString().trim();
    if (base64String.isNotEmpty) {
      try {
        final normalized = base64String.contains(',')
            ? base64String.split(',').last
            : base64String;
        final bytes = base64Decode(normalized);
        return MemoryImage(bytes);
      } catch (e) {
        debugPrint("PHOTO TRANSLATE BASE64 PARSE ERROR: $e");
      }
    }

    final imageUrl = (data['translated_image_url'] ?? '').toString().trim();
    if (imageUrl.isNotEmpty) {
      return NetworkImage(imageUrl);
    }

    if (data['data'] is Map<String, dynamic>) {
      return _buildTranslatedImageProvider(data['data']);
    }

    return null;
  }

  Future<void> _handlePickedFile(File file) async {
    final l10n = AppLocalizations.of(context)!;
    final firebaseUid = _currentFirebaseUid();
    final userId = _currentUserId();

    if (!mounted) return;

    setState(() {
      _selectedImageFile = file;
      _isProcessing = true;
      _translatedBlocks = [];
      _originalImageProvider = FileImage(file);
      _translatedImageProvider = null;
    });

    if (firebaseUid == null && userId == null) {
      debugPrint("USER DATA NOT READY");

      setState(() {
        _isProcessing = false;
      });

      return;
    }

    debugPrint('PHOTO TRANSLATE FIREBASE UID: $firebaseUid');
    debugPrint('PHOTO TRANSLATE USER ID: $userId');
    debugPrint('PHOTO TRANSLATE SOURCE: $_sourceLangCode');
    debugPrint('PHOTO TRANSLATE TARGET: $_targetLangCode');

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConfig.baseUrl}/translate/photo"),
      );

      if (firebaseUid != null) {
        request.fields['firebase_uid'] = firebaseUid;
      }
      if (userId != null) {
        request.fields['user_id'] = userId.toString();
      }

      request.fields['source_language'] = _backendLanguageName(_sourceLangCode);
      request.fields['target_language'] = _backendLanguageName(_targetLangCode);
      request.fields['provider'] = 'gemini';
      request.fields['render_translated_image'] = 'true';

      request.files.add(
        await http.MultipartFile.fromPath('image', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("PHOTO TRANSLATE STATUS: ${response.statusCode}");
      debugPrint("PHOTO TRANSLATE BODY: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(response.body);

        final List<dynamic> blocksJson = (data is Map<String, dynamic> &&
                data['blocks'] is List)
            ? data['blocks'] as List<dynamic>
            : (data is Map<String, dynamic> &&
                    data['data'] is Map<String, dynamic> &&
                    (data['data'] as Map<String, dynamic>)['blocks'] is List)
                ? ((data['data'] as Map<String, dynamic>)['blocks']
                    as List<dynamic>)
                : [];

        final translatedImageProvider = _buildTranslatedImageProvider(data);

        ImageProvider? originalImageProvider;
        if (data is Map<String, dynamic>) {
          originalImageProvider = _buildImageProviderFromBase64(
            data['original_image_base64']?.toString(),
          );

          originalImageProvider ??= _buildImageProviderFromBase64(
            data['data'] is Map<String, dynamic>
                ? (data['data']
                        as Map<String, dynamic>)['original_image_base64']
                    ?.toString()
                : null,
          );
        }

        if (!mounted) return;
        setState(() {
          _translatedBlocks = blocksJson
              .map(
                (e) => PhotoTranslatedBlock.fromJson(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList();

          _originalImageProvider = originalImageProvider ?? FileImage(file);
          _translatedImageProvider = translatedImageProvider;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.photoTranslationFailed)),
        );
      }
    } catch (e) {
      debugPrint("PHOTO TRANSLATE ERROR: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.photoTranslationFailedWithError('$e'))),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomReserve = 62.h + 20.h + 18.h;
    final src = _find(_sourceLangCode);
    final trg = _find(_targetLangCode);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomReserve),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: PhotoTranslateTopBar(
                    title: l10n.photoTranslateTitle,
                    onBack: () {
                      if (widget.onBackToHome != null) {
                        widget.onBackToHome!.call();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                SizedBox(height: 51.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Container(
                    key: _langBarKey,
                    child: PhotoTranslateLangBar(
                      leftFlagAssetOrEmoji: src.flagAsset,
                      leftText: _localizedLanguageName(l10n, _sourceLangCode),
                      rightFlagAssetOrEmoji: trg.flagAsset,
                      rightText: _localizedLanguageName(l10n, _targetLangCode),
                      onSwap: () {
                        _closeOverlay();
                        _swapLanguages();
                      },
                      onLeftTap: () => _toggleDropdown(forSource: true),
                      onRightTap: () => _toggleDropdown(forSource: false),
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  l10n.photoTranslateInstruction,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11.sp,
                    color: const Color(0xFF94A3B8),
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 18.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      PhotoScanFrame(
                        originalImage: _originalImageProvider,
                        translatedImage: _translatedImageProvider,
                        translatedBlocks: _translatedBlocks,
                        isProcessing: _isProcessing,
                      ),
                      SizedBox(height: 30.h),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final double camSize = 70.w;
                          final double galSize = 37.w;
                          final double spacing = 15.w;
                          final double camLeft =
                              (constraints.maxWidth - camSize) / 2;
                          final double galLeft = camLeft - galSize - spacing;

                          return SizedBox(
                            height: camSize,
                            child: Stack(
                              children: [
                                Positioned(
                                  left: galLeft,
                                  top: (camSize - galSize) / 2,
                                  child: _ActionButton(
                                    iconPath: AppAssets.icGallery,
                                    onTap: _pickFromGallery,
                                    size: galSize,
                                    iconSize: 19.w,
                                  ),
                                ),
                                Positioned(
                                  left: camLeft,
                                  child: _ActionButton(
                                    iconPath: AppAssets.icCamera,
                                    onTap: _pickFromCamera,
                                    size: camSize,
                                    iconSize: 42.w,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LangItem {
  final String code;
  final String flagAsset;

  const _LangItem({
    required this.code,
    required this.flagAsset,
  });
}

class _DropdownCard extends StatelessWidget {
  final double width;
  final Widget child;

  const _DropdownCard({
    required this.width,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(maxHeight: 310.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0B2B6B),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: child,
        ),
      ),
    );
  }
}

class _LangRow extends StatelessWidget {
  final _LangItem item;
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _LangRow({
    required this.item,
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Image.asset(
              item.flagAsset,
              width: 26.w,
              height: 18.h,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            if (active)
              Icon(
                Icons.check_rounded,
                size: 18.sp,
                color: const Color(0xFF0A70FF),
              ),
          ],
        ),
      ),
    );
  }
}

class _TapOutsideToClose extends StatelessWidget {
  final VoidCallback onClose;
  final Widget child;

  const _TapOutsideToClose({
    required this.onClose,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onClose,
      child: child,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String iconPath;
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _ActionButton({
    required this.iconPath,
    required this.onTap,
    required this.size,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(iconPath, width: iconSize, height: iconSize),
        ),
      ),
    );
  }
}
