import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_lang_bar.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_plan_card.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_top_bar.dart';
import 'package:lingora_app/View/TranslationView/VoiceTranslationView/voice_translate_free_live_view.dart';
import 'package:lingora_app/View/TranslationView/VoiceTranslationView/voice_translate_pro_live_view.dart';

class VoiceTranslateView extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const VoiceTranslateView({super.key, this.onBackToHome});

  @override
  State<VoiceTranslateView> createState() => _VoiceTranslateViewState();
}

class _VoiceTranslateViewState extends State<VoiceTranslateView> {
  final List<_LangItem> _langs = const [
    _LangItem(name: "Turkish", flagAsset: "assets/images/flags/Turkish.png"),
    _LangItem(name: "English", flagAsset: "assets/images/flags/English.png"),
    _LangItem(name: "German", flagAsset: "assets/images/flags/German.png"),
    _LangItem(name: "Italian", flagAsset: "assets/images/flags/Italian.png"),
    _LangItem(name: "French", flagAsset: "assets/images/flags/French.png"),
    _LangItem(name: "Spain", flagAsset: "assets/images/flags/Spanish.png"),
  ];

  String _sourceLang = "Turkish";
  String _targetLang = "English";
  final GlobalKey _langBarKey = GlobalKey();
  OverlayEntry? _langOverlay;
  bool? _overlayForSource;

  _LangItem _find(String name) =>
      _langs.firstWhere((e) => e.name == name, orElse: () => _langs.first);

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween =
              Tween(begin: const Offset(1, 0), end: Offset.zero).chain(
            CurveTween(curve: Curves.easeOutCubic),
          );
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
      ),
    );
  }

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
                            });
                            _closeOverlay();
                          },
                        ),
                        if (i != _langs.length - 1)
                          const Divider(
                              height: 1,
                              color: Color(0xFFE9EEF7),
                              indent: 14,
                              endIndent: 14),
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

  @override
  void dispose() {
    _closeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomReserve = 62.h + 20.h + 22.h;
    final src = _find(_sourceLang);
    final trg = _find(_targetLang);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A70FF),
                    Color(0xFF03B7FF),
                    Color(0xFFEFF2F9),
                    Color(0xFFFFFFFF)
                  ],
                  stops: [0.0, 0.35, 0.70, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: bottomReserve),
                      child: Column(
                        children: [
                          SizedBox(height: 28.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: VoiceTopBar(
                              title: "Voice Translate",
                              onBack: () => widget.onBackToHome != null
                                  ? widget.onBackToHome!()
                                  : Navigator.of(context).maybePop(),
                            ),
                          ),
                          SizedBox(height: 51.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Container(
                              key: _langBarKey,
                              child: VoiceLangBar(
                                leftFlagAsset: src.flagAsset,
                                leftText: _sourceLang,
                                rightFlagAsset: trg.flagAsset,
                                rightText: _targetLang,
                                onSwap: () {
                                  _closeOverlay();
                                  _swapLang();
                                },
                                onLeftTap: () =>
                                    _toggleDropdown(forSource: true),
                                onRightTap: () =>
                                    _toggleDropdown(forSource: false),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          SvgPicture.asset(AppAssets.icAltok,
                              width: 16.w,
                              height: 8.w,
                              colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(.92),
                                  BlendMode.srcIn)),
                          SizedBox(height: 30.h),
                          Text("Select a voice mode to begin",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 26 / 12,
                                  color: const Color(0xFF4B5563))),
                          SizedBox(height: 50.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                VoicePlanCard.free(
                                    onStart: () => _push(context,
                                        const VoiceTranslateFreeLiveView())),
                                SizedBox(width: 18.w),
                                VoicePlanCard.pro(
                                    onStart: () => _push(context,
                                        const VoiceTranslateProLiveView())),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LangItem {
  final String name;
  final String flagAsset;
  const _LangItem({required this.name, required this.flagAsset});
}

class _DropdownCard extends StatelessWidget {
  final double width;
  final Widget child;
  const _DropdownCard({required this.width, required this.child});
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
                color: Color(0x1F0B2B6B), blurRadius: 18, offset: Offset(0, 10))
          ]),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(18.r),
          child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(), child: child)),
    );
  }
}

class _LangRow extends StatelessWidget {
  final _LangItem item;
  final bool active;
  final VoidCallback onTap;
  const _LangRow(
      {required this.item, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Image.asset(item.flagAsset,
                width: 26.w, height: 18.h, fit: BoxFit.cover),
            SizedBox(width: 10.w),
            Expanded(
                child: Text(item.name,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: const Color(0xFF0F172A)))),
            if (active)
              Icon(Icons.check_rounded,
                  size: 18.sp, color: const Color(0xFF0A70FF)),
          ],
        ),
      ),
    );
  }
}

class _TapOutsideToClose extends StatelessWidget {
  final VoidCallback onClose;
  final Widget child;
  const _TapOutsideToClose({required this.onClose, required this.child});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent, onTap: onClose, child: child);
  }
}
