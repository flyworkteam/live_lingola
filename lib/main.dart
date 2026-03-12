import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'firebase_options.dart';
import 'Core/Theme/app_theme.dart';
import 'Core/Routes/route_generator.dart';
import 'Core/Routes/app_routes.dart';
import 'Riverpod/Providers/app_locale_provider.dart';
import 'Services/notification_service.dart';
import 'Services/revenuecat_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, s) {
    debugPrint('Firebase initialize error: $e');
    debugPrintStack(stackTrace: s);
  }

  try {
    await RevenueCatService.init();
    debugPrint('REVENUECAT INIT OK');
  } catch (e, s) {
    debugPrint('REVENUECAT INIT ERROR: $e');
    debugPrintStack(stackTrace: s);
  }

  runApp(
    const ProviderScope(
      child: LingoraApp(),
    ),
  );
}

class LingoraApp extends ConsumerStatefulWidget {
  const LingoraApp({super.key});

  @override
  ConsumerState<LingoraApp> createState() => _LingoraAppState();
}

class _LingoraAppState extends ConsumerState<LingoraApp> {
  bool _notificationInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_notificationInitialized) {
      _notificationInitialized = true;
      NotificationService.init(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(appLocaleProvider);

    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
