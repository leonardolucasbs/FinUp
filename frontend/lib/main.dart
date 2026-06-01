import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import 'presentation/login/view/login_page.dart';
import 'presentation/signup/view/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinUp App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primaryOrange,
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: LoginPage(),
    );
  }
}