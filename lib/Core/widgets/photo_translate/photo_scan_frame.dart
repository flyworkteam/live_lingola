import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PhotoScanFrame extends StatefulWidget {
  final ImageProvider originalImage;
  final ImageProvider translatedImage;

  const PhotoScanFrame({
    super.key,
    required this.originalImage,
    required this.translatedImage,
  });

  @override
  State<PhotoScanFrame> createState() => _PhotoScanFrameState();
}

class _PhotoScanFrameState extends State<PhotoScanFrame> {
  double _x = 0.5;

  @override
  Widget build(BuildContext context) {
    final double frameWidth = 254.w;
    final double frameHeight = 340.h;

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
            Positioned.fill(
              child: Image(
                image: widget.translatedImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: ClipRect(
                clipper: _LeftClipper(dx: _x * (frameWidth - 24.w)),
                child: Image(
                  image: widget.originalImage,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Positioned.fill(child: _CornerFrame()),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _x = (details.localPosition.dx / (frameWidth - 24.w))
                        .clamp(0.0, 1.0);
                  });
                },
                child: CustomPaint(
                  painter: _ScanLinePainter(dx: _x * (frameWidth - 24.w)),
                ),
              ),
            ),
          ],
        ),
      ),
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
    final p = Paint()
      ..color = const Color(0xFFFF2D2D)
      ..strokeWidth = 2.w;

    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), p);
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
      ..color = Colors.white.withOpacity(0.90)
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
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - len, size.height), p);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - len), p);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}
