import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:mobile/app/route_names.dart';

import '../../core/storage/auth_storage.dart';
import '../auth/services/auth_service.dart';

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
    await Future.delayed(const Duration(seconds: 2));

    final token = await AuthStorage.getToken();

    if (!mounted) return;

    if (token == null || token.isEmpty) {
      _goToLogin();

      return;
    }

    try {
      final response = await AuthService.getProfile();

      final user = response['user'];

      if (user is! Map) {
        await AuthStorage.clear();

        if (!mounted) return;

        _goToLogin();

        return;
      }

      final userMap = Map<String, dynamic>.from(user);

      final role = userMap['role']?.toString();

      final userId = int.tryParse(userMap['id']?.toString() ?? '');

      if (role == null || userId == null) {
        await AuthStorage.clear();

        if (!mounted) return;

        _goToLogin();

        return;
      }

      await AuthStorage.saveAuth(token: token, role: role, userId: userId);

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacementNamed(context, RouteNames.adminDashboard);

        return;
      }

      if (role == 'employee') {
        Navigator.pushReplacementNamed(context, RouteNames.employeeDashboard);

        return;
      }

      await AuthStorage.clear();

      if (!mounted) return;

      _goToLogin();
    } on DioException {
      await AuthStorage.clear();

      if (!mounted) return;

      _goToLogin();
    } catch (_) {
      await AuthStorage.clear();

      if (!mounted) return;

      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/splash.png', fit: BoxFit.cover),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 120,
            child: Center(
              child: SizedBox(
                height: 28,
                width: 28,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
