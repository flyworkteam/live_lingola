import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lingora_app/Riverpod/Controllers/OnboardingController/onboarding_controller.dart';
import 'package:lingora_app/View/HomeView/home_and_notifications_view.dart';

import 'onboarding_flow_view1.dart';
import 'onboarding_flow_view2.dart';
import 'onboarding_flow_view3.dart';
import 'onboarding_flow_view4.dart';
import 'onboarding_flow_view5.dart';

class OnboardingFlowSlider extends ConsumerStatefulWidget {
  const OnboardingFlowSlider({super.key});

  @override
  ConsumerState<OnboardingFlowSlider> createState() =>
      _OnboardingFlowSliderState();
}

class _OnboardingFlowSliderState extends ConsumerState<OnboardingFlowSlider> {
  late final PageController _pc;

  static const _dur = Duration(milliseconds: 320);
  static const _curve = Curves.easeInOut;

  static const int _lastIndex = 4; // 0..4 (View1..View5)

  @override
  void initState() {
    super.initState();
    _pc = PageController(
      initialPage: ref.read(onboardingControllerProvider).pageIndex,
    );
  }

  @override
  void dispose() {
    _pc.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    ref.read(onboardingControllerProvider.notifier).setPage(index);
    _pc.animateToPage(index, duration: _dur, curve: _curve);
  }

  void _finishToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeAndNotificationsView()),
    );
  }

  void _nextOrFinish(BuildContext context) {
    final s = ref.read(onboardingControllerProvider);
    if (s.pageIndex >= _lastIndex) {
      _finishToHome(context);
      return;
    }
    _goTo(s.pageIndex + 1);
  }

  void _back() {
    final s = ref.read(onboardingControllerProvider);
    final prev = (s.pageIndex - 1).clamp(0, _lastIndex);
    _goTo(prev);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pc,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (i) {
        ref.read(onboardingControllerProvider.notifier).setPage(i);
      },
      children: [
        OnboardingFlowView1(
          onNext: () => _nextOrFinish(context),
          onSkip: () => _nextOrFinish(context), // ✅ Skip = Next
        ),
        OnboardingFlowView2(
          onNext: () => _nextOrFinish(context),
          onBack: _back,
        ),
        OnboardingFlowView3(
          onNext: () => _nextOrFinish(context),
          onBack: _back,
          onSkip: () => _nextOrFinish(context), // ✅ Skip = Next
        ),
        OnboardingFlowView4(
          onNext: () => _nextOrFinish(context),
          onBack: _back,
          onSkip: () => _nextOrFinish(context), // ✅ Skip = Next
        ),
        OnboardingFlowView5(
          // ✅ Get Started (progress 1.0 olunca) => direkt Home
          onFinish: () => _finishToHome(context), onNext: () {},
        ),
      ],
    );
  }
}
