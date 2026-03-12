import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Routes/app_routes.dart';
import '../../../Core/Theme/app_colors.dart';
import '../../../Core/Theme/app_text_styles.dart';
import '../../../Core/Utils/assets.dart';
import '../../../Riverpod/Providers/all_auth_providers.dart';
import '../../../Riverpod/Providers/current_user_provider.dart';
import '../../../Services/backend_auth_service.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  static const Alignment _gradBegin = Alignment(0.198, -0.980);
  static const Alignment _gradEnd = Alignment(-0.198, 0.980);

  static const LinearGradient _figmaGradient = LinearGradient(
    begin: _gradBegin,
    end: _gradEnd,
    colors: [
      Color(0xFF0A70FF),
      Color(0xFF03B7FF),
      Color.fromRGBO(239, 242, 249, 0.721154),
      Color.fromRGBO(239, 242, 249, 0.0),
    ],
    stops: [0.0043, 0.2741, 0.5750, 0.9957],
  );

  static const LinearGradient _guestTextGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF03B7FF), Color(0xFF0A70FF)],
  );

  static const String _termsUrl = 'https://fly-work.com/livelingola/terms/';
  static const String _privacyUrl =
      'https://fly-work.com/livelingola/privacy-policy/';
  static const String _cookiesUrl = 'https://fly-work.com/livelingola/cookies/';

  void _goOnboarding() {
    Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
  }

  void _goHome() {
    Navigator.pushReplacementNamed(context, AppRoutes.homeAndNotifications);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _snack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  String _readableError(Object e, {required String provider}) {
    final message = e.toString().toLowerCase();

    if (message.contains('cancelled') ||
        message.contains('canceled') ||
        message.contains('aborted_by_user') ||
        message.contains('sign_in_canceled') ||
        message.contains('user cancelled')) {
      return '$provider sign-in cancelled.';
    }

    if (provider == 'Apple') {
      return 'Apple sign-in failed. Please check Apple setup in Firebase, Xcode capabilities and Apple Developer account.';
    }

    if (provider == 'Facebook') {
      return 'Facebook sign-in failed. Please check Meta app status and Firebase Facebook settings.';
    }

    if (provider == 'Google') {
      return 'Google sign-in failed. Please check Firebase and Google sign-in configuration.';
    }

    return '$provider sign-in failed.';
  }

  bool _isOnboardingCompleted(Map<String, dynamic> user) {
    final usagePurpose = user['usage_purpose']?.toString().trim() ?? '';
    final fromLanguage = user['from_language']?.toString().trim() ?? '';
    final toLanguage = user['to_language']?.toString().trim() ?? '';
    final desiredFeature = user['desired_feature']?.toString().trim() ?? '';
    final usedAiBefore = user['used_ai_before'];

    final hasUsedAiBefore = usedAiBefore != null &&
        usedAiBefore.toString().trim().isNotEmpty &&
        usedAiBefore.toString().trim() != 'null';

    return usagePurpose.isNotEmpty &&
        fromLanguage.isNotEmpty &&
        toLanguage.isNotEmpty &&
        desiredFeature.isNotEmpty &&
        hasUsedAiBefore;
  }

  Future<void> _handlePostLogin() async {
    try {
      debugPrint('AUTH SUCCESS -> SYNC USER');

      final user = await BackendAuthService.syncMe();
      debugPrint('SYNCED USER: $user');

      final userMap = user as Map<String, dynamic>;
      ref.read(currentUserProvider.notifier).state = userMap;
      debugPrint('CURRENT USER PROVIDER FILLED');

      if (!mounted) return;

      final onboardingCompleted = _isOnboardingCompleted(userMap);
      debugPrint('ONBOARDING COMPLETED: $onboardingCompleted');

      if (onboardingCompleted) {
        debugPrint('AUTH SUCCESS -> GO HOME');
        _goHome();
      } else {
        debugPrint('AUTH SUCCESS -> GO ONBOARDING');
        _goOnboarding();
      }

      ref.read(authControllerProvider.notifier).clearStatus();
    } catch (e, st) {
      debugPrint('SYNC USER ERROR: $e');
      debugPrintStack(stackTrace: st);

      if (!mounted) return;
      _snack('User sync failed.');
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      debugPrint('GOOGLE SIGN IN STARTED');
      await ref.read(authControllerProvider.notifier).signInWithGoogle();
      debugPrint('GOOGLE SIGN IN REQUEST SENT');
    } catch (e, st) {
      debugPrint('GOOGLE SIGN IN ERROR: $e');
      debugPrintStack(stackTrace: st);
      _snack(_readableError(e, provider: 'Google'));
    }
  }

  Future<void> _signInWithApple() async {
    try {
      debugPrint('APPLE SIGN IN STARTED');
      await ref.read(authControllerProvider.notifier).signInWithApple();
      debugPrint('APPLE SIGN IN REQUEST SENT');
    } catch (e, st) {
      debugPrint('APPLE SIGN IN ERROR: $e');
      debugPrintStack(stackTrace: st);
      _snack(_readableError(e, provider: 'Apple'));
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      debugPrint('FACEBOOK SIGN IN STARTED');
      await ref.read(authControllerProvider.notifier).signInWithFacebook();
      debugPrint('FACEBOOK SIGN IN REQUEST SENT');
    } catch (e, st) {
      debugPrint('FACEBOOK SIGN IN ERROR: $e');
      debugPrintStack(stackTrace: st);
      _snack(_readableError(e, provider: 'Facebook'));
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      final oldError = previous?.errorMessage;
      final newError = next.errorMessage;

      if (newError != null && newError != oldError) {
        debugPrint('AUTH STATE ERROR: $newError');
        _snack(newError);
      }

      if (next.isSuccess && previous?.isSuccess != true) {
        Future.microtask(_handlePostLogin);
      }
    });

    final authState = ref.watch(authControllerProvider);
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(gradient: _figmaGradient),
            ),
          ),
          Positioned(
            top: 125,
            left: 38,
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo/live_lingola_logo.png',
                width: 43,
                height: 43,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Positioned(
            top: 130,
            left: 96,
            child: SizedBox(
              width: 140,
              height: 36,
              child: Text(
                "Live Lingola",
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Positioned(
            top: 207,
            left: 37,
            child: SizedBox(
              width: 220,
              height: 90,
              child: Text(
                "Let’s Get\nStarted",
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 1.05,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            top: 289,
            left: 38,
            child: SizedBox(
              width: 281,
              height: 114,
              child: Text(
                'Experience seamless communication with our AI-powered translation engine.',
                style: TextStyle(
                  fontFamily: AppTextStyles.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.0,
                  color: Colors.black.withValues(alpha: 0.85),
                ),
              ),
            ),
          ),
          Positioned(
            top: 389,
            left: 37,
            child: _LoginButtonAligned(
              label:
                  authState.isLoading ? "Signing in..." : "Continue with Gmail",
              provider: _AuthProvider.google,
              onTap: authState.isLoading ? null : _signInWithGoogle,
              iconSize: const Size(18, 18.64),
            ),
          ),
          Positioned(
            top: 453,
            left: 37,
            child: _LoginButtonAligned(
              label: authState.isLoading
                  ? "Signing in..."
                  : "Continue with Facebook",
              provider: _AuthProvider.facebook,
              onTap: authState.isLoading ? null : _signInWithFacebook,
              iconSize: const Size(12, 21.81),
            ),
          ),
          Positioned(
            top: 517,
            left: 37,
            child: _LoginButtonAligned(
              label:
                  authState.isLoading ? "Signing in..." : "Continue with Apple",
              provider: _AuthProvider.apple,
              onTap: authState.isLoading ? null : _signInWithApple,
              iconSize: const Size(18, 22),
            ),
          ),
          Positioned(
            bottom: 80 + bottomPad,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: authState.isLoading ? null : _goOnboarding,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShaderMask(
                        shaderCallback: (b) =>
                            _guestTextGradient.createShader(b),
                        child: const Text(
                          'Continue as Guest',
                          style: TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SvgPicture.asset(
                        AppAssets.navOkRight,
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 52,
            bottom: 24 + bottomPad,
            child: SizedBox(
              width: 295,
              height: 60,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10,
                      height: 1.5,
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      const TextSpan(
                        text: 'By signing up for swipe, you agree to our ',
                      ),
                      TextSpan(
                        text: 'Terms of Service.',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_termsUrl),
                      ),
                      const TextSpan(text: '\n'),
                      const TextSpan(
                        text: 'Learn how we process your data in our ',
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_privacyUrl),
                      ),
                      const TextSpan(text: ' and\n'),
                      TextSpan(
                        text: 'Cookies Policy',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _openUrl(_cookiesUrl),
                      ),
                      const TextSpan(text: '.'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _AuthProvider { google, facebook, apple }

extension _AuthProviderAssets on _AuthProvider {
  String get assetPath {
    switch (this) {
      case _AuthProvider.google:
        return 'assets/images/auth/google.svg';
      case _AuthProvider.facebook:
        return 'assets/images/auth/facebook.svg';
      case _AuthProvider.apple:
        return 'assets/images/auth/apple.svg';
    }
  }

  String get semanticLabel {
    switch (this) {
      case _AuthProvider.google:
        return 'Google';
      case _AuthProvider.facebook:
        return 'Facebook';
      case _AuthProvider.apple:
        return 'Apple';
    }
  }
}

class _LoginButtonAligned extends StatelessWidget {
  final String label;
  final _AuthProvider provider;
  final VoidCallback? onTap;
  final Size iconSize;

  const _LoginButtonAligned({
    required this.label,
    required this.provider,
    required this.onTap,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    const double buttonW = 319;
    const double buttonH = 45;

    const double iconSlotW = 44;
    const double gap = 14;
    const double textW = 190;
    const double contentW = iconSlotW + gap + textW;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.65 : 1,
          child: Container(
            width: buttonW,
            height: buttonH,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFDEE5F7),
                  offset: Offset(0, 4),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: SizedBox(
                width: contentW,
                height: buttonH,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: iconSlotW,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: iconSize.width,
                          height: iconSize.height,
                          child: SvgPicture.asset(
                            provider.assetPath,
                            fit: BoxFit.contain,
                            semanticsLabel: provider.semanticLabel,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: gap),
                    SizedBox(
                      width: textW,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          label,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.clip,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.0,
                            letterSpacing: 0.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
