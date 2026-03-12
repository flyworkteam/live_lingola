import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_ui_flutter/purchases_ui_flutter.dart';

import '../../Core/Routes/app_routes.dart';
import '../../Riverpod/Providers/current_user_provider.dart';
import '../../Services/subscription_service.dart';

class PaywallView extends ConsumerStatefulWidget {
  const PaywallView({super.key});

  @override
  ConsumerState<PaywallView> createState() => _PaywallViewState();
}

class _PaywallViewState extends ConsumerState<PaywallView> {
  bool _started = false;
  bool _loadingFree = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_started) return;
    _started = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _openRevenueCatPaywall();
    });
  }

  Future<void> _goHomeAsFree() async {
    if (_loadingFree) return;

    setState(() {
      _loadingFree = true;
    });

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeAndNotifications,
      (route) => false,
    );
  }

  Future<void> _handleProActivated() async {
    final user = ref.read(currentUserProvider);
    final userId = user?['id'];

    if (userId != null) {
      await SubscriptionService.activatePro(userId as int);
    }

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.homeAndNotifications,
      (route) => false,
    );
  }

  Future<void> _openRevenueCatPaywall() async {
    try {
      final result = await RevenueCatUI.presentPaywallIfNeeded("pro");

      if (result == PaywallResult.purchased ||
          result == PaywallResult.restored) {
        await _handleProActivated();
        return;
      }

      await _goHomeAsFree();
    } catch (e) {
      debugPrint("REVENUECAT PAYWALL ERROR: $e");
      await _goHomeAsFree();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            const Center(
              child: CircularProgressIndicator(),
            ),
            Positioned(
              top: 8,
              right: 16,
              child: TextButton(
                onPressed: _goHomeAsFree,
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
