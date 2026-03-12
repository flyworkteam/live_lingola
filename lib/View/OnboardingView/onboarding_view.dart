import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  Timer? _timer;
  int _currentIndex = 0;

  static const Duration _autoInterval = Duration(seconds: 3);
  static const Duration _pageAnimDuration = Duration(milliseconds: 900);

  bool _isUserInteracting = false;
  Timer? _resumeTimer;
  static const Duration _resumeAfterUser = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final p = _controller.page ?? 0.0;
      if (p != _page) setState(() => _page = p);
    });

    _startAuto();
  }

  void _startAuto() {
    _timer?.cancel();
    _timer = Timer.periodic(_autoInterval, (_) => _goNextAuto());
  }

  void _stopAuto() {
    _timer?.cancel();
    _timer = null;
  }

  void _scheduleResumeAuto() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(_resumeAfterUser, () {
      if (!mounted) return;
      if (_isUserInteracting) return;
      _startAuto();
    });
  }

  void _goNextAuto() {
    if (!mounted) return;
    if (!_controller.hasClients) return;
    if (_isUserInteracting) return;

    _currentIndex = (_currentIndex == 0) ? 1 : 0;

    _controller.animateToPage(
      _currentIndex,
      duration: _pageAnimDuration,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _stopAuto();
    _controller.dispose();
    super.dispose();
  }

  void _goLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final t = (_page).clamp(0.0, 1.0);
    final e = Curves.easeInOutCubic.transform(t);

    final bottomPad = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;

    final double centerX = screenWidth / 2;
    const double centerY = 260.0;

    const double outerR = 156.0;
    const double innerR = 122.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n is ScrollStartNotification) {
                _isUserInteracting = true;
                _stopAuto();
                _resumeTimer?.cancel();
              } else if (n is ScrollEndNotification) {
                _isUserInteracting = false;

                final p = _controller.page ?? 0.0;
                _currentIndex = p.round().clamp(0, 1);

                _scheduleResumeAuto();
              }
              return false;
            },
            child: PageView(
              controller: _controller,
              children: const [
                SizedBox.expand(),
                SizedBox.expand(),
              ],
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: ColoredBox(color: AppColors.background),
                ),
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
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_tr.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: outerR,
                  a0: 30,
                  a1: 110,
                  w: 58,
                  h: 58,
                ),
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_uk.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: outerR,
                  a0: 130,
                  a1: 210,
                  w: 50,
                  h: 50,
                ),
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_us.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: outerR,
                  a0: 250,
                  a1: 330,
                  w: 48,
                  h: 48,
                ),
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_fr.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: outerR,
                  a0: 350,
                  a1: 60,
                  w: 46,
                  h: 46,
                ),
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_kr.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: innerR,
                  a0: 80,
                  a1: 170,
                  w: 38,
                  h: 38,
                ),
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_ru.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: innerR,
                  a0: 200,
                  a1: 290,
                  w: 44,
                  h: 44,
                ),
                _flagOrbitLerpClockwise(
                  e,
                  path: 'assets/images/onboarding/flags/flag_de.svg',
                  cx: centerX,
                  cy: centerY,
                  radius: innerR,
                  a0: 300,
                  a1: 30,
                  w: 42,
                  h: 42,
                ),
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
                Positioned(
                  top: 490,
                  left: 20,
                  right: 20,
                  child: _TextSwap(
                    progress: e,
                    t1: l10n.onboardingTitle1,
                    t2: l10n.onboardingTitle2,
                  ),
                ),
                Positioned(
                  top: 590,
                  left: 30,
                  right: 30,
                  child: _BodySwap(
                    progress: e,
                    b1: l10n.onboardingBody1,
                    b2: l10n.onboardingBody2,
                  ),
                ),
              ],
            ),
          ),
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
                child: Text(
                  l10n.getStarted,
                  style: const TextStyle(
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

  static Widget _flagOrbitLerpClockwise(
    double e, {
    required String path,
    required double cx,
    required double cy,
    required double radius,
    required double a0,
    required double a1,
    required double w,
    required double h,
  }) {
    double end = a1;
    if (end < a0) end += 360.0;

    final angDeg = a0 + (end - a0) * e;
    final angle = angDeg * math.pi / 180;

    final left = cx + radius * math.cos(angle) - (w / 2);
    final top = cy + radius * math.sin(angle) - (h / 2);

    return Positioned(
      top: top,
      left: left,
      child: SvgPicture.asset(path, width: w, height: h),
    );
  }
}

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
        decoration: BoxDecoration(
          color: c,
          borderRadius: BorderRadius.circular(10),
        ),
      );
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
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 8 + (25 * e),
          height: 8,
          decoration: BoxDecoration(
            color: Color.lerp(gray, blue, e),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }
}

class _TextSwap extends StatelessWidget {
  final double progress;
  final String t1, t2;
  const _TextSwap({
    required this.progress,
    required this.t1,
    required this.t2,
  });

  @override
  Widget build(BuildContext context) {
    final e = progress.clamp(0.0, 1.0);
    return Stack(
      children: [
        _item(1 - e, 8 * e, t1),
        _item(e, 8 * (1 - e), t2),
      ],
    );
  }

  Widget _item(double op, double dy, String t) => Opacity(
        opacity: op,
        child: Transform.translate(
          offset: Offset(0, dy),
          child: Center(
            child: Text(
              t,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                height: 1.15,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
}

class _BodySwap extends StatelessWidget {
  final double progress;
  final String b1, b2;
  const _BodySwap({
    required this.progress,
    required this.b1,
    required this.b2,
  });

  @override
  Widget build(BuildContext context) {
    final e = progress.clamp(0.0, 1.0);
    return Stack(
      children: [
        _item(1 - e, 6 * e, b1),
        _item(e, 6 * (1 - e), b2),
      ],
    );
  }

  Widget _item(double op, double dy, String t) => Opacity(
        opacity: op,
        child: Transform.translate(
          offset: Offset(0, dy),
          child: Center(
            child: Text(
              t,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14.5,
                height: 1.5,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ),
      );
}
