import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              child: Icon(
                Icons.arrow_back_rounded,
                size: 22.sp,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
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
                  width: 22.w,
                  height: 22.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A70FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings_outlined,
                    size: 14.sp,
                    color: Colors.white,
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
