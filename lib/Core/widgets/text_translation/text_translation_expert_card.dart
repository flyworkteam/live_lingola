import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingola_app/Core/widgets/common/app_card.dart';

class TextTranslationExpertCard extends StatelessWidget {
  final String title;
  final String selectedExpert;
  final VoidCallback onTap;

  const TextTranslationExpertCard({
    super.key,
    required this.title,
    required this.selectedExpert,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              height: 26 / 13,
              color: const Color(0xFF0F172A),
            ),
          ),
          const Spacer(),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
              child: Row(
                children: [
                  Text(
                    selectedExpert,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0A70FF),
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.sp,
                    color: const Color(0xFF0A70FF),
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
