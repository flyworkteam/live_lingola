import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const TopIconBtn({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.22),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.35)),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
