import 'package:shared_preferences/shared_preferences.dart';

class AiConsentService {
  static const String _consentKey = 'ai_consent_v1';

  static Future<void> setConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_consentKey, value);
  }

  static Future<bool?> getConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey);
  }

  static Future<bool> hasConsent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_consentKey) ?? false;
  }

  static Future<void> clearConsent() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_consentKey);
  }
}
