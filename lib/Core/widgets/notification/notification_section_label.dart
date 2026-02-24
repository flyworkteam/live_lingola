import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSectionLabel extends StatelessWidget {
  final String text;
  final bool isOnBlue;

  const NotificationSectionLabel({
    super.key,
    required this.text,
    required this.isOnBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          color: isOnBlue
              ? Colors.white.withOpacity(0.85)
              : const Color(0xFF94A3B8),
        ),
      ),
    );
  }
}
