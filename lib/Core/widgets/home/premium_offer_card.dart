import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

class PremiumOfferCard extends StatelessWidget {
  const PremiumOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 6),
            blurRadius: 16,
            color: Color(0x220B2B6B),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 6.w,
            bottom: 0,
            top: 0,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Image.asset(
                'assets/images/home/premium_girl.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18.w, 16.h, 140.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF03B7FF), Color(0xFF0A70FF)],
                  ).createShader(bounds),
                  child: Text(
                    "Unlimited Live Translation",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.2,
                      letterSpacing: -0.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  "Remove daily limits\non voice and text.",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.09,
                    letterSpacing: -1.0,
                    color: const Color(0xFF000000),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 30.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment(1.0, -0.2),
                      end: Alignment(-1.0, 0.8),
                      colors: [
                        Color(0xFF03B7FF),
                        Color(0xFF2EC9FF),
                        Color(0xFF0A70FF),
                      ],
                      stops: [0.1939, 0.45, 0.8061],
                    ),
                    borderRadius: BorderRadius.circular(999.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x2603B7FF),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 20.w,
                        height: 20.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(4.w),
                          child: SvgPicture.asset(
                            AppAssets.icPremium,
                            fit: BoxFit.contain,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Get Premium",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
