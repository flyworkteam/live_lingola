import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../Models/Auth/app_user_model.dart';

class AuthApiService {
  String get _baseUrl {
    if (Platform.isAndroid) return 'http://127.0.0.1:4000';
    return 'http://127.0.0.1:4000';
  }

  Future<AppUserModel> fetchMe(String idToken) async {
    final uri = Uri.parse('$_baseUrl/auth/me');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $idToken',
      },
    );

    if (kDebugMode) {
      debugPrint('AUTH ME STATUS: ${response.statusCode}');
    }

    if (response.statusCode != 200) {
      throw Exception('Backend auth/me failed: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final ok = decoded['ok'] == true;

    if (!ok || decoded['user'] == null) {
      throw Exception('Invalid backend response');
    }

    return AppUserModel.fromJson(decoded['user'] as Map<String, dynamic>);
  }
}
