import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingola_app/Core/Utils/assets.dart';
import 'package:lingola_app/Core/widgets/common/app_card.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class TextTranslationSourceCard extends StatelessWidget {
  final TextEditingController controller;
  final int charLimit;
  final int sourceLength;
  final VoidCallback onPaste;
  final VoidCallback onSave;
  final ValueChanged<String> onChanged;
  final bool isSaveAnimating;

  const TextTranslationSourceCard({
    super.key,
    required this.controller,
    required this.charLimit,
    required this.sourceLength,
    required this.onPaste,
    required this.onSave,
    required this.onChanged,
    required this.isSaveAnimating,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
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
                borderRadius: BorderRadius.circular(999.r),
                onTap: onPaste,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F0FF),
                    borderRadius: BorderRadius.circular(999.r),
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
            controller: controller,
            maxLines: 4,
            maxLength: charLimit,
            onChanged: onChanged,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              height: 22 / 16,
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
                borderRadius: BorderRadius.circular(999.r),
                onTap: onSave,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  child: SvgPicture.asset(
                    AppAssets.icDocument,
                    width: 18.sp,
                    height: 18.sp,
                    colorFilter: ColorFilter.mode(
                      isSaveAnimating
                          ? const Color(0xFF0A70FF)
                          : const Color(0xFF94A3B8),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '$sourceLength / $charLimit',
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
    );
  }
}
