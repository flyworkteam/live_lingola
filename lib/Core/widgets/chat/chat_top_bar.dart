import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final String title;
  final String iconAsset;

  const ChatTopBar({
    super.key,
    required this.onBack,
    required this.title,
    required this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onBack,
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Icon(
                Icons.arrow_back_rounded,
                size: 22.sp,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7F0FF),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Image.asset(
                  iconAsset,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22.sp,
                color: const Color(0xFF0F172A),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(width: 44.w, height: 44.w),
        ],
      ),
    );
  }
}
