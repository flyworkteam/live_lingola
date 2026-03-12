import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BackendAuthService {
  static const String baseUrl = "http://127.0.0.1:4000";

  static Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;
    return user.getIdToken(true);
  }

  static Future<Map<String, String>> authHeaders() async {
    final token = await _getIdToken();

    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<Map<String, dynamic>?> syncMe() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser == null) return null;

    final headers = await authHeaders();

    try {
      // 1) Önce auth/me ile session doğrulansın
      final authResponse = await http.get(
        Uri.parse("$baseUrl/auth/me"),
        headers: headers,
      );

      if (kDebugMode) {
        print("SYNC ME AUTH STATUS: ${authResponse.statusCode}");
      }
      if (kDebugMode) {
        print("SYNC ME AUTH BODY: ${authResponse.body}");
      }

      // 2) Sonra asıl güncel user profilini users/firebase üzerinden al
      final profileResponse = await http.get(
        Uri.parse("$baseUrl/users/firebase/${firebaseUser.uid}"),
        headers: {"Content-Type": "application/json"},
      );

      if (kDebugMode) {
        print("SYNC ME PROFILE STATUS: ${profileResponse.statusCode}");
      }
      if (kDebugMode) {
        print("SYNC ME PROFILE BODY: ${profileResponse.body}");
      }

      if (profileResponse.statusCode >= 200 &&
          profileResponse.statusCode < 300) {
        final profileData = jsonDecode(profileResponse.body);
        if (profileData is Map<String, dynamic>) {
          return profileData["user"] as Map<String, dynamic>?;
        }
      }

      // profile gelmezse auth/me fallback
      if (authResponse.statusCode >= 200 && authResponse.statusCode < 300) {
        final authData = jsonDecode(authResponse.body);
        if (authData is Map<String, dynamic>) {
          return authData["user"] as Map<String, dynamic>?;
        }
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print("SYNC ME ERROR: $e");
      }
      return null;
    }
  }

  static Future<Map<String, dynamic>?> savePreferences({
    required String? usagePurpose,
    required String? fromLanguage,
    required String? toLanguage,
    required bool? usedAiBefore,
    required String? desiredFeature,
  }) async {
    final headers = await authHeaders();

    final response = await http.post(
      Uri.parse("$baseUrl/auth/preferences"),
      headers: headers,
      body: jsonEncode({
        "usagePurpose": usagePurpose,
        "fromLanguage": fromLanguage,
        "toLanguage": toLanguage,
        "usedAiBefore": usedAiBefore,
        "desiredFeature": desiredFeature,
      }),
    );

    if (kDebugMode) {
      print("SAVE PREFERENCES STATUS: ${response.statusCode}");
    }
    if (kDebugMode) {
      print("SAVE PREFERENCES BODY: ${response.body}");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return data["user"] as Map<String, dynamic>?;
    }

    return null;
  }

  static Future<Map<String, dynamic>?> getProfileByFirebaseUid() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final response = await http.get(
      Uri.parse("$baseUrl/users/firebase/${user.uid}"),
      headers: {"Content-Type": "application/json"},
    );

    if (kDebugMode) {
      print("GET PROFILE STATUS: ${response.statusCode}");
    }
    if (kDebugMode) {
      print("GET PROFILE BODY: ${response.body}");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return data["user"] as Map<String, dynamic>?;
    }

    return null;
  }

  static Future<Map<String, dynamic>?> updateProfile({
    required String name,
    required int age,
    String? photoUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final response = await http.put(
      Uri.parse("$baseUrl/users/firebase/${user.uid}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "age": age,
        "photo_url": photoUrl,
      }),
    );

    if (kDebugMode) {
      print("UPDATE PROFILE STATUS: ${response.statusCode}");
    }
    if (kDebugMode) {
      print("UPDATE PROFILE BODY: ${response.body}");
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final data = jsonDecode(response.body);
      return data["user"] as Map<String, dynamic>?;
    }

    return null;
  }

  static Future<bool> deleteProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    final response = await http.delete(
      Uri.parse("$baseUrl/users/firebase/${user.uid}"),
      headers: {"Content-Type": "application/json"},
    );

    if (kDebugMode) {
      print("DELETE PROFILE STATUS: ${response.statusCode}");
    }
    if (kDebugMode) {
      print("DELETE PROFILE BODY: ${response.body}");
    }

    return response.statusCode >= 200 && response.statusCode < 300;
  }
}
