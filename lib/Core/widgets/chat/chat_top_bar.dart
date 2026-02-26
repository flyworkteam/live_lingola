import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

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
          // --- GERİ BUTONU (SVG GÜNCELLENDİ) ---
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onBack,
            child: SizedBox(
              width: 44.w,
              height: 44.w,
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.icBack,
                  width: 22.sp,
                  height: 22.sp,
                  colorFilter: const ColorFilter.mode(
                    Color(0xFF0F172A),
                    BlendMode.srcIn,
                  ),
                ),
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
                child: SvgPicture.asset(
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
          // Sağ taraftaki dengeleyici boşluk
          SizedBox(width: 44.w, height: 44.w),
        ],
      ),
    );
  }
}
