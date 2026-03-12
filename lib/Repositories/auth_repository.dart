import 'package:flutter/foundation.dart';

import '../Models/Auth/app_user_model.dart';
import '../Services/Auth/auth_api_service.dart';
import '../Services/Auth/firebase_auth_service.dart';
import '../Services/Auth/local_auth_storage_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final AuthApiService _authApiService;
  final LocalAuthStorageService _localAuthStorageService;

  AuthRepository({
    required FirebaseAuthService firebaseAuthService,
    required AuthApiService authApiService,
    required LocalAuthStorageService localAuthStorageService,
  })  : _firebaseAuthService = firebaseAuthService,
        _authApiService = authApiService,
        _localAuthStorageService = localAuthStorageService;

  Future<AppUserModel> signInWithGoogle() async {
    try {
      debugPrint('AUTH REPOSITORY: Google -> Firebase sign-in start');

      final idToken =
          await _firebaseAuthService.signInWithGoogleAndGetIdToken();

      debugPrint('AUTH REPOSITORY: Google -> idToken received');

      final user = await _authApiService.fetchMe(idToken);

      debugPrint('AUTH REPOSITORY: Google -> backend fetchMe success');

      await _localAuthStorageService.saveUser(user, provider: 'google');

      debugPrint('AUTH REPOSITORY: Google -> user saved locally');

      return user;
    } catch (e, st) {
      debugPrint('AUTH REPOSITORY GOOGLE ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<AppUserModel> signInWithFacebook() async {
    try {
      debugPrint('AUTH REPOSITORY: Facebook -> Firebase sign-in start');

      final idToken =
          await _firebaseAuthService.signInWithFacebookAndGetIdToken();

      debugPrint('AUTH REPOSITORY: Facebook -> idToken received');

      final user = await _authApiService.fetchMe(idToken);

      debugPrint('AUTH REPOSITORY: Facebook -> backend fetchMe success');

      await _localAuthStorageService.saveUser(user, provider: 'facebook');

      debugPrint('AUTH REPOSITORY: Facebook -> user saved locally');

      return user;
    } catch (e, st) {
      debugPrint('AUTH REPOSITORY FACEBOOK ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<AppUserModel> signInWithApple() async {
    try {
      debugPrint('AUTH REPOSITORY: Apple -> Firebase sign-in start');

      final idToken = await _firebaseAuthService.signInWithAppleAndGetIdToken();

      debugPrint('AUTH REPOSITORY: Apple -> idToken received');

      final user = await _authApiService.fetchMe(idToken);

      debugPrint('AUTH REPOSITORY: Apple -> backend fetchMe success');

      await _localAuthStorageService.saveUser(user, provider: 'apple');

      debugPrint('AUTH REPOSITORY: Apple -> user saved locally');

      return user;
    } catch (e, st) {
      debugPrint('AUTH REPOSITORY APPLE ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('AUTH REPOSITORY: signOut start');

      await _firebaseAuthService.signOut();
      await _localAuthStorageService.clear();

      debugPrint('AUTH REPOSITORY: signOut success');
    } catch (e, st) {
      debugPrint('AUTH REPOSITORY SIGNOUT ERROR: $e');
      debugPrintStack(stackTrace: st);
      rethrow;
    }
  }

  Future<AppUserModel?> getSavedUser() {
    return _localAuthStorageService.getUser();
  }

  Future<bool> hasSession() {
    return _localAuthStorageService.isLoggedIn();
  }
}
