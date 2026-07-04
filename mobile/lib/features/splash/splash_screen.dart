import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/app/route_names.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {

    await Future.delayed(const Duration(seconds: 5));

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('access_token');
    final role = prefs.getString('role');

    if (!mounted) return;

    // User not logged in
    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.login,
      );
      return;
    }

    // Logged in
    if (role == 'admin') {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.adminDashboard,
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        RouteNames.employeeDashboard,
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.white,

      body: Stack(

        fit: StackFit.expand,

        children: [

          /// Splash Image
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),

          /// Loader
          const Positioned(
            left: 0,
            right: 0,
            bottom: 120,
            child: Center(
              child: SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}