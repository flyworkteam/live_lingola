import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lingola_app/Core/Utils/assets.dart';

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

List<QuickActionData> quickActions(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;

  return [
    QuickActionData(
      title: l10n.aiChat,
      iconAsset: AppAssets.icAiChat,
      tileColor: const Color(0xFFE7F0FF),
    ),
    QuickActionData(
      title: l10n.travel,
      iconAsset: AppAssets.icTravel,
      tileColor: const Color(0xFFE7F7EF),
    ),
    QuickActionData(
      title: l10n.textCheck,
      iconAsset: AppAssets.icTextCheck,
      tileColor: const Color(0xFFFFE9D6),
    ),
    QuickActionData(
      title: l10n.interview,
      iconAsset: AppAssets.icInterview,
      tileColor: const Color(0xFFF1E6FF),
    ),
    QuickActionData(
      title: l10n.email,
      iconAsset: AppAssets.icEmail,
      tileColor: const Color(0xFFFFE2E7),
    ),
    QuickActionData(
      title: l10n.business,
      iconAsset: AppAssets.icBusiness,
      tileColor: const Color(0xFFDFF7FF),
    ),
    QuickActionData(
      title: l10n.replyIdeas,
      iconAsset: AppAssets.icReply,
      tileColor: const Color(0xFFFFEACB),
    ),
    QuickActionData(
      title: l10n.popular,
      iconAsset: AppAssets.icPopular,
      tileColor: const Color(0xFFE2F1FF),
    ),
  ];
}
