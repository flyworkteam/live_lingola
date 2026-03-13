import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

class RevenueCatService {
  static const String appleKey = "appl_GaUwpiXYrlXBoPTUOThRmVtJWMk";
  static const String androidKey = "goog_lnZYrGvBSTZyFbYDEugWVwDIGQm";

  static Future<void> init() async {
    final config = PurchasesConfiguration(
      Platform.isIOS ? appleKey : androidKey,
    );

    await Purchases.configure(config);
  }

  static Future<bool> isProEntitlementActive() async {
    try {
      final customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey("Live Lingola Pro");
    } catch (e) {
      debugPrint("REVENUECAT STATUS ERROR: $e");
      return false;
    }
  }

  static Future<bool> showPaywall() async {
    try {
      // Sadece kullanıcının "Live Lingola Pro" yetkisi YOKSA paywall ekranını açar.
      // Eğer zaten Pro ise ekranı hiç açmaz ve doğrudan true döner.
      final paywallResult =
          await RevenueCatUI.presentPaywallIfNeeded("Live Lingola Pro");

      debugPrint("Paywall Result: $paywallResult");

      // Kullanıcı satın alma işlemini yaptıktan veya ekranı kapattıktan sonra
      // son durumu tekrar kontrol edip sonucu (true/false) dönüyoruz.
      return await isProEntitlementActive();
    } catch (e) {
      debugPrint("REVENUECAT PAYWALL ERROR: $e");
      return false;
    }
  }
}
