import 'package:flutter/material.dart';
import 'package:lingora_app/Core/Utils/assets.dart';

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
    iconAsset: AppAssets.icAiChat,
    tileColor: Color(0xFFE7F0FF),
  ),
  QuickActionData(
    title: "Travel",
    iconAsset: AppAssets.icTravel,
    tileColor: Color(0xFFE7F7EF),
  ),
  QuickActionData(
    title: "Text Check",
    iconAsset: AppAssets.icTextCheck,
    tileColor: Color(0xFFFFE9D6),
  ),
  QuickActionData(
    title: "Interview",
    iconAsset: AppAssets.icInterview,
    tileColor: Color(0xFFF1E6FF),
  ),
  QuickActionData(
    title: "Email",
    iconAsset: AppAssets.icEmail,
    tileColor: Color(0xFFFFE2E7),
  ),
  QuickActionData(
    title: "Business",
    iconAsset: AppAssets.icBusiness,
    tileColor: Color(0xFFDFF7FF),
  ),
  QuickActionData(
    title: "Reply Ideas",
    iconAsset: AppAssets.icReply,
    tileColor: Color(0xFFFFEACB),
  ),
  QuickActionData(
    title: "Popular",
    iconAsset: AppAssets.icPopular,
    tileColor: Color(0xFFE2F1FF),
  ),
];
