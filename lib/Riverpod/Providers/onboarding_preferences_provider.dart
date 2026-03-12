import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Repositories/onboarding_repository.dart';
import '../../Services/Onboarding/onboarding_api_service.dart';
import '../Controllers/OnboardingController/onboarding_controller.dart';
import 'all_auth_providers.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
  (ref) => OnboardingController(),
);

final onboardingApiServiceProvider = Provider<OnboardingApiService>((ref) {
  final firebaseAuthService = ref.read(firebaseAuthServiceProvider);
  return OnboardingApiService(firebaseAuthService: firebaseAuthService);
});

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  final apiService = ref.read(onboardingApiServiceProvider);
  return OnboardingRepository(apiService);
});
