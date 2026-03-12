import '../Riverpod/Controllers/OnboardingController/onboarding_controller.dart';
import '../Services/Onboarding/onboarding_api_service.dart';

class OnboardingRepository {
  final OnboardingApiService _apiService;

  OnboardingRepository(this._apiService);

  Future<void> savePreferences(OnboardingState state) async {
    await _apiService.savePreferences(state);
  }

  Future<Map<String, dynamic>?> getPreferences() async {
    return await _apiService.getPreferences();
  }
}
