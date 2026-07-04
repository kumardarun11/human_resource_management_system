import 'package:flutter/material.dart';

import 'package:mobile/app/route_names.dart';

import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/splash/splash_screen.dart';


class AppRoutes {
  AppRoutes._();

  static const String splash = RouteNames.splash;

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

    // =========================
    // Splash
    // =========================
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

    // =========================
    // Register
    // =========================
      case RouteNames.register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

    // =========================
    // Login
    // =========================
      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

    /*// =========================
    // Onboarding
    // =========================
      case RouteNames.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );





    // =========================
    // OTP Verification
    // =========================
      case RouteNames.otpVerification:
        return MaterialPageRoute(
          builder: (_) => const OtpVerificationScreen(),
        );*/

    // =========================
    // Default
    // =========================
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
            ),
            body: const Center(
              child: Text(
                '404\nPage Not Found',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
    }
  }
}
