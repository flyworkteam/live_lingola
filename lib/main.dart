import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'Core/Theme/app_theme.dart';
import 'Core/Routes/route_generator.dart';
import 'Core/Routes/app_routes.dart';
import 'View/SplashView/splash_screen.dart';

void main() {
  runApp(
    const ProviderScope(
      child: LingoraApp(),
    ),
  );
}

class LingoraApp extends StatelessWidget {
  const LingoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash, // 2sn duran ekranın route'u burada
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
      // ScreenUtilInit "child" ister; burada kalabilir. Route yine initialRoute ile açılır.
      child: const SplashView(),
    );
  }
}
