import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lingola_app/Models/notification_settings_model.dart';

final notificationSettingsProvider =
    StateProvider<NotificationSettingsModel>((ref) {
  return NotificationSettingsModel.initial();
});
