import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../Riverpod/Providers/current_user_provider.dart';
import '../../Services/subscription_service.dart';

class PaywallView {
  const PaywallView._();

  static Future<void> open(BuildContext context, WidgetRef ref) async {
    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded("pro");

      if (result == PaywallResult.purchased ||
          result == PaywallResult.restored) {
        final user = ref.read(currentUserProvider);
        final userId = user?['id'];

        if (userId != null) {
          await SubscriptionService.activatePro(userId as int);
        }
      }
    } catch (e) {
      debugPrint("REVENUECAT PAYWALL ERROR: $e");
    }
  }
}
