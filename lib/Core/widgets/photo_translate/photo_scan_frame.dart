import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

class PhotoTranslatedBlock {
  final double x;
  final double y;
  final double width;
  final double height;
  final String translatedText;

  const PhotoTranslatedBlock({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.translatedText,
  });

  factory PhotoTranslatedBlock.fromJson(Map<String, dynamic> json) {
    double toDouble(dynamic v) {
      if (v is num) return v.toDouble();
      return double.tryParse('$v') ?? 0;
    }

    return PhotoTranslatedBlock(
      x: toDouble(json['x']),
      y: toDouble(json['y']),
      width: toDouble(json['width']),
      height: toDouble(json['height']),
      translatedText: (json['translated_text'] ?? '').toString(),
    );
  }
}

class PhotoScanFrame extends StatefulWidget {
  final ImageProvider? originalImage;
  final ImageProvider? translatedImage;
  final bool isProcessing;
  final List<PhotoTranslatedBlock> translatedBlocks;

  const PhotoScanFrame({
    super.key,
    required this.originalImage,
    this.translatedImage,
    this.isProcessing = false,
    this.translatedBlocks = const [],
  });

  @override
  State<PhotoScanFrame> createState() => _PhotoScanFrameState();
}

class _PhotoScanFrameState extends State<PhotoScanFrame> {
  double _x = 0.5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final double frameWidth = 254.w;
    final double frameHeight = 340.h;
    final double innerWidth = frameWidth - 24.w;

    final bool hasImage = widget.originalImage != null;
    final bool hasRenderedTranslatedImage = widget.translatedImage != null;

    return Container(
      width: frameWidth,
      height: frameHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0B2B6B),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      padding: EdgeInsets.all(12.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          children: [
            if (hasImage) ...[
              Positioned.fill(
                child: Image(
                  image: widget.originalImage!,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned.fill(
                child: ClipRect(
                  clipper: _LeftClipper(dx: _x * innerWidth),
                  child: hasRenderedTranslatedImage
                      ? Image(
                          image: widget.translatedImage!,
                          fit: BoxFit.cover,
                        )
                      : Stack(
                          children: [
                            Positioned.fill(
                              child: Image(
                                image: widget.originalImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned.fill(
                              child: _TranslatedOverlay(
                                blocks: widget.translatedBlocks,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const Positioned.fill(child: _CornerFrame()),
              Positioned(
                top: 10.h,
                left: 10.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    l10n.translated,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    l10n.original,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      _x = (details.localPosition.dx / innerWidth)
                          .clamp(0.0, 1.0);
                    });
                  },
                  child: CustomPaint(
                    painter: _ScanLinePainter(dx: _x * innerWidth),
                  ),
                ),
              ),
            ] else
              Container(
                color: const Color(0xFFF6F8FC),
                alignment: Alignment.center,
                child: Text(
                  l10n.selectOrCapturePhoto,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            if (widget.isProcessing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.18),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            l10n.processing,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
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

class _TranslatedOverlay extends StatelessWidget {
  final List<PhotoTranslatedBlock> blocks;

  const _TranslatedOverlay({
    required this.blocks,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: blocks.map((block) {
            return Positioned(
              left: block.x * constraints.maxWidth,
              top: block.y * constraints.maxHeight,
              width: block.width * constraints.maxWidth,
              height: block.height * constraints.maxHeight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    block.translatedText,
                    maxLines: 2,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _LeftClipper extends CustomClipper<Rect> {
  final double dx;
  _LeftClipper({required this.dx});

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, dx, size.height);

  @override
  bool shouldReclip(covariant _LeftClipper oldClipper) => oldClipper.dx != dx;
}

class _ScanLinePainter extends CustomPainter {
  final double dx;
  _ScanLinePainter({required this.dx});

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFFF2D2D)
      ..strokeWidth = 2.w;

    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), linePaint);

    final knobPaint = Paint()..color = const Color(0xFFFF2D2D);

    canvas.drawCircle(Offset(dx, size.height / 2), 10.w, knobPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(dx, size.height / 2), 4.w, innerPaint);
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) =>
      oldDelegate.dx != dx;
}

class _CornerFrame extends StatelessWidget {
  const _CornerFrame();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: CustomPaint(painter: _CornerPainter()),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.white.withValues(alpha: 0.90)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5.w
      ..strokeCap = StrokeCap.round;

    const len = 20.0;

    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), p);
    canvas.drawLine(const Offset(0, 0), const Offset(0, len), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - len, 0), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), p);
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), p);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - len), p);
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width - len, size.height),
      p,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width, size.height - len),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}
