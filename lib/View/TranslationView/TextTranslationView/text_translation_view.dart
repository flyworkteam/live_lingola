import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';
import 'package:lingora_app/Core/widgets/common/app_card.dart';
import 'package:lingora_app/Core/widgets/common/dropdown_card.dart';
import 'package:lingora_app/Core/widgets/common/tap_outside_to_close.dart';
import 'package:lingora_app/Core/widgets/text_translation/example_tile.dart';
import 'package:lingora_app/Core/widgets/text_translation/lang_bar.dart';
import 'package:lingora_app/Core/widgets/text_translation/lang_row.dart';
import 'package:lingora_app/Core/widgets/text_translation/models.dart';

class TextTranslationView extends StatefulWidget {
  final VoidCallback? onBackToHome;

  const TextTranslationView({super.key, this.onBackToHome});

  @override
  State<TextTranslationView> createState() => _TextTranslationViewState();
}

class _TextTranslationViewState extends State<TextTranslationView> {
  final TextEditingController _sourceCtrl = TextEditingController(
    text: "Bugün hava çok güzel, biraz\nyürüyüş yapmak istiyorum.",
  );

  String _sourceLang = "Turkish";
  String _targetLang = "English";
  String _expert = "General";

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
  final LayerLink _expertLink = LayerLink();

  OverlayEntry? _langOverlay;
  OverlayEntry? _expertOverlay;

  @override
  void dispose() {
    _removeLangOverlay();
    _removeExpertOverlay();
    _sourceCtrl.dispose();
    super.dispose();
  }

  Future<bool> _handleBack() async {
    if (widget.onBackToHome != null) {
      widget.onBackToHome!();
      return false;
    }
    return true;
  }

  void _swapLang() {
    setState(() {
      final t = _sourceLang;
      _sourceLang = _targetLang;
      _targetLang = t;
    });
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
                              });
                              _removeLangOverlay();
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
                              setState(() => _expert = _experts[i]);
                              _removeExpertOverlay();
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h),
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
                "Save",
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Saved")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomReserve = 62.h + 20.h + 22.h;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _handleBack();
        if (shouldPop && context.mounted) Navigator.of(context).pop();
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
                      const Color(0xFFEFF2F9).withOpacity(0.72),
                      const Color(0xFFEFF2F9).withOpacity(0.0),
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
                      top: 83.h - topPad - 8.h, left: 16.w, right: 16.w),
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
                              "Text Translation",
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
                              sourceLink: LayerLink(),
                              targetLink: LayerLink(),
                              sourceFlagAsset: _langs
                                  .firstWhere((e) => e.name == _sourceLang)
                                  .flagAsset,
                              targetFlagAsset: _langs
                                  .firstWhere((e) => e.name == _targetLang)
                                  .flagAsset,
                              leftText: _sourceLang,
                              rightText: _targetLang,
                              onLeftTap: () =>
                                  _toggleLangDropdown(forSource: true),
                              onRightTap: () =>
                                  _toggleLangDropdown(forSource: false),
                              onSwap: () {
                                _removeLangOverlay();
                                _removeExpertOverlay();
                                _swapLang();
                              },
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
                                      "SOURCE LANGUAGE",
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.6,
                                        color: const Color(0xFF94A3B8),
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
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
                                            colorFilter: const ColorFilter.mode(
                                              Color(0xFF0A70FF),
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Text(
                                            "Paste",
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
                                  ],
                                ),
                                SizedBox(height: 10.h),
                                TextField(
                                  controller: _sourceCtrl,
                                  maxLines: 4,
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
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.icDocument,
                                      width: 18.sp,
                                      height: 18.sp,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFF94A3B8),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "54 / 2000",
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
                                  "TRANSLATION",
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
                                  "The weather is very nice today,\nI want to go for a walk.",
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
                                    SvgPicture.asset(
                                      AppAssets.icCopy,
                                      width: 18.sp,
                                      height: 18.sp,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFCBD5E1),
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(width: 14.w),
                                    SvgPicture.asset(
                                      AppAssets.icFav,
                                      width: 20.sp,
                                      height: 20.sp,
                                      colorFilter: const ColorFilter.mode(
                                        Color(0xFFCBD5E1),
                                        BlendMode.srcIn,
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
                                  "AI Experts",
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
                                  "EXAMPLES",
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
                                  title:
                                      "The weather is so nice today;\nI want to go for a walk.",
                                  subtitle:
                                      "Bugün hava çok güzel; yürüyüşe çıkmak istiyorum.",
                                  onMore: _showSaveMenu,
                                ),
                                SizedBox(height: 10.h),
                                TextTranslationExampleTile(
                                  title:
                                      "It’s a beautiful day; I think I’ll take a stroll.",
                                  subtitle:
                                      "Harika bir gün; sanırım kısa bir yürüyüş yapacağım.",
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
