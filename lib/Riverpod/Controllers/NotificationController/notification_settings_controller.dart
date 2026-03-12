import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingola_app/Models/notification_settings_model.dart';

class NotificationSettingsController
    extends StateNotifier<NotificationSettingsModel> {
  NotificationSettingsController() : super(NotificationSettingsModel.initial());

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }
}

final notificationSettingsControllerProvider = StateNotifierProvider<
    NotificationSettingsController, NotificationSettingsModel>((ref) {
  return NotificationSettingsController();
});
