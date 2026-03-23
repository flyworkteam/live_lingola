import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Utils/assets.dart';
import '../../../Riverpod/Providers/language_provider.dart';

class PhotoTranslateLangBar extends ConsumerWidget {
  final String leftFlagAssetOrEmoji;
  final String leftText;
  final String rightFlagAssetOrEmoji;
  final String rightText;
  final VoidCallback onSwap;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap;

  const PhotoTranslateLangBar({
    super.key,
    required this.leftFlagAssetOrEmoji,
    required this.leftText,
    required this.rightFlagAssetOrEmoji,
    required this.rightText,
    required this.onSwap,
    this.onLeftTap,
    this.onRightTap,
  });

  String _mapLanguageCodeToText(String code) {
    switch (code.toLowerCase()) {
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
        return code.toUpperCase();
    }
  }

  String _mapLanguageCodeToFlag(String code) {
    switch (code.toLowerCase()) {
      case 'tr':
        return 'assets/images/flags/Turkish.png';
      case 'en':
        return 'assets/images/flags/English.png';
      case 'de':
        return 'assets/images/flags/German.png';
      case 'it':
        return 'assets/images/flags/Italian.png';
      case 'fr':
        return 'assets/images/flags/French.png';
      case 'ja':
        return 'assets/images/flags/Japanese.png';
      case 'es':
        return 'assets/images/flags/Spanish.png';
      case 'ru':
        return 'assets/images/flags/Russian.png';
      case 'pt':
        return 'assets/images/flags/Portuguese.png';
      case 'ko':
        return 'assets/images/flags/Korean.png';
      case 'hi':
        return 'assets/images/flags/Hindi.png';
      default:
        return leftFlagAssetOrEmoji;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sourceLangCode = ref.watch(translationSourceLanguageProvider);

    final displayLeftText = (sourceLangCode.trim().isNotEmpty)
        ? _mapLanguageCodeToText(sourceLangCode)
        : leftText;

    final displayLeftFlag = (sourceLangCode.trim().isNotEmpty)
        ? _mapLanguageCodeToFlag(sourceLangCode)
        : leftFlagAssetOrEmoji;

    return Container(
      height: 58.h,
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
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onLeftTap,
              borderRadius: BorderRadius.circular(14.r),
              child: Row(
                children: [
                  _Flag(displayLeftFlag),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      displayLeftText,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onSwap,
            borderRadius: BorderRadius.circular(999.r),
            child: Container(
              width: 31.w,
              height: 31.w,
              decoration: const BoxDecoration(
                color: Color(0xFF0A70FF),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.icDegisim,
                  width: 15.w,
                  height: 15.w,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: InkWell(
              onTap: onRightTap,
              borderRadius: BorderRadius.circular(14.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      rightText,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  _Flag(rightFlagAssetOrEmoji),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final String assetOrEmoji;

  const _Flag(this.assetOrEmoji);

  @override
  Widget build(BuildContext context) {
    if (assetOrEmoji.contains('/') && assetOrEmoji.endsWith('.png')) {
      return Image.asset(
        assetOrEmoji,
        width: 26.w,
        height: 18.h,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => SizedBox(
          width: 26.w,
          height: 18.h,
        ),
      );
    }

    return SizedBox(
      width: 26.w,
      height: 18.h,
      child: Center(
        child: Text(
          assetOrEmoji,
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}
