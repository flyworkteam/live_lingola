import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProOfferCard extends StatelessWidget {
  final VoidCallback onTap;
  const ProOfferCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18.r),
      child: Container(
        height: 74.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1D8CFF), Color(0xFF0B62FF)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B62FF).withOpacity(.20),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                "Unlimited access to\nall features",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13.sp,
                  height: 1.15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFC24B),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.lock_rounded,
                      size: 16.sp, color: const Color(0xFF7A4B00)),
                  SizedBox(width: 6.w),
                  Text(
                    "Pro",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF7A4B00),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
