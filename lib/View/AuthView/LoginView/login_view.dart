import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Routes/app_routes.dart';
import '../../../Core/Theme/app_colors.dart';
import '../../../Core/Theme/app_text_styles.dart';
import '../../../Core/Utils/assets.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

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

  void _goOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {}
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.black.withOpacity(0.85),
                ),
              ),
            ),
          ),
          Positioned(
            top: 389,
            left: 37,
            child: _LoginButtonAligned(
              label: "Continue with Gmail",
              provider: _AuthProvider.google,
              onTap: () => _goOnboarding(context),
              iconSize: const Size(18, 18.64),
            ),
          ),
          Positioned(
            top: 453,
            left: 37,
            child: _LoginButtonAligned(
              label: "Continue with Facebook",
              provider: _AuthProvider.facebook,
              onTap: () => _goOnboarding(context),
              iconSize: const Size(12, 21.81),
            ),
          ),
          Positioned(
            top: 517,
            left: 37,
            child: _LoginButtonAligned(
              label: "Continue with Apple",
              provider: _AuthProvider.apple,
              onTap: () => _goOnboarding(context),
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
                onTap: () => _goOnboarding(context),
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
    );
  }
}
