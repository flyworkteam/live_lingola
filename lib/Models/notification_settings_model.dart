class NotificationSettingsModel {
  final bool notificationsEnabled;

  const NotificationSettingsModel({
    required this.notificationsEnabled,
  });

  factory NotificationSettingsModel.initial() {
    return const NotificationSettingsModel(
      notificationsEnabled: true,
    );
  }

  NotificationSettingsModel copyWith({
    bool? notificationsEnabled,
  }) {
    return NotificationSettingsModel(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
