import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'models.dart';

class TextTranslationLangRow extends StatelessWidget {
  final LangItem item;
  final bool active;
  final VoidCallback onTap;

  const TextTranslationLangRow({
    super.key,
    required this.item,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
        child: Row(
          children: [
            Image.asset(
              item.flagAsset,
              width: 28.w,
              height: 20.h,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => SizedBox(width: 28.w, height: 20.h),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                item.name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            if (active)
              Icon(
                Icons.check_rounded,
                size: 20.sp,
                color: const Color(0xFF0A70FF),
              ),
          ],
        ),
      ),
    );
  }
}
