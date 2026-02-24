import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSkip;

  const OnboardingTopBar({super.key, this.onBack, this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        children: [
          if (onBack != null)
            GestureDetector(
              onTap: onBack,
              child: Text(
                'Back',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF7A879A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          const Spacer(),
          if (onSkip != null)
            GestureDetector(
              onTap: onSkip,
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xFF0A70FF),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
