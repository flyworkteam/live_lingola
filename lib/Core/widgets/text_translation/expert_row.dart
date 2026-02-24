import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextTranslationExpertRow extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const TextTranslationExpertRow({
    super.key,
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            if (active)
              Icon(
                Icons.check_rounded,
                size: 18.sp,
                color: const Color(0xFF0A70FF),
              ),
          ],
        ),
      ),
    );
  }
}
