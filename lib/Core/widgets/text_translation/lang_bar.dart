import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextTranslationLangBar extends StatelessWidget {
  final LayerLink sourceLink;
  final LayerLink targetLink;

  final String sourceFlagAsset;
  final String targetFlagAsset;

  final String leftText;
  final String rightText;

  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final VoidCallback onSwap;

  const TextTranslationLangBar({
    super.key,
    required this.sourceLink,
    required this.targetLink,
    required this.sourceFlagAsset,
    required this.targetFlagAsset,
    required this.leftText,
    required this.rightText,
    required this.onLeftTap,
    required this.onRightTap,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
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
            child: CompositedTransformTarget(
              link: sourceLink,
              child: InkWell(
                onTap: onLeftTap,
                borderRadius: BorderRadius.circular(14.r),
                child: Row(
                  children: [
                    Image.asset(
                      sourceFlagAsset,
                      width: 26.w,
                      height: 18.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          SizedBox(width: 26.w, height: 18.h),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      leftText,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          InkWell(
            onTap: onSwap,
            borderRadius: BorderRadius.circular(999.r),
            child: Container(
              width: 34.w,
              height: 34.w,
              decoration: const BoxDecoration(
                color: Color(0xFF0A70FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                size: 18.sp,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: CompositedTransformTarget(
              link: targetLink,
              child: InkWell(
                onTap: onRightTap,
                borderRadius: BorderRadius.circular(14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      targetFlagAsset,
                      width: 26.w,
                      height: 18.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          SizedBox(width: 26.w, height: 18.h),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      rightText,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
