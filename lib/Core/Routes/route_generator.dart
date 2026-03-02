import 'package:flutter/material.dart';

import 'app_routes.dart';

import '../../View/SplashView/splash_screen.dart';
import '../../View/OnboardingView/onboarding_view.dart';
import '../../View/AuthView/LoginView/login_view.dart';

import '../../View/OnboardingView/onboarding_flow_slider.dart';

import '../../View/HomeView/home_and_notifications_view.dart';

import '../../View/ProfileView/profile_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());

      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());

      case AppRoutes.onboardingFlow:
        return MaterialPageRoute(builder: (_) => const OnboardingFlowSlider());

      case AppRoutes.homeAndNotifications:
        return MaterialPageRoute(
          builder: (_) => const HomeAndNotificationsView(),
        );

      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileView());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'Route not found: ${settings.name}',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ),
        );
    }
  }
}
