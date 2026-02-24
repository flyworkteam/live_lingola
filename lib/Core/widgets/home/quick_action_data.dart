import 'package:flutter/material.dart';

class QuickActionData {
  final String title;
  final String iconAsset;
  final Color tileColor;

  const QuickActionData({
    required this.title,
    required this.iconAsset,
    required this.tileColor,
  });
}

const quickActions = <QuickActionData>[
  QuickActionData(
    title: "Ai Chat",
    iconAsset: "assets/images/icons/actions/ic_action_ai_chat.png",
    tileColor: Color(0xFFE7F0FF),
  ),
  QuickActionData(
    title: "Travel",
    iconAsset: "assets/images/icons/actions/ic_action_travel.png",
    tileColor: Color(0xFFE7F7EF),
  ),
  QuickActionData(
    title: "Text Check",
    iconAsset: "assets/images/icons/actions/ic_action_text_check.png",
    tileColor: Color(0xFFFFE9D6),
  ),
  QuickActionData(
    title: "Interview",
    iconAsset: "assets/images/icons/actions/ic_action_interview.png",
    tileColor: Color(0xFFF1E6FF),
  ),
  QuickActionData(
    title: "Email",
    iconAsset: "assets/images/icons/actions/ic_action_email.png",
    tileColor: Color(0xFFFFE2E7),
  ),
  QuickActionData(
    title: "Business",
    iconAsset: "assets/images/icons/actions/ic_action_business.png",
    tileColor: Color(0xFFDFF7FF),
  ),
  QuickActionData(
    title: "Reply Ideas",
    iconAsset: "assets/images/icons/actions/ic_action_replay.png",
    tileColor: Color(0xFFFFEACB),
  ),
  QuickActionData(
    title: "Popular",
    iconAsset: "assets/images/icons/actions/ic_action_popular.png",
    tileColor: Color(0xFFE2F1FF),
  ),
];
