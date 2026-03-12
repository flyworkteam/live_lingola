import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Models/Auth/auth_state.dart';
import '../../../Models/Auth/app_user_model.dart';
import '../../../Repositories/auth_repository.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState());

  Future<void> signInWithGoogle() async {
    await _runAuthFlow(_repository.signInWithGoogle, provider: 'Google');
  }

  Future<void> signInWithFacebook() async {
    await _runAuthFlow(_repository.signInWithFacebook, provider: 'Facebook');
  }

  Future<void> signInWithApple() async {
    await _runAuthFlow(_repository.signInWithApple, provider: 'Apple');
  }

  Future<void> _runAuthFlow(
    Future<AppUserModel> Function() action, {
    required String provider,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      isLoading: true,
      isSuccess: false,
      clearError: true,
    );

    try {
      debugPrint('AUTH CONTROLLER: $provider sign-in started');

      final user = await action();

      debugPrint(
        'AUTH CONTROLLER: $provider sign-in success -> userId: ${user.id}',
      );

      state = state.copyWith(
        isLoading: false,
        user: user,
        isSuccess: true,
        clearError: true,
      );
    } catch (e, st) {
      debugPrint('AUTH CONTROLLER $provider ERROR: $e');
      debugPrintStack(stackTrace: st);

      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: _mapErrorMessage(e, provider: provider),
      );
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('AUTH CONTROLLER: signOut started');

      await _repository.signOut();

      debugPrint('AUTH CONTROLLER: signOut success');
      state = const AuthState();
    } catch (e, st) {
      debugPrint('AUTH CONTROLLER SIGNOUT ERROR: $e');
      debugPrintStack(stackTrace: st);

      state = state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: _mapErrorMessage(e, provider: 'SignOut'),
      );
    }
  }

  void clearStatus() {
    state = state.copyWith(
      isSuccess: false,
      clearError: true,
    );
  }

  String _mapErrorMessage(Object error, {required String provider}) {
    final raw = error.toString();
    final lower = raw.toLowerCase();

    debugPrint('AUTH CONTROLLER RAW ERROR [$provider]: $raw');

    if (lower.contains('cancelled') ||
        lower.contains('canceled') ||
        lower.contains('aborted_by_user') ||
        lower.contains('sign_in_canceled') ||
        lower.contains('user cancelled')) {
      return '$provider giriş işlemi iptal edildi.';
    }

    if (raw.contains('Google sign in cancelled')) {
      return 'Google giriş işlemi iptal edildi.';
    }

    if (raw.contains('Facebook sign in cancelled')) {
      return 'Facebook giriş işlemi iptal edildi.';
    }

    if (raw.contains('Apple sign in is not available')) {
      return 'Bu cihazda Apple girişi kullanılamıyor.';
    }

    if (raw.contains('Apple identity token is null')) {
      return 'Apple identity token alınamadı. Apple ayarlarını kontrol et.';
    }

    if (raw.contains('Apple authorization failed')) {
      return 'Apple yetkilendirmesi başarısız oldu.';
    }

    if (raw.contains('sign_in_with_apple')) {
      return 'Apple girişinde bir sorun oluştu.';
    }

    if (raw.contains('Backend auth/me failed')) {
      return 'Sunucuya bağlanırken bir sorun oluştu.';
    }

    if (raw.contains('SocketException')) {
      return 'Sunucuya ulaşılamadı. Backend bağlantısını kontrol et.';
    }

    if (raw.contains('invalid-credential')) {
      return 'Kimlik doğrulama bilgisi geçersiz. Firebase ayarlarını kontrol et.';
    }

    if (raw.contains('not-configured')) {
      return '$provider girişi henüz düzgün yapılandırılmamış.';
    }

    return '$provider giriş hatası: $raw';
  }
}
