import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureBtn extends StatelessWidget {
  final IconData icon;
  final String title;

  final VoidCallback? onTap;

  const FeatureBtn({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: 107.w,
          height: 105.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFFDEE5F7),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                left: 16.w,
                top: 14.h,
                child: Container(
                  width: 31.w,
                  height: 31.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A70FF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 23.w,
                      height: 30.h,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Icon(icon, color: const Color(0xFF0A70FF)),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16.w,
                top: 62.h,
                child: SizedBox(
                  width: 90.w,
                  child: Text(
                    title,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      height: 16 / 13,
                      letterSpacing: -0.65,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
