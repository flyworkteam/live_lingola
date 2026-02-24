import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Core/Routes/app_routes.dart';
import '../../../Core/Theme/app_colors.dart';
import '../../../Core/Theme/app_text_styles.dart';

/// Kullanıcı giriş işlemlerini, sosyal medya entegrasyonlarını
/// ve yasal dökümantasyon erişimlerini yöneten ana ekran.
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  static const String _termsUrl = 'https://fly-work.com/livelingola/terms/';
  static const String _privacyUrl =
      'https://fly-work.com/livelingola/privacy-policy/';
  static const String _cookiesUrl = 'https://fly-work.com/livelingola/cookies/';

  void _goOnboarding(BuildContext context) {
    Navigator.pushReplacementNamed(context, AppRoutes.onboardingFlow);
  }

  /// Harici tarayıcı üzerinden belirtilen URL bağlantısını açar.
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!ok) {}
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Arka plan gradyan katmanı
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
          ),

          // Logo ve marka ikonu alanı
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

          // Uygulama başlığı
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

          // Karşılama metni
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

          // Tanıtım alt metni
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

          // Sosyal medya giriş butonları
          Positioned(
            top: 389,
            left: 37,
            child: _LoginButton(
              label: "Continue with Gmail",
              provider: _AuthProvider.google,
              onTap: () => _goOnboarding(context),
            ),
          ),
          Positioned(
            top: 453,
            left: 37,
            child: _LoginButton(
              label: "Continue with Facebook",
              provider: _AuthProvider.facebook,
              onTap: () => _goOnboarding(context),
            ),
          ),
          Positioned(
            top: 517,
            left: 37,
            child: _LoginButton(
              label: "Continue with Apple",
              provider: _AuthProvider.apple,
              onTap: () => _goOnboarding(context),
            ),
          ),

          // Misafir girişi sekmesi
          Positioned(
            bottom: 80 + bottomPad,
            left: 0,
            right: 0,
            child: Center(
              child: TextButton(
                onPressed: () => _goOnboarding(context),
                child: const Text(
                  'Continue as Guest   →',
                  style: TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0A70FF),
                  ),
                ),
              ),
            ),
          ),

          // Yasal bilgilendirme ve yönlendirme linkleri
          Positioned(
            left: 52,
            bottom: 24 + bottomPad,
            child: SizedBox(
              width: 290,
              height: 60,
              child: Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontFamily: AppTextStyles.fontFamily,
                      fontSize: 10,
                      height: 1.2,
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
                          ..onTap = () {
                            _openUrl(_termsUrl);
                          },
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
                          ..onTap = () {
                            _openUrl(_privacyUrl);
                          },
                      ),
                      const TextSpan(text: ' and\n'),
                      TextSpan(
                        text: 'Cookies Policy',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _openUrl(_cookiesUrl);
                          },
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

/// Desteklenen kimlik doğrulama sağlayıcıları
enum _AuthProvider { google, facebook, apple }

extension _AuthProviderAssets on _AuthProvider {
  String get assetPath {
    switch (this) {
      case _AuthProvider.google:
        return 'assets/images/auth/google.png';
      case _AuthProvider.facebook:
        return 'assets/images/auth/facebook.png';
      case _AuthProvider.apple:
        return 'assets/images/auth/apple.png';
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

/// Standartlaştırılmış giriş butonu bileşeni
class _LoginButton extends StatelessWidget {
  final String label;
  final _AuthProvider provider;
  final VoidCallback? onTap;

  const _LoginButton({
    required this.label,
    required this.provider,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: onTap,
        child: Container(
          width: 319,
          height: 45,
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  provider.assetPath,
                  width: 18,
                  height: 18,
                  fit: BoxFit.contain,
                  semanticLabel: provider.semanticLabel,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.0,
                    letterSpacing: 0.0,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
