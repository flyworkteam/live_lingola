import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Core/widgets/photo_translate/photo_translate_top_bar.dart';
import '../../Core/widgets/photo_translate/photo_translate_lang_bar.dart';
import '../../Core/widgets/photo_translate/photo_scan_frame.dart';
import '../../Core/widgets/photo_translate/photo_scan_actions.dart';

class PhotoTranslateView extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const PhotoTranslateView({super.key, this.onBackToHome});

  @override
  State<PhotoTranslateView> createState() => _PhotoTranslateViewState();
}

class _PhotoTranslateViewState extends State<PhotoTranslateView> {
  // Dil verileri
  final List<_LangItem> _langs = const [
    _LangItem(name: "Turkish", flagAsset: "assets/images/flags/Turkish.png"),
    _LangItem(name: "English", flagAsset: "assets/images/flags/English.png"),
    _LangItem(name: "German", flagAsset: "assets/images/flags/German.png"),
    _LangItem(name: "Italian", flagAsset: "assets/images/flags/Italian.png"),
    _LangItem(name: "French", flagAsset: "assets/images/flags/French.png"),
    _LangItem(name: "Spanish", flagAsset: "assets/images/flags/Spanish.png"),
  ];

  String _sourceLang = "Turkish";
  String _targetLang = "English";

  // Overlay işlemleri için
  final GlobalKey _langBarKey = GlobalKey();
  OverlayEntry? _langOverlay;
  bool? _overlayForSource;

  _LangItem _find(String name) =>
      _langs.firstWhere((e) => e.name == name, orElse: () => _langs.first);

  void _swapLang() {
    setState(() {
      final t = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = t;
    });
  }

  void _closeOverlay() {
    _langOverlay?.remove();
    _langOverlay = null;
    _overlayForSource = null;
  }

  void _toggleDropdown({required bool forSource}) {
    if (_langOverlay != null && _overlayForSource == forSource) {
      _closeOverlay();
      return;
    }
    if (_langOverlay != null && _overlayForSource != forSource) {
      _closeOverlay();
    }

    final barCtx = _langBarKey.currentContext;
    if (barCtx == null) return;

    final RenderBox barBox = barCtx.findRenderObject() as RenderBox;
    final barPos = barBox.localToGlobal(Offset.zero);
    final barSize = barBox.size;

    final screenW = MediaQuery.of(context).size.width;
    final margin = 16.w;
    final ddW = screenW - (margin * 2);
    final ddTop = barPos.dy + barSize.height + 8.h;

    _overlayForSource = forSource;

    _langOverlay = OverlayEntry(
      builder: (_) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _closeOverlay,
          child: Stack(
            children: [
              Positioned(
                left: margin,
                top: ddTop,
                width: ddW,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: 280.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.r),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _langs.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, color: Color(0xFFE9EEF7)),
                        itemBuilder: (context, i) {
                          final item = _langs[i];
                          final isActive = forSource
                              ? item.name == _sourceLang
                              : item.name == _targetLang;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                if (forSource) {
                                  _sourceLang = item.name;
                                } else {
                                  _targetLang = item.name;
                                }
                              });
                              _closeOverlay();
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h),
                              child: Row(
                                children: [
                                  Image.asset(item.flagAsset,
                                      width: 22.w, height: 22.w),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13.sp,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                  ),
                                  if (isActive)
                                    Icon(Icons.check_rounded,
                                        size: 18.sp,
                                        color: const Color(0xFF0A70FF)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
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

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomReserve = 62.h + 20.h + 18.h;
    final src = _find(_sourceLang);
    final trg = _find(_targetLang);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomReserve),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 6.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: PhotoTranslateTopBar(
                          title: 'Photo Translate',
                          onBack: () {
                            if (widget.onBackToHome != null) {
                              widget.onBackToHome!();
                            } else {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Padding(
                        key: _langBarKey,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: PhotoTranslateLangBar(
                          leftFlagAssetOrEmoji: src.flagAsset,
                          leftText: _sourceLang,
                          rightFlagAssetOrEmoji: trg.flagAsset,
                          rightText: _targetLang,
                          onSwap: () {
                            _closeOverlay();
                            _swapLang();
                          },
                          onLeftTap: () => _toggleDropdown(forSource: true),
                          onRightTap: () => _toggleDropdown(forSource: false),
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Text(
                        "Place the text you want to translate\ninside the frame.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
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
                              imageProvider: const AssetImage(
                                'assets/images/demo/photo_translate_sample.png',
                              ),
                              translatedOverlayBuilder: (context) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.all(18.w),
                                    child: Text(
                                      "Kapitol\nBanka\nHavalimanı",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        shadows: const [
                                          Shadow(
                                            blurRadius: 10,
                                            color: Colors.black54,
                                            offset: Offset(0, 4),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 18.h),
                            PhotoScanActions(
                              onGalleryTap: () {},
                              onCameraTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LangItem {
  final String name;
  final String flagAsset;
  const _LangItem({required this.name, required this.flagAsset});
}
