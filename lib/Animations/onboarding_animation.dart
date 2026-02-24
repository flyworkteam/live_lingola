import 'dart:math' as math;
import 'package:flutter/material.dart';

class OnboardingAnimationHelper {
  final double page;

  OnboardingAnimationHelper(this.page);

  // Animasyon ilerlemesini normalize eder ve yumuşatır (Easing)
  double get t => page.clamp(0.0, 1.0);
  double get ease => Curves.easeInOutCubic.transform(t);

  // Değerler arası geçiş hesaplaması (Interpolation)
  double lerp(double a, double b) => a + (b - a) * ease;

  // Dairesel hareket açısını hesaplar
  double orbitAngle(double startDeg, double sweepDeg) {
    return (startDeg + (sweepDeg * ease)) * math.pi / 180;
  }

  // Tur bazlı dönüş miktarını radyana çevirir
  double selfRotation(double turns) {
    return (turns * 2 * math.pi) * ease;
  }
}
