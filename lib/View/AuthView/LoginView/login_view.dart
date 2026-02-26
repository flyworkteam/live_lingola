import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../Core/Routes/app_routes.dart';
import '../../../Core/Theme/app_colors.dart';
import '../../../Core/Theme/app_text_styles.dart';

/// LoginView
/// - Sosyal giriş butonları (Google/Facebook/Apple)
/// - Continue as Guest
/// - Terms / Privacy / Cookies linkleri
///
/// Bu ekran Figma ölçülerine göre pixel-perfect kurgulanmıştır.
/// Özellikle social login butonlarında:
/// - İkonların X/Y konumu ve boyutu Figma’daki left/top/width/height değerleriyle eşleşir.
/// - Yazı kutularının genişlikleri (122/145/121) Figma’daki bounding box değerleriyle birebir uygulanır.
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
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      // Opsiyonel: Snackbar/Toast
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // -------------------------------------------------------------------
          // 1) Background Gradient
          // -------------------------------------------------------------------
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
            ),
          ),

          // -------------------------------------------------------------------
          // 2) Brand Logo Container
          // -------------------------------------------------------------------
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

          // -------------------------------------------------------------------
          // 3) App Title
          // -------------------------------------------------------------------
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

          // -------------------------------------------------------------------
          // 4) Headline
          // -------------------------------------------------------------------
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

          // -------------------------------------------------------------------
          // 5) Subtitle
          // -------------------------------------------------------------------
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

          // -------------------------------------------------------------------
          // 6) Social Login Buttons (Figma pixel-perfect)
          // Button ölçüsü: width=319 height=45, left=37
          // İçerikler: ikon + text kutuları figmadaki top/left değerleriyle konumlandırılır.
          // -------------------------------------------------------------------

          // Google Button
          Positioned(
            top: 389,
            left: 37,
            child: _LoginButton(
              label: "Continue with Gmail",
              provider: _AuthProvider.google,
              onTap: () => _goOnboarding(context),

              // --- Figma: TEXT box
              textBoxWidth: 122,
              textBoxHeight: 18,
              // Global left/top -> buton içi (buttonLeft=37, buttonTop=389)
              textLeft: 148 - 37, // 111
              textTop: 403.43 - 389, // 14.43

              // --- Figma: ICON
              iconWidth: 18.0,
              iconHeight: 18.642105102539062,
              iconLeft: 122 - 37, // 85
              iconTop: 402 - 389, // 13
            ),
          ),

          // Facebook Button
          Positioned(
            top: 453,
            left: 37,
            child: _LoginButton(
              label: "Continue with Facebook",
              provider: _AuthProvider.facebook,
              onTap: () => _goOnboarding(context),

              // --- Figma: TEXT box
              textBoxWidth: 145,
              textBoxHeight: 18,
              textLeft: 134 - 37, // 97
              textTop: 467.43 - 453, // 14.43

              // --- Figma: ICON
              iconWidth: 12.0,
              iconHeight: 21.81818199157715,
              iconLeft: 113 - 37, // 76
              iconTop: 464 - 453, // 11
            ),
          ),

          // Apple Button
          Positioned(
            top: 517,
            left: 37,
            child: _LoginButton(
              label: "Continue with Apple",
              provider: _AuthProvider.apple,
              onTap: () => _goOnboarding(context),

              // --- Figma: TEXT box
              textBoxWidth: 121,
              textBoxHeight: 18,
              textLeft: 149 - 37, // 112
              textTop: 531.43 - 517, // 14.43

              // --- Figma: ICON
              iconWidth: 18.0,
              iconHeight: 22.0,
              iconLeft: 122 - 37, // 85
              iconTop: 526 - 517, // 9
            ),
          ),

          // -------------------------------------------------------------------
          // 7) Guest Login
          // -------------------------------------------------------------------
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

          // -------------------------------------------------------------------
          // 8) Legal Links
          // -------------------------------------------------------------------
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

/// Desteklenen kimlik doğrulama sağlayıcıları
enum _AuthProvider { google, facebook, apple }

extension _AuthProviderAssets on _AuthProvider {
  /// SVG asset path'leri
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

  /// Erişilebilirlik etiketi
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

/// Social login button
///
/// Bu widget Figma pixel değerleri ile çalışır.
/// - İçerikler (ikon + yazı) butonun içine, figmadaki left/top değerleriyle "Positioned" olarak yerleşir.
class _LoginButton extends StatelessWidget {
  final String label;
  final _AuthProvider provider;
  final VoidCallback? onTap;

  // Figma: text bounding box
  final double textBoxWidth;
  final double textBoxHeight;
  final double textLeft;
  final double textTop;

  // Figma: icon box
  final double iconWidth;
  final double iconHeight;
  final double iconLeft;
  final double iconTop;

  const _LoginButton({
    required this.label,
    required this.provider,
    required this.onTap,
    required this.textBoxWidth,
    required this.textBoxHeight,
    required this.textLeft,
    required this.textTop,
    required this.iconWidth,
    required this.iconHeight,
    required this.iconLeft,
    required this.iconTop,
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

          // Stack: Figma'daki absolute konumları buton içinde birebir uygular.
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // --------------------------------------------------------------
              // Icon (Figma left/top/width/height)
              // --------------------------------------------------------------
              Positioned(
                left: iconLeft,
                top: iconTop,
                child: SizedBox(
                  width: iconWidth,
                  height: iconHeight,
                  child: SvgPicture.asset(
                    provider.assetPath,
                    width: iconWidth,
                    height: iconHeight,
                    fit: BoxFit.contain,
                    semanticsLabel: provider.semanticLabel,
                  ),
                ),
              ),

              // --------------------------------------------------------------
              // Text (Figma bounding box: width/height + left/top)
              // --------------------------------------------------------------
              Positioned(
                left: textLeft,
                top: textTop,
                child: SizedBox(
                  width: textBoxWidth,
                  height: textBoxHeight,
                  child: Center(
                    child: Text(
                      label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow
                          .clip, // Figma'da bounding box içinde kalır
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: AppTextStyles.fontFamily, // Poppins
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 1.0, // line-height: 100%
                        letterSpacing: 0.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
