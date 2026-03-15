import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingola_app/Riverpod/Providers/onboarding_preferences_provider.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class OnboardingFlowView3 extends ConsumerWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onSkip;

  const OnboardingFlowView3({
    super.key,
    required this.onNext,
    required this.onBack,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(onboardingControllerProvider);
    final c = ref.read(onboardingControllerProvider.notifier);

    final canNext = s.usedAiBefore != null;
    const skipRight = 29.0;

    final bottomPad = 18.h;
    final bottomCtaSpace = (51 + bottomPad + 12).h;

    void handleNext() {
      if (!canNext) return;
      onNext();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
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
                    child: _AdaptiveText(
                      l10n.back,
                      maxLines: 1,
                      minFontSize: 11,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9AA4B2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
                      child: _AdaptiveText(
                        l10n.skip,
                        maxLines: 1,
                        minFontSize: 9,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 103.h),
                    SizedBox(
                      width: 255.w,
                      child: _AdaptiveText(
                        l10n.onboardingFlow3Title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        minFontSize: 16,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          height: 30 / 24,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 275.w,
                      child: _AdaptiveText(
                        l10n.onboardingFlow3Subtitle,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        minFontSize: 11,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 15.sp,
                          height: 1.15,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    SizedBox(height: 26.h),
                    _SimpleSelectButton(
                      text: l10n.yes,
                      selected: s.usedAiBefore == true,
                      onTap: () => c.setUsedAiBefore(true),
                    ),
                    SizedBox(height: 15.h),
                    _SimpleSelectButton(
                      text: l10n.no,
                      selected: s.usedAiBefore == false,
                      onTap: () => c.setUsedAiBefore(false),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
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
                      onPressed: canNext ? handleNext : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0A70FF),
                        disabledBackgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: _AdaptiveText(
                        l10n.next,
                        maxLines: 1,
                        minFontSize: 12,
                        textAlign: TextAlign.center,
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
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: _AdaptiveText(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  minFontSize: 11,
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
    );
  }
}

class _AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final double minFontSize;
  final TextAlign textAlign;

  const _AdaptiveText(
    this.text, {
    required this.style,
    required this.maxLines,
    required this.minFontSize,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fittedStyle = _findFittingStyle(
          text: text,
          baseStyle: style,
          minFontSize: minFontSize.sp,
          maxFontSize: (style.fontSize ?? 14),
          maxWidth: constraints.maxWidth,
          maxLines: maxLines,
          textDirection: Directionality.of(context),
          textScaler: MediaQuery.textScalerOf(context),
        );

        return Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: fittedStyle,
        );
      },
    );
  }

  TextStyle _findFittingStyle({
    required String text,
    required TextStyle baseStyle,
    required double minFontSize,
    required double maxFontSize,
    required double maxWidth,
    required int maxLines,
    required TextDirection textDirection,
    required TextScaler textScaler,
  }) {
    double low = minFontSize;
    double high = maxFontSize;
    double best = minFontSize;

    bool fits(double size) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: baseStyle.copyWith(fontSize: size),
        ),
        textAlign: textAlign,
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: maxLines,
        ellipsis: '…',
      )..layout(maxWidth: maxWidth);

      return !painter.didExceedMaxLines;
    }

    if (fits(maxFontSize)) {
      return baseStyle.copyWith(fontSize: maxFontSize);
    }

    for (int i = 0; i < 20; i++) {
      final mid = (low + high) / 2;
      if (fits(mid)) {
        best = mid;
        low = mid;
      } else {
        high = mid;
      }
    }

    return baseStyle.copyWith(fontSize: best);
  }
}
