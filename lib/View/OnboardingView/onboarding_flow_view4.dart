import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingora_app/Riverpod/Controllers/OnboardingController/onboarding_controller.dart';

class OnboardingFlowView4 extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingFlowView4({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(onboardingControllerProvider);
    final c = ref.read(onboardingControllerProvider.notifier);

    final canNext = s.feature != null;
    const skipRight = 29.0;

    final bottomPad = 18.h;
    final bottomCtaSpace = (51 + bottomPad + 12).h;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            // BACK
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: SizedBox(
                  height: 44.h,
                  child: TextButton(
                    onPressed: onBack,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF9AA4B2),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                    ),
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // SKIP
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: skipRight.w),
                child: SizedBox(
                  width: 35.w,
                  height: 30.h,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onSkip,
                    child: Center(
                      child: Text(
                        'Skip',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          height: 30 / 16,
                          color: const Color(0xFF0A70FF),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // CONTENT
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomCtaSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 103.h),
                    SizedBox(
                      width: 354.w,
                      height: 60.h,
                      child: Text(
                        'What features would you like\nin a translation app?',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          height: 30 / 24,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    SizedBox(
                      width: 275.w,
                      height: 51.h,
                      child: Text(
                        'Please indicate your preference.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 15.sp,
                          height: 1.0,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    _SimpleSelectButton(
                      text: 'Accurate Translation',
                      selected: s.feature == AppFeature.accurate,
                      onTap: () => c.setFeature(AppFeature.accurate),
                    ),
                    SizedBox(height: 15.h),
                    _SimpleSelectButton(
                      text: 'Easy To Use',
                      selected: s.feature == AppFeature.easy,
                      onTap: () => c.setFeature(AppFeature.easy),
                    ),
                    SizedBox(height: 15.h),
                    _SimpleSelectButton(
                      text: 'Privacy Protection',
                      selected: s.feature == AppFeature.privacy,
                      onTap: () => c.setFeature(AppFeature.privacy),
                    ),
                    SizedBox(height: 15.h),
                    _SimpleSelectButton(
                      text: 'Teach Me A Language',
                      selected: s.feature == AppFeature.teach,
                      onTap: () => c.setFeature(AppFeature.teach),
                    ),
                    SizedBox(height: 15.h),
                    _SimpleSelectButton(
                      text: 'All Of Them',
                      selected: s.feature == AppFeature.all,
                      onTap: () => c.setFeature(AppFeature.all),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),

            // NEXT
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 0, 36.w, bottomPad),
                  child: SizedBox(
                    width: 321.w,
                    height: 51.h,
                    child: ElevatedButton(
                      onPressed: canNext ? onNext : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0A70FF),
                        disabledBackgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        'Next',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          color: Colors.white,
                        ),
                      ),
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

class _SimpleSelectButton extends StatelessWidget {
  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _SimpleSelectButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFF0A70FF) : const Color(0xFFDFDFDF);
    final borderWidth = selected ? 2.w : 1.w;
    final textColor =
        selected ? const Color(0xFF0A70FF) : const Color(0xFF000000);

    return SizedBox(
      width: 321.w,
      height: 51.h,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.r),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
              border: Border.all(color: borderColor, width: borderWidth),
            ),
            child: Center(
              child: SizedBox(
                width: 164.w,
                height: 24.h,
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 15.sp,
                      height: 24 / 15,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
