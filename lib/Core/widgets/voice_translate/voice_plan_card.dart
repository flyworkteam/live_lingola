import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

class VoicePlanCard extends StatelessWidget {
  final bool isPro;
  final VoidCallback onStart;
  final Widget? child;

  const VoicePlanCard._({
    required this.isPro,
    required this.onStart,
    this.child,
  });

  factory VoicePlanCard.free({required VoidCallback onStart}) {
    return VoicePlanCard._(isPro: false, onStart: onStart);
  }

  factory VoicePlanCard.pro({required VoidCallback onStart, Widget? child}) {
    return VoicePlanCard._(isPro: true, onStart: onStart, child: child);
  }

  @override
  Widget build(BuildContext context) {
    final bg = isPro ? const Color(0xFFEAF2FF) : Colors.white;
    final borderColor = isPro ? const Color(0xFF1677FF) : Colors.transparent;

    final pillBg = isPro ? const Color(0xFFFFE8C7) : const Color(0xFFDDEBFF);
    final pillTextColor =
        isPro ? const Color(0xFFFF8A00) : const Color(0xFF1677FF);
    final pillLabel = isPro ? "PRO" : "FREE";

    final title = isPro ? "Real-Time\nTranslation" : "Translation Machine";

    final features = isPro
        ? const [
            "High Precision",
            "Pro Scenario",
            "Automatic Translation",
            "Top-Level Model"
          ]
        : const [
            "Basic Sensitivity",
            "Simple Scenario",
            "Touch and Talk",
            "General Model"
          ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 165.w,
          height: 287.h,
          padding: EdgeInsets.fromLTRB(14.w, 15.h, 14.w, 14.h),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(color: borderColor, width: isPro ? 2 : 0),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 26,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 4.w, top: 5.h),
                child: SizedBox(
                  height: 68.w,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: isPro
                        ? SizedBox(
                            width: 68.w,
                            height: 68.w,
                            child:
                                child ?? SvgPicture.asset(AppAssets.icMicicon),
                          )
                        : SizedBox(
                            width: 46.w,
                            height: 46.w,
                            child: SvgPicture.asset(
                              AppAssets.icKeyboard,
                              fit: BoxFit.contain,
                            ),
                          ),
                  ),
                ),
              ),

              // sabit mesafe
              SizedBox(height: 12.h),

              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                  color: const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 10.h),
              ...features.map((f) => Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: isPro
                            ? const Color(0xFF1677FF)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  )),
              const Spacer(),

              // Başlat Butonu
              Center(
                child: SizedBox(
                  width: 132.w,
                  height: 34.h,
                  child: ElevatedButton(
                    onPressed: onStart,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1677FF),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                    ),
                    child: Text(
                      "Başlat",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // FREE/PRO Etiketi
        Positioned(
          top: -11.5.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 80.w,
              height: 23.h,
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(50.r),
              ),
              alignment: Alignment.center,
              child: Text(
                pillLabel,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                  color: pillTextColor,
                ),
              ),
            ),
          ),
        ),

        if (isPro)
          Positioned(
            bottom: 42.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 56.w,
                height: 17.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A00),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  "60s trial",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
