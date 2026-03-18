import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lingola_app/l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final message = e.toString().toLowerCase();

    if (message.contains('cancelled') ||
        message.contains('canceled') ||
        message.contains('aborted_by_user') ||
        message.contains('sign_in_canceled') ||
        message.contains('user cancelled')) {
      return l10n.signInCancelled;
    }

    if (provider == 'Apple') {
      return l10n.appleSignInFailed;
    }

    /* FACEBOOK ERROR HANDLING DISABLED
    if (provider == 'Facebook') {
      return l10n.facebookSignInFailed;
    }
    */

    if (provider == 'Google') {
      return l10n.googleSignInFailed;
    }

    return l10n.genericSignInFailed(provider);
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
    final l10n = AppLocalizations.of(context)!;

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
      _snack(l10n.userSyncFailed);
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

  /* FACEBOOK SIGN IN FUNCTION DISABLED
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
  */

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
              child: Align(
                alignment: Alignment.centerLeft,
                child: _AdaptiveText(
                  "Live Lingola",
                  maxLines: 1,
                  minFontSize: 14,
                  textAlign: TextAlign.left,
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
          ),
          Positioned(
            top: 207,
            left: 37,
            child: SizedBox(
              width: 220,
              height: 90,
              child: Align(
                alignment: Alignment.topLeft,
                child: _AdaptiveText(
                  l10n.loginTitle,
                  maxLines: 2,
                  minFontSize: 24,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    color: Colors.white,
                  ),
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
              child: Align(
                alignment: Alignment.topLeft,
                child: _AdaptiveText(
                  l10n.loginSubtitle,
                  maxLines: 5,
                  minFontSize: 12,
                  textAlign: TextAlign.left,
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
          ),
          Positioned(
            top: 389,
            left: 37,
            child: _LoginButtonAligned(
              label: authState.isLoading
                  ? l10n.signingIn
                  : l10n.continueWithGoogle,
              provider: _AuthProvider.google,
              onTap: authState.isLoading ? null : _signInWithGoogle,
              iconSize: const Size(18, 18.64),
            ),
          ),
          /* FACEBOOK BUTTON POSITIONED DISABLED
          Positioned(
            top: 453,
            left: 37,
            child: _LoginButtonAligned(
              label: authState.isLoading
                  ? l10n.signingIn
                  : l10n.continueWithFacebook,
              provider: _AuthProvider.facebook,
              onTap: authState.isLoading ? null : _signInWithFacebook,
              iconSize: const Size(12, 21.81),
            ),
          ),
          */
          Positioned(
            top: 517,
            left: 37,
            child: _LoginButtonAligned(
              label:
                  authState.isLoading ? l10n.signingIn : l10n.continueWithApple,
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
                        child: const SizedBox(
                          height: 20,
                          child: _AdaptiveText(
                            '',
                            maxLines: 1,
                            minFontSize: 11,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      ShaderMask(
                        shaderCallback: (b) =>
                            _guestTextGradient.createShader(b),
                        child: SizedBox(
                          height: 20,
                          child: _AdaptiveText(
                            l10n.continueAsGuest,
                            maxLines: 1,
                            minFontSize: 11,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.fontFamily,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.0,
                              color: Colors.white,
                            ),
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
                child: _AdaptiveRichText(
                  maxLines: 4,
                  minFontSize: 8,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: AppTextStyles.fontFamily,
                    fontSize: 10,
                    height: 1.5,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                  children: [
                    TextSpan(
                      text: l10n.loginLegalPrefix,
                    ),
                    TextSpan(
                      text: l10n.termsOfServiceLinkText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _openUrl(_termsUrl),
                    ),
                    const TextSpan(text: '\n'),
                    TextSpan(
                      text: l10n.loginLegalMiddle,
                    ),
                    TextSpan(
                      text: l10n.privacyPolicyLinkText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => _openUrl(_privacyUrl),
                    ),
                    TextSpan(text: l10n.loginLegalAnd),
                    TextSpan(
                      text: l10n.cookiesPolicyLinkText,
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
        ],
      ),
    );
  }
}

enum _AuthProvider { google, /* facebook, */ apple }

extension _AuthProviderAssets on _AuthProvider {
  String get assetPath {
    switch (this) {
      case _AuthProvider.google:
        return 'assets/images/auth/google.svg';
      /* case _AuthProvider.facebook:
        return 'assets/images/auth/facebook.svg'; */
      case _AuthProvider.apple:
        return 'assets/images/auth/apple.svg';
    }
  }

  String get semanticLabel {
    switch (this) {
      case _AuthProvider.google:
        return 'Google';
      /* case _AuthProvider.facebook:
        return 'Facebook'; */
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
                      height: buttonH,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _AdaptiveText(
                          label,
                          maxLines: 1,
                          minFontSize: 9,
                          textAlign: TextAlign.left,
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

class _AdaptiveText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int maxLines;
  final double minFontSize;
  final TextAlign textAlign;

  const _AdaptiveText(
    this.text, {
    required this.style,
    required this.maxLines,
    required this.minFontSize,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fittedStyle = _bestFitStyle(
          context: context,
          text: text,
          baseStyle: style,
          maxLines: maxLines,
          minFontSize: minFontSize,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
          textAlign: textAlign,
        );

        return Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.clip,
          softWrap: true,
          textAlign: textAlign,
          style: fittedStyle,
        );
      },
    );
  }
}

class _AdaptiveRichText extends StatelessWidget {
  final List<InlineSpan> children;
  final TextStyle style;
  final int maxLines;
  final double minFontSize;
  final TextAlign textAlign;

  const _AdaptiveRichText({
    required this.children,
    required this.style,
    required this.maxLines,
    required this.minFontSize,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final fittedStyle = _bestFitStyleForSpans(
          context: context,
          children: children,
          baseStyle: style,
          maxLines: maxLines,
          minFontSize: minFontSize,
          maxWidth: constraints.maxWidth,
          maxHeight: constraints.maxHeight,
          textAlign: textAlign,
        );

        List<InlineSpan> scaledChildren(List<InlineSpan> spans) {
          return spans.map((span) {
            if (span is TextSpan) {
              final childStyle = span.style == null
                  ? fittedStyle
                  : fittedStyle.merge(span.style);
              return TextSpan(
                text: span.text,
                style: childStyle,
                recognizer: span.recognizer,
                mouseCursor: span.mouseCursor,
                onEnter: span.onEnter,
                onExit: span.onExit,
                locale: span.locale,
                semanticsLabel: span.semanticsLabel,
                spellOut: span.spellOut,
                children: span.children == null
                    ? null
                    : scaledChildren(span.children!),
              );
            }
            return span;
          }).toList();
        }

        return RichText(
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: TextOverflow.clip,
          text: TextSpan(
            style: fittedStyle,
            children: scaledChildren(children),
          ),
        );
      },
    );
  }
}

TextStyle _bestFitStyle({
  required BuildContext context,
  required String text,
  required TextStyle baseStyle,
  required int maxLines,
  required double minFontSize,
  required double maxWidth,
  required double maxHeight,
  required TextAlign textAlign,
}) {
  final baseSize = baseStyle.fontSize ?? 14;
  double low = minFontSize;
  double high = baseSize;
  double best = minFontSize;

  bool fits(double size) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: baseStyle.copyWith(fontSize: size),
      ),
      textDirection: Directionality.of(context),
      textAlign: textAlign,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    return !painter.didExceedMaxLines && painter.height <= maxHeight;
  }

  if (fits(high)) {
    return baseStyle;
  }

  for (int i = 0; i < 18; i++) {
    final mid = (low + high) / 2;
    if (fits(mid)) {
      best = mid;
      low = mid;
    } else {
      high = mid;
    }
  }

  return baseStyle.copyWith(fontSize: best);
}

TextStyle _bestFitStyleForSpans({
  required BuildContext context,
  required List<InlineSpan> children,
  required TextStyle baseStyle,
  required int maxLines,
  required double minFontSize,
  required double maxWidth,
  required double maxHeight,
  required TextAlign textAlign,
}) {
  final baseSize = baseStyle.fontSize ?? 14;
  double low = minFontSize;
  double high = baseSize;
  double best = minFontSize;

  List<InlineSpan> scaledChildren(double size, List<InlineSpan> spans) {
    return spans.map((span) {
      if (span is TextSpan) {
        final merged =
            (span.style == null ? baseStyle : baseStyle.merge(span.style))
                .copyWith(fontSize: size);
        return TextSpan(
          text: span.text,
          style: merged,
          recognizer: span.recognizer,
          mouseCursor: span.mouseCursor,
          onEnter: span.onEnter,
          onExit: span.onExit,
          locale: span.locale,
          semanticsLabel: span.semanticsLabel,
          spellOut: span.spellOut,
          children: span.children == null
              ? null
              : scaledChildren(size, span.children!),
        );
      }
      return span;
    }).toList();
  }

  bool fits(double size) {
    final painter = TextPainter(
      text: TextSpan(
        style: baseStyle.copyWith(fontSize: size),
        children: scaledChildren(size, children),
      ),
      textDirection: Directionality.of(context),
      textAlign: textAlign,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth);

    return !painter.didExceedMaxLines && painter.height <= maxHeight;
  }

  if (fits(high)) {
    return baseStyle;
  }

  for (int i = 0; i < 18; i++) {
    final mid = (low + high) / 2;
    if (fits(mid)) {
      best = mid;
      low = mid;
    } else {
      high = mid;
    }
  }

  return baseStyle.copyWith(fontSize: best);
}
