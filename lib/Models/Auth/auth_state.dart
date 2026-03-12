import 'app_user_model.dart';

class AuthState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;
  final AppUserModel? user;

  const AuthState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
    AppUserModel? user,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      user: clearUser ? null : (user ?? this.user),
    );
  }
}
