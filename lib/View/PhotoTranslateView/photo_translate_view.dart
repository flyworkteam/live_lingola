import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Core/Utils/assets.dart';
import '../../Core/widgets/photo_translate/photo_translate_top_bar.dart';
import '../../Core/widgets/photo_translate/photo_translate_lang_bar.dart';
import '../../Core/widgets/photo_translate/photo_scan_frame.dart';

class PhotoTranslateView extends StatefulWidget {
  final VoidCallback? onBackToHome;
  const PhotoTranslateView({super.key, this.onBackToHome});

  @override
  State<PhotoTranslateView> createState() => _PhotoTranslateViewState();
}

class _PhotoTranslateViewState extends State<PhotoTranslateView> {
  final String _sourceLang = "Turkish";
  final String _targetLang = "English";

  @override
  Widget build(BuildContext context) {
    final bottomReserve = 62.h + 20.h + 18.h;

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
                    title: 'Photo Translate',
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
                  child: PhotoTranslateLangBar(
                    leftFlagAssetOrEmoji: "assets/images/flags/Turkish.png",
                    leftText: _sourceLang,
                    rightFlagAssetOrEmoji: "assets/images/flags/English.png",
                    rightText: _targetLang,
                    onSwap: () {},
                    onLeftTap: () {},
                    onRightTap: () {},
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  "Place the text you want to translate\ninside the frame.",
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
                      const PhotoScanFrame(
                        originalImage: AssetImage(
                            'assets/images/demo/photo_translate_sample.png'),
                        translatedImage: AssetImage(
                            'assets/images/demo/photo_translate_translated.png'),
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
                                    onTap: () {},
                                    size: galSize,
                                    iconSize: 19.w,
                                  ),
                                ),
                                Positioned(
                                  left: camLeft,
                                  child: _ActionButton(
                                    iconPath: AppAssets.icCamera,
                                    onTap: () {},
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
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: SvgPicture.asset(iconPath, width: iconSize, height: iconSize),
        ),
      ),
    );
  }
}
