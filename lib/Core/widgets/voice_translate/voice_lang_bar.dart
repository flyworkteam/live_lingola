import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../Utils/assets.dart';

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
      height: 58.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
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
      child: Row(
        children: [
          InkWell(
            onTap: onLeftTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.asset(
                    leftFlagAsset,
                    width: 26.w,
                    height: 18.h,
                    fit: BoxFit.cover,
                  ),
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
          const Spacer(),
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
          const Spacer(),
          InkWell(
            onTap: onRightTap,
            borderRadius: BorderRadius.circular(14.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  rightText,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(width: 10.w),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Image.asset(
                    rightFlagAsset,
                    width: 26.w,
                    height: 18.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
