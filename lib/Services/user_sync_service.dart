import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class UserSyncService {
  static const String baseUrl = "http://89.117.238.164:4000";

  static Future<Map<String, dynamic>?> syncCurrentUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    String provider = "unknown";
    if (user.providerData.isNotEmpty) {
      provider = user.providerData.first.providerId;
    }

    final response = await http.post(
      Uri.parse("$baseUrl/users/sync"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firebase_uid": user.uid,
        "email": user.email,
        "name": user.displayName,
        "photo_url": user.photoURL,
        "provider": provider,
      }),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return data["user"] as Map<String, dynamic>?;
    }

    return null;
  }
}
