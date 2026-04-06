import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lingola_app/Services/ai_consent_service.dart';
import 'package:lingola_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

const String _privacyPolicyUrl =
    'https://fly-work.com/livelingola/privacy-policy/';

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.aiConsentBody),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      text: l10n.aiConsentLearnMore,
                      style: const TextStyle(
                        color: Color(0xFF1677FF),
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(
                            Uri.parse(_privacyPolicyUrl),
                            mode: LaunchMode.externalApplication,
                          );
                        },
                    ),
                  ),
                ],
              ),
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
