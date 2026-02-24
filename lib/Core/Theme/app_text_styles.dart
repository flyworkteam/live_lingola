import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static TextStyle get splashTitle42 => TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w500,
        fontSize: 42.sp,
        height: 26 / 42,
        letterSpacing: -0.05 * 42,
        color: Colors.black,
      );

  static TextStyle get onboardingTitle32sb => TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w600,
        fontSize: 32.sp,
        height: 40 / 32,
        letterSpacing: -0.05 * 32,
        color: Colors.black,
      );

  static TextStyle get onboardingBody15l => TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w300,
        fontSize: 15.sp,
        height: 24 / 15,
        letterSpacing: -0.05 * 15,
        color: Colors.black,
      );

  static TextStyle get button16r => TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.w400,
        fontSize: 16.sp,
        height: 24 / 16,
        color: Colors.white,
      );
}
