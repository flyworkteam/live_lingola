import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextTranslationExampleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function(Offset globalPos) onMore;

  const TextTranslationExampleTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F8),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poppins Medium 12 / lineHeight 14
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 14 / 12,
                    letterSpacing: 0,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 8.h),

                // Poppins Medium 10 / lineHeight 14
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    height: 14 / 10,
                    letterSpacing: 0,
                    color: const Color(0xFF0A70FF),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (d) => onMore(d.globalPosition),
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, top: 2.h),
              child: Icon(
                Icons.more_vert_rounded,
                size: 18.sp,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
