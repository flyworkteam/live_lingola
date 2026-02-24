import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoicePlanCard extends StatelessWidget {
  final bool isPro;

  final VoidCallback onStart;

  const VoicePlanCard._({
    required this.isPro,
    required this.onStart,
  });

  factory VoicePlanCard.free({required VoidCallback onStart}) {
    return VoicePlanCard._(isPro: false, onStart: onStart);
  }

  factory VoicePlanCard.pro({required VoidCallback onStart}) {
    return VoicePlanCard._(isPro: true, onStart: onStart);
  }

  @override
  Widget build(BuildContext context) {
    final bg = isPro ? const Color(0xFFEAF2FF) : Colors.white;
    final borderColor = isPro ? const Color(0xFF1677FF) : Colors.transparent;

    final pillBg = isPro ? const Color(0xFFFFE8C7) : const Color(0xFFDDEBFF);
    final pillText = isPro ? const Color(0xFFFF8A00) : const Color(0xFF1677FF);
    final pillLabel = isPro ? "PRO" : "FREE";

    final title = isPro ? "Real-Time\nTranslation" : "Translation Machine";

    final features = isPro
        ? const [
            "High Precision",
            "Pro Scenario",
            "Automatic Translation",
            "Top-Level Model",
          ]
        : const [
            "Basic Sensitivity",
            "Simple Scenario",
            "Touch and Talk",
            "General Model",
          ];

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(18.w, 26.h, 18.w, 18.h),
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
              // icon box
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 78.w,
                      height: 78.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F0FF),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Center(
                        child: Icon(
                          isPro
                              ? Icons.mic_rounded
                              : Icons.keyboard_alt_rounded,
                          size: 40.sp,
                          color: const Color(0xFF1677FF),
                        ),
                      ),
                    ),

                    // PRO card AI bubble
                    if (isPro)
                      Positioned(
                        right: -6.w,
                        top: -8.h,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 6.h),
                          decoration: const BoxDecoration(
                            color: Color(0xFF22C55E),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "Ai",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.15,
                  color: const Color(0xFF0F172A),
                ),
              ),

              SizedBox(height: 12.h),

              for (final f in features) ...[
                Text(
                  f,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: isPro
                        ? const Color(0xFF1677FF)
                        : const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: 8.h),
              ],

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1677FF),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Text(
                    "Başlat",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              SizedBox(height: isPro ? 6.h : 0),
            ],
          ),
        ),

        // pill label (FREE/PRO)
        Positioned(
          top: -14.h,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: pillBg,
                borderRadius: BorderRadius.circular(999.r),
              ),
              child: Text(
                pillLabel,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w800,
                  color: pillText,
                ),
              ),
            ),
          ),
        ),

        // PRO “60s trial” chip
        if (isPro)
          Positioned(
            bottom: 58.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8A00),
                  borderRadius: BorderRadius.circular(999.r),
                ),
                child: Text(
                  "60s trial",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
