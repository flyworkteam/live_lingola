import 'package:flutter/material.dart';
import '../../Core/Routes/app_routes.dart';
import '../../Core/Theme/app_colors.dart';
import '../../Core/Theme/app_text_styles.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();

    // 1.5 - 2 saniye sonra onboarding'e geç
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
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
              Text('Live Lingola', style: AppTextStyles.splashTitle42),
            ],
          ),
        ),
      ),
    );
  }
}
