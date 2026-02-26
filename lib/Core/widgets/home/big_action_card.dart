import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

class BigActionCard extends StatelessWidget {
  final String title;
  final bool active;
  final String iconAsset;
  final VoidCallback? onTap;

  const BigActionCard({
    super.key,
    required this.title,
    required this.active,
    required this.iconAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26.r),
      onTap: onTap,
      child: Container(
        height: 130.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A70FF), Color(0xFF03B7FF)],
                )
              : null,
          color: active ? null : Colors.white,
          borderRadius: BorderRadius.circular(26.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F0B2B6B),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFFFFFFF) : null,
                gradient: !active
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF03B7FF), Color(0xFF0A70FF)],
                      )
                    : null,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: SvgPicture.asset(
                iconAsset,
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                  active ? const Color(0xFF0A70FF) : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.8,
                  color: active ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Transform.translate(
                  offset: Offset(0, -4.h),
                  child: SvgPicture.asset(
                    AppAssets.icArrowRight,
                    width: 24.sp,
                    height: 24.sp,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      active ? Colors.white : const Color(0xFF0F172A),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
