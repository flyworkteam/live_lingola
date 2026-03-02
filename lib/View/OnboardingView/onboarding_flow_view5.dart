import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lingora_app/Riverpod/Controllers/OnboardingController/onboarding_controller.dart';

class OnboardingFlowView5 extends ConsumerStatefulWidget {
  final VoidCallback onFinish;

  const OnboardingFlowView5({
    super.key,
    required this.onFinish,
    required Null Function() onNext,
  });

  @override
  ConsumerState<OnboardingFlowView5> createState() =>
      _OnboardingFlowView5State();
}

class _OnboardingFlowView5State extends ConsumerState<OnboardingFlowView5> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      ref.read(onboardingControllerProvider.notifier).startCreating();
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(onboardingControllerProvider);

    final bottomPad = 18.h;
    final percent = (s.createProgress * 100).round().clamp(0, 100);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: (51 + bottomPad + 24).h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 28.h),
                      SizedBox(
                        width: 159.w,
                        height: 159.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 159.w,
                              height: 159.w,
                              child: CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 7.w,
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFFD9E3F9),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            SizedBox(
                              width: 159.w,
                              height: 159.w,
                              child: CircularProgressIndicator(
                                value: s.createProgress.clamp(0.0, 1.0),
                                strokeWidth: 7.w,
                                strokeCap: StrokeCap.round,
                                valueColor: const AlwaysStoppedAnimation(
                                  Color(0xFF0A70FF),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Container(
                              width: 110.w,
                              height: 110.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFD9E7FF),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/images/icons/actions/ai_robot.svg',
                                  width: 54.sp,
                                  height: 54.sp,
                                  fit: BoxFit.contain,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF0A70FF),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Text(
                          'Your Personal Account\nIs Being Created',
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
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 32.w),
                        child: Text(
                          'Your AI assistant is personalizing your experience.\nThis may take a few seconds.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            fontSize: 15.sp,
                            height: 1.25,
                            color: const Color(0xFF7A879A),
                          ),
                        ),
                      ),
                      SizedBox(height: 34.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36.w),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 198.w,
                              height: 28.h,
                              child: Text(
                                'AI personalizing your experience',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  height: 28 / 12,
                                  color: const Color(0xFF0A70FF),
                                ),
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 40.w,
                              height: 28.h,
                              child: Text(
                                '$percent%',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  height: 28 / 12,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: SizedBox(
                            height: 6.h,
                            child: LinearProgressIndicator(
                              value: s.createProgress.clamp(0.0, 1.0),
                              backgroundColor: const Color(0xFFE6EAF2),
                              valueColor: const AlwaysStoppedAnimation(
                                Color(0xFF0A70FF),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 18.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                color: Color(0xFFDEE5F7),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 16.h),
                          child: Column(
                            children: [
                              _CheckRow(
                                done: s.profileCreated,
                                text: 'Profile is being created',
                              ),
                              SizedBox(height: 12.h),
                              _CheckRow(
                                done: s.languageConfigured,
                                text: 'Language settings are being configured',
                              ),
                              SizedBox(height: 12.h),
                              _CheckRow(
                                done: s.aiPrepared,
                                text: 'AI model is being prepared',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
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
                      onPressed:
                          s.createProgress >= 1.0 ? widget.onFinish : null,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF0A70FF),
                        disabledBackgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                      ),
                      child: Text(
                        'Get Started',
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

class _CheckRow extends StatelessWidget {
  final bool done;
  final String text;

  const _CheckRow({required this.done, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 22.w,
          height: 22.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? const Color(0xFF22C55E) : Colors.transparent,
            border: Border.all(
              color: done ? const Color(0xFF22C55E) : const Color(0xFFBFC7D5),
              width: 2,
            ),
          ),
          child:
              done ? Icon(Icons.check, size: 14.sp, color: Colors.white) : null,
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              height: 30 / 12,
              color: const Color(0xFF000000),
            ),
          ),
        ),
      ],
    );
  }
}
