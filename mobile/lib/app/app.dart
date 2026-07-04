import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:mobile/app/routes.dart';
import 'package:mobile/app/app_theme.dart';

import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/theme_provider.dart';

class HRMSApp extends StatelessWidget {
  const HRMSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [

        /// Authentication
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        /// Theme
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),

      ],

      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {

          return MaterialApp(

            debugShowCheckedModeBanner: false,

            title: 'HRMS',

            theme: AppTheme.lightTheme,

            darkTheme: AppTheme.darkTheme,

            themeMode: themeProvider.themeMode,

            initialRoute: AppRoutes.splash,

            onGenerateRoute: AppRoutes.generateRoute,

          );

        },
      ),
    );
  }
}