import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SectionHeader extends StatelessWidget {
  final String left;
  final String? right;
  final VoidCallback? onRightTap;

  const SectionHeader({
    super.key,
    required this.left,
    this.right,
    this.onRightTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          left,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF94A3B8),
          ),
        ),
        const Spacer(),
        if (right != null)
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onRightTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
              child: Text(
                right!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0A70FF),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
