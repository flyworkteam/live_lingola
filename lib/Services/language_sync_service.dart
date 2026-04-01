import 'dart:io';
import 'package:flutter/services.dart';

class LanguageSyncService {
  static const MethodChannel _channel =
      MethodChannel('com.livelingola.app/language');

  static Future<void> syncAppLanguageToIOS(String languageCode) async {
    if (!Platform.isIOS) return;

    await _channel.invokeMethod(
      'setAppLanguage',
      {'languageCode': languageCode},
    );
  }
}
