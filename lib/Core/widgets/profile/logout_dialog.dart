import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

class LogoutDialog {
  static Future<bool?> show(BuildContext context) {
    return showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'logout',
      barrierColor: Colors.black.withOpacity(.10),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, anim1, anim2) {
        return SafeArea(
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(color: Colors.transparent),
              ),
              Center(
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 310.w,
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4F4),
                      borderRadius: BorderRadius.circular(18.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 24,
                          offset: const Offset(0, 14),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 26.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE3E3),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.icBack,
                                  width: 14.w,
                                  height: 14.w,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFFEF4444),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "You are about to log out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14.5.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "See you again soon! We'll miss your\nexperience.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            height: 1.25,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF0F172A).withOpacity(.70),
                          ),
                        ),
                        SizedBox(height: 14.h),
                        SizedBox(
                          width: double.infinity,
                          height: 44.h,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEA3B4A),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.r),
                              ),
                            ),
                            child: Text(
                              "Log out",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        InkWell(
                          onTap: () => Navigator.of(context).pop(false),
                          borderRadius: BorderRadius.circular(12.r),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 6.h,
                            ),
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12.5.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, anim, _, child) {
        final curved =
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
