import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const String _appId = 'BURAYA_ONESIGNAL_APP_ID';

  static Future<void> init() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(_appId);

    // Bildirim açılınca yakala
    OneSignal.Notifications.addClickListener((event) {
      final data = event.notification.additionalData;
      final target = data?['target'];
      final translationId = data?['translation_id'];

      // Burada istersen route yönlendirme yaparsın.
      // Örn: history detail, premium screen, campaign popup vs.
      debugPrint(
        'ONESIGNAL CLICK target=$target translationId=$translationId',
      );
    });

    // iOS'ta izin sor, Android 13+ için de gerekli olabilir
    final accepted = await OneSignal.Notifications.requestPermission(true);
    debugPrint('ONESIGNAL PERMISSION: $accepted');

    // Push subscription değişimini izle
    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint('ONESIGNAL PUSH ID: ${state.current.id}');
      debugPrint('ONESIGNAL PUSH TOKEN: ${state.current.token}');
      debugPrint('ONESIGNAL OPTED IN: ${state.current.optedIn}');
    });
  }

  static Future<void> loginUser({
    required String firebaseUid,
    String? email,
    String? name,
  }) async {
    // Kullanıcıyı OneSignal tarafında tekilleştirir
    await OneSignal.login(firebaseUid);

    final tags = <String, String>{
      'firebase_uid': firebaseUid,
      'platform': Platform.isIOS ? 'ios' : 'android',
      'app': 'lingola',
    };

    if (email != null && email.trim().isNotEmpty) {
      tags['email'] = email.trim();
    }

    if (name != null && name.trim().isNotEmpty) {
      tags['name'] = name.trim();
    }

    await OneSignal.User.addTags(tags);
  }

  static Future<void> logoutUser() async {
    await OneSignal.logout();
  }

  static Future<void> setLanguageTags({
    required String sourceLanguageCode,
    required String targetLanguageCode,
  }) async {
    await OneSignal.User.addTags({
      'source_lang': sourceLanguageCode,
      'target_lang': targetLanguageCode,
    });
  }

  static Future<void> setPremium(bool isPremium) async {
    await OneSignal.User.addTags({
      'is_premium': isPremium ? 'true' : 'false',
    });
  }
}
