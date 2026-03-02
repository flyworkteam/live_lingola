import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';
import 'package:lingora_app/Core/widgets/navigation/bottom_nav_item_tile.dart';

enum _FreeStage { idle, listening, result }

enum _SpeakLang { tr, en }

class VoiceTranslateFreeLiveView extends StatefulWidget {
  const VoiceTranslateFreeLiveView({super.key});

  @override
  State<VoiceTranslateFreeLiveView> createState() =>
      _VoiceTranslateFreeLiveViewState();
}

class _VoiceTranslateFreeLiveViewState extends State<VoiceTranslateFreeLiveView>
    with SingleTickerProviderStateMixin {
  _FreeStage _stage = _FreeStage.idle;
  _SpeakLang _speakLang = _SpeakLang.tr;

  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  bool get _isListening => _stage == _FreeStage.listening;

  void _toggleMic() {
    setState(() {
      if (_stage == _FreeStage.idle) {
        _stage = _FreeStage.listening;
      } else if (_stage == _FreeStage.listening) {
        _stage = _FreeStage.result;
      } else {
        _stage = _FreeStage.idle;
      }
    });
  }

  void _setSpeakLang(_SpeakLang lang) {
    setState(() => _speakLang = lang);
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final bottomNavReserve = 62.h + 20.h + bottomPad;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(color: const Color(0xFFF3F6FB)),
          ),
          Column(
            children: [
              SizedBox(height: topPad + 10.h),

              // TOP BAR
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  height: 44.h,
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.pop(context),
                        child: SizedBox(
                          width: 40.w,
                          height: 40.w,
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.icBack,
                              width: 18.sp,
                              height: 18.sp,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0F172A),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Voice Translate",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 40.w),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 51.h),

              // HEADER ROW
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Real-Time Translation - Faster,\nSmarter Artificial Intelligence",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7F0FF),
                        borderRadius: BorderRadius.circular(999.r),
                      ),
                      child: Text(
                        "Try Now!",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0A70FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              // TOP WAVE
              SizedBox(
                height: 140.h,
                child: _isListening
                    ? AnimatedBuilder(
                        animation: _waveCtrl,
                        builder: (_, __) => CustomPaint(
                          size: Size(double.infinity, 140.h),
                          painter: _TopStrandsWavePainter(
                            t: _waveCtrl.value,
                            strands: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              // Divider line
              Container(
                height: 2.h,
                width: double.infinity,
                color: const Color(0xFF0A70FF),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 0),
                  child: Column(
                    children: [
                      if (_stage == _FreeStage.listening) ...[
                        Text(
                          "Listening",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _speakLang == _SpeakLang.tr
                              ? "Merhaba, nasılsın?"
                              : "Hello, how are you?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ] else if (_stage == _FreeStage.result) ...[
                        Text(
                          "Translation results",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          _speakLang == _SpeakLang.tr
                              ? "Hello, how are you?"
                              : "Merhaba, nasılsın?",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                      ] else ...[
                        const Spacer(),
                        const Spacer(),
                      ],
                      const Spacer(),

                      // Pill
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 18.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(
                            color: const Color(0xFF0A70FF),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.icMicrophone,
                              width: 14.w,
                              height: 14.w,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF0A70FF),
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "Real-Time Translation",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF0A70FF),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 14.h),

                      _UnifiedLangBar(
                        height: 74.h,
                        isListening: _isListening,
                        speakLang: _speakLang,
                        onSelectTR: () => _setSpeakLang(_SpeakLang.tr),
                        onSelectEN: () => _setSpeakLang(_SpeakLang.en),
                        onMicTap: _toggleMic,
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        _isListening
                            ? "Tap to translate now"
                            : "Please select the language you wish to speak in",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                        ),
                      ),

                      SizedBox(height: 18.h),
                      SizedBox(height: bottomNavReserve),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Nav
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavBar(
              currentIndex: 2,
              onTap: (_) {},
              homeAsset: AppAssets.navHome,
              chatAsset: AppAssets.navChat,
              micAsset: AppAssets.navMic,
              cameraAsset: AppAssets.navCamera,
              outerBottomPadding: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _TopStrandsWavePainter extends CustomPainter {
  final double t;
  final int strands;

  _TopStrandsWavePainter({required this.t, this.strands = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final baseY = h - 2.0;

    const double freq = 2 * math.pi;
    final phase = t * 2 * math.pi;

    final envelope = 0.55 + 0.45 * ((math.sin(phase * 0.9) + 1) / 2);

    for (int i = 0; i < strands; i++) {
      final mid = (strands - 1) / 2;
      final dist = (i - mid).abs();
      final alpha = 0.08 + (1.0 - dist / (mid + 0.0001)) * 0.22;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF0A70FF).withOpacity(alpha);

      final path = Path();
      path.moveTo(0, baseY);

      final localPhase = phase + i * 0.22;

      for (double x = 0; x <= w; x += 2) {
        final nx = x / w;

        final ampBase = 18.0 * (1.0 - (dist / (mid + 0.0001)) * 0.35);
        final amp = ampBase * envelope;

        final y = baseY - (math.sin(nx * freq + localPhase) * amp).abs();

        path.lineTo(x, y);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_TopStrandsWavePainter oldDelegate) =>
      oldDelegate.t != t || oldDelegate.strands != strands;
}

class _UnifiedLangBar extends StatelessWidget {
  final double height;
  final bool isListening;
  final _SpeakLang speakLang;
  final VoidCallback onSelectTR;
  final VoidCallback onSelectEN;
  final VoidCallback onMicTap;

  const _UnifiedLangBar({
    required this.height,
    required this.isListening,
    required this.speakLang,
    required this.onSelectTR,
    required this.onSelectEN,
    required this.onMicTap,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF0A70FF);
    const dark = Color(0xFF0F172A);

    final isTrActive = isListening && speakLang == _SpeakLang.tr;
    final isEnActive = isListening && speakLang == _SpeakLang.en;

    final r = 16.r;

    final double micSize = 84.w;
    final double micSlotW = 96.w;

    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;

          final double micLeft = (w - micSize) / 2;
          final double micCenter = w / 2;

          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(r),
                  child: Container(color: Colors.white),
                ),
              ),
              if (isTrActive)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  width: micCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: Container(color: blue),
                  ),
                ),
              if (isEnActive)
                Positioned(
                  left: micCenter,
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(r),
                    child: Container(color: blue),
                  ),
                ),
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: onSelectTR,
                        child: Center(
                          child: Text(
                            "Turkish",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isTrActive ? Colors.white : dark,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: micSlotW),
                    Expanded(
                      child: InkWell(
                        onTap: onSelectEN,
                        child: Center(
                          child: Text(
                            "English",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: isEnActive ? Colors.white : dark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: micLeft,
                child: InkWell(
                  onTap: onMicTap,
                  borderRadius: BorderRadius.circular(999),
                  child: Container(
                    width: micSize,
                    height: micSize,
                    decoration: BoxDecoration(
                      color: isListening ? blue : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1F0B2B6B),
                          blurRadius: 18,
                          offset: Offset(0, 10),
                        )
                      ],
                    ),
                    child: Center(
                      child: isListening
                          ? Icon(
                              Icons.stop_rounded,
                              size: 34.sp,
                              color: Colors.white,
                            )
                          : SvgPicture.asset(
                              AppAssets.icMicrophone,
                              width: 30.w,
                              height: 30.w,
                              colorFilter: const ColorFilter.mode(
                                dark,
                                BlendMode.srcIn,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
