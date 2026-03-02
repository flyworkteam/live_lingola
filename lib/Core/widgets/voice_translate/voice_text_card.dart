import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceTextCard extends StatelessWidget {
  final String label;
  final String text;
  final Widget? rightTopWidget;
  final Widget? labelWidget;
  final bool showBottomIcons;
  final bool showEmptyPlaceholder;

  const VoiceTextCard({
    super.key,
    required this.label,
    required this.text,
    this.rightTopWidget,
    this.labelWidget,
    required this.showBottomIcons,
    this.showEmptyPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0B2B6B),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              labelWidget ??
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: const Color(0xFF0A70FF),
                    ),
                  ),
              const Spacer(),
              if (rightTopWidget != null) rightTopWidget!,
            ],
          ),
          SizedBox(height: 10.h),
          if (text.isNotEmpty)
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                height: 1.25,
                color: const Color(0xFF0F172A),
              ),
            )
          else if (showEmptyPlaceholder)
            SizedBox(height: 36.h),
          SizedBox(height: 12.h),
          if (showBottomIcons)
            Row(
              children: [
                Icon(Icons.copy_all_outlined,
                    size: 18.sp, color: const Color(0xFF94A3B8)),
                SizedBox(width: 12.w),
                Icon(Icons.star_border_rounded,
                    size: 20.sp, color: const Color(0xFF94A3B8)),
                const Spacer(),
                Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF0A70FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.volume_up_rounded,
                      size: 18.sp, color: Colors.white),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
