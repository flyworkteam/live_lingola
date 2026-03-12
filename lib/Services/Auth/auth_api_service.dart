import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../Core/config/app_config.dart';
import '../../Models/Auth/app_user_model.dart';

class AuthApiService {
  static const Duration _timeout = Duration(seconds: 15);

  Future<AppUserModel> fetchMe(String idToken) async {
    final uri = Uri.parse('${AppConfig.baseUrl}/auth/me');

    try {
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
      ).timeout(_timeout);

      if (response.statusCode != 200) {
        String message = 'Backend auth/me failed: ${response.statusCode}';

        try {
          final decoded = jsonDecode(response.body) as Map<String, dynamic>;
          final serverMessage = decoded['message'] ?? decoded['error'];
          if (serverMessage is String && serverMessage.isNotEmpty) {
            message = '$message - $serverMessage';
          }
        } catch (_) {}

        throw Exception(message);
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final ok = decoded['ok'] == true;
      final userJson = decoded['user'];

      if (!ok || userJson is! Map<String, dynamic>) {
        throw Exception('Invalid backend response');
      }

      return AppUserModel.fromJson(userJson);
    } on TimeoutException {
      throw Exception('Request timeout');
    } on SocketException {
      throw Exception('SocketException');
    } on FormatException {
      throw Exception('Invalid response format');
    }
  }
}
