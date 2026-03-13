import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lingola_app/Riverpod/Controllers/OnboardingController/onboarding_controller.dart';
import 'package:lingola_app/Riverpod/Providers/onboarding_preferences_provider.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class OnboardingFlowView1 extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingFlowView1({
    super.key,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(onboardingControllerProvider);
    final c = ref.read(onboardingControllerProvider.notifier);

    const skipRight = 29.0;
    const blockTop = 130.0;
    const blockHeight = 516.0;

    final bottomCtaSpace = (51 + 18 + 12).h;

    void handleNext() {
      if (!s.canGoNext) return;
      onNext();
    }

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
                    onTap: onSkip,
                    child: Center(
                      child: Text(
                        l10n.skip,
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
                              l10n.onboardingFlow1Title,
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
                              l10n.onboardingFlow1Subtitle,
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
                          text: l10n.onboardingFlow1OptionDaily,
                          v: TranslationUsage.daily,
                          iconAsset: 'assets/images/onboarding1/messages.svg',
                        ),
                        choice(
                          figmaTop: 331,
                          text: l10n.onboardingFlow1OptionBusiness,
                          v: TranslationUsage.business,
                          iconAsset: 'assets/images/onboarding1/business.svg',
                        ),
                        choice(
                          figmaTop: 397,
                          text: l10n.onboardingFlow1OptionLearning,
                          v: TranslationUsage.learning,
                          iconAsset: 'assets/images/onboarding1/translate.svg',
                        ),
                        choice(
                          figmaTop: 463,
                          text: l10n.onboardingFlow1OptionTravel,
                          v: TranslationUsage.travel,
                          iconAsset: 'assets/images/onboarding1/travel.svg',
                        ),
                        choice(
                          figmaTop: 529,
                          text: l10n.onboardingFlow1OptionEntertainment,
                          v: TranslationUsage.entertainment,
                          iconAsset: 'assets/images/onboarding1/game.svg',
                        ),
                        choice(
                          figmaTop: 595,
                          text: l10n.onboardingFlow1OptionOther,
                          v: TranslationUsage.other,
                          iconAsset: 'assets/images/onboarding1/other.svg',
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
                      onPressed: s.canGoNext ? handleNext : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0A70FF),
                        disabledBackgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        l10n.next,
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
                  SvgPicture.asset(
                    iconAsset,
                    width: 18.sp,
                    height: 18.sp,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                      contentColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 230.w),
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
