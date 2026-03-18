import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

import '../../Core/Utils/assets.dart';
import '../../Models/notification_model.dart';

class NotificationsInboxController extends StateNotifier<List<NotifItem>> {
  NotificationsInboxController() : super(const []);

  List<NotifItem> _buildLocalizedItems(AppLocalizations l10n) {
    return [
      NotifItem(
        id: 't1',
        section: NotifSection.today,
        iconBg: const Color(0xFFE7F0FF),
        iconAsset: AppAssets.icStatus,
        iconColor: const Color(0xFF0A70FF),
        title: l10n.notificationNewTranslationReadyTitle,
        body: l10n.notificationNewTranslationReadyBody,
        time: l10n.notificationTime10MinAgo,
        unread: true,
      ),
      NotifItem(
        id: 't2',
        section: NotifSection.today,
        iconBg: const Color(0xFFFFE9D6),
        iconAsset: AppAssets.icTicket,
        iconColor: const Color(0xFFFF8A00),
        title: l10n.notificationSpecialOfferTitle,
        body: l10n.notificationSpecialOfferBody,
        time: l10n.notificationTime2hAgo,
        unread: true,
        action: l10n.notificationSeeOpportunity,
      ),
      NotifItem(
        id: 'y1',
        section: NotifSection.yesterday,
        iconBg: const Color(0xFFE7F7EF),
        iconAsset: AppAssets.icRobot,
        iconColor: const Color(0xFF10B981),
        title: l10n.notificationAiChatTitle,
        body: l10n.notificationAiChatBody,
        time: '2:20 PM',
        unread: false,
      ),
    ];
  }

  void syncWithL10n(AppLocalizations l10n) {
    final currentDynamicItems = state
        .where((e) => e.id != 't1' && e.id != 't2' && e.id != 'y1')
        .toList();

    state = [
      ..._buildLocalizedItems(l10n),
      ...currentDynamicItems,
    ];
  }

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
