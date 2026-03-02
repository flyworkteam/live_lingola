import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingFlowView6 extends StatelessWidget {
  final VoidCallback onFinish;

  const OnboardingFlowView6({
    super.key,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 22.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle,
                    color: Color(0xFF0A70FF), size: 72),
                SizedBox(height: 16.h),
                Text(
                  'Created!',
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF000000)),
                ),
                SizedBox(height: 8.h),
                Text(
                  'You are ready to start.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF7A879A),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 18.h),
                SizedBox(
                  width: double.infinity,
                  height: 51.h,
                  child: ElevatedButton(
                    onPressed: onFinish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A70FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r)),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
