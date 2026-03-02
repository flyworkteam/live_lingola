import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ProStage { empty, listening, result }

class VoiceProBackgroundPainter extends CustomPainter {
  final double t;
  final ProStage stage;

  VoiceProBackgroundPainter({required this.t, required this.stage});

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;

    const double angle = 191.41 * (math.pi / 180);
    final Alignment begin = Alignment(
      math.cos(angle - math.pi / 2),
      math.sin(angle - math.pi / 2),
    );
    final Alignment end = Alignment(
      math.cos(angle + math.pi / 2),
      math.sin(angle + math.pi / 2),
    );

    final gradient = LinearGradient(
      begin: begin,
      end: end,
      colors: [
        const Color(0xFF0A70FF),
        const Color(0xFF03B7FF),
        const Color(0xFFEFF2F9).withOpacity(0.72),
        const Color(0xFFEFF2F9).withOpacity(0.0),
      ],
      stops: const [0.0043, 0.2741, 0.575, 0.9957],
    );

    final whitePaint = Paint()..shader = gradient.createShader(rect);

    final baseTop = size.height * 0.62;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, baseTop);

    if (stage == ProStage.empty) {
      path.quadraticBezierTo(
        size.width * 0.5,
        baseTop - 220,
        size.width,
        baseTop,
      );
    } else {
      path.quadraticBezierTo(
        size.width * 0.5,
        baseTop - 140,
        size.width,
        baseTop,
      );
    }

    path
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, whitePaint);

    if (stage != ProStage.empty) {
      final wavePaint = Paint()
        ..color = const Color(0xFF0A70FF).withOpacity(0.75)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0;

      final midY = baseTop + 95;
      for (int k = 0; k < 10; k++) {
        final amp = 10 + k * 4.2;
        final p = Path();
        for (double x = 0; x <= size.width; x += 2) {
          final nx = x / size.width;
          final envelope = math.sin(nx * math.pi);
          final y = midY -
              envelope *
                  amp *
                  math.sin((nx * 5.6 * math.pi) + (t * 2 * math.pi) + k * 0.2);

          if (x == 0) {
            p.moveTo(x, y);
          } else {
            p.lineTo(x, y);
          }
        }
        canvas.drawPath(p, wavePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant VoiceProBackgroundPainter oldDelegate) {
    return oldDelegate.t != t || oldDelegate.stage != stage;
  }
}
