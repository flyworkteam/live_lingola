import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lingora_app/Core/Utils/assets.dart';
import 'package:lingora_app/Core/widgets/navigation/bottom_nav_item_tile.dart';

enum _FreeStage { idle, listening, result }

class VoiceTranslateFreeLiveView extends StatefulWidget {
  const VoiceTranslateFreeLiveView({super.key});

  @override
  State<VoiceTranslateFreeLiveView> createState() =>
      _VoiceTranslateFreeLiveViewState();
}

class _VoiceTranslateFreeLiveViewState extends State<VoiceTranslateFreeLiveView>
    with SingleTickerProviderStateMixin {
  _FreeStage _stage = _FreeStage.idle;

  late final AnimationController _waveCtrl;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  void _toggle() {
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: SizedBox(
                  height: 44.h,
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(999),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          color: Colors.transparent,
                          child: Center(
                            child: SvgPicture.asset(
                              AppAssets.icBack,
                              width: 24.w,
                              height: 24.w,
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
                      SizedBox(width: 24.w),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 51.h),
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
              SizedBox(
                height: 140.h,
                child: _stage == _FreeStage.listening
                    ? AnimatedBuilder(
                        animation: _waveCtrl,
                        builder: (_, __) => CustomPaint(
                          size: Size(double.infinity, 140.h),
                          painter: _WavePainter(t: _waveCtrl.value),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
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
                          "Merhaba, nasılsın?",
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
                          "Hello, how are you?",
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
                      Container(
                        height: 74.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Turkish",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 96.w,
                              child: Center(
                                child: InkWell(
                                  onTap: _toggle,
                                  borderRadius: BorderRadius.circular(999),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 84.w,
                                    height: 84.w,
                                    decoration: BoxDecoration(
                                      color: _stage == _FreeStage.listening
                                          ? const Color(0xFF0A70FF)
                                          : Colors.white,
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
                                      child: _stage == _FreeStage.listening
                                          ? Icon(
                                              Icons.stop_rounded,
                                              size: 34.sp,
                                              color: Colors.white,
                                            )
                                          : SvgPicture.asset(
                                              AppAssets.icMicrophone,
                                              width: 30.w,
                                              height: 30.w,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                Color(0xFF0F172A),
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "English",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        _stage == _FreeStage.listening
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

class _WavePainter extends CustomPainter {
  final double t;

  _WavePainter({required this.t});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF0A70FF).withOpacity(0.18)
      ..style = PaintingStyle.fill;

    final path = Path();
    const double waveHeight = 24.0;
    final double waveLength = size.width;
    final double baseHeight = size.height / 2;

    path.moveTo(0, baseHeight);

    for (double x = 0; x <= waveLength; x++) {
      final y = baseHeight +
          math.sin((x / waveLength * 2 * math.pi) + (t * 2 * math.pi)) *
              waveHeight;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => oldDelegate.t != t;
}
