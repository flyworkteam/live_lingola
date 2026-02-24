import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoicePastePill extends StatelessWidget {
  const VoicePastePill({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F0FF),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.content_paste_rounded,
              size: 14.sp, color: const Color(0xFF0A70FF)),
          SizedBox(width: 6.w),
          Text(
            "Paste",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0A70FF),
            ),
          ),
        ],
      ),
    );
  }
}
