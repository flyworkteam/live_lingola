import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Core/Utils/assets.dart';
import '../../Models/notification_model.dart';

class NotificationsInboxController extends StateNotifier<List<NotifItem>> {
  NotificationsInboxController()
      : super([
          const NotifItem(
            id: 't1',
            section: NotifSection.today,
            iconBg: Color(0xFFE7F0FF),
            iconAsset: AppAssets.icStatus,
            iconColor: Color(0xFF0A70FF),
            title: 'New Translation Ready',
            body:
                'Your audio translation file has been successfully converted to text and translated.',
            time: '10 min. ago',
            unread: true,
          ),
          const NotifItem(
            id: 't2',
            section: NotifSection.today,
            iconBg: Color(0xFFFFE9D6),
            iconAsset: AppAssets.icTicket,
            iconColor: Color(0xFFFF8A00),
            title: 'A Special Offer Awaits You',
            body:
                'Upgrade to Premium for unlimited photo translations at 50% off.',
            time: '2h ago',
            unread: true,
            action: 'SEE THE OPPORTUNITY',
          ),
          const NotifItem(
            id: 'y1',
            section: NotifSection.yesterday,
            iconBg: Color(0xFFE7F7EF),
            iconAsset: AppAssets.icRobot,
            iconColor: Color(0xFF10B981),
            title: 'Ai Chat ile Sohbet et',
            body: 'Ai chat ile aklına takılan sorular anında yanıt bul.',
            time: '2:20 PM',
            unread: false,
          ),
        ]);

  void addNotification({
    required String title,
    required String body,
  }) {
    final item = NotifItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      section: NotifSection.today,
      iconBg: const Color(0xFFE7F0FF),
      iconAsset: AppAssets.icStatus,
      iconColor: const Color(0xFF0A70FF),
      title: title,
      body: body,
      time: 'Just now',
      unread: true,
    );

    state = [item, ...state];
  }

  void removeNotification(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final notificationsInboxProvider =
    StateNotifierProvider<NotificationsInboxController, List<NotifItem>>(
  (ref) => NotificationsInboxController(),
);
