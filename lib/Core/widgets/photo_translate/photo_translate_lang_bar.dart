import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoTranslateLangBar extends StatelessWidget {
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
            child: InkWell(
              onTap: onLeftTap,
              borderRadius: BorderRadius.circular(14.r),
              child: Row(
                children: [
                  _Flag(leftFlagAssetOrEmoji),
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
            child: InkWell(
              onTap: onRightTap,
              borderRadius: BorderRadius.circular(14.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _Flag(rightFlagAssetOrEmoji),
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
      return ClipRRect(
        borderRadius: BorderRadius.circular(4.r),
        child: Image.asset(
          assetOrEmoji,
          width: 26.w,
          height: 18.h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => SizedBox(width: 26.w, height: 18.h),
        ),
      );
    }

    return Text(assetOrEmoji, style: TextStyle(fontSize: 18.sp));
  }
}
