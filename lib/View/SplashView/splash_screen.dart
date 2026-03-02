import 'package:flutter/material.dart';
import '../../Core/Routes/app_routes.dart';
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

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
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
              Text('Live Lingola', style: AppTextStyles.splashTitle42),
            ],
          ),
        ),
      ),
    );
  }
}
