import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lingora_app/Core/Utils/assets.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_lang_bar.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_paste_pill.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_pro_background_painter.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_text_card.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_top_bar.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_mic_button.dart';

import 'package:lingora_app/Riverpod/Providers/voice_translation_providers.dart';

class VoiceTranslateProLiveView extends ConsumerStatefulWidget {
  const VoiceTranslateProLiveView({super.key});

  @override
  ConsumerState<VoiceTranslateProLiveView> createState() =>
      _VoiceTranslateProLiveViewState();
}

class _VoiceTranslateProLiveViewState
    extends ConsumerState<VoiceTranslateProLiveView>
    with TickerProviderStateMixin {
  late final AnimationController _premiumCtrl;

  @override
  void initState() {
    super.initState();

    _premiumCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _premiumCtrl.dispose();
    super.dispose();
  }

  void _tapMic() {
    ref.read(voiceProLiveControllerProvider.notifier).tapMic();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final state = ref.watch(voiceProLiveControllerProvider);
    final stage = state.stage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF03B7FF),
                    Color(0xFFF3F6FB),
                    Color(0xFFFFFFFF),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          if (stage == ProStage.listening)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 280.h,
              child: IgnorePointer(
                ignoring: true,
                child: Opacity(
                  opacity: 0.70,
                  child: PremiumWaveOscillate(
                    anim: _premiumCtrl,
                    asset: AppAssets.icProAnimation,
                    height: 280.h,
                  ),
                ),
              ),
            ),

          // 3) Ana içerik
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: VoiceTopBar(
                    title: 'Real-Time Translation',
                    onBack: () => Navigator.pop(context),
                  ),
                ),
                SizedBox(height: 51.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: VoiceLangBar(
                    leftFlagAsset: 'assets/images/flags/Turkish.png',
                    leftText: 'Turkish',
                    rightFlagAsset: 'assets/images/flags/English.png',
                    rightText: 'English',
                    onSwap: () {},
                    onLeftTap: () {},
                    onRightTap: () {},
                  ),
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: stage == ProStage.empty
                          ? const SizedBox.shrink()
                          : Column(
                              children: [
                                const VoiceTextCard(
                                  label: "SOURCE LANGUAGE",
                                  text:
                                      "Modern ve temiz görünen UI arayüzleri oluşturmanıza yardımcı olabilirim.",
                                  rightTopWidget: VoicePastePill(),
                                  showBottomIcons: false,
                                ),
                                SizedBox(height: 12.h),
                                VoiceTextCard(
                                  label: stage == ProStage.listening
                                      ? "TRANSLATING..."
                                      : "TRANSLATION",
                                  text: stage == ProStage.listening
                                      ? ""
                                      : "I can help you create seamless and intuitive interfaces.",
                                  showBottomIcons: stage == ProStage.result,
                                  showEmptyPlaceholder:
                                      stage == ProStage.listening,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20.h + bottomPad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      VoiceMicButton(
                        onTap: _tapMic,
                        stage: stage,
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 20.h,
                        child: stage == ProStage.listening
                            ? Text(
                                "Listening",
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF94A3B8),
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumWaveOscillate extends StatelessWidget {
  final Animation<double> anim;
  final String asset;
  final double height;

  const PremiumWaveOscillate({
    super.key,
    required this.anim,
    required this.asset,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: anim,
      builder: (_, __) {
        final t = anim.value; // 0..1

        //  SAĞ-SOL dalgalanma
        final dx = math.sin(t * math.pi * 2) * 18.0;

        //  Çok hafif yukarı-aşağı nefes
        final dy = math.sin((t * math.pi * 2) + 1.1) * 5.0;

        //  Nefes/pulse
        final scale = 0.988 + (math.sin(t * math.pi * 2) * 0.012);

        //  Çok minik rotate
        final rot = math.sin(t * math.pi * 2) * 0.004;

        return ClipRect(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Transform.translate(
                  offset: Offset(dx, dy),
                  child: Transform.rotate(
                    angle: rot,
                    child: Transform.scale(
                      scale: scale,
                      child: SvgPicture.asset(
                        asset,
                        width: w,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(1),
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(0),
                          Colors.white.withOpacity(1),
                        ],
                        stops: const [0.0, 0.18, 0.82, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
