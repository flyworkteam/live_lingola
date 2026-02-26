import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

class PhotoTranslateTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;
  final VoidCallback? onRightTap;

  const PhotoTranslateTopBar({
    super.key,
    required this.title,
    required this.onBack,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onBack,
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.icBack,
                  width: 24.sp,
                  height: 24.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0F172A),
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                  height: 26 / 20,
                  letterSpacing: 0,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onRightTap,
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Center(
                child: Container(
                  width: 29.w,
                  height: 29.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.icSettings,
                      width: 20.w,
                      height: 20.w,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF0A70FF),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
