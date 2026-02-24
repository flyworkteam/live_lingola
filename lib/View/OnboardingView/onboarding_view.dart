import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Core/Routes/app_routes.dart';
import '../../Core/Theme/app_colors.dart';
import '../../Core/Theme/app_text_styles.dart';
import '../../Core/widgets/common/dashed_circle.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _controller = PageController();
  double _page = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final p = _controller.page ?? 0.0;
      if (p != _page) setState(() => _page = p);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final t = (_page).clamp(0.0, 1.0);
    final e = Curves.easeInOutCubic.transform(t);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    //MERKEZ NOKTASI
    final double centerX = screenWidth / 2;
    const double centerY = 260.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: const [SizedBox.expand(), SizedBox.expand()],
          ),
          IgnorePointer(
            ignoring: true,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: AppColors.background),
                ),

                // -------------------- HERO (CIRCLES) --------------------
                Positioned(
                  top: centerY - 146,
                  left: centerX - 146,
                  child: Transform.rotate(
                    angle: (6 * e) * math.pi / 180,
                    child: const DashedCircle(size: 292),
                  ),
                ),
                Positioned(
                  top: centerY - 113,
                  left: centerX - 113,
                  child: Transform.rotate(
                    angle: (-5 * e) * math.pi / 180,
                    child: const DashedCircle(size: 226),
                  ),
                ),
                Positioned(
                  top: centerY - 79,
                  left: centerX - 79,
                  child: const SizedBox(
                    width: 158,
                    height: 158,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Color(0xFFEFF2F9),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),

                // -------------------- FLAGS (ORBIT ROTATION) --------------------

                // --- DIŞ HALKA ---
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_tr.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 146,
                    startAngle: 210,
                    sweepAngle: 120,
                    w: 65,
                    h: 65,
                    rotateTurns: 0),
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_us.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 146,
                    startAngle: 275,
                    sweepAngle: 85,
                    w: 50,
                    h: 50,
                    rotateTurns: 0),
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_fr.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 146,
                    startAngle: 350,
                    sweepAngle: -90,
                    w: 48,
                    h: 48,
                    rotateTurns: 0),
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_uk.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 146,
                    startAngle: 85,
                    sweepAngle: 115,
                    w: 55,
                    h: 55,
                    rotateTurns: 0),

                // --- İÇ HALKA ---
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_ru.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 113,
                    startAngle: 165,
                    sweepAngle: -110,
                    w: 45,
                    h: 45,
                    rotateTurns: 0),
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_kr.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 113,
                    startAngle: 45,
                    sweepAngle: 135,
                    w: 38,
                    h: 38,
                    rotateTurns: 0),
                _flagOrbit(e,
                    path: 'assets/images/onboarding/flags/flag_de.svg',
                    cx: centerX,
                    cy: centerY,
                    radius: 113,
                    startAngle: 315,
                    sweepAngle: -150,
                    w: 42,
                    h: 42,
                    rotateTurns: 0),

                // -------------------- INDICATOR --------------------
                const Positioned(
                  top: 460,
                  left: 0,
                  right: 0,
                  child: _IndicatorBase(),
                ),
                Positioned(
                  top: 460,
                  left: 0,
                  right: 0,
                  child: _IndicatorAnimator(progress: e),
                ),

                // -------------------- TITLE --------------------
                Positioned(
                  top: 490,
                  left: 20,
                  right: 20,
                  child: _TextSwap(
                    progress: e,
                    t1: 'Break Down\nLanguage Barriers',
                    t2: 'Live Translation\nExperience',
                  ),
                ),

                // -------------------- BODY --------------------
                Positioned(
                  top: 590,
                  left: 30,
                  right: 30,
                  child: _BodySwap(
                    progress: e,
                    b1: 'With Live Lingola, no matter where you are in the world, foreign languages are no longer a barrier. Experience communication at its most fluid.',
                    b2: 'Instantly translate your voice and surrounding text into your own language. Conversations are now seamless with our AI-powered technology.',
                  ),
                ),
              ],
            ),
          ),

          //GET STARTED BUTTON
          Positioned(
            left: 36,
            right: 36,
            bottom: 20 + bottomPad,
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A70FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 0,
                ),
                onPressed: _goLogin,
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _flagOrbit(double e,
      {required String path,
      required double cx,
      required double cy,
      required double radius,
      required double startAngle,
      required double sweepAngle,
      required double w,
      required double h,
      double rotateTurns = 0.0}) {
    final angle = (startAngle + (sweepAngle * e)) * math.pi / 180;
    final left = cx + radius * math.cos(angle) - (w / 2);
    final top = cy + radius * math.sin(angle) - (h / 2);

    return Positioned(
      top: top,
      left: left,
      child: SvgPicture.asset(path, width: w, height: h),
    );
  }
}

// --- YARDIMCI BİLEŞENLER ---

class _IndicatorBase extends StatelessWidget {
  const _IndicatorBase();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _dot(8, const Color(0xFFD9D9D9)),
        const SizedBox(width: 6),
        _dot(8, const Color(0xFFD9D9D9)),
      ],
    );
  }

  Widget _dot(double w, Color c) => Container(
      width: w,
      height: 8,
      decoration:
          BoxDecoration(color: c, borderRadius: BorderRadius.circular(10)));
}

class _IndicatorAnimator extends StatelessWidget {
  final double progress;
  const _IndicatorAnimator({required this.progress});
  @override
  Widget build(BuildContext context) {
    final e = progress.clamp(0.0, 1.0);
    const blue = Color(0xFF0A70FF);
    const gray = Color(0xFFD9D9D9);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 33 - (25 * e),
            height: 8,
            decoration: BoxDecoration(
                color: Color.lerp(blue, gray, e),
                borderRadius: BorderRadius.circular(10))),
        const SizedBox(width: 6),
        Container(
            width: 8 + (25 * e),
            height: 8,
            decoration: BoxDecoration(
                color: Color.lerp(gray, blue, e),
                borderRadius: BorderRadius.circular(10))),
      ],
    );
  }
}

class _TextSwap extends StatelessWidget {
  final double progress;
  final String t1, t2;
  const _TextSwap({required this.progress, required this.t1, required this.t2});
  @override
  Widget build(BuildContext context) {
    final e = progress.clamp(0.0, 1.0);
    return Stack(children: [
      _item(1 - e, 8 * e, t1),
      _item(e, 8 * (1 - e), t2),
    ]);
  }

  Widget _item(double op, double dy, String t) => Opacity(
      opacity: op,
      child: Transform.translate(
          offset: Offset(0, dy),
          child: Center(
              child: Text(t,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 30,
                      height: 1.15,
                      color: Colors.black)))));
}

class _BodySwap extends StatelessWidget {
  final double progress;
  final String b1, b2;
  const _BodySwap({required this.progress, required this.b1, required this.b2});
  @override
  Widget build(BuildContext context) {
    final e = progress.clamp(0.0, 1.0);
    return Stack(children: [
      _item(1 - e, 6 * e, b1),
      _item(e, 6 * (1 - e), b2),
    ]);
  }

  Widget _item(double op, double dy, String t) => Opacity(
      opacity: op,
      child: Transform.translate(
          offset: Offset(0, dy),
          child: Center(
              child: Text(t,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.5,
                      height: 1.5,
                      color: Color(0xFF475569))))));
}
