import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:lingora_app/Core/widgets/voice_translate/voice_lang_bar.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_paste_pill.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_pro_background_painter.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_text_card.dart';
import 'package:lingora_app/Core/widgets/voice_translate/voice_top_bar.dart';
import 'package:lingora_app/Core/Utils/assets.dart';
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
  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20000),
    )..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  void _tapMic() {
    ref.read(voiceProLiveControllerProvider.notifier).tapMic();
  }

  Widget _buildTranslatingLabel() {
    return AnimatedBuilder(
      animation: _waveCtrl,
      builder: (context, child) {
        int dots = ((_waveCtrl.value * 100) % 4).toInt();
        String dotText = "." * dots;
        return Text(
          "TRANSLATING$dotText",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
            color: const Color(0xFF0A70FF),
          ),
        );
      },
    );
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(0.2, -1.0),
                  end: const Alignment(-0.2, 1.0),
                  colors: [
                    const Color(0xFF0A70FF),
                    const Color(0xFF03B7FF),
                    const Color(0xFFEFF2F9).withOpacity(0.72),
                    const Color(0xFFEFF2F9).withOpacity(0.0),
                  ],
                  stops: const [0.0043, 0.2741, 0.575, 0.9957],
                ),
              ),
            ),
          ),
          Positioned(
            left: (-130).w,
            top: (600).h,
            child: IgnorePointer(
              child: Transform.rotate(
                angle: 43.37 * math.pi / 180,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (stage == ProStage.listening)
                      CustomPaint(
                        size: Size(611.6457.w, 643.0121.h),
                        painter: VoiceWavePainter(
                          animation: _waveCtrl,
                          color: const Color(0xFF0B84FF),
                          layerCount: 6,
                        ),
                      ),
                    CustomPaint(
                      size: Size(611.6457.w, 643.0121.h),
                      painter: _OvalStrokePainter(
                        color: const Color(0xFF0B84FF),
                        strokeWidth: 2.5,
                        isListening: stage == ProStage.listening,
                        animation: _waveCtrl,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
                    child: Column(
                      children: [
                        if (stage != ProStage.empty) ...[
                          const VoiceTextCard(
                            label: "SOURCE LANGUAGE",
                            text:
                                "Modern ve temiz görünen UI arayüzleri oluşturmanıza yardımcı olabilirim.",
                            rightTopWidget: VoicePastePill(),
                            showBottomIcons: false,
                          ),
                          SizedBox(height: 12.h),
                          VoiceTextCard(
                            labelWidget: stage == ProStage.listening
                                ? _buildTranslatingLabel()
                                : null,
                            label: stage == ProStage.listening
                                ? ""
                                : "TRANSLATION",
                            text: stage == ProStage.listening
                                ? ""
                                : (stage == ProStage.result
                                    ? "I can help you create seamless and intuitive interfaces."
                                    : ""),
                            showBottomIcons: stage == ProStage.result,
                            showEmptyPlaceholder: stage == ProStage.listening,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(bottom: 20.h + bottomPad),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _VoiceMicButton(
                        onTap: _tapMic,
                        isListening: stage == ProStage.listening,
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

class _VoiceMicButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isListening;

  const _VoiceMicButton({
    required this.onTap,
    required this.isListening,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 84.w,
        height: 84.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isListening ? const Color(0xFF0A70FF) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            AppAssets.icMicrophone,
            width: 50.w,
            height: 50.w,
            colorFilter: ColorFilter.mode(
              isListening ? Colors.white : Colors.black,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceWavePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final int layerCount;

  VoiceWavePainter(
      {required this.animation, required this.color, this.layerCount = 4})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < layerCount; i++) {
      final double progress = (animation.value + (i / layerCount)) % 1.0;
      final double opacity = (1.0 - progress).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = color.withOpacity(opacity * 0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 + (1 - progress) * 2;
      final Path path = Path();
      final double waveCount = 7.0 + i;
      final double waveAmplitude = 15.w * (1 - progress);
      final double baseRadiusX = (size.width / 2) + (progress * 100.w);
      final double baseRadiusY = (size.height / 2) + (progress * 100.w);
      for (double angle = 0; angle <= 360; angle += 2) {
        final double radian = angle * math.pi / 180;
        final double displacement = math.sin(
                (radian * waveCount) + (animation.value * 2 * math.pi) + i) *
            waveAmplitude;
        final double x =
            center.dx + (baseRadiusX + displacement) * math.cos(radian);
        final double y =
            center.dy + (baseRadiusY + displacement) * math.sin(radian);
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant VoiceWavePainter oldDelegate) => true;
}

class _OvalStrokePainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final bool isListening;
  final Animation<double>? animation;

  _OvalStrokePainter({
    required this.color,
    required this.strokeWidth,
    this.isListening = false,
    this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..isAntiAlias = true;
    if (!isListening || animation == null) {
      canvas.drawOval(Rect.fromLTWH(0, 0, size.width, size.height), paint);
    } else {
      final center = Offset(size.width / 2, size.height / 2);
      final Path path = Path();
      const double waveCount = 10.0;
      final double waveAmplitude = 6.w;
      for (double angle = 0; angle <= 360; angle += 1) {
        final double radian = angle * math.pi / 180;
        final double displacement =
            math.sin((radian * waveCount) + (animation!.value * 2 * math.pi)) *
                waveAmplitude;
        final double x =
            center.dx + (size.width / 2 + displacement) * math.cos(radian);
        final double y =
            center.dy + (size.height / 2 + displacement) * math.sin(radian);
        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OvalStrokePainter oldDelegate) => true;
}
