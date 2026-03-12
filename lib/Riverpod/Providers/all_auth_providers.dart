import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Models/Auth/auth_state.dart';
import '../../Repositories/auth_repository.dart';
import '../../Services/Auth/auth_api_service.dart';
import '../../Services/Auth/firebase_auth_service.dart';
import '../../Services/Auth/local_auth_storage_service.dart';
import '../Controllers/AuthController/auth_controller.dart';

final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService();
});

final localAuthStorageServiceProvider =
    Provider<LocalAuthStorageService>((ref) {
  return LocalAuthStorageService();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    firebaseAuthService: ref.read(firebaseAuthServiceProvider),
    authApiService: ref.read(authApiServiceProvider),
    localAuthStorageService: ref.read(localAuthStorageServiceProvider),
  );
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});
