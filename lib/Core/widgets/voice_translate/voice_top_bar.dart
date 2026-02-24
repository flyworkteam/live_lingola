import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceTopBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const VoiceTopBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44.h,
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(999.r),
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.sp,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 44.w),
        ],
      ),
    );
  }
}
