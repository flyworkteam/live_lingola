import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String plan;
  final String imageUrl;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.plan,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 82.w,
            height: 82.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF6B8B),
            ),
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.person,
                      color: Color(0xFF0F172A),
                      size: 34,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          plan,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white.withOpacity(.85),
          ),
        ),
      ],
    );
  }
}
