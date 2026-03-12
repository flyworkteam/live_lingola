import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../Riverpod/Providers/notifications_inbox_provider.dart';

class NotificationService {
  static const String _appId = '8abda957-7534-4ef5-9e2e-c960d3080642';

  static Future<void> init(WidgetRef ref) async {
    try {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize(_appId);

      final granted = await OneSignal.Notifications.requestPermission(true);
      debugPrint('ONESIGNAL PERMISSION: $granted');

      OneSignal.Notifications.addForegroundWillDisplayListener((event) {
        final title = event.notification.title ?? 'Live Lingola';
        final body = event.notification.body ?? 'Yeni bir bildirimin var.';

        ref.read(notificationsInboxProvider.notifier).addNotification(
              title: title,
              body: body,
            );

        event.preventDefault();
        event.notification.display();
      });

      OneSignal.Notifications.addClickListener((event) {
        final title = event.notification.title ?? 'Live Lingola';
        final body = event.notification.body ?? 'Yeni bir bildirimin var.';

        ref.read(notificationsInboxProvider.notifier).addNotification(
              title: title,
              body: body,
            );
      });

      debugPrint('ONESIGNAL INIT OK');
    } catch (e) {
      debugPrint('ONESIGNAL INIT ERROR: $e');
    }
  }
}
