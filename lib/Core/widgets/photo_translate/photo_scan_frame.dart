import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef TranslatedOverlayBuilder = Widget Function(BuildContext context);

class PhotoScanFrame extends StatefulWidget {
  final ImageProvider imageProvider;
  final TranslatedOverlayBuilder translatedOverlayBuilder;

  const PhotoScanFrame({
    super.key,
    required this.imageProvider,
    required this.translatedOverlayBuilder,
  });

  @override
  State<PhotoScanFrame> createState() => _PhotoScanFrameState();
}

class _PhotoScanFrameState extends State<PhotoScanFrame> {
  double _x = 0.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final h = 360.h;
        final lineX = (_x.clamp(0.0, 1.0)) * w;

        return Container(
          width: w,
          height: h,
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
          padding: EdgeInsets.all(14.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18.r),
            child: Stack(
              children: [
                // 1) Alt katman: “Translated”
                Positioned.fill(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        image: widget.imageProvider,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.white,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            size: 40.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.10),
                        ),
                      ),
                      Positioned.fill(
                          child: widget.translatedOverlayBuilder(context)),
                    ],
                  ),
                ),

                // 2) Üst katman: Original
                Positioned.fill(
                  child: ClipRect(
                    clipper: _LeftClipper(dx: lineX),
                    child: Image(
                      image: widget.imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // 3) Köşe frame
                Positioned.fill(child: _CornerFrame()),

                // 4) Kırmızı tarama çizgisi (drag)
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragStart: (d) {
                      final local = (context.findRenderObject() as RenderBox)
                          .globalToLocal(d.globalPosition);
                      setState(() => _x = (local.dx / w).clamp(0.0, 1.0));
                    },
                    onHorizontalDragUpdate: (d) {
                      final local = (context.findRenderObject() as RenderBox)
                          .globalToLocal(d.globalPosition);
                      setState(() => _x = (local.dx / w).clamp(0.0, 1.0));
                    },
                    child: CustomPaint(
                      painter: _ScanLinePainter(dx: lineX),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
    final p = Paint()
      ..color = const Color(0xFFFF2D2D)
      ..strokeWidth = 2;

    canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), p);
  }

  @override
  bool shouldRepaint(covariant _ScanLinePainter oldDelegate) =>
      oldDelegate.dx != dx;
}

class _CornerFrame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: CustomPaint(
          painter: _CornerPainter(),
        ),
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
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    const len = 26.0;

    // TL
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), p);
    canvas.drawLine(const Offset(0, 0), const Offset(0, len), p);

    // TR
    canvas.drawLine(Offset(size.width, 0), Offset(size.width - len, 0), p);
    canvas.drawLine(Offset(size.width, 0), Offset(size.width, len), p);

    // BL
    canvas.drawLine(Offset(0, size.height), Offset(len, size.height), p);
    canvas.drawLine(Offset(0, size.height), Offset(0, size.height - len), p);

    // BR
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - len, size.height), p);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - len), p);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) => false;
}
