import 'package:flutter/material.dart';
import 'package:lingola_app/Services/ai_consent_service.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

Future<bool> showAiConsentDialog(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;

  return await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            title: Text(l10n.aiConsentTitle),
            content: SingleChildScrollView(
              child: Text(l10n.aiConsentBody),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  await AiConsentService.setConsent(false);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, false);
                  }
                },
                child: Text(l10n.aiConsentDecline),
              ),
              ElevatedButton(
                onPressed: () async {
                  await AiConsentService.setConsent(true);
                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext, true);
                  }
                },
                child: Text(l10n.aiConsentAccept),
              ),
            ],
          );
        },
      ) ??
      false;
}
