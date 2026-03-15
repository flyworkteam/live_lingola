import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/Core/widgets/common/app_card.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class TextTranslationResultCard extends StatelessWidget {
  final bool isTranslating;
  final String translatedText;
  final bool isFavorite;
  final bool isSpeaking;
  final VoidCallback onCopy;
  final VoidCallback onFavorite;
  final VoidCallback onSpeak;

  const TextTranslationResultCard({
    super.key,
    required this.isTranslating,
    required this.translatedText,
    required this.isFavorite,
    required this.isSpeaking,
    required this.onCopy,
    required this.onFavorite,
    required this.onSpeak,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasText = translatedText.trim().isNotEmpty;

    return AppCard(
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
            isTranslating ? l10n.translating : translatedText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 22 / 16,
              color: const Color(0xFF0F172A),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: onCopy,
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
                borderRadius: BorderRadius.circular(999.r),
                onTap: onFavorite,
                child: SvgPicture.asset(
                  AppAssets.icFav,
                  width: 20.sp,
                  height: 20.sp,
                  colorFilter: ColorFilter.mode(
                    isFavorite
                        ? const Color(0xFF0A70FF)
                        : const Color(0xFFCBD5E1),
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                borderRadius: BorderRadius.circular(999.r),
                onTap: hasText ? onSpeak : null,
                child: Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: hasText
                        ? const Color(0xFF0A70FF)
                        : const Color(0xFFBFD8FF),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.icSes,
                      width: 18.sp,
                      height: 18.sp,
                      colorFilter: ColorFilter.mode(
                        isSpeaking ? const Color(0xFFE3F2FF) : Colors.white,
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
