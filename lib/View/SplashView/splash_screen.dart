import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Core/Routes/app_routes.dart';
import '../../Core/Theme/app_text_styles.dart';
import '../../Riverpod/Providers/current_user_provider.dart';
import '../../Riverpod/Providers/language_provider.dart';
import '../../Services/backend_auth_service.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _clearStoredUiAndSessionData({String? firebaseUid}) async {
    try {
      ref.read(currentUserProvider.notifier).state = null;
      debugPrint('SPLASH -> CURRENT USER PROVIDER CLEARED');
    } catch (e) {
      debugPrint('SPLASH CURRENT USER CLEAR ERROR: $e');
    }

    try {
      await ref
          .read(translationSourceLanguageProvider.notifier)
          .resetSourceLanguage();
      debugPrint('SPLASH -> SOURCE LANGUAGE RESET');
    } catch (e) {
      debugPrint('SPLASH SOURCE LANGUAGE RESET ERROR: $e');
    }

    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove('selected_translation_source_language_code');

      if (firebaseUid != null && firebaseUid.isNotEmpty) {
        await prefs.remove('app_locale_code_$firebaseUid');
      }

      await prefs.remove('selected_language_code');
      await prefs.remove('app_locale_code');
      await prefs.remove('is_guest_mode');
      await prefs.remove('guest_session_active');
      await prefs.remove('guest_user_id');
      await prefs.remove('onboarding_completed');

      await prefs.remove('guest_selected_language');
      await prefs.remove('guest_selected_level');
      await prefs.remove('guest_selected_translation_source_language_code');
      await prefs.remove('guest_app_locale_code');

      debugPrint('SPLASH -> SHARED PREFERENCES SESSION/UI DATA CLEARED');
    } catch (e) {
      debugPrint('SPLASH PREF CLEAR ERROR: $e');
    }

    try {
      await OneSignal.logout();
      debugPrint('SPLASH -> ONESIGNAL LOGOUT OK');
    } catch (e) {
      debugPrint('SPLASH ONESIGNAL LOGOUT ERROR: $e');
    }
  }

  Future<void> _goLoginAfterFullCleanup({String? firebaseUid}) async {
    await _clearStoredUiAndSessionData(firebaseUid: firebaseUid);

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  Future<void> _goGuestHome() async {
    ref.read(currentUserProvider.notifier).state = {
      'id': 'guest',
      'name': 'Guest',
      'email': '',
      'photo_url': '',
      'is_guest': true,
    };

    if (!mounted) return;

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.homeAndNotifications,
    );
  }

  Future<void> _bootstrap() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final isGuestMode = prefs.getBool('is_guest_mode') ?? false;
    final guestSessionActive = prefs.getBool('guest_session_active') ?? false;

    final firebaseUser = FirebaseAuth.instance.currentUser;

    debugPrint('SPLASH GUEST MODE: $isGuestMode');
    debugPrint('SPLASH GUEST SESSION ACTIVE: $guestSessionActive');
    debugPrint('SPLASH FIREBASE USER: ${firebaseUser?.uid}');
    debugPrint('SPLASH FIREBASE EMAIL: ${firebaseUser?.email}');
    debugPrint('SPLASH FIREBASE DISPLAY NAME: ${firebaseUser?.displayName}');
    debugPrint('SPLASH FIREBASE PHOTO URL: ${firebaseUser?.photoURL}');

    if (!mounted) return;

    if (isGuestMode || guestSessionActive) {
      debugPrint(
        'SPLASH -> GUEST SESSION FOUND -> GO HOME',
      );
      await _goGuestHome();
      return;
    }

    if (firebaseUser == null) {
      debugPrint('SPLASH -> NO ACTIVE SESSION -> CLEAR EVERYTHING -> GO LOGIN');
      await _goLoginAfterFullCleanup();
      return;
    }

    try {
      debugPrint('SPLASH -> ACTIVE SESSION FOUND -> SYNC USER');

      final user = await BackendAuthService.syncMe();
      debugPrint('SPLASH SYNCED USER RAW: $user');

      if (user == null) {
        debugPrint(
            'SPLASH -> SYNC USER IS NULL -> CLEAR EVERYTHING -> GO LOGIN');
        await _goLoginAfterFullCleanup(firebaseUid: firebaseUser.uid);
        return;
      }

      final userMap = Map<String, dynamic>.from(user as Map);

      debugPrint('SPLASH USER ID: ${userMap['id']}');
      debugPrint('SPLASH USER FIREBASE UID: ${userMap['firebase_uid']}');
      debugPrint('SPLASH USER NAME: ${userMap['name']}');
      debugPrint('SPLASH USER EMAIL: ${userMap['email']}');
      debugPrint('SPLASH USER PHOTO URL: ${userMap['photo_url']}');
      debugPrint('SPLASH USER AGE: ${userMap['age']}');
      debugPrint('SPLASH USER UPDATED AT: ${userMap['updated_at']}');

      ref.read(currentUserProvider.notifier).state = userMap;
      debugPrint('SPLASH -> CURRENT USER PROVIDER FILLED');

      try {
        await OneSignal.login('user_${userMap['id']}');
        debugPrint("ONESIGNAL LOGIN OK: user_${userMap['id']}");
      } catch (e) {
        debugPrint("ONESIGNAL LOGIN ERROR: $e");
      }

      if (!mounted) return;

      debugPrint('SPLASH -> GO HOME');
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.homeAndNotifications,
      );
    } catch (e, st) {
      debugPrint('SPLASH SYNC ERROR: $e');
      debugPrintStack(stackTrace: st);

      await _goLoginAfterFullCleanup(firebaseUid: firebaseUser.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Alignment begin = Alignment(0.198, -0.980);
    const Alignment end = Alignment(-0.198, 0.980);

    const gradient = LinearGradient(
      begin: begin,
      end: end,
      colors: [
        Color(0xFF0A70FF),
        Color(0xFF03B7FF),
        Color.fromRGBO(239, 242, 249, 0.721154),
        Color.fromRGBO(239, 242, 249, 0.0),
      ],
      stops: [0.0043, 0.2741, 0.5750, 0.9957],
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: gradient),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo/live_lingola_logo.png',
                width: 168,
                height: 168,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              Text(
                'Live Lingola',
                style: AppTextStyles.splashTitle42,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
