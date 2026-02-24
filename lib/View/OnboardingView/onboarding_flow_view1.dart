import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingora_app/Riverpod/Controllers/OnboardingController/onboarding_controller.dart';

import 'onboarding_flow_view2.dart';
import 'onboarding_flow_view6.dart';

class OnboardingFlowView1 extends ConsumerWidget {
  const OnboardingFlowView1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(onboardingControllerProvider);
    final c = ref.read(onboardingControllerProvider.notifier);

    const skipRight = 29.0;

    const blockTop = 130.0;
    const blockHeight = 516.0;

    final bottomCtaSpace = (51 + 18 + 12).h;

    Widget choice({
      required double figmaTop,
      required String text,
      required TranslationUsage v,
      required String iconAsset,
    }) {
      return Positioned(
        top: (figmaTop - blockTop).h,
        left: 36.w,
        child: _UsageChoiceButton(
          text: text,
          iconAsset: iconAsset,
          selected: s.usage == v,
          onTap: () => c.setUsage(v),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: true,
        bottom: false,
        minimum: EdgeInsets.only(top: 73.h),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.only(right: skipRight.w),
                child: SizedBox(
                  width: 35.w,
                  height: 30.h,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const OnboardingFlowView6(),
                        ),
                      );
                    },
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
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomCtaSpace),
                child: Center(
                  child: SizedBox(
                    width: 393.w,
                    height: blockHeight.h,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          top: (130 - blockTop).h,
                          left: 70.w,
                          child: SizedBox(
                            width: 255.w,
                            height: 60.h,
                            child: Text(
                              'What do you use the\ntranslation for most?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 24.sp,
                                height: 30 / 24,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: (193 - blockTop).h,
                          left: 60.w,
                          child: SizedBox(
                            width: 275.w,
                            height: 23.h,
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
                        ),
                        choice(
                          figmaTop: 265,
                          text: 'Daily Communication',
                          v: TranslationUsage.daily,
                          iconAsset: 'assets/images/onboarding1/messages.png',
                        ),
                        choice(
                          figmaTop: 331,
                          text: 'Business World',
                          v: TranslationUsage.business,
                          iconAsset: 'assets/images/onboarding1/bussines.png',
                        ),
                        choice(
                          figmaTop: 397,
                          text: 'Language Learning',
                          v: TranslationUsage.learning,
                          iconAsset: 'assets/images/onboarding1/translate.png',
                        ),
                        choice(
                          figmaTop: 463,
                          text: 'Travel',
                          v: TranslationUsage.travel,
                          iconAsset: 'assets/images/onboarding1/travel.png',
                        ),
                        choice(
                          figmaTop: 529,
                          text: 'Entertainment',
                          v: TranslationUsage.entertainment,
                          iconAsset: 'assets/images/onboarding1/game.png',
                        ),
                        choice(
                          figmaTop: 595,
                          text: 'Other',
                          v: TranslationUsage.other,
                          iconAsset: 'assets/images/onboarding1/other.png',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(36.w, 0, 36.w, 18.h),
                  child: SizedBox(
                    width: 321.w,
                    height: 51.h,
                    child: ElevatedButton(
                      onPressed: s.canGoNext
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const OnboardingFlowView2(),
                                ),
                              );
                            }
                          : null,
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

class _UsageChoiceButton extends StatelessWidget {
  final String text;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  const _UsageChoiceButton({
    required this.text,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selected ? const Color(0xFF0A70FF) : const Color(0xFFDFDFDF);
    final borderWidth = selected ? 2.w : 1.w;

    final contentColor =
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    iconAsset,
                    width: 18.sp,
                    height: 18.sp,
                    fit: BoxFit.contain,
                    color: contentColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                  SizedBox(width: 10.w),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 230.w,
                    ),
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
                        height: 24 / 15,
                        color: contentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
