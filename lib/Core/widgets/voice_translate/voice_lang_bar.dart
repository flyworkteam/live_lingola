import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceLangBar extends StatelessWidget {
  final String leftFlagAsset;
  final String leftText;

  final String rightFlagAsset;
  final String rightText;

  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;
  final VoidCallback onSwap;

  const VoiceLangBar({
    super.key,
    required this.leftFlagAsset,
    required this.leftText,
    required this.rightFlagAsset,
    required this.rightText,
    required this.onLeftTap,
    required this.onRightTap,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onLeftTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: Image.asset(
                      leftFlagAsset,
                      width: 34.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 34.w,
                        height: 24.h,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    leftText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
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
              width: 44.w,
              height: 44.w,
              decoration: const BoxDecoration(
                color: Color(0xFF1677FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.swap_horiz_rounded,
                size: 22.sp,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: onRightTap,
              borderRadius: BorderRadius.circular(16.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: Image.asset(
                      rightFlagAsset,
                      width: 34.w,
                      height: 24.h,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 34.w,
                        height: 24.h,
                        color: const Color(0xFFE2E8F0),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    rightText,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16.sp,
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
