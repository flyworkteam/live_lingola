import 'dart:convert';
import 'package:http/http.dart' as http;

class SubscriptionService {
  static const String baseUrl = 'http://127.0.0.1:4000';

  static Future<bool> isPro(int userId) async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/subscription/status/$userId"),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 && body["ok"] == true) {
        return body["isPro"] == true;
      }

      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> activatePro(int userId) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/subscription/activate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      final body = jsonDecode(res.body);
      return res.statusCode == 200 && body["ok"] == true;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> deactivatePro(int userId) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/subscription/deactivate"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      final body = jsonDecode(res.body);
      return res.statusCode == 200 && body["ok"] == true;
    } catch (_) {
      return false;
    }
  }
}
