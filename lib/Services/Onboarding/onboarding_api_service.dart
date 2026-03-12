import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Core/config/app_config.dart';
import '../../Riverpod/Controllers/OnboardingController/onboarding_controller.dart';
import '../Auth/firebase_auth_service.dart';

class OnboardingApiService {
  final http.Client _client;
  final FirebaseAuthService _firebaseAuthService;

  OnboardingApiService({
    http.Client? client,
    required FirebaseAuthService firebaseAuthService,
  })  : _client = client ?? http.Client(),
        _firebaseAuthService = firebaseAuthService;

  Future<void> savePreferences(OnboardingState state) async {
    final firebaseUser = _firebaseAuthService.currentUser;

    if (firebaseUser == null) {
      throw Exception('User is not logged in');
    }

    final idToken = await firebaseUser.getIdToken(true);

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Firebase ID token could not be created');
    }

    final uri = Uri.parse('${AppConfig.baseUrl}/auth/preferences');

    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'usagePurpose': state.usageKey,
        'fromLanguage': state.fromLangCode,
        'toLanguage': state.toLangCode,
        'usedAiBefore': state.usedAiBefore,
        'desiredFeature': state.featureKey,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Preferences save failed: ${response.body}');
    }
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    final firebaseUser = _firebaseAuthService.currentUser;

    if (firebaseUser == null) {
      throw Exception('User is not logged in');
    }

    final idToken = await firebaseUser.getIdToken(true);

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Firebase ID token could not be created');
    }

    final uri = Uri.parse('${AppConfig.baseUrl}/auth/me');

    final response = await _client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Preferences fetch failed: ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return data['user'] as Map<String, dynamic>?;
  }
}
