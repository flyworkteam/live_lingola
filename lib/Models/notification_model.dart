import 'package:flutter/material.dart';

enum NotifSection { today, yesterday }

class NotifItem {
  final String id;
  final NotifSection section;

  final Color iconBg;

  final String iconAsset;
  final Color? iconColor;

  final String title;
  final String body;
  final String time;
  final bool unread;
  final String? action;

  const NotifItem({
    required this.id,
    required this.section,
    required this.iconBg,
    required this.iconAsset,
    this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
    this.action,
  });
}
