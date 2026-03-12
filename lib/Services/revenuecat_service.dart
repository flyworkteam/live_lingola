import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
      return customerInfo.entitlements.active.containsKey("pro");
    } catch (e) {
      debugPrint("REVENUECAT STATUS ERROR: $e");
      return false;
    }
  }
}
