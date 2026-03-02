import 'package:flutter/material.dart';
import 'package:rive/rive.dart' hide LinearGradient;

class VoiceListeningRiveWave extends StatelessWidget {
  final String riveAssetPath;
  final double height;
  final double opacity;

  final String? stateMachineName;

  final String? animationName;

  const VoiceListeningRiveWave({
    super.key,
    required this.riveAssetPath,
    required this.height,
    this.opacity = 0.80,
    this.stateMachineName,
    this.animationName,
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return IgnorePointer(
      ignoring: true,
      child: Opacity(
        opacity: opacity,
        child: ClipPath(
          clipper: _BottomOvalArcClipper(),
          child: SizedBox(
            width: w,
            height: height,
            child: Stack(
              children: [
                Positioned.fill(
                  child: RiveAnimation.asset(
                    riveAssetPath,
                    fit: BoxFit.cover,
                    stateMachines: stateMachineName != null
                        ? [stateMachineName!]
                        : const [],
                    animations:
                        animationName != null ? [animationName!] : const [],
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
          ),
        ),
      ),
    );
  }
}

class _BottomOvalArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final p = Path();

    p.moveTo(0, size.height);

    p.lineTo(0, size.height * 0.55);

    p.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.08,
      size.width,
      size.height * 0.55,
    );

    p.lineTo(size.width, size.height);

    p.close();

    return p;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
