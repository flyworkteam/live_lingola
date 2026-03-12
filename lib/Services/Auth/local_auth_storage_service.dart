import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../Models/Auth/app_user_model.dart';

class LocalAuthStorageService {
  static const _userKey = 'auth_user';
  static const _loginProviderKey = 'auth_login_provider';
  static const _isLoggedInKey = 'auth_is_logged_in';

  final FlutterSecureStorage _storage;

  LocalAuthStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveUser(
    AppUserModel user, {
    required String provider,
  }) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
    await _storage.write(key: _loginProviderKey, value: provider);
    await _storage.write(key: _isLoggedInKey, value: 'true');
  }

  Future<AppUserModel?> getUser() async {
    final raw = await _storage.read(key: _userKey);
    if (raw == null || raw.isEmpty) return null;

    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AppUserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  Future<String?> getLoginProvider() async {
    return _storage.read(key: _loginProviderKey);
  }

  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _isLoggedInKey);
    return value == 'true';
  }

  Future<void> clear() async {
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _loginProviderKey);
    await _storage.delete(key: _isLoggedInKey);
  }
}
