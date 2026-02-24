import 'package:flutter_screenutil/flutter_screenutil.dart';

class UIMetrics {
  // Genel uygulama yerleşimi ve kenar boşlukları
  static double screenHPad = 18.w;

  // Üst bar (TopBar) bileşen ölçüleri
  static double topPad = 10.h;
  static double topIconBox = 40.w;
  static double topIconSize = 20.sp;
  static double topTitleSize = 20.sp;

  // Alt navigasyon (Bottom Navigation) yapılandırması
  static double navHeight = 62.h;
  static double navRadius = 18.r;
  static double navIconSize = 24.sp;
  static double navPadBottom = 12.h;
  static double navHPad = 18.w;

  // Ana sayfa spesifik boşluklar
  static double homeTopGap = 8.h;

  // Bildirim kartları ve ikon konteynerları
  static double notifCardRadius = 18.r;
  static double notifCardPadX = 14.w;
  static double notifCardPadY = 14.h;
  static double notifIconBox = 40.w;
  static double notifIconRadius = 10.r;
  static double notifIconSize = 20.sp;

  // Chat/Mesajlaşma arayüzü bileşenleri
  static double chatRobotBox = 34.w;
  static double chatRobotRadius = 10.r;
  static double chatRobotPad = 6.w;

  // Mesaj baloncukları (Chat Bubbles) yerleşimi
  static double bubbleRadius = 16.r;
  static double bubbleMaxWidth = 260.w;
  static double bubblePadX = 14.w;
  static double bubblePadY = 12.h;

  // Mesaj giriş alanı ve gönderim butonu ölçüleri
  static double inputHeight = 46.h;
  static double inputRadius = 16.r;
  static double sendBtnSize = 44.w;
  static double sendIconSize = 20.sp;

  // Standart tipografi ölçekleri
  static double t12 = 12.sp;
  static double t11 = 11.sp;
  static double t10 = 10.sp;
}
