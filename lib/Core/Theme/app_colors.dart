import 'package:flutter/material.dart';

class AppColors {
  // Temel arayüz renkleri
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);

  // Metin ve tipografi renkleri
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF475569);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // Marka ve vurgu renkleri
  static const primary = Color(0xFF0A70FF);
  static const secondary = Color(0xFF03B7FF);
  static const error = Color(0xFFEF4444);

  // Uygulama geneli ana gradyan tanımı
  static const primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0043, 0.2741, 0.575, 0.9957],
    colors: [
      primary,
      secondary,
      Color.fromRGBO(239, 242, 249, 0.721154),
      Color.fromRGBO(239, 242, 249, 0.0),
    ],
  );
}
