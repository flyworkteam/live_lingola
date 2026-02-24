import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceMicButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool filled;

  const VoiceMicButton({
    super.key,
    required this.onTap,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        width: 74.w,
        height: 74.w,
        decoration: BoxDecoration(
          color: filled ? const Color(0xFF0A70FF) : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.mic_rounded,
          size: 32.sp,
          color: filled ? Colors.white : const Color(0xFF0A70FF),
        ),
      ),
    );
  }
}
