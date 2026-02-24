import 'package:flutter/material.dart';

class DashedCircle extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern; // [dash, gap]

  const DashedCircle({
    super.key,
    required this.size,
    this.strokeWidth = 2,
    this.color = const Color(0xFFDFE4F0),
    this.dashPattern = const [4, 4],
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _DashedCirclePainter(
        strokeWidth: strokeWidth,
        color: color,
        dashPattern: dashPattern,
      ),
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;

  _DashedCirclePainter({
    required this.strokeWidth,
    required this.color,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = color;

    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final dash = dashPattern[0];
    final gap = dashPattern[1];
    final circumference = 2 * 3.141592653589793 * radius;
    final dashCount = (circumference / (dash + gap)).floor();

    final sweepPerDash = (dash / circumference) * 2 * 3.141592653589793;
    final step = ((dash + gap) / circumference) * 2 * 3.141592653589793;

    for (int i = 0; i < dashCount; i++) {
      final start = i * step;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweepPerDash,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCirclePainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.color != color ||
        oldDelegate.dashPattern != dashPattern;
  }
}
