import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lingora_app/Core/widgets/voice_translate/voice_lang_bar.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_paste_pill.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_pro_background_painter.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_text_card.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_top_bar.dart';

import 'package:lingora_app/Riverpod/Providers/voice_translation_providers.dart';

class VoiceTranslateProLiveView extends ConsumerStatefulWidget {
  const VoiceTranslateProLiveView({super.key});

  @override
  ConsumerState<VoiceTranslateProLiveView> createState() =>
      _VoiceTranslateProLiveViewState();
}

class _VoiceTranslateProLiveViewState
    extends ConsumerState<VoiceTranslateProLiveView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  void _tapMic() {
    ref.read(voiceProLiveControllerProvider.notifier).tapMic();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    final state = ref.watch(voiceProLiveControllerProvider);
    final stage = state.stage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Arka Plan Gradiyenti
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

          // 2. Dalga (Painter)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveCtrl,
              builder: (_, __) {
                return CustomPaint(
                  painter: VoiceProBackgroundPainter(
                    t: _waveCtrl.value,
                    stage: stage,
                  ),
                );
              },
            ),
          ),

          // 3. İçerik
          Column(
            children: [
              SizedBox(height: topPad + 8.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: VoiceTopBar(
                  title: 'Real-Time Translation',
                  onBack: () => Navigator.pop(context),
                ),
              ),

              SizedBox(height: 16.h),

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

              const Spacer(),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: stage == ProStage.empty
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const VoiceTextCard(
                              label: "SOURCE LANGUAGE",
                              text:
                                  "Modern ve temiz görünen, sorunsuz ve\nsezgisel kullanıcı arayüzleri oluşturmama\nyardımcı olabilirim.",
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
                                  : "I can help you create seamless and intuitive\nuser interfaces (UI) that look modern and\nclean.",
                              showBottomIcons: stage == ProStage.result,
                              showEmptyPlaceholder: stage == ProStage.listening,
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
              ),

              // ALT PANEL
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
        ],
      ),
    );
  }
}

class VoiceMicButton extends StatefulWidget {
  final VoidCallback onTap;
  final ProStage stage;

  const VoiceMicButton({
    super.key,
    required this.onTap,
    required this.stage,
  });

  @override
  State<VoiceMicButton> createState() => _VoiceMicButtonState();
}

class _VoiceMicButtonState extends State<VoiceMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _checkPulse();
  }

  @override
  void didUpdateWidget(covariant VoiceMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _checkPulse();
  }

  void _checkPulse() {
    if (widget.stage == ProStage.listening) {
      _pulseCtrl.repeat(reverse: true);
    } else {
      _pulseCtrl.stop();
      _pulseCtrl.animateTo(0);
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseCtrl,
        builder: (context, child) {
          double pulse = _pulseCtrl.value;
          bool isListening = widget.stage == ProStage.listening;

          return Container(
            width: 76.w + (pulse * 6.w),
            height: 76.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isListening ? 35.r : 40.r),
              color: isListening ? const Color(0xFF0A70FF) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isListening
                      ? const Color(0xFF0A70FF).withOpacity(0.3)
                      : Colors.black.withOpacity(0.05),
                  blurRadius: 25 + (pulse * 10),
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                'assets/images/icons/translate/microphone.png',
                width: 34.w,
                height: 34.w,
                color: isListening ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
